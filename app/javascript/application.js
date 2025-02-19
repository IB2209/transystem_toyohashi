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

