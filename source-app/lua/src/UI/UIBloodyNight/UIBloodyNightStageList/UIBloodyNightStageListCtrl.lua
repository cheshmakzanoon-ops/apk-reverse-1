local UIBloodyNightStageListCtrl = BaseClass("UIBloodyNightStageListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBloodyNightStageList)
end

UIBloodyNightStageListCtrl.CloseSelf = CloseSelf
return UIBloodyNightStageListCtrl
