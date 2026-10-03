local KingPowerCtrl = BaseClass("KingPowerCtrl", UIBaseCtrl)

function KingPowerCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentKingPower)
end

return KingPowerCtrl
