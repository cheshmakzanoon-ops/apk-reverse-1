local UIOfficialMessageBar = {
  Name = UIWindowNames.UIOfficialMessageBar,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UIGovernment.OfficialMessageBar.Controller.UIOfficialMessageBarCtrl"),
  View = require("UI.UIGovernment.OfficialMessageBar.View.UIOfficialMessageBarView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/OfficialApply/UIOfficialMessageBar.prefab"
}
return {UIOfficialMessageBar = UIOfficialMessageBar}
