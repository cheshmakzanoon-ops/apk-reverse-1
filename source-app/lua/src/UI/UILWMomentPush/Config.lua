local UILWMomentPush = {
  Name = UIWindowNames.UILWMomentPush,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWMomentPush.Controller.UILWMomentPushCtrl"),
  View = require("UI.UILWMomentPush.View.UILWMomentPushView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/FiendCircle/UILWMomentPush.prefab"
}
return {UILWMomentPush = UILWMomentPush}
