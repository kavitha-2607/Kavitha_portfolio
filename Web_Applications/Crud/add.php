<?php
session_start();

if (! isset($_SESSION['name'])){
  die("ACCESS DENIED");
}

require_once "pdo.php";


if (isset($_POST['make']) && isset($_POST['year']) && isset($_POST['model']) && isset($_POST['mileage'])) {
    if (strlen($_POST['make'])<1 || strlen($_POST['year']) < 1 || strlen($_POST['mileage'])< 1 || strlen($_POST['model']) < 1){
        $_SESSION['error'] = "All fields are required";
        header("Location: add.php");
        return;
  } elseif (is_numeric($_POST['mileage']) == false || is_numeric($_POST['year']) == false){
        $_SESSION['error'] = "Mileage and year must be numeric";
        header("Location: add.php");
        return;
  } else {
    $sql = "INSERT INTO autos (make, year, mileage, model)
    VALUES (:make, :year, :mileage, :model)";
    $statement = $pdo->prepare($sql);

    $statement->execute(array(
    ':make' => htmlentities($_POST['make']),
    ':year' => htmlentities($_POST['year']),
    ':mileage' => htmlentities($_POST['mileage']),
    ':model' => htmlentities($_POST['model']))
  );
    $_SESSION['success'] = "Record Added";
    header("Location: index.php");
  }
} ?>
<!DOCTYPE html>
 <html>
 <head>
   <title> Kavitha Raghunath Add page </title>
   <?php require_once "bootstrap.php"; ?>
 </head>
 <body>
 <div class = "container">
 <h1>Tracking Autos for <?php echo (htmlentities($_SESSION['name'])); ?></h1>
<?php
     if (isset($_SESSION['error'])) {
         echo('<p style="color: red;">' . htmlentities($_SESSION['error']) . "</p>\n");
         unset($_SESSION['error']);
     }
?>
     <form method="post">
         <p>Make:
             <input type="text" name="make" size="60"/></p>
         <p>Year:
             <input type="text" name="year"/></p>
         <p>Mileage:
             <input type="text" name="mileage"/></p>
          <p> Model:
            <input type = "text" name = "model"/></p>
         <input type="submit" value="Add">
         <a href = "index.php"> Cancel </a>
     </form>
</div>
</body>
</html>
