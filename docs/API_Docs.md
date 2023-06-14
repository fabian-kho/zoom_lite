# API Documentation

This document provides an overview of the API endpoints used to store data in Firebase Realtime Database and Firebase Storage.

## Firebase Realtime Database Endpoints

### Store Presentation Data

- Endpoint: `/presentations`
- Method: `POST`
- Description: Stores presentation data in the Firebase Realtime Database.
- Request Body:
    - `title` (string): The title of the presentation.
    - `file_path` (string): The file path of the presentation in Firebase Storage.
- Response:
    - Status: `201 Created`
    - Body: JSON object containing the stored presentation data.

### Update Page Number

- Endpoint: `/presentations/{presentationId}`
- Method: `PATCH`
- Description: Updates the page number of a specific presentation in the Firebase Realtime Database.
- Request Parameters:
    - `presentationId` (string): The unique identifier of the presentation.
- Request Body:
    - `page_number` (integer): The updated page number.
- Response:
    - Status: `200 OK`

### Delete Presentation

- Endpoint: `/presentations/{presentationId}`
- Method: `DELETE`
- Description: Deletes a specific presentation from the Firebase Realtime Database and Firebase Storage.
- Request Parameters:
    - `presentationId` (string): The unique identifier of the presentation.
- Response:
    - Status: `204 No Content`

## Firebase Storage Endpoints

### Upload Presentation File

- Endpoint: `/upload`
- Method: `POST`
- Description: Uploads a presentation file to Firebase Storage.
- Request Body: Form-data with the following field:
    - `file` (file): The presentation file to upload.
- Response:
    - Status: `200 OK`
    - Body: JSON object containing the download URL of the uploaded file.

### Delete Presentation File

- Endpoint: `/presentations/{presentationId}/file`
- Method: `DELETE`
- Description: Deletes the presentation file from Firebase Storage.
- Request Parameters:
    - `presentationId` (string): The unique identifier of the presentation.
- Response:
    - Status: `204 No Content`
