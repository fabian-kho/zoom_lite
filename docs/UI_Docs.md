# User interface design Documentation
Documentation for the user interface design of the application.

## Table of Contents
- [User interface design Documentation](#user-interface-design-documentation)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Design](#design)
    - [Wireframes](#wireframes)
    - [Next Steps](#next-steps)
  - [References](#references)

## Introduction
This document provides an overview of the user interface design of the application. It includes the wireframes, mockups, and prototype of the application.

## Design
The application is designed to be simple and easy to use. The user interface is based on Material Design guidelines and follows the design principles of simplicity, consistency, and usability. 
There are three main pages:
- The LandingPage is the first page that the user sees when they open the application. It displays a greeting and allows the user to search for a presentation. The user can also create a new presentation by tapping the FAB (Floating Action Button).
- The AudiencePage is displayed when the user selects a presentation from the list. It displays the presentation document and allows the user to navigate through the presentation. The user can also change the orientation of the presentation between vertical and horizontal modes.
- The PresentationPage is displayed when the user creates a new presentation. It displays the presentation document and allows the user to navigate through the presentation. The user can also change the orientation of the presentation between vertical and horizontal modes.


## LandingPage

### UI Components:
- AppBar: Displays a Greeting.
- SearchBar: Allows the user to search for a presentation.
- ListView: Displays the list of presentations.
  - ListTile: Displays the title of the presentation.
- FloatingActionButton: Allows the user to create a new presentation via a [Dialog](#CreatePresentationDialog).

### User Interactions:
- Tapping FAB: Navigates to the CreatePresentationDialog.


### AudiencePage

#### UI Components:
- AppBar: Displays the title of the presentation.
- PDF Viewer: Renders and displays the presentation document.
- BottomAppBar: Contains navigation controls for the presentation.
  - IconButton (change direction): Changes the orientation between vertical and horizontal modes.

#### User Interactions:
- Tapping Toggle Orientation Icon: Changes the orientation of the presentation between vertical and horizontal modes.
- Tapping Back Icon (AppBar): Displays a confirmation dialog and allows the user to end the presentation.


### PresentationPage

#### UI Components:
- AppBar: Displays the title of the presentation.
- PDF Viewer: Renders and displays the presentation document.
- BottomAppBar: Contains navigation controls for the presentation.
  - IconButton (Previous Page): Navigates to the previous page if available.
  - IconButton (Next Page): Navigates to the next page if available.
  - IconButton (Toggle Orientation): Changes the orientation between vertical and horizontal modes.

#### User Interactions:
- Tapping Previous/Next Page Icons: Enables the user to navigate to the previous or next page of the presentation.
- Tapping Toggle Orientation Icon: Changes the orientation of the presentation between vertical and horizontal modes.
- Tapping Back Icon (AppBar): Displays a confirmation dialog and allows the user to end the presentation. **Note that this also deletes the presentation from the database**.
- 

### CreatePresentationDialog

#### UI Components:
- AlertDialog: Displays a dialog to create a new presentation.
  - Text Field: Allows the user to enter the presentation name.
  - Text (Information): Informs the user that only PDF files are supported.

#### User Interactions:
- Typing in the Text Field: Enables the user to enter the presentation name.
- Tapping Cancel Button: Closes the dialog without creating a new presentation.
- Tapping Upload Button: Initiates the process of uploading a PDF file for the presentation.
  - File Picker: Allows the user to select a PDF file from their device.
  - CircularProgressIndicator: Indicates the loading process during the file upload.
  - AlertDialog (Error): Displays an error dialog if an error occurs during the file upload.


### Wireframes
In Figma we have created wireframes for the application. The wireframes are available [here](https://www.figma.com/file/nhKYOe3ctBqtwVwMKXlw5w/Zoom-lite?type=design&node-id=0%3A1&t=7ucbBcvpRjc7epkW-1).

### Next Steps
- Add Authentication
  - This would allow users to have their own presentations and not share them with other users.
  - This could be done using Firebase Authentication.
- Support for multiple file types
  - Right Now the application only supports PDF files. In the future we could add the support of more file types like PowerPoint, Word, Excel, etc.
- Add Animations
  - This would make the application more interactive and fun to use.
- Improve Error Handling (e.g. file upload failed)
 - Right now the application does not handle errors very well. In the future we could improve the error handling to make the application more robust.
 - E.g. if the file upload fails (which never happens local, but could happen on production with millions of users), the application should display an error message to the user.
- IOS support
  - Right now the application only supports Android. In the future we could add support for IOS devices.
  

## References
Below are some of the resources that we used to develop the application:
- [Material Design](https://material.io/design)
- [Flutter Documentation](https://flutter.dev/docs)
- [Getting started with Firebase on Flutter - Firecasts](https://www.youtube.com/watch?v=EXp0gq9kGxI&ab_channel=Firebase)
- [The Firebase Realtime Database and Flutter - Firecasts](https://www.youtube.com/watch?v=sXBJZD0fBa4&t=481s&ab_channel=Firebase)