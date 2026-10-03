local UIAllianceCareerEffectTipCtrl = BaseClass("UIAllianceCareerEffectTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceCareerEffectTip)
end

UIAllianceCareerEffectTipCtrl.CloseSelf = CloseSelf
return UIAllianceCareerEffectTipCtrl
