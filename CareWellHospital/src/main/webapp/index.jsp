<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.nio.charset.StandardCharsets"%>
<%@ page import="com.dao.FeaturedDoctorDAO"%>
<%@ page import="com.daoimpl.FeaturedDoctorDAOImpl"%>
<%@ page import="com.model.FeaturedDoctor"%>

<%!
    /* Escapes text before printing it into HTML (prevents broken markup / XSS). */
    private static String esc(String value) {
        if (value == null) return "";
        StringBuilder out = new StringBuilder(value.length());
        for (char c : value.toCharArray()) {
            switch (c) {
                case '<': out.append("&lt;"); break;
                case '>': out.append("&gt;"); break;
                case '&': out.append("&amp;"); break;
                case '"': out.append("&quot;"); break;
                case '\'': out.append("&#39;"); break;
                default: out.append(c);
            }
        }
        return out.toString();
    }

    /* Builds a login link that sends the patient to the booking page after sign-in. */
    private static String bookLink(String contextPath, String query) {
        String next = "/patient/book-appointment.jsp" + (query == null ? "" : "?" + query);
        return contextPath + "/login.jsp?next=" + URLEncoder.encode(next, StandardCharsets.UTF_8);
    }
%>

<%
    FeaturedDoctorDAO featuredDoctorDAO = new FeaturedDoctorDAOImpl();
    List<FeaturedDoctor> featuredDoctors = featuredDoctorDAO.getFeaturedDoctors();
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CareWell Hospital | Your Health, Our Priority</title>
<meta name="description"
	content="CareWell Hospital - book appointments with experienced doctors in cardiology, neurology, orthopedics, pediatrics and more. Manage appointments, prescriptions and bills online.">
<meta name="theme-color" content="#1266e8">
<meta property="og:type" content="website">
<meta property="og:title" content="CareWell Hospital | Your Health, Our Priority">
<meta property="og:description"
	content="Book appointments with experienced doctors and manage your care online.">
<link rel="icon" type="image/svg+xml"
	href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Crect width='64' height='64' rx='14' fill='%231266e8'/%3E%3Cpath d='M32 50s-16-9.6-16-21.2C16 22.3 20.7 18 26 18c2.9 0 4.9 1.4 6 3.3 1.1-1.9 3.1-3.3 6-3.3 5.3 0 10 4.3 10 10.8C48 40.4 32 50 32 50z' fill='%23fff'/%3E%3C/svg%3E">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet" href="<%= ctx %>/css/home.css">
</head>
<body>

	<header class="navbar">
		<a href="<%= ctx %>/index.jsp" class="brand" aria-label="CareWell Hospital home">
			<span class="brand-icon"><i class="fa-solid fa-heart-pulse" aria-hidden="true"></i></span>
			<span>CareWell<span class="brand-highlight"> Hospital</span></span>
		</a>

		<button type="button" class="nav-toggle" id="navToggle"
			aria-label="Open menu" aria-expanded="false" aria-controls="mainNav">
			<i class="fa-solid fa-bars" aria-hidden="true"></i>
		</button>

		<nav class="nav-links" id="mainNav" aria-label="Main">
			<a href="#home">Home</a>
			<a href="#services">Services</a>
			<a href="#doctors">Our Doctors</a>
			<a href="#about">About Us</a>
			<a href="#contact">Contact</a>
			<a class="nav-login nav-login-mobile" href="<%= ctx %>/login.jsp">Login / Portal</a>
		</nav>

		<a class="nav-login nav-login-desktop" href="<%= ctx %>/login.jsp">Login / Portal</a>
	</header>

	<main>
		<!-- Hero Section -->
		<section class="hero" id="home">
			<div class="hero-content">
				<span class="eyebrow">WELCOME TO CAREWELL HOSPITAL</span>

				<h1>
					Your Health Deserves <span>Exceptional Care.</span>
				</h1>

				<p>Discover compassionate healthcare, personalized attention,
					and convenient access to the care you need. Your well-being is our
					priority.</p>

				<div class="hero-actions">
					<a class="btn btn-primary" href="<%= bookLink(ctx, null) %>">
						Book an Appointment <span aria-hidden="true">→</span>
					</a>
					<a class="btn btn-secondary" href="#services">Explore Our Services</a>
				</div>

				<div class="hero-note">
					<span class="note-icon"><i class="fa-solid fa-hand-holding-heart" aria-hidden="true"></i></span>
					<div>
						<strong>Care that puts you first</strong>
						<p>Supporting you throughout your healthcare journey.</p>
					</div>
				</div>
			</div>

			<div class="hero-visual" aria-hidden="true">
				<div class="hero-image">
					<div class="medical-symbol"><i class="fa-solid fa-heart-pulse"></i></div>
					<div class="image-caption">
						<span class="caption-icon"><i class="fa-solid fa-shield-heart"></i></span>
						<div>
							<strong>Your Care, Our Commitment</strong>
							<p>Here for your health journey</p>
						</div>
					</div>
				</div>

				<div class="floating-card">
					<span class="floating-icon"><i class="fa-solid fa-user-doctor"></i></span>
					<div>
						<strong>Personalized Care</strong>
						<p>Focused on your well-being</p>
					</div>
				</div>
			</div>
		</section>

		<!-- Database-driven Doctors Section -->
		<section class="section doctors-section" id="doctors">
			<div class="section-heading">
				<span class="eyebrow">OUR MEDICAL TEAM</span>
				<h2>Meet Our Experienced Doctors</h2>
				<p>Get expert medical care from our dedicated healthcare
					professionals.</p>
			</div>

			<div class="doctors-grid">
				<%
                if (featuredDoctors != null && !featuredDoctors.isEmpty()) {
                    for (FeaturedDoctor doctor : featuredDoctors) {
                        String imagePath = doctor.getProfileImage();
                        String imageUrl = null;

                        if (imagePath != null && !imagePath.trim().isEmpty()) {
                            imagePath = imagePath.trim().replace("\\", "/");
                            if (imagePath.startsWith("https://") || imagePath.startsWith("http://")) {
                                imageUrl = imagePath;
                            } else {
                                imagePath = imagePath.replaceFirst("^/+", "");
                                imageUrl = ctx + "/" + imagePath;
                            }
                        }

                        String doctorName = doctor.getFullName() != null
                                ? doctor.getFullName() : "Medical Professional";
                        String specialization = doctor.getSpecialization() != null
                                ? doctor.getSpecialization() : "General Healthcare";
                        String availability = doctor.getAvailabilityStatus();
                        boolean available = availability != null
                                && availability.equalsIgnoreCase("AVAILABLE");
            %>
				<article class="doctor-card">
					<div class="doctor-image-wrapper">
						<% if (imageUrl != null) { %>
						<img src="<%= esc(imageUrl) %>"
							alt="Photo of <%= esc(doctorName) %>, <%= esc(specialization) %>"
							class="doctor-image" loading="lazy" width="300" height="250">
						<% } else { %>
						<div class="doctor-image-placeholder">
							<i class="fa-solid fa-user-doctor" aria-hidden="true"></i>
						</div>
						<% } %>
					</div>

					<div class="doctor-card-content">
						<h3><%= esc(doctorName) %></h3>
						<p class="doctor-specialization"><%= esc(specialization) %></p>
						<p class="doctor-qualification"><%= esc(doctor.getQualification()) %></p>
						<p class="doctor-experience">
							<%= doctor.getExperienceYears() %> years of experience
						</p>

						<div class="doctor-card-footer">
							<% if (available) { %>
							<span class="doctor-status available">Available</span>
							<% } else { %>
							<span class="doctor-status">Contact for availability</span>
							<% } %>
							<a class="doctor-book"
								href="<%= bookLink(ctx, "doctorId=" + doctor.getDoctorId()) %>"
								aria-label="Book an appointment with <%= esc(doctorName) %>">
								Book <span aria-hidden="true">→</span>
							</a>
						</div>
					</div>
				</article>
				<%
                    }
                } else {
            %>
				<div class="doctors-empty-state">
					<h3>Our medical team is here for you</h3>
					<p>Doctor profiles will appear here when active doctor records
						are available.</p>
				</div>
				<% } %>
			</div>
		</section>

		<!-- Services Section -->
		<section class="section services-section" id="services">
			<div class="section-heading">
				<span class="eyebrow">HEALTHCARE SERVICES</span>
				<h2>Care for Every Stage of Life</h2>
				<p>Explore healthcare specialties and find the support that fits
					your needs.</p>
			</div>

			<div class="service-grid">
				<article class="service-card">
					<div class="service-icon blue"><i class="fa-solid fa-heart-pulse" aria-hidden="true"></i></div>
					<h3>Cardiology</h3>
					<p>Healthcare focused on heart health and cardiovascular
						well-being.</p>
					<a href="<%= bookLink(ctx, "dept=Cardiology") %>">Book Cardiology →</a>
				</article>

				<article class="service-card">
					<div class="service-icon purple"><i class="fa-solid fa-brain" aria-hidden="true"></i></div>
					<h3>Neurology</h3>
					<p>Care and consultation for conditions affecting the nervous
						system.</p>
					<a href="<%= bookLink(ctx, "dept=Neurology") %>">Book Neurology →</a>
				</article>

				<article class="service-card">
					<div class="service-icon green"><i class="fa-solid fa-bone" aria-hidden="true"></i></div>
					<h3>Orthopedics</h3>
					<p>Support for bone, joint, muscle, and mobility concerns.</p>
					<a href="<%= bookLink(ctx, "dept=Orthopedics") %>">Book Orthopedics →</a>
				</article>

				<article class="service-card">
					<div class="service-icon orange"><i class="fa-solid fa-baby" aria-hidden="true"></i></div>
					<h3>Pediatrics</h3>
					<p>Healthcare guidance for infants, children, and adolescents.</p>
					<a href="<%= bookLink(ctx, "dept=Pediatrics") %>">Book Pediatrics →</a>
				</article>

				<article class="service-card">
					<div class="service-icon pink"><i class="fa-solid fa-stethoscope" aria-hidden="true"></i></div>
					<h3>General Medicine</h3>
					<p>Consultations for common health concerns and ongoing care.</p>
					<a href="<%= bookLink(ctx, "dept=General") %>">Book a consultation →</a>
				</article>

				<article class="service-card">
					<div class="service-icon teal"><i class="fa-solid fa-microscope" aria-hidden="true"></i></div>
					<h3>Diagnostics</h3>
					<p>Explore diagnostic services and discuss your testing needs.</p>
					<a href="<%= bookLink(ctx, "dept=Diagnostic") %>">Book a test consultation →</a>
				</article>
			</div>
		</section>

		<!-- About Section -->
		<section class="about-section" id="about">
			<div class="about-visual" aria-hidden="true">
				<div class="about-symbol"><i class="fa-solid fa-hospital"></i></div>
				<span>CAREWELL HOSPITAL</span>
				<p>Every patient matters.</p>
			</div>

			<div class="about-content">
				<span class="eyebrow">ABOUT CAREWELL</span>
				<h2>Healthcare Made More Accessible</h2>
				<p>CareWell is a multi-specialty hospital focused on
					compassionate, organized care. From your first appointment to
					prescriptions and bills, everything is available in one secure
					patient portal.</p>

				<ul class="benefit-list">
					<li><span><i class="fa-solid fa-check" aria-hidden="true"></i></span> Online appointment booking with specialists</li>
					<li><span><i class="fa-solid fa-check" aria-hidden="true"></i></span> Digital prescriptions and medical records</li>
					<li><span><i class="fa-solid fa-check" aria-hidden="true"></i></span> Appointment reminders by email</li>
					<li><span><i class="fa-solid fa-check" aria-hidden="true"></i></span> Transparent billing and online payments</li>
				</ul>

				<a class="btn btn-primary" href="<%= ctx %>/register.jsp">
					Create a Patient Account <span aria-hidden="true">→</span>
				</a>
			</div>
		</section>

		<!-- Contact / Visit Section
		     TODO (student): replace the sample address and phone numbers below
		     with your own details before presenting the project. -->
		<section class="section contact-section" id="contact">
			<div class="section-heading">
				<span class="eyebrow">VISIT &amp; CONTACT</span>
				<h2>We're Here When You Need Us</h2>
				<p>Reach our front desk, find us, or call for an emergency.</p>
			</div>

			<div class="contact-grid">
				<div class="contact-card emergency">
					<span class="contact-icon"><i class="fa-solid fa-truck-medical" aria-hidden="true"></i></span>
					<h3>Emergency</h3>
					<p>24 × 7 emergency care</p>
					<a href="tel:108">Call 108 (Ambulance)</a>
				</div>

				<div class="contact-card">
					<span class="contact-icon"><i class="fa-solid fa-phone" aria-hidden="true"></i></span>
					<h3>Front Desk</h3>
					<p>Appointments &amp; enquiries</p>
					<a href="tel:+918000000000">+91 80 0000 0000</a>
				</div>

				<div class="contact-card">
					<span class="contact-icon"><i class="fa-solid fa-clock" aria-hidden="true"></i></span>
					<h3>OPD Timings</h3>
					<p>Mon – Sat: 9:00 AM – 6:00 PM</p>
					<p>Sunday: 10:00 AM – 1:00 PM</p>
				</div>

				<div class="contact-card">
					<span class="contact-icon"><i class="fa-solid fa-location-dot" aria-hidden="true"></i></span>
					<h3>Address</h3>
					<p>123 Health Avenue, Bengaluru, Karnataka 560001</p>
					<a href="mailto:care@carewellhospital.example">care@carewellhospital.example</a>
				</div>
			</div>
		</section>

		<!-- Call to Action -->
		<section class="cta-section">
			<div>
				<span class="eyebrow">TAKE THE NEXT STEP</span>
				<h2>Your Health Journey Starts Here.</h2>
				<p>Book your first appointment in under a minute.</p>
			</div>
			<a class="btn btn-light" href="<%= bookLink(ctx, null) %>">
				Book an Appointment <span aria-hidden="true">→</span>
			</a>
		</section>
	</main>

	<!-- Footer -->
	<footer class="footer">
		<div class="footer-main">
			<div class="footer-brand">
				<a href="<%= ctx %>/index.jsp" class="brand">
					<span class="brand-icon"><i class="fa-solid fa-heart-pulse" aria-hidden="true"></i></span>
					<span>CareWell<span class="brand-highlight"> Hospital</span></span>
				</a>
				<p>Bringing hospital services and patient access together in one
					place.</p>
			</div>

			<div class="footer-column">
				<h4>Explore</h4>
				<a href="#home">Home</a>
				<a href="#services">Services</a>
				<a href="#doctors">Our Doctors</a>
				<a href="#about">About Us</a>
				<a href="#contact">Contact</a>
			</div>

			<div class="footer-column">
				<h4>Portal</h4>
				<a href="<%= ctx %>/login.jsp">Sign in (Patients, Doctors &amp; Staff)</a>
				<a href="<%= ctx %>/register.jsp">Create a patient account</a>
				<a href="<%= bookLink(ctx, null) %>">Book an appointment</a>
			</div>
		</div>

		<div class="footer-bottom">
			<p>© <%= java.time.Year.now() %> CareWell Hospital. All rights reserved.</p>
			<a href="#home">Back to top ↑</a>
		</div>
	</footer>

	<script>
		(function () {
			var toggle = document.getElementById("navToggle");
			var nav = document.getElementById("mainNav");
			if (!toggle || !nav) return;

			function setOpen(open) {
				nav.classList.toggle("open", open);
				toggle.setAttribute("aria-expanded", String(open));
				toggle.setAttribute("aria-label", open ? "Close menu" : "Open menu");
				toggle.querySelector("i").className = open ? "fa-solid fa-xmark" : "fa-solid fa-bars";
			}

			toggle.addEventListener("click", function () {
				setOpen(!nav.classList.contains("open"));
			});

			nav.addEventListener("click", function (event) {
				if (event.target.tagName === "A") setOpen(false);
			});

			document.addEventListener("keydown", function (event) {
				if (event.key === "Escape") setOpen(false);
			});
		})();
	</script>
</body>
</html>
