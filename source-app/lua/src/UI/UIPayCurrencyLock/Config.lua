local UIPayCurrencyLock = {
  Name = UIWindowNames.UIPayCurrencyLock,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPayCurrencyLock.Controller.UIPayCurrencyLockCtrl"),
  View = require("UI.UIPayCurrencyLock.View.UIPayCurrencyLockView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPayCurrencyLock/UIPayCurrencyLock.prefab"
}
return {UIPayCurrencyLock = UIPayCurrencyLock}
