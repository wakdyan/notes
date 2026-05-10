# Notes

A simple note application that allows users to create, read, update, and delete notes in real-time.

## Project setup steps

#### Environment Preparation:

- Download and install IDE ([vscode](https://code.visualstudio.com/download)
  or [android studio](https://developer.android.com/studio)).
- Download and install [Flutter](https://docs.flutter.dev/get-started/install).
- Android emulator or device.

#### Project Initialization:

- Clone or download this repository to your local machine.

## How to run the app locally

1. Open the project in your IDE.

2. Fetch the required packages with command `flutter pub get` in the terminal.

3. Run the project using the "Run" button or by typing `flutter run` in the terminal.

## Database schema / collections / tables

Database: Cloud Firestore <br>Collection: `notes`

- `id`: String (Document ID)
- `userId`: String (UID from Firebase Auth)
- `title`: String
- `content`: String
- `createdAt`: Timestamp
- `updatedAt`: Timestamp

Each note document is associated with a single user via `userId`. This ensures data isolation
between users.

## Authentication approach used

- Provider: Firebase Authentication
- Method: Email and Password
- Mechanism: Implements an auth wrapper (`RootPage`) that listens to `authStateChanges`. This ensures that if a
  user is already logged in, they are redirected straight to the `HomePage` upon app launch.

## Any assumptions or trade-offs made

#### Assumptions

- Users must be authenticated before accessing notes.
- Each note belongs to a single note.
- Internet connection is required for authentication and CRUD operations.
- Users are assumed to be familiar with mobile gestures, as deleting a note is handled via a swipe
  action.

#### Trade-offs

- Using `Consumer` (from `provider`) instead of `StreamBuilder` to handle stream-based data updates.
  This decision was made to centralize state management within a single architecture layer and
  making state easier to manage across multiple widgets.