local UIPrivacyCtrl = BaseClass("UIPrivacy", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPrivacy, {anim = false})
end

UIPrivacyCtrl.CloseSelf = CloseSelf
return UIPrivacyCtrl
