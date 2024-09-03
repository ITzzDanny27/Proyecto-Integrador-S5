<?php
require_once "../config/conexion.php"; // Asegúrate de que la ruta sea correcta

class CitaModel {

    // Función para obtener todas las citas
    public static function getCitas() {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "SELECT c.ID_CITA, p.PRIMER_NOMBRE AS PACIENTE_NOMBRE, p.APELLIDO_PATERNO AS PACIENTE_APELLIDO, 
                         o.NOMBRE AS ODONTOLOGO_NOMBRE, o.APELLIDO AS ODONTOLOGO_APELLIDO, c.FECHA, c.HORA, c.ESTADO 
                  FROM cita c 
                  JOIN paciente p ON c.ID_PACIENTE = p.ID_PACIENTE 
                  JOIN cita_x_odontologo co ON c.ID_CITA = co.ID_CITA 
                  JOIN odontologo o ON co.ID_ODONTOLOGO = o.ID_ODONTOLOGO";
        $stmt = $db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();

        $citas = [];
        while ($row = $result->fetch_assoc()) {
            $citas[] = $row;
        }

        $stmt->close();
        $db->close();

        return $citas;
    }

    // Función para insertar una nueva cita
    public static function addCita($datos) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        // Inserta en la tabla cita
        $query = "INSERT INTO cita (ID_PACIENTE, ID_RECEPCIONISTA, FECHA, HORA, ESTADO) VALUES (?, ?, ?, ?, ?)";
        $stmt = $db->prepare($query);
        $stmt->bind_param("iisss", $datos['id_paciente'], $datos['id_recepcionista'], $datos['fecha'], $datos['hora'], $datos['estado']);
        $result = $stmt->execute();
        $id_cita = $db->insert_id; // Obtén el último ID insertado
        $stmt->close();

        if ($result) {
            // Inserta en la tabla cita_x_odontologo
            $query = "INSERT INTO cita_x_odontologo (ID_CITA, ID_ODONTOLOGO) VALUES (?, ?)";
            $stmt = $db->prepare($query);
            $stmt->bind_param("ii", $id_cita, $datos['id_odontologo']);
            $result = $stmt->execute();
            $stmt->close();
        }

        $db->close();
        return $result;
    }

    // Función para actualizar una cita
    public static function updateCita($datos) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        // Actualiza la tabla cita
        $query = "UPDATE cita SET ID_PACIENTE = ?, ID_RECEPCIONISTA = ?, FECHA = ?, HORA = ?, ESTADO = ? WHERE ID_CITA = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("iisssi", $datos['id_paciente'], $datos['id_recepcionista'], $datos['fecha'], $datos['hora'], $datos['estado'], $datos['id_cita']);
        $result = $stmt->execute();
        $stmt->close();

        if ($result) {
            // Actualiza la tabla cita_x_odontologo
            $query = "UPDATE cita_x_odontologo SET ID_ODONTOLOGO = ? WHERE ID_CITA = ?";
            $stmt = $db->prepare($query);
            $stmt->bind_param("ii", $datos['id_odontologo'], $datos['id_cita']);
            $result = $stmt->execute();
            $stmt->close();
        }

        $db->close();
        return $result;
    }

    // Función para eliminar una cita
    public static function deleteCita($id_cita) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        // Elimina de la tabla cita_x_odontologo
        $query = "DELETE FROM cita_x_odontologo WHERE ID_CITA = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("i", $id_cita);
        $result = $stmt->execute();
        $stmt->close();

        if ($result) {
            // Elimina de la tabla cita
            $query = "DELETE FROM cita WHERE ID_CITA = ?";
            $stmt = $db->prepare($query);
            $stmt->bind_param("i", $id_cita);
            $result = $stmt->execute();
            $stmt->close();
        }

        $db->close();
        return $result;
    }

    // Función para obtener una cita por ID
    public static function getCitaById($id) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "SELECT * FROM cita WHERE ID_CITA = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();

        $cita = $result->fetch_assoc();

        $stmt->close();
        $db->close();

        return $cita;
    }

    // Función para verificar si existe una cita en la misma fecha y hora
    public static function existeCitaEnFechaHora($fecha, $hora) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "SELECT COUNT(*) as total FROM cita WHERE FECHA = ? AND HORA = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("ss", $fecha, $hora);
        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();

        $stmt->close();
        $db->close();

        return $row['total'] > 0; // Devuelve true si ya existe una cita
    }

    // Función para obtener todos los pacientes
    public static function getPacientes() {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "SELECT ID_PACIENTE, PRIMER_NOMBRE, APELLIDO_PATERNO FROM paciente";
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

    // Función para obtener todos los odontólogos
    public static function getOdontologos() {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "SELECT ID_ODONTOLOGO, NOMBRE, APELLIDO FROM odontologo";
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
}
?>
