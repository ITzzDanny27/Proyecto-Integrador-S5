<?php 

require_once("../config/conexion.php");

class Clase_Tratamiento {

    public function uno ($ID_TRATAMIENTO) {
        $conexion = new Clase_Conectar();
        $con = $conexion->conectar();
        $sql = "SELECT * FROM tratamiento WHERE ID_TRATAMIENTO = ?";
        $stmt = $con->prepare($sql);
        $stmt->bind_param("i", $ID_TRATAMIENTO);
        $stmt->execute();
        $resultado = $stmt->get_result();
        $con->close();
        return $resultado;
    }

    public function listarTratamiento() {
        $conexion = new Clase_Conectar();
        $con = $conexion->conectar();
        $sql = "SELECT * FROM tratamiento";
        
        $datos = mysqli_query($con, $sql);
        $con->close();
        return $datos;
    }

    public function registrarTratamiento($DESCRIPCION, $COSTO, $DURACION) {
        $conexion = new Clase_Conectar();
        $con = $conexion->conectar();

        $sql = "INSERT INTO tratamiento (DESCRIPCION, COSTO, DURACION) VALUES (?, ?, ?)";
        
        $stmt = $con->prepare($sql);
        $stmt->bind_param("sds", $DESCRIPCION, $COSTO, $DURACION);

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

    public function actualizarTratamiento($ID_TRATAMIENTO, $DESCRIPCION, $COSTO, $DURACION) {
        $conexion = new Clase_Conectar();
        $con = $conexion->conectar();

        $sql = "UPDATE tratamiento SET DESCRIPCION = ?, COSTO = ?, DURACION = ? WHERE ID_TRATAMIENTO = ?";

        $stmt = $con->prepare($sql);
        $stmt->bind_param("sdsi", $DESCRIPCION, $COSTO, $DURACION, $ID_TRATAMIENTO);

        $resultado = $stmt->execute();

        if ($resultado) {
            $respuesta = array("message" => "Tratamiento actualizado correctamente");
        } else {
            $respuesta = array("message" => "Error al actualizar el tratamiento: " . $stmt->error);
        }

        $stmt->close();
        $con->close();

        return $respuesta;
    }
    
    public function eliminarTratamiento($ID_TRATAMIENTO) {
        $conexion = new Clase_Conectar();
        $con = $conexion->conectar();

        $sql = "DELETE FROM tratamiento WHERE ID_TRATAMIENTO = ?";

        $stmt = $con->prepare($sql);
        $stmt->bind_param("i", $ID_TRATAMIENTO);

        $resultado = $stmt->execute();

        if ($resultado) {
            $respuesta = array("message" => "Tratamiento eliminado correctamente");
        } else {
            $respuesta = array("message" => "Error al eliminar el tratamiento: " . $stmt->error);
        }

        $stmt->close();
        $con->close();

        return $respuesta;
    }

    public function listarComboTratamiento() {
        $conexion = new Clase_Conectar();
        $con = $conexion->conectar();
        $sql = "SELECT ID_TRATAMIENTO, DESCRIPCION FROM tratamiento";

        $datos = mysqli_query($con, $sql);
        $con->close();
        return $datos;
    }
}
?>