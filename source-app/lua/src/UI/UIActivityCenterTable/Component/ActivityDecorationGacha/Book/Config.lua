local UIActivityDecorationGachaBook = {
  Name = UIWindowNames.UIActivityDecorationGachaBook,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UIActivityCenterTable/Component/ActivityDecorationGacha/Book/Ctrl/ActivityDecorationGachaBookCtrl"),
  View = require("UI/UIActivityCenterTable/Component/ActivityDecorationGacha/Book/View/ActivityDecorationGachaBookView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DecorationGacha/UIDecorationGachaBook.prefab"
}
return {UIActivityDecorationGachaBook = UIActivityDecorationGachaBook}
