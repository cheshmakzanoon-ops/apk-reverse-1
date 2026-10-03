local UITacticalEquipResearchStageTipsCtrl = BaseClass("UITacticalEquipResearchStageTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalEquipResearchStageTips)
end

UITacticalEquipResearchStageTipsCtrl.CloseSelf = CloseSelf
return UITacticalEquipResearchStageTipsCtrl
