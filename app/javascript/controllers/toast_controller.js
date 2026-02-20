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
      position: "right",
      style: {
        background: this.backgroundColor(),
        borderRadius: "0.375rem",
        fontFamily: "Patrick Hand, cursive",
        fontSize: "1.5rem",
        textShadow: "0 1px 2px rgba(0, 0, 0, 0.5)",
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
