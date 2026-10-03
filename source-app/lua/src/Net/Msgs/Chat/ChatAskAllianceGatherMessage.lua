local ChatAskAllianceGatherMessage = BaseClass("ChatAskAllianceGatherMessage", SFSBaseMessage)
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

ChatAskAllianceGatherMessage.OnCreate = OnCreate
ChatAskAllianceGatherMessage.HandleMessage = HandleMessage
return ChatAskAllianceGatherMessage
