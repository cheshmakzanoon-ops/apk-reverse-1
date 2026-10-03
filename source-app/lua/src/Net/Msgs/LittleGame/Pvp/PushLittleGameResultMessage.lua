local PushLittleGameResultMessage = BaseClass("PushLittleGameResultMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, speak, cost)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local room = DataCenter.LWGGGoDataManager:GetRoom()
    room:Result(t)
  end
end

PushLittleGameResultMessage.OnCreate = OnCreate
PushLittleGameResultMessage.HandleMessage = HandleMessage
return PushLittleGameResultMessage
