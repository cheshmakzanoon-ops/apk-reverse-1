local UILWHeroHonorLevelUpgradeCtrl = BaseClass("UILWHeroHonorLevelUpgradeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWHeroHonorLevelUpgrade, {anim = true, playEffect = false})
end

UILWHeroHonorLevelUpgradeCtrl.CloseSelf = CloseSelf
return UILWHeroHonorLevelUpgradeCtrl
