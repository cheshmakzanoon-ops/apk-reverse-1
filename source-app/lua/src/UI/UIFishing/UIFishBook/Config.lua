local UIFishBook = {
  Name = UIWindowNames.UIFishBook,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFishing.UIFishBook.UIFishBookCtrl"),
  View = require("UI.UIFishing.UIFishBook.UIFishBookView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/UIFishBook.prefab",
  HideBack = true
}
return {UIFishBook = UIFishBook}
