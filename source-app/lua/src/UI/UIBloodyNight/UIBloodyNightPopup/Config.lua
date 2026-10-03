local UIBloodyNightPopup = {
  Name = UIWindowNames.UIBloodyNightPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBloodyNight.UIBloodyNightPopup.Controller.UIBloodyNightPopupCtrl"),
  View = require("UI.UIBloodyNight.UIBloodyNightPopup.View.UIBloodyNightPopupView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Activity/BloodyNight/UIBloodyNightPopup.prefab"
}
return {UIBloodyNightPopup = UIBloodyNightPopup}
