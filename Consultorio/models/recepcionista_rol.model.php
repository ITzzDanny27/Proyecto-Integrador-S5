<?php
// php es un lenguaje de programacion interpretado, por lo que no se compila, se ejecuta en el servidor
require_once('../config/conexion.php');

class Clase_Usuarios_Roles
{
    // Procedimiento para obtener todos los registros de la tabla `recepcionista_rol`
    public function todos()  ///select * from recepcionista_rol;
    {
        // Instanciar la clase conectar
        $con = new Clase_Conectar();
        // Usar el procedimiento para conectar
        $con = $con->Procedimiento_Conectar();
        // Ejecutar la consulta
        $cadena = "SELECT * FROM `recepcionista_rol`";
        // Guardar la consulta en una variable
        $todos = mysqli_query($con, $cadena);
        // Cerrar la conexion
        $con->close();
        // Retornar la consulta
        return $todos;
    }

    // Procedimiento para obtener un registro de la tabla `recepcionista_rol` por ID
    public function uno($ID_RECEPCIONISTA_ROL) //select * from recepcionista_rol where ID_RECEPCIONISTA_ROL=$ID_RECEPCIONISTA_ROL;
    {
        $con = new Clase_Conectar();
        $con = $con->Procedimiento_Conectar();
        $cadena = "SELECT * FROM `recepcionista_rol` WHERE ID_RECEPCIONISTA_ROL=$ID_RECEPCIONISTA_ROL";
        $todos = mysqli_query($con, $cadena);
        $con->close();
        return $todos;
    }

    // Procedimiento para insertar un registro en la tabla `recepcionista_rol`
    public function insertar($ID_ROL, $ID_RECEPCIONISTA)
    {
        $con = new Clase_Conectar();
        $con = $con->Procedimiento_Conectar();
        $cadena = "INSERT INTO `recepcionista_rol`(ID_ROL, ID_RECEPCIONISTA) VALUES ('$ID_ROL', '$ID_RECEPCIONISTA')";
        $todos = mysqli_query($con, $cadena);
        $con->close();
        return $todos;
    }

    // Procedimiento para actualizar un registro en la tabla `recepcionista_rol`
    public function actualizar($ID_ROL, $ID_RECEPCIONISTA_ROL, $ID_RECEPCIONISTA)
    {
        $con = new Clase_Conectar();
        $con = $con->Procedimiento_Conectar();
        $cadena = "UPDATE `recepcionista_rol` SET ID_RECEPCIONISTA=$ID_RECEPCIONISTA, ID_ROL=$ID_ROL WHERE ID_RECEPCIONISTA_ROL=$ID_RECEPCIONISTA_ROL";
        $todos = mysqli_query($con, $cadena);
        $con->close();
        return $todos;
    }

    // Procedimiento para eliminar un registro de la tabla `recepcionista_rol` por ID
    public function eliminar($ID_RECEPCIONISTA_ROL)
    {
        $con = new Clase_Conectar();
        $con = $con->Procedimiento_Conectar();
        $cadena = "DELETE FROM `recepcionista_rol` WHERE ID_RECEPCIONISTA_ROL=$ID_RECEPCIONISTA_ROL";
        $todos = mysqli_query($con, $cadena);
        $con->close();
        return $todos;
    }

    // Procedimiento para eliminar registros de la tabla `recepcionista_rol` por ID de recepcionista
    public function eliminarxUsuario($ID_RECEPCIONISTA)
    {
        $con = new Clase_Conectar();
        $con = $con->Procedimiento_Conectar();
        $cadena = "DELETE FROM `recepcionista_rol` WHERE `ID_RECEPCIONISTA`= $ID_RECEPCIONISTA";
        $todos = mysqli_query($con, $cadena);
        $con->close();
        return $todos;
    }
}
?>