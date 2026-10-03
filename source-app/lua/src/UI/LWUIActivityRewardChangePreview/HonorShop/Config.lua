local LWUIRewardChangePreview_HonorShopView = {
  Name = UIWindowNames.LWUIRewardChangePreview_HonorShopView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActivityRewardChangePreview.HonorShop.Ctrl.LWUIRewardChangePreview_HonorShopCtrl"),
  View = require("UI.LWUIActivityRewardChangePreview.HonorShop.View.LWUIRewardChangePreview_HonorShopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/HonorShop/LWUIRewardChangePreview_HonorShop.prefab"
}
return {LWUIRewardChangePreview_HonorShopView = LWUIRewardChangePreview_HonorShopView}
