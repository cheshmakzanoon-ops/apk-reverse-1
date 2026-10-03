local PushMonsterInvasionBossPlanInfoMessage = BaseClass("PushMonsterInvasionBossPlanInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, planTime)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.planTime then
    DataCenter.ActivityMonsterInvasionDataManager:UpdateBossPlanTime(t.planTime)
    EventManager:GetInstance():Broadcast(EventId.AisillaPlanTimeChange)
  end
end

PushMonsterInvasionBossPlanInfoMessage.OnCreate = OnCreate
PushMonsterInvasionBossPlanInfoMessage.HandleMessage = HandleMessage
return PushMonsterInvasionBossPlanInfoMessage
