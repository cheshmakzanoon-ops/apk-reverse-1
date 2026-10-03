local LWSeasonVirusResearchLevelUp = {
  Name = UIWindowNames.LWSeasonVirusResearchLevelUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.LWSeasonVirusResearch.Controller.LWSeasonVirusResearchLevelUpCtrl"),
  View = require("UI.LWSeason1.LWSeasonVirusResearch.View.LWSeasonVirusResearchLevelUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/VirusResearch/LWSeasonVirusResearchLevelUp.prefab",
  CustomKeyCodeEscape = true
}
return {LWSeasonVirusResearchLevelUp = LWSeasonVirusResearchLevelUp}
