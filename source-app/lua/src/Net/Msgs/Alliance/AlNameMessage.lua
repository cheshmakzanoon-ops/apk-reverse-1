local AlNameMessage = BaseClass("AlNameMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, name)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("name", name)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.result ~= nil then
    local exist = t.result
    EventManager:GetInstance():Broadcast(EventId.AllianceChangeNameSuccess, exist and CheckNameType.Exist or CheckNameType.None)
  end
end

AlNameMessage.OnCreate = OnCreate
AlNameMessage.HandleMessage = HandleMessage
return AlNameMessage
