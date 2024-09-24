<!DOCTYPE html>
<html lang='es'>

<head>
    <?php require_once('./html/head.php'); ?>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
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

            <!-- Nuevo Historial Médico Modal -->
            <div class="modal fade" id="modalHistorial" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">Nuevo Historial Médico</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <!-- Formulario de historial médico -->
                            <form id="frm_historial">
                                <input type="hidden" id="id_historial" name="id_historial">
                                <div class="mb-3">
                                    <label for="ID_CONSULTA" class="form-label">ID Consulta</label>
                                    <input type="number" class="form-control" id="ID_CONSULTA" name="ID_CONSULTA" required>
                                </div>
                                <div class="mb-3">
                                    <label for="FECHA" class="form-label">Fecha</label>
                                    <input type="date" class="form-control" id="FECHA" name="FECHA" required>
                                </div>
                                <div class="mb-3">
                                    <label for="OBSERVACIONES" class="form-label">Observaciones</label>
                                    <textarea class="form-control" id="OBSERVACIONES" name="OBSERVACIONES" required></textarea>
                                </div>
                                <div class="mb-3">
                                    <label for="id_paciente" class="form-label">Paciente</label>
                                    <select id="id_paciente" name="id_paciente" class="form-control" required></select>
                                </div>
                                <button type="submit" class="btn btn-primary">Guardar</button>
                            </form>

                        </div>
                    </div>
                </div>
            </div>
            <!-- Fin Modal Nuevo Historial Médico -->

            <!-- Botón para abrir el Modal -->
<div class='d-flex align-items-center justify-content-between mb-4'>
    <button id="nuevoHistorialBtn" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalHistorial">
        <i class="bi bi-file-plus"></i> Nuevo Historial
    </button>
</div>

<!-- Modal para Nuevo Historial Médico -->
<div class="modal fade" id="modalHistorial" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Nuevo Historial Médico</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="frm_historial">
                    <input type="hidden" id="id_historial" name="id_historial">
                    <div class="mb-3">
                        <label for="ID_CONSULTA" class="form-label">ID Consulta</label>
                        <input type="number" class="form-control" id="ID_CONSULTA" name="ID_CONSULTA" required>
                    </div>
                    <div class="mb-3">
                        <label for="FECHA" class="form-label">Fecha</label>
                        <input type="date" class="form-control" id="FECHA" name="FECHA" required>
                    </div>
                    <div class="mb-3">
                        <label for="OBSERVACIONES" class="form-label">Observaciones</label>
                        <textarea class="form-control" id="OBSERVACIONES" name="OBSERVACIONES" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="id_paciente" class="form-label">Paciente</label>
                        <select id="id_paciente" name="id_paciente" class="form-control" required></select>
                    </div>
                    <button type="submit" class="btn btn-primary">Guardar</button>
                </form>
            </div>
        </div>
    </div>
</div>


            <!-- Tabla de Lista de Historiales -->
            <h6 style="text-align: center; color: white;" class='mb-4'>Lista de Historiales Médicos</h6>
            <div class='d-flex align-items-center justify-content-between mb-4'>
                <table class="table table-bordered table-striped table-hover table-responsive">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>ID Consulta</th>
                            <th>Fecha</th>
                            <th>Observaciones</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody id="cuerpoHistoriales">
                        <!-- Aquí se llenan los datos de los historiales médicos -->
                    </tbody>
                </table>
            </div>
            <!-- Fin Lista de Historiales -->

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
    <!-- Cargar el script con defer para asegurarse de que el DOM esté listo -->
    <script src="../views/HistorialMedico.js" defer></script>
</body>

</html>