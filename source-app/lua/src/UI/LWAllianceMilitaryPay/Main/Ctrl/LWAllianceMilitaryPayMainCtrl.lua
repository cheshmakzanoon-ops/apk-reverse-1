local LWAllianceMilitaryPayMainCtrl = BaseClass("LWAllianceMilitaryPayMainCtrl", UIBaseCtrl)

function LWAllianceMilitaryPayMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWAllianceMilitaryPayMainView)
end

return LWAllianceMilitaryPayMainCtrl
