local UIDoomsdayDetails = {
  Name = UIWindowNames.UIDoomsdayDetails,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.Doomsday.UIDoomsdayDetails.Controller.UIDoomsdayDetailsCtrl"),
  View = require("UI.UIActivityCenterTable.Component.Doomsday.UIDoomsdayDetails.View.UIDoomsdayDetailsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Doomsday/UIActivityDoomsdayDetails.prefab"
}
return {UIDoomsdayDetails = UIDoomsdayDetails}
