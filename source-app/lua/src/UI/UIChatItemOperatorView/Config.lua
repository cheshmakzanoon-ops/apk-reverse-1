local UIChatItemOperatorView = {
  Name = UIWindowNames.UIChatItemOperatorView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatItemOperatorView.Controller.UIChatItemOperatorCtrl"),
  View = require("UI.UIChatItemOperatorView.View.UIChatItemOperatorView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatItemOperator/UIChatItemOperator.prefab"
}
return {UIChatItemOperatorView = UIChatItemOperatorView}
