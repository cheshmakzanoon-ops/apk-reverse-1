local UILWDispatchTaskLogCtrl = BaseClass("UILWDispatchTaskLogCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UILWDispatchTaskLogCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWDispatchTaskLog)
end

function UILWDispatchTaskLogCtrl:Close()
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

return UILWDispatchTaskLogCtrl
