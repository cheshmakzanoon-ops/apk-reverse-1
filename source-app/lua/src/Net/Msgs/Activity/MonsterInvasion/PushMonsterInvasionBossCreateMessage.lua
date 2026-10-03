local PushMonsterInvasionBossCreateMessage = BaseClass("PushMonsterInvasionBossCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, point)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityMonsterInvasionDataManager:SetAisillaChallengeInfo(t)
  end
end

PushMonsterInvasionBossCreateMessage.OnCreate = OnCreate
PushMonsterInvasionBossCreateMessage.HandleMessage = HandleMessage
return PushMonsterInvasionBossCreateMessage
