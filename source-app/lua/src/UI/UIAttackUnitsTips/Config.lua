local UIAttackUnitsTips = {
  Name = UIWindowNames.UIAttackUnitsTips,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UIAttackUnitsTips.Controller.UIAttackUnitsTipsCtrl"),
  View = require("UI.UIAttackUnitsTips.View.UIAttackUnitsTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIAttackUnits/UIAttackUnitsTips.prefab"
}
return {UIAttackUnitsTips = UIAttackUnitsTips}
