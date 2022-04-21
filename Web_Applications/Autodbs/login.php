<?php
if (isset($_POST['cancel'])){
  header("Location: index.php");
  return;
}
$failure = false;
$noat = false;
$blank = false;
if (isset($_POST['who']) && isset($_POST['pass'])) {
   if ((strlen($_POST['who']) < 1 || strlen($_POST['pass'])<1)){
      $blank = "Email and password are required" ;
  } else if (strpos($_POST['who'],'@') === false){
    $noat = "Email must have an at-sign (@)";
  }
  else {
      $salt = 'XyZzy12*_';
      $pw = 'php123';
      $stored_hash = hash('md5', $salt.$pw);
      $check = hash('md5', $salt.$_POST['pass']);
      if($check == $stored_hash){
      error_log("Login success ".$_POST['who']);
      header("Location: autos.php?name=".urlencode($_POST['who']));
      } else {
        $failure = "Incorrect password";
        error_log("Login fail ".$_POST['who']." $check");
      }
    }
 }
 ?>
<!DOCTYPE html>
<html>
<head>
<title> Kavitha Raghunath - Autos Database </title>
<?php require_once "bootstrap.php"; ?>
</head>
<body>
<div class = "container">
<h1> Please Log In </h1>
<?php
// Note triple not equals and think how badly double
// not equals would work here...
if ( $failure !== false) {
    // Look closely at the use of single and double quotes
    echo('<p style="color: red;">'.htmlentities($failure)."</p>\n");
}
else if ($noat !== false){
  echo('<p style="color: red;">'.htmlentities($noat)."</p>\n");
}

else if ($blank !== false){
  echo('<p style="color: red;">'.htmlentities($blank)."</p>\n");
}
?>
<form method = "POST">
<label for = "eml"> Email</label>
<input type = "text" name = "who" id = "eml"></br>
<label for = "pass"> Password </label>
<input type = "password" name = "pass" id = "id_1723"></br>
<input type = "submit" value = "Log In">
<input type = "submit" name = "cancel" value = "Cancel">
</form>
<p>For a password hint, view source and find a password hint
in the HTML comments.
<!-- Hint: The password is the name of the programming language taught in
this course followed by 123. -->
</p>
</div>
</body>
</html>
