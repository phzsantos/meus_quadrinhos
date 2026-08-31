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
    yTitle: String,
    indexAxis: { type: String, default: "x" }
  }

  connect() {
    this.renderChart()

    this.beforeCacheHandler = () => this.destroyChart()
    this.pageShowHandler = (event) => {
      if (event.persisted) this.renderChart()
    }

    document.addEventListener("turbo:before-cache", this.beforeCacheHandler)
    window.addEventListener("pageshow", this.pageShowHandler)
  }

  renderChart() {
    this.destroyChart()

    window.Chart.defaults.font.family = "'Patrick Hand', cursive"
    window.Chart.defaults.font.size = 20

    if (window.ChartDataLabels) {
      window.Chart.register(window.ChartDataLabels)
    }

    const hasComparison = this.hasDataSecondaryValue && this.dataSecondaryValue.length > 0
    const horizontal = this.indexAxisValue === "y"
    const valueAxis = horizontal ? "x" : "y"
    const categoryAxis = horizontal ? "y" : "x"

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
        indexAxis: this.indexAxisValue,
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
              label: (context) => {
                const value = context.raw
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
          [categoryAxis]: {
            title: {
              display: true,
              text: horizontal ? this.yTitleValue : this.xTitleValue,
              color: "#000000"
            },
            ticks: { color: "#000000" },
            grid: { color: "#000000" }
          },
          [valueAxis]: {
            beginAtZero: true,
            ticks: {
              stepSize: 1,
              callback: (value) => value,
              color: "#000000"
            },
            title: {
              display: true,
              text: horizontal ? this.xTitleValue : this.yTitleValue,
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
    document.removeEventListener("turbo:before-cache", this.beforeCacheHandler)
    window.removeEventListener("pageshow", this.pageShowHandler)
    this.destroyChart()
  }

  destroyChart() {
    if (this.chart) {
      this.chart.destroy()
      this.chart = null
    }
  }
}
