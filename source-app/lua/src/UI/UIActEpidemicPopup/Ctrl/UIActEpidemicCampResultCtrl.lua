local UIActEpidemicCampResultCtrl = BaseClass("UIActEpidemicCampResultCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEpidemicCampResultView)
end

UIActEpidemicCampResultCtrl.CloseSelf = CloseSelf
return UIActEpidemicCampResultCtrl
