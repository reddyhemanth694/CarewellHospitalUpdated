package com.controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.UserDAO;
import com.dao.PatientDAO;
import com.daoimpl.UserDAOImpl;
import com.daoimpl.PatientDAOImpl;
import com.model.User;
import com.model.Patient;
import com.util.PasswordUtil;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final Pattern NAME_PATTERN =
            Pattern.compile("^[A-Za-z][A-Za-z .'-]{1,99}$");
    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^[6-9][0-9]{9}$");
    private static final Pattern PASSWORD_PATTERN =
            Pattern.compile("^(?=.*[A-Za-z])(?=.*[0-9]).{8,64}$");

    private static final List<String> GENDERS =
            Arrays.asList("Male", "Female", "Other");
    private static final List<String> BLOOD_GROUPS =
            Arrays.asList("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-");

    private UserDAO userDAO;
    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {

        userDAO = new UserDAOImpl();
        patientDAO = new PatientDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = clean(request.getParameter("fullName"));
        String email = clean(request.getParameter("email")).toLowerCase();
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = clean(request.getParameter("phone"));

        String dateOfBirth = clean(request.getParameter("dateOfBirth"));
        String gender = clean(request.getParameter("gender"));
        String bloodGroup = clean(request.getParameter("bloodGroup"));
        String address = clean(request.getParameter("address"));

        String emergencyContactName =
                clean(request.getParameter("emergencyContactName"));

        String emergencyContactPhone =
                clean(request.getParameter("emergencyContactPhone"));

        // Server-side validation: never trust the browser checks alone.
        String validationError = validate(fullName, email, password,
                confirmPassword, phone, dateOfBirth, gender, bloodGroup,
                address, emergencyContactName, emergencyContactPhone);

        if (validationError != null) {
            request.setAttribute("formError", validationError);
            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        try {

            // Check whether email already exists

            User existingUser = userDAO.getUserByEmail(email);

            if (existingUser != null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/register.jsp?error=emailExists");

                return;
            }

            // Create User

            User user = new User();

            user.setFullName(fullName);
            user.setEmail(email);
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setPhone(phone);
            user.setRole("PATIENT");
            user.setStatus("ACTIVE");

            boolean userAdded = userDAO.addUser(user);

            if (!userAdded) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/register.jsp?error=registrationFailed");

                return;
            }

            // Get newly created User using email

            User createdUser = userDAO.getUserByEmail(email);

            if (createdUser == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/register.jsp?error=registrationFailed");

                return;
            }

            // Create Patient

            Patient patient = new Patient();

            patient.setUserId(createdUser.getUserId());

            patient.setDateOfBirth(Date.valueOf(dateOfBirth));

            patient.setGender(gender);
            patient.setBloodGroup(bloodGroup);
            patient.setAddress(address);
            patient.setEmergencyContactName(
                    emergencyContactName);
            patient.setEmergencyContactPhone(
                    emergencyContactPhone);

            boolean patientAdded =
                    patientDAO.addPatient(patient);

            if (patientAdded) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/login.jsp?registered=success");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/register.jsp?error=patientCreationFailed");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/register.jsp?error=registrationFailed");
        }
    }

    private static String clean(String value) {
        return value == null ? "" : value.trim().replaceAll("\\s{2,}", " ");
    }

    private static String validate(String fullName, String email,
            String password, String confirmPassword, String phone,
            String dateOfBirth, String gender, String bloodGroup,
            String address, String emergencyContactName,
            String emergencyContactPhone) {

        if (!NAME_PATTERN.matcher(fullName).matches()) {
            return "Please enter a valid full name (letters only, at least 2 characters).";
        }
        if (email.length() > 150 || !EMAIL_PATTERN.matcher(email).matches()) {
            return "Please enter a valid email address.";
        }
        if (!PHONE_PATTERN.matcher(phone).matches()) {
            return "Please enter a valid 10-digit mobile number.";
        }
        if (password == null || !PASSWORD_PATTERN.matcher(password).matches()) {
            return "Password must be 8-64 characters with at least one letter and one number.";
        }
        if (!password.equals(confirmPassword)) {
            return "Passwords do not match.";
        }

        LocalDate dob;
        try {
            dob = LocalDate.parse(dateOfBirth);
        } catch (DateTimeParseException e) {
            return "Please enter a valid date of birth.";
        }
        LocalDate today = LocalDate.now();
        if (dob.isAfter(today) || dob.isBefore(today.minusYears(120))) {
            return "Date of birth cannot be in the future or more than 120 years ago.";
        }

        if (!GENDERS.contains(gender)) {
            return "Please select your gender.";
        }
        if (!BLOOD_GROUPS.contains(bloodGroup)) {
            return "Please select your blood group.";
        }
        if (address.length() < 10 || address.length() > 500) {
            return "Please enter your full address (10-500 characters).";
        }
        if (!NAME_PATTERN.matcher(emergencyContactName).matches()) {
            return "Please enter a valid emergency contact name.";
        }
        if (!PHONE_PATTERN.matcher(emergencyContactPhone).matches()) {
            return "Please enter a valid emergency contact number.";
        }
        if (emergencyContactPhone.equals(phone)) {
            return "Emergency contact number must be different from your own number.";
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/register.jsp");
    }
}