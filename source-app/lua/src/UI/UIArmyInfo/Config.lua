local UIArmyInfo = {
  Name = UIWindowNames.UIArmyInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIArmyInfo.Controller.UIArmyInfoCtrl"),
  View = require("UI.UIArmyInfo.View.UIArmyInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIArmyInfo/UIArmyInfo.prefab"
}
return {UIArmyInfo = UIArmyInfo}
