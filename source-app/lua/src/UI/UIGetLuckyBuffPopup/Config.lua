local UIGetLuckyBuffPopup = {
  Name = UIWindowNames.UIGetLuckyBuffPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGetLuckyBuffPopup.Controller.UIGetLuckyBuffPopupCtrl"),
  View = require("UI.UIGetLuckyBuffPopup.View.UIGetLuckyBuffPopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILuckyBuff/UIGetLuckyBuffPopup.prefab"
}
return {UIGetLuckyBuffPopup = UIGetLuckyBuffPopup}
