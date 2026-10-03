local UIDispatchTaskRecordCtrl = BaseClass("UIDispatchTaskRecordCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIDispatchTaskRecordCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIDispatchTaskRecord)
end

function UIDispatchTaskRecordCtrl:Close()
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

return UIDispatchTaskRecordCtrl
