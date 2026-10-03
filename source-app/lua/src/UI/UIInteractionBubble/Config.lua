local UIInteractionBubble = {
  Name = UIWindowNames.UIInteractionBubble,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIInteractionBubble.Controller.UIInteractionBubbleCtrl"),
  View = require("UI.UIInteractionBubble.View.UIInteractionBubbleView"),
  PrefabPath = "Assets/Main/Prefabs/UI/InteractionBubble/UIInteractionBubble.prefab",
  HideInBattle = true
}
return {UIInteractionBubble = UIInteractionBubble}
