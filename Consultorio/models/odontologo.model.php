<?php
require_once "../config/conexion.php"; // Asegúrate de que este archivo esté correctamente configurado

class OdontologoModel {

    // Función para obtener todos los pacientes
    public static function getOdontologos($tabla) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "SELECT * FROM $tabla";
        $stmt = $db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();

        $odontologos = [];
        while ($row = $result->fetch_assoc()) {
            $odontologos[] = $row;
        }

        $stmt->close();
        $db->close();

        return $odontologos;
    }

    // Función para insertar un nuevo paciente
    public static function addOdontologo($tabla, $datos) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        // Validar correo electrónico
        if (!filter_var($datos['CORREO_ELECTRONICO'], FILTER_VALIDATE_EMAIL)) {
            return ['result' => 'error', 'message' => 'El correo electrónico no es válido.'];
        }

        $query = "INSERT INTO $tabla (NOMBRE, APELLIDO, ESPECIALIDAD, TELEFONO, CORREO_ELECTRONICO) VALUES (?, ?, ?, ?, ?)";
        $stmt = $db->prepare($query);
        $stmt->bind_param("sssss", $datos['NOMBRE'], $datos['APELLIDO'], $datos['ESPECIALIDAD'], $datos['TELEFONO'], $datos['CORREO_ELECTRONICO']);
        $result = $stmt->execute();
        $stmt->close();
        $db->close();

        return $result ? ['result' => 'ok'] : ['result' => 'error', 'message' => 'Error al guardar el odontólogo.'];
    }
    

      // Nueva función para obtener un paciente por ID
      public static function getOdontologoById($tabla, $id) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "SELECT * FROM $tabla WHERE id_odontologo = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();

        $odontologo = $result->fetch_assoc();

        $stmt->close();
        $db->close();

        return $odontologo;
    }

    // Función para actualizar un paciente
    public static function updateOdontologo($tabla, $datos) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        // Validar correo electrónico
        if (!filter_var($datos['CORREO_ELECTRONICO'], FILTER_VALIDATE_EMAIL)) {
            return ['result' => 'error', 'message' => 'El correo electrónico no es válido.'];
        }

        $query = "UPDATE $tabla SET NOMBRE = ?, APELLIDO = ?, ESPECIALIDAD = ?, TELEFONO = ?, CORREO_ELECTRONICO = ? WHERE id_odontologo = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("sssssi", $datos['NOMBRE'], $datos['APELLIDO'], $datos['ESPECIALIDAD'], $datos['TELEFONO'], $datos['CORREO_ELECTRONICO'], $datos['id_odontologo']);
        $result = $stmt->execute();
        $stmt->close();
        $db->close();

        return $result ? ['result' => 'ok'] : ['result' => 'error', 'message' => 'Error al actualizar el odontólogo.'];
    }

    // Función para eliminar un paciente
    public static function deleteOdontologo($tabla, $id_odontologo) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "DELETE FROM $tabla WHERE id_odontologo = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("i", $id_odontologo);
        $result = $stmt->execute();
        $stmt->close();
        $db->close();

        return $result;
    }
}
?>
