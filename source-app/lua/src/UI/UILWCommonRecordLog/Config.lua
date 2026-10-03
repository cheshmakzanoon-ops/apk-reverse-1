local UILWCommonShowBubbleTip = {
  Name = UIWindowNames.UILWCommonRecordLog,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWCommonRecordLog.Controller.UILWCommonRecordLogCtrl"),
  View = require("UI.UILWCommonRecordLog.View.UILWCommonRecordLogView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DispatchTask/UILWCommonRecordLog.prefab"
}
return {UILWCommonShowBubbleTip = UILWCommonShowBubbleTip}
