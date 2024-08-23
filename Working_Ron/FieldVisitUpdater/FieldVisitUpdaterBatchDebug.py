import sys
import time
import subprocess
import keyboard
import logging
import psutil
import pyautogui
from pathlib import Path
from pywinauto import Application
import traceback

# Setup logging
logging.basicConfig(filename='FieldVisitUpdater.log', level=logging.INFO,
                    format='%(asctime)s:%(levelname)s:%(message)s')

proval_process = None
app_path = "C:/Program Files (x86)/Thomson Reuters/ProVal/ProVal.exe"
data_file_path = Path(r"C:\Users\rmason\Documents\Kootenai_County_Assessor_CodeBase\Working_Ron\FieldVisitUpdater\fvb.txt")

# Function to terminate the script
def terminate_script():
    global proval_process
    if proval_process:
        proval_process.terminate()
        logging.info("ProVal process terminated.")
    logging.info("ProVal terminated.")
    sys.exit()

# Register the hotkey
keyboard.add_hotkey('ctrl+shift+h', terminate_script)

class ProValAutomation:
    def __init__(self):
        self.app = None

    def open_proval(self):
        global proval_process
        try:
            # Check if ProVal is already running
            for proc in psutil.process_iter(['name']):
                if proc.info['name'] == 'ProVal.exe':
                    logging.info("ProVal is already running.")
                    self.app = Application().connect(path=app_path)
                    return

            # Start a new instance of ProVal
            proval_process = subprocess.Popen([app_path])
            self.app = Application().connect(process=proval_process.pid)
            logging.info("ProVal started successfully.")
            return proval_process
        except FileNotFoundError:
            logging.error("ProVal executable not found. Please ensure the path is correct.")
            sys.exit()
        except Exception as e:
            logging.error(f"Failed to start ProVal: {e}")
            logging.error(traceback.format_exc())
            sys.exit()

    def load_data(self, file_path):
        try:
            with open(file_path, "r") as file:
                lsrns = file.read().splitlines()
            logging.info(f"Loaded data: {lsrns}")
            return lsrns
        except Exception as e:
            logging.error(f"Error loading data: {e}")
            logging.error(traceback.format_exc())
            return []

    def automate_field_visit(self, lsrn, lsrns):
        try:
            logging.info(f"Starting automation for LSRN: {lsrn}")

            # Example automation steps (replace with actual steps)
            pyautogui.click(100, 200)  # Replace with actual coordinates
            pyautogui.typewrite(lsrn)
            pyautogui.press('enter')

            logging.info(f"Completed automation for LSRN: {lsrn}")
            time.sleep(2)
        except Exception as e:
            logging.error(f"Error processing LSRN {lsrn}: {e}")
            logging.error(traceback.format_exc())
            time.sleep(1)

def main():
    global proval_process
    try:
        # Initialize ProVal
        proval_automation = ProValAutomation()
        logging.info("Initialized ProValAutomation class.")

        # Open ProVal
        proval_process = proval_automation.open_proval()
        logging.info("ProVal application opened.")
        time.sleep(10)  # Wait for ProVal to load

        # Load the data file
        lsrns = proval_automation.load_data(str(data_file_path))
        logging.info(f"Loaded LSRNs from data file: {lsrns}")

        # Automate field visit setup for each LSRN
        for lsrn in lsrns:
            logging.info(f"Starting automation for LSRN: {lsrn}")
            proval_automation.automate_field_visit(lsrn, lsrns)
            logging.info(f"Completed automation for LSRN: {lsrn}")

    except Exception as e:
        logging.error(f"An error occurred in the main function: {e}")
        logging.error(traceback.format_exc())
    finally:
        # Close ProVal
        terminate_script()

if __name__ == "__main__":
    logging.info("Script started.")
    main()
    logging.info("Script ended.")
