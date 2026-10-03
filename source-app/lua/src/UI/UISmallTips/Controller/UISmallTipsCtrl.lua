local UISmallTipsCtrl = BaseClass("UISmallTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISmallTips)
end

UISmallTipsCtrl.CloseSelf = CloseSelf
return UISmallTipsCtrl
