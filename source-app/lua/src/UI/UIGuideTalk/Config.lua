local UIGuideTalk = {
  Name = UIWindowNames.UIGuideTalk,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIGuideTalk.Controller.UIGuideTalkCtrl"),
  View = require("UI.UIGuideTalk.View.UIGuideTalkView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIGuideTalk.prefab"
}
return {UIGuideTalk = UIGuideTalk}
