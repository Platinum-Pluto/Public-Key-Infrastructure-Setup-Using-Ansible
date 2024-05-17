<?php
// Function to connect to the database
function connect_db() {
 $host = "cnn.com";
 $port = 5432;
 $dbname = "vss";
 $user = "postgres";
 $password = "postgres"; // adjust the password
 $connection_string = "host={$host} port={$port} dbname={$dbname} user={$user} 
password={$password}";
 $dbconn = pg_connect($connection_string);
 if(!$dbconn) {
 die("Connection failed: " . pg_last_error());
 }
 return $dbconn;
}
// Handling the form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
 $dbconn = connect_db();
 $name = pg_escape_string($dbconn, $_POST['name']);
 $position = pg_escape_string($dbconn, $_POST['position']);
 $salary = (float)$_POST['salary'];
 // Handle the uploaded file
 $fileTmpPath = $_FILES['resume']['tmp_name'];
 $fp = fopen($fileTmpPath, 'rb'); // read binary
 if ($fp && $fileTmpPath) {
 // Prepare the INSERT statement
 $query = "INSERT INTO employees (name, position, salary, resume) VALUES ($1, $2, 
$3, $4)";
 $result = pg_query_params($dbconn, $query, array($name, $position, $salary, $fp));
 if($result){
 echo "<h3>Employee added successfully!</h3>";
 } else {
 echo "<h3>Error: " . pg_last_error($dbconn) . "</h3>";
 }
 fclose($fp);
 } else {
 echo "<h3>Error uploading file!</h3>";
 }
 pg_close($dbconn);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
 <meta charset="UTF-8">
 <title>Add Employee</title>
</head>
<body>
 <h2>Add New Employee</h2>
 <form method="POST" action="index.php" enctype="multipart/form-data">
 <label for="name">Name:</label><br>
 <input type="text" id="name" name="name" required><br><br>
 <label for="position">Position:</label><br>
 <input type="text" id="position" name="position" required><br><br>
 <label for="salary">Salary:</label><br>
 <input type="text" id="salary" name="salary" required><br><br>
 <label for="resume">Resume (PDF only):</label><br>
 <input type="file" id="resume" name="resume" accept=".pdf" required><br><br>
 <input type="submit" value="Submit">
 </form>
</body>
</html>