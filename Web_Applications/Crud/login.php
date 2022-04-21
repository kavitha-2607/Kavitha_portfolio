<?php
session_start();

$salt = 'XyZzy12*_';
$stored_hash = hash('md5','XyZzy12*_php123');

if (isset($_POST['email']) && isset($_POST['pass'])) {
    if(strlen($_POST['email']) <1 || strlen($_POST['pass']) <1){
        $_SESSION['error'] = "User name and password are required";
        header ("Location: login.php");
        return;
    } else {
            $check = hash('md5', $salt.$_POST['pass']);
            if ($check == $stored_hash){
                $_SESSION['name'] = $_POST['email'];
                $_SESSION['lg_success'] = "Login success";
                error_log("Login success ".$_POST['email']);
                header("Location: index.php");
                return;
        } else {
              $_SESSION['error'] = "Incorrect Password";
              error_log("Login fail ".$_POST['email']." $check");
              header("Location: login.php");
              return;
    }
  }
}
 ?>
 <!DOCTYPE html>
<html>
<head>
<title> Kavitha Raghunath Login Page </title>
<?php require_once "bootstrap.php"; ?>
</head>
<body>
<div class = "container">
<h1> Please Log In </h1>
<?php
if (isset($_SESSION['error'])) {
  echo('<p style = "color: red;">'. htmlentities($_SESSION['error'])."</p>\n");
  unset($_SESSION['error']);
}
 ?>
<form method = "POST">
<label for = "email"> User Name </label>
<input type = "text" name = "email" id = "email"></br>
<label for = "pass"> Password </label>
<input type = "password" name  = "pass" id = "id_1723"></br>
<input type = "submit" name = "login" value = "Log In">
<a href = "index.php"> Cancel </a>
