<?php

require_once('../config/cors.php');
require_once('../models/login.model.php');
session_start(); // Iniciar la sesión

$usuario = new Clase_Usuarios();
$metodo = $_SERVER['REQUEST_METHOD'];

switch ($_GET["op"]) {

    case "login":
        $correo = $_POST["CORREO_ELECTRONICO"] ?? null;
        $password = $_POST["PASSWORD"] ?? null;

        if (!empty($correo) && !empty($password)) {
            $login = $usuario->loginParametros($correo, $password);
            $res = mysqli_fetch_assoc($login);

            if ($res) {
                // Verifica la contraseña (esto ya lo haces en tu código)
                if ($res['PASSWORD'] == $password) {
                    // Iniciar la sesión y almacenar los datos del usuario
                    $_SESSION['usuario_id'] = $res['ID_RECEPCIONISTA'] ?? $res['ID_ADMIN'];
                    $_SESSION['usuario_rol'] = $res['rol'];
                    $_SESSION['usuario_nombre'] = $res['NOMBRE'];

                    // Redireccionar según el rol
                    if ($res['rol'] == 'recepcionista') {
                        header('Location: ../views/cita.php');
                    } elseif ($res['rol'] == 'admin') {
                        header('Location: ../views/paciente.php');
                    } else {
                        header('Location: ../index.php?op=4'); // Rol no reconocido
                    }
                    exit();
                } else {
                    header('Location: ../index.php?op=3'); // Contraseña incorrecta
                    exit();
                }
            } else {
                header('Location: ../index.php?op=1'); // Usuario no encontrado
                exit();
            }
        } else {
            header('Location: ../index.php?op=2'); // Faltan datos
            exit();
        }
        break;

    // case "uno":
    //     $ID_RECEPCIONISTA = $_GET["ID_RECEPCIONISTA"] ?? null;
    //     if (!empty($ID_RECEPCIONISTA)) {
    //         $dato = $usuario->uno($ID_RECEPCIONISTA);
    //         $fila = mysqli_fetch_assoc($dato);
    //         if (!empty($fila)) {
    //             echo json_encode($fila);
    //         } else {
    //             echo json_encode(array("message" => "No se encontró el recepcionista"));
    //         }
    //     } else {
    //         echo json_encode(array("message" => "Falta el ID del recepcionista"));
    //     }
    //     break;

    // case "listar":
    //     $ListaRecepcionistas = array();
    //     $dato = $usuario->listarRecepcionista();

    //     while ($fila = mysqli_fetch_assoc($dato)) {
    //         $ListaRecepcionistas[] = $fila;
    //     }

    //     if (!empty($ListaRecepcionistas)) {
    //         echo json_encode($ListaRecepcionistas);
    //     } else {
    //         echo json_encode(array("message" => "No hay recepcionistas"));
    //     }
    // break;

    // case "insertar":
    //     $NOMBRE = $_POST["NOMBRE"] ?? null;
    //     $APELLIDO = $_POST["APELLIDO"] ?? null;
    //     $CORREO_ELECTRONICO = $_POST["CORREO_ELECTRONICO"] ?? null;
    //     $PASSWORD = $_POST["PASSWORD"] ?? null;
    //     $ID_ROL = $_POST["ID_ROL"] ?? null;

    //     if (!empty($CORREO_ELECTRONICO) && !empty($PASSWORD)) {
    //         $insertar = $usuario->insertar($NOMBRE, $APELLIDO, $CORREO_ELECTRONICO, $PASSWORD, $ID_ROL);
    //         echo json_encode($insertar);
    //     } else {
    //         echo json_encode(array("message" => "Faltan Datos"));
    //     }
    //     break;

    // case "actualizar":
    //     $ID_RECEPCIONISTA = $_POST["ID_RECEPCIONISTA"] ?? null;
    //     $NOMBRE = $_POST["NOMBRE"] ?? null;
    //     $APELLIDO = $_POST["APELLIDO"] ?? null;
    //     $CORREO_ELECTRONICO = $_POST["CORREO_ELECTRONICO"] ?? null;
    //     $PASSWORD = $_POST["PASSWORD"] ?? null;
    //     $ID_ROL = $_POST["ID_ROL"] ?? null;

    //     if (!empty($ID_RECEPCIONISTA) && !empty($CORREO_ELECTRONICO) && !empty($PASSWORD)) {
    //         $actualizar = $usuario->actualizar($ID_RECEPCIONISTA, $NOMBRE, $APELLIDO, $CORREO_ELECTRONICO, $PASSWORD, $ID_ROL);
    //         echo json_encode($actualizar);
    //     } else {
    //         echo json_encode(array("message" => "Faltan Datos"));
    //     }
    //     break;

    // case "eliminar":
    //     $ID_RECEPCIONISTA = $_POST["ID_RECEPCIONISTA"] ?? null;
    //     if (!empty($ID_RECEPCIONISTA)) {
    //         $eliminar = $usuario->eliminar($ID_RECEPCIONISTA);
    //         echo json_encode($eliminar);
    //     } else {
    //         echo json_encode(array("message" => "Falta el ID del recepcionista"));
    //     }
    //     break;

}
?>