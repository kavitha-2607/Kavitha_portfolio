<?php
session_start();

require_once "pdo.php";

if (!isset($_SESSION['name']) && isset($_SESSION['user_id'])) {
    die('Not Logged in');
}

if ( isset($_POST['delete']) && isset($_POST['profile_id']) ) {
    $sql = "DELETE FROM Profile WHERE profile_id = :zip";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(array(':zip' => $_GET['profile_id']));
    $_SESSION['success'] = 'Record deleted';
    header( 'Location: index.php' ) ;
    return;
}

// Gua
if ( ! isset($_GET['profile_id']) ) {
    $_SESSION['error'] = "Missing profile_id";
    header('Location: index.php');
    return;
}

$stmt = $pdo->prepare("SELECT first_name, last_name FROM Profile where profile_id = :xyz");
$stmt->execute(array(":xyz" => $_GET['profile_id']));
$row = $stmt->fetch(PDO::FETCH_ASSOC);
if ( $row === false ) {
    $_SESSION['error'] = 'Bad value for profile_id';
    header('Location: index.php');
    return;
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Kavitha Raghunath Delete Page</title>
    <?php require_once "bootstrap.php"; ?>
</head>
<body>
<div class="container">
    <h1>Deleting Profile </h1>
    <p> First Name: </br><?php echo $row['first_name'] ?></p>
    <p> Last Name: </br><?php echo $row['last_name'] ?></p>
    <form method="post"><input type="hidden" name="profile_id" value="<?php echo $_GET['profile_id'] ;?>">
      <input type="submit" value="Delete" name="delete">
      <a href="index.php">Cancel</a>
    </form>
</div>
</body>
