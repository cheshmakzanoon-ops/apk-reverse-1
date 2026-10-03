local UINoticeEquipTips = {
  Name = UIWindowNames.UINoticeEquipTips,
  Layer = UILayer.Info,
  Ctrl = require("UI.UINoticeEquipTips.Controller.UINoticeEquipTipsCtrl"),
  View = require("UI.UINoticeEquipTips.View.UINoticeEquipTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UINoticeEquipTips.prefab"
}
return {UINoticeEquipTips = UINoticeEquipTips}
