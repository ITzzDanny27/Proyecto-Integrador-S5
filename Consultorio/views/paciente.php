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
            <div class="modal fade" id="modalPaciente" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">Nuevo Paciente</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form id="frm_paciente">
                            <input type="hidden" id="id_paciente" name="id_paciente"> <!-- Campo oculto para el ID -->
                            <div class="modal-body">
                                <div class="form-group">
                                    <label for="PRIMER_NOMBRE">Primer Nombre</label>
                                    <input type="text" name="primer_nombre" id="primer_nombre" placeholder="Ingrese el primer nombre del paciente" class="form-control" required>
                                </div>

                                <div class="form-group">
                                    <label for="SEGUNDO_NOMBRE">Segundo Nombre</label>
                                    <input type="text" name="segundo_nombre" id="segundo_nombre" placeholder="Ingrese el segundo nombre del paciente" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label for="APELLIDO_PATERNO">Apellido Paterno</label>
                                    <input type="text" name="apellido_paterno" id="apellido_paterno" placeholder="Ingrese el apellido paterno del paciente" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="APELLIDO_MATERNO">Apellido Materno</label>
                                    <input type="text" name="apellido_materno" id="apellido_materno" placeholder="Ingrese el apellido materno del paciente" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label for="FECHA_NACIMIENTO">Fecha de Nacimiento</label>
                                    <input type="date" name="fecha_nacimiento" id="fecha_nacimiento" placeholder="Ingrese la fecha de nacimiento del paciente" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="TELEFONO">Teléfono</label>
                                    <input type="text" name="telefono" id="telefono" placeholder="Ingrese el teléfono del paciente" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="CORREO_ELECTRONICO">Correo Electrónico</label>
                                    <input type="email" name="correo_electronico" id="correo_electronico" placeholder="Ingrese el correo electrónico del paciente" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label for="DIRECCION">Dirección</label>
                                    <input type="text" name="direccion" id="direccion" placeholder="Ingrese la dirección del paciente" class="form-control">
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
                        <button type="button" class="btn btn-primary mb-4 mx-2" data-bs-toggle="modal" data-bs-target="#modalPaciente">
                            <i class="bi bi-person-check"></i> Nuevo Paciente
                        </button>
                    </div>
                    <div>
                        <input onkeydown="if (event.keyCode === 13) buscarPaciente(this.value)" style="width: 25rem;" type="text" id="buscarPaciente" class="form-control mb-4 mx-3" placeholder="Buscar Paciente">
                    </div>
                </div>

                <h6 style="text-align: center;" class='mb-4'>Lista de Pacientes</h6>
                <div class='d-flex align-items-center justify-content-between mb-4'>
                    <table class="table table-bordered table-striped table-hover table-responsive">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>1er Nombre</th>
                                <th>2do Nombre</th>
                                <th>Apellido Paterno</th>
                                <th>Apellido Materno</th>
                                <th>Nacimiento</th>
                                <th>Teléfono</th>
                                <th>Correo</th>
                                <th>Dirección</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="cuerpoPacientes">
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
    <script src="../views/paciente.js" defer></script>

</body>

</html>
