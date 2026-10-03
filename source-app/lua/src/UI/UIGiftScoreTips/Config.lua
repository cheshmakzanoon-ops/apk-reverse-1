local UIGiftScoreTips = {
  Name = UIWindowNames.UIGiftScoreTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGiftScoreTips.Controller.UIGiftScoreTipsController"),
  View = require("UI.UIGiftScoreTips.View.UIGiftScoreTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIGiftScoreTips.prefab"
}
return {UIGiftScoreTips = UIGiftScoreTips}
