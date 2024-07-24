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


            <!-- Nuevo Estudiante Modal -->
            <div class="modal fade" id="modalEstudiante" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">Nuevo Pacientes</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form id="frm_estudiantes">
                            <div class="modal-body">
                                <!-- <input type="hidden" name="EstudiantesId" id="EstudiantesId"> -->

                                <div class="form-group">
                                    <label for="Nombre">Identificacion</label>
                                    <input type="text" name="EstudiantesId" id="EstudiantesId" placeholder="Ingrese el nombre del estudiante" class="form-control" required>
                                </div>

                                <div class="form-group">
                                    <label for="Nombre">Nombre</label>
                                    <input type="text" name="Nombre" id="Nombre" placeholder="Ingrese el nombre del estudiante" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="Apellido">Apellido</label>
                                    <input type="text" name="Apellido" id="Apellido" placeholder="Ingrese el apellido del estudiante" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="FechaNacimiento">Fecha Nacimiento</label>
                                    <input type="date" name="FechaNacimiento" id="FechaNacimiento" placeholder="Ingrese la fecha de nacimiento del estudiante" class="form-control" required>
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
            <!-- Fin Nuevo Estudiante Modal -->

            <!-- Editar Estudiante Modal -->
            <div class="modal fade" id="modalEditarEstudiante" tabindex="-1" aria-labelledby="editarEstudianteLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editarEstudianteLabel">Editar Estudiante</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form id="frm_editar_estudiantes">
                            <div class="modal-body">
                                <input type="hidden" name="EditarEstudianteId" id="EditarEstudianteId">

                                <div class="form-group">
                                    <label for="NombreE">Nombre</label>
                                    <input type="text" name="NombreE" id="NombreE" placeholder="Ingrese el nombre del estudiante" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="ApellidoE">Apellido</label>
                                    <input type="text" name="ApellidoE" id="ApellidoE" placeholder="Ingrese el apellido del estudiante" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="FechaNacimientoE">Fecha Nacimiento</label>
                                    <input type="date" name="FechaNacimientoE" id="FechaNacimientoE" placeholder="Ingrese la fecha de nacimiento del estudiante" class="form-control" required>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-primary">Actualizar</button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <!-- Fin Editar Estudiante Modal -->

            <!-- Lista de Productos -->
            <div class='container-fluid pt-4 px-3'>
                <div class="container d-flex flex-row justify-content-start">
                    <div>
                        <button type="button" class="btn btn-primary mb-4 mx-2" data-bs-toggle="modal" data-bs-target="#modalEstudiante">
                            <i class="bi bi-person-check"></i> Nuevo Paciente
                        </button>
                    </div>
                    <div>
                        <input onkeydown="if (event.keyCode === 13) buscarEstudiante(this.value)" style="width: 25rem;" type="text" id="buscarEstudiante" class="form-control mb-4 mx-3" placeholder="Buscar Paciente">
                    </div>
                </div>

                <h6 style="text-align: center; color: #FFFFFF;" class='mb-4'> Lista de Pacientes</h6>
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
                                <th>Telefono</th>
                                <th>Correo</th>
                                <th>Direccion</th>
                            </tr>
                        </thead>
                        <tbody id="cuerpoestudiantes">
                            <!-- Aquí van los datos de los productos -->
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- Fin Lista de Productos -->


            <!-- Widgets Start -->
            <!-- Aquí podrías agregar widgets relacionados con productos si lo deseas -->
            <!-- Widgets End -->


            <!-- Footer Start -->
            <?php require_once('./html/footer.php') ?>
            <!-- Footer End -->
        </div>
        <!-- Content End -->


        <!-- Back to Top -->
        <a href='#' class='btn btn-lg btn-primary btn-lg-square back-to-top'><i class='bi bi-arrow-up'></i></a>
    </div>


    <!-- JavaScript Libraries -->
    <?php require_once('./html/scripts.php') ?>
    <script src="paciente.js"></script>

</body>

</html>