// Inicialización
function init() {
    $("#frm_estudiantes").on("submit", function (e) {
        guardar(e);
    });
    $("#frm_editar_estudiantes").on("submit", function (e) {
        editar(e);
    });
}

$(document).ready(() => {
    cargaTabla();
});




// Cargar la tabla de estudiantes
var cargaTabla = () => {
    var html = "";

    $.get("../controllers/estudiante.controller.php?op=listar", (response) => {
        try {
            var listaEstudiantes = JSON.parse(response);
        } catch (e) {
            console.error("Error parsing JSON:", e);
            return;
        }

        if (Array.isArray(listaEstudiantes)) {
            $.each(listaEstudiantes, (indice, unEstudiante) => {
                html += `
                    <tr>
                        <td>${indice + 1}</td>
                        <td>${unEstudiante.id_estudiante}</td>  
                        <td>${unEstudiante.nombre}</td>
                        <td>${unEstudiante.apellido}</td>
                        <td>${unEstudiante.fecha_nacimiento}</td>
                        <td>
                            <button class="btn btn-primary" onclick="cargarEstudiante(${unEstudiante.id_estudiante})">Editar</button>
                            <button class="btn btn-danger" onclick="eliminar(${unEstudiante.id_estudiante})">Eliminar</button>
                        </td>
                    </tr>
                `;
            });
            $("#cuerpoestudiantes").html(html);
        } else {
            console.error("Expected an array but got:", listaEstudiantes);
        }
    });
};


var cargarEstudiante = (id_estudiante) => {
    console.log("ID del estudiante:", id_estudiante);
    $.get("../controllers/estudiante.controller.php?op=uno&id=" + id_estudiante, (data) => {
        var Estudiante = JSON.parse(data);
        console.log("Estudiante encontrado:", Estudiante);
        $("#EditarEstudianteId").val(Estudiante.id_estudiante);
        $("#NombreE").val(Estudiante.nombre);
        $("#ApellidoE").val(Estudiante.apellido);
        $("#FechaNacimientoE").val(Estudiante.fecha_nacimiento);
        $("#modalEditarEstudiante").modal("show");
    }).fail(function() {
        Swal.fire({
            title: "Estudiantes",
            text: "Ocurrió un error al intentar obtener los datos del estudiante",
            icon: "error",
        });
    });
};

var buscarEstudiante = (id_estudiante) => {
    $.get("../controllers/estudiante.controller.php?op=uno&id=" + id_estudiante, (data) => {
        try {
            var Estudiante = JSON.parse(data);

            if (Estudiante && Estudiante.id_estudiante) {
                console.log("Estudiante encontrado:", Estudiante);

                var html="";

                html += `
                    <tr>
                        <td>${Estudiante.id_estudiante}</td>
                        <td>${Estudiante.nombre}</td>
                        <td>${Estudiante.apellido}</td>
                        <td>${Estudiante.fecha_nacimiento}</td>
                        <td>
                            <button class="btn btn-primary" onclick="cargarEstudiante(${Estudiante.id_estudiante})">Editar</button>
                            <button class="btn btn-danger" onclick="eliminar(${Estudiante.id_estudiante})">Eliminar</button>
                        </td>
                    </tr>
                `;

                $("#cuerpoestudiantes").html(html);
            } else {
                console.error("Estudiante no encontrado:", Estudiante);
                cargaTabla();
            }
        } catch (e) {
            console.error("Error parsing JSON:", e);
        }
    });
}


// Guardar o editar un estudiante
var guardar = (e) => {
    e.preventDefault();

    var frm_estudiantes = new FormData($("#frm_estudiantes")[0]);
    console.log("Datos del formulario:", frm_estudiantes);

    var ruta = "../controllers/estudiante.controller.php?op=insertar";
    $.ajax({
        url: ruta,
        type: "POST",
        data: frm_estudiantes,
        contentType: false,
        processData: false,
        success: function (datos) {
            console.log(datos);
            $("#modalEstudiante").modal("hide");
            location.reload();
        },
        error: function (xhr, status, error) {
            console.error("Error al guardar el estudiante:", error);
        }
    });
};

// Editar un estudiante
var editar = (e) => {
    e.preventDefault();
    var frm_editar_estudiantes = new FormData($("#frm_editar_estudiantes")[0]);
    console.log("Datos del formulario:", frm_editar_estudiantes);
    var ruta = "../controllers/estudiante.controller.php?op=actualizar";

    $.ajax({
        url: ruta,
        type: "POST",
        data: frm_editar_estudiantes,
        processData: false,
        contentType: false,
        success: function (datos) {
            console.log(datos);
            location.reload();
            $("#modalEditarEstudiante").modal("hide");
        },
        error: function (xhr, status, error) {
            console.error("Error al actualizar:", error);
        }
    });
};

// Eliminar un estudiante
var eliminar = (EstudiantesId) => {
    Swal.fire({
        title: "Estudiantes",
        text: "¿Está seguro que desea eliminar el estudiante?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#3085d6",
        confirmButtonText: "Eliminar",
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: "../controllers/estudiante.controller.php?op=eliminar",
                type: "POST",
                data: { id_estudiante: EstudiantesId },
                success: (resultado) => {
                    console.log("Respuesta del servidor:", resultado);
                    try {
                        let response = JSON.parse(resultado);
                        if (response === "Estudiante eliminado") {
                            Swal.fire({
                                title: "Estudiantes",
                                text: "Se eliminó con éxito",
                                icon: "success",
                            });
                            cargaTabla();
                        }
                    } catch (e) {
                        Swal.fire({
                            title: "Estudiantes",
                            text: "No se pudo eliminar el estudiante debido a que ya está registrado en otra tabla",
                            icon: "error",
                        });
                        console.error("Error al parsear JSON:", e);
                    }
                },
                error: () => {
                    Swal.fire({
                        title: "Estudiantes", 
                        text: "Ocurrió un error al intentar eliminar",
                        icon: "error",
                    });
                }
            });
        }
    });
};

init();

// Inicialización
function init() {
    $("#frm_estudiantes").on("submit", function (e) {
        guardar(e);
    });
    $("#frm_editar_estudiantes").on("submit", function (e) {
        editar(e);
    });
}

$(document).ready(() => {
    cargaTabla();
});

// Cargar la tabla de estudiantes
var cargaTabla = () => {
    var html = "";

    $.get("../controllers/estudiante.controller.php?op=listar", (response) => {
        let listaEstudiantes;
        try {
            listaEstudiantes = JSON.parse(response);
        } catch (e) {
            console.error("Error parsing JSON:", e);
            return;
        }

        if (Array.isArray(listaEstudiantes)) {
            $.each(listaEstudiantes, (indice, unEstudiante) => {
                html += `
                    <tr>
                        <td>${indice + 1}</td>
                        <td>${unEstudiante.id_estudiante}</td>
                        <td>${unEstudiante.nombre}</td>
                        <td>${unEstudiante.apellido}</td>
                        <td>${unEstudiante.fecha_nacimiento}</td>
                        <td>
                            <button class="btn btn-primary" onclick="cargarEstudiante(${unEstudiante.id_estudiante})">Editar</button>
                            <button class="btn btn-danger" onclick="eliminar(${unEstudiante.id_estudiante})">Eliminar</button>
                        </td>
                    </tr>
                `;
            });
            $("#cuerpoestudiantes").html(html);
        } else {
            console.error("Expected an array but got:", listaEstudiantes);
        }
    });
};

// Cargar los datos de un estudiante en el formulario de edición
var cargarEstudiante = (id_estudiante) => {
    console.log("ID del estudiante:", id_estudiante);
    $.get("../controllers/estudiante.controller.php?op=uno&id=" + id_estudiante, (data) => {
        var Estudiante = JSON.parse(data);
        console.log("Estudiante encontrado:", Estudiante);
        $("#EditarEstudianteId").val(Estudiante.id_estudiante);
        $("#NombreE").val(Estudiante.nombre);
        $("#ApellidoE").val(Estudiante.apellido);
        $("#FechaNacimientoE").val(Estudiante.fecha_nacimiento);
        $("#modalEditarEstudiante").modal("show");
    }).fail(function() {
        Swal.fire({
            title: "Estudiantes",
            text: "Ocurrió un error al intentar obtener los datos del estudiante",
            icon: "error",
        });
    });
};

// Guardar o editar un estudiante
var guardar = (e) => {
    e.preventDefault();

    var frm_estudiantes = new FormData($("#frm_estudiantes")[0]);
    console.log("Datos del formulario:", frm_estudiantes);

    var ruta = "../controllers/estudiante.controller.php?op=insertar";
    $.ajax({
        url: ruta,
        type: "POST",
        data: frm_estudiantes,
        contentType: false,
        processData: false,
        success: function (datos) {
            console.log(datos);
            $("#modalEstudiante").modal("hide");
            location.reload();
        },
        error: function (xhr, status, error) {
            console.error("Error al guardar el estudiante:", error);
        }
    });
};

// Editar un estudiante
var editar = (e) => {
    e.preventDefault();
    var frm_editar_estudiantes = new FormData($("#frm_editar_estudiantes")[0]);
    console.log("Datos del formulario:", frm_editar_estudiantes);
    var ruta = "../controllers/estudiante.controller.php?op=actualizar";

    $.ajax({
        url: ruta,
        type: "POST",
        data: frm_editar_estudiantes,
        processData: false,
        contentType: false,
        success: function (datos) {
            console.log(datos);
            location.reload();
            $("#modalEditarEstudiante").modal("hide");
        },
        error: function (xhr, status, error) {
            console.error("Error al actualizar:", error);
        }
    });
};

// Eliminar un estudiante
var eliminar = (EstudiantesId) => {
    Swal.fire({
        title: "Estudiantes",
        text: "¿Está seguro que desea eliminar el estudiante?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#3085d6",
        confirmButtonText: "Eliminar",
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: "../controllers/estudiante.controller.php?op=eliminar",
                type: "POST",
                data: { id_estudiante: EstudiantesId },
                success: (resultado) => {
                    console.log("Respuesta del servidor:", resultado);
                    try {
                        let response = JSON.parse(resultado);
                        if (response === "Estudiante eliminado") {
                            Swal.fire({
                                title: "Estudiantes",
                                text: "Se eliminó con éxito",
                                icon: "success",
                            });
                            cargaTabla();
                        }
                    } catch (e) {
                        Swal.fire({
                            title: "Estudiantes",
                            text: "No se pudo eliminar el estudiante debido a que ya está siendo utilizado en INSCRIPCION",
                            icon: "error",
                        });
                        console.error("Error al parsear JSON:", e);
                    }
                },
                error: () => {
                    Swal.fire({
                        title: "Estudiantes", 
                        text: "Ocurrió un error al intentar eliminar",
                        icon: "error",
                    });
                }
            });
        }
    });
};

init();
