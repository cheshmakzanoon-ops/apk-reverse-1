local GoldTreeGetAllianceCardViewMessage = BaseClass("GoldTreeGetAllianceCardViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GoldTreeGetAllianceCardViewMessage:OnCreate(weekTime)
  base.OnCreate(self)
  self.sfsObj:PutLong("weekTime", weekTime)
end

function GoldTreeGetAllianceCardViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.GoldTreeThirdError, MsgDefines.GoldTreeGetAllianceCardView)
    return
  end
  DataCenter.SeasonGoldTreeThirdManager:GoldTreeGetAllianceCardViewMessage(t)
end

return GoldTreeGetAllianceCardViewMessage
