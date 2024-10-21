<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.employee.util.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Task Dashboard</title>
    <!-- Load Google Charts library -->
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }
        .charts-container {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .chart {
            width: 45%;
            height: 500px;
        }
        .legend {
            margin-top: 20px;
        }
        .legend-item {
            display: inline-block;
            margin-right: 10px;
        }
        .legend-color {
            display: inline-block;
            width: 20px;
            height: 20px;
            margin-right: 5px;
            border-radius: 50%;
        }
        .completed {
            background-color: #FF6384;
        }
        .not-completed {
            background-color: #36A2EB;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .logout-button {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <h2>Task Dashboard</h2>
    
    <div class="charts-container">
        <div id="piechart" class="chart"></div>
        <div id="barchart" class="chart"></div>
    </div>

    <!-- JavaScript to render the charts -->
    <script type="text/javascript">
        google.charts.load('current', {'packages':['corechart', 'bar']});
        google.charts.setOnLoadCallback(drawCharts);

        function drawCharts() {
            drawPieChart();
            drawBarChart();
        }

        function drawPieChart() {
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Task Status');
            data.addColumn('number', 'Number of Tasks');
            
            <% 
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            int userId = (Integer) session.getAttribute("user_id");
            try {
                conn = DbUtil.getConnection(); // Replace with your method to get DB connection
                stmt = conn.prepareStatement("SELECT ts.is_completed, COUNT(*) AS count " +
                                             "FROM tasks t " +
                                             "INNER JOIN task_status ts ON t.task_id = ts.task_id " +
                                             "WHERE t.user_id = ? " +
                                             "GROUP BY ts.is_completed");
                stmt.setInt(1, userId);
                rs = stmt.executeQuery();
                while (rs.next()) {
                    String status = rs.getBoolean("is_completed") ? "Completed" : "Not Completed";
                    int count = rs.getInt("count");
            %>
                data.addRow(['<%= status %>', <%= count %>]);
            <% 
                } // End while loop
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                // Close resources
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            %>
            
            var options = {
                title: 'Task Completion Status',
                pieHole: 0.4,
                sliceVisibilityThreshold: 0.1,
                legend: { position: 'top', alignment: 'center' },
                pieSliceText: 'label',
                colors: ['#FF6384', '#36A2EB']
            };

            var chart = new google.visualization.PieChart(document.getElementById('piechart'));
            chart.draw(data, options);
        }

        function drawBarChart() {
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Task Category');
            data.addColumn('number', 'Number of Tasks');
            
            <% 
            try {
                conn = DbUtil.getConnection(); // Replace with your method to get DB connection
                stmt = conn.prepareStatement("SELECT t.task_category, COUNT(*) AS count " +
                                             "FROM tasks t " +
                                             "WHERE t.user_id = ? " +
                                             "GROUP BY t.task_category");
                stmt.setInt(1, userId);
                rs = stmt.executeQuery();
                while (rs.next()) {
                    String taskCategory = rs.getString("task_category");
                    int count = rs.getInt("count");
            %>
                data.addRow(['<%= taskCategory %>', <%= count %>]);
            <% 
                } // End while loop
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                // Close resources
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            %>
            
            var options = {
                title: 'Task Count by Category',
                legend: { position: 'none' },
                hAxis: {
                    title: 'Task Category'
                },
                vAxis: {
                    title: 'Number of Tasks'
                },
                colors: ['#36A2EB']
            };

            var chart = new google.visualization.ColumnChart(document.getElementById('barchart'));
            chart.draw(data, options);
        }
    </script>

    <h2>Incomplete Tasks</h2>
    <table>
        <tr>
            <th>Project</th>
            <th>Task Category</th>
            <th>End Time</th>
        </tr>
        <% 
        try {
            conn = DbUtil.getConnection(); // Replace with your method to get DB connection
            stmt = conn.prepareStatement("SELECT t.project, t.task_category, t.end_time " +
                                         "FROM tasks t " +
                                         "INNER JOIN task_status ts ON t.task_id = ts.task_id " +
                                         "WHERE t.user_id = ? AND ts.is_completed = 0");
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                String project = rs.getString("project");
                String taskCategory = rs.getString("task_category");
                String endTime = rs.getString("end_time");
        %>
        <tr>
            <td><%= project %></td>
            <td><%= taskCategory %></td>
            <td><%= endTime %></td>
        </tr>
        <% 
            } // End while loop
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        %>
    </table>

    <form action="LogoutServlet" method="post" class="logout-button">
        <input type="submit" value="Logout">
    </form>
</body>
</html>
