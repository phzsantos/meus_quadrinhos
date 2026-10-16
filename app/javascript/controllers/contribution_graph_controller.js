import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tooltip"]

  connect() {
    this.hide = this.hide.bind(this)
    window.addEventListener("scroll", this.hide, true)
  }

  disconnect() {
    window.removeEventListener("scroll", this.hide, true)
  }

  show(event) {
    const tip = this.tooltipTarget
    tip.innerHTML = event.params.text
    tip.classList.remove("hidden")

    const cell = event.currentTarget.getBoundingClientRect()
    const box = tip.getBoundingClientRect()
    const margin = 8
    let left = cell.left + (cell.width / 2) - (box.width / 2)
    left = Math.max(margin, Math.min(left, window.innerWidth - box.width - margin))

    let top = cell.top - box.height - margin
    if (top < margin) top = cell.bottom + margin

    tip.style.left = `${left}px`
    tip.style.top = `${top}px`
  }

  hide() {
    this.tooltipTarget.classList.add("hidden")
  }
}
