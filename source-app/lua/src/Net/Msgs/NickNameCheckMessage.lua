local NickNameCheckMessage = BaseClass("NickNameCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, nickName)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("nickName", nickName)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.reason ~= nil then
    local type = t.reason
    EventManager:GetInstance():Broadcast(EventId.NickNameChackEvent, type)
  end
end

NickNameCheckMessage.OnCreate = OnCreate
NickNameCheckMessage.HandleMessage = HandleMessage
return NickNameCheckMessage
