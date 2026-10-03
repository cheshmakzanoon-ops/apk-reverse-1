local UILWSeasonHint = {
  Name = UIWindowNames.UILWSeasonHint,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonHint.Controller.LWSeasonHintCtrl"),
  View = require("UI.LWSeason.LWSeasonHint.View.LWSeasonHintView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonHint.prefab"
}
return {UILWSeasonHint = UILWSeasonHint}
