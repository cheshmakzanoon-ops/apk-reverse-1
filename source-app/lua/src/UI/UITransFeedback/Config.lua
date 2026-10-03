local UITransFeedbackView = {
  Name = UIWindowNames.UITransFeedbackView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UITransFeedback.Ctrl.UITransFeedbackCtrl"),
  View = require("UI.UITransFeedback.View.UITransFeedbackView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/UITransFeedbackView.prefab"
}
return {UITransFeedbackView = UITransFeedbackView}
