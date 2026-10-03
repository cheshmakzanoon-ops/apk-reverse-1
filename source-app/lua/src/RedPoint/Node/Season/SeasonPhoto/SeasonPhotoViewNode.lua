local RedPoint = BaseClass("SeasonPhotoViewNode", RedPointNode)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.SeasonPhotoViewOpen, self.SeasonPhotoViewOpen)
end

function RedPoint:__delete()
end

function RedPoint:SetData(activityId)
  self.activityId = tostring(activityId)
  self:Refresh()
end

function RedPoint:Refresh(updateIt)
  local count = UIUtil.GetActiveCount(DataCenter.SeasonDataManager:GetSeasonStartTime(), "PhotoSeason" .. (self.activityId or "-"), updateIt)
  self:SetCountBoolean(count <= 0)
end

function RedPoint:SeasonPhotoViewOpen(activityId)
  if self.activityId ~= tostring(activityId) then
    return
  end
  local redCountOld = self:GetCount()
  self:Refresh(true)
  self:SetCountBoolean(false)
  if redCountOld ~= self:GetCount() then
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
  end
  self:RemoveListener(EventId.SeasonPhotoViewOpen, self.SeasonPhotoViewOpen)
end

return RedPoint
