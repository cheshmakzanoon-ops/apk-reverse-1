local UIBindSendMailCtrl = BaseClass("UIBindSendMailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBindSendMail)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIBindSendMailCtrl.CloseSelf = CloseSelf
UIBindSendMailCtrl.Close = Close
return UIBindSendMailCtrl
