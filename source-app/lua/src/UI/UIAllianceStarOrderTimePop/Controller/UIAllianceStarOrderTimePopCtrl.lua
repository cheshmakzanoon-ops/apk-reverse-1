local UIAllianceStarOrderTimePopCtrl = BaseClass("UIAllianceStarOrderTimePopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceStarOrderTimePop)
end

UIAllianceStarOrderTimePopCtrl.CloseSelf = CloseSelf
return UIAllianceStarOrderTimePopCtrl
