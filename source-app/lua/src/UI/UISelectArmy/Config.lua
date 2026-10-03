local UISelectArmy = {
  Name = UIWindowNames.UISelectArmy,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISelectArmy.Controller.UISelectArmyCtrl"),
  View = require("UI.UISelectArmy.View.UISelectArmyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISelectArmy/UISelectArmy.prefab"
}
return {UISelectArmy = UISelectArmy}
