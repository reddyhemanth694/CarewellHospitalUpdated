<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%!
    /* Escapes user input before printing it back into the form. */
    private static String esc(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;")
                    .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    /* When the server rejects the form it forwards back here,
       so we can keep what the user already typed (except passwords). */
    String formError = (String) request.getAttribute("formError");
    String errorParam = request.getParameter("error");
    boolean refill = formError != null;

    String vFullName = refill ? esc(request.getParameter("fullName")) : "";
    String vEmail = refill ? esc(request.getParameter("email")) : "";
    String vPhone = refill ? esc(request.getParameter("phone")) : "";
    String vDob = refill ? esc(request.getParameter("dateOfBirth")) : "";
    String vGender = refill ? request.getParameter("gender") : null;
    String vBlood = refill ? request.getParameter("bloodGroup") : null;
    String vAddress = refill ? esc(request.getParameter("address")) : "";
    String vEcName = refill ? esc(request.getParameter("emergencyContactName")) : "";
    String vEcPhone = refill ? esc(request.getParameter("emergencyContactPhone")) : "";

    String[] genders = {"Male", "Female", "Other"};
    String[] bloodGroups = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account | CareWell Hospital</title>
    <meta name="description" content="Create your CareWell Hospital patient account to book appointments and view prescriptions, records and bills.">
    <link rel="icon" type="image/svg+xml"
          href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Crect width='64' height='64' rx='14' fill='%231266e8'/%3E%3Cpath d='M32 50s-16-9.6-16-21.2C16 22.3 20.7 18 26 18c2.9 0 4.9 1.4 6 3.3 1.1-1.9 3.1-3.3 6-3.3 5.3 0 10 4.3 10 10.8C48 40.4 32 50 32 50z' fill='%23fff'/%3E%3C/svg%3E">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/register.css">
</head>

<body>
    <main class="register-page">
        <section class="register-card">

            <header class="register-header">
                <div class="register-topbar">
                    <a class="brand" href="${pageContext.request.contextPath}/index.jsp"
                       aria-label="Back to CareWell Hospital home page">
                        <div class="brand-icon"><i class="fa-solid fa-heart-pulse" aria-hidden="true"></i></div>
                        <div>
                            <div class="brand-name">CareWell</div>
                            <div class="brand-caption">HOSPITAL</div>
                        </div>
                    </a>

                    <a class="back-home-link" href="${pageContext.request.contextPath}/index.jsp">
                        <i class="fa-solid fa-arrow-left" aria-hidden="true"></i> Home
                    </a>
                </div>

                <span class="secure-label"><i class="fa-solid fa-lock" aria-hidden="true"></i> Secure Registration</span>

                <h1>Create your account</h1>
                <p class="subtitle">
                    Join CareWell Hospital to manage your healthcare
                    information and appointments.
                </p>

                <div class="account-badge">
                    <span class="badge-icon"><i class="fa-solid fa-hospital-user" aria-hidden="true"></i></span>
                    <div>
                        <strong>Patient Registration</strong>
                        <small>Create your personal patient account</small>
                    </div>
                </div>
            </header>

            <div class="form-content">

                <% if (formError != null) { %>
                    <div class="form-alert error-message" role="alert">
                        <%= esc(formError) %>
                    </div>
                <% } else if ("emailExists".equals(errorParam)) { %>
                    <div class="form-alert error-message" role="alert">
                        An account with this email already exists.
                        Please <a href="${pageContext.request.contextPath}/login.jsp">sign in</a>
                        or use another email.
                    </div>
                <% } else if ("patientCreationFailed".equals(errorParam)) { %>
                    <div class="form-alert error-message" role="alert">
                        Your account could not be fully created.
                        Please try again or contact support.
                    </div>
                <% } else if ("registrationFailed".equals(errorParam)) { %>
                    <div class="form-alert error-message" role="alert">
                        Registration failed. Please check your details and try again.
                    </div>
                <% } %>

                <div class="section-heading">
                    <h2>Personal information</h2>
                    <p>Enter your details as they appear on your records.</p>
                </div>

                <form id="registerForm"
                      action="${pageContext.request.contextPath}/register"
                      method="post" novalidate>

                    <div class="form-grid">

                        <div class="form-field full-width">
                            <label for="fullName">Full name <span>*</span></label>
                            <input id="fullName" type="text" name="fullName"
                                   placeholder="Enter your full name"
                                   autocomplete="name" minlength="2" maxlength="100"
                                   pattern="[A-Za-z][A-Za-z .'\-]{1,99}"
                                   data-error="Use letters only (spaces, . ' - allowed), at least 2 characters."
                                   value="<%= vFullName %>" required>
                            <small class="field-error" aria-live="polite"></small>
                        </div>

                        <div class="form-field">
                            <label for="email">Email address <span>*</span></label>
                            <input id="email" type="email" name="email"
                                   placeholder="you@example.com"
                                   autocomplete="email" maxlength="150"
                                   pattern="[^@\s]+@[^@\s]+\.[A-Za-z]{2,}"
                                   data-error="Enter a valid email, e.g. name@gmail.com."
                                   value="<%= vEmail %>" required>
                            <small class="field-error" aria-live="polite"></small>
                        </div>

                        <div class="form-field">
                            <label for="phone">Phone number <span>*</span></label>
                            <input id="phone" type="tel" name="phone"
                                   placeholder="10-digit mobile number"
                                   pattern="[6-9][0-9]{9}" minlength="10"
                                   maxlength="10" inputmode="numeric"
                                   autocomplete="tel-national"
                                   data-error="Enter a valid 10-digit Indian mobile number starting with 6-9."
                                   value="<%= vPhone %>" required>
                            <small class="field-error" aria-live="polite"></small>
                        </div>

                        <div class="form-field">
                            <label for="password">Password <span>*</span></label>
                            <div class="password-input-wrapper">
                                <input id="password" type="password" name="password"
                                       placeholder="At least 8 characters"
                                       minlength="8" maxlength="64"
                                       pattern="(?=.*[A-Za-z])(?=.*[0-9]).{8,64}"
                                       autocomplete="new-password"
                                       data-error="Use 8-64 characters with at least one letter and one number."
                                       required>
                                <button type="button" class="password-toggle"
                                        data-target="password"
                                        aria-label="Show password" aria-pressed="false">
                                    <i class="fa-regular fa-eye" aria-hidden="true"></i>
                                </button>
                            </div>
                            <small class="field-hint">
                                8+ characters, with at least one letter and one number.
                            </small>
                            <small class="field-error" aria-live="polite"></small>
                        </div>

                        <div class="form-field">
                            <label for="confirmPassword">Confirm password <span>*</span></label>
                            <div class="password-input-wrapper">
                                <input id="confirmPassword" type="password"
                                       name="confirmPassword"
                                       placeholder="Re-enter your password"
                                       autocomplete="new-password"
                                       data-error="Passwords do not match."
                                       required>
                                <button type="button" class="password-toggle"
                                        data-target="confirmPassword"
                                        aria-label="Show password" aria-pressed="false">
                                    <i class="fa-regular fa-eye" aria-hidden="true"></i>
                                </button>
                            </div>
                            <small class="field-error" aria-live="polite"></small>
                        </div>

                        <div class="form-field">
                            <label for="dateOfBirth">Date of birth <span>*</span></label>
                            <input id="dateOfBirth" type="date" name="dateOfBirth"
                                   autocomplete="bday"
                                   data-error="Enter a real date of birth (not in the future, not more than 120 years ago)."
                                   value="<%= vDob %>" required>
                            <small class="field-error" aria-live="polite"></small>
                        </div>

                        <div class="form-field">
                            <label for="gender">Gender <span>*</span></label>
                            <select id="gender" name="gender" required
                                    data-error="Please select your gender.">
                                <option value="">Select gender</option>
                                <% for (String g : genders) { %>
                                    <option value="<%= g %>" <%= g.equals(vGender) ? "selected" : "" %>><%= g %></option>
                                <% } %>
                            </select>
                            <small class="field-error" aria-live="polite"></small>
                        </div>

                        <div class="form-field">
                            <label for="bloodGroup">Blood group <span>*</span></label>
                            <select id="bloodGroup" name="bloodGroup" required
                                    data-error="Please select your blood group.">
                                <option value="">Select blood group</option>
                                <% for (String bg : bloodGroups) { %>
                                    <option value="<%= bg %>" <%= bg.equals(vBlood) ? "selected" : "" %>><%= bg %></option>
                                <% } %>
                            </select>
                            <small class="field-error" aria-live="polite"></small>
                        </div>

                        <div class="form-field full-width">
                            <label for="address">Residential address <span>*</span></label>
                            <textarea id="address" name="address" rows="3"
                                      placeholder="House / flat, street, area, city, PIN code"
                                      minlength="10" maxlength="500" autocomplete="street-address"
                                      data-error="Enter your full address (at least 10 characters)."
                                      required><%= vAddress %></textarea>
                            <small class="field-error" aria-live="polite"></small>
                        </div>

                    </div>

                    <div class="section-heading emergency-heading">
                        <h2>Emergency contact</h2>
                        <p>Provide someone we can contact when necessary.</p>
                    </div>

                    <div class="form-grid">
                        <div class="form-field">
                            <label for="emergencyContactName">
                                Contact person's name <span>*</span>
                            </label>
                            <input id="emergencyContactName" type="text"
                                   name="emergencyContactName"
                                   placeholder="Enter contact person's name"
                                   minlength="2" maxlength="100"
                                   pattern="[A-Za-z][A-Za-z .'\-]{1,99}"
                                   data-error="Use letters only (spaces, . ' - allowed), at least 2 characters."
                                   value="<%= vEcName %>" required>
                            <small class="field-error" aria-live="polite"></small>
                        </div>

                        <div class="form-field">
                            <label for="emergencyContactPhone">
                                Contact phone number <span>*</span>
                            </label>
                            <input id="emergencyContactPhone" type="tel"
                                   name="emergencyContactPhone"
                                   placeholder="10-digit mobile number"
                                   pattern="[6-9][0-9]{9}" minlength="10"
                                   maxlength="10" inputmode="numeric"
                                   data-error="Enter a valid 10-digit mobile number that is different from your own."
                                   value="<%= vEcPhone %>" required>
                            <small class="field-error" aria-live="polite"></small>
                        </div>
                    </div>

                    <div class="privacy-note">
                        <span class="privacy-icon"><i class="fa-solid fa-shield-halved" aria-hidden="true"></i></span>
                        <p>
                            Your information is used only to manage your
                            patient account and healthcare services.
                        </p>
                    </div>

                    <button type="submit" class="submit-btn" id="submitBtn">
                        Create Patient Account
                        <span aria-hidden="true">→</span>
                    </button>

                </form>

                <p class="login-link">
                    Already have an account?
                    <a href="${pageContext.request.contextPath}/login.jsp">
                        Sign in
                    </a>
                </p>

            </div>

            <footer class="register-footer">
                CareWell Hospital · Your health, our priority.
            </footer>

        </section>
    </main>

    <script>
        (function () {
            var form = document.getElementById("registerForm");
            var password = document.getElementById("password");
            var confirm = document.getElementById("confirmPassword");
            var dob = document.getElementById("dateOfBirth");
            var phone = document.getElementById("phone");
            var ecPhone = document.getElementById("emergencyContactPhone");

            /* Date of birth: no future dates, max age 120 */
            function isoDate(d) {
                var m = String(d.getMonth() + 1).padStart(2, "0");
                var day = String(d.getDate()).padStart(2, "0");
                return d.getFullYear() + "-" + m + "-" + day;
            }
            var today = new Date();
            var oldest = new Date(today.getFullYear() - 120, today.getMonth(), today.getDate());
            dob.max = isoDate(today);
            dob.min = isoDate(oldest);

            /* Phone fields: digits only while typing */
            [phone, ecPhone].forEach(function (input) {
                input.addEventListener("input", function () {
                    input.value = input.value.replace(/\D/g, "").slice(0, 10);
                });
            });

            /* Show / hide password buttons */
            document.querySelectorAll(".password-toggle").forEach(function (btn) {
                btn.addEventListener("click", function () {
                    var input = document.getElementById(btn.dataset.target);
                    var show = input.type === "password";
                    input.type = show ? "text" : "password";
                    btn.querySelector("i").className = show ? "fa-regular fa-eye-slash" : "fa-regular fa-eye";
                    btn.setAttribute("aria-label", show ? "Hide password" : "Show password");
                    btn.setAttribute("aria-pressed", String(show));
                });
            });

            function runCustomChecks() {
                confirm.setCustomValidity(
                    confirm.value && confirm.value !== password.value ? "mismatch" : "");
                ecPhone.setCustomValidity(
                    ecPhone.value && ecPhone.value === phone.value ? "same" : "");
                form.querySelectorAll("input[type=text], textarea").forEach(function (el) {
                    var blank = el.required && el.value.trim().length === 0 && el.value.length > 0;
                    var tooShort = el.minLength > 0 && el.value.trim().length > 0
                                   && el.value.trim().length < el.minLength;
                    el.setCustomValidity(blank || tooShort ? "invalid" : "");
                });
            }

            function showError(field) {
                var box = field.closest(".form-field").querySelector(".field-error");
                if (!box) return;
                if (field.validity.valid) {
                    box.textContent = "";
                    field.classList.remove("is-invalid");
                    field.removeAttribute("aria-invalid");
                } else {
                    box.textContent = field.validity.valueMissing
                        ? "This field is required."
                        : (field.dataset.error || field.validationMessage);
                    field.classList.add("is-invalid");
                    field.setAttribute("aria-invalid", "true");
                }
            }

            var fields = form.querySelectorAll("input:not([type=hidden]), select, textarea");

            fields.forEach(function (field) {
                field.addEventListener("blur", function () {
                    runCustomChecks();
                    showError(field);
                });
                field.addEventListener("input", function () {
                    if (field.classList.contains("is-invalid")) {
                        runCustomChecks();
                        showError(field);
                    }
                });
            });

            form.addEventListener("submit", function (event) {
                /* Trim spaces so "   " is never accepted */
                form.querySelectorAll("input[type=text], input[type=email], textarea").forEach(function (el) {
                    el.value = el.value.trim();
                });
                runCustomChecks();

                var firstInvalid = null;
                fields.forEach(function (field) {
                    showError(field);
                    if (!field.validity.valid && !firstInvalid) firstInvalid = field;
                });

                if (firstInvalid) {
                    event.preventDefault();
                    firstInvalid.focus();
                    return;
                }

                var btn = document.getElementById("submitBtn");
                btn.disabled = true;
                btn.firstChild.textContent = "Creating account… ";
            });
        })();
    </script>
</body>
</html>
