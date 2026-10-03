local PushRefundRestartMessage = BaseClass("PushRefundRestartMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushRefundRestartMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushRefundRestartMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local Localization = CS.GameEntry.Localization
    local tmpMsg = ""
    if DataCenter.LWRefundManager.CurRefundListPfType == RefundListPfType.GoldBlock then
      tmpMsg = Localization:GetString("refund_tips_goldbrick_reload")
    else
      tmpMsg = Localization:GetString("refund_tips_reload")
    end
    UIUtil.ShowMessage(tmpMsg, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      CS.ApplicationLaunch.Instance:ReloadGame()
    end, nil, function()
      CS.ApplicationLaunch.Instance:ReloadGame()
    end)
  end
end

return PushRefundRestartMessage
