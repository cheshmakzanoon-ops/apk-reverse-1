local UIActivityKillZombieHelpPopup = {
  Name = UIWindowNames.UIActivityKillZombieHelpPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityKillZombie.HelpPopup.Controller.HelpPopupCtrl"),
  View = require("UI.UIActivityKillZombie.HelpPopup.View.HelpPopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/HelpPopup.prefab"
}
return {UIActivityKillZombieHelpPopup = UIActivityKillZombieHelpPopup}
