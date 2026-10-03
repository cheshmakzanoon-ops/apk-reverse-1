local UIValentineNpcRewardCard = {
  Name = UIWindowNames.UIValentineNpcRewardCard,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIValentineNpcRewardCard.Ctrl.UIValentineNpcRewardCardCtrl"),
  View = require("UI.UIValentineNpcRewardCard.View.UIValentineNpcRewardCardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/SendGiftContent/UIValentineNpcRewardCard.prefab"
}
return {UIValentineNpcRewardCard = UIValentineNpcRewardCard}
