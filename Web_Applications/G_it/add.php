<?php
session_start();

require_once "pdo.php";

if (isset($_POST['cancel'])) {
  header("Location: view.php");
  return;
}
if (! isset($_SESSION['name'])){
  die("Not Logged In");
}
if (isset($_POST['add'])) {
    if (is_numeric($_POST['mileage']) == false || is_numeric($_POST['year']) == false){
    $_SESSION['error'] = "Mileage and year must be numeric";
    header("Location: add.php");
    return;
  } else if (strlen($_POST['make'])<1){
    $_SESSION['error'] = "Make is required";
    header("Location: add.php");
    return;
  } else {
  $statement = $pdo->prepare('INSERT INTO autos
       (make, year, mileage) VALUES ( :mk, :yr, :mi)');
   $statement->execute(array(
       ':mk' => $_POST['make'],
       ':yr' => $_POST['year'],
       ':mi' => $_POST['mileage'])
   );
   $_SESSION['success'] = "Record inserted";
   header("Location: view.php");
   return;
 }
}
 ?>
 <!DOCTYPE html>
 <html>
 <head>
   <title> Kavitha Raghunath Add Page </title>
   <?php require_once "bootstrap.php" ?>
 </head>
 <body>
   <div class = "container">
  <?php
  if (isset($_SESSION['name'])) {
    echo "<h1>Tracking Autos for ".$_SESSION['name']."</h1>";
  }
  if (isset($_SESSION['error'])){
    echo ('<p style = "color:red;">'.htmlentities($_SESSION['error'])."</p>\n");
    unset($_SESSION['error']);
  }
   ?>
 <form method = "POST">
 <label for = "make"> Make: </label>
 <input type = "text" name = "make" id = mk></br>
 <label for = "year"> Year: </label>
 <input type = "text" name = "year" id = id_1723></br>
 <label for = "mileage"> Mileage: </label>
 <input type = "text" name = "mileage"></br>
 <input type = "submit" name = "add" value = "Add">
 <input type = "submit" name = "cancel" value = "Cancel">
</form>
</div>
</body>
</html>
