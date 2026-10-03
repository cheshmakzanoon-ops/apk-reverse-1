local PushDigTreasureGetHammerMessage = BaseClass("PushDigTreasureGetHammerMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushDigTreasureGetHammerMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushDigTreasureGetHammerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local playerInfo = t.playerInfo
    if playerInfo then
      EventManager:GetInstance():Broadcast(EventId.DigTreasureGetHelp, playerInfo)
    end
    local bIsMax = t.isHammerGetMax == 1
    DataCenter.DigTreasureManager:UpdateHelpTimesIsMax(bIsMax)
  end
end

return PushDigTreasureGetHammerMessage
