local DispatchStartMessage = BaseClass("DispatchStartMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function DispatchStartMessage:OnCreate(uuid, heroList, marchDuration)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutLongArray("heroList", heroList)
  self.sfsObj:PutLong("marchDuration", marchDuration + 500)
end

function DispatchStartMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif message.data then
    DataCenter.ActDispatchTaskDataManager:UpdateOneSingleTask(message.data, true)
    DataCenter.ActDispatchTaskFakeMarchManager:AddMarchIndex(message.data.pointId, LuaEntry.Player:GetMainWorldPos(), false)
    if message.data.uuid then
      DataCenter.InteractionBubbleManager:HandleDispatchStartMessage(message.data.uuid)
    end
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

return DispatchStartMessage
