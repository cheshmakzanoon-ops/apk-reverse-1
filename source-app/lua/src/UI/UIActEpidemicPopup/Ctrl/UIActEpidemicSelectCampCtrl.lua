local UIActEpidemicSelectCampCtrl = BaseClass("UIActEpidemicSelectCampCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEpidemicSelectCampView)
end

UIActEpidemicSelectCampCtrl.CloseSelf = CloseSelf
return UIActEpidemicSelectCampCtrl
