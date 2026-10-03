local UIGolloesCardsRank = {
  Name = UIWindowNames.UIGolloesCardsRank,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIGolloesCardsRank.Controller.UIGolloesCardsRankCtrl"),
  View = require("UI.UIGolloesCardsRank.View.UIGolloesCardsRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/GolloesCards/UIGolloesCardsRank.prefab"
}
return {UIGolloesCardsRank = UIGolloesCardsRank}
