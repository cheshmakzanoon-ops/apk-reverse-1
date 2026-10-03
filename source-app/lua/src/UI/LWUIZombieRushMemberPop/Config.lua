local LWUIZombieRushMemberPop = {
  Name = UIWindowNames.LWUIZombieRushMemberPop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIZombieRushMemberPop.Controller.LWUIZombieRushMemberPopCtrl"),
  View = require("UI.LWUIZombieRushMemberPop.View.LWUIZombieRushMemberPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UILWZombieRush/LWUIZombieRushMemberPop.prefab"
}
return {LWUIZombieRushMemberPop = LWUIZombieRushMemberPop}
