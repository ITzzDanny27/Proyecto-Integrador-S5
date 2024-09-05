document.addEventListener("DOMContentLoaded", function () {
    const formOdontologo = document.getElementById("frm_odontologo");

    // Evento para el envío del formulario
    formOdontologo.addEventListener("submit", function (event) {
        event.preventDefault(); // Evita la redirección predeterminada del formulario

        const formData = new FormData(formOdontologo);
        const idOdontologo = document.getElementById("id_odontologo").value;

        // Determina si es una edición o una creación
        const action = idOdontologo ? 'updateOdontologo' : 'addOdontologo';

        fetch(`../controllers/odontologo.controller.php?action=${action}`, { // Ajusta la ruta si es necesario
            method: "POST",
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            console.log("Respuesta del servidor:", data); // Mensaje de depuración
            if (data.result === "ok") {
                alert(idOdontologo ? "Odontologo actualizado con éxito" : "Odontologo guardado con éxito");
                $('#modalOdontologo').modal('hide'); // Cierra el modal después de guardar
                limpiarFormulario(); // Limpia el formulario después de guardar
                listarOdontologos(); // Recarga la lista de pacientes
            } else {
                alert("Error al guardar odontologo: " + (data.message || "Error desconocido"));
            }
        })
        .catch(error => console.error("Error en la petición:", error));
    });

    // Llamar a la función para listar pacientes
    listarOdontologos();

    // Añadir evento al botón de nuevo paciente
    document.getElementById("nuevoOdontologoBtn").addEventListener("click", function () {
        limpiarFormulario(); // Limpiar el formulario antes de mostrar el modal
        $('#modalOdontologo').modal('show'); // Mostrar el modal de nuevo paciente
    });
});

// Función para limpiar el formulario
function limpiarFormulario() {
    document.getElementById('id_odontologo').value = ''; // Limpia el campo oculto ID
    document.getElementById('NOMBRE').value = '';
    document.getElementById('APELLIDO').value = '';
    document.getElementById('ESPECIALIDAD').value = '';
    document.getElementById('TELEFONO').value = '';
    document.getElementById('CORREO_ELECTRONICO').value = '';
}

// Función para listar pacientes
function listarOdontologos() {
    fetch("../controllers/odontologo.controller.php?action=listar") // Ajusta la ruta si es necesario
        .then(response => response.json())
        .then(data => {
            console.log("Odontologos obtenidos:", data); // Verifica qué se recibe del servidor
            const cuerpoOdontologos = document.getElementById("cuerpoOdontologos");
            cuerpoOdontologos.innerHTML = ""; // Limpia el contenido anterior

            data.forEach((odontologo, index) => {
                const fila = document.createElement("tr");
                fila.innerHTML = `
                    <td>${index + 1}</td>
                    <td>${odontologo.NOMBRE}</td>
                    <td>${odontologo.APELLIDO}</td>
                    <td>${odontologo.ESPECIALIDAD}</td>
                    <td>${odontologo.TELEFONO}</td>
                    <td>${odontologo.CORREO_ELECTRONICO}</td>
                    <td>
                        <button class="btn btn-warning btn-sm" onclick="editarOdontologo(${odontologo.ID_ODONTOLOGO})">Editar</button>
                        <button class="btn btn-danger btn-sm" onclick="eliminarOdontologo(${odontologo.ID_ODONTOLOGO})">Eliminar</button>
                    </td>
                `;
                cuerpoOdontologos.appendChild(fila);
            });
        })
        .catch(error => console.error("Error al listar odontologos:", error));
}

// Función para editar un paciente
function editarOdontologo(id) {
    fetch(`../controllers/odontologo.controller.php?action=listar&id=${id}`)
        .then(response => response.json())
        .then(data => {
            const odontologo = data[0]; // Asegúrate de que obtienes el paciente correcto
            document.getElementById('id_odontologo').value = odontologo.ID_ODONTOLOGO;
            document.getElementById('NOMBRE').value = odontologo.NOMBRE;
            document.getElementById('APELLIDO').value = odontologo.APELLIDO;
            document.getElementById('ESPECIALIDAD').value = odontologo.ESPECIALIDAD;
            document.getElementById('TELEFONO').value = odontologo.TELEFONO;
            document.getElementById('CORREO_ELECTRONICO').value = odontologo.CORREO_ELECTRONICO;
            
            $('#modalOdontologo').modal('show'); // Mostrar el modal de edición
        })
        .catch(error => console.error("Error al obtener los datos del odontologo:", error));
}

// Función para eliminar un paciente
function eliminarOdontologo(id) {
    if (confirm("¿Estás seguro de que deseas eliminar este odontologo?")) {
        fetch("../controllers/odontologo.controller.php?action=deleteOdontologo", {
            method: "POST",
            body: new URLSearchParams({ id_odontologo: id })
        })
        .then(response => response.json())
        .then(data => {
            if (data.result === "ok") {
                alert("Odontologo eliminado con éxito");
                listarOdontologos(); // Actualiza la lista de pacientes
            } else {
                alert("Error al eliminar el odontologo");
            }
        })
        .catch(error => console.error("Error al eliminar el odontologo:", error));
    }
}
