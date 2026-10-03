local UIDecorateUnlock = {
  Name = UIWindowNames.UIDecorateUnlock,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDecoration.UIDecorateUnlock.Controller.UIDecorateUnlockCtrl"),
  View = require("UI.UIDecoration.UIDecorateUnlock.View.UIDecorateUnlockView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIDecoration/UIDecorateUnlock.prefab"
}
return {UIDecorateUnlock = UIDecorateUnlock}
