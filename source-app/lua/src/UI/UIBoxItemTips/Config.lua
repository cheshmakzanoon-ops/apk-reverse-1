local UIBoxItemTips = {
  Name = UIWindowNames.UIBoxItemTips,
  Layer = UILayer.Info,
  Ctrl = require("UI/UIBoxItemTips/Controller/UIBoxItemTipsController"),
  View = require("UI/UIBoxItemTips/View/UIBoxItemTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIBoxItemTips.prefab"
}
return {UIBoxItemTips = UIBoxItemTips}
