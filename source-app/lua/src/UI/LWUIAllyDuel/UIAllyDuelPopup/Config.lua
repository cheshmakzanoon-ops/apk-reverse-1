local UIAllyDuelPopup = {
  Name = UIWindowNames.UIAllyDuelPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIAllyDuel.UIAllyDuelPopup.Controller.UIAllyDuelPopupCtrl"),
  View = require("UI.LWUIAllyDuel.UIAllyDuelPopup.View.UIAllyDuelPopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllyDuel/UIAllyDuelPopupNew.prefab"
}
return {UIAllyDuelPopup = UIAllyDuelPopup}
