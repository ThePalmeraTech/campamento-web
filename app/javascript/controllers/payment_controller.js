import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["step", "fullPaymentMethod", "reservationPaymentMethod", "yappyInfo", "achInfo", "fullPaymentProof", "reservationPaymentProof", "paymentOption", "fileInput", "filePreview"];

  connect() {
    this.updateStepVisibility();
    this.initializeProgressBars();  // Inicializar barras de progreso para la carga directa de archivos.
    console.log("Payment controller connected");
  }

  // Actualiza la visibilidad de los pasos de pago en el formulario.
  updateStepVisibility() {
    this.stepTargets.forEach((step, index) => {
      step.classList.toggle('step-active', index === 0);  // Solo el primer paso es visible inicialmente.
    });
  }

  // Avanza al siguiente paso del formulario.
  nextStep() {
    const currentStepIndex = this.currentStepIndex();
    const nextStep = this.stepTargets[currentStepIndex + 1];
    if (nextStep) {
      this.stepTargets[currentStepIndex].classList.remove('step-active');
      nextStep.classList.add('step-active');
      // Refrescar AOS para que procese los elementos recién visibles
      AOS.refresh();
    }
  }

  // Retorna el índice del paso actualmente activo.
  currentStepIndex() {
    return this.stepTargets.findIndex(step => step.classList.contains('step-active'));
  }

  // Muestra información adicional basada en el método de pago seleccionado.
  showPaymentInfo() {
    const fullMethod = this.fullPaymentMethodTarget.value;
    const reservationMethod = this.reservationPaymentMethodTarget.value;
    this.yappyInfoTarget.classList.toggle("d-none", fullMethod !== "yappy" && reservationMethod !== "yappy");
    this.achInfoTarget.classList.toggle("d-none", fullMethod !== "ach" && reservationMethod !== "ach");

    // Mostrar las opciones de comprobante solo si se ha seleccionado un método de pago
    const paymentOption = this.paymentOptionTarget.value;
    if (method === "yappy" || method === "ach") {
      this.fullPaymentProofTargets.forEach((element) => {
        element.classList.toggle("d-none", paymentOption !== "full");
        AOS.refresh();

      });
      this.reservationPaymentProofTargets.forEach((element) => {
        element.classList.toggle("d-none", paymentOption !== "reservation");
        AOS.refresh();

      });
    }
  }

  // Ajusta showPaymentProof para manejar los diferentes contenedores de método de pago
  showPaymentProof(event) {
    const option = event.target.value;
    const fullContainer = document.getElementById('fullPaymentMethodContainer');
    const reservationContainer = document.getElementById('reservationPaymentMethodContainer');

    // Asegúrate de manejar la visibilidad basada en la opción seleccionada
    if (option === "full") {
      fullContainer.classList.remove('d-none');
      reservationContainer.classList.add('d-none');
    } else {
      reservationContainer.classList.remove('d-none');
      fullContainer.classList.add('d-none');
    }

    this.updateProofVisibility(option);
  }

  // Muestra el contenedor de comprobante de pago correspondiente a la opción seleccionada.
  updateProofVisibility(option) {
    this.fullPaymentProofTargets.forEach((element) => {
      element.classList.toggle("d-none", option !== "full");
      AOS.refresh();
    });
    this.reservationPaymentProofTargets.forEach((element) => {
      element.classList.toggle("d-none", option !== "reservation");
      AOS.refresh();
    });
  } // Extrae la lógica para actualizar la visibilidad de los comprobantes
   updateProofVisibility(option) {
    this.fullPaymentProofTargets.forEach((element) => {
      element.classList.toggle("d-none", option !== "full");
    });
    this.reservationPaymentProofTargets.forEach((element) => {
      element.classList.toggle("d-none", option !== "reservation");
    });
  }


  // Maneja la carga y vista previa de archivos subidos.
  uploadFile(event) {
    const input = event.target;
    const file = input.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        const preview = this.filePreviewTarget;
        preview.src = e.target.result;
        preview.classList.remove('d-none');
      };
      reader.readAsDataURL(file);
    }
  }

  // Inicializa la gestión de la barra de progreso para la carga directa de archivos.
  initializeProgressBars() {
    document.addEventListener('direct-upload:initialize', event => {
      const { target, detail } = event;
      const progressElement = target.parentNode.querySelector('.progress');
      progressElement.classList.remove('d-none');
    });

    document.addEventListener('direct-upload:progress', event => {
      const { target, detail } = event;
      const { id, progress } = detail;
      const progressBar = target.parentNode.querySelector('.progress-bar');
      progressBar.style.width = `${progress}%`;
      progressBar.setAttribute('aria-valuenow', progress);
    });

    document.addEventListener('direct-upload:end', event => {
      const { target, detail } = event;
      const progressElement = target.parentNode.querySelector('.progress');
      setTimeout(() => progressElement.classList.add('d-none'), 1500);  // Oculta la barra de progreso después de finalizar la carga.
    });
  }
}
