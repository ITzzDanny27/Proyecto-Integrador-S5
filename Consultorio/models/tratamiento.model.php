<?php 

require_once("../config/conexion.php");

class Clase_Tratamiento {

    public function listarTratamiento() {
        $conexion = new Clase_Conectar();
        $con = $conexion->conectar();
        $sql = "SELECT * FROM tratamiento";
        
        $datos = mysqli_query($con, $sql);
        $con->close();
        return $datos;

        // $stmt = $con->prepare($sql);
        // $stmt->execute();
        // $result = $stmt->get_result();
        // return $result;
    }

    public function registrarTratamiento($DESCRIPCION, $COSTO, $DURACION) {
        $conexion = new Clase_Conectar();
        $con = $conexion->conectar();

        $sql = "INSERT INTO tratamiento (DESCRIPCION, COSTO, DURACION) VALUES (?, ?, ?)";
        
        $stmt = $con->prepare($sql);
        $stmt->bind_param("ssd", $DESCRIPCION, $DURACION, $COSTO);

        $resultado = $stmt->execute();

        if ($resultado) {
            $respuesta = array("message" => "Tratamiento registrada correctamente");
        } else {
            $respuesta = array("message" => "Error al registrar el tratamiento: " . $stmt->error);
        }

        $stmt->close();
        $con->close();

        return $respuesta;
    }
}