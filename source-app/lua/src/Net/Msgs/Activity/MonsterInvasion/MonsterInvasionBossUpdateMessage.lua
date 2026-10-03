local MonsterInvasionBossUpdateMessage = BaseClass("MonsterInvasionBossUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, planTime)
  base.OnCreate(self)
  self.sfsObj:PutLong("planTime", planTime)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.planTime then
    DataCenter.ActivityMonsterInvasionDataManager:UpdateBossPlanTime(t.planTime)
  end
end

MonsterInvasionBossUpdateMessage.OnCreate = OnCreate
MonsterInvasionBossUpdateMessage.HandleMessage = HandleMessage
return MonsterInvasionBossUpdateMessage
