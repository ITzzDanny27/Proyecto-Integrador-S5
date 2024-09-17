document.addEventListener("DOMContentLoaded", function () {
    const formRecepcionista = document.getElementById("frm_recepcionista");

    // Evento para el envío del formulario
    formRecepcionista.addEventListener("submit", function (event) {
        event.preventDefault(); // Evita la redirección predeterminada del formulario

        const formData = new FormData(formRecepcionista);
        const idRecepcionista = document.getElementById("id_recepcionista").value;

        // Determina si es una edición o una creación
        const action = idRecepcionista ? 'updateRecepcionista' : 'addRecepcionista';

        fetch(`../controllers/recepcionista.controller.php?action=${action}`, { // Ajusta la ruta si es necesario
            method: "POST",
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            console.log("Respuesta del servidor:", data); // Mensaje de depuración
            if (data.result === "ok") {
                alert(idRecepcionista ? "Recepcionista actualizado con éxito" : "Recepcionista guardado con éxito");
                $('#modalRecepcionista').modal('hide'); // Cierra el modal después de guardar
                limpiarFormulario(); // Limpia el formulario después de guardar
                listarRecepcionistas(); // Recarga la lista de recepcionistas
            } else {
                alert("Error al guardar recepcionista: " + (data.message || "Error desconocido"));
            }
        })
        .catch(error => console.error("Error en la petición:", error));
    });

    // Llamar a la función para listar recepcionistas
    listarRecepcionistas();

    // Añadir evento al botón de nuevo recepcionista
    document.getElementById("nuevoRecepcionistaBtn").addEventListener("click", function () {
        limpiarFormulario(); // Limpiar el formulario antes de mostrar el modal
        $('#modalRecepcionista').modal('show'); // Mostrar el modal de nuevo recepcionista
    });
});

// Función para listar recepcionistas
function listarRecepcionistas() {
    fetch("../controllers/recepcionista.controller.php?action=listar")
        .then(response => response.json())
        .then(data => {
            const cuerpoRecepcionistas = document.getElementById("cuerpoRecepcionistas");
            cuerpoRecepcionistas.innerHTML = ""; // Limpia la tabla antes de agregar los datos

            data.forEach((recepcionista, index) => {
                const fila = document.createElement("tr");
                fila.innerHTML = `
                    <td>${index + 1}</td>
                    <td>${recepcionista.NOMBRE}</td>
                    <td>${recepcionista.APELLIDO}</td>
                    <td>${recepcionista.TELEFONO}</td>
                    <td>${recepcionista.CORREO_ELECTRONICO}</td>
                    <td>********</td> <!-- Oculta la contraseña -->
                    <td>
                        <button class="btn btn-warning btn-sm" onclick="editarRecepcionista(${recepcionista.ID_RECEPCIONISTA})">Editar</button>
                        <button class="btn btn-danger btn-sm" onclick="eliminarRecepcionista(${recepcionista.ID_RECEPCIONISTA})">Eliminar</button>
                    </td>
                `;
                cuerpoRecepcionistas.appendChild(fila);
            });
        })
        .catch(error => console.error("Error al listar los recepcionistas:", error));
}

// Función para limpiar el formulario
function limpiarFormulario() {
    document.getElementById("id_recepcionista").value = "";
    document.getElementById("nombre").value = "";
    document.getElementById("apellido").value = "";
    document.getElementById("telefono").value = "";
    document.getElementById("correo_electronico").value = "";
    document.getElementById("password").value = "";
}

// Función para editar recepcionista
function editarRecepcionista(id) {
    fetch(`../controllers/recepcionista.controller.php?action=listar&id=${id}`)
        .then(response => response.json())
        .then(data => {
            const recepcionista = data[0];
            document.getElementById('id_recepcionista').value = recepcionista.ID_RECEPCIONISTA;
            document.getElementById('nombre').value = recepcionista.NOMBRE;
            document.getElementById('apellido').value = recepcionista.APELLIDO;
            document.getElementById('telefono').value = recepcionista.TELEFONO;
            document.getElementById('correo_electronico').value = recepcionista.CORREO_ELECTRONICO;
            document.getElementById('password').value = recepcionista.PASSWORD;

            $('#modalRecepcionista').modal('show'); // Mostrar el modal de edición
        })
        .catch(error => console.error("Error al obtener los datos del recepcionista:", error));
}

// Función para eliminar recepcionista
function eliminarRecepcionista(id) {
    if (confirm("¿Estás seguro de que deseas eliminar a este recepcionista? Esta acción no se puede deshacer.")) {
        fetch("../controllers/recepcionista.controller.php?action=deleteRecepcionista", {
            method: "POST",
            body: new URLSearchParams({ id_recepcionista: id })
        })
        .then(response => response.json())
        .then(data => {
            if (data.result === "ok") {
                alert("Recepcionista eliminado con éxito");
                listarRecepcionistas(); // Actualiza la lista de recepcionistas
            } else {
                alert("Error al eliminar el recepcionista");
            }
        })
        .catch(error => console.error("Error al eliminar el recepcionista:", error));
    }
}
