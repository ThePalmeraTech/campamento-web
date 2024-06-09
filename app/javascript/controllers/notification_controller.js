// app/javascript/controllers/notification_controller.js
import { Controller } from "@hotwired/stimulus";
import Swal from 'sweetalert2';

export default class extends Controller {
  static targets = ["notice", "alert"];

  connect() {
    this.showNotice();
    this.showAlert();
  }

  showNotice() {
    if (this.hasNoticeTarget && this.noticeTarget.textContent.trim() !== '') {
      Swal.fire({
        icon: 'success',
        title: 'OK!',
        text: this.noticeTarget.textContent,
        timer: 5000,
        timerProgressBar: true,
        showConfirmButton: false
      });
      this.noticeTarget.classList.add("d-none"); // Esconde el elemento HTML
    }
  }

  showAlert() {
    if (this.hasAlertTarget && this.alertTarget.textContent.trim() !== '') {
      Swal.fire({
        icon: 'error',
        title: 'Oops...',
        text: this.alertTarget.textContent,
        timer: 5000,
        timerProgressBar: true,
        showConfirmButton: false
      });
      this.alertTarget.classList.add("d-none"); // Esconde el elemento HTML
    }
  }
}
