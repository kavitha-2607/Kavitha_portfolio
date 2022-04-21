<?php
session_start();

require_once "pdo.php";

if (isset($_SESSION['name']) == false && isset($_SESSION['user_id']) == false){
  die ('Not Logged in');
}

if (isset($_POST['cancel'])){
  header("Location: index.php");
  return;
}

if(isset($_POST['first_name']) && isset($_POST['last_name']) && isset($_POST['email']) && isset($_POST['headline']) && isset($_POST['summary'])){
   if (strlen($_POST['first_name'])<1 || strlen($_POST['last_name']) < 1 || strlen($_POST['email'])< 1 || strlen($_POST['headline']) < 1 || strlen($_POST['summary']) < 1){
      $_SESSION['error'] = "All fields are required";
      header("Location: add.php");
      return;
} elseif (strpos($_POST['email'], '@') == false){
      $_SESSION['error'] = "Email address must contain @";
      header("Location: add.php");
      return;
} else{
  $stmt = $pdo->prepare('INSERT INTO Profile
          (user_id, first_name, last_name, email, headline, summary)
          VALUES ( :user_id, :first_name, :last_name, :email, :headline, :summary)');
      $stmt->execute(array(
          ':user_id' => $_SESSION['user_id'],
          ':first_name' => $_POST['first_name'],
          ':last_name' => $_POST['last_name'],
          ':email' => $_POST['email'],
          ':headline' => $_POST['headline'],
          ':summary' => $_POST['summary']
      ));
      $_SESSION['success'] = "Profile added";
      header("Location: index.php");
      return;
}
}
 ?>
 <!DOCTYPE html>
 <html>
 <head>
   <title> Kavitha Raghunath </title>
   <?php require_once "bootstrap.php"; ?>
 </head>
 <body>
   <div class = "container">
   <h1> Adding Profile for UMSI </h1>
   <?php
   if (isset($_SESSION['error'])) {
     echo('<p style = "color: red;">'. htmlentities($_SESSION['error'])."</p>\n");
     unset($_SESSION['error']);
   }
    ?>
   <p>
   <form method = "POST">
     <p>
     <label for = "first_name"> First Name </label></br>
     <input type = "text" name = "first_name"  size = "60"></br></p>
     <p>
     <label for = "last_name"> Last Name </label></br>
     <input type = "text" name = "last_name"  size = "60"></br></p>
     <p>
     <label for = "email"> Email </label></br>
     <input type = "text" name = "email" size = "30"></br></p>
     <p>
     <label for = "headline"> Headline </label></br>
     <input type = "text" name = "headline"  size = "80"></p>
     <p><b>Summary</b></br>
     <textarea name = "summary"  rows = "8" cols = "80"></textarea></br></p>
     <p>
     <input type = "submit" value = "Add">
     <input type = "submit" name = "cancel" value = "Cancel"></p>
   </form>
 </p>
</div>
</body>
