local UIShareLuckyBuffPopup = {
  Name = UIWindowNames.UIShareLuckyBuffPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIShareLuckyBuffPopup.Controller.UIShareLuckyBuffPopupCtrl"),
  View = require("UI.UIShareLuckyBuffPopup.View.UIShareLuckyBuffPopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILuckyBuff/UIShareLuckyBuffPopup.prefab"
}
return {UIShareLuckyBuffPopup = UIShareLuckyBuffPopup}
