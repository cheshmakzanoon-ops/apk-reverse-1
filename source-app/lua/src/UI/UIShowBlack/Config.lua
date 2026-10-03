local UIShowBlack = {
  Name = UIWindowNames.UIShowBlack,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIShowBlack.Controller.UIShowBlackCtrl"),
  View = require("UI.UIShowBlack.View.UIShowBlackView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIShowBlack.prefab"
}
return {UIShowBlack = UIShowBlack}
