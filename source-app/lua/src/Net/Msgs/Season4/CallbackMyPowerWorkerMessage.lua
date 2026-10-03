local CallbackMyPowerWorkerMessage = BaseClass("CallbackMyPowerWorkerMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CallbackMyPowerWorkerMessage:OnCreate(workerUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("workerUuid", workerUuid)
end

function CallbackMyPowerWorkerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.FetchPowerWorkerDetail)
end

return CallbackMyPowerWorkerMessage
