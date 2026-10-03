local UILWAlAssemblyInfo = {
  Name = UIWindowNames.UILWAlAssemblyInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlAssemblyInfo.Controller.UILWAlAssemblyInfoCtrl"),
  View = require("UI.UILWAlliance.UILWAlAssemblyInfo.View.UILWAlAssemblyInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlAssemblyInfoPanel.prefab"
}
return {UILWAlAssemblyInfo = UILWAlAssemblyInfo}
