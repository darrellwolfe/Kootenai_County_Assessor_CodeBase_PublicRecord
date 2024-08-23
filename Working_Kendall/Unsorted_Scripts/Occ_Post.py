import pyautogui
import logging
import psutil
import os
import time
from pywinauto import Application

# New import to handle windows
logging.basicConfig(
    filename='Occ_Post.log',
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.DEBUG)
console_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
logging.getLogger().addHandler(console_handler)

DEFAULT_PROVAL_PATH = "C:/Program Files (x86)/Thomson Reuters/ProVal/ProVal.exe"
PROVAL_PATH = ('ProVal', 'executable_path')

class Window:
    def __init__(self, name, proval_path=DEFAULT_PROVAL_PATH):
        self.name = name
        self.proval_path = proval_path

    def get_proval_pid(self):
            """Get the PID of the ProVal process."""
            for proc in psutil.process_iter(['pid', 'name', 'exe']):
                try:
                    if proc.info['exe'] and os.path.normpath(proc.info['exe']) == os.path.normpath(self.proval_path):
                        return proc.info['pid']
                except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
                    pass
            return None
    
    def focus_proval(self):
        logging.debug("Attempting to focus ProVal window...")
        try:
            proval_pid = self.get_proval_pid()
            if not proval_pid:
                logging.debug("ProVal process not found.")
                return False
            app = Application().connect(process=proval_pid)
            proval_windows = app.windows(title_re='ProVal', found_index=0)
            if proval_windows:
                self.proval_window_handle = proval_windows[0]
                logging.debug(f"Found ProVal window: {self.proval_window_handle}")
                self.proval_window_handle.set_focus()
                time.sleep(1)
                if self.proval_window_handle.has_focus():
                    logging.debug("ProVal window is confirmed as active.")
                    return True
                else:
                    logging.debug("Failed to activate ProVal window.")
                    return False
            else:
                logging.debug("ProVal window not found.")
                return False
        except Exception as e:
            logging.error(f"Error focusing ProVal window: {e}")
            return False

    def find_and_click(self, x, y):
        logging.debug(f"Clicking at position ({x}, {y}) in {self.name}")
        pyautogui.click(x, y)

def wait(seconds):
    pyautogui.sleep(seconds)

def press_key(key):
    pyautogui.press(key)

def send_keys(text):
    pyautogui.write(text)

def ask_question(question) -> bool:
    return pyautogui.confirm(text=question, title='Confirmation', buttons=['YES', 'NO']) == 'YES'

def keyinfo(proval_window):
    proval_window.focus_proval()
    wait(2)
    proval_window.find_and_click(996,584)
    wait(1)
    pyautogui.hotkey('ctrl', 'k')
    wait(3)
    return ask_question("Key Information is correct?")

def pricing(proval_window):
    proval_window.focus_proval()
    wait(0.75)
    press_key("enter")
    wait(0.75)
    press_key("esc")
    wait(0.75)
    pyautogui.hotkey('alt')
    send_keys("vc")
    wait(1)
    proval_window.focus_proval()
    proval_window.find_and_click(446,407)
    wait(0.5)
    proval_window.find_and_click(240,407)
    wait(2.75)
    proval_window.find_and_click(604,187)
    wait(1)
    return ask_question("Ready to edit the memo?")

def memo(proval_window, method_of_posting, date_of_occupancy):
    proval_window.focus_proval()
    pyautogui.hotkey('ctrl', 'shift', 'm')
    wait(1)
    proval_window.focus_proval()
    pyautogui.hotkey('n')
    press_key("enter")
    wait(1)
    pyautogui.hotkey('ctrl', 'a')
    press_key("backspace")
    send_keys(f"POSTED - {method_of_posting} {date_of_occupancy}")
    wait(1)
    press_key("tab")
    press_key("enter")
    return ask_question("Ready to post?")

def posting(proval_window, date_of_occupancy):
    proval_window.focus_proval()
    pyautogui.hotkey('ctrl', 's')
    wait(2)
    pyautogui.hotkey('alt')
    wait(0.5)
    send_keys("vp")
    wait(1)
    proval_window.focus_proval()
    wait(0.5)
    send_keys("2024")
    press_key("tab")
    send_keys(date_of_occupancy)
    press_key("tab")
    send_keys("0")
    wait(1.75)
    press_key("enter")
    wait(1)
    press_key("enter")
    return ask_question("Next Parcel?")

def next_parcel(proval_window):
    proval_window.find_and_click(615,165)
    wait(1)
    press_key("f3")

def main():
    proval_window = Window("ProVal")
    
    method_of_posting = pyautogui.prompt("Enter Method of Posting:")
    date_of_occupancy = pyautogui.prompt("Enter Date of Occupancy:")

    if not proval_window.focus_proval():
        logging.error("Failed to focus ProVal window. Exiting.")
        return

    press_key("f9")
    wait(2)

    if ask_question("Allocations are correct?"):
        if keyinfo(proval_window):
            if pricing(proval_window):
                if memo(proval_window, method_of_posting, date_of_occupancy):
                    if posting(proval_window, date_of_occupancy):
                        next_parcel(proval_window)

if __name__ == "__main__":
    main()