local UICounterAttackRank = {
  Name = UIWindowNames.UICounterAttackRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICounterAttack.UICounterAttackRank.Controller.UICounterAttackRankCtrl"),
  View = require("UI.UICounterAttack.UICounterAttackRank.View.UICounterAttackRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/CounterAttack/UICounterAttackRank.prefab"
}
return {UICounterAttackRank = UICounterAttackRank}
