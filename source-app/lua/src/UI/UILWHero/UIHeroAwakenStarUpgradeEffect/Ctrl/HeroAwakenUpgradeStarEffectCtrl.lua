local HeroAwakenUpgradeStarEffectCtrl = BaseClass("HeroAwakenUpgradeStarEffectCtrl", UIBaseCtrl)

function HeroAwakenUpgradeStarEffectCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.HeroAwakenUpgradeStarEffect, {anim = true})
end

return HeroAwakenUpgradeStarEffectCtrl
