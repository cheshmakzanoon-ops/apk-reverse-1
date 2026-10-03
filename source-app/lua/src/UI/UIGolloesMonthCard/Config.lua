local UIGolloesMonthCard = {
  Name = UIWindowNames.UIGolloesMonthCard,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGolloesMonthCard.Controller.UIGolloesMonthCardCtrl"),
  View = require("UI.UIGolloesMonthCard.View.UIGolloesMonthCardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGolloesMonthCard/UIGolloesMonthCard.prefab"
}
return {UIGolloesMonthCard = UIGolloesMonthCard}
