local UITrainPrepareThanksPopup = {
  Name = UIWindowNames.UITrainPrepareThanksPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITrainPrepareThanksPopup.Controller.UITrainPrepareThanksPopupCtrl"),
  View = require("UI.UILWRailway.UITrainPrepareThanksPopup.View.UITrainPrepareThanksPopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/Scene/UITrainPrepareThanksPopup.prefab"
}
return {UITrainPrepareThanksPopup = UITrainPrepareThanksPopup}
