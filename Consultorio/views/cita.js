document.addEventListener("DOMContentLoaded", function () {
    const formCita = document.getElementById("frm_cita");

    // Llenar los selectores al cargar la página
    cargarPacientes();
    cargarOdontologos();

    // Evento para el envío del formulario
    formCita.addEventListener("submit", function (event) {
        event.preventDefault();

        const formData = new FormData(formCita);
        const idCita = document.getElementById("id_cita").value;

        // Determina si es una edición o una creación
        const action = idCita ? 'updateCita' : 'addCita';

        fetch(`../controllers/cita.controller.php?action=${action}`, {
            method: "POST",
            body: formData
        })
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => { throw new Error(text); });
            }
            return response.json(); // Parsear la respuesta como JSON
        })
        .then(data => {
            console.log("Respuesta del servidor:", data);
            if (data.result === "ok") {
                alert(idCita ? "Cita actualizada con éxito" : "Cita guardada con éxito");
                $('#modalCita').modal('hide'); // Cierra el modal después de guardar
                limpiarFormulario(); // Limpia el formulario después de guardar
                listarCitas(); // Recarga la lista de citas
            } else {
                alert("Error al guardar cita: " + (data.message || "Error desconocido"));
            }
        })
        .catch(error => {
            location.reload();
        });
    });

    listarCitas();

    document.getElementById("nuevaCitaBtn").addEventListener("click", function () {
        limpiarFormulario();
        $('#modalCita').modal('show');
    });
});

// Función para llenar el selector de pacientes
function cargarPacientes() {
    return new Promise((resolve, reject) => {
        fetch("../controllers/cita.controller.php?action=getPacientes")
            .then(response => response.json())
            .then(data => {
                if (!Array.isArray(data)) throw new Error("Respuesta inesperada al cargar pacientes.");
                const selectPaciente = document.getElementById("id_paciente");
                selectPaciente.innerHTML = ""; // Limpiar el contenido actual
                data.forEach(paciente => {
                    const option = document.createElement("option");
                    option.value = paciente.ID_PACIENTE;
                    option.text = `${paciente.PRIMER_NOMBRE} ${paciente.APELLIDO_PATERNO}`;
                    selectPaciente.appendChild(option);
                });
                resolve(); // Resuelve la promesa después de llenar los pacientes
            })
            .catch(error => {
                console.error("Error al cargar pacientes:", error);
                reject(error); // Rechaza la promesa si hay un error
            });
    });
}

function cargarOdontologos() {
    return new Promise((resolve, reject) => {
        fetch("../controllers/cita.controller.php?action=getOdontologos")
            .then(response => response.json())
            .then(data => {
                if (!Array.isArray(data)) throw new Error("Respuesta inesperada al cargar odontólogos.");
                const selectOdontologo = document.getElementById("id_odontologo");
                selectOdontologo.innerHTML = ""; // Limpiar el contenido actual
                data.forEach(odontologo => {
                    const option = document.createElement("option");
                    option.value = odontologo.ID_ODONTOLOGO;
                    option.text = `${odontologo.NOMBRE} ${odontologo.APELLIDO}`;
                    selectOdontologo.appendChild(option);
                });
                resolve(); // Resuelve la promesa después de llenar los odontólogos
            })
            .catch(error => {
                console.error("Error al cargar odontólogos:", error);
                reject(error); // Rechaza la promesa si hay un error
            });
    });
}

// Función para limpiar el formulario
function limpiarFormulario() {
    document.getElementById('id_cita').value = ''; // Limpia el campo oculto ID
    document.getElementById('fecha').value = '';
    document.getElementById('hora').value = '';
    document.getElementById('id_paciente').value = '';
    document.getElementById('id_odontologo').value = '';
    document.getElementById('estado').value = '';
}

// Función para listar citas
function listarCitas() {
    fetch("../controllers/cita.controller.php?action=listar")
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => { throw new Error(text); });
            }
            return response.json();
        })
        .then(data => {
            if (!Array.isArray(data)) throw new Error("Respuesta inesperada al listar citas.");
            
            const cuerpoCitasPendientes = document.getElementById("cuerpoCitasPendientes");
            const cuerpoCitasFinalizadas = document.getElementById("cuerpoCitasFinalizadas");
            cuerpoCitasPendientes.innerHTML = ""; // Limpia el contenido anterior
            cuerpoCitasFinalizadas.innerHTML = ""; // Limpia el contenido anterior

            data.forEach((cita, index) => {
                const fila = document.createElement("tr");
                fila.innerHTML = `
                    <td>${index + 1}</td>
                    <td>${cita.FECHA}</td>
                    <td>${cita.HORA}</td>
                    <td>${cita.PACIENTE_NOMBRE} ${cita.PACIENTE_APELLIDO}</td>
                    <td>${cita.ODONTOLOGO_NOMBRE} ${cita.ODONTOLOGO_APELLIDO}</td>
                    <td>${cita.ESTADO}</td>
                    <td>
                        <button class="btn btn-warning btn-sm" onclick="editarCita(${cita.ID_CITA})">Editar</button>
                        <button class="btn btn-danger btn-sm" onclick="eliminarCita(${cita.ID_CITA})">Eliminar</button>
                        ${cita.ESTADO !== "Finalizado" ? `<button class="btn btn-success btn-sm" onclick="finalizarCita(${cita.ID_CITA})">Finalizar</button>` : ""}
                    </td>
                `;
                
                // Clasifica las citas en dos tablas según el estado
                if (cita.ESTADO === "Finalizado") {
                    cuerpoCitasFinalizadas.appendChild(fila);
                } else {
                    cuerpoCitasPendientes.appendChild(fila);
                }
            });
        })
        .catch(error => {
            console.error("Error al listar citas:", error);
            alert("Ocurrió un error al listar las citas: " + error.message);
        });
}

// Función para finalizar una cita
function finalizarCita(id) {
    if (confirm("¿Estás seguro de que deseas marcar esta cita como finalizada?")) {
        fetch("../controllers/cita.controller.php?action=finalizarCita", {
            method: "POST",
            body: new URLSearchParams({ id_cita: id })
        })
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => { throw new Error(text); });
            }
            return response.json();
        })
        .then(data => {
            if (data.result === "ok") {
                alert("Cita finalizada con éxito");
                listarCitas(); // Actualiza la lista de citas
            } else {
                alert("Error al finalizar la cita");
            }
        })
        .catch(error => {
            console.error("Error al finalizar la cita:", error);
            alert("Ocurrió un error al finalizar la cita: " + error.message);
        });
    }
}

// Función para editar una cita
function editarCita(id) {
    // Obtener los datos de la cita
    fetch("../controllers/cita.controller.php?action=listar&id=${id}")
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => { throw new Error(text); });
            }
            return response.json();
        })
        .then(citaData => {
            const cita = citaData[0];

            // Cargar los pacientes y odontólogos antes de asignar los valores
            Promise.all([cargarPacientes(), cargarOdontologos()])
                .then(() => {
                    // Asignar los valores del formulario
                    document.getElementById('id_cita').value = cita.ID_CITA;
                    document.getElementById('fecha').value = cita.FECHA;
                    document.getElementById('hora').value = cita.HORA;

                    // Seleccionar el paciente correcto
                    const selectPaciente = document.getElementById('id_paciente');
                    const pacienteOption = Array.from(selectPaciente.options).find(option => option.value == cita.ID_PACIENTE);
                    if (pacienteOption) pacienteOption.selected = true;

                    // Seleccionar el odontólogo correcto
                    const selectOdontologo = document.getElementById('id_odontologo');
                    const odontologoOption = Array.from(selectOdontologo.options).find(option => option.value == cita.ID_ODONTOLOGO);
                    if (odontologoOption) odontologoOption.selected = true;

                    document.getElementById('estado').value = cita.ESTADO;

                    // Mostrar el modal de edición
                    $('#modalCita').modal('show');
                })
                .catch(error => {
                    console.error("Error al cargar los datos de pacientes u odontólogos:", error);
                    alert("Ocurrió un error al cargar los datos de pacientes u odontólogos: " + error.message);
                });
        })
        .catch(error => {
            console.error("Error al obtener los datos de la cita:", error);
            alert("Ocurrió un error al obtener los datos de la cita: " + error.message);
        });
}

// Función para eliminar una cita
function eliminarCita(id) {
    if (confirm("¿Estás seguro de que deseas eliminar esta cita?")) {
        fetch("../controllers/cita.controller.php?action=deleteCita", {
            method: "POST",
            body: new URLSearchParams({ id_cita: id })
        })
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => { throw new Error(text); });
            }
            return response.json();
        })
        .then(data => {
            if (data.result === "ok") {
                alert("Cita eliminada con éxito");
                listarCitas(); // Actualiza la lista de citas
            } else {
                alert("Error al eliminar la cita");
            }
        })
        .catch(error => {
            console.error("Error al eliminar la cita:", error);
            alert("Ocurrió un error al eliminar la cita: " + error.message);
        });
    }
}
