import os
import re
import time
import logging
import pyautogui
import win32com.client
import pygetwindow as gw

# Set up logging
def setup_logging():
    home_dir = os.path.expanduser("~")
    log_dir = os.path.join(home_dir, "CertificateOfOccupancy")

    if not os.path.exists(log_dir):
        os.makedirs(log_dir)

    log_file = os.path.join(log_dir, "CertificateOfOccupancy.log")

    logging.basicConfig(
        filename=log_file,
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s'
    )

    console = logging.StreamHandler()
    console.setLevel(logging.INFO)
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    console.setFormatter(formatter)
    logging.getLogger().addHandler(console)

def extract_pin(body):
    match = re.search(r'PARCEL #:\s*(\w+)', body)
    return match.group(1) if match else None

def extract_address(body):
    match = re.search(r'work at (.+?) has been issued', body)
    return match.group(1) if match else None

def extract_permit_number(body):
    match = re.search(r'PERMIT INFORMATION:.*?(\w+)', body)
    return match.group(1) if match else None

def update_proval(pin, address, permit_number, occupancy_date):
    try:
        # Bring ProVal to focus
        windows = gw.getWindowsWithTitle("ProVal")
        if windows:
            windows[0].maximize()
            windows[0].activate()  # Ensure the window is focused
            logging.info("ProVal window activated.")
        else:
            logging.warning("ProVal window not found.")
            return

        # Open the record using the hotkey
        pyautogui.hotkey('ctrl', 'o')
        time.sleep(2)  # Wait for the open dialog to appear

        # Navigate to the PIN selection
        for _ in range(11):
            pyautogui.press('up')
        pyautogui.press('tab')
        time.sleep(1)  # Ensure focus is on the PIN field

        # Enter the PIN
        pyautogui.typewrite(pin)
        pyautogui.press('enter')
        logging.info(f"Entered PIN: {pin}")
        time.sleep(5)  # Wait for the record to load

        # Check the 'Date Certified for Occupancy' box
        pyautogui.click(x=145, y=855)  # Update coordinates as needed
        logging.info("Checked 'Date Certified for Occupancy' box.")
        time.sleep(1)  # Wait for the checkbox action to complete

        # Enter the occupancy date
        pyautogui.click(x=160, y=855)  # Update coordinates as needed for the date field
        # Split the date into components
        month, day, year = occupancy_date.split('/')
        # Enter the month
        pyautogui.typewrite(month)
        pyautogui.press('right')
        # Enter the day
        pyautogui.typewrite(day)
        pyautogui.press('right')
        # Enter the year
        pyautogui.typewrite(year)
        pyautogui.press('enter')
        logging.info(f"Entered Occupancy Date: {occupancy_date}.")
        time.sleep(5)  # Wait to perhaps activate an inactive parcel

        # Save the record
        pyautogui.hotkey('ctrl', 's')
        time.sleep(1)  # Wait for the save operation to complete
        logging.info("Record saved successfully.")

    except Exception as e:
        logging.error(f"Error updating ProVal: {e}")

def main():
    setup_logging()
    logging.info("Starting email processing...")

    try:
        outlook = win32com.client.Dispatch("Outlook.Application").GetNamespace("MAPI")
        logging.info("Connected to Outlook.")

        # Access the kcasr permits mailbox
        for folder in outlook.Folders:
            logging.info(f"Available folder: {folder.Name}")
            if folder.Name == 'kcasr permits':
                try:
                    # Access the Inbox within the mailbox
                    inbox_folder = folder.Folders['Inbox']
                    logging.info("Accessed Inbox.")

                    # Loop through each email in the Inbox
                    for message in inbox_folder.Items:
                        sender = message.SenderEmailAddress
                        body = message.Body
                        received_date = message.ReceivedTime.strftime('%m/%d/%Y')

                        # Filter emails based on the sender's email address
                        if sender == "noreply@cityofhaydenid.us":
                            subject = message.Subject
                            logging.info(f"Processing email from {sender}: {subject}")

                            pin = extract_pin(body)
                            address = extract_address(body)
                            permit_number = extract_permit_number(body)

                            if pin or address:
                                update_proval(pin, address, permit_number, received_date)
                            else:
                                logging.warning(f"Could not extract data from email: {subject}")

                    logging.info("Email processing completed.")
                    return

                except Exception as e:
                    logging.error(f"Error accessing Inbox: {e}")
                    return

        logging.error("Mailbox 'kcasr permits' not found.")

    except Exception as e:
        logging.error(f"Error during email processing: {e}")

if __name__ == "__main__":
    main()