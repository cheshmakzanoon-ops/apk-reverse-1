local LWComic = {
  Name = UIWindowNames.UILWComic,
  Layer = UILayer.Guide,
  Ctrl = require("UI.LWComic.Controller.UILWComicCtrl"),
  View = require("UI.LWComic.View.UILWComicView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Comics/UIComicsMain.prefab"
}
return {LWComic = LWComic}
