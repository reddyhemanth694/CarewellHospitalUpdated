package com.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Adds basic security headers to every response and stops browsers from
 * caching the patient / doctor portal pages, so pressing "Back" after
 * logout cannot show private medical data.
 */
@WebFilter("/*")
public class SecurityHeadersFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "SAMEORIGIN");
        response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");

        String path = request.getRequestURI()
                .substring(request.getContextPath().length());

        if (path.startsWith("/patient/") || path.startsWith("/doctor/")
                || path.startsWith("/admin/")) {
            response.setHeader("Cache-Control",
                    "no-store, no-cache, must-revalidate, private");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
        }

        chain.doFilter(req, res);
    }
}
