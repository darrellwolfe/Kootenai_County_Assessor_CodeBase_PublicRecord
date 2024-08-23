import os
import shutil
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler import pandas as pd import PyPDF2 # or pdfplumber, PyMuPDF

class PDFHandler(FileSystemEventHandler):
def on_created(self, event):
if event.is_directory:
return
if event.src_path.endswith('.pdf'):
process_pdf(event.src_path)

def process_pdf(pdf_path):
# Extract information from the PDF
with open(pdf_path, 'rb') as file:
reader = PyPDF2.PdfFileReader(file)
# Assuming the required info is in the first page page = reader.getPage(0) text = page.extract_text() # Example: Extracting specific information (you will need regex or specific parsing logic) # info = extract_information_from_text(text)
# For demonstration, let's assume we need the title title = extract_title(text)

# Rename and move the PDF
new_filename = f"{title}.pdf"
new_path = os.path.join('processed_pdfs', new_filename) shutil.move(pdf_path, new_path)

# Update the spreadsheet
update_spreadsheet(new_filename, text)

def extract_title(text):
# Custom logic to extract the title from the PDF text # For demonstration, let's return a dummy title return "example_title"

def update_spreadsheet(filename, text):
spreadsheet_path = 'path_to_your_spreadsheet.xlsx'
df = pd.read_excel(spreadsheet_path)

# Custom logic to determine what information to fill in # For demonstration, let's add a new row new_row = {'Filename': filename, 'Content': text} df = df.append(new_row, ignore_index=True)

df.to_excel(spreadsheet_path, index=False)

if __name__ == "__main__":
path_to_watch = 'directory_to_watch'
os.makedirs('processed_pdfs', exist_ok=True)

event_handler = PDFHandler()
observer = Observer()
observer.schedule(event_handler, path_to_watch, recursive=False)
observer.start()

try:
while True:
time.sleep(1)
except KeyboardInterrupt:
observer.stop()
observer.join()
