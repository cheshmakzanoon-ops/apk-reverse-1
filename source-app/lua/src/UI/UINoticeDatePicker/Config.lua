local UINoticeDatePicker = {
  Name = UIWindowNames.UINoticeDatePicker,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UINoticeDatePicker.Controller.UINoticeDatePickerCtrl"),
  View = require("UI.UINoticeDatePicker.View.UINoticeDatePickerView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatNotice/UINoticeDatePicker.prefab"
}
return {UINoticeDatePicker = UINoticeDatePicker}
