import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    labels: Array,
    data: Array
  }

  static targets = ["chart"]

  connect() {
    try {
      this.initializeChart();
    } catch (error) {
      console.error("Error initializing chart:", error);
    }
  }

  initializeChart() {
    this.chartTargets.forEach(target => {
      const ctx = target.getContext('2d');
      const type = target.id === 'totalIncomeChart' ? 'line' : 'pie';
      const label = this.getLabel(target.id);

      try {
        new Chart(ctx, {
          type: type,
          data: {
            labels: this.labelsValue,
            datasets: [{
              label: label,
              data: this.dataValue,
              backgroundColor: [
                'rgba(255, 99, 132, 0.2)',
                'rgba(54, 162, 235, 0.2)',
                'rgba(255, 206, 86, 0.2)',
                'rgba(75, 192, 192, 0.2)',
                'rgba(153, 102, 255, 0.2)',
                'rgba(255, 159, 64, 0.2)'
              ],
              borderColor: [
                'rgba(255, 99, 132, 1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)',
                'rgba(255, 159, 64, 1)'
              ],
              borderWidth: 1
            }]
          },
          options: {
            scales: {
              y: {
                beginAtZero: true
              }
            }
          }
        });
      } catch (error) {
        console.error("Error creating chart:", error);
      }
    });
  }

  getLabel(chartId) {
    if (chartId === 'totalIncomeChart') {
      return 'Ingresos Totales';
    } else if (chartId === 'incomeByWorkshopChart') {
      return 'Ingresos por Talleres';
    } else if (chartId === 'incomeByClassroomChart') {
      return 'Ingresos por Aulas';
    } else {
      return '';
    }
  }
}
