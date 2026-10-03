local LWUIWorldBossDamageTipCtrl = BaseClass("LWUIWorldBossDamageTipCtrl", UIBaseCtrl)

function LWUIWorldBossDamageTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIWorldBossDamageTip)
end

return LWUIWorldBossDamageTipCtrl
