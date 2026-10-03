local UIOfficialApply = {
  Name = UIWindowNames.UIOfficialApply,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.OfficialApply.Controller.UIOfficialApplyCtrl"),
  View = require("UI.UIGovernment.OfficialApply.View.UIOfficialApplyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/OfficialApply/UIOfficialApply.prefab"
}
return {UIOfficialApply = UIOfficialApply}
