from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import qrcode
import os
from io import BytesIO
from dotenv import load_dotenv
load_dotenv()
from azure.storage.blob import BlobServiceClient, ContentSettings

app = FastAPI()

# Allowing CORS for local testing
origins = [
    "http://localhost:3000"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Azure Blob Storage Configuration
connection_str = os.getenv("AZURE_STORAGE_CONNECTION_STRING")
container_name = os.getenv("AZURE_CONTAINER_NAME")  # Your container name from Azure
blob_service_client = BlobServiceClient.from_connection_string(connection_str)

@app.post("/generate-qr/")
async def generate_qr(url: str):
    # Generate QR Code
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(url)
    qr.make(fit=True)

    img = qr.make_image(fill_color="black", back_color="white")
    
    # Save QR Code to BytesIO object
    img_byte_arr = BytesIO()
    img.save(img_byte_arr, format='PNG')
    img_byte_arr.seek(0)

    # Generate file name for Azure Blob Storage
    file_name = f"qr_codes/{url.split('//')[-1]}.png"

    try:
        blob_client = blob_service_client.get_blob_client(container=container_name, blob=file_name)
        blob_client.upload_blob(img_byte_arr, overwrite=True, 
                                content_settings=ContentSettings(content_type="image/png"))
        
        # Construct the URL to the uploaded blob.
        # Assumes your container has public access set for the blobs.
        account_name = os.getenv("AZURE_STORAGE_ACCOUNT")
        azure_url = f"https://{account_name}.blob.core.windows.net/{container_name}/{file_name}"
        return {"qr_code_url": azure_url}
    except Exception as e:
        print("Error uploading to Azure Blob Storage:", e)
        raise HTTPException(status_code=500, detail=str(e))