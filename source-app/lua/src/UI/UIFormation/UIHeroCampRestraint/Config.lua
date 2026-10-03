local UIHeroCampRestraint = {
  Name = UIWindowNames.UIHeroCampRestraint,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormation.UIHeroCampRestraint.Controller.UIHeroCampRestraintCtrl"),
  View = require("UI.UIFormation.UIHeroCampRestraint.View.UIHeroCampRestraintView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroCampRestraint.prefab"
}
return {UIHeroCampRestraint = UIHeroCampRestraint}
