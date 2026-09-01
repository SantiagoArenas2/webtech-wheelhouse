document.addEventListener("DOMContentLoaded", () => {
    
   
    const datosColeccion = [
        { id: 1, titulo: "The C++ programming language", categoria: "Programming", type: "Book" },
        { id: 2, titulo: "Roma Victoriosa - Javier Negrete", categoria: "History", type: "Book" },
        { id: 3, titulo: "Modern Game development in C with raylib", categoria: "Programming", type: "Book" },
        { id: 4, titulo: "Administración de Linux Ubuntu", categoria: "System", type: "Documentation" },
        { id: 5, titulo: "Rocky", categoria: "Entertainment", type: "Movie" },
        { id: 6, titulo: "Cinema Paradiso", categoria: "Entertainment", type: "Movie" }
    ];

    const contenedorColeccion = document.getElementById("lista-coleccion");
    const mensajeVacio = document.getElementById("coleccion-vacia");

   
    function crearNodoItem(item) {
        const li = document.createElement("li");
        li.classList.add("item-coleccion");
        li.dataset.id = item.id; 

        const h4 = document.createElement("h4");
        h4.textContent = item.titulo;

        const spanCategoria = document.createElement("span");
        spanCategoria.classList.add("etiqueta");
        spanCategoria.textContent = item.categoria;

        const pType = document.createElement("p");
        pType.textContent = `Type: ${item.type}`;

        const btnEliminar = document.createElement("button");
        btnEliminar.classList.add("btn-eliminar");
        btnEliminar.textContent = "Delete"; 

        li.appendChild(h4);
        li.appendChild(spanCategoria);
        li.appendChild(pType);
        li.appendChild(btnEliminar);

        return li;
    }

    function renderizarColeccion(datos) {
        contenedorColeccion.innerHTML = ""; 
        
        if (datos.length === 0) {
            mensajeVacio.style.display = "block";
        } else {
            mensajeVacio.style.display = "none";
            datos.forEach(item => {
                const nodo = crearNodoItem(item);
                contenedorColeccion.appendChild(nodo);
            });
        }
    }

    
    renderizarColeccion(datosColeccion);

    
    
    const inputFiltro = document.getElementById("filtro-coleccion");

    inputFiltro.addEventListener("input", (e) => {
        const textoBusqueda = e.target.value.toLowerCase();
        const datosFiltrados = datosColeccion.filter(item => 
            item.titulo.toLowerCase().includes(textoBusqueda) || 
            item.categoria.toLowerCase().includes(textoBusqueda)
        );
        renderizarColeccion(datosFiltrados);
    });


    const formAgregar = document.getElementById("form-agregar");

    formAgregar.addEventListener("submit", (e) => {
        e.preventDefault();
        
        const nuevoTitulo = document.getElementById("nuevo-titulo").value;
        const nuevaCategoria = document.getElementById("nueva-categoria").value;
        
        const nuevoItem = {
            id: Date.now(), 
            titulo: nuevoTitulo,
            categoria: nuevaCategoria,
            type: "New Resource" 
        };


        datosColeccion.push(nuevoItem);
        inputFiltro.dispatchEvent(new Event('input'));
        
        formAgregar.reset();
    });

    
    contenedorColeccion.addEventListener("click", (e) => {
        if (e.target.classList.contains("btn-eliminar")) {
            const itemLi = e.target.closest("li");
            const idItem = parseInt(itemLi.dataset.id);
            
            
            const index = datosColeccion.findIndex(i => i.id === idItem);
            if (index > -1) {
                datosColeccion.splice(index, 1);
            }
            
            
            inputFiltro.dispatchEvent(new Event('input'));
        }
    });

    
    const formContacto = document.getElementById("formulario-contacto");
    const mensajeExito = document.getElementById("mensaje-exito");

    function mostrarError(input, idError, mensaje) {
        const elementoError = document.getElementById(idError);
        elementoError.textContent = mensaje;
        elementoError.classList.add("visible");
        input.setAttribute("aria-invalid", "true");
    }

    function ocultarError(input, idError) {
        const elementoError = document.getElementById(idError);
        elementoError.textContent = "";
        elementoError.classList.remove("visible");
        input.removeAttribute("aria-invalid");
    }

    formContacto.addEventListener("submit", (e) => {
        e.preventDefault();
        let formularioValido = true;

        
        const inputNombre = document.getElementById("nombre");
        if (inputNombre.value.trim() === "") {
            mostrarError(inputNombre, "error-name", "Please enter your name.");
            formularioValido = false;
        } else {
            ocultarError(inputNombre, "error-name");
        }

        const inputEmail = document.getElementById("email");
        const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!regexEmail.test(inputEmail.value)) {
            mostrarError(inputEmail, "error-email", "Please enter a valid email.");
            formularioValido = false;
        } else {
            ocultarError(inputEmail, "error-email");
        }

        
        const inputMensaje = document.getElementById("mensaje");
        if (inputMensaje.value.trim().length < 10) {
            mostrarError(inputMensaje, "error-message", "The message must have more than 10 characters");
            formularioValido = false;
        } else {
            ocultarError(inputMensaje, "error-message");
        }

        if (formularioValido) {
            mensajeExito.style.display = "block";
            formContacto.reset();
            setTimeout(() => {
                mensajeExito.style.display = "none";
            }, 3000);
        }
    });

    
    formContacto.querySelectorAll("input, textarea").forEach(input => {
        input.addEventListener("input", (e) => {
            const idError = `error-${e.target.id}`;
            ocultarError(e.target, idError);
        });
    });

    
    const btnToggle = document.getElementById("theme-toggle");
    
    btnToggle.addEventListener("click", () => {
        const esOscuro = document.body.classList.toggle("dark-theme");
        btnToggle.setAttribute("aria-pressed", esOscuro);
    });
});