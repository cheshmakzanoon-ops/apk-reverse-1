local UIAllianceStarBookCtrl = BaseClass("UIAllianceStarBookCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceStarBook)
end

UIAllianceStarBookCtrl.CloseSelf = CloseSelf
return UIAllianceStarBookCtrl
