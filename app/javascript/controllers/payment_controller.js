import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "step", "nextButton", "requiredField", "emailField", "passwordField",
    "passwordConfirmationField", "passwordRequirements", "passwordLength",
    "passwordUppercase", "passwordSpecial", "passwordNumber", "emailError",
    "passwordError", "paymentOption", "paymentMethod", "fileInput",
    "fullPaymentMethod", "reservationPaymentMethod", "yappyInfo", "achInfo",
    "fullPaymentProof", "reservationPaymentProof", "filePreview", "fileProgress"
  ];

  connect() {
    this.updateStepVisibility();
    this.initializeProgressBars();
    this.validateStep(); // Validate step on initial load
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
      this.validateStep(); // Validate the new step
      AOS.refresh();
    }
  }

  previousStep() {
    const currentStepIndex = this.currentStepIndex();
    const previousStep = this.stepTargets[currentStepIndex - 1];
    if (previousStep) {
      this.stepTargets[currentStepIndex].classList.remove('step-active');
      previousStep.classList.add('step-active');
      this.validateStep(); // Validate the previous step
      AOS.refresh();
    }
  }

  currentStepIndex() {
    return this.stepTargets.findIndex(step => step.classList.contains('step-active'));
  }

  showPaymentInfo() {
    const paymentMethod = this.paymentMethodTarget.value;
    this.yappyInfoTarget.classList.toggle("d-none", paymentMethod !== "yappy");
    this.achInfoTarget.classList.toggle("d-none", paymentMethod !== "ach");
  }

  showPaymentProof(event) {
    const option = event.target.value;
    const fullContainer = this.fullPaymentProofTarget;
    const reservationContainer = this.reservationPaymentProofTarget;

    fullContainer.classList.toggle('d-none', option !== "full");
    reservationContainer.classList.toggle('d-none', option !== "reservation");

    this.updateProofVisibility(option);
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
    this.validateStep(); // Validate step when file is uploaded
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

  validateStep() {
    const currentStepIndex = this.currentStepIndex();
    const currentStep = this.stepTargets[currentStepIndex];
    const requiredFields = currentStep.querySelectorAll(".required-field");
    const allFilled = Array.from(requiredFields).every(field => field.value.trim() !== "" && field.validity.valid);
    const nextButton = currentStep.querySelector('[data-payment-target="nextButton"]');
    if (nextButton) {
      nextButton.disabled = !allFilled;
    }
  }

  validateEmail(event) {
    const emailField = event.target;
    const emailValue = emailField.value;
    const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const emailError = this.emailErrorTarget;
    if (emailPattern.test(emailValue)) {
      emailField.setCustomValidity("");
      emailError.textContent = "";
    } else {
      emailField.setCustomValidity("Por favor, ingrese un correo electrónico válido.");
      emailError.textContent = "Por favor, ingrese un correo electrónico válido.";
    }
    this.validateStep();
  }

  validatePassword(event) {
    const passwordField = event.target;
    const passwordValue = passwordField.value;
    const lengthRequirement = passwordValue.length >= 7;
    const uppercaseRequirement = /[A-Z]/.test(passwordValue);
    const specialCharacterRequirement = /[!@#$%^&*(),.?":{}|<>]/.test(passwordValue);
    const numberRequirement = /[0-9]/.test(passwordValue);

    this.updateRequirementIndicator(this.passwordLengthTarget, lengthRequirement);
    this.updateRequirementIndicator(this.passwordUppercaseTarget, uppercaseRequirement);
    this.updateRequirementIndicator(this.passwordSpecialTarget, specialCharacterRequirement);
    this.updateRequirementIndicator(this.passwordNumberTarget, numberRequirement);

    const allRequirementsMet = lengthRequirement && uppercaseRequirement && specialCharacterRequirement && numberRequirement;

    if (allRequirementsMet) {
      passwordField.setCustomValidity("");
      this.passwordErrorTarget.textContent = "";
    } else {
      passwordField.setCustomValidity("La contraseña no cumple con todos los requisitos.");
      this.passwordErrorTarget.textContent = "La contraseña no cumple con todos los requisitos.";
    }

    this.validateStep();
  }

  updateRequirementIndicator(element, isValid) {
    if (isValid) {
      element.classList.remove("text-danger");
      element.classList.add("text-success");
    } else {
      element.classList.remove("text-success");
      element.classList.add("text-danger");
    }
  }

  validatePasswordConfirmation(event) {
    const passwordField = this.passwordFieldTarget;
    const passwordConfirmationField = event.target;
    const passwordError = this.passwordErrorTarget;

    if (passwordField.value === passwordConfirmationField.value) {
      passwordConfirmationField.setCustomValidity("");
      passwordError.textContent = "";
    } else {
      passwordConfirmationField.setCustomValidity("Las contraseñas no coinciden.");
      passwordError.textContent = "Las contraseñas no coinciden.";
    }

    this.validateStep();
  }
}
