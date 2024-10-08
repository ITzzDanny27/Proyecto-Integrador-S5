<!DOCTYPE html>
<html lang='es'>

<head>
    <?php require_once('./html/head.php'); ?>
    <link href='../public/lib/calendar/lib/main.css' rel='stylesheet' />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <style>
        .custom-flatpickr {
            display: flex;
            align-items: center;
        }

        .custom-flatpickr input {
            margin-right: 5px;
            flex: 1;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>
    <div class='container-xxl position-relative bg-light d-flex p-0'>
        <!-- Spinner Start -->
        <div id='spinner' class='show bg-light position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center'>
            <div class='spinner-border text-primary' style='width: 3rem; height: 3rem;' role='status'>
                <span class='sr-only'>Cargando...</span>
            </div>
        </div>
        <!-- Spinner End -->

        <!-- Sidebar Start -->
        <?php require_once('./html/menu.php'); ?>
        <!-- Sidebar End -->

        <!-- Content Start -->
        <div class='content'>
            <!-- Navbar Start -->
            <?php require_once('./html/header.php'); ?>
            <!-- Navbar End -->

            <!-- Mostrar el mensaje si está disponible -->
            <?php
            if (isset($_SESSION['mensaje'])) {
                echo '<div class="alert alert-info" role="alert">' . $_SESSION['mensaje'] . '</div>';
                unset($_SESSION['mensaje']); // Eliminar el mensaje después de mostrarlo
            }
            ?>

            <!-- Nueva Cita Modal -->
            <div class="modal fade" id="modalCita" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">Nueva Cita</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form id="frm_cita">
                            <input type="hidden" id="id_cita" name="id_cita"> <!-- Campo oculto para el ID -->
                            <div class="modal-body">
                                <div class="form-group">
                                    <label for="FECHA">Fecha de Cita</label>
                                    <input type="date" name="fecha" id="fecha" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="HORA">Hora de Cita</label>
                                    <input type="time" name="hora" id="hora" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="PACIENTE_ID">Paciente</label>
                                    <select name="id_paciente" id="id_paciente" class="form-control" required>
                                        <!-- Opciones de pacientes llenadas desde JavaScript -->
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="ODONTOLOGO_ID">Odontólogo</label>
                                    <select name="id_odontologo" id="id_odontologo" class="form-control" required>
                                        <!-- Opciones de odontólogos llenadas desde JavaScript -->
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="ESTADO">Estado</label>
                                    <select name="estado" id="estado" class="form-control">
                                        <option value="Pendiente">Pendiente</option>
                                        <!-- <option value="Finalizado">Finalizado</option> -->
                                    </select>
                                </div>

                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-primary">Guardar</button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <!-- Fin Nueva Cita Modal -->

            <!-- Lista de Citas -->
            <div class='container-fluid pt-4 px-3'>
                <div class="container d-flex flex-row justify-content-start">
                    <div>
                        <button type="button" class="btn btn-primary mb-4 mx-2" id="nuevaCitaBtn" data-bs-toggle="modal" data-bs-target="#modalCita">
                            <i class="bi bi-calendar-plus"></i> Nueva Cita
                        </button>
                    </div>
                    <div>
                        <input onkeydown="if (event.keyCode === 13) buscarCita(this.value)" style="width: 25rem;" type="text" id="buscarCita" class="form-control mb-4 mx-3" placeholder="Buscar Cita">
                    </div>
                </div>

                <h6 style="text-align: center; color: white;" class='mb-4'>Lista de Citas</h6>
                <div class='d-flex align-items-center justify-content-between mb-4'>
                    <table class="table table-bordered table-striped table-hover table-responsive">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Fecha</th>
                                <th>Hora</th>
                                <th>Paciente</th>
                                <th>Odontólogo</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="cuerpoCitasPendientes">
                            <!-- Aquí van los datos de las citas -->
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- Fin Lista de Citas -->

            <!-- Segunda Tabla de Citas Finalizadas -->
            <div class='container-fluid pt-4 px-3'>
                <h6 style="text-align: center; color: white;" class='mb-4'>Lista de Citas Finalizadas</h6>
                <div class='d-flex align-items-center justify-content-between mb-4'>
                    <table class="table table-bordered table-striped table-hover table-responsive">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Fecha</th>
                                <th>Hora</th>
                                <th>Paciente</th>
                                <th>Odontólogo</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="cuerpoCitasFinalizadas">
                            <!-- Aquí van los datos de las citas finalizadas -->
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- Fin Segunda Tabla de Citas Finalizadas -->

            <!-- Footer Start -->
            <?php require_once('./html/footer.php'); ?>
            <!-- Footer End -->
        </div>
        <!-- Content End -->

        <!-- Back to Top -->
        <a href='#' class='btn btn-lg btn-primary btn-lg-square back-to-top'><i class='bi bi-arrow-up'></i></a>
    </div>

    <!-- JavaScript Libraries -->
    <?php require_once('../views/html/scripts.php'); ?>
    <script src="../views/cita.js" defer></script>

</body>

</html>