local MonsterInvasionBossDetailMessge = BaseClass("MonsterInvasionBossDetailMessge", SFSBaseMessage)
local base = SFSBaseMessage
local _uuid

local function OnCreate(self, serverId, uuid)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutLong("uuid", uuid)
  _uuid = uuid
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      t.uuid = _uuid
      DataCenter.MonsterProtectionManager:OnGetDetail(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

MonsterInvasionBossDetailMessge.OnCreate = OnCreate
MonsterInvasionBossDetailMessge.HandleMessage = HandleMessage
return MonsterInvasionBossDetailMessge
