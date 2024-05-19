import { Controller } from "@hotwired/stimulus";
//import Swal from "sweetalert";

export default class extends Controller {
  static targets = ["step", "paymentMethod", "yappyInfo", "achInfo", "fullPaymentProof", "reservationPaymentProof", "paymentOption", "fileInput", "filePreview"];

  connect() {
    this.updateStepVisibility();
    this.initializeProgressBars();
  }

  updateStepVisibility() {
    this.stepTargets.forEach((step, index) => {
      step.classList.toggle('step-active', index === 0);
    });
  }

  nextStep() {
    const currentStepIndex = this.currentStepIndex();
    const nextStep = this.stepTargets[currentStepIndex + 1];
    if (nextStep) {
      this.stepTargets[currentStepIndex].classList.remove('step-active');
      nextStep.classList.add('step-active');
    }
  }

  currentStepIndex() {
    return this.stepTargets.findIndex(step => step.classList.contains('step-active'));
  }

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

  showPaymentInfo() {
    const method = this.paymentMethodTarget.value;
    this.yappyInfoTarget.classList.toggle("d-none", method !== "yappy");
    this.achInfoTarget.classList.toggle("d-none", method !== "ach");
  }

  showPaymentProof() {
    const option = this.paymentOptionTarget.value;
    this.fullPaymentProofTarget.classList.toggle("d-none", option !== "full");
    this.reservationPaymentProofTarget.classList.toggle("d-none", option !== "reservation");
  }

  uploadFile(event) {
    console.log("uploadFile called"); // Diagnóstico para verificar que el método se llama
    const input = event.target;
    const file = input.files[0];
    if (file) {
      console.log(`File selected: ${file.name}`); // Diagnóstico para verificar que el archivo se ha seleccionado
      const reader = new FileReader();
      reader.onload = (e) => {
        const preview = this.filePreviewTarget;
        preview.src = e.target.result;
        preview.classList.remove('d-none');
        console.log("Preview should be visible now"); // Diagnóstico para verificar que la vista previa debería mostrarse
      };
      reader.readAsDataURL(file);
    } else {
      console.log("No file selected"); // Diagnóstico en caso de que no se seleccione ningún archivo
    }
}

initializeProgressBars() {
  document.addEventListener('direct-upload:initialize', event => {
    console.log("Direct upload initialized");
    const { target, detail } = event;
    const progressElement = target.parentNode.querySelector('.progress');
    progressElement.classList.remove('d-none');
  });

  document.addEventListener('direct-upload:progress', event => {
    console.log("Direct upload progress");
    const { target, detail } = event;
    const { id, progress } = detail;
    const progressBar = target.parentNode.querySelector('.progress-bar');
    progressBar.style.width = `${progress}%`;
    progressBar.setAttribute('aria-valuenow', progress);
  });

  document.addEventListener('direct-upload:end', event => {
    console.log("Direct upload ended");
    const { target, detail } = event;
    const progressElement = target.parentNode.querySelector('.progress');
    setTimeout(() => progressElement.classList.add('d-none'), 4500); // Ocultar después de 1.5 segundos
  });
}


}
