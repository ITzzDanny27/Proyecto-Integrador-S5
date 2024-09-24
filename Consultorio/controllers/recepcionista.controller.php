<?php
require_once "../models/recepcionista.model.php"; // Asegúrate de que la ruta sea correcta

if (isset($_GET['action'])) {
    switch ($_GET['action']) {
        case 'addRecepcionista':
            // Obtener datos del formulario
            $datos = [
                "nombre" => $_POST['nombre'],
                "apellido" => $_POST['apellido'],
                "telefono" => $_POST['telefono'],
                "correo_electronico" => $_POST['correo_electronico'],
                "password" => $_POST['password']

            ];

            $respuesta = RecepcionistaModel::addRecepcionista("recepcionista", $datos);
            echo json_encode(["result" => $respuesta ? "ok" : "error"]);
            break;

            case 'listar':
                // Verifica si se solicita un paciente específico para editar
                if (isset($_GET['id'])) {
                    $id = $_GET['id'];
                    $recepcionista = RecepcionistaModel::getRecepcionistaById("recepcionista", $id);
                    echo json_encode([$recepcionista]);
                } else {
                    // Obtener todos los pacientes desde el modelo
                    $recepcionistas = RecepcionistaModel::getRecepcionistas("recepcionista");
                    echo json_encode($recepcionistas);
                }
                break;

            case 'updateRecepcionista':
                // Obtener los datos del formulario
                $datos = [
                    "id_recepcionista" => $_POST['id_recepcionista'],
                    "nombre" => $_POST['nombre'],
                    "apellido" => $_POST['apellido'],
                    "telefono" => $_POST['telefono'],
                    "correo_electronico" => $_POST['correo_electronico'],
                    "password" => $_POST['password']
                ];
    
                $respuesta = RecepcionistaModel::updateRecepcionista("recepcionista", $datos);
                echo json_encode(["result" => $respuesta ? "ok" : "error"]);
                break;

        case 'deleteRecepcionista':
            $id_recepcionista = $_POST['id_recepcionista'];
            $respuesta = RecepcionistaModel::deleteRecepcionista("recepcionista", $id_recepcionista);
            echo json_encode(["result" => $respuesta ? "ok" : "error"]);
            break;

        default:
            echo json_encode(["result" => "Acción no reconocida"]);
            break;
    }
}
?>