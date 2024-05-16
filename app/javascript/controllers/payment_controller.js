// app/javascript/controllers/payment_controller.js

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["step1", "step2", "paymentMethod", "yappyInfo", "achInfo", "fullPaymentProof", "reservationPaymentProof", "paymentOption"];

  connect() {
    console.log("Payment controller connected");
  }

  showPaymentInfo() {
    const method = this.paymentMethodTarget.value;
    this.hideAllPaymentInfo(); // Oculta toda la información antes de mostrar la nueva
    if (method === "yappy") {
      this.yappyInfoTarget.classList.remove("d-none");
    } else if (method === "ach") {
      this.achInfoTarget.classList.remove("d-none");
    }
  }

  showPaymentProof() {
    const option = this.paymentOptionTarget.value;
    if (option === "full") {
      this.fullPaymentProofTarget.classList.remove("d-none");
      this.reservationPaymentProofTarget.classList.add("d-none");
    } else if (option === "reservation") {
      this.reservationPaymentProofTarget.classList.remove("d-none");
      this.fullPaymentProofTarget.classList.add("d-none");
    }
  }

  hideAllPaymentInfo() {
    this.yappyInfoTarget.classList.add("d-none");
    this.achInfoTarget.classList.add("d-none");
    this.fullPaymentProofTarget.classList.add("d-none");
    this.reservationPaymentProofTarget.classList.add("d-none");
  }

  nextStep(event) {
    event.preventDefault(); // Prevenir la acción por defecto si es necesario
    let currentStep = document.querySelector('.step-active');
    let nextStep = currentStep.nextElementSibling;

    console.log("Current step:", currentStep);
    console.log("Next step:", nextStep);

    if (currentStep && nextStep && nextStep.classList.contains('step')) {
      currentStep.classList.remove('step-active');
      currentStep.classList.add('step-completed');
      nextStep.classList.add('step-active');
    } else {
      console.error("No next step found or next step is not a 'step' class element.");
    }
}


  previousStep(event) {
    const currentStep = this.element.querySelector('.step-active');
    const previousStep = currentStep.previousElementSibling;

    if (previousStep && previousStep.classList.contains('step')) {
      currentStep.classList.remove('step-active');
      previousStep.classList.remove('step-completed');
      previousStep.classList.add('step-active');
    }
  }
}
