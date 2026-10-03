local UIActShowTextTipCtrl = BaseClass("UISeasonShowTextTipView", UIBaseCtrl)

function UIActShowTextTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActShowTextTipView)
end

return UIActShowTextTipCtrl
