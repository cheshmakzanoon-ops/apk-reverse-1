local AllianceSalaryRankMessage = BaseClass("AllianceSalaryRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceSalaryRankMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceSalaryRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.OnAllianceMilitaryPayGetRankInfo, t)
  end
end

return AllianceSalaryRankMessage
