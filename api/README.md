# QR Code Generator API

This API generates QR codes for provided URLs and uploads the generated PNG image to Azure Blob Storage. The API is built with FastAPI.

## Features

- Generates a QR code image from a URL.
- Uploads the generated image to Azure Blob Storage.
- Returns the public URL for the uploaded QR code image.

## Prerequisites

- Python 3.8 or newer
- [FastAPI](https://fastapi.tiangolo.com/)  
- [Uvicorn](https://www.uvicorn.org/)
- [Azure Storage Blob](https://pypi.org/project/azure-storage-blob/)
- [python-dotenv](https://pypi.org/project/python-dotenv/)
- Environment variables configured (see below)

## Setup

1. **Clone the repository and navigate into the API directory:**

   ```bash
   git clone <repository-url>
   cd \qr-code-generator\api
   ```

2. **Install Dependencies:**

   Create a virtual environment and install the required packages:
   ```bash
   python -m venv .venv
   source .venv/bin/activate      # On Linux/Mac
   .venv\Scripts\activate         # On Windows
   pip install -r requirements.txt
   ```

3. **Configure Environment Variables:**

   Create a `.env` file in the same directory as `main.py` and add:
   ```ini
   AZURE_STORAGE_CONNECTION_STRING=<your-azure-storage-connection-string>
   AZURE_CONTAINER_NAME=<your-container-name>         # e.g., "qr-codes"
   AZURE_STORAGE_ACCOUNT=<your-storage-account-name>
   ```
   These variables are used to connect to your Azure Blob Storage instance.

## Running the API

Start the API with Uvicorn:
```bash
uvicorn main:app --reload
```
The API will be available at [http://localhost:8000](http://localhost:8000).

## API Endpoint

### `POST /generate-qr/`

- **Description:** Generates a QR code for the provided URL and uploads the image to Azure Blob Storage.
- **Request Body:**  
  A form or query parameter `url` with the URL you wish to generate a QR code for.
- **Response:**  
  JSON object containing the QR code image URL:
  ```json
  {
    "qr_code_url": "https://<storage-account>.blob.core.windows.net/<container>/<file-name>.png"
  }
  ```

## How It Works

1. **QR Code Generation:**  
   The API creates a QR code using the [qrcode](https://pypi.org/project/qrcode/) library with specified parameters such as version, error correction, box size, and border.

2. **Image Storage:**  
   The generated image is saved into a `BytesIO` object in PNG format.

3. **File Naming and Upload:**  
   A file name is generated based on the provided URL. The file is then uploaded to Azure Blob Storage using the specified container.  
   The file name format is:  
   ```
   qr_codes/<url-domain>.png
   ```
   Note: The code uses a folder named `qr_codes` inside your Azure container.

4. **Response:**  
   A URL that points to the uploaded blob is constructed and returned in the API response.

## Troubleshooting

- **Azure Blob Upload Issues:**  
  Check that your Azure Storage connection string and container name are correct. Ensure that the container allows public blob access for retrieving the QR code image.

- **Environment Variables:**  
  Verify that your `.env` file is properly configured and that environment variables are being loaded (using `python-dotenv`).

- **Logging:**  
  The API prints errors to the console if issues occur during the upload process.

## License

This project is licensed under the MIT License. (Update as needed.)