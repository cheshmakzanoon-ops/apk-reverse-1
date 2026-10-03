local UIJungleTrialPopup = {
  Name = UIWindowNames.UIJungleTrialPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIJungleTrial.UIJungleTrialPopup.UIJungleTrialPopupCtrl"),
  View = require("UI.UIJungleTrial.UIJungleTrialPopup.UIJungleTrialPopupView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/JungleTrial/UIJungleTrialPopup.prefab"
}
return {UIJungleTrialPopup = UIJungleTrialPopup}
