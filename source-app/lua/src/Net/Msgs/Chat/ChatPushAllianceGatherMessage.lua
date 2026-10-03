local ChatPushAllianceGatherMessage = BaseClass("ChatPushAllianceGatherMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, messageType)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWChatPinManager:HandlePinMsg(t)
  end
end

ChatPushAllianceGatherMessage.OnCreate = OnCreate
ChatPushAllianceGatherMessage.HandleMessage = HandleMessage
return ChatPushAllianceGatherMessage
