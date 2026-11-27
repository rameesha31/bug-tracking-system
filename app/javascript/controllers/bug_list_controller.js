import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="bug-list"
export default class extends Controller {
  connect() {
    console.log("Show list");
  }
  search() {
    clearTimeout(this.timeout);

    this.timeout = setTimeout(() => {
      this.element.requestSubmit();
    }, 800);
    // console.log("request sent");

    // this.element.requestSubmit();
  }

  filter() {
    this.element.requestSubmit();
  }
  clear() {
    this.element.querySelectorAll("input, select").forEach((field) => {
      if (field.name === "sort") {
        field.value = "newest";
      } else {
        field.value = "";
      }
    });

    this.element.requestSubmit();
  }
}
