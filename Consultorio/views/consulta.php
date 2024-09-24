<!DOCTYPE html>
<html lang='es'>

<head>
    <?php require_once('./html/head.php') ?>
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
        <?php require_once('./html/menu.php') ?>
        <!-- Sidebar End -->

        <!-- Content Start -->
        <div class='content'>
            <!-- Navbar Start -->
            <?php require_once('./html/header.php') ?>
            <!-- Navbar End -->

            <!-- Nuevo Paciente Modal -->
            <div class="modal fade" id="modalConsulta" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">Nueva Consulta</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form id="frm_consulta">
                            <input type="hidden" id="id_consulta" name="id_consulta"> <!-- Campo oculto para el ID -->
                            <div class="modal-body">
                                <div class="form-group">
                                    <label for="ID_CITA">Seleccione cita</label>
                                    <select name="ID_CITA" id="ID_CITA" class="form-control">
                                        <!-- Opciones se llenarán con JavaScript -->
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="ID_TRATAMIENTO">Seleccione tratamiento</label>
                                    <select name="ID_TRATAMIENTO" id="ID_TRATAMIENTO" class="form-control">
                                        <!-- Opciones se llenarán con JavaScript -->
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="DESCRIPCION">Descripción</label>
                                    <input type="text" name="DESCRIPCION" id="DESCRIPCION" placeholder="Descripción" class="form-control" required>
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
            <!-- Fin Nuevo Paciente Modal -->

            <!-- Lista de Pacientes -->
            <div class='container-fluid pt-4 px-3'>
                <div class="container d-flex flex-row justify-content-start">
                    <div>
                        <button type="button" class="btn btn-primary mb-4 mx-2" data-bs-toggle="modal" data-bs-target="#modalConsulta">
                            <i class="bi bi-person-check"></i> Agregar Historial
                        </button>
                    </div>
                    <div>
                    <input oninput="buscarConsulta(this.value)" style="width: 20rem;" type="text" id="buscarConsulta" class="form-control mb-4 mx-3" placeholder="Buscar Historial">
                    </div>
                </div>

                <h6 style="text-align: center; color: white;" class='mb-4'>Lista de Historial Médico</h6>
                <div class='d-flex align-items-center justify-content-between mb-4'>
                    <table class="table table-bordered table-striped table-hover table-responsive">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <!-- <th>ID Consulta</th> -->
                                <th>Nombres</th>
                                <th>Fecha</th>
                                <th>Hora</th>
                                <th>Estado</th>
                                <th>Tratamiento</th>
                                <th>Odontólogo</th>
                                <th>Descripción</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="cuerpoConsultas">
                            <!-- Aquí van los datos de los pacientes -->
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- Fin Lista de Pacientes -->

            <!-- Footer Start -->
            <?php require_once('./html/footer.php') ?>
            <!-- Footer End -->
        </div>
        <!-- Content End -->

        <!-- Back to Top -->
        <a href='#' class='btn btn-lg btn-primary btn-lg-square back-to-top'><i class='bi bi-arrow-up'></i></a>
    </div>

    <!-- JavaScript Libraries -->
    <?php require_once('../views/html/scripts.php') ?>
    <script src="../views/consulta.js" defer></script>

</body>

</html>