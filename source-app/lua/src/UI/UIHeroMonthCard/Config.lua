local UIHeroMonthCard = {
  Name = UIWindowNames.UIHeroMonthCard,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHeroMonthCard.Controller.UIHeroMonthCardCtrl"),
  View = require("UI.UIHeroMonthCard.View.UIHeroMonthCardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHeroMonthCard/UIHeroMonthCard.prefab"
}
return {UIHeroMonthCard = UIHeroMonthCard}
