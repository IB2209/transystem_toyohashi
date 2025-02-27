// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "@rails/actioncable"
import "@hotwired/turbo"
import Rails from "@rails/ujs"
Rails.start()
import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus";

const application = Application.start();
const context = require.context("./controllers", true, /\.js$/);
application.load(definitionsFromContext(context));

document.addEventListener("DOMContentLoaded", () => {
  initResponsiblePersonSelection();
  initMenuState();
  initButtonToggle();
  initTabs();
});

// 「その他」の選択肢の処理
function initResponsiblePersonSelection() {
  const otherRadio = document.getElementById("responsible_person_other");
  const otherInput = document.querySelector(".optional-person");

  if (otherRadio && otherInput) {
    otherInput.disabled = !otherRadio.checked;
    document.querySelectorAll("[name='schedule[responsible_person]']").forEach((radio) => {
      radio.addEventListener("change", () => {
        otherInput.disabled = !otherRadio.checked;
        if (!otherRadio.checked) {
          otherInput.value = "";
        }
      });
    });
  }
}

// メニューの開閉状態の処理
function initMenuState() {
  const menuItems = document.querySelectorAll(".menu-item > a");
  restoreMenuState();

  menuItems.forEach(item => {
    item.addEventListener("click", function (event) {
      event.preventDefault();
      let parent = this.parentElement;
      let dropdown = parent.querySelector(".dropdown");
      if (dropdown) {
        parent.classList.toggle("open");
        saveMenuState();
      }
    });
  });

  function saveMenuState() {
    const openMenus = [];
    document.querySelectorAll(".menu-item.open").forEach(item => {
      openMenus.push(item.dataset.menu);
    });
    localStorage.setItem("sidebarMenuState", JSON.stringify(openMenus));
  }

  function restoreMenuState() {
    const storedMenus = JSON.parse(localStorage.getItem("sidebarMenuState"));
    if (storedMenus) {
      storedMenus.forEach(menu => {
        const item = document.querySelector(`[data-menu="${menu}"]`);
        if (item) item.classList.add("open");
      });
    }
  }
}

// ボタンのトグル処理
function initButtonToggle() {
  document.querySelectorAll(".btn-toggle").forEach(button => {
    button.addEventListener("click", (event) => {
      event.preventDefault();
      const url = button.getAttribute("data-url");
      fetch(url, {
        method: "PATCH",
        headers: {
          "X-Requested-With": "XMLHttpRequest",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
        }
      })
      .then(response => response.json())
      .then(data => {
        const buttonToUpdate = document.querySelector(`[data-url='${url}']`);
        if (buttonToUpdate) {
          buttonToUpdate.textContent = data.new_status ? "済" : "未";
          buttonToUpdate.classList.toggle("btn-success", data.new_status);
          buttonToUpdate.classList.toggle("btn-danger", !data.new_status);
        }
      })
      .catch(error => console.error("Error:", error));
    });
  });
}

// タブの切り替え処理
function initTabs() {
  const tabLinks = document.querySelectorAll(".tab-link");
  const tabPanes = document.querySelectorAll(".tab-pane");

  tabLinks.forEach(link => {
    link.addEventListener("click", () => {
      tabLinks.forEach(tab => tab.classList.remove("active"));
      tabPanes.forEach(pane => pane.classList.remove("active"));
      link.classList.add("active");
      const targetTab = document.getElementById(link.dataset.tab);
      if (targetTab) targetTab.classList.add("active");
    });
  });
}
