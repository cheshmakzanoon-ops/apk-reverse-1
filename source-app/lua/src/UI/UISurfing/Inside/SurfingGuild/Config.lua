local UISurfingGuild = {
  Name = UIWindowNames.UISurfingGuild,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISurfing.Inside.SurfingGuild.Controller.UISurfingGuildCtrl"),
  View = require("UI.UISurfing.Inside.SurfingGuild.View.UISurfingGuildView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SurfingBattle/Inside/UISurfingGuild.prefab"
}
return {UISurfingGuild = UISurfingGuild}
