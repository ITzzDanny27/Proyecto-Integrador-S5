<?php
require_once "../models/odontologo.model.php"; // Asegúrate de que la ruta sea correcta

if (isset($_GET['action'])) {
    switch ($_GET['action']) {
        case 'addOdontologo':
            // Obtener datos del formulario
            $datos = [
                
                "NOMBRE" => $_POST['NOMBRE'],
                "APELLIDO" => $_POST['APELLIDO'],
                "ESPECIALIDAD" => $_POST['ESPECIALIDAD'],
                "TELEFONO" => $_POST['TELEFONO'],
                "CORREO_ELECTRONICO" => $_POST['CORREO_ELECTRONICO']
              
            ];

            $respuesta = OdontologoModel::addOdontologo("odontologo", $datos);
            echo json_encode(["result" => $respuesta ? "ok" : "error"]);
            break;

            case 'listar':
                // Verifica si se solicita un paciente específico para editar
                if (isset($_GET['id'])) {
                    $id = $_GET['id'];
                    $odontologo = OdontologoModel::getOdontologoById("odontologo", $id);
                    echo json_encode([$odontologo]);
                } else {
                    // Obtener todos los pacientes desde el modelo
                    $odontologos = OdontologoModel::getOdontologos("odontologo");
                    echo json_encode($odontologos);
                }
                break;

            case 'updateOdontologo':
                // Obtener los datos del formulario
                $datos = [
                    "id_odontologo" => $_POST['id_odontologo'],
                    "NOMBRE" => $_POST['NOMBRE'],
                "APELLIDO" => $_POST['APELLIDO'],
                "ESPECIALIDAD" => $_POST['ESPECIALIDAD'],
                "TELEFONO" => $_POST['TELEFONO'],
                "CORREO_ELECTRONICO" => $_POST['CORREO_ELECTRONICO']
                ];
    
                $respuesta = OdontologoModel::updateOdontologo("odontologo", $datos);
                echo json_encode(["result" => $respuesta ? "ok" : "error"]);
                break;

        case 'deleteOdontologo':
            $id_odontologo = $_POST['id_odontologo'];
            $respuesta = OdontologoModel::deleteOdontologo("odontologo", $id_odontologo);
            echo json_encode(["result" => $respuesta ? "ok" : "error"]);
            break;

        default:
            echo json_encode(["result" => "Acción no reconocida"]);
            break;
    }
}
?>
