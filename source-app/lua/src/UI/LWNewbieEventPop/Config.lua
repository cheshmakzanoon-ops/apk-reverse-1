local LWNewbieEventPopView = {
  Name = UIWindowNames.LWNewbieEventPopView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWNewbieEventPop.Ctrl.LWNewbieEventPopCtrl"),
  View = require("UI.LWNewbieEventPop.View.LWNewbieEventPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWNewbieEventPop/LWNewbieEventPop.prefab"
}
return {LWNewbieEventPopView = LWNewbieEventPopView}
