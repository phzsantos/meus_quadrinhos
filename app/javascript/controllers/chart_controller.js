import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    type: String,
    labels: Array,
    data: Array,
    xTitle: String,
    yTitle: String
  }

  connect() {
    if (this.chart) return

    this.chart = new window.Chart(this.element, {
      type: this.typeValue,
      data: {
        labels: this.labelsValue,
        datasets: [{
          data: this.dataValue,
          backgroundColor: "#000000",
          borderColor: "#000000",
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: {
              label: function(context) {
                return context.parsed.y
              }
            }
          }
        },
        scales: {
          x: {
            title: {
              display: true,
              text: this.xTitleValue,
              color: "#000000"
            },
            ticks: { color: "#000000" },
            grid: { color: "#000000" }
          },
          y: {
            beginAtZero: true,
            ticks: {
              stepSize: 1,
              callback: (value) => value,
              color: "#000000"
            },
            title: {
              display: true,
              text: this.yTitleValue,
              color: "#000000"
            },
            grid: { color: "#000000" }
          }
        }
      }
    })
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy()
      this.chart = null
    }
  }
}
