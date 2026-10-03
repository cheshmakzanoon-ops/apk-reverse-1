local UIPersonalArmsCalendarExchange = {
  Name = UIWindowNames.UIPersonalArmsCalendarExchange,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityPersonalArms.UIPersonalArmsCalendarExchange.Ctrl.UIPersonalArmsCalendarExchangeCtrl"),
  View = require("UI.UIActivityPersonalArms.UIPersonalArmsCalendarExchange.View.UIPersonalArmsCalendarExchangeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/PersonalArms/UIPersonalArmsCalendarExchange.prefab"
}
return {UIPersonalArmsCalendarExchange = UIPersonalArmsCalendarExchange}
