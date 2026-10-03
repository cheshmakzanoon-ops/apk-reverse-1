local ZombieRushActGetPlayerListMessage = BaseClass("ZombieRushActGetPlayerListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZombieRushActGetPlayerListMessage:OnCreate(Id, allianceId)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", Id)
  self.sfsObj:PutUtfString("allianceId", allianceId)
end

function ZombieRushActGetPlayerListMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWZombieRushPlanInfoManager:UpdateActInfo(message)
    EventManager:GetInstance():Broadcast(EventId.UpdateZombieRushOpenPlayerPop, message.canBeAttackUserInfo)
  end
end

return ZombieRushActGetPlayerListMessage
