package com.myMusicList.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.myMusicList.model.UserModel;
import com.myMusicList.service.UserService;

// admin user management — edit name/role or delete a user
// an admin cannot delete or demote their own account
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserModel admin = (session != null) ? (UserModel) session.getAttribute("loggedUser") : null;
        if (admin == null || !"admin".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=users");
                return;
            }
            try {
                int userId = Integer.parseInt(idStr);
                UserService service = new UserService();
                UserModel target = service.getUserWithSecurity(userId);
                if (target == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=users&userError=notfound");
                    return;
                }
                request.setAttribute("targetUser", target);
                request.getRequestDispatcher("/WEB-INF/pages/editUser.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=users");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=users");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserModel admin = (session != null) ? (UserModel) session.getAttribute("loggedUser") : null;
        if (admin == null || !"admin".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String idStr  = request.getParameter("id");

        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=users");
            return;
        }

        int targetId;
        try {
            targetId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=users");
            return;
        }

        UserService service = new UserService();

        if ("delete".equals(action)) {
            // can't delete your own account
            if (targetId == admin.getId()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=users&userError=selfdelete");
                return;
            }
            boolean ok = service.deleteUser(targetId);
            String param = ok ? "userSuccess=deleted" : "userError=deletefail";
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=users&" + param);

        } else if ("edit".equals(action)) {
            String newName = request.getParameter("name");
            String newRole = request.getParameter("role");

            if (newName == null || newName.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&id=" + targetId + "&error=emptyname");
                return;
            }
            if (!"user".equals(newRole) && !"admin".equals(newRole)) {
                response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&id=" + targetId + "&error=invalidrole");
                return;
            }
            // can't demote yourself
            if (targetId == admin.getId() && !"admin".equals(newRole)) {
                response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&id=" + targetId + "&error=selfdemote");
                return;
            }

            boolean ok = service.updateUser(targetId, newName.trim(), newRole);
            if (ok) {
                // keep session in sync if the admin just renamed themselves
                if (targetId == admin.getId()) {
                    admin.setName(newName.trim());
                    session.setAttribute("loggedUser", admin);
                }
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=users&userSuccess=edited");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&id=" + targetId + "&error=savefail");
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?tab=users");
        }
    }
}