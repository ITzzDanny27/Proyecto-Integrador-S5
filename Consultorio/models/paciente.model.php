<?php
require_once "../config/conexion.php"; // Asegúrate de que este archivo esté correctamente configurado

class PacienteModel {

    // Función para obtener todos los pacientes
    public static function getPacientes($tabla) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "SELECT * FROM $tabla";
        $stmt = $db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();

        $pacientes = [];
        while ($row = $result->fetch_assoc()) {
            $pacientes[] = $row;
        }

        $stmt->close();
        $db->close();

        return $pacientes;
    }

    // Función para insertar un nuevo paciente
    public static function addPaciente($tabla, $datos) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "INSERT INTO $tabla (PRIMER_NOMBRE, SEGUNDO_NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, FECHA_NACIMIENTO, TELEFONO, CORREO_ELECTRONICO, DIRECCION) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $db->prepare($query);
        $stmt->bind_param("ssssssss", $datos['primer_nombre'], $datos['segundo_nombre'], $datos['apellido_paterno'], $datos['apellido_materno'], $datos['fecha_nacimiento'], $datos['telefono'], $datos['correo_electronico'], $datos['direccion']);
        $result = $stmt->execute();
        $stmt->close();
        $db->close();

        return $result;
    }

      // Nueva función para obtener un paciente por ID
      public static function getPacienteById($tabla, $id) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "SELECT * FROM $tabla WHERE ID_PACIENTE = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();

        $paciente = $result->fetch_assoc();

        $stmt->close();
        $db->close();

        return $paciente;
    }

    // Función para actualizar un paciente
    public static function updatePaciente($tabla, $datos) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "UPDATE $tabla SET PRIMER_NOMBRE = ?, SEGUNDO_NOMBRE = ?, APELLIDO_PATERNO = ?, APELLIDO_MATERNO = ?, FECHA_NACIMIENTO = ?, TELEFONO = ?, CORREO_ELECTRONICO = ?, DIRECCION = ? WHERE ID_PACIENTE = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("ssssssssi", $datos['primer_nombre'], $datos['segundo_nombre'], $datos['apellido_paterno'], $datos['apellido_materno'], $datos['fecha_nacimiento'], $datos['telefono'], $datos['correo_electronico'], $datos['direccion'], $datos['id_paciente']);
        $result = $stmt->execute();
        $stmt->close();
        $db->close();

        return $result;
    }

    // Función para eliminar un paciente
    public static function deletePaciente($tabla, $id_paciente) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "DELETE FROM $tabla WHERE ID_PACIENTE = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("i", $id_paciente);
        $result = $stmt->execute();
        $stmt->close();
        $db->close();

        return $result;
    }
}
?>
