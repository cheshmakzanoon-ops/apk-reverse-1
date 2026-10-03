local UIPuzzleMonsterCreate = {
  Name = UIWindowNames.UIPuzzleMonsterCreate,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPuzzleMonster.UIPuzzleMonsterCreate.Controller.UIPuzzleMonsterCreateCtrl"),
  View = require("UI.UIPuzzleMonster.UIPuzzleMonsterCreate.View.UIPuzzleMonsterCreateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPuzzleMonster/UIPuzzleMonsterCreate.prefab"
}
return {UIPuzzleMonsterCreate = UIPuzzleMonsterCreate}
