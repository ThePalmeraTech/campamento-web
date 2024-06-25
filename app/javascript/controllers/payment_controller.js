import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["step", "fullPaymentMethod", "reservationPaymentMethod", "yappyInfo", "achInfo", "fullPaymentProof", "reservationPaymentProof", "paymentOption", "fileInput", "filePreview", "priceDisplay", "workshop"];

  connect() {
    this.updateStepVisibility();
    this.initializeProgressBars();
    console.log("Payment controller connected");
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
      AOS.refresh();
    }
  }

  currentStepIndex() {
    return this.stepTargets.findIndex(step => step.classList.contains('step-active'));
  }

  showPaymentInfo() {
    const fullMethod = this.fullPaymentMethodTarget.value;
    const reservationMethod = this.reservationPaymentMethodTarget.value;
    this.yappyInfoTarget.classList.toggle("d-none", fullMethod !== "yappy" && reservationMethod !== "yappy");
    this.achInfoTarget.classList.toggle("d-none", fullMethod !== "ach" && reservationMethod !== "ach");
    this.updateProofVisibility(this.paymentOptionTarget.value);
  }

  showPaymentProof(event) {
    const option = event.target.value;
    const fullContainer = document.getElementById('fullPaymentMethodContainer');
    const reservationContainer = document.getElementById('reservationPaymentMethodContainer');

    if (option === "full") {
      fullContainer.classList.remove('d-none');
      reservationContainer.classList.add('d-none');
    } else {
      reservationContainer.classList.remove('d-none');
      fullContainer.classList.add('d-none');
    }

    this.updateProofVisibility(option);
  }

  updateProofVisibility(option) {
    this.fullPaymentProofTargets.forEach(element => element.classList.toggle("d-none", option !== "full"));
    this.reservationPaymentProofTargets.forEach(element => element.classList.toggle("d-none", option !== "reservation"));
  }

  uploadFile(event) {
    const input = event.target;
    const file = input.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = e => {
        const preview = this.filePreviewTarget;
        preview.src = e.target.result;
        preview.classList.remove('d-none');
      };
      reader.readAsDataURL(file);
    }
  }

  initializeProgressBars() {
    document.addEventListener("direct-upload:initialize", event => {
      const progressElement = event.target.parentNode.querySelector(".progress");
      progressElement.classList.remove('d-none');
    });

    document.addEventListener("direct-upload:progress", event => {
      const progressBar = event.target.parentNode.querySelector(".progress-bar");
      progressBar.style.width = `${event.detail.progress}%`;
      progressBar.setAttribute("aria-valuenow", event.detail.progress);
    });

    document.addEventListener("direct-upload:end", event => {
      const progressElement = event.target.parentNode.querySelector(".progress");
      setTimeout(() => progressElement.classList.add('d-none'), 1500);
    });
  }

  updatePrice(event) {
    const workshopId = this.workshopTarget.value;
    if (!workshopId) return;

    fetch(`/workshops/${workshopId}/per_student_price`)
      .then(response => response.json())
      .then(data => {
        // Asegúrate de que data.price realmente existe y es un número
        if (data && data.price) {
          const price = Number(data.price);
          this.priceDisplayTarget.textContent = price.toFixed(2); // Usa toFixed(2) si es necesario
        } else {
          console.error('Price data is missing or invalid');
        }
      })
      .catch(error => console.error("Failed to fetch price:", error));
  }

}
