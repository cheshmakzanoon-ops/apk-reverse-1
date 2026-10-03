local LWUIWorldBossDamageTipCtrl = BaseClass("LWUIWorldBossDamageTipCtrl", UIBaseCtrl)

function LWUIWorldBossDamageTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWSeasonBossDamageTip)
end

return LWUIWorldBossDamageTipCtrl
