local UIBindMailTipsCtrl = BaseClass("UIBindMailTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBindMailTips)
end

UIBindMailTipsCtrl.CloseSelf = CloseSelf
return UIBindMailTipsCtrl
