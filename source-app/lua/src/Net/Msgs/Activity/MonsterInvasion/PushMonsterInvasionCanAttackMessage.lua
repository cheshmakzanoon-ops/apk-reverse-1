local PushMonsterInvasionCanAttackMessage = BaseClass("PushMonsterInvasionCanAttackMessage", SFSBaseMessage)
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
    t.isProtected = false
    DataCenter.MonsterProtectionManager:OnGetDetail(t)
  end
end

PushMonsterInvasionCanAttackMessage.OnCreate = OnCreate
PushMonsterInvasionCanAttackMessage.HandleMessage = HandleMessage
return PushMonsterInvasionCanAttackMessage
