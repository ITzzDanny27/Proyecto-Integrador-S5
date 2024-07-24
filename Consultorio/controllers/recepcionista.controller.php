<?php
error_reporting(1);
require_once('../config/cors.php');
require_once('../models/recepcionista.model.php');

$usuario = new Clase_Usuarios();
$metodo = $_SERVER['REQUEST_METHOD'];

// $_POST   insertar
// $_GET    select 
// $_PUT    actualizar
// $_DELETE   eliminar
// www.google.com?Nombre=Luis

switch ($metodo) {
    case "GET":
        if (isset($_GET["ID_RECEPCIONISTA"])) {
            $uno = $usuario->uno($_GET["ID_RECEPCIONISTA"]);
            echo json_encode(mysqli_fetch_assoc($uno));
        } else {
            $datos = $usuario->todos();
            $todos = array();
            while ($fila = mysqli_fetch_assoc($datos)) {
                array_push($todos, $fila);
            }
            echo json_encode($todos);
        }
        break;
    case "POST":
        if (isset($_GET["op"]) && $_GET["op"] == "login") {
            if (empty(trim($_POST["CORREO_ELECTRONICO"])) || empty(trim($_POST["PASSWORD"]))) {
                header('Location: ../index.php?op=2');
                exit();
            }
            $correo = $_POST["CORREO_ELECTRONICO"];
            $password = $_POST["PASSWORD"];

            $login = $usuario->loginParametros($correo, $password);
            $res = mysqli_fetch_assoc($login);
            if ($res) {
                if ($res['PASSWORD'] == $password) {
                    header('Location: ../views/paciente.php');
                    exit();
                } else {
                    header('Location: ../index.php?op=3');
                    exit();
                }
            } else {
                header('Location: ../index.php?op=1');
                exit();
            }
        } elseif (isset($_GET["op"]) && $_GET["op"] == "actualizar") {
            $ID_RECEPCIONISTA = $_POST["ID_RECEPCIONISTA"];
            $NOMBRE = $_POST["NOMBRE"];
            $APELLIDO = $_POST["APELLIDO"];
            $CORREO_ELECTRONICO = $_POST["CORREO_ELECTRONICO"];
            $PASSWORD = $_POST["PASSWORD"];
            $ID_ROL = $_POST["ID_ROL"];
            if (!empty($ID_RECEPCIONISTA) && !empty($CORREO_ELECTRONICO) && !empty($PASSWORD)) {
                $actualizar = $usuario->actualizar($ID_RECEPCIONISTA, $NOMBRE, $APELLIDO, $CORREO_ELECTRONICO, $PASSWORD, $ID_ROL);
                if ($actualizar) {
                    echo json_encode(array("message" => "Se actualizó correctamente"));
                } else {
                    echo json_encode(array("message" => "Error, no se actualizó"));
                }
            } else {
                echo json_encode(array("message" => "Error, faltan datos: " . $ID_RECEPCIONISTA . " " . $NOMBRE . " " . $APELLIDO . " " . $CORREO_ELECTRONICO . " " . $PASSWORD . " " . $ID_ROL));
            }
        } else {
            $NOMBRE = $_POST["NOMBRE"];
            $APELLIDO = $_POST["APELLIDO"];
            $CORREO_ELECTRONICO = $_POST["CORREO_ELECTRONICO"];
            $PASSWORD = $_POST["PASSWORD"];
            $ID_ROL = $_POST["ID_ROL"];
            if (!empty($CORREO_ELECTRONICO) && !empty($PASSWORD)) {
                $insertar = $usuario->insertar($NOMBRE, $APELLIDO, $CORREO_ELECTRONICO, $PASSWORD, $ID_ROL);
                if ($insertar) {
                    echo json_encode(array("message" => "Se insertó correctamente"));
                } else {
                    echo json_encode(array("message" => "Error, no se insertó"));
                }
            } else {
                echo json_encode(array("message" => "Error, faltan datos"));
            }
        }
        break;
    case "PUT":
        // Aquí puedes agregar el manejo de actualización si es necesario
        break;
    case "DELETE":
        $datos = json_decode(file_get_contents('php://input'));
        if (!empty($datos->ID_RECEPCIONISTA)) {
            try {
                $eliminar = $usuario->eliminar($datos->ID_RECEPCIONISTA);
                echo json_encode(array("message" => "Se eliminó correctamente"));
            } catch (Exception $th) {
                echo json_encode(array("message" => "Error, no se eliminó"));
            }
        } else {
            echo json_encode(array("message" => "Error, no se envió el id"));
        }
        break;
    case "login":
        // No es necesario ya que el login se maneja en POST
        break;
}
?>