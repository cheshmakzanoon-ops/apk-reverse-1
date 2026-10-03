local GetCityAttachmentFreePointMessage = BaseClass("GetCityAttachmentFreePointMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCityAttachmentFreePointMessage:OnCreate(buildId)
  base.OnCreate(self)
  self.sfsObj:PutInt("buildId", buildId)
end

function GetCityAttachmentFreePointMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t == nil or t.buildId == nil or toInt(t.pointId) <= 0 then
    UIUtil.ShowTipsId("season_builders_alliance_tips_8")
    return
  end
  EventManager:GetInstance():Broadcast(EventId.CityAttachmentFreePointInfo, t)
end

return GetCityAttachmentFreePointMessage
