document.addEventListener("DOMContentLoaded", function () {
    const formConsulta = document.getElementById("frm_consulta");

    // Evento para el envío del formulario
    formConsulta.addEventListener("submit", function (event) {
        event.preventDefault(); // Evita la redirección predeterminada del formulario

        const formData = new FormData(formConsulta);
        const idConsulta = document.getElementById("id_consulta").value;

        // Determina si es una edición o una creación
        const action = idConsulta ? 'updateConsulta' : 'addConsulta';

        fetch(`../controllers/consulta.controller.php?action=${action}`, { // Ajusta la ruta si es necesario
            method: "POST",
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            console.log("Respuesta del servidor:", data); // Mensaje de depuración
            if (data.result === "ok") {
                alert(idConsulta ? "Consulta actualizada con éxito" : "Consulta guardada con éxito");
                $('#modalConsulta').modal('hide'); // Cierra el modal después de guardar
                limpiarFormulario(); // Limpia el formulario después de guardar
                listarConsultas(); // Recarga la lista de pacientes
            } else {
                alert("Error al guardar consulta: " + (data.message || "Error desconocido"));
            }
        })
        .catch(error => console.error("Error en la petición:", error));
    });

    // Llamar a la función para listar pacientes
    listarConsultas();

    // Añadir evento al botón de nuevo paciente
    document.getElementById("nuevoConsultaBtn").addEventListener("click", function () {
        limpiarFormulario(); // Limpiar el formulario antes de mostrar el modal
        $('#modalConsulta').modal('show'); // Mostrar el modal de nuevo paciente
    });
});

// Función para limpiar el formulario
function limpiarFormulario() {
    document.getElementById('id_consulta').value = ''; // Limpia el campo oculto ID
    document.getElementById('ID_CITA').value = '';
    document.getElementById('ID_TRATAMIENTO').value = '';
    document.getElementById('DESCRIPCION').value = '';
}

// Función para listar pacientes
// Función para listar consultas
function listarConsultas() {
    fetch("../controllers/consulta.controller.php?action=listar") // Ajusta la ruta si es necesario
        .then(response => response.json())
        .then(data => {
            console.log("Consultas obtenidos:", data); // Verifica qué se recibe del servidor
            const cuerpoConsultas = document.getElementById("cuerpoConsultas");
            cuerpoConsultas.innerHTML = ""; // Limpia el contenido anterior

            data.forEach((consulta, index) => {
                const fila = document.createElement("tr");
                fila.innerHTML = `
                    <td>${index + 1}</td>
                    <td>${consulta.ID_CONSULTA}</td>
                    <td>${consulta.PACIENTE_NOMBRE} ${consulta.PACIENTE_APELLIDO}</td>
                    <td>${consulta.FECHA}</td>
                    <td>${consulta.HORA}</td>
                    <td>${consulta.CITA_ESTADO}</td>
                    <td>${consulta.TRATAMIENTO_DESCRIPCION}</td>
                    <td>
                        <button class="btn btn-warning btn-sm" onclick="editarConsulta(${consulta.ID_CONSULTA})">Editar</button>
                        <button class="btn btn-danger btn-sm" onclick="eliminarConsulta(${consulta.ID_CONSULTA})">Eliminar</button>
                    </td>
                `;
                cuerpoConsultas.appendChild(fila);
            });
        })
        .catch(error => console.error("Error al listar consultas:", error));
}


// Función para editar un paciente
function editarConsulta(id) {
    fetch(`../controllers/consulta.controller.php?action=listar&id=${id}`)
        .then(response => response.json())
        .then(data => {
            const consulta = data[0]; // Asegúrate de que obtienes el paciente correcto
            document.getElementById('id_consulta').value = consulta.ID_CONSULTA;
            document.getElementById('ID_CITA').value = consulta.ID_CITA;
            document.getElementById('ID_TRATAMIENTO').value = consulta.ID_TRATAMIENTO;
            document.getElementById('DESCRIPCION').value = consulta.DESCRIPCION;
            
            $('#modalConsulta').modal('show'); // Mostrar el modal de edición
        })
        .catch(error => console.error("Error al obtener los datos de la consulta:", error));
}

// Función para eliminar un paciente
function eliminarConsulta(id) {
    if (confirm("¿Estás seguro de que deseas eliminar esta consulta?")) {
        fetch("../controllers/consulta.controller.php?action=deleteConsulta", {
            method: "POST",
            body: new URLSearchParams({ id_consulta: id })
        })
        .then(response => response.json())
        .then(data => {
            if (data.result === "ok") {
                alert("Consulta eliminada con éxito");
                listarConsultas(); // Actualiza la lista de pacientes
            } else {
                alert("Error al eliminar la consulta");
            }
        })
        .catch(error => console.error("Error al eliminar la consulta:", error));
    }
}

// Función para llenar el combobox de citas
function llenarCitas() {
    fetch("../controllers/consulta.controller.php?action=listarCitas") // Ajusta la ruta si es necesario
        .then(response => response.json())
        .then(data => {
            const selectCita = document.getElementById("ID_CITA");
            selectCita.innerHTML = "<option value=''>Seleccione cita</option>"; // Opción por defecto
            data.forEach(cita => {
                const option = document.createElement("option");
                option.value = cita.ID_CITA;
               option.textContent = `Cita #${cita.ID_CITA} - Paciente: ${cita.NOMBRE_PACIENTE}  - Fecha: ${cita.FECHA} - Hora: ${cita.HORA} - Estado: ${cita.ESTADO}`;
               
                selectCita.appendChild(option);
            });
        })
        .catch(error => console.error("Error al obtener citas:", error));
}

function listarCitas() {
    fetch("../controllers/consulta.controller.php?action=listarCitas")
        .then(response => response.json())
        .then(data => {
            console.log("Datos de citas:", data); // Verifica qué se recibe del servidor
            const selectCitas = document.getElementById("ID_CITA");
            selectCitas.innerHTML = ""; // Limpia el contenido anterior

            data.forEach(cita => {
                const option = document.createElement("option");
                option.value = cita.ID_CITA;
                option.textContent = cita.ID_CITA; // Muestra solo el ID_CITA
                selectCitas.add(option);
            });
        })
        .catch(error => console.error("Error al listar citas:", error));
}


// Función para llenar el combobox de tratamientos
function llenarTratamientos() {
    fetch("../controllers/consulta.controller.php?action=listarTratamientos") // Ajusta la ruta si es necesario
        .then(response => response.json())
        .then(data => {
            const selectTratamiento = document.getElementById("ID_TRATAMIENTO");
            selectTratamiento.innerHTML = "<option value=''>Seleccione tratamiento</option>"; // Opción por defecto
            data.forEach(tratamiento => {
                const option = document.createElement("option");
                option.value = tratamiento.ID_TRATAMIENTO;
                option.textContent = tratamiento.DESCRIPCION;
                selectTratamiento.appendChild(option);
            });
        })
        .catch(error => console.error("Error al obtener tratamientos:", error));
}

// Llamar a las funciones para llenar los comboboxes cuando se carga la página
document.addEventListener("DOMContentLoaded", function () {
    llenarCitas();
    llenarTratamientos();
    
    // El resto de tu código aquí...
});

