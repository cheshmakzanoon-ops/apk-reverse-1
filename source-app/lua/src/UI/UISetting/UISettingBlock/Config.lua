local UISettingBlock = {
  Name = UIWindowNames.UISettingBlock,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UISettingBlock.Controller.UISettingBlockCtrl"),
  View = require("UI.UISetting.UISettingBlock.View.UISettingBlockView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingBlock.prefab"
}
return {UISettingBlock = UISettingBlock}
