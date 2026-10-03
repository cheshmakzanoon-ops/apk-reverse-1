local UILWArena3V3DefenseTeamOrder = {
  Name = UIWindowNames.UILWArena3V3DefenseTeamOrder,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWArena3V3DefenseTeamOrder.Controller.UILWArena3V3DefenseTeamOrderCtrl"),
  View = require("UI.UILWArena3V3DefenseTeamOrder.View.UILWArena3V3DefenseTeamOrderView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/LWUIArena3V3DefenseTeamOrder.prefab"
}
return {UILWArena3V3DefenseTeamOrder = UILWArena3V3DefenseTeamOrder}
