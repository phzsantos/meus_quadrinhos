import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    type: String,
    labels: Array,
    data: Array,
    dataSecondary: Array,
    labelPrimary: String,
    labelSecondary: String,
    xTitle: String,
    yTitle: String
  }

  connect() {
    if (this.chart) return

    window.Chart.defaults.font.family = "'Patrick Hand', cursive"
    window.Chart.defaults.font.size = 20

    if (window.ChartDataLabels) {
      window.Chart.register(window.ChartDataLabels)
    }

    const hasComparison = this.hasDataSecondaryValue && this.dataSecondaryValue.length > 0

    this.chart = new window.Chart(this.element, {
      type: this.typeValue,
      data: {
        labels: this.labelsValue,
        datasets: hasComparison ? this.comparisonDatasets() : [{
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
          legend: {
            display: hasComparison,
            onClick: null,
            labels: {
              color: "#000000",
              font: {
                family: "'Patrick Hand', cursive",
                size: 18
              }
            }
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                const value = context.parsed.y
                if (context.dataset.label) {
                  return `${context.dataset.label}: ${value}`
                }
                return value
              }
            }
          },
          datalabels: {
            color: "#FFFE01",
            anchor: "center",
            align: "center",
            formatter: (value) => value || null,
            font: {
              family: "'Bangers'"
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

  comparisonDatasets() {
    return [
      {
        label: this.labelPrimaryValue,
        data: this.dataValue,
        backgroundColor: "#000000",
        borderColor: "#000000",
        borderWidth: 1,
        categoryPercentage: 1,
        barPercentage: 0.98
      },
      {
        label: this.labelSecondaryValue,
        data: this.dataSecondaryValue,
        backgroundColor: "#555555",
        borderColor: "#555555",
        borderWidth: 1,
        categoryPercentage: 1,
        barPercentage: 0.98
      }
    ]
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy()
      this.chart = null
    }
  }
}
