local UIWorldDeclareWarInfo = {
  Name = UIWindowNames.UIWorldDeclareWarInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldDeclareWarInfo.Controller.UIWorldDeclareWarInfoCtrl"),
  View = require("UI.UIWorldDeclareWarInfo.View.UIWorldDeclareWarInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIWorldDeclareWarInfo.prefab"
}
return {UIWorldDeclareWarInfo = UIWorldDeclareWarInfo}
