<?php
session_start();

require_once "pdo.php";

if (isset($_POST['cancel'])){
  header("Location: index.php");
  return;
}

$salt = 'XyZzy12*_';
if (isset($_POST['email']) && isset($_POST['pass'])){
$check = hash('md5', $salt.$_POST['pass']);
$sql = "SELECT user_id, name, email, password FROM users WHERE email = :em AND password = :pw";
$stmt = $pdo->prepare($sql);
$stmt->execute(array(
  ':em' => $_POST['email'],
  ':pw' => $check
));
$row = $stmt->fetch(PDO::FETCH_ASSOC);

if ($row !== false){
  $_SESSION['name'] = $row['name'];
  $_SESSION['user_id'] = $row['user_id'];
  header("Location: index.php");
  return;
} else {
  $_SESSION['error'] = 'Incorrect password';
  header("Location: login.php");
  return;
}
}
 ?>
 <!DOCTYPE html>
 <html>
 <head>
   <title> Kavitha Raghunath Login page </title>
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
   <p>
   <form method = "POST">
     <label for = "email"> Email </label>
     <input type = "text" name = "email" id ="email"></br>
     <label for = "pass"> Password </label>
     <input type = "password" name = "pass" id = "id_1723"></br>
     <input type = "submit" onclick = "return doValidate();" value = "Log In">
     <input type = "submit" name = "cancel" value = "Cancel">
   </form>
 </p>
 <script>
function doValidate() {
    console.log('Validating...');
    try {
        addr = document.getElementById('email').value;
        pw = document.getElementById('id_1723').value;
        console.log("Validating addr="+addr+" pw="+pw);
        if (addr == null || addr == "" || pw == null || pw == "") {
            alert("Both fields must be filled out");
            return false;
        }
        if ( addr.indexOf('@') == -1 ) {
            alert("Invalid email address");
            return false;
        }
        return true;
    } catch(e) {
        return false;
    }
    return false;
}
</script>
 </body>
