local UIChampionDuelFormationTips = {
  Name = UIWindowNames.UIChampionDuelFormationTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.FormationTips.Controller.UIChampionDuelFormationTipsCtrl"),
  View = require("UI.UIChampionDuel.FormationTips.View.UIChampionDuelFormationTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelFormationTips.prefab"
}
return {UIChampionDuelFormationTips = UIChampionDuelFormationTips}
