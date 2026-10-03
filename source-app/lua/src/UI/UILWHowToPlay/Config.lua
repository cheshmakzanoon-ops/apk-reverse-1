local UILWHowToPlay = {
  Name = UIWindowNames.UILWHowToPlay,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHowToPlay.Controller.UILWHowToPlayCtrl"),
  View = require("UI.UILWHowToPlay.View.UILWHowToPlayView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWHowToPlay/UILWHowToPlay.prefab"
}
return {UILWHowToPlay = UILWHowToPlay}
