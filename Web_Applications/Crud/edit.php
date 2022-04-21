<?php
require_once "pdo.php";

session_start();

if (! isset($_SESSION['name'])){
  die("ACCESS DENIED");
}


if (isset($_POST['make']) && isset($_POST['year']) && isset($_POST['model']) && isset($_POST['mileage'])) {
    if (strlen($_POST['make'])<1 || strlen($_POST['year'])<1 || strlen($_POST['model']) < 1 || strlen($_POST['mileage']) < 1){
        $_SESSION['error'] = "All fields are required";
        header("Location: edit.php");
        return;
  }  elseif (is_numeric($_POST['mileage']) == false || is_numeric($_POST['year']) == false){
        $_SESSION['error'] = "Mileage and year must be numeric";
        header("Location: edit.php");
        return;
    }else {
      $sql = "UPDATE autos SET make = :make, year = :year, model = :model,
      mileage = :mileage WHERE autos_id = :autos_id";
      $statement = $pdo->prepare($sql);

    $statement->execute(array(
    ':make' => $_POST['make'],
    ':year' => $_POST['year'],
    ':mileage' => $_POST['mileage'],
    ':model' => $_POST['model'],
    ':autos_id' => $_GET['autos_id'])
  );
    $_SESSION['edit_success'] = "Record edited";
    header("Location: index.php");
    return;
  }
}
  if (!isset($_GET['autos_id'])) {
      $_SESSION['error'] = "Missing autos_id";
      header('Location: index.php');
      return;
    }
$statement  = $pdo-> prepare("SELECT * FROM autos where autos_id = :xyz");
$statement-> execute(array(":xyz" => $_GET['autos_id']));
$row = $statement->fetch(PDO::FETCH_ASSOC);
if($row == false){
$_SESSION['error'] = "Bad value for autos_id";
header("Location: index.php");
return;
    }
 ?>
 <!DOCTYPE html>
 <html>
 <head>
   <title> Kavitha Raghunath Edit page </title>
   <?php require_once "bootstrap.php"; ?>
 </head>
 <body>
   <div class = "container">
   <h1> Editing Automobile </h1>
   <?php
        if (isset($_SESSION['error'])) {
            echo('<p style="color: red;">' . htmlentities($_SESSION['error']) . "</p>\n");
            unset($_SESSION['error']);
        }

   ?>
        <form method="post"><input type = "hidden" name = "autos_id" value = "<?= $_GET['autos_id']?>">

            <p>Make:
                <input type="text" name="make" value = "<?= $row['make']?>"/></p>
            <p>Year:
                <input type="text" name="year" value = "<?= $row['year']?>"/></p>
            <p>Mileage:
                <input type="text" name="mileage" value = "<?= $row['mileage']?>"/></p>
             <p> Model:
               <input type = "text" name = "model" value = "<?= $row['model']?>"/></p>
            <input type="submit" value="Save">
            <a href = "index.php"> Cancel </a>
        </form>
   </div>
   </body>
   </html>
