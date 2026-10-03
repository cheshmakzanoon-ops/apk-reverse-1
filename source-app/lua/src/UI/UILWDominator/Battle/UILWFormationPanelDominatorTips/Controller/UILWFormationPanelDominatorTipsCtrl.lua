local UILWFormationPanelDominatorTipsCtrl = BaseClass("UILWFormationPanelDominatorTipsCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWFormationPanelDominatorTips)
end

UILWFormationPanelDominatorTipsCtrl.CloseSelf = CloseSelf
return UILWFormationPanelDominatorTipsCtrl
