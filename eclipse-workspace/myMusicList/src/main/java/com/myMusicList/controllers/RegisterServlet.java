package com.myMusicList.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.myMusicList.service.UserService;
import com.myMusicList.model.UserModel;

/**
 * @author Abhyudaya Shrestha
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// 1. Get form data
	    String name     = request.getParameter("name");
	    String email    = request.getParameter("email");
	    String password = request.getParameter("password");

	    // 2. Call service to save to DB
	    UserService service = new UserService();

	    // 3. Check if email already taken
	    if (service.emailExists(email)) {
	        request.setAttribute("error", "Email already registered!");
	        request.getRequestDispatcher("/WEB-INF/pages/register.jsp")
	               .forward(request, response);
	        return;
	    }
	 // 4. Save user
	    UserModel user = new UserModel(name, email, password);
	    boolean success = service.registerUser(user);

	    // 5. Redirect to login if success, show error if not
	    if (success) {
	        response.sendRedirect(request.getContextPath() + "/login");
	    } else {
	        request.setAttribute("error", "Registration failed. Please try again.");
	        request.getRequestDispatcher("/WEB-INF/pages/register.jsp")
	               .forward(request, response);
	    }
	}
}
