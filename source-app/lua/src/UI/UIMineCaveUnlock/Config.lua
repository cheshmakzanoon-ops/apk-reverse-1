local UIMineCaveUnlock = {
  Name = UIWindowNames.UIMineCaveUnlock,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMineCaveUnlock.Controller.UIMineCaveUnlockCtrl"),
  View = require("UI.UIMineCaveUnlock.View.UIMineCaveUnlockView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMineCaveUnlock/UIMineCaveUnlock.prefab"
}
return {UIMineCaveUnlock = UIMineCaveUnlock}
