local UIJigsawArea = {
  Name = UIWindowNames.UIJigsawArea,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIJigsawArea.Controller.UIJigsawAreaCtrl"),
  View = require("UI.UIJigsawArea.View.UIJigsawAreaView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIJigsawArea/UIJigsawArea.prefab"
}
return {UIJigsawArea = UIJigsawArea}
