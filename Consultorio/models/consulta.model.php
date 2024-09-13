<?php
require_once "../config/conexion.php"; // Asegúrate de que este archivo esté correctamente configurado

class ConsultaModel
{

    // Función para obtener todos los pacientes
    public static function getConsultas() {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();
    
        $query = "SELECT c.ID_CONSULTA, c.DESCRIPCION, c.ID_CITA, ci.FECHA, ci.HORA, 
                         ci.ESTADO AS CITA_ESTADO, 
                         p.PRIMER_NOMBRE AS PACIENTE_NOMBRE, p.APELLIDO_PATERNO AS PACIENTE_APELLIDO, 
                         t.DESCRIPCION AS TRATAMIENTO_DESCRIPCION
                  FROM consulta c
                  JOIN cita ci ON c.ID_CITA = ci.ID_CITA
                  JOIN paciente p ON ci.ID_PACIENTE = p.ID_PACIENTE
                  JOIN tratamiento t ON c.ID_TRATAMIENTO = t.ID_TRATAMIENTO";
        $stmt = $db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();
    
        $consultas = [];
        while ($row = $result->fetch_assoc()) {
            $consultas[] = $row;
        }
    
        $stmt->close();
        $db->close();
    
        return $consultas;
    }
    

    public static function getCitas($tabla)
    {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        // Consulta SQL con INNER JOIN para obtener el nombre del paciente
        $query = "
        SELECT 
            c.ID_CITA, 
            CONCAT(p.primer_nombre, ' ', p.apellido_paterno) AS NOMBRE_PACIENTE,
            c.FECHA, 
            c.HORA, 
            c.ESTADO
        FROM 
            $tabla c
        INNER JOIN 
            paciente p ON c.ID_PACIENTE = p.ID_PACIENTE
    ";
        $stmt = $db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();

        $citas = $result->fetch_all(MYSQLI_ASSOC);

        $stmt->close();
        $db->close();

        return $citas;
    }

    // Método para obtener todos los tratamientos
    public static function getTratamientos($tabla)
    {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "SELECT ID_TRATAMIENTO, DESCRIPCION FROM $tabla";
        $stmt = $db->prepare($query);
        $stmt->execute();
        $result = $stmt->get_result();
        $tratamientos = $result->fetch_all(MYSQLI_ASSOC);

        $stmt->close();
        $db->close();

        return $tratamientos;
    }

    // Función para insertar un nuevo paciente
    public static function addConsulta($tabla, $datos)
    {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "INSERT INTO $tabla (ID_CITA, ID_TRATAMIENTO, DESCRIPCION) VALUES (?, ?, ?)";
        $stmt = $db->prepare($query);
        $stmt->bind_param("iis", $datos['ID_CITA'], $datos['ID_TRATAMIENTO'], $datos['DESCRIPCION']);
        $result = $stmt->execute();
        $stmt->close();
        $db->close();

        return $result;
    }



    // Nueva función para obtener un paciente por ID
    public static function getConsultaById($tabla, $id)
    {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "SELECT * FROM $tabla WHERE id_consulta = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();

        $consulta = $result->fetch_assoc();

        $stmt->close();
        $db->close();

        return $consulta;
    }

    // Función para actualizar un paciente
    public static function updateConsulta($tabla, $datos)
    {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "UPDATE $tabla SET ID_CITA = ?, ID_TRATAMIENTO = ?, DESCRIPCION = ? WHERE id_consulta = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("iisi", $datos['ID_CITA'], $datos['ID_TRATAMIENTO'], $datos['DESCRIPCION'], $datos['id_consulta']);
        $result = $stmt->execute();
        $stmt->close();
        $db->close();

        return $result;
    }


    // Función para eliminar un paciente
    public static function deleteConsulta($tabla, $id_consulta)
    {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();

        $query = "DELETE FROM $tabla WHERE id_consulta = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("i", $id_consulta);
        $result = $stmt->execute();
        $stmt->close();
        $db->close();

        return $result;
    }
}
