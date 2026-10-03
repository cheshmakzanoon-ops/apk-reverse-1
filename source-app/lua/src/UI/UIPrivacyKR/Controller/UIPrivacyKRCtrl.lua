local UIPrivacyKRCtrl = BaseClass("UIPrivacyKR", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPrivacyKR, {anim = false})
end

UIPrivacyKRCtrl.CloseSelf = CloseSelf
return UIPrivacyKRCtrl
