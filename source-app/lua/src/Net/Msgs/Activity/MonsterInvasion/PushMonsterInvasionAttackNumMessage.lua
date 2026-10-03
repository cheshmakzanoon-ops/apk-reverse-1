local PushMonsterInvasionAttackNumMessage = BaseClass("PushMonsterInvasionAttackNumMessage", SFSBaseMessage)
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
    DataCenter.ActivityMonsterInvasionDataManager:UpdateAttackNum(t)
  end
end

PushMonsterInvasionAttackNumMessage.OnCreate = OnCreate
PushMonsterInvasionAttackNumMessage.HandleMessage = HandleMessage
return PushMonsterInvasionAttackNumMessage
