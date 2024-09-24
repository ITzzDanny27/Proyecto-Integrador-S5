document.addEventListener("DOMContentLoaded", function () {
    const formPaciente = document.getElementById("frm_paciente");

    // Evento para el envío del formulario
    formPaciente.addEventListener("submit", function (event) {
        event.preventDefault(); // Evita la redirección predeterminada del formulario

        if (!validarFormulario()) {
            return; // Si la validación falla, no continuar
        }

        const formData = new FormData(formPaciente);
        const idPaciente = document.getElementById("id_paciente").value;

        // Determina si es una edición o una creación
        const action = idPaciente ? 'updatePaciente' : 'addPaciente';

        fetch(`../controllers/paciente.controller.php?action=${action}`, { // Ajusta la ruta si es necesario
            method: "POST",
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            console.log("Respuesta del servidor:", data); // Mensaje de depuración
            if (data.result === "ok") {
                alert(idPaciente ? "Paciente actualizado con éxito" : "Paciente guardado con éxito");
                $('#modalPaciente').modal('hide'); // Cierra el modal después de guardar
                limpiarFormulario(); // Limpia el formulario después de guardar
                listarPacientes(); // Recarga la lista de pacientes
            } else {
                alert("Error al guardar paciente: " + (data.message || "Error desconocido"));
            }
        })
        .catch(error => console.error("Error en la petición:", error));
    });

    // Llamar a la función para listar pacientes
    listarPacientes();

    // Añadir evento al botón de nuevo paciente
    document.getElementById("nuevoPacienteBtn").addEventListener("click", function () {
        limpiarFormulario(); // Limpiar el formulario antes de mostrar el modal
        $('#modalPaciente').modal('show'); // Mostrar el modal de nuevo paciente
    });
});

// Función para limpiar el formulario
function limpiarFormulario() {
    document.getElementById('id_paciente').value = ''; // Limpia el campo oculto ID
    document.getElementById('primer_nombre').value = '';
    document.getElementById('segundo_nombre').value = '';
    document.getElementById('apellido_paterno').value = '';
    document.getElementById('apellido_materno').value = '';
    document.getElementById('fecha_nacimiento').value = '';
    document.getElementById('telefono').value = '';
    document.getElementById('correo_electronico').value = '';
    document.getElementById('direccion').value = '';
}

// Función para listar pacientes
function listarPacientes() {
    fetch("../controllers/paciente.controller.php?action=listar") // Ajusta la ruta si es necesario
        .then(response => response.json())
        .then(data => {
            console.log("Pacientes obtenidos:", data); // Verifica qué se recibe del servidor
            const cuerpoPacientes = document.getElementById("cuerpoPacientes");
            cuerpoPacientes.innerHTML = ""; // Limpia el contenido anterior

            data.forEach((paciente, index) => {
                const fila = document.createElement("tr");
                fila.innerHTML = `
                    <td>${index + 1}</td>
                    <td>${paciente.PRIMER_NOMBRE}</td>
                    <td>${paciente.SEGUNDO_NOMBRE}</td>
                    <td>${paciente.APELLIDO_PATERNO}</td>
                    <td>${paciente.APELLIDO_MATERNO}</td>
                    <td>${paciente.FECHA_NACIMIENTO}</td>
                    <td>${paciente.TELEFONO}</td>
                    <td>${paciente.CORREO_ELECTRONICO}</td>
                    <td>${paciente.DIRECCION}</td>
                    <td>
                        <button class="btn btn-warning btn-sm" onclick="editarPaciente(${paciente.ID_PACIENTE})">Editar</button>
                        <button class="btn btn-danger btn-sm" onclick="eliminarPaciente(${paciente.ID_PACIENTE})">Eliminar</button>
                    </td>
                `;
                cuerpoPacientes.appendChild(fila);
            });
        })
        .catch(error => console.error("Error al listar pacientes:", error));
}

// Función para editar un paciente
function editarPaciente(id) {
    fetch(`../controllers/paciente.controller.php?action=listar&id=${id}`)
        .then(response => response.json())
        .then(data => {
            const paciente = data[0]; // Asegúrate de que obtienes el paciente correcto
            document.getElementById('id_paciente').value = paciente.ID_PACIENTE;
            document.getElementById('primer_nombre').value = paciente.PRIMER_NOMBRE;
            document.getElementById('segundo_nombre').value = paciente.SEGUNDO_NOMBRE;
            document.getElementById('apellido_paterno').value = paciente.APELLIDO_PATERNO;
            document.getElementById('apellido_materno').value = paciente.APELLIDO_MATERNO;
            document.getElementById('fecha_nacimiento').value = paciente.FECHA_NACIMIENTO;
            document.getElementById('telefono').value = paciente.TELEFONO;
            document.getElementById('correo_electronico').value = paciente.CORREO_ELECTRONICO;
            document.getElementById('direccion').value = paciente.DIRECCION;
            
            $('#modalPaciente').modal('show'); // Mostrar el modal de edición
        })
        .catch(error => console.error("Error al obtener los datos del paciente:", error));
}

// Función para eliminar un paciente
function eliminarPaciente(id) {
    if (confirm("¿Estás seguro de que deseas eliminar este paciente?")) {
        fetch("../controllers/paciente.controller.php?action=deletePaciente", {
            method: "POST",
            body: new URLSearchParams({ id_paciente: id })
        })
        .then(response => response.json())
        .then(data => {
            if (data.result === "ok") {
                alert("Paciente eliminado con éxito");
                listarPacientes(); // Actualiza la lista de pacientes
            } else {
                alert("Error al eliminar el paciente");
            }
        })
        .catch(error => console.error("Error al eliminar el paciente:", error));
    }
}

// Función para buscar pacientes en tiempo real
function buscarPaciente(query) {
    const filter = query.toLowerCase();
    const filas = document.getElementById("cuerpoPacientes").getElementsByTagName("tr");

    for (let i = 0; i < filas.length; i++) {
        const nombrePaciente = filas[i].getElementsByTagName("td")[1]; // Ajusta al índice de la columna de nombre en tu tabla
        if (nombrePaciente) {
            const textoNombre = nombrePaciente.textContent || nombrePaciente.innerText;
            if (textoNombre.toLowerCase().indexOf(filter) > -1) {
                filas[i].style.display = "";
            } else {
                filas[i].style.display = "none";
            }
        }
    }
}

function validarFormulario() {
    const primerNombre = document.getElementById('primer_nombre').value.trim();
    const apellidoPaterno = document.getElementById('apellido_paterno').value.trim();
    const correoElectronico = document.getElementById('correo_electronico').value.trim();
    const telefono = document.getElementById('telefono').value.trim();

    if (!primerNombre || !apellidoPaterno || !correoElectronico || !telefono) {
        alert("Error: Por favor, complete todos los campos obligatorios.");
        return false;
    }

    const emailRegex = /^[^\s@]+@[^\s@]+.[^\s@]+$/;
    if (!emailRegex.test(correoElectronico)) {
        alert("Error: El correo electrónico no es válido.");
        return false;
    }

    const telefonoRegex = /^\d{10}$/; // Ajusta la expresión regular según el formato deseado
    if (!telefonoRegex.test(telefono)) {
        alert("Error: El número de teléfono no es válido. Debe tener 10 dígitos.");
        return false;
    }

    return true; // El formulario es válido
}