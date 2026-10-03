local UIResourceItemLack = {
  Name = UIWindowNames.UIResourceItemLack,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIResourceItemLack.Controller.UIResourceItemLackCtrl"),
  View = require("UI.UIResourceItemLack.View.UIResourceItemLackView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIResourceItemLack/UIResourceItemLack.prefab"
}
return {UIResourceItemLack = UIResourceItemLack}
