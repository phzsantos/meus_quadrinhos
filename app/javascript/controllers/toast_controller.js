import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    message: String,
    type: String
  }

  connect() {
    if (!this.messageValue) return

    Toastify({
      text: this.messageValue,
      duration: 4500,
      gravity: "top",
      position: "center",
      style: {
        background: this.backgroundColor(),
        borderRadius: "0.375rem",
      }
    }).showToast()
    
    this.element.remove()
  }

  backgroundColor() {
    switch (this.typeValue) {
      case "alert":
        return "red"
      case "notice":
      default:
        return "green"
    }
  }
}
