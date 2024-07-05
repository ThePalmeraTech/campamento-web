// app/javascript/controllers/payment_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "step", "nextButton", "requiredField", "emailField", "passwordField",
    "passwordConfirmationField", "passwordRequirements", "passwordLength",
    "passwordUppercase", "passwordSpecial", "passwordNumber", "emailError",
    "passwordError", "paymentOption", "paymentMethod", "fileInput",
    "fullPaymentMethod", "reservationPaymentMethod", "yappyInfo", "achInfo",
    "fullPaymentProof", "reservationPaymentProof", "filePreview", "fullPaymentPreview", "reservationPaymentPreview",
    "emailValidationMessage"
  ];

  connect() {
    this.updateStepVisibility();
    this.initializeProgressBars();
    this.validateStep();
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
      this.validateStep();
      AOS.refresh();
    }
  }

  previousStep() {
    const currentStepIndex = this.currentStepIndex();
    const previousStep = this.stepTargets[currentStepIndex - 1];
    if (previousStep) {
      this.stepTargets[currentStepIndex].classList.remove('step-active');
      previousStep.classList.add('step-active');
      this.validateStep();
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
    this.fullPaymentProofTarget.classList.toggle('d-none', option !== "full");
    this.reservationPaymentProofTarget.classList.toggle('d-none', option !== "reservation");
  }

  uploadFile(event) {
    const input = event.target;
    const file = input.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = e => {
        const preview = (input.name.includes("full_payment_proof")) ? this.fullPaymentPreviewTarget : this.reservationPaymentPreviewTarget;
        preview.src = e.target.result;
        preview.classList.remove('d-none');
      };
      reader.readAsDataURL(file);
    }
    this.validateStep();
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
    const emailValue = emailField.value.trim();
    const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const emailError = this.emailErrorTarget;
    const validationMessage = this.emailValidationMessageTarget;

    if (emailValue === "") {
      emailError.textContent = "";
      validationMessage.textContent = "";
      validationMessage.classList.remove("text-success", "text-danger");
      return;
    }

    if (emailPattern.test(emailValue)) {
      emailField.setCustomValidity("");
      emailError.textContent = "";
      this.checkEmailUniqueness(emailValue);
    } else {
      emailField.setCustomValidity("Por favor, ingrese un correo electrónico válido.");
      emailError.textContent = "Por favor, ingrese un correo electrónico válido.";
      validationMessage.textContent = "";
      validationMessage.classList.remove("text-success", "text-danger");
    }
    this.validateStep();
  }

  checkEmailUniqueness(email) {
    const validationMessage = this.emailValidationMessageTarget;
    validationMessage.textContent = "Verificando...";
    validationMessage.classList.remove("text-success", "text-danger");

    fetch(`/users/check_email?email=${encodeURIComponent(email)}`, {
      method: 'GET',
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Accept': 'application/json'
      }
    })
    
    .then(response => {
      if (!response.ok) {
        console.error('Response status:', response.status);
        console.error('Response status text:', response.statusText);
        return response.text().then(text => {
          throw new Error(`HTTP error! status: ${response.status}, body: ${text}`);
        });
      }
      return response.json();
    })
    .then(data => {
      if (data.unique) {
        validationMessage.textContent = "Email disponible";
        validationMessage.classList.add("text-success");
        validationMessage.classList.remove("text-danger");
      } else {
        validationMessage.textContent = "Email ya está en uso";
        validationMessage.classList.add("text-danger");
        validationMessage.classList.remove("text-success");
      }
    })
    .catch(error => {
      console.error('Error completo:', error);
      validationMessage.textContent = "Error al verificar el email";
      validationMessage.classList.add("text-danger");
      validationMessage.classList.remove("text-success");
    });
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
