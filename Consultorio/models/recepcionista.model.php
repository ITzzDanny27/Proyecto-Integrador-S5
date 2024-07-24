<?php
require_once('../config/conexion.php');
require_once('recepcionista_rol.model.php');

class Clase_Usuarios
{
    // Procedimiento para obtener todos los recepcionistas de la base de datos
    public function todos()  // select * from recepcionista;
    {
        $con = new Clase_Conectar();
        $con = $con->Procedimiento_Conectar();
        $cadena = "SELECT recepcionista.`ID_RECEPCIONISTA`, recepcionista.`NOMBRE`, recepcionista.`APELLIDO`, recepcionista.`CORREO_ELECTRONICO`, GROUP_CONCAT(roles.ROL SEPARATOR ' - ') as rol 
                   FROM `recepcionista` 
                   INNER JOIN usuarios_roles ON recepcionista.ID_RECEPCIONISTA = usuarios_roles.ID_RECEPCIONISTA 
                   INNER JOIN roles ON usuarios_roles.ID_ROL = roles.ID_ROL 
                   GROUP BY recepcionista.`ID_RECEPCIONISTA`, recepcionista.`NOMBRE`, recepcionista.`APELLIDO`, recepcionista.`CORREO_ELECTRONICO`";
        $todos = mysqli_query($con, $cadena);
        $con->close();
        return $todos;
    }

    public function uno($ID_RECEPCIONISTA)  // select * from recepcionista where ID_RECEPCIONISTA=$ID_RECEPCIONISTA;
    {
        $con = new Clase_Conectar();
        $con = $con->Procedimiento_Conectar();
        $cadena = "SELECT recepcionista.`ID_RECEPCIONISTA`, recepcionista.`NOMBRE`, recepcionista.`APELLIDO`, recepcionista.`CORREO_ELECTRONICO`, recepcionista.`PASSWORD`, roles.ID_ROL 
                   FROM `recepcionista` 
                   INNER JOIN usuarios_roles ON recepcionista.ID_RECEPCIONISTA = usuarios_roles.ID_RECEPCIONISTA 
                   INNER JOIN roles ON usuarios_roles.ID_ROL = roles.ID_ROL 
                   WHERE recepcionista.`ID_RECEPCIONISTA`=$ID_RECEPCIONISTA";
        $todos = mysqli_query($con, $cadena);
        $con->close();
        return $todos;
    }

    public function insertar($NOMBRE, $APELLIDO, $CORREO_ELECTRONICO, $PASSWORD, $ID_ROL)
    {
        $con = new Clase_Conectar();
        $con = $con->Procedimiento_Conectar();
        $cadena = "INSERT INTO `recepcionista`(`NOMBRE`, `APELLIDO`, `CORREO_ELECTRONICO`, `PASSWORD`) VALUES ('$NOMBRE', '$APELLIDO', '$CORREO_ELECTRONICO', '$PASSWORD')";
        if (mysqli_query($con, $cadena)) {
            $ID_RECEPCIONISTA = mysqli_insert_id($con);
            $usuarios_roles = new Clase_Usuarios_Roles();
            $resultado = $usuarios_roles->insertar($ID_ROL, $ID_RECEPCIONISTA);
            if ($resultado) {
                $con->close();
                return true;
            } else {
                $con->close();
                return "Error: No se insertó el rol";
            }
        } else {
            $con->close();
            return "Error: No se insertó el recepcionista";
        }
    }

    public function actualizar($ID_RECEPCIONISTA, $NOMBRE, $APELLIDO, $CORREO_ELECTRONICO, $PASSWORD, $ID_ROL)
    {
        $con = new Clase_Conectar();
        $con = $con->Procedimiento_Conectar();
        $cadena = "UPDATE `recepcionista` SET `NOMBRE`='$NOMBRE', `APELLIDO`='$APELLIDO', `CORREO_ELECTRONICO`='$CORREO_ELECTRONICO', `PASSWORD`='$PASSWORD' WHERE ID_RECEPCIONISTA=$ID_RECEPCIONISTA";
        if (mysqli_query($con, $cadena)) {
            $cadena2 = "DELETE FROM `usuarios_roles` WHERE `ID_RECEPCIONISTA`=$ID_RECEPCIONISTA";
            if (mysqli_query($con, $cadena2)) {
                $cadena3 = "INSERT INTO `usuarios_roles`(`ID_ROL`, `ID_RECEPCIONISTA`) VALUES ($ID_ROL, $ID_RECEPCIONISTA)";
                if (mysqli_query($con, $cadena3)) {
                    $con->close();
                    return true;
                } else {
                    $con->close();
                    return "Error: No se actualizó el rol";
                }
            } else {
                $con->close();
                return "Error: No se eliminó el rol antiguo";
            }
        } else {
            $con->close();
            return "Error: No se actualizó el recepcionista";
        }
    }

    public function eliminar($ID_RECEPCIONISTA)
    {
        $usuarios_roles = new Clase_Usuarios_Roles();
        $resultado = $usuarios_roles->eliminarxUsuario($ID_RECEPCIONISTA);

        if ($resultado) {
            $con = new Clase_Conectar();
            $con = $con->Procedimiento_Conectar();
            $cadena = "DELETE FROM `recepcionista` WHERE ID_RECEPCIONISTA=$ID_RECEPCIONISTA";
            $todos = mysqli_query($con, $cadena);
            $con->close();
            return $todos;
        } else {
            return "Error: No se eliminó el rol";
        }
    }

    public function login($CORREO_ELECTRONICO, $PASSWORD)
    {
        $con = new Clase_Conectar();
        $con = $con->Procedimiento_Conectar();
        $cadena = "SELECT * FROM `recepcionista` WHERE `CORREO_ELECTRONICO`='$CORREO_ELECTRONICO' AND `PASSWORD`='$PASSWORD'";
        $todos = mysqli_query($con, $cadena);
        $con->close();
        return $todos;
    }

    public function loginCorreo($CORREO_ELECTRONICO)
    {
        $con = new Clase_Conectar();
        $con = $con->Procedimiento_Conectar();
        $cadena = "SELECT * FROM `recepcionista` WHERE `CORREO_ELECTRONICO`='$CORREO_ELECTRONICO'";
        $todos = mysqli_query($con, $cadena);
        $con->close();
        return $todos;
    }

    public function loginParametros($CORREO_ELECTRONICO, $PASSWORD) // mayor seguridad
    {
        $con = new Clase_Conectar();
        $con = $con->Procedimiento_Conectar();
        $cadena = "SELECT * FROM `recepcionista` WHERE `CORREO_ELECTRONICO`=? AND `PASSWORD`=?";
        $stmt = $con->prepare($cadena);
        $stmt->bind_param('ss', $CORREO_ELECTRONICO, $PASSWORD);
        if ($stmt->execute()) {
            $result = $stmt->get_result();
            return $result;
        }
    }
}
?>
