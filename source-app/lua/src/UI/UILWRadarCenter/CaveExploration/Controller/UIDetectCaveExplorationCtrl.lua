local UIDetectCaveExplorationCtrl = BaseClass("UIDetectCaveExplorationCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDetectCaveExploration)
end

UIDetectCaveExplorationCtrl.CloseSelf = CloseSelf
return UIDetectCaveExplorationCtrl
