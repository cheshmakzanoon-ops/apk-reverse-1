local LWUIGoldTreeRecordCtrl = BaseClass("LWUIGoldTreeRecordCtrl", UIBaseCtrl)

function LWUIGoldTreeRecordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGoldTreeRecord)
end

function LWUIGoldTreeRecordCtrl:OnCustomKeyCodeEscape()
  EventManager:GetInstance():Broadcast(EventId.LWUIGoldTreeRecordESC)
end

return LWUIGoldTreeRecordCtrl
