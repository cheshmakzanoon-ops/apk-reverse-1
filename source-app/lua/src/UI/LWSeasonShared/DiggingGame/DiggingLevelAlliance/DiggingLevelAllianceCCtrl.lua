local DiggingLevelAllianceCtrl = BaseClass("DiggingLevelAllianceCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.DiggingLevelAllianceCView, {anim = true, playEffect = false})
end

DiggingLevelAllianceCtrl.CloseSelf = CloseSelf
return DiggingLevelAllianceCtrl
