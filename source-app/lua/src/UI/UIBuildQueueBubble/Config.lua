local UIBuildQueueBubble = {
  Name = UIWindowNames.UIBuildQueueBubble,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UIBuildQueueBubble/Controller/UIBuildQueueBubbleCtrl"),
  View = require("UI/UIBuildQueueBubble/View/UIBuildQueueBubbleView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMainUI/BuildQueueBubble.prefab"
}
return {UIBuildQueueBubble = UIBuildQueueBubble}
