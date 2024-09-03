<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
header('Content-Type: application/json; charset=utf-8'); // Asegura que la respuesta sea en formato JSON

require_once "../models/cita.model.php"; // Incluye los modelos necesarios

try {
    if (isset($_GET['action'])) {
        switch ($_GET['action']) {
            case 'addCita':
                if ($_SERVER['REQUEST_METHOD'] === 'POST') {
                    $fecha = $_POST['fecha'];
                    $hora = $_POST['hora'];

                    // Comprobar si ya existe una cita en la misma fecha y hora
                    if (CitaModel::existeCitaEnFechaHora($fecha, $hora)) {
                        echo json_encode(["result" => "error", "message" => "Ya existe una cita en esa fecha y hora"]);
                        exit;
                    }

                    $datos = [
                        "id_paciente" => $_POST['id_paciente'],
                        "id_recepcionista" => $_POST['id_recepcionista'],
                        "fecha" => $fecha,
                        "hora" => $hora,
                        "estado" => $_POST['estado'],
                        "id_odontologo" => $_POST['id_odontologo']
                    ];
                    $respuesta = CitaModel::addCita($datos);
                    echo json_encode(["result" => $respuesta ? "ok" : "error"]);
                } else {
                    echo json_encode(["result" => "Método no permitido"]);
                }
                break;

            case 'updateCita':
                if ($_SERVER['REQUEST_METHOD'] === 'POST') {
                    $datos = [
                        "id_cita" => $_POST['id_cita'],
                        "id_paciente" => $_POST['id_paciente'],
                        "id_recepcionista" => $_POST['id_recepcionista'],
                        "fecha" => $_POST['fecha'],
                        "hora" => $_POST['hora'],
                        "estado" => $_POST['estado'],
                        "id_odontologo" => $_POST['id_odontologo']
                    ];
                    $respuesta = CitaModel::updateCita($datos);
                    echo json_encode(["result" => $respuesta ? "ok" : "error"]);
                } else {
                    echo json_encode(["result" => "Método no permitido"]);
                }
                break;

            case 'deleteCita':
                if ($_SERVER['REQUEST_METHOD'] === 'POST') {
                    $id_cita = $_POST['id_cita'];
                    $respuesta = CitaModel::deleteCita($id_cita);
                    echo json_encode(["result" => $respuesta ? "ok" : "error"]);
                } else {
                    echo json_encode(["result" => "Método no permitido"]);
                }
                break;

            case 'listar':
                $citas = CitaModel::getCitas();
                echo json_encode($citas);
                break;

            case 'getPacientes':
                $pacientes = CitaModel::getPacientes();
                echo json_encode($pacientes);
                break;

            case 'getOdontologos':
                $odontologos = CitaModel::getOdontologos();
                echo json_encode($odontologos);
                break;

            default:
                echo json_encode(["result" => "Acción no reconocida"]);
                break;
        }
    } else {
        echo json_encode(["result" => "No se especificó ninguna acción"]);
    }
} catch (Exception $e) {
    http_response_code(400); // Devuelve un código de error HTTP
    echo json_encode(["error" => $e->getMessage()]);
}
?>
