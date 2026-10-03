local ZombieRushActGetPlanInfoMessage = BaseClass("ZombieRushActGetPlanInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZombieRushActGetPlanInfoMessage:OnCreate(allianceId, needLevelRoleCount)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("allianceId", allianceId)
  self.sfsObj:PutBool("needLevelRoleCount", needLevelRoleCount)
end

function ZombieRushActGetPlanInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWZombieRushPlanInfoManager:UpdateActInfo(message)
    DataCenter.LWZombieRushPlanInfoManager:SetNeedLevelRoleCountValue(false)
  end
end

return ZombieRushActGetPlanInfoMessage
