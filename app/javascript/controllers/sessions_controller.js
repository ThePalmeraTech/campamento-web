import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sessionsContainer", "dayCountInput"]

  connect() {
    console.log("Sessions controller connected")
    this.updateSessions()
    this.dayCountInputTarget.addEventListener('change', this.updateSessions.bind(this))
  }

  updateSessions() {
    console.log("Updating sessions")
    const dayCount = parseInt(this.dayCountInputTarget.value) || 0
    this.sessionsContainerTarget.innerHTML = ''

    for (let i = 0; i < dayCount; i++) {
      this.sessionsContainerTarget.insertAdjacentHTML('beforeend', this.newSessionFields(i))
    }
  }

  newSessionFields(index) {
    return `
      <div class="border rounded p-3 mb-3">
        <div class="form-group mb-3">
          <label class="form-label">Session Date ${index + 1}</label>
          <input type="date" class="form-control" name="classroom[class_sessions_attributes][${index}][session_date]">
        </div>
        <div class="row">
          <div class="col">
            <div class="form-group">
              <label class="form-label">Start Time</label>
              <input type="time" class="form-control" name="classroom[class_sessions_attributes][${index}][start_time]">
            </div>
          </div>
          <div class="col">
            <div class="form-group">
              <label class="form-label">End Time</label>
              <input type="time" class="form-control" name="classroom[class_sessions_attributes][${index}][end_time]">
            </div>
          </div>
        </div>
        <button type="button" class="btn btn-danger mt-3" data-action="click->sessions#remove" data-sessions-target="removeLink">Remove session</button>
      </div>
    `
  }

  add(event) {
    event.preventDefault()
    const index = this.sessionsContainerTarget.children.length
    this.sessionsContainerTarget.insertAdjacentHTML('beforeend', this.newSessionFields(index))
  }

  remove(event) {
    event.preventDefault()
    event.target.closest('.border').remove()
  }
}
