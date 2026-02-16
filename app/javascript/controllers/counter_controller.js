import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    value: Number
  }

  connect() {
    this.startAnimation()
  }

  startAnimation() {
    const end = Math.max(0, this.valueValue || 0)
    const duration = 700
    const startTime = performance.now()

    const animate = (currentTime) => {
      const elapsed = currentTime - startTime
      const progress = Math.min(Math.max(elapsed / duration, 0), 1)

      const current = Math.max(0, Math.floor(progress * end))
      this.element.textContent = current

      if (progress < 1) {
        requestAnimationFrame(animate)
      }
    }

    requestAnimationFrame(animate)
  }
}
