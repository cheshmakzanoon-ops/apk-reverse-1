local ZombieRushActDelPlanInfoMessage = BaseClass("ZombieRushActDelPlanInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZombieRushActDelPlanInfoMessage:OnCreate(Id)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", Id)
end

function ZombieRushActDelPlanInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

return ZombieRushActDelPlanInfoMessage
