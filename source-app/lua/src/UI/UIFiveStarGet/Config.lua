local UIFiveStarGet = {
  Name = UIWindowNames.UIFiveStarGet,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFiveStarGet.Controller.UIFiveStarGetCtrl"),
  View = require("UI.UIFiveStarGet.View.UIFiveStarGetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMain/UIFiveStarGet.prefab"
}
return {UIFiveStarGet = UIFiveStarGet}
