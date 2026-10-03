local ZombieRushActSetPlanLevelMessage = BaseClass("ZombieRushActSetPlanLevelMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZombieRushActSetPlanLevelMessage:OnCreate(Id, planLevel)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", Id)
  self.sfsObj:PutInt("planLevel", planLevel)
end

function ZombieRushActSetPlanLevelMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

return ZombieRushActSetPlanLevelMessage
