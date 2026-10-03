local MonsterInvasionBossCanAttackMessge = BaseClass("MonsterInvasionBossCanAttackMessge", SFSBaseMessage)
local base = SFSBaseMessage
local _uuid

local function OnCreate(self, uuid, serverId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  if serverId then
    self.sfsObj:PutInt("serverId", serverId)
  end
  _uuid = uuid
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t == nil or t.errorCode == nil then
  else
    UIUtil.ShowTipsId(t.errorCode)
  end
end

MonsterInvasionBossCanAttackMessge.OnCreate = OnCreate
MonsterInvasionBossCanAttackMessge.HandleMessage = HandleMessage
return MonsterInvasionBossCanAttackMessge
