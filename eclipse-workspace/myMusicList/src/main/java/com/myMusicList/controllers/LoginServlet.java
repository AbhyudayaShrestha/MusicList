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
 * Servlet implementation class LoginServlet
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String email    = request.getParameter("email");
	    String password = request.getParameter("password");

	    UserService service = new UserService();
	    UserModel user = service.validateUser(email, password);

	    if (user != null) {
	        request.getSession().setAttribute("loggedUser", user);
	        response.sendRedirect(request.getContextPath() + "/dashboard");
	    } else {
	        request.setAttribute("error", "Invalid email or password.");
	        request.getRequestDispatcher("/WEB-INF/pages/login.jsp")
	               .forward(request, response);
	    }
	}

}
