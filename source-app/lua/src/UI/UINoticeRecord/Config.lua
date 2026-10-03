local UINoticeRecord = {
  Name = UIWindowNames.UINoticeRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UINoticeRecord.Controller.UINoticeRecordCtrl"),
  View = require("UI.UINoticeRecord.View.UINoticeRecordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatNotice/NoticeRecord/LWUINoticeRecord.prefab",
  CustomKeyCodeEscape = true
}
return {UINoticeRecord = UINoticeRecord}
