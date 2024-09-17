<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once "../models/HistorialMedicoModel.php";

header('Content-Type: application/json');

$historialMedico = new HistorialMedico();

if (isset($_GET['action'])) {
    switch ($_GET['action']) {
        case 'listar':
            try {
                $historiales = $historialMedico->listar();
                echo json_encode($historiales);
            } catch (Exception $e) {
                echo json_encode(['result' => 'error', 'message' => $e->getMessage()]);
            }
            break;

        case 'agregar':
            try {
                $data = [
                    'id_paciente' => $_POST['id_paciente'],
                    'observaciones' => $_POST['OBSERVACIONES'],
                    'fecha' => $_POST['FECHA'],
                    'ID_CONSULTA' => $_POST['ID_CONSULTA']
                ];
                echo json_encode(['result' => $historialMedico->agregar($data) ? 'ok' : 'error']);
            } catch (Exception $e) {
                echo json_encode(['result' => 'error', 'message' => $e->getMessage()]);
            }
            break;
        case 'actualizar':
            try {
                $data = [
                    'id_historial' => $_POST['id_historial'],
                    'observaciones' => $_POST['OBSERVACIONES'],
                    'fecha' => $_POST['FECHA'],
                    'ID_CONSULTA' => $_POST['ID_CONSULTA']
                ];
                echo json_encode(['result' => $historialMedico->actualizar($data) ? 'ok' : 'error']);
            } catch (Exception $e) {
                echo json_encode(['result' => 'error', 'message' => $e->getMessage()]);
            }
            break;
        case 'eliminar':
            try {
                echo json_encode(['result' => $historialMedico->eliminar($_POST['id_historial']) ? 'ok' : 'error']);
            } catch (Exception $e) {
                echo json_encode(['result' => 'error', 'message' => $e->getMessage()]);
            }
            break;
        case 'getPacientes':
            try {
                $pacientes = $historialMedico->obtenerPacientes();
                echo json_encode($pacientes);
            } catch (Exception $e) {
                echo json_encode(['result' => 'error', 'message' => $e->getMessage()]);
            }
            break;
        default:
            echo json_encode(['result' => 'error', 'message' => 'Acción no válida']);
            break;
    }
} else {
    echo json_encode(['result' => 'error', 'message' => 'No se especificó ninguna acción']);
}
