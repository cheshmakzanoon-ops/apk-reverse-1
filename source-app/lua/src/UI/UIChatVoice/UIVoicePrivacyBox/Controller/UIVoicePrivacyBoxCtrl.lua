local UIVoicePrivacyBoxCtrl = BaseClass("UIVoicePrivacyBoxCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVoicePrivacyBox)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIVoicePrivacyBoxCtrl.CloseSelf = CloseSelf
UIVoicePrivacyBoxCtrl.Close = Close
return UIVoicePrivacyBoxCtrl
