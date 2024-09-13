<?php
require_once "../models/consulta.model.php";

if (isset($_GET['action'])) {
    switch ($_GET['action']) {
        case 'addConsulta':
            $datos = [
                "ID_CITA" => $_POST['ID_CITA'],
                "ID_TRATAMIENTO" => $_POST['ID_TRATAMIENTO'],
                "DESCRIPCION" => $_POST['DESCRIPCION']
            ];

            $respuesta = ConsultaModel::addConsulta("consulta", $datos);
            echo json_encode(["result" => $respuesta ? "ok" : "error"]);
            break;

        case 'listar':
            if (isset($_GET['id'])) {
                $id = $_GET['id'];
                $consulta = ConsultaModel::getConsultaById("consulta", $id);
                echo json_encode([$consulta]);
            } else {
                $consultas = ConsultaModel::getConsultas("consulta");
                echo json_encode($consultas);
            }
            break;

        case 'updateConsulta':
            $datos = [
                "id_consulta" => $_POST['id_consulta'],
                "ID_CITA" => $_POST['ID_CITA'],
                "ID_TRATAMIENTO" => $_POST['ID_TRATAMIENTO'],
                "DESCRIPCION" => $_POST['DESCRIPCION']
            ];

            $respuesta = ConsultaModel::updateConsulta("consulta", $datos);
            echo json_encode(["result" => $respuesta ? "ok" : "error"]);
            break;

        case 'deleteConsulta':
            $id_consulta = $_POST['id_consulta'];
            $respuesta = ConsultaModel::deleteConsulta("consulta", $id_consulta);
            echo json_encode(["result" => $respuesta ? "ok" : "error"]);
            break;

            // Nuevas acciones para listar citas y tratamientos
        case 'listarCitas':
            $citas = ConsultaModel::getCitas("cita");
            echo json_encode($citas);
            break;

        case 'listarTratamientos':
            $tratamientos = ConsultaModel::getTratamientos("tratamiento");
            echo json_encode($tratamientos);
            break;

        default:
            echo json_encode(["result" => "Acción no reconocida"]);
            break;
    }
}
