// app/javascript/controllers/notification_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["notice", "alert"];

  connect() {
    this.showNotice();
    this.showAlert();
  }

  showNotice() {
    if (this.hasNoticeTarget) {
      this.noticeTarget.classList.remove("d-none");
      setTimeout(() => {
        this.noticeTarget.classList.add("d-none");
      }, 5000); // Ajusta el tiempo según necesidad
    }
  }

  showAlert() {
    if (this.hasAlertTarget) {
      this.alertTarget.classList.remove("d-none");
      setTimeout(() => {
        this.alertTarget.classList.add("d-none");
      }, 5000); // Ajusta el tiempo según necesidad
    }
  }
}
