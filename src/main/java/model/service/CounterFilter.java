package model.service;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@WebFilter(urlPatterns = "/*")
public class CounterFilter implements Filter {
    private boolean first_access = true;
    private static int count;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        count = 0;
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        if (first_access) {
            HttpServletRequest httpRequest = (HttpServletRequest) servletRequest;
            String requestURI = httpRequest.getRequestURI();
            // Kiểm tra nếu URL không chứa "admin"
            System.out.println("client: " + requestURI);
            if (!requestURI.contains("admin")) {
                count++;
            }
            first_access = false;
        }
        filterChain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {

    }

    public static int getCount() {
        return count;
    }
}