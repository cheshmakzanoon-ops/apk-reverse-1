local UIAllianceStarBookView = {
  Name = UIWindowNames.UIAllianceStarBookView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllianceStarBook.Controller.UIAllianceStarBookCtrl"),
  View = require("UI.UIAllianceStarBook.View.UIAllianceStarBookView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllianceStar/UIAllianceStarBook.prefab"
}
return {UIAllianceStarBookView = UIAllianceStarBookView}
