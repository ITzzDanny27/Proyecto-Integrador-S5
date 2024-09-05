// Inicialización
function init() {
    $("#frm_tratamiento").on("submit", function (e) {
        guardar(e);
    });

    $("#frm_EditarTratamiento").on("submit", function (e) {
        editar(e);
    });

}

$(document).ready(() => {
    cargaTabla();
});

// Cargar la tabla de tratamientos
var cargaTabla = () => {
    var html = "";

    $.get("../controllers/tratamiento.controller.php?op=listar", (response) => {
        let listaTratamientos;
        try {
            listaTratamientos = JSON.parse(response);
        } catch (e) {
            console.error("Error parsing JSON:", e);
            return;
        }

        if (Array.isArray(listaTratamientos)) {
            $.each(listaTratamientos, (indice, unTratamiento) => {
                html += `
                    <tr>
                        <td>${indice + 1}</td>
                        <td>${unTratamiento.DESCRIPCION}</td>
                        <td>${unTratamiento.COSTO}</td>
                        <td>${unTratamiento.DURACION}</td>
                        <td>
                            <button class="btn btn-primary" onclick="cargarTratamiento(${unTratamiento.ID_TRATAMIENTO})">Editar</button>
                            <button class="btn btn-danger" onclick="eliminar(${unTratamiento.ID_TRATAMIENTO})">Eliminar</button>
                        </td>
                    </tr>
                `;
            });
            $("#cuerpotratamiento").html(html);
        } else {
            console.error("Expected an array but got:", listaTratamientos);
        }
    });
};

// Cargar datos de un tratamiento en el formulario de edición
var cargarTratamiento = (TratamientoId) => {
    $.get("../controllers/tratamiento.controller.php?op=uno&id=" + TratamientoId, (data) => {
        var tratamiento = JSON.parse(data);
        console.log("Tratamiento encontrado:", tratamiento);
        $("#TratamientoIdE").val(tratamiento.ID_TRATAMIENTO);
        $("#DescripcionE").val(tratamiento.DESCRIPCION);
        $("#CostoE").val(tratamiento.COSTO);
        $("#DuracionE").val(tratamiento.DURACION);
        $("#modalEditarTratamiento").modal("show");
    }).fail(function() {
        console.error("Error al obtener los datos del tratamiento");
    });
}

// Guardar un tratamiento
var guardar = (e) => {
    e.preventDefault();

    var frm_tratamiento = new FormData($("#frm_tratamiento")[0]);
    console.log("Datos del formulario:", frm_tratamiento);

    var ruta = "../controllers/tratamiento.controller.php?op=insertar";

    $.ajax({
        url: ruta,
        type: "POST",
        data: frm_tratamiento,
        contentType: false,
        processData: false,
        success: function (datos) {
            console.log(datos);
            location.reload();
            $("#modalTratamiento").modal("hide");
        },
        error: function (xhr, status, error) {
            console.error("Error al guardar el tratamiento:", error);
        }
    });
}

// Editar un tratamiento
var editar = (e) => {
    e.preventDefault();

    var frm_EditarTratamiento = new FormData($("#frm_EditarTratamiento")[0]);
    console.log("Datos del formulario de edición:", frm_EditarTratamiento);

    var ruta = "../controllers/tratamiento.controller.php?op=actualizar";

    $.ajax({
        url: ruta,
        type: "POST",
        data: frm_EditarTratamiento,
        contentType: false,
        processData: false,
        success: function (datos) {
            console.log(datos);
            location.reload();
            $("#modalEditarTratamiento").modal("hide");
        },
        error: function (xhr, status, error) {
            console.error("Error al editar el tratamiento:", error);
        }
    });
}

// Eliminar un tratamiento
var eliminar = (TratamientoId) => {
    Swal.fire({
        title: "Tratamiento",
        text: "¿Está seguro que desea eliminar el tratamiento?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#3085d6",
        confirmButtonText: "Eliminar",
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: "../controllers/tratamiento.controller.php?op=eliminar",
                type: "POST",
                data: { ID_TRATAMIENTO: TratamientoId },
                success: (resultado) => {
                    console.log("Respuesta del servidor:", resultado);
                    try {
                        let response = JSON.parse(resultado);
                        if (response === "Tratamiento eliminado") {
                            Swal.fire({
                                title: "Tratamiento",
                                text: "Se eliminó con éxito",
                                icon: "success",
                            });
                            cargaTabla();
                        }location.reload();
                    } catch (e) {
                        Swal.fire({
                            title: "Tratamiento",
                            text: "No se pudo eliminar el tratamiento debido a que ya está registrado en otra tabla",
                            icon: "error",
                        });
                        console.error("Error al parsear JSON:", e);
                    }
                },
                error: () => {
                    Swal.fire({
                        title: "Tratamiento", 
                        text: "Ocurrió un error al intentar eliminar",
                        icon: "error",
                    });
                }
            });
        }
    });
};

init();