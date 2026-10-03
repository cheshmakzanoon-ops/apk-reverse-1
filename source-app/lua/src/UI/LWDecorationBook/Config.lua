local UILWDecorationBook = {
  Name = UIWindowNames.LWDecorationBook,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWDecorationBook.Controller.LWDecorationBookMainCtrl"),
  View = require("UI.LWDecorationBook.View.LWDecorationBookMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIDecorationBook/UIDecorationBookMain.prefab"
}
return {UILWDecorationBook = UILWDecorationBook}
