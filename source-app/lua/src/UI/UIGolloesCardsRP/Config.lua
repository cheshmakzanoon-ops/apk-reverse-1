local UIGolloesCardsRP = {
  Name = UIWindowNames.UIGolloesCardsRP,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGolloesCardsRP.Controller.UIGolloesCardsRPCtrl"),
  View = require("UI.UIGolloesCardsRP.View.UIGolloesCardsRPView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/GolloesCards/UIGolloesCardsRP.prefab"
}
return {UIGolloesCardsRP = UIGolloesCardsRP}
