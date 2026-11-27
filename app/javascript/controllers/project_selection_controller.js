import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="project-selection"
export default class extends Controller {

  static targets = ["project", "developer", "form", "projectId"];

  async projectChanged() {
    const projectId = this.projectTarget.value;

    this.projectIdTarget.value = projectId;
    this.developerTarget.innerHTML =
      '<option value="">Select Developer</option>';
    if (!projectId) return;
    const url = `/projects/${projectId}/project_developers`;

    const response = await fetch(url, {
      headers: { Accept: "application/json" },
    });

    if (!response.ok) {
      console.error("Failed to load developers");
      return;
    }

    const developers = await response.json();
    developers.forEach((developer) => {
      const option = document.createElement("option");
      option.value = developer.id;
      option.textContent = developer.name;
      this.developerTarget.appendChild(option);
    });
    this.formTarget.classList.remove("hidden");
  }
}
