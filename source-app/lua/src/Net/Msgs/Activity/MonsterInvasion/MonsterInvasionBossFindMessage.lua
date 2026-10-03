local MonsterInvasionBossFindMessage = BaseClass("MonsterInvasionBossFindMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityMonsterInvasionDataManager:OnInvasionBossPointGot(t.point)
  end
end

MonsterInvasionBossFindMessage.OnCreate = OnCreate
MonsterInvasionBossFindMessage.HandleMessage = HandleMessage
return MonsterInvasionBossFindMessage
