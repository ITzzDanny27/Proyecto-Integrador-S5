<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <title>Login</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta content="" name="keywords" />
    <meta content="" name="description" />

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon" />

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&display=swap" rel="stylesheet" />

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet" />

    <!-- Libraries Stylesheet -->
    <link href="./public/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet" />
    <link href="./public/lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />

    <!-- Customized Bootstrap Stylesheet -->
    <link href="./public/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Template Stylesheet -->
    <link href="./public/css/style.css" rel="stylesheet" />
</head>

<body>
    <div class="container-xxl position-relative bg-white d-flex p-0">
        <!-- Sign In Start -->
        <div class="container-fluid">
            <div class="row h-100 align-items-center justify-content-center" style="min-height: 100vh">
                <div class="col-12 col-sm-8 col-md-6 col-lg-5 col-xl-4">
                    <div class="bg-light rounded p-4 p-sm-5 my-4 mx-3">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <a class="">
                                <h3 class="text-primary">
                                    <i class="fa fa-hashtag me-2"></i>Login
                                </h3>
                            </a>
                            <h3>Ingreso</h3>
                        </div>

                        <form method="post" action="./controllers/login.controller.php?op=login">
                            <?php
                            if (isset($_GET['op'])) {
                                switch ($_GET['op']) {
                                    case '1':
                                        echo '<div class="alert alert-danger">El usuario o la contraseña son incorrectos, intente de nuevo</div>';
                                        break;
                                    case '2':
                                        echo '<div class="alert alert-danger">Complete las carillas</div>';
                                        break;
                                }
                            }
                            ?>

                            <div class="form-floating mb-3">
                                <input required type="text" class="form-control" id="CORREO_ELECTRONICO" name="CORREO_ELECTRONICO" placeholder="Ingrese su usuario o correo" autofocus />
                                <label for="CORREO_ELECTRONICO">Usuario o Correo</label>
                            </div>
                            <div class="form-floating mb-4">
                                <input required type="password" id="PASSWORD" name="PASSWORD" class="form-control" placeholder="Contraseña" />
                                <label for="PASSWORD">Contraseña</label>
                            </div>

                            <!-- Eliminamos el campo de rol o cambiamos por un select si es necesario -->
                            <div class="form-floating mb-4">
                                <select id="rol" name="rol" class="form-control">
                                    <option value="" disabled selected>Seleccione su rol</option>
                                    <option value="recepcionista">Recepcionista</option>
                                    <option value="admin">Admin</option>
                                </select>
                                <label for="rol">Rol</label>
                            </div>

                            <div class="mb-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="remember-me" />
                                    <label class="form-check-label" for="remember-me">Recuérdame</label>
                                </div>
                            </div>

                            <div class="mb-3">
                                <button class="btn btn-primary py-3 w-100 mb-4" type="submit">
                                    Ingresar
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <!-- Sign In End -->
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>
