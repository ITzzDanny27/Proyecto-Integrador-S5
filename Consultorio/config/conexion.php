<?php

class Clase_Conectar {
    private $conexion;
    protected $db;
    private $server = "localhost";
    private $usu = "root"; 
    private $clave = ""; 
    private $base = "consultorio";

    // public function conectar() {
    //     $this->conexion = new mysqli($this->server, $this->usuario, $this->pass, $this->base);
        
    //     if ($this->conexion->connect_error) {
    //         die("Error al conectar con MySQL: " . $this->conexion->connect_error);
    //     }

    //     if (!$this->conexion->set_charset("utf8")) {
    //         die("Error al establecer el charset UTF-8: " . $this->conexion->error);
    //     }
    //     return $this->conexion;
    // }

    public function Procedimiento_Conectar()
    {
        $this->conexion = mysqli_connect($this->server, $this->usu, $this->clave, $this->base);
        mysqli_query($this->conexion, "SET NAMES 'utf8'");
        if ($this->conexion == 0) die("error al conectarse con mysql ");
        $this->db = mysqli_select_db($this->conexion, $this->base);
        if ($this->db == 0) die("error conexión con la base de datos ");
        return $this->conexion;
    }

}
?>
