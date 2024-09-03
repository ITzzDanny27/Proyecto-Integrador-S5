<?php
require_once "../models/paciente.model.php"; // Asegúrate de que la ruta sea correcta

if (isset($_GET['action'])) {
    switch ($_GET['action']) {
        case 'addPaciente':
            // Obtener datos del formulario
            $datos = [
                "primer_nombre" => $_POST['primer_nombre'],
                "segundo_nombre" => $_POST['segundo_nombre'],
                "apellido_paterno" => $_POST['apellido_paterno'],
                "apellido_materno" => $_POST['apellido_materno'],
                "fecha_nacimiento" => $_POST['fecha_nacimiento'],
                "telefono" => $_POST['telefono'],
                "correo_electronico" => $_POST['correo_electronico'],
                "direccion" => $_POST['direccion']
            ];

            $respuesta = PacienteModel::addPaciente("paciente", $datos);
            echo json_encode(["result" => $respuesta ? "ok" : "error"]);
            break;

            case 'listar':
                // Verifica si se solicita un paciente específico para editar
                if (isset($_GET['id'])) {
                    $id = $_GET['id'];
                    $paciente = PacienteModel::getPacienteById("paciente", $id);
                    echo json_encode([$paciente]);
                } else {
                    // Obtener todos los pacientes desde el modelo
                    $pacientes = PacienteModel::getPacientes("paciente");
                    echo json_encode($pacientes);
                }
                break;

            case 'updatePaciente':
                // Obtener los datos del formulario
                $datos = [
                    "id_paciente" => $_POST['id_paciente'],
                    "primer_nombre" => $_POST['primer_nombre'],
                    "segundo_nombre" => $_POST['segundo_nombre'],
                    "apellido_paterno" => $_POST['apellido_paterno'],
                    "apellido_materno" => $_POST['apellido_materno'],
                    "fecha_nacimiento" => $_POST['fecha_nacimiento'],
                    "telefono" => $_POST['telefono'],
                    "correo_electronico" => $_POST['correo_electronico'],
                    "direccion" => $_POST['direccion']
                ];
    
                $respuesta = PacienteModel::updatePaciente("paciente", $datos);
                echo json_encode(["result" => $respuesta ? "ok" : "error"]);
                break;

        case 'deletePaciente':
            $id_paciente = $_POST['id_paciente'];
            $respuesta = PacienteModel::deletePaciente("paciente", $id_paciente);
            echo json_encode(["result" => $respuesta ? "ok" : "error"]);
            break;

        default:
            echo json_encode(["result" => "Acción no reconocida"]);
            break;
    }
}
?>
