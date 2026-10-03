local UIActBossTipsCtrl = BaseClass("UIActBossTipsCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActBossTips)
end

UIActBossTipsCtrl.CloseSelf = CloseSelf
return UIActBossTipsCtrl
