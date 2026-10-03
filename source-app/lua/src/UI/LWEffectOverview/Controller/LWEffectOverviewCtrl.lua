local LWEffectOverviewCtrl = BaseClass("LWEffectOverviewCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWEffectOverview, {anim = useAnimation})
end

LWEffectOverviewCtrl.CloseSelf = CloseSelf
return LWEffectOverviewCtrl
