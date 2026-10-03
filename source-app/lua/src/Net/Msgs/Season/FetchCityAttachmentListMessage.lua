local FetchCityAttachmentListMessage = BaseClass("FetchCityAttachmentListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchCityAttachmentListMessage:OnCreate()
  base.OnCreate(self)
end

function FetchCityAttachmentListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonFarmerManager:OnBuilderStateChange(t)
  EventManager:GetInstance():Broadcast(EventId.CityAttachmentInfoUpdate)
end

return FetchCityAttachmentListMessage
