local LWUIWorldBossRecordCtrl = BaseClass("LWUIWorldBossRecordCtrl", UIBaseCtrl)

function LWUIWorldBossRecordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIWorldBossRecord)
end

return LWUIWorldBossRecordCtrl
