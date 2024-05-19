import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["entries"]

  connect() {
    this.currentPage = 0;
    this.refreshTotalPages();
    console.log("Pagination controller connected. Current page set to:", this.currentPage);
    console.log("Total pages from data on connect:", this.totalPages);
}

refreshTotalPages() {
    this.totalPages = parseInt(this.data.get("total-pages"));
    if (isNaN(this.totalPages)) {
        console.error("Total pages is not a number. Check data-total-pages attribute in HTML.");
    }
}

// Agregar una función para obtener el total de páginas de forma segura
getTotalPages() {
  const totalPages = parseInt(this.data.get("total-pages"), 10);
  if (isNaN(totalPages)) {
      console.error("Total pages is not a number. Check data-total-pages attribute in HTML.");
      return 0;  // Retorna 0 para prevenir errores de cálculo
  }
  return totalPages;
}

  // Carga la primera página
  firstPage() {
    console.log("Loading the first page...");
    this.currentPage = 0;
    console.log("currentPage set to:", this.currentPage);
    this.loadPage();
  }

  // Retrocede a la página anterior
  prevPage() {
    if (this.currentPage > 0) {
      console.log("Current page before decrement:", this.currentPage);
      this.currentPage -= 1;
      console.log("Current page after decrement:", this.currentPage);
      this.loadPage();
    }
  }

  // Avanza a la próxima página
  nextPage() {
    console.log("Current page before increment:", this.currentPage);
    this.currentPage += 1;
    console.log("Current page after increment:", this.currentPage);
    this.loadPage();
  }
// Cargar la última página utilizando la nueva función para obtener el total de páginas
lastPage() {
    console.log("Loading the last page...");
    const totalPages = this.getTotalPages();  // Obtiene el total de páginas de forma segura
    if (totalPages > 0) {
        this.currentPage = totalPages - 1;
        console.log("Last page index set to:", this.currentPage);
        this.loadPage();
    }
}

  // Función para cargar la página
  loadPage() {
    // Verificar si currentPage es un número válido
    if (isNaN(this.currentPage) || this.currentPage < 0) {
        console.error("currentPage is not valid:", this.currentPage);
        return;
    }

    const url = `/admin/dashboard?page=${this.currentPage}&format=js`;
    console.log("Fetching data from:", url);

    fetch(url, {
      method: 'GET',
      headers: {
        'Accept': 'text/javascript',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute("content")
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.text();
    })
    .then(html => {
      this.entriesTarget.innerHTML = html;
      this.updateButtons();
    })
    .catch(error => {
      console.error("Error loading coders:", error);
    });
  }

// Función para actualizar los botones de navegación
updateButtons() {
  const totalPages = parseInt(this.data.get("total-pages"), 10); // Asegúrate de que siempre se actualice el valor total de páginas.

  // Remueve la clase 'disabled' de todos los elementos primero
  document.querySelectorAll(".pagination .page-item").forEach(item => {
    item.classList.remove("disabled");
  });

  // Añade la clase 'disabled' a los botones correspondientes basado en la página actual
  if (this.currentPage <= 0) {
    document.querySelector("[data-action='pagination#firstPage']").closest('.page-item').classList.add("disabled");
    document.querySelector("[data-action='pagination#prevPage']").closest('.page-item').classList.add("disabled");
  }
  if (this.currentPage >= totalPages - 1) {
    document.querySelector("[data-action='pagination#nextPage']").closest('.page-item').classList.add("disabled");
    document.querySelector("[data-action='pagination#lastPage']").closest('.page-item').classList.add("disabled");
  }
}
}
