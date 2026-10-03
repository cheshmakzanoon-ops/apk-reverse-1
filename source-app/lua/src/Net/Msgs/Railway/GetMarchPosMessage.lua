local GetMarchPosMessage = BaseClass("GetMarchPosMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, serverId, worldId, marchUuid, marchType)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("worldId", worldId or 0)
  self.sfsObj:PutLong("marchUuid", marchUuid)
  self.sfsObj:PutInt("marchType", marchType or 2)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
  GoToUtil.MoveToWorldMarchAndOpen(message.positionId, message.marchUuid, message.serverId, message.worldId)
end

GetMarchPosMessage.OnCreate = OnCreate
GetMarchPosMessage.HandleMessage = HandleMessage
return GetMarchPosMessage
