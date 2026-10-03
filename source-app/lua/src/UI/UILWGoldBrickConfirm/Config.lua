local UILWGoldBrickConfirmView = {
  Name = UIWindowNames.UILWGoldBrickConfirm,
  Layer = UILayer.Info,
  Ctrl = require("UI.UILWGoldBrickConfirm.Controller.UILWGoldBrickConfirmCtrl"),
  View = require("UI.UILWGoldBrickConfirm.View.UILWGoldBrickConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GoldBrick/UILWGoldBrickConfirm.prefab"
}
return {UILWGoldBrickConfirmView = UILWGoldBrickConfirmView}
