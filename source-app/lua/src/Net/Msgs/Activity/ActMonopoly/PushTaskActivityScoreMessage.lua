local PushTaskActivityScoreMessage = BaseClass("PushTaskActivityScoreMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActTaskManager:UpdateActScore(t)
  end
end

PushTaskActivityScoreMessage.OnCreate = OnCreate
PushTaskActivityScoreMessage.HandleMessage = HandleMessage
return PushTaskActivityScoreMessage
