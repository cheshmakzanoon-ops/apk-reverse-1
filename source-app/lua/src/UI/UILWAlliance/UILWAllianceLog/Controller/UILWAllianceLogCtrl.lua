local UILWAllianceLogCtrl = BaseClass("UILWAllianceLogCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UILWAllianceLogCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWAllianceLog)
end

function UILWAllianceLogCtrl:Close()
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

function UILWAllianceLogCtrl:ReqMore(lastTime, pageId)
  SFSNetwork.SendMessage(MsgDefines.ViewAllianceLog, lastTime, false, pageId)
end

return UILWAllianceLogCtrl
