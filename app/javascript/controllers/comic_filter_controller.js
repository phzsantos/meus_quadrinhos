import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["query", "item", "empty"]

  connect() {
    this.filter()
  }

  filter() {
    const tokens = this.normalize(this.queryTarget.value).split(" ").filter(Boolean)
    const searching = tokens.length > 0
    let visibleCount = 0

    this.itemTargets.forEach((item) => {
      const title = this.normalize(item.dataset.comicFilterTitle)
      const match = searching && tokens.every((token) => title.includes(token))
      item.hidden = !match
      if (match) visibleCount += 1
    })

    if (!this.hasEmptyTarget) return

    if (!searching) {
      this.emptyTarget.hidden = false
      this.emptyTarget.textContent = "Digite um título para buscar."
    } else if (visibleCount === 0) {
      this.emptyTarget.hidden = false
      this.emptyTarget.textContent = "Nenhum quadrinho encontrado."
    } else {
      this.emptyTarget.hidden = true
    }
  }

  normalize(value) {
    return value
      .toLowerCase()
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .replace(/[^a-z0-9]+/g, " ")
      .trim()
      .replace(/\s+/g, " ")
  }
}
