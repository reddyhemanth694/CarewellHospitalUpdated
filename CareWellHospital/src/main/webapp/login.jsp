<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.model.User"%>
<%!
    /* Only allow redirects to the patient booking page (prevents open redirects). */
    private static String safeNext(String next) {
        if (next == null) return "";
        next = next.trim();
        if (!next.startsWith("/patient/book-appointment.jsp")) return "";
        if (next.contains("//") || next.contains("\\") || next.contains("\r") || next.contains("\n")) return "";
        return next;
    }

    private static String esc(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;")
                    .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    String nextPage = safeNext(request.getParameter("next"));
    User signedInUser = (User) session.getAttribute("user");

    if (signedInUser != null && !nextPage.isEmpty()
            && "PATIENT".equalsIgnoreCase(signedInUser.getRole())) {
        response.sendRedirect(request.getContextPath() + nextPage);
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>CareWell Hospital | Login</title>
    <meta name="description" content="Sign in to the CareWell Hospital portal for patients, doctors and staff.">
    <link rel="icon" type="image/svg+xml"
          href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Crect width='64' height='64' rx='14' fill='%231266e8'/%3E%3Cpath d='M32 50s-16-9.6-16-21.2C16 22.3 20.7 18 26 18c2.9 0 4.9 1.4 6 3.3 1.1-1.9 3.1-3.3 6-3.3 5.3 0 10 4.3 10 10.8C48 40.4 32 50 32 50z' fill='%23fff'/%3E%3C/svg%3E">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <!-- CareWell CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

</head>

<body>

<div class="auth-page">

    <div class="auth-container">

        <!-- =================================================
             LEFT BRAND SECTION
             ================================================= -->

        <div class="auth-brand">

            <a class="auth-logo" href="${pageContext.request.contextPath}/index.jsp"
               aria-label="Back to CareWell Hospital home page">

                <div class="auth-logo-icon">
                    <i class="fa-solid fa-heart-pulse" aria-hidden="true"></i>
                </div>

                <div>
                    <h2>CareWell</h2>
                    <span>Hospital</span>
                </div>

            </a>


            <h1>
                Your Health.<br>
                Our Priority.
            </h1>

            <p>
                Welcome to CareWell Hospital Management System.
                Manage appointments, doctors, medical records,
                prescriptions and healthcare services in one place.
            </p>


            <div class="auth-features">

                <div class="auth-feature">

                    <i class="fa-solid fa-user-doctor"></i>

                    <span>
                        Experienced & Trusted Doctors
                    </span>

                </div>


                <div class="auth-feature">

                    <i class="fa-solid fa-calendar-check"></i>

                    <span>
                        Easy Appointment Management
                    </span>

                </div>


                <div class="auth-feature">

                    <i class="fa-solid fa-shield-heart"></i>

                    <span>
                        Secure Patient Records
                    </span>

                </div>


                <div class="auth-feature">

                    <i class="fa-solid fa-clock"></i>

                    <span>
                        Quality Healthcare, Anytime
                    </span>

                </div>

            </div>

        </div>


        <!-- =================================================
             LOGIN FORM
             ================================================= -->

        <div class="auth-form">

            <a class="back-home" href="${pageContext.request.contextPath}/index.jsp">
                <i class="fa-solid fa-arrow-left" aria-hidden="true"></i>
                Back to home
            </a>

            <h2>Welcome Back 👋</h2>

            <p>
                Sign in to continue to your CareWell account.
            </p>


            <!-- Success Message -->

            <%
                String registered = request.getParameter("registered");

                if ("success".equals(registered)) {
            %>

                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    Registration successful. Please login.
                </div>

            <%
                }
            %>


            <!-- Logout Message -->

            <%
                String logout = request.getParameter("logout");

                if ("success".equals(logout)) {
            %>

                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    You have been logged out successfully.
                </div>

            <%
                }
            %>


            <!-- Error Message -->

            <%
                String error = request.getParameter("error");

                if ("invalid".equals(error)) {
            %>

                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    Invalid email or password.
                </div>

            <%
                } else if ("invalidRole".equals(error)) {
            %>

                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    Invalid user role.
                </div>

            <%
                } else if ("loginFailed".equals(error)) {
            %>

                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    We couldn't sign you in right now. Please try again.
                </div>

            <%
                }
            %>

			
			<%
    if ("success".equals(request.getParameter("reset"))) {
%>
    <div class="alert alert-success">
        Your password has been reset successfully. Please log in.
    </div>
<%
    }
%>

            <!-- Login Form -->

            <form action="${pageContext.request.contextPath}/login"
                  method="post">

                <% if (!nextPage.isEmpty()) { %>
                    <input type="hidden" name="next" value="<%= esc(nextPage) %>">
                <% } %>


                <!-- Email -->

                <div class="form-group">

                    <label for="email">
                        <i class="fa-regular fa-envelope"></i>
                        Email Address
                    </label>

                    <input
                        type="email"
                        id="email"
                        name="email"
                        class="form-control"
                        placeholder="Enter your email address"
                        autocomplete="email"
                        maxlength="150"
                        required>

                </div>


                <!-- Password -->

                
<div class="form-group">
    <label for="password">
        <i class="fa-solid fa-lock"></i>
        Password
    </label>

    <div class="password-input-wrapper">
        <input
            type="password"
            id="password"
            name="password"
            class="form-control"
            placeholder="Enter your password"
            autocomplete="current-password"
            required>

        <button
            type="button"
            id="togglePassword"
            class="password-toggle"
            aria-label="Show password"
            aria-pressed="false">
            <i class="fa-regular fa-eye" aria-hidden="true"></i>
        </button>
    </div>
</div>
                


                <!-- Remember / Forgot -->

                <div class="auth-options">

                    <label class="remember-label">
                        <input type="checkbox" name="remember" value="true">
                        Keep me signed in for 7 days
                    </label>

                    <a href="${pageContext.request.contextPath}/forgot-password">
                        Forgot Password?
                    </a>

                </div>


                <!-- Login Button -->

                <button type="submit"
                        class="btn btn-primary">

                    <i class="fa-solid fa-right-to-bracket"></i>

                    Sign In

                </button>

            </form>


            <!-- Register -->

            <div class="auth-footer">

                Don't have an account?

                <a href="${pageContext.request.contextPath}/register.jsp">
                    Create an account
                </a>

            </div>

        </div>

    </div>

</div>


<script>
    const passwordInput = document.getElementById("password");
    const togglePassword = document.getElementById("togglePassword");
    const eyeIcon = togglePassword.querySelector("i");

    togglePassword.addEventListener("click", function () {
        const isHidden = passwordInput.type === "password";

        passwordInput.type = isHidden ? "text" : "password";
        eyeIcon.classList.toggle("fa-eye", !isHidden);
        eyeIcon.classList.toggle("fa-eye-slash", isHidden);

        togglePassword.setAttribute(
            "aria-label",
            isHidden ? "Hide password" : "Show password"
        );

        togglePassword.setAttribute("aria-pressed", String(isHidden));
    });
</script>
</body>
</html>
