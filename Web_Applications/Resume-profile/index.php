<?php
session_start();
require_once "pdo.php";

$stmt = $pdo->query("SELECT profile_id, user_id, first_name, last_name, email, headline, summary FROM Profile");
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

 ?>
<!DOCTYPE html>
<html>
<head>
  <title> Kavitha Raghunath Index page </title>
  <?php require_once "bootstrap.php"; ?>
</head>
<body>
  <div class = "container">
  <h1> Kavitha's Resume Registry </h1>
  <?php
  if (isset($_SESSION['success'])){
    echo('<p style = "color: green;">'. htmlentities($_SESSION['success'])."</p>\n");
    unset($_SESSION['success']);
  }
  if (isset($_SESSION['error'])) {
    echo('<p style = "color: red;">'. htmlentities($_SESSION['error'])."</p>\n");
    unset($_SESSION['error']);
  }
   ?>
   <p>
  <?php
  if (isset($_SESSION['name']) && isset($_SESSION['user_id'])){
  if (sizeof($rows) > 0) {
    echo '<table>';
    echo ('<table border = "1">'. "\n");
    echo '<tr><th>';
    echo 'Name';
    echo '</th><th>';
    echo 'Headline';
    echo '</th><th>';
    echo 'Action';

  foreach ($rows as $row) {
    echo '<tr><td>';
    echo("<a href='view.php?profile_id=" . $row['profile_id'] . "'>" . $row['first_name'] . $row['last_name']  . "</a>");
    echo '</td><td>';
    echo $row['headline'];
    echo '</td><td>';
    echo('<a href="edit.php?profile_id='.$row['profile_id'].'">Edit</a> / <a href="delete.php?profile_id='.$row['profile_id'].'">Delete</a>');
      }
      echo '</table>';
    } else {
      echo '<p> No rows added </p>';
    }
    echo '<p><a href = "add.php"> Add New Entry </a> | <a href = "logout.php"> Log Out </a>';
} else {
  echo '<p><a href = "login.php" > Please log in </a></br></p>
  <p><b> Note:</b> Your implementation should retain data across multiple logout/login sessions.
      This sample implementation clears all its data periodically - which you should not do in your implementation. </p>';
}
   ?>
</p>
  </div>
</body>
