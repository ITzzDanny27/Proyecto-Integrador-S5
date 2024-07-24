<?php

require_once("../models/tratamiento.model.php");
$tratamiento = new Clase_Tratamiento();
$metodo = $_SERVER['REQUEST_METHOD'];

switch($_GET["op"]){

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
            $registro = $tratamiento->registrarTratamiento($descripcion, $costo, $duracion);
            echo json_encode($registro);
        } else {
            echo json_encode("Faltan Datos");
        }
    break;
}