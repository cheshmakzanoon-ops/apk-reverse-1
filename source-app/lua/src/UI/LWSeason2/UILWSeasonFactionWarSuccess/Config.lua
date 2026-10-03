local UILWSeasonFactionWarSuccess = {
  Name = UIWindowNames.UILWSeasonFactionWarSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason2.UILWSeasonFactionWarSuccess.Controller.UILWSeasonFactionWarSuccessCtrl"),
  View = require("UI.LWSeason2.UILWSeasonFactionWarSuccess.View.UILWSeasonFactionWarSuccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonActivity/FactionWarSuccess.prefab"
}
return {UILWSeasonFactionWarSuccess = UILWSeasonFactionWarSuccess}
