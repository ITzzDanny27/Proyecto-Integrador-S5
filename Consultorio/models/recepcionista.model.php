<?php
require_once "../config/conexion.php"; // Asegúrate de que este archivo esté correctamente configurado

class RecepcionistaModel {

    // Función para validar datos
    private static function validarDatos($datos) {
        $errores = [];

        // Validar nombre
        if (empty($datos['nombre'])) {
            $errores[] = 'El nombre es obligatorio.';
        }

        // Validar apellido
        if (empty($datos['apellido'])) {
            $errores[] = 'El apellido es obligatorio.';
        }

        // Validar teléfono (opcional, según el formato esperado)
        if (empty($datos['telefono']) || !preg_match('/^\d{10}$/', $datos['telefono'])) {
            $errores[] = 'El teléfono debe tener 10 dígitos.';
        }

        // Validar correo electrónico
        if (empty($datos['correo_electronico']) || !filter_var($datos['correo_electronico'])) {
            $errores[] = 'El correo electrónico no es válido.';
        }

        // Validar contraseña
        if (empty($datos['password']) || !preg_match('/^(?=.*[A-Z])(?=.*[\W_])[A-Za-z\d\W_]{8,}$/', $datos['password'])) {
            $errores[] = 'La contraseña debe tener al menos 8 caracteres, una letra mayúscula y un carácter especial.';
        }

        return $errores;
    }

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
        $errores = self::validarDatos($datos);
    
        if (!empty($errores)) {
            return ['success' => false, 'errores' => $errores];
        }
    
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();
    
        // Encriptar la contraseña antes de guardarla
        $passwordEncriptada = password_hash($datos['password'], PASSWORD_DEFAULT);
    
        $query = "INSERT INTO $tabla (NOMBRE, APELLIDO, TELEFONO, CORREO_ELECTRONICO, PASSWORD) VALUES (?, ?, ?, ?, ?)";
        $stmt = $db->prepare($query);
        $stmt->bind_param("sssss", $datos['nombre'], $datos['apellido'], $datos['telefono'], $datos['correo_electronico'], $passwordEncriptada);
        $result = $stmt->execute();
        $stmt->close();
        $db->close();
    
        return ['success' => $result, 'errores' => []];
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
        $errores = self::validarDatos($datos);
    
        if (!empty($errores)) {
            return ['success' => false, 'errores' => $errores];
        }
    
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();
    
        // Encriptar la contraseña antes de actualizarla
        $passwordEncriptada = password_hash($datos['password'], PASSWORD_DEFAULT);
    
        $query = "UPDATE $tabla SET NOMBRE = ?, APELLIDO = ?, TELEFONO = ?, CORREO_ELECTRONICO = ?, PASSWORD = ? WHERE ID_RECEPCIONISTA = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("sssssi", $datos['nombre'], $datos['apellido'], $datos['telefono'], $datos['correo_electronico'], $passwordEncriptada, $datos['id_recepcionista']);
        $result = $stmt->execute();
        $stmt->close();
        $db->close();
    
        return ['success' => $result, 'errores' => []];
    }
    
    public static function verificarLogin($tabla, $correo, $password) {
        $conexion = new Clase_Conectar();
        $db = $conexion->conectar();
    
        $query = "SELECT * FROM $tabla WHERE CORREO_ELECTRONICO = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param("s", $correo);
        $stmt->execute();
        $result = $stmt->get_result();
    
        if ($result->num_rows > 0) {
            $recepcionista = $result->fetch_assoc();
            
            // Verificar si la contraseña ingresada coincide con la contraseña encriptada almacenada
            if (password_verify($password, $recepcionista['PASSWORD'])) {
                // Contraseña correcta, iniciar sesión
                return ['success' => true, 'datos' => $recepcionista];
            } else {
                // Contraseña incorrecta
                return ['success' => false, 'errores' => ['La contraseña es incorrecta.']];
            }
        } else {
            // Correo no encontrado
            return ['success' => false, 'errores' => ['El correo electrónico no está registrado.']];
        }
    
        $stmt->close();
        $db->close();
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