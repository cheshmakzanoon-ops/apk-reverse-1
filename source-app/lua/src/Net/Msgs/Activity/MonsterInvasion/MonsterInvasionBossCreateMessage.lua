local MonsterInvasionBossCreateMessage = BaseClass("MonsterInvasionBossCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, point, planTime)
  base.OnCreate(self)
  self.sfsObj:PutInt("point", point)
  if planTime then
    self.sfsObj:PutLong("planTime", planTime)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    PostEventLog.Track(PostEventLog.Defines.InvasionAisillaSummoned, {})
  end
end

MonsterInvasionBossCreateMessage.OnCreate = OnCreate
MonsterInvasionBossCreateMessage.HandleMessage = HandleMessage
return MonsterInvasionBossCreateMessage
