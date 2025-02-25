// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@rails/actioncable";
import Rails from "@rails/ujs";
Rails.start();


//= require rails-ujs



document.addEventListener("DOMContentLoaded", () => {
  const otherRadio = document.getElementById("responsible_person_other");
  const otherInput = document.querySelector(".optional-person");

  if (otherRadio && otherInput) {
    // 初期状態: その他が選択されていない場合は無効化
    otherInput.disabled = !otherRadio.checked;

    // ラジオボタンの変更イベントを監視
    document.querySelectorAll("[name='schedule[responsible_person]']").forEach((radio) => {
      radio.addEventListener("change", () => {
        otherInput.disabled = !otherRadio.checked;
        if (!otherRadio.checked) {
          otherInput.value = ""; // その他以外を選択した場合、入力をクリア
        }
      });
    });
  }
});

document.addEventListener("DOMContentLoaded", function () {
  const menuItems = document.querySelectorAll(".menu-item > a");

  // ページロード時にlocalStorageから状態を復元
  restoreMenuState();

  menuItems.forEach(item => {
      item.addEventListener("click", function (event) {
          event.preventDefault(); // Railsのリンク遷移を防ぐ

          let parent = this.parentElement;
          let dropdown = parent.querySelector(".dropdown");

          if (dropdown) {
              // メニューの開閉状態をトグル
              if (parent.classList.contains("open")) {
                  parent.classList.remove("open");
              } else {
                  parent.classList.add("open");
              }
              saveMenuState(); // 状態を保存
          }
      });
  });

  // 開いているメニューの状態をlocalStorageに保存
  function saveMenuState() {
      const openMenus = [];
      document.querySelectorAll(".menu-item.open").forEach(item => {
          openMenus.push(item.dataset.menu); // 各メニューにdata-menuを付与する
      });
      localStorage.setItem("sidebarMenuState", JSON.stringify(openMenus));
  }

  // ページリロード時にlocalStorageから開いているメニューを復元
  function restoreMenuState() {
      const storedMenus = JSON.parse(localStorage.getItem("sidebarMenuState"));
      if (storedMenus) {
          storedMenus.forEach(menu => {
              const item = document.querySelector(`[data-menu="${menu}"]`);
              if (item) {
                  item.classList.add("open");
              }
          });
      }
  }
});
document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".btn-toggle").forEach(button => {
        button.addEventListener("click", (event) => {
            event.preventDefault(); // ページ遷移を防ぐ
            
            const url = button.getAttribute("data-url"); // 各ボタンのURLを取得
            
            fetch(url, {
                method: "PATCH",
                headers: {
                    "X-Requested-With": "XMLHttpRequest",
                    "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
                }
            })
            .then(response => response.json())
            .then(data => {
                // 更新するボタンを明確に識別
                const buttonToUpdate = document.querySelector(`[data-url='${url}']`);
                
                if (buttonToUpdate) {
                    // ステータスを更新
                    buttonToUpdate.textContent = data.new_status ? "済" : "未";
                    buttonToUpdate.classList.toggle("btn-success", data.new_status);
                    buttonToUpdate.classList.toggle("btn-danger", !data.new_status);
                }
            })
            .catch(error => console.error("Error:", error));
        });
    });
});

document.addEventListener("DOMContentLoaded", () => {
    const tabLinks = document.querySelectorAll(".tab-link");
    const tabPanes = document.querySelectorAll(".tab-pane");

    tabLinks.forEach(link => {
        link.addEventListener("click", () => {
            // すべてのタブの "active" クラスを削除
            tabLinks.forEach(tab => tab.classList.remove("active"));
            tabPanes.forEach(pane => pane.classList.remove("active"));

            // クリックしたタブを "active" にする
            link.classList.add("active");
            const targetTab = document.getElementById(link.dataset.tab);
            if (targetTab) {
                targetTab.classList.add("active");
            }
        });
    });
});

