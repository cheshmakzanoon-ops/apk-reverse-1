local UIUnLockNewFunc = {
  Name = UIWindowNames.UIUnLockNewFunc,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIUnLockNewFunc.Controller.UIUnLockNewFuncCtrl"),
  View = require("UI.UIUnLockNewFunc.View.UIUnLockNewFuncView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIUnLockNewFunc.prefab"
}
return {UIUnLockNewFunc = UIUnLockNewFunc}
