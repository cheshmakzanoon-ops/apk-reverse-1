local DominatorCheckEditUserNameMessage = BaseClass("DominatorCheckEditUserNameMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutUtfString("name", param.name)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.reason ~= nil then
    local type = t.reason
    EventManager:GetInstance():Broadcast(EventId.DominatorCheckEditUserNameSuccess, type)
  end
end

DominatorCheckEditUserNameMessage.OnCreate = OnCreate
DominatorCheckEditUserNameMessage.HandleMessage = HandleMessage
return DominatorCheckEditUserNameMessage
