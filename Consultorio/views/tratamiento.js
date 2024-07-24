// Inicialización
function init() {
    $("#frm_tratamiento").on("submit", function (e) {
        guardar(e);
    });
}

$(document).ready(() => {
    cargaTabla();
});

// Cargar la tabla de clases
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
                            <button class="btn btn-primary" onclick="cargarClase(${unTratamiento.ID_TRATAMIENTO})">Editar</button>
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


// var cargarClase = (id_clase) => {
//     $.get("../controllers/clase.controller.php?op=uno&id=" + id_clase, (data) => {
//         var Clase = JSON.parse(data);
//         console.log("Clase encontrada:", Clase);
//         $("#EditarClaseId").val(Clase.id_clase);
//         $("#EditarClaseCurso").val(Clase.nombre_curso);
//         $("#EditarClaseProfesor").val(Clase.id_profesor);
//         $("#EditarClaseAula").val(Clase.numero_aula);
//         $("#EditarClaseHorario").val(Clase.horario);
//         $("#modalEditarClase").modal("show");
//     });
// }


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
            console.error("Error al guardar:", error);
        }
    });
}

init();