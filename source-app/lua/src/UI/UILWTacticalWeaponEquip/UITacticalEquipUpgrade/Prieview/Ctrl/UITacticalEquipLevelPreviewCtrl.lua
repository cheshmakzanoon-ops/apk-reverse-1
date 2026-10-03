local UITacticalEquipLevelPreviewCtrl = BaseClass("UITacticalEquipLevelPreviewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalEquipLevelPreview)
end

UITacticalEquipLevelPreviewCtrl.CloseSelf = CloseSelf
return UITacticalEquipLevelPreviewCtrl
