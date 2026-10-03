local LWUIWorldBossTaskCtrl = BaseClass("LWUIWorldBossTaskCtrl", UIBaseCtrl)

function LWUIWorldBossTaskCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIWorldBossTask)
end

return LWUIWorldBossTaskCtrl
