local UIPlayerHeadIconSelect = {
  Name = UIWindowNames.UIPlayerHeadIconSelect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPlayerHeadIconSelect.Controller.UIPlayerHeadIconSelectCtrl"),
  View = require("UI.UIPlayerHeadIconSelect.View.UIPlayerHeadIconSelectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Set/New/UIPlayerHeadIconSelectNew.prefab"
}
return {UIPlayerHeadIconSelect = UIPlayerHeadIconSelect}
