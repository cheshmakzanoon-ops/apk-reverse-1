local LWUIMeteoriteConditionNotice = {
  Name = UIWindowNames.LWUIMeteoriteConditionNotice,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMeteoriteConditionNotice.Controller.LWUIMeteoriteConditionNoticeCtrl"),
  View = require("UI.LWUIMeteoriteConditionNotice.View.LWUIMeteoriteConditionNoticeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWCommon/UIMeteoriteConditionNotice.prefab"
}
return {LWUIMeteoriteConditionNotice = LWUIMeteoriteConditionNotice}
