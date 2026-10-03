local UISurfingInteraction = {
  Name = UIWindowNames.UISurfingInteraction,
  Layer = UILayer.Info,
  Ctrl = require("UI.UISurfing.Inside.SurfingInteraction.Controller.UISurfingInteractionCtrl"),
  View = require("UI.UISurfing.Inside.SurfingInteraction.View.UISurfingInteractionView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SurfingBattle/Inside/UISurfingInteraction.prefab"
}
return {UISurfingInteraction = UISurfingInteraction}
