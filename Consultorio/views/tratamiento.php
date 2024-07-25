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

        body{
            background-color: #282d41;
        }
    
    </style>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>
    <div class='container-xxl position-relative bg-white d-flex p-0'>
        <!-- Spinner Start -->
        <div id='spinner'
            class='show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center'>
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


            <!-- Nuevo Clase Modal -->
            <div class="modal fade" id="modalTratamiento" tabindex="-1" aria-labelledby="exampleModalLabel"
                aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">Nuevo tratamiento</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form id="frm_tratamiento">
                            <div class="modal-body">
                                <input type="hidden" name="TratamientoId" id="TratamientoId">

                                <div class="form-group">
                                    <label for="Descripcion">Descripción</label>
                                    <input type="text" name="Descripcion" id="Descripcion" placeholder="Ingrese la descripcion del tratamiento" class="form-control" required>
                                </div>

                                <div class="form-group">
                                    <label for="Costo">Costo</label>
                                    <input type="text" name="Costo" id="Costo" placeholder="Ingrese el costo del tratamiento" class="form-control" required>
                                </div>

                                <div class="form-group">
                                    <label for="Duracion">Duracion</label>
                                    <input type="text" name="Duracion" id="Duracion" placeholder="Ingrese la duracion del tratamiento" class="form-control" required>
                                </div>

                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-primary">Guardar</button>
                                <button type="button" class="btn btn-secondary"
                                    data-bs-dismiss="modal">Cancelar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <!-- Fin Nuevo Clase Modal -->

            <!-- Editar Clase Modal -->
            <!-- <div class="modal fade" id="modalEditarClase" tabindex="-1" aria-labelledby="editarClaseLabel"
                aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editarClaseLabel">Editar Clase</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form id="frm_editar_clase">
                            <div class="modal-body">
                                <input type="hidden" name="EditarClaseId" id="EditarClaseId">

                                <div class="form-group">
                                    <label for="Nombre">Nombre</label>
                                    <input type="text" name="NombreE" id="NombreE" placeholder="Ingrese el nombre de la clase" class="form-control" required>
                                </div>

                                <div class="form-group">
                                    <label for="Descripcion">Descripción</label>
                                    <input type="text" name="DescripcionE" id="DescripcionE" placeholder="Ingrese la Descripcion del curso" class="form-control" required>
                                </div>

                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-primary">Actualizar</button>
                                <button type="button" class="btn btn-secondary"
                                    data-bs-dismiss="modal">Cancelar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div> -->
            <!-- Fin Editar Clase Modal -->

            <!-- Lista de Clase -->
            <div class='container-fluid pt-4 px-4'>
                <button type="button" class="btn btn-primary " data-bs-toggle="modal" data-bs-target="#modalTratamiento">
                <i class="bi bi-file-earmark-plus-fill"></i> Nuevo Tratamiento
                </button>
                <h6 style="text-align: center;" class='mb-4'> Lista de tratamientos</h6>
                <div class='d-flex align-items-center justify-content-between mb-4'>
                    <table class="table table-bordered table-striped table-hover table-responsive">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Descripcion</th>
                                <th>Costo</th>
                                <th>Duracion</th>

                            </tr>
                        </thead>
                        <tbody id="cuerpotratamiento">
                            <!-- Aquí van los datos de los productos -->
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- Fin Lista de Clase -->


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
    <script src="tratamiento.js"></script>

</body>

</html>