document.addEventListener("DOMContentLoaded", function () {
    const formHistorial = document.getElementById("frm_historial");
    const nuevoHistorialBtn = document.getElementById("nuevoHistorialBtn");

    // Verifica si el formulario y el botón existen en el DOM
    if (formHistorial && nuevoHistorialBtn) {
        // Cargar la lista de pacientes y historiales al cargar la página
        cargarPacientes();
        listarHistoriales();

        // Agregar EventListener para manejar el submit del formulario
        formHistorial.addEventListener("submit", function (event) {
            event.preventDefault();
            guardarHistorial();
        });

        // Agregar EventListener para mostrar el modal de nuevo historial
        nuevoHistorialBtn.addEventListener("click", function () {
            limpiarFormulario();
            $('#modalHistorial').modal('show');
        });
    } else {
        console.error("El formulario 'frm_historial' o el botón 'nuevoHistorialBtn' no se encontraron en el DOM.");
    }
});

// Función para guardar o actualizar un historial
function guardarHistorial() {
    const formHistorial = document.getElementById("frm_historial");
    const formData = new FormData(formHistorial);
    const idHistorial = document.getElementById("id_historial").value;
    const action = idHistorial ? 'actualizar' : 'agregar';

    fetch(`../controllers/HistorialMedicoController.php?action=${action}`, {
        method: "POST",
        body: formData
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Error en la solicitud');
        }
        return response.json();
    })
    .then(data => {
        if (data.result === 'ok') {
            alert(idHistorial ? "Historial actualizado con éxito" : "Historial guardado con éxito");
            listarHistoriales(); // Actualiza la lista después de guardar o actualizar
            $('#modalHistorial').modal('hide'); // Oculta el modal después de guardar
        } else {
            alert("Error: " + (data.message || "Error desconocido"));
        }
    })
    .catch(error => console.error("Error al guardar historial:", error));
}

// Función para cargar los pacientes
function cargarPacientes() {
    fetch("../controllers/HistorialMedicoController.php?action=getPacientes")
        .then(response => {
            if (!response.ok) {
                throw new Error('Respuesta inesperada al cargar pacientes.');
            }
            return response.json();
        })
        .then(data => {
            if (!Array.isArray(data)) {
                throw new Error("La respuesta no es un arreglo válido.");
            }
            const selectPaciente = document.getElementById("id_paciente");
            selectPaciente.innerHTML = ""; // Limpiar el contenido actual
            data.forEach(paciente => {
                const option = document.createElement("option");
                option.value = paciente.id_paciente;
                option.text = `${paciente.primer_nombre} ${paciente.apellido_paterno}`;
                selectPaciente.appendChild(option);
            });
        })
        .catch(error => console.error("Error al cargar pacientes:", error));
}

// Función para listar los historiales
function listarHistoriales() {
    fetch("../controllers/HistorialMedicoController.php?action=listar")
        .then(response => {
            if (!response.ok) {
                throw new Error('Error al listar historiales');
            }
            return response.text(); // Cambia a text para inspeccionar la respuesta completa
        })
        .then(text => {
            console.log("Respuesta del servidor:", text); // Muestra la respuesta del servidor en la consola
            try {
                const data = JSON.parse(text); // Intenta convertir la respuesta a JSON
                if (!Array.isArray(data)) {
                    throw new Error("La respuesta no es un arreglo válido.");
                }

                const cuerpoHistoriales = document.getElementById("cuerpoHistoriales");
                cuerpoHistoriales.innerHTML = "";

                data.forEach(historial => {
                    const fila = document.createElement("tr");
                    fila.innerHTML = `
                        <td>${historial.id_historial || 'Sin ID'}</td>
                        <td>${historial.ID_CONSULTA || 'Sin Consulta'}</td>
                        <td>${historial.fecha || 'Sin Fecha'}</td>
                        <td>${historial.observaciones || 'Sin Observaciones'}</td>
                        <td>
                            <button onclick="editarHistorial(${historial.id_historial})">Editar</button>
                            <button onclick="eliminarHistorial(${historial.id_historial})">Eliminar</button>
                        </td>
                    `;
                    cuerpoHistoriales.appendChild(fila);
                });
            } catch (error) {
                console.error("Error al procesar la respuesta del servidor:", text); // Muestra la respuesta no válida
                alert("Error al listar historiales: " + error.message);
            }
        })
        .catch(error => console.error("Error al listar historiales:", error));
}


// Función para editar un historial
function editarHistorial(id) {
    fetch(`../controllers/HistorialMedicoController.php?action=listar&id=${id}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Error al obtener los datos del historial');
            }
            return response.json();
        })
        .then(data => {
            const historial = data[0];
            document.getElementById('id_historial').value = historial.id_historial;
            document.getElementById('ID_CONSULTA').value = historial.ID_CONSULTA;
            document.getElementById('FECHA').value = historial.fecha;
            document.getElementById('OBSERVACIONES').value = historial.observaciones;
            
            $('#modalHistorial').modal('show'); // Mostrar el modal de edición
        })
        .catch(error => {
            console.error("Error al obtener los datos del historial:", error);
            alert("Ocurrió un error al obtener los datos del historial: " + error.message);
        });
}

// Función para eliminar un historial
function eliminarHistorial(id) {
    if (confirm("¿Estás seguro de que deseas eliminar este historial?")) {
        fetch("../controllers/HistorialMedicoController.php?action=eliminar", {
            method: "POST",
            body: new URLSearchParams({ id_historial: id })
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Error al eliminar el historial');
            }
            return response.json();
        })
        .then(data => {
            if (data.result === "ok") {
                alert("Historial eliminado con éxito");
                listarHistoriales(); // Actualiza la lista de historiales
            } else {
                alert("Error al eliminar el historial");
            }
        })
        .catch(error => {
            console.error("Error al eliminar el historial:", error);
            alert("Ocurrió un error al eliminar el historial: " + error.message);
        });
    }
}

// Función para limpiar el formulario
function limpiarFormulario() {
    document.getElementById('id_historial').value = '';
    document.getElementById('ID_CONSULTA').value = '';
    document.getElementById('FECHA').value = '';
    document.getElementById('OBSERVACIONES').value = '';
}
