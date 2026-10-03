local LWActMeteoriteFlyTipCtrl = BaseClass("LWActMeteoriteFlyTipCtrl", UIBaseCtrl)

function LWActMeteoriteFlyTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActMeteoriteFlyTip)
end

return LWActMeteoriteFlyTipCtrl
