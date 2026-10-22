// clean-dashboard-v1 — template interaction glue (drawer, error states, confirm)
(function () {
  "use strict";

  // mobile: sidebar collapses to top drawer (manifest breakpoint rule)
  var toggle = document.getElementById("menu-toggle");
  var sidebar = document.getElementById("sidebar");
  if (toggle && sidebar) {
    toggle.addEventListener("click", function () {
      var open = sidebar.classList.toggle("open");
      toggle.setAttribute("aria-expanded", open ? "true" : "false");
    });
  }

  // state_error: dismiss + retry (component spec)
  var banner = document.getElementById("error-banner");
  var retry = document.getElementById("err-retry");
  var dismiss = document.getElementById("err-dismiss");
  if (dismiss && banner) dismiss.addEventListener("click", function () { banner.hidden = true; });
  if (retry && banner) retry.addEventListener("click", function () {
    banner.hidden = true;
    var demo = document.getElementById("loading-demo");
    if (demo) { demo.hidden = false; setTimeout(function () { demo.hidden = true; }, 1500); }
  });
  if (document.getElementById("demo-reload") && banner) {
    document.getElementById("demo-reload").addEventListener("click", function () {
      banner.hidden = false; // demo: simulate a failed refresh
    });
  }

  // form_input + inline validation (no console errors, no network)
  var form = document.getElementById("invite-form");
  var msg = document.getElementById("invite-msg");
  if (form && msg) {
    form.addEventListener("submit", function (e) {
      e.preventDefault();
      var email = form.elements["email"];
      var ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test((email.value || "").trim());
      msg.style.color = ok ? "var(--color_success)" : "var(--color_danger)";
      msg.textContent = ok ? "Invite queued locally (demo: nothing sent)." : "Enter a valid work email.";
      if (!ok) email.focus();
    });
  }

  // usability rule: destructive actions require confirmation
  var danger = document.getElementById("archive-danger");
  if (danger) danger.addEventListener("click", function () {
    if (window.confirm("Archive all failing projects? This cannot be undone.")) {
      danger.textContent = "Archived (demo)";
    }
  });
})();
