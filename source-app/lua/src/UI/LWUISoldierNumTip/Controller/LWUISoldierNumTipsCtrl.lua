local LWUISoldierNumTipsCtrl = BaseClass("LWUISoldierNumTipsCtrl", UIBaseCtrl)

function LWUISoldierNumTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUISoldierNumTips)
end

return LWUISoldierNumTipsCtrl
