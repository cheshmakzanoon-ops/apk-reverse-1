local UIOfficialAppointLog = {
  Name = UIWindowNames.UIOfficialAppointLog,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.OfficialAppointLog.Controller.UIOfficialAppointLogCtrl"),
  View = require("UI.UIGovernment.OfficialAppointLog.View.UIOfficialAppointLogView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/OfficialApply/UIOfficialAppointLog.prefab"
}
return {UIOfficialAppointLog = UIOfficialAppointLog}
