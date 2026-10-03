local ChatSendAlliacneGatherMessage = BaseClass("ChatSendAlliacneGatherMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, messageType, markType)
  base.OnCreate(self)
  self.sfsObj:PutInt("messageType", messageType)
  if markType then
    self.sfsObj:PutInt("markType", markType)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

ChatSendAlliacneGatherMessage.OnCreate = OnCreate
ChatSendAlliacneGatherMessage.HandleMessage = HandleMessage
return ChatSendAlliacneGatherMessage
