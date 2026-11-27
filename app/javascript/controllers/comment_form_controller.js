import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {}
  static targets = ["button", "spinner", "text", "input", "error"];

  showLoading() {
    this.buttonTarget.disabled = true;
    this.spinnerTarget.classList.remove("hidden");
    this.textTarget.textContent = "Adding...";
  }

  hideLoading() {
    this.buttonTarget.disabled = false;
    this.spinnerTarget.classList.add("hidden");
    this.textTarget.textContent = "Add Comment";
  }
  validate() {
    if (this.inputTarget.value.trim() === "") {
      this.errorTarget.classList.remove("hidden");
    } else {
      this.errorTarget.classList.add("hidden");
    }
  }
}
