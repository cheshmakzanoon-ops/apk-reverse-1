local UIActBingoTaskInfoCtrl = BaseClass("UIActBingoTaskInfoCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActBingoTaskInfo)
end

UIActBingoTaskInfoCtrl.CloseSelf = CloseSelf
return UIActBingoTaskInfoCtrl
