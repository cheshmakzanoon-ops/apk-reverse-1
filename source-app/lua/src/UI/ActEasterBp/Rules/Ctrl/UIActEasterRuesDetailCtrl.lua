local UIActEasterRuesDetailCtrl = BaseClass("UIActEasterRuesDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEasterRuesDetail)
end

UIActEasterRuesDetailCtrl.CloseSelf = CloseSelf
return UIActEasterRuesDetailCtrl
