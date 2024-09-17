<?php
require_once "../config/conexion.php";

class HistorialMedico
{
    private $conexion;

    public function __construct()
    {
        $conectar = new Clase_Conectar();
        $this->conexion = $conectar->conectar();
    }

    public function listar()
    {
        $sql = "SELECT id_historial, ID_CONSULTA, fecha, observaciones FROM historial_medico";
        $query = $this->conexion->query($sql);
        if (!$query) {
            throw new Exception("Error al listar historiales: " . $this->conexion->error);
        }
        return $query->fetch_all(MYSQLI_ASSOC);
    }


    public function agregar($data)
    {
        $sql = "INSERT INTO historial_medico (id_paciente, observaciones, fecha, ID_CONSULTA) VALUES (?, ?, ?, ?)";
        $query = $this->conexion->prepare($sql);
        if (!$query) {
            throw new Exception("Error al preparar la consulta de inserción: " . $this->conexion->error);
        }
        $query->bind_param('isss', $data['id_paciente'], $data['observaciones'], $data['fecha'], $data['ID_CONSULTA']);
        if (!$query->execute()) {
            throw new Exception("Error al ejecutar la consulta de inserción: " . $query->error);
        }
        return true;
    }

    public function actualizar($data)
    {
        $sql = "UPDATE historial_medico SET observaciones = ?, fecha = ?, ID_CONSULTA = ? WHERE id_historial = ?";
        $query = $this->conexion->prepare($sql);
        if (!$query) {
            throw new Exception("Error al preparar la consulta de actualización: " . $this->conexion->error);
        }
        $query->bind_param('sssi', $data['observaciones'], $data['fecha'], $data['ID_CONSULTA'], $data['id_historial']);
        if (!$query->execute()) {
            throw new Exception("Error al ejecutar la consulta de actualización: " . $query->error);
        }
        return true;
    }

    public function eliminar($id)
    {
        $sql = "DELETE FROM historial_medico WHERE id_historial = ?";
        $query = $this->conexion->prepare($sql);
        if (!$query) {
            throw new Exception("Error al preparar la consulta de eliminación: " . $this->conexion->error);
        }
        $query->bind_param('i', $id);
        if (!$query->execute()) {
            throw new Exception("Error al ejecutar la consulta de eliminación: " . $query->error);
        }
        return true;
    }

    public function obtenerPacientes()
    {
        $sql = "SELECT id_paciente, primer_nombre, apellido_paterno FROM paciente";
        $query = $this->conexion->query($sql);
        if (!$query) {
            throw new Exception("Error al obtener pacientes: " . $this->conexion->error);
        }
        return $query->fetch_all(MYSQLI_ASSOC);
    }
}
