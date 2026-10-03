local UIAllianceStarBookTipCtrl = BaseClass("UIAllianceStarBookTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceStarBookTip)
end

UIAllianceStarBookTipCtrl.CloseSelf = CloseSelf
return UIAllianceStarBookTipCtrl
