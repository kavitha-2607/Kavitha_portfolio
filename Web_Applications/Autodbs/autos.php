<?php
if (isset($_POST['logout'])){
  header("Location: index.php");
  return;
}
require_once "pdo.php";
if (isset($_GET['name']) === false){
  die("Name parameter missing");
} else {
  echo "<h1>Tracking Autos for ".$_GET['name']."</h1>";
}

$notnum = false;
$blk = false;
$success = false;
if (isset($_POST['add'])){
    if (is_numeric($_POST['mileage']) == false || is_numeric($_POST['year']) == false){
    $notnum = "Mileage and year must be numeric";
  } else if (strlen($_POST['make'])<1){
    $blk = "Make is required";
  } else {
  $stmt = $pdo->prepare('INSERT INTO autos
       (make, year, mileage) VALUES ( :mk, :yr, :mi)');
   $stmt->execute(array(
       ':mk' => $_POST['make'],
       ':yr' => $_POST['year'],
       ':mi' => $_POST['mileage'])
   );
   $success = "Record inserted";
 }
}
 ?>
<!DOCTYPE html>
<html>
<head>
<title> Kavitha Raghunath Autos Database </title>
<?php require_once "bootstrap.php"; ?>
</head>
<body>
<div class = "container">
<?php
if ($notnum !== false){
  echo ('<p style="color: red;">'.htmlentities($notnum)."</p>\n");
} else if ($blk !== false){
  echo ('<p style = "color: red;">'.htmlentities($blk)."</p>\n");
} else if ($success !== false) {
  echo ('<p style = "color: green;">'. htmlentities($success)."</p>\n");
}
 ?>
<form method = "POST">
<label for = "make"> Make: </label>
<input type = "text" name = "make" id = mk></br>
<label for = "year"> Year: </label>
<input type = "text" name = "year" id = id_1723></br>
<label for = "mileage"> Mileage: </label>
<input type = "text" name = "mileage"></br>
<input type = "submit" name = 'add' value = "Add">
<input type = "submit" name = 'logout' value = "Logout">
</form>
<h2>Automobiles</h2>
   <ul>
       <?php

           $statement = $pdo->query("SELECT auto_id, make, year, mileage FROM autos");

           while ($row = $statement->fetch(PDO::FETCH_ASSOC)) {
               echo "<li> ";
               echo $row['year']." ";
               echo htmlentities($row['make'])." / ";
               echo $row['mileage'];
               echo "</li>";
           }
       ?>
   </ul>
</div>
</body>
</html>
