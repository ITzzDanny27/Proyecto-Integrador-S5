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
            $login = $usuario->loginParametros($correo, $password); // Recibe datos directamente del modelo
            if (isset($login['error'])) {
                // Si hubo un error (por ejemplo, usuario no encontrado o contraseña incorrecta)
                header('Location: ../index.php?op=1'); // Usuario no encontrado o error en el login
                exit();
            }

            // Verifica la contraseña:
            if ($login['rol'] == 'recepcionista') {
                // Para recepcionista, usamos password_verify()
                if (password_verify($password, $login['PASSWORD'])) {
                    // Iniciar la sesión y almacenar los datos del usuario
                    $_SESSION['usuario_id'] = $login['ID_RECEPCIONISTA'];
                    $_SESSION['usuario_rol'] = $login['rol'];
                    $_SESSION['usuario_nombre'] = $login['NOMBRE'];

                    $_SESSION['mensaje'] = 'Bienvenido, recepcionista!';
                    header('Location: ../views/cita.php');
                    exit();
                } else {
                    // Contraseña incorrecta para recepcionista
                    header('Location: ../index.php?op=3');
                    exit();
                }
            } elseif ($login['rol'] == 'admin') {
                // Para admin, comparamos la contraseña en texto plano
                if ($password === $login['PASSWORD']) {
                    // Iniciar la sesión y almacenar los datos del usuario
                    $_SESSION['usuario_id'] = $login['ID_ADMIN'];
                    $_SESSION['usuario_rol'] = $login['rol'];
                    $_SESSION['usuario_nombre'] = $login['NOMBRE'];

                    $_SESSION['mensaje'] = 'Bienvenido, administrador!';
                    header('Location: ../views/paciente.php');
                    exit();
                } else {
                    // Contraseña incorrecta para admin
                    header('Location: ../index.php?op=3');
                    exit();
                }
            } else {
                // Rol no reconocido
                header('Location: ../index.php?op=4');
                exit();
            }
        } else {
            header('Location: ../index.php?op=2'); // Faltan datos
            exit();
        }
        break;

    // Otros casos...

}
?>