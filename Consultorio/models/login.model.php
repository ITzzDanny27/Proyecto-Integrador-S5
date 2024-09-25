<?php
require_once('../config/conexion.php');

class Clase_Usuarios
{

    public function loginParametros($CORREO_ELECTRONICO, $PASSWORD)
{
    $con = new Clase_Conectar();
    $con = $con->Procedimiento_Conectar();

    // Consulta en la tabla recepcionista
    $cadena = "SELECT *, 'recepcionista' as rol FROM `recepcionista` WHERE `CORREO_ELECTRONICO`=?";
    $stmt = $con->prepare($cadena);
    $stmt->bind_param('s', $CORREO_ELECTRONICO);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $recepcionista = $result->fetch_assoc();
        
        // Usar password_verify() para comparar la contraseña ingresada con la encriptada
        if (password_verify($PASSWORD, $recepcionista['PASSWORD'])) {
            $con->close();
            return $recepcionista;  // Login exitoso
        } else {
            // Contraseña incorrecta
            return ['error' => 'La contraseña es incorrecta.'];
        }
    }

    // Si no encuentra resultados en recepcionista, busca en admin
    $cadenaAdmin = "SELECT *, 'admin' as rol FROM `admin` WHERE `CORREO_ELECTRONICO`=?";
    $stmtAdmin = $con->prepare($cadenaAdmin);
    $stmtAdmin->bind_param('s', $CORREO_ELECTRONICO);
    $stmtAdmin->execute();
    $resultAdmin = $stmtAdmin->get_result();

    if ($resultAdmin->num_rows > 0) {
        $admin = $resultAdmin->fetch_assoc();
        
        // Aquí no usamos password_verify, solo comparamos directamente con la contraseña en texto plano
        if ($PASSWORD === $admin['PASSWORD']) {
            $con->close();
            return $admin;  // Login exitoso
        } else {
            // Contraseña incorrecta para admin
            return ['error' => 'La contraseña es incorrecta.'];
        }
    }

    // Correo electrónico no encontrado
    $con->close();
    return ['error' => 'El correo electrónico no está registrado.'];
}



    // // Procedimiento para obtener todos los recepcionistas de la base de datos
    // public function todos()  // select * from recepcionista;
    // {
    //     $con = new Clase_Conectar();
    //     $con = $con->Procedimiento_Conectar();
    //     $cadena = "SELECT recepcionista.`ID_RECEPCIONISTA`, recepcionista.`NOMBRE`, recepcionista.`APELLIDO`, recepcionista.`CORREO_ELECTRONICO`, GROUP_CONCAT(roles.ROL SEPARATOR ' - ') as rol 
    //                FROM `recepcionista` 
    //                INNER JOIN usuarios_roles ON recepcionista.ID_RECEPCIONISTA = usuarios_roles.ID_RECEPCIONISTA 
    //                INNER JOIN roles ON usuarios_roles.ID_ROL = roles.ID_ROL 
    //                GROUP BY recepcionista.`ID_RECEPCIONISTA`, recepcionista.`NOMBRE`, recepcionista.`APELLIDO`, recepcionista.`CORREO_ELECTRONICO`";
    //     $todos = mysqli_query($con, $cadena);
    //     $con->close();
    //     return $todos;
    // }

    // public function listarRecepcionista() {
    //     $conexion = new Clase_Conectar();
    //     $con = $conexion->conectar();
    //     $sql = "SELECT * FROM recepcionista";
        
    //     $datos = mysqli_query($con, $sql);
    //     $con->close();
    //     return $datos;
    // }

    // public function uno($ID_RECEPCIONISTA)  // select * from recepcionista where ID_RECEPCIONISTA=$ID_RECEPCIONISTA;
    // {
    //     $con = new Clase_Conectar();
    //     $con = $con->Procedimiento_Conectar();
    //     $cadena = "SELECT recepcionista.`ID_RECEPCIONISTA`, recepcionista.`NOMBRE`, recepcionista.`APELLIDO`, recepcionista.`CORREO_ELECTRONICO`, recepcionista.`PASSWORD`, roles.ID_ROL 
    //                FROM `recepcionista` 
    //                INNER JOIN usuarios_roles ON recepcionista.ID_RECEPCIONISTA = usuarios_roles.ID_RECEPCIONISTA 
    //                INNER JOIN roles ON usuarios_roles.ID_ROL = roles.ID_ROL 
    //                WHERE recepcionista.`ID_RECEPCIONISTA`=$ID_RECEPCIONISTA";
    //     $todos = mysqli_query($con, $cadena);
    //     $con->close();
    //     return $todos;
    // }

    // public function insertar($NOMBRE, $APELLIDO, $CORREO_ELECTRONICO, $PASSWORD, $ID_ROL)
    // {
    //     $con = new Clase_Conectar();
    //     $con = $con->Procedimiento_Conectar();
    //     $cadena = "INSERT INTO `recepcionista`(`NOMBRE`, `APELLIDO`, `CORREO_ELECTRONICO`, `PASSWORD`) VALUES ('$NOMBRE', '$APELLIDO', '$CORREO_ELECTRONICO', '$PASSWORD')";
    //     if (mysqli_query($con, $cadena)) {
    //         $ID_RECEPCIONISTA = mysqli_insert_id($con);
    //         $usuarios_roles = new Clase_Usuarios_Roles();
    //         $resultado = $usuarios_roles->insertar($ID_ROL, $ID_RECEPCIONISTA);
    //         if ($resultado) {
    //             $con->close();
    //             return true;
    //         } else {
    //             $con->close();
    //             return "Error: No se insertó el rol";
    //         }
    //     } else {
    //         $con->close();
    //         return "Error: No se insertó el recepcionista";
    //     }
    // }

    // public function actualizar($ID_RECEPCIONISTA, $NOMBRE, $APELLIDO, $CORREO_ELECTRONICO, $PASSWORD, $ID_ROL)
    // {
    //     $con = new Clase_Conectar();
    //     $con = $con->Procedimiento_Conectar();
    //     $cadena = "UPDATE `recepcionista` SET `NOMBRE`='$NOMBRE', `APELLIDO`='$APELLIDO', `CORREO_ELECTRONICO`='$CORREO_ELECTRONICO', `PASSWORD`='$PASSWORD' WHERE ID_RECEPCIONISTA=$ID_RECEPCIONISTA";
    //     if (mysqli_query($con, $cadena)) {
    //         $cadena2 = "DELETE FROM `usuarios_roles` WHERE `ID_RECEPCIONISTA`=$ID_RECEPCIONISTA";
    //         if (mysqli_query($con, $cadena2)) {
    //             $cadena3 = "INSERT INTO `usuarios_roles`(`ID_ROL`, `ID_RECEPCIONISTA`) VALUES ($ID_ROL, $ID_RECEPCIONISTA)";
    //             if (mysqli_query($con, $cadena3)) {
    //                 $con->close();
    //                 return true;
    //             } else {
    //                 $con->close();
    //                 return "Error: No se actualizó el rol";
    //             }
    //         } else {
    //             $con->close();
    //             return "Error: No se eliminó el rol antiguo";
    //         }
    //     } else {
    //         $con->close();
    //         return "Error: No se actualizó el recepcionista";
    //     }
    // }

    // public function eliminar($ID_RECEPCIONISTA)
    // {
    //     $usuarios_roles = new Clase_Usuarios_Roles();
    //     $resultado = $usuarios_roles->eliminarxUsuario($ID_RECEPCIONISTA);

    //     if ($resultado) {
    //         $con = new Clase_Conectar();
    //         $con = $con->Procedimiento_Conectar();
    //         $cadena = "DELETE FROM `recepcionista` WHERE ID_RECEPCIONISTA=$ID_RECEPCIONISTA";
    //         $todos = mysqli_query($con, $cadena);
    //         $con->close();
    //         return $todos;
    //     } else {
    //         return "Error: No se eliminó el rol";
    //     }
    // }

}
?>