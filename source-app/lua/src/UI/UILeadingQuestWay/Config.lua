local UILeadingQuestWay = {
  Name = UIWindowNames.UILeadingQuestWay,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILeadingQuestWay.Controller.UILeadingQuestWayCtrl"),
  View = require("UI.UILeadingQuestWay.View.UILeadingQuestWayView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/LeadingQuestV2/UILeadingQuestWay.prefab",
  CustomKeyCodeEscape = true
}
return {UILeadingQuestWay = UILeadingQuestWay}
