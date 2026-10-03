local UIGhostreconRecordCtrl = BaseClass("UIGhostreconRecordCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIGhostreconRecordCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIGhostreconRecord)
end

function UIGhostreconRecordCtrl:Close()
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

return UIGhostreconRecordCtrl
