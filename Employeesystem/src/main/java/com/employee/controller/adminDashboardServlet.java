package com.employee.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.time.Duration;
import java.time.LocalTime;

import com.employee.util.DbUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/taskManager")
public class adminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addTask(request, response);
        } else if ("fetch".equals(action)) {
            fetchTask(request, response);
        } else if ("update".equals(action)) {
            updateTask(request, response);
        } else if ("delete".equals(action)) {
            deleteTask(request, response);
        } else {
            response.sendRedirect("adminDashboard.jsp");
        }
    }

    private void addTask(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("user_id"));
        String project = request.getParameter("project");
        Date date = Date.valueOf(request.getParameter("date"));
        Time startTime = Time.valueOf(request.getParameter("start_time") + ":00");
        Time endTime = Time.valueOf(request.getParameter("end_time") + ":00");
        String taskCategory = request.getParameter("task_category");
        String description = request.getParameter("description");

        // Calculate duration
        LocalTime start = startTime.toLocalTime();
        LocalTime end = endTime.toLocalTime();
        Duration duration = Duration.between(start, end);

        BigDecimal durationInHours = BigDecimal.valueOf(duration.toMinutes() / 60.0);

        if (durationInHours.compareTo(BigDecimal.valueOf(8)) > 0) {
            // Duration exceeds 8 hours, handle the error
            request.setAttribute("errorMessage", "Task duration cannot exceed 8 hours.");
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbUtil.getConnection();
            stmt = conn.prepareStatement(
                     "INSERT INTO tasks (user_id, project, date, start_time, end_time, duration, task_category, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
            stmt.setInt(1, userId);
            stmt.setString(2, project);
            stmt.setDate(3, date);
            stmt.setTime(4, startTime);
            stmt.setTime(5, endTime);
            stmt.setBigDecimal(6, durationInHours);
            stmt.setString(7, taskCategory);
            stmt.setString(8, description);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("adminDashboard.jsp");
    }

    private void fetchTask(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int taskId = Integer.parseInt(request.getParameter("task_id"));

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbUtil.getConnection();
            stmt = conn.prepareStatement("SELECT * FROM tasks WHERE task_id = ?");
            stmt.setInt(1, taskId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                request.setAttribute("task_id", rs.getInt("task_id"));
                request.setAttribute("user_id", rs.getInt("user_id"));
                request.setAttribute("project", rs.getString("project"));
                request.setAttribute("date", rs.getDate("date"));
                request.setAttribute("start_time", rs.getTime("start_time"));
                request.setAttribute("end_time", rs.getTime("end_time"));
                request.setAttribute("duration", rs.getBigDecimal("duration"));
                request.setAttribute("task_category", rs.getString("task_category"));
                request.setAttribute("description", rs.getString("description"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int taskId = Integer.parseInt(request.getParameter("task_id"));
        int userId = Integer.parseInt(request.getParameter("user_id"));
        String project = request.getParameter("project");
        Date date = Date.valueOf(request.getParameter("date"));
        Time startTime = Time.valueOf(request.getParameter("start_time") + ":00");
        Time endTime = Time.valueOf(request.getParameter("end_time") + ":00");
        String taskCategory = request.getParameter("task_category");
        String description = request.getParameter("description");

        // Calculate duration
        LocalTime start = startTime.toLocalTime();
        LocalTime end = endTime.toLocalTime();
        Duration duration = Duration.between(start, end);

        BigDecimal durationInHours = BigDecimal.valueOf(duration.toMinutes() / 60.0);

        if (durationInHours.compareTo(BigDecimal.valueOf(8)) > 0) {
            // Duration exceeds 8 hours, handle the error
            request.setAttribute("errorMessage", "Task duration cannot exceed 8 hours.");
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbUtil.getConnection();
            stmt = conn.prepareStatement(
                     "UPDATE tasks SET user_id = ?, project = ?, date = ?, start_time = ?, end_time = ?, duration = ?, task_category = ?, description = ? WHERE task_id = ?");
            stmt.setInt(1, userId);
            stmt.setString(2, project);
            stmt.setDate(3, date);
            stmt.setTime(4, startTime);
            stmt.setTime(5, endTime);
            stmt.setBigDecimal(6, durationInHours);
            stmt.setString(7, taskCategory);
            stmt.setString(8, description);
            stmt.setInt(9, taskId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("adminDashboard.jsp");
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int taskId = Integer.parseInt(request.getParameter("task_id"));

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbUtil.getConnection();
            stmt = conn.prepareStatement("DELETE FROM tasks WHERE task_id = ?");
            stmt.setInt(1, taskId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("adminDashboard.jsp");
    }
}
