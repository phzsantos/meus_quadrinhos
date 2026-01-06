import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  remove() {
    const destroyInput = this.element.querySelector(
      'input[name*="[_destroy]"]'
    )

    destroyInput.value = "1"
    this.element.style.display = "none"
  }
}
