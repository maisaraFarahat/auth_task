
# Flutter Frontend for Google Cloud App

This is the **Flutter frontend** for an application with a **NestJS backend** deployed to **Google App Engine** and a **PostgreSQL** database on **Google Cloud SQL**.

---

## Project Overview

The Flutter frontend provides a simple, interactive UI for the backend API, allowing users to sign up, sign in, and manage their profiles based on role-based access.

- **Backend**: The backend is developed in NestJS and includes an API for user management and role-based access control. (See the [backend repository](https://github.com/YOUR_ORG/YOUR_BACKEND_REPO) for more details.)
- **Database**: PostgreSQL instance hosted on Google Cloud SQL, accessed by the backend.
- **Deployment**: The backend is deployed to Google App Engine with a CI/CD pipeline.

---

## Technologies Used

- **Flutter**: For frontend development.
- **HTTP**: For connecting with the backend API.
- **Google App Engine**: Hosts the NestJS backend (deployed via CI/CD).
- **PostgreSQL**: Database for application data, hosted on Google Cloud SQL.

---

## Setup Instructions

1. **Install Flutter**: 
   - Make sure you have Flutter installed. Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install).

2. **Configure API URL**:
   - Update the API URL in your Flutter code to point to the backend URL deployed on Google App Engine. You may have two configurations:
     - **Testing**: Point to a local environment or staging endpoint.
     - **Production**: Point to the deployed backend URL on Google App Engine.

3. **Run the Flutter App**:
   - Install dependencies and run the app locally:
     ```bash
     flutter pub get
     flutter run
     ```

---

## API Connection

The Flutter frontend connects to the NestJS backend API for the following functionalities:

- **User Authentication**:
  - Sign Up with random password generation and email delivery (for Users, Admins, and Viewers).
  - Sign In to retrieve an access token.

- **Role-Based Access**:
  - Users can edit their own profiles.
  - Admins can edit roles and delete other users as needed.
  - Viewers have read-only access to view all users.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

