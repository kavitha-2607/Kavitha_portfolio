<?php
session_start();

require_once "pdo.php";

if (! isset($_SESSION['name'])){
  die("Not Logged In");
}

$statement = $pdo->query("SELECT auto_id, make, year, mileage FROM autos");
$rows = $statement->fetchAll(PDO::FETCH_ASSOC);
 ?>
<!DOCTYPE html>
<html>
<head>
<title> Kavitha Raghunath Login Page </title>
<?php require_once "bootstrap.php"; ?>
</head>
<body>
<div class = "container">
  <h1>Tracking Autos for <?php echo $_SESSION['name']; ?></h1>
<?php
if (isset($_SESSION['lg_success'])){
  echo ('<p style = "color:green;">'.htmlentities($_SESSION['lg_success'])."</p>\n");
  unset($_SESSION['lg_success']);
}
if (isset($_SESSION['success'])){
  echo ('<p style = "color:green;">'.htmlentities($_SESSION['success'])."</p>\n");
  unset($_SESSION['success']);
}
 ?>
 <h2> Automobiles </h2>
 <ul>
          <?php
          foreach ($rows as $row) {
              echo '<li>';
              echo htmlentities($row['make']) . ' ' . $row['year'] . ' / ' . $row['mileage'];
          };
          echo '</li><br/>';
          ?>
      </ul>
<p>
    <a href = "add.php"> Add New </a> |
    <a href = "logout.php" > Logout </a>
</p>
</div>
</body>
</html>
