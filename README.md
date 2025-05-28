# QR Code DevOps Platform

This is the sample application for the DevOps Capstone Project.
It generates QR Codes for the provided URL, the front-end is in NextJS and the API is written in Python using FastAPI.

*This project is a modified version of the original work by [Rishab Kumar](https://github.com/rishabkumar7), updated to use Azure cloud services.*

![Image](https://github.com/user-attachments/assets/008feca6-5b51-499e-8c20-4375e47c8003)

## Application

**Front-End** - A web application where users can submit URLs.

**API**: API that receives URLs and generates QR codes. The API stores the QR codes in cloud storage.

## Running locally

### API

The API code exists in the `api` directory. You can run the API server locally:

- Clone this repo
- Make sure you are in the `api` directory
- Create a virtualenv by typing in the following command: `python -m venv .venv`
- Install the required packages: `pip install -r requirements.txt`
- Create a `.env` file, and add you AWS Access and Secret key, check  `.env.example`
- Also, change the BUCKET_NAME to your S3 bucket name in `main.py`
- Run the API server: `uvicorn main:app --reload`
- Your API Server should be running on port `http://localhost:8000`

### Front-end

The front-end code exits in the `front-end-nextjs` directory. You can run the front-end server locally:

- Clone this repo
- Make sure you are in the `front-end-nextjs` directory
- Install the dependencies: `npm install`
- Run the NextJS Server: `npm run dev`
- Your Front-end Server should be running on `http://localhost:3000`


## Goal

The goal is to get hands-on with DevOps practices like Containerization, CICD and monitoring.

Look at the capstone project for more detials.

## Original Author

The base project was created by [Rishab Kumar](https://github.com/rishabkumar7)

## Modifications

This version includes:
- Migration from AWS S3 to Azure Blob Storage.
- Updated instructions for local development with Azure integration.

## Deployment Steps

1. **Backend (FastAPI)**
   - For detailed instructions on running the API locally or deploying it, please refer to the [API Module README](./api/README.md).

2. **Frontend (Next.js)**
   - For configuration and deployment instructions for the front-end, see the [Front-End-Nextjs Module README](./front-end-nextjs/README.md).

3. **Infrastructure**
   - Provision the necessary Azure resources (e.g., Storage Account, AKS) using Terraform by following the steps in the [Infrastructure Module README](./infrastructure/README.md).

4. **Kubernetes Deployment**
   - After verifying your resource deployments in the Azure Portal, continue with the Kubernetes deployment as described in the [K8s Module README](./k8s/README.md).
  
5. **CI/CD**
   - For detailed instructions on the automated pipelines—including Docker builds, Terraform provisioning, and Kubernetes deployments—please refer to the [CI/CD GitHub Actions Workflows README](./.github/workflows/README.md).

## License

[MIT](./LICENSE)
