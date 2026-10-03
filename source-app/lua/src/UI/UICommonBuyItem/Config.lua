local UICommonBuyItem = {
  Name = UIWindowNames.UICommonBuyItem,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICommonBuyItem.Controller.UICommonBuyItemCtrl"),
  View = require("UI.UICommonBuyItem.View.UICommonBuyItemView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonBuyItem.prefab"
}
return {UICommonBuyItem = UICommonBuyItem}
