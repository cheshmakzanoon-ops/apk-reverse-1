local UICapacityBoxSelect = {
  Name = UIWindowNames.UICapacityBoxSelect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGiftPackRewardSelect.Controller.UIGiftPackRewardSelectCtrl"),
  View = require("UI.UIGiftPackRewardSelect.View.UIGiftPackRewardSelectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/UIGiftPackRewardSelect.prefab"
}
return {UICapacityBoxSelect = UICapacityBoxSelect}
