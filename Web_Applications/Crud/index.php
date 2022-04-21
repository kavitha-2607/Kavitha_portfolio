<?php
session_start();


require_once "pdo.php";

$statement = $pdo->query("SELECT autos_id, make, year, mileage, model FROM autos");
$rows = $statement->fetchAll(PDO::FETCH_ASSOC);

 ?>
 <!DOCTYPE html>
 <html>
 <head>
  <title> Kavitha Raghunath Index page </title>
  <?php require_once "bootstrap.php"; ?>
</head>
<body>
<div class = "container">
<h1> Welcome to the Automobiles Database </h1>
<?php
if (isset($_SESSION['lg_success'])){
  echo('<p style = "color: green;">'. htmlentities($_SESSION['lg_success'])."</p>\n");
  unset($_SESSION['lg_success']);
}

if (isset($_SESSION['edit_success'])) {
    echo('<p style = "color: green;">'. htmlentities($_SESSION['edit_success'])."</p>\n");
    unset($_SESSION['edit_success']);
}

if(isset($_SESSION['success'])){
  echo('<p style = "color: green;">'. htmlentities($_SESSION['success'])."</p>\n");
  unset($_SESSION['success']);
}

 ?>

  <?php
if (isset($_SESSION['name'])){
  if (sizeof($rows) > 0){
  echo "<table>";
  echo ('<table border = "1">'. "\n");
  echo ("<tr><th>");
  echo "Make";
  echo ("</th><th>");
  echo "Year";
  echo ("</th><th>");
  echo "Mileage";
  echo ("</th><th>");
  echo "Model";
  echo ("</th><th>");
  echo "Action";

  foreach ($rows as $row) {

      echo "<tr><td>";
      echo ($row['make']);
      echo ("</td><td>");
      echo ($row['year']);
      echo ("</td><td>");
      echo ($row['mileage']);
      echo ("</td><td>");
      echo ($row['model']);
      echo ("</td><td>");
      echo('<a href="edit.php?autos_id='.$row['autos_id'].'">Edit</a> / <a href="delete.php?autos_id='.$row['autos_id'].'">Delete</a>');
      echo ("\n </form> \n");
      echo ("</td><td>");
    }
  echo "</table>";
}
else {
  echo "No rows added";
}

echo '<p><a href="add.php">Add New Entry</a></p>
  <p><a href="logout.php">Logout</a></p><p>
      <b>Note:</b> Your implementation should retain data across multiple
      logout/login sessions.  This sample implementation clears all its
      data on logout - which you should not do in your implementation.
  </p>';
}  else {

          echo "<p><a href='login.php'>Please log in</a></p><p>Attempt to <a href='add.php'>add data</a> without logging in</p>";
      } ?>
</body>
</html>
