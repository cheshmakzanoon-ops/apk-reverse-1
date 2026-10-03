local UIBindSendMailCtrl = BaseClass("UIBindSendMailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBindSendMail)
end

UIBindSendMailCtrl.CloseSelf = CloseSelf
return UIBindSendMailCtrl
