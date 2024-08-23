import os
import time
import math
import psutil
import ctypes
import logging
import keyboard
import threading
import subprocess
import pandas as pd
import tkinter as tk
import pyautogui as pag
import pygetwindow as gw
from datetime import datetime
from tkinter import simpledialog, filedialog
from pynput import keyboard as pynput_keyboard

# Configure logging
def setup_logging():
    home_dir = os.path.expanduser("~")
    log_dir = os.path.join(home_dir, "SalesInfoUpdater")
    os.makedirs(log_dir, exist_ok=True)
    log_file = os.path.join(log_dir, "SalesInfoUpdater.log")
    logging.basicConfig(filename=log_file, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

console_handler = logging.StreamHandler()
console_handler.setLevel(logging.DEBUG)
console_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
logging.getLogger().addHandler(console_handler)

PROVAL_PATH = "C:/Program Files (x86)/Thomson Reuters/ProVal/ProVal.exe"
halt_event = threading.Event()
block_input = False
initial_caps_lock_state = ctypes.windll.user32.GetKeyState(0x14) & 1

def log_time(message):
    """Log the current time with a custom message for performance monitoring."""
    logging.info(f"{message} at {time.strftime('%Y-%m-%d %H:%M:%S')}")

def get_proval_pid():
    """Get the PID of the ProVal process, or start it if not running."""
    log_time("Checking for ProVal process")
    for proc in psutil.process_iter(['pid', 'name', 'exe']):
        try:
            if proc.info['exe'] and os.path.normpath(proc.info['exe']) == os.path.normpath(PROVAL_PATH):
                return proc.info['pid']
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass

    # ProVal is not running, attempt to start it
    logging.info("ProVal process not found, attempting to start it.")
    try:
        subprocess.Popen(PROVAL_PATH)
        logging.info("ProVal started successfully.")
        # Wait for ProVal to start
        while True:
            for proc in psutil.process_iter(['pid', 'name', 'exe']):
                try:
                    if proc.info['exe'] and os.path.normpath(proc.info['exe']) == os.path.normpath(PROVAL_PATH):
                        return proc.info['pid']
                except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
                    pass
    except Exception as e:
        logging.error(f"Error starting ProVal: {e}")
        return None

def focus_proval_window(window_title):
    """Focus a specific ProVal window by its title."""
    log_time(f"Attempting to focus ProVal window with title '{window_title}'")
    try:
        proval_pid = get_proval_pid()
        if not proval_pid:
            logging.debug("ProVal process not found.")
            return False

        proval_window = gw.getWindowsWithTitle(window_title)[0]
        if proval_window:
            proval_window.activate()
            logging.debug(f"ProVal window '{window_title}' is confirmed as active.")
            return True
        else:
            logging.debug(f"ProVal window '{window_title}' not found.")
            return False
    except Exception as e:
        logging.error(f"Error focusing ProVal window: {e}")
        return False

def get_loop_count():
    """Get the loop count using a Tkinter GUI."""
    log_time("Prompting for loop count")
    global block_input
    block_input = True
    root = tk.Tk()
    root.withdraw()
    loop_count = simpledialog.askinteger("Loop Count", "Enter Loop Count:")
    root.destroy()
    block_input = False
    return loop_count

def get_line_of_sale():
    """Get the line of sale selection using Tkinter GUI."""
    log_time("Prompting for line of sale")
    global block_input
    block_input = True
    root = tk.Tk()
    root.withdraw()
    line_of_sale = simpledialog.askinteger("Line of Sale", "Select Line of Sale (1-4):", minvalue=1, maxvalue=4)
    root.destroy()
    block_input = False
    return line_of_sale

def select_file(title, filetypes):
    """Open a file dialog to select a file."""
    root = tk.Tk()
    root.withdraw()
    file_path = filedialog.askopenfilename(title=title, filetypes=filetypes)
    root.destroy()
    return file_path

def save_file(title, filetypes):
    """Open a file dialog to specify a save location."""
    root = tk.Tk()
    root.withdraw()
    file_path = filedialog.asksaveasfilename(title=title, filetypes=filetypes)
    root.destroy()
    return file_path

def monitor_hotkeys():
    """Monitor for the halt and skip hotkeys to stop or skip the script."""
    def on_halt():
        logging.info("Halt hotkey pressed.")
        halt_event.set()

    keyboard.add_hotkey('ctrl+shift+h', on_halt)
    while not halt_event.is_set():
        pass
    logging.info("Script halted by user.")
    os._exit(1)

def block_keyboard_input(key):
    """Block keyboard input except for the halt hotkey and input prompts."""
    global block_input
    if block_input:
        return key == pynput_keyboard.Key.esc
    else:
        return key == pynput_keyboard.Key.ctrl_r and key == pynput_keyboard.Key.shift_r and key.char == 'h'

def block_mouse_input(x, y):
    """Block mouse input except during input prompts."""
    global block_input
    if block_input:
        return True
    else:
        return False

def toggle_caps_lock(state):
    """Toggle Caps Lock to the specified state (True for ON, False for OFF)."""
    current_state = ctypes.windll.user32.GetKeyState(0x14) & 1
    if current_state != state:
        ctypes.windll.user32.keybd_event(0x14, 0, 0, 0)  # Press Caps Lock key
        ctypes.windll.user32.keybd_event(0x14, 0, 0x0002, 0)  # Release Caps Lock key

def main_script():
    global initial_caps_lock_state, block_input

    # Set Caps Lock to off for consistent data entry
    toggle_caps_lock(False)

    # Prompt the user to select the input Excel file
    excel_path = select_file("Select Input Excel File", [("Excel files", "*.xlsx *.xls")])
    if not excel_path:
        logging.error("No input file selected.")
        return
    
    # Prompt the user to select the output file location
    output_path = save_file("Select Output File Location", [("Excel files", "*.xlsx")])
    if not output_path:
        logging.error("No output file selected.")
        return

    log_time("Loading Excel file")
    with pd.ExcelFile(excel_path) as xlsx:
        df = pd.read_excel(xlsx, sheet_name=0)  # Load the first sheet

    loop_count = get_loop_count()
    if loop_count is None:
        logging.error("Loop count not provided.")
        return

    first_record = True  # Initialize a flag for the first record

    for i in range(loop_count):
        if halt_event.is_set():
            break

        AIN_value = df.iloc[i, 15]  # Value in Column P
        if pd.isna(AIN_value):  # Check if AIN_value is NaN
            AIN_value = df.iloc[i, 13]  # Use PIN from Column N if AIN is NaN
        Sales = df.iloc[i, 3]  # Sales in Column D
        Comment = "MLS"
        record_status = "Entered Successfully"

        try:
            # Check if AIN_value is a number and convert it to float
            if isinstance(AIN_value, (int, float)) or (isinstance(AIN_value, str) and AIN_value.isdigit()):
                AIN_value_float = float(AIN_value)
                if math.isnan(AIN_value_float):
                    logging.warning(f"Record {i+1}: AIN is NaN, skipping this record.")
                    record_status = "Error: AIN is NaN"
                    continue
            else:
                logging.error(f"Record {i+1}: AIN is not a valid number.")
                record_status = "Error: AIN is not a valid number"
                continue

            # Convert AIN_value to integer
            AIN = int(AIN_value_float)       

        except ValueError as e:
            logging.error(f"Record {i+1}: AIN is not a valid integer or float.")
            record_status = f"Error: {e}"
            continue

        finally:
            df.at[i, 'Status'] = record_status

        if not focus_proval_window('ProVal'):
            logging.error("ProVal window not found or could not be focused.")
            record_status = "Error: ProVal window not found or could not be focused."
            block_input = True  # Allow user interaction to log in to ProVal
            input("Press Enter to continue after logging in to ProVal...")
            block_input = False  # Resume blocking user input
            continue

        try:
            pag.hotkey('ctrl', 'o')
            pag.sleep(1)  # Add a short delay to ensure the dialog is open

            if first_record:
                pag.press('up', presses=11, interval=0.01)
                pag.press('down', presses=4, interval=0.01)
                pag.press('tab')
                first_record = False  # Set the flag to False after the first record
            else:
                pag.press('tab')

            pag.write(str(AIN))
            pag.press('enter')
            pag.sleep(2)  # Wait for the ProVal system to process the AIN entry

            # Wait for the window to update if needed
            pag.hotkey('alt', 'a', 'p', interval=0.25)

            line_of_sale = get_line_of_sale()
            if line_of_sale is None:
                logging.info(f"Record {i+1}: User skipped the record.")
                record_status = "Skipped by user"
                continue
            
            if not focus_proval_window('Update Sales Transaction Information'):
                logging.error("Update Sales Transaction Information window not found or could not be focused.")
                record_status = "Error: Update Sales Transaction Information window not found or could not be focused."
                continue

            if line_of_sale == 1:
                pag.press('tab')
                pag.press('space')
            elif line_of_sale == 2:
                pag.press('tab')
                pag.press('down', presses=4, interval=0.01)
                pag.press('space')
            elif line_of_sale == 3:
                pag.press('tab')
                pag.press('down', presses=7, interval=0.01)
                pag.press('space')
            elif line_of_sale == 4:
                pag.press('tab')
                pag.press('down', presses=10, interval=0.01)
                pag.press('space')

            pag.hotkey('alt', 'e')
            pag.press('tab', presses=17, interval=0.01)
            pag.write(str(Sales))
            pag.press('tab', presses=18, interval=0.01)
            pag.write(str(Comment))
            pag.press('tab', presses=2, interval=0.01)
            pag.press('enter')
            pag.press('tab')
            pag.press('enter')
            pag.hotkey('ctrl', 's')
            logging.info(f"Record {i+1}: Entered Successfully")

        except Exception as e:
            logging.error(f"Record {i+1}: Error - {e}")
            record_status = f"Error: {e}"

        finally:
            df.at[i, 'Status'] = record_status

    log_time("Saving updated Excel file")
    with pd.ExcelWriter(output_path) as writer:
        df.to_excel(writer, index=False)

    # Save a copy in the user's Documents/Sales folder
    current_date = datetime.now()
    month_year = current_date.strftime("%m%y")
    sales_dir = os.path.join(os.path.expanduser("~"), "Documents", "Sales", month_year)
    os.makedirs(sales_dir, exist_ok=True)
    copy_path = os.path.join(sales_dir, "UpdatedSalesInfo.xlsx")
    df.to_excel(copy_path, index=False)

    log_time(f"Task completed! Updated file saved at {output_path}")
    print("Task completed!")

    # Restore original Caps Lock state
    toggle_caps_lock(initial_caps_lock_state)

if __name__ == "__main__":
    # Start hotkey monitoring in a separate thread
    hotkey_thread = threading.Thread(target=monitor_hotkeys, daemon=True)
    hotkey_thread.start()

    # Run the main script
    main_script()
