import Alpine from "alpinejs";

Alpine.store("darkMode", {
  on: false,

  toggle() {
    this.on = !this.on;
  },
});

window.Alpine = Alpine;
Alpine.start();
