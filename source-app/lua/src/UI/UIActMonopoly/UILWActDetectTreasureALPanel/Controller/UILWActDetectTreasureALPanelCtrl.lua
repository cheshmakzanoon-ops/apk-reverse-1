local UILWActDetectTreasureALPanelCtrl = BaseClass("UILWActDetectTreasureALPanelCtrl", UIBaseCtrl)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILWActDetectTreasureALPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWActDetectTreasureALPanel)
end

return UILWActDetectTreasureALPanelCtrl
