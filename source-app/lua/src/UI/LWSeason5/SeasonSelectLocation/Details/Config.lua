local SeasonSelectLocationDetails = {
  Name = UIWindowNames.SeasonSelectLocationDetails,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.SeasonSelectLocation.Details.Ctrl.SeasonSelectLocationDetailsCtrl"),
  View = require("UI.LWSeason5.SeasonSelectLocation.Details.View.SeasonSelectLocationDetailsView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Activity/SeasonSelectLocation/SeasonSelectLocationDetails.prefab"
}
return {SeasonSelectLocationDetails = SeasonSelectLocationDetails}
