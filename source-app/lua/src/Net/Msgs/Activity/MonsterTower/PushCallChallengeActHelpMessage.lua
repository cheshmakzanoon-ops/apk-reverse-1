local PushCallChallengeActHelpMessage = BaseClass("PushCallChallengeActHelpMessage", SFSBaseMessage)
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
    DataCenter.ActMonsterTowerData:PushCallHelpHandel(t)
  end
end

PushCallChallengeActHelpMessage.OnCreate = OnCreate
PushCallChallengeActHelpMessage.HandleMessage = HandleMessage
return PushCallChallengeActHelpMessage
