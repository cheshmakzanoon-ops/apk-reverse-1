local LWUIZombieRushOrderTimePop = {
  Name = UIWindowNames.LWUIZombieRushOrderTimePop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIZombieRushOrderPop.Controller.LWUIZombieRushOrderTimePopCtrl"),
  View = require("UI.LWUIZombieRushOrderPop.View.LWUIZombieRushOrderTimePopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UILWZombieRush/LWUIZombieRushOrderTimePop.prefab"
}
return {LWUIZombieRushOrderTimePop = LWUIZombieRushOrderTimePop}
