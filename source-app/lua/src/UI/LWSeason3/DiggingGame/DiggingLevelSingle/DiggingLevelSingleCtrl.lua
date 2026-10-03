local DiggingLevelSingleCtrl = BaseClass("DiggingLevelSingleCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.DiggingLevelSingleView, {anim = true, playEffect = false})
end

DiggingLevelSingleCtrl.CloseSelf = CloseSelf
return DiggingLevelSingleCtrl
