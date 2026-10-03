local UIGovernmentKingPower = {
  Name = UIWindowNames.UIGovernmentKingPower,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.KingPower.Controller.KingPowerCtrl"),
  View = require("UI.UIGovernment.KingPower.View.KingPowerView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/KingPower.prefab"
}
return {UIGovernmentKingPower = UIGovernmentKingPower}
