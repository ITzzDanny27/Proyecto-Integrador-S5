<?php

require_once("../models/tratamiento.model.php");
$tratamiento = new Clase_Tratamiento();
$metodo = $_SERVER['REQUEST_METHOD'];

switch($_GET["op"]){

    case "uno":
        $ID_TRATAMIENTO = $_GET["id"] ?? null;
        if (!empty($ID_TRATAMIENTO)) {
            $dato = $tratamiento->uno($ID_TRATAMIENTO);
            $fila = mysqli_fetch_assoc($dato);
            if (!empty($fila)) {
                echo json_encode($fila);
            } else {
                echo json_encode(array("message" => "No se encontró el tratamiento"));
            }
        } else {
            echo json_encode(array("message" => "Falta el ID del tratamiento"));
        }
    break;

    case "listar":
        $ListaTratamiento = array();
        $dato = $tratamiento->listarTratamiento();

        while ($fila = mysqli_fetch_assoc($dato)) {
            $ListaTratamiento[] = $fila;
        }

        if (!empty($ListaTratamiento)) {
            echo json_encode($ListaTratamiento);
        } else {
            echo json_encode(array("message" => "No hay tratamientos"));
        }

    break;

    case "insertar":
        $descripcion = $_POST["Descripcion"] ?? null;
        $costo = $_POST["Costo"] ?? null;
        $duracion = $_POST["Duracion"] ?? null;

        if (!empty($descripcion) && !empty($costo) && !empty($duracion)) {
            $insertar = $tratamiento->registrarTratamiento($descripcion, $costo, $duracion);
            echo json_encode($insertar);
        } else {
            echo json_encode("Faltan Datos");
        }
    break;

    case "actualizar" :
        $ID_TRATAMIENTO = $_POST["TratamientoIdE"] ?? null;
        $descripcion = $_POST["DescripcionE"] ?? null;
        $costo = $_POST["CostoE"] ?? null;
        $duracion = $_POST["DuracionE"] ?? null;

        if (!empty($ID_TRATAMIENTO) && !empty($descripcion) && !empty($costo) && !empty($duracion)) {
            $actualizar = $tratamiento->actualizarTratamiento($ID_TRATAMIENTO, $descripcion, $costo, $duracion);
            echo json_encode($actualizar);
        } else {
            echo json_encode("Faltan Datos");
        }
    break;

    case "eliminar":
        $ID_TRATAMIENTO = $_POST["ID_TRATAMIENTO"] ?? null;
        if (!empty($ID_TRATAMIENTO)) {
            $eliminar = $tratamiento->eliminarTratamiento($ID_TRATAMIENTO);
            echo json_encode($eliminar);
        } else {
            echo json_encode("Falta el ID del tratamiento");
        }
    break;

    case "listarCombo":
        $ListaTratamiento = array();
        $dato = $tratamiento->listarComboTratamiento();

        while ($fila = mysqli_fetch_assoc($dato)) {
            $ListaTratamiento[] = $fila;
        }

        if (!empty($ListaTratamiento)) {
            echo json_encode($ListaTratamiento);
        } else {
            echo json_encode(array("message" => "No hay tratamientos"));
        }
    break;

}?>