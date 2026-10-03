local SeasonAllianceWarTimeStateTipsCtrl = BaseClass("SeasonAllianceWarTimeStateTipsCtrl", UIBaseCtrl)

function SeasonAllianceWarTimeStateTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonAllianceWarTimeStateTipsView)
end

return SeasonAllianceWarTimeStateTipsCtrl
