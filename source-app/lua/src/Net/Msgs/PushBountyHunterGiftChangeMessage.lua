local PushBountyHunterGiftChangeMessage = BaseClass("PushBountyHunterGiftChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBountyHunterGiftChangeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBountyHunterGiftChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId then
    local actData = DataCenter.BountyHunterActDataManager:GetActData(t.activityId)
    if actData then
      actData:ClearEventShopDataDict()
      if t.eventShopKey then
        local eventShopData = t.eventShopKey
        for i, v in pairs(eventShopData) do
          actData:UpdateSingleEventShopData(v)
        end
      end
      EventManager:GetInstance():Broadcast(EventId.BountyHunterShopEventUpdate)
    end
  end
end

return PushBountyHunterGiftChangeMessage
