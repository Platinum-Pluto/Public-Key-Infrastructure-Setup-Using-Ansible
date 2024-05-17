<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);
//phpinfo();
// Function to connect to the database
//echo '<a href="temp.crt" download> Download Your Signed tificate</a>';
function connect_db()
{
        $host = "localhost";
        $port = 5432;
        $dbname = "cm";
        $user = "postgres";
        $password = "postgres"; // adjust the password
        $connection_string = "host={$host} port={$port} dbname={$dbname} user={$user} password={$password}";
        $dbconn = pg_connect($connection_string);
        if (!$dbconn) {
                die("Connection failed: " . pg_last_error());
        }
        return $dbconn;
}

// Handling the form submission
if (isset($_POST['add'])) {

        $dbconn = connect_db();
        $fileP = $_FILES['resume']['tmp_name'];
        //	print_r($fileP);
        $position = pg_escape_string($dbconn, $_POST['position']);
        //	echo "Output here:";
        // Handle the uploaded file
        $fileTmpPath = $_FILES['resume']['tmp_name'];
        $pemdata = file_get_contents($fileTmpPath);
        //	echo $pemdata;
        $fp = fopen($fileTmpPath, 'rb'); // read binary


        $filelines = file("AcmeSubCATwoSigner.conf");
        $filelines[count($filelines) - 2] = "DNS.1 = $position\n";
        $filelines[count($filelines) - 1] = "DNS.2 = www.$position";
        file_put_contents("AcmeSubCATwoSigner.conf", implode("", $filelines));

        //echo '<a href="temp.crt" download> Download Your Signed tificate</a>';

        if ($fp && $fileTmpPath) {
                // Prepare the INSERT statement
                $query = "INSERT INTO data (name, position, resume, ver) VALUES ($1, $2, $3, $4)";
                $result = pg_query_params($dbconn, $query, array($filename, $position, $fp, $pemdata));
                if ($result) {
                        echo "SUCCESS";
                        // header("Location:./");
                        echo '<a href="temp.crt" download> Download Your Signed tificate</a>';

                } else {
                        //    header("Location:./");
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
        <title>ACME CA</title>

        <style>
                body {
                        font-family: Arial, sans-serif;
                        margin: 0;
                        padding: 0;
                        background-color: #f5f5f5;
                }

                .container {
                        max-width: 600px;
                        margin: 50px auto;
                        background-color: #fff;
                        padding: 20px;
                        border-radius: 8px;
                        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }

                h2 {
                        color: #333;
                }

                form {
                        margin-top: 20px;
                }

                label {
                        display: block;
                        margin-bottom: 5px;
                        font-weight: bold;
                }

                input[type="file"],
                input[type="text"] {
                        width: 100%;
                        padding: 10px;
                        margin-bottom: 15px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                        box-sizing: border-box;
                }

                button {
                        background-color: #4caf50;
                        color: #fff;
                        padding: 10px 20px;
                        border: none;
                        border-radius: 5px;
                        cursor: pointer;
                }

                button:hover {
                        background-color: #45a049;
                }

                ol {
                        margin-top: 20px;
                        padding-left: 20px;
                }

                li {
                        margin-bottom: 10px;
                }
        </style>


        <script>
                function showbutton() {
                        setTimeout(function () {
                                document.getElementById("download").style.display = "block";
                        }, 5000);
                }
        </script>




</head>

<body>
        <div class="container">
                <h2> AcmeCA CSR Signer Website</h2>
                <h4>Follow the instructions below</h4>
                <ol>
                        <li>Upload your CSR file and provide your Domain name.</li>
                        <li>Then Click the "Submit Query" button.</li>
                        <li>Wait for the certificate to be generated.</li>
                        <li>Download the signed certificate.</li>
                </ol>



                <form method="POST" action="index.php" enctype="multipart/form-data">
                        <label for="position">Your Domain Name:</label><br>
                        <input type="text" id="position" name="position" required><br><br>

                        <label for="resume">Upload your CSR here (.pem file format):</label><br>
                        <input type="file" id="resume" name="resume" required><br><br>

                        <input type="submit" name="add" onclick="showbutton()">

                </form>

                <button id="download" style="display: none;"> <a href="/home/hostVM_Username/Desktop/temp.crt" download>
                                Download Your Signed Certificate></a></button>

</body>

</html>