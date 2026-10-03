local UILWGoldBrickConfirmCtrl = BaseClass("UILWGoldBrickConfirmCtrl", UIBaseCtrl)
local Setting = CS.GameEntry.Setting

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGoldBrickConfirm)
end

UILWGoldBrickConfirmCtrl.CloseSelf = CloseSelf
return UILWGoldBrickConfirmCtrl
