document.addEventListener("DOMContentLoaded", function() {
  const attackForm = document.getElementById("attack-form");
  const fleeForm = document.getElementById("flee-form");
  const monsterTurnForm = document.getElementById("monster-turn-form");

  const playerCharacter = document.getElementById("player-character");
  const monsterCharacter = document.getElementById("monster-character");

  const playerHealth = document.getElementById("player-health");
  const monsterHealth = document.getElementById("monster-health");

  // Attach animation classes to actions
  attackForm?.addEventListener("submit", function(e) {
    e.preventDefault(); // Prevent immediate form submission for animation
    playerCharacter.classList.add("attack");
    setTimeout(() => {
      this.submit(); // Submit the form after animation finishes
    }, 300); // Match animation duration
  });

  monsterTurnForm?.addEventListener("submit", function(e) {
    e.preventDefault(); // Prevent immediate form submission for animation
    monsterCharacter.classList.add("attack");
    setTimeout(() => {
      this.submit();
    }, 300); // Monster attacks after animation
  });

  // Simulate damage received
  const displayDamageFeedback = (characterElement) => {
    characterElement.classList.add("damage");
    setTimeout(() => {
      characterElement.classList.remove("damage");
    }, 500); // Flash duration
  };

  // Hook into battle messages or health updates
  // Example: Flash red when damage occurs
  const battleMessage = document.getElementById("battle-message");
  if (battleMessage && battleMessage.textContent.includes("attacks")) {
    if (battleMessage.textContent.includes("You attack")) {
      displayDamageFeedback(monsterCharacter);
    } else if (battleMessage.textContent.includes("attacks you")) {
      displayDamageFeedback(playerCharacter);
    }
  }

  // Optional: Update health bars or text smoothly
  const smoothHealthUpdate = (element, newHealth) => {
    element.style.width = newHealth + "%"; // Assuming you have a health bar element
  };
});
