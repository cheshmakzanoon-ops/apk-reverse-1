local DispatchPutPointInWorldMessage = BaseClass("DispatchPutPointInWorldMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function DispatchPutPointInWorldMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function DispatchPutPointInWorldMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActDispatchTaskDataManager:UpdateOneSingleTask(message, true)
    EventManager:GetInstance():Broadcast(EventId.DispatchGetRealPoint, message.uuid)
  end
end

return DispatchPutPointInWorldMessage
