local UICapacityBoxSelectNew = {
  Name = UIWindowNames.UICapacityBoxSelectNew,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UICapacityBoxSelectNew/Controller/UICapacityBoxSelectNewCtrl"),
  View = require("UI/UICapacityBoxSelectNew/View/UICapacityBoxSelectNewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWBag/UICapacityBoxSelectNew.prefab"
}
return {UICapacityBoxSelectNew = UICapacityBoxSelectNew}
