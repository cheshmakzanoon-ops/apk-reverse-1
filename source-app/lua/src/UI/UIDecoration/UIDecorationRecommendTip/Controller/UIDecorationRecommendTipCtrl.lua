local UIDecorationRecommendTipCtrl = BaseClass("UIDecorationRecommendTipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDecorationRecommendTip)
end

UIDecorationRecommendTipCtrl.CloseSelf = CloseSelf
return UIDecorationRecommendTipCtrl
