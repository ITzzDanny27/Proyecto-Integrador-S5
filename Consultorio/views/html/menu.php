<?php


// Obtener el rol del usuario de la sesión (por ejemplo, 'admin' o 'recepcionista')
$rol = $_SESSION['usuario_rol'] ?? ''; // Si no está definida, asigna una cadena vacía
?>

<div class='sidebar pe-4 pb-3'>
    <nav class='navbar bg-darki navbar-light'>
        <a href='../Dashboard/' class='navbar-brand mx-4 mb-3'>
            <h3 class='text-light'><i class='fa fa-hashtag me-2'></i>Consultorio</h3>
        </a>
        <div class='d-flex align-items-center justify-content-start ms-4 mb-4'>
            <div class='position-relative'>
                <img class='rounded-circle' src='../public/img/Consultorio proyecto.jpeg' alt='' style='width: 200px; height: 195px;'>
            </div>
        </div>

        <div class='navbar-nav w-100'>
            <a href='paciente.php' class='nav-item nav-link'><i class='fa fa-tachometer-alt me-2'></i>Listado de Paciente</a>

            <?php if ($rol === 'admin') : ?>
                <!-- Opciones exclusivas para el rol de "admin" -->
                <a href='odontologo.php' class='nav-item nav-link'><i class='fa fa-th me-2'></i>Odontólogo</a>
                <a href='recepcionista.php' class='nav-item nav-link'><i class='fa fa-th me-2'></i>Recepcionista</a>
                <a href='tratamiento.php' class='nav-item nav-link'><i class='fa fa-th me-2'></i>Tratamiento</a>
                <a href='cita.php' class='nav-item nav-link'><i class='fa fa-th me-2'></i>Agendamiento de citas</a>
            <?php endif; ?>

            <?php if ($rol === 'recepcionista') : ?>
                <!-- Opciones exclusivas para el rol de "recepcionista" -->
                <a href='cita.php' class='nav-item nav-link'><i class='fa fa-th me-2'></i>Agendamiento de citas</a>
                <a href='tratamiento.php' class='nav-item nav-link'><i class='fa fa-th me-2'></i>Tratamiento</a>
            <?php endif; ?>

            <!-- Opciones comunes a ambos roles (admin y recepcionista) -->
            <a href='consulta.php' class='nav-item nav-link'><i class='fa fa-th me-2'></i>Historial Médico</a>
            <!-- <a href='HistorialMedico.php' class='nav-item nav-link'><i class='fa fa-th me-2'></i>Historial Médico</a> -->
        </div>
    </nav>
</div>
