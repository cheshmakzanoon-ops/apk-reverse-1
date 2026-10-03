local UIBuildUpgrade = {
  Name = UIWindowNames.UIBuildDecorateExchange,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBuildDecorateExchange.Controller.UIBuildDecorateExchangeCtrl"),
  View = require("UI.UIBuildDecorateExchange.View.UIBuildDecorateExchangeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgrade/UIBuildDecorateExchange.prefab"
}
return {UIBuildUpgrade = UIBuildUpgrade}
