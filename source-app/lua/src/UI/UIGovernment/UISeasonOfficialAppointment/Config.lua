local UISeasonOfficialAppointment = {
  Name = UIWindowNames.UISeasonOfficialAppointment,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UISeasonOfficialAppointment.UISeasonOfficialAppointmentCtrl"),
  View = require("UI.UIGovernment.UISeasonOfficialAppointment.UISeasonOfficialAppointmentView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UISeasonOfficialAppointment.prefab"
}
return {UISeasonOfficialAppointment = UISeasonOfficialAppointment}
