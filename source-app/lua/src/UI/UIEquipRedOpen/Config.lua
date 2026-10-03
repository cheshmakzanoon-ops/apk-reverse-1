local UIRedEquipLimitTip = {
  Name = UIWindowNames.UIRedEquipLimitTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIEquipRedOpen.Controller.UIRedEquipLimitTipCtrl"),
  View = require("UI.UIEquipRedOpen.View.UIRedEquipLimitTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIRedEquipLimitTip.prefab"
}
return {UIRedEquipLimitTip = UIRedEquipLimitTip}
