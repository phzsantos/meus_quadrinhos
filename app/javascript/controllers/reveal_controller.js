import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.handleLoad = this.handleLoad.bind(this)
    document.addEventListener("turbo:load", this.handleLoad)
  }

  disconnect() {
    document.removeEventListener("turbo:load", this.handleLoad)
  }

  handleLoad() {
    this.animate()
  }

  animate() {
    this.element.style.opacity = 0
    this.element.style.transition = "none"

    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.element.style.transition = "opacity 1000ms ease-out"
        this.element.style.opacity = 1
      })
    })
  }
}
