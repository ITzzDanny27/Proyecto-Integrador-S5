<?php
require_once "../config/conexion.php"; // Asegúrate de que este archivo esté correctamente configurado

class RecepcionistaModel {

    // Función para obtener todos los pacientes
    public static function getRecepcionistas($tabla) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "SELECT * FROM $tabla";
        $stmt = $db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();

        $recepcionistas = [];
        while ($row = $result->fetch_assoc()) {
            $recepcionistas[] = $row;
        }

        $stmt->close();
        $db->close();

        return $recepcionistas;
    }

    // Función para insertar un nuevo paciente
    public static function addRecepcionista($tabla, $datos) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "INSERT INTO $tabla (NOMBRE, APELLIDO, TELEFONO, CORREO_ELECTRONICO, PASSWORD) VALUES (?, ?, ?, ?, ?)";
        $stmt = $db->prepare($query);
        $stmt->bind_param("sssss", $datos['nombre'], $datos['apellido'], $datos['telefono'], $datos['correo_electronico'], $datos['password']);
        $result = $stmt->execute();
        $stmt->close();
        $db->close();

        return $result;
    }

      // Nueva función para obtener un paciente por ID
      public static function getRecepcionistaById($tabla, $id) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "SELECT * FROM $tabla WHERE ID_RECEPCIONISTA = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();

        $recepcionista = $result->fetch_assoc();

        $stmt->close();
        $db->close();

        return $recepcionista;
    }

    // Función para actualizar un paciente
    public static function updateRecepcionista($tabla, $datos) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();
    
        // Agregar la cláusula WHERE para actualizar el registro correcto
        $query = "UPDATE $tabla SET NOMBRE = ?, APELLIDO = ?, TELEFONO = ?, CORREO_ELECTRONICO = ?, PASSWORD = ? WHERE ID_RECEPCIONISTA = ?";
        $stmt = $db->prepare($query);
        
        // Corregir la asignación de parámetros
        $stmt->bind_param("sssssi", $datos['nombre'], $datos['apellido'], $datos['telefono'], $datos['correo_electronico'], $datos['password'], $datos['id_recepcionista']);
        
        $result = $stmt->execute();
        $stmt->close();
        $db->close();
    
        return $result;
    }
    

    // Función para eliminar un paciente
    public static function deleteRecepcionista($tabla, $id_recepcionista) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "DELETE FROM $tabla WHERE ID_RECEPCIONISTA = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("i", $id_recepcionista);
        $result = $stmt->execute();
        $stmt->close();
        $db->close();

        return $result;
    }
}
?>
