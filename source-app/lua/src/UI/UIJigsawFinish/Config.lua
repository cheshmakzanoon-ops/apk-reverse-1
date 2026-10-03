local UIJigsawFinish = {
  Name = UIWindowNames.UIJigsawFinish,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIJigsawFinish.Controller.UIJigsawFinishCtrl"),
  View = require("UI.UIJigsawFinish.View.UIJigsawFinishView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIJigsawFinish/UIJigsawFinish.prefab"
}
return {UIJigsawFinish = UIJigsawFinish}
