local UIActMonopolyTaskCtrl = BaseClass("UIActMonopolyTaskCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActMonopolyTask)
end

UIActMonopolyTaskCtrl.CloseSelf = CloseSelf
return UIActMonopolyTaskCtrl
