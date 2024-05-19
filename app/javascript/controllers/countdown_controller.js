// app/javascript/controllers/countdown_controller.js
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["output"]
  static values = { time: String }

  connect() {
    this.updateTime()
    this.interval = setInterval(() => {
      this.updateTime()
    }, 1000)  // Actualiza cada segundo
  }

  disconnect() {
    clearInterval(this.interval)
  }

  updateTime() {
    const endTime = new Date(this.timeValue)
    const now = new Date()
    const distance = endTime - now

    if (distance < 0) {
      clearInterval(this.interval)
      this.outputTarget.innerText = "La sesión ha comenzado"
      return
    }

    let days = Math.floor(distance / (1000 * 60 * 60 * 24))
    let hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
    let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60))
    let seconds = Math.floor((distance % (1000 * 60)) / 1000)

    this.outputTarget.innerText = days + "d " + hours + "h "
      + minutes + "m " + seconds + "s "
  }
}
