# CareWell Hospital Management System

A full-stack hospital web application built with **Java (Jakarta Servlets & JSP)** and **MySQL**.
Patients can register, book appointments with doctors, and view their prescriptions, medical
records, bills and notifications. Doctors get their own portal to manage appointments,
prescriptions and medical records.

**Live demo:** https://carewellhospital.onrender.com
*(Hosted on Render's free plan. The first visit after a period of inactivity can take
30-60 seconds while the server wakes up.)*

---

## Features

### Public website
- Responsive home page with doctor profiles loaded from the database
- Services, About and Contact sections
- "Book" buttons that take the patient straight to the booking form with the doctor or department pre-selected

### Patient portal
- Secure registration with full client-side and server-side validation
- Login with "Keep me signed in", forgot password and reset password by email
- Book appointments by department and doctor
- View and manage appointments
- Prescriptions, medical records, bills and payments
- Notifications and email appointment reminders
- Profile update and change password

### Doctor portal
- Dashboard with today's appointments
- Manage appointments
- Add prescriptions and medical records
- Notifications, profile and change password

### Security
- Passwords hashed with **BCrypt**
- Session fixation protection (new session ID on login)
- Server-side input validation on registration
- No-cache headers on portal pages (Back button after logout does not show private data)
- Security headers (`X-Frame-Options`, `X-Content-Type-Options`, `Referrer-Policy`)
- Secrets read from environment variables, never stored in the code
- Custom error pages (no server details exposed)

---

## Tech stack

| Layer | Technology |
|---|---|
| Frontend | JSP, HTML5, CSS3, JavaScript, Font Awesome |
| Backend | Java 21, Jakarta Servlets 6, JSP |
| Database | MySQL with JDBC (DAO pattern) |
| Email | Brevo transactional email API |
| Security | jBCrypt password hashing |
| Server | Apache Tomcat 10.1 |
| Deployment | Docker + Render |

---

## Project structure

```
CarewellHospital-main/
├── CareWellHospital/
│   ├── lib/                     # External JARs (MySQL driver, BCrypt, Jakarta Mail)
│   └── src/main/
│       ├── java/com/
│       │   ├── controller/      # Servlets (login, register, appointments, ...)
│       │   ├── dao/             # DAO interfaces
│       │   ├── daoimpl/         # JDBC implementations
│       │   ├── filter/          # Security headers filter
│       │   ├── model/           # Entity classes
│       │   └── util/            # DB connection, email, schedulers, password hashing
│       └── webapp/
│           ├── css/             # Stylesheets and images
│           ├── patient/         # Patient portal pages
│           ├── doctor/          # Doctor portal pages
│           ├── WEB-INF/web.xml
│           └── index.jsp, login.jsp, register.jsp, ...
├── CareWellHospital.war         # Built application used by the Dockerfile
├── Dockerfile
├── .env.example                 # List of required environment variables
└── README.md
```

---

## Running locally

### Prerequisites
- JDK 21
- Apache Tomcat 10.1
- MySQL 8
- Eclipse IDE for Enterprise Java and Web Developers

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/CarewellHospital.git
   ```
2. Create the MySQL database `carewell_hospital` and its tables.
3. Set the environment variables listed in `.env.example`
   (in Eclipse: *Run Configurations → Tomcat → Environment*).
4. Import `CareWellHospital` into Eclipse as a Dynamic Web Project and add the JARs in `lib/` to the build path.
5. Run on Tomcat 10.1 and open `http://localhost:8080/CareWellHospital/`.

---

## Deployment (Render)

1. In Eclipse: right-click the project → **Export → WAR file** → save it as `CareWellHospital.war` in the repository root.
2. Commit and push to GitHub.
3. Render builds the `Dockerfile` (Tomcat 10.1 + the WAR) and redeploys automatically.
4. Add the variables from `.env.example` in Render under **Environment**.

---

## Screenshots

_Add screenshots of the home page, patient dashboard and doctor dashboard here._

---

## Author

**<Your Name>**
- GitHub: https://github.com/<your-username>
- LinkedIn: https://www.linkedin.com/in/<your-profile>
