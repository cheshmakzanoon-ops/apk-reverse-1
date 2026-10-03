local GetActivityPreviewInfoMessage = BaseClass("GetActivityPreviewInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetActivityPreviewInfoMessage:OnCreate(idList, clientPara)
  base.OnCreate(self)
  self.sfsObj:PutIntArray("activityIds", idList)
  if not string.IsNullOrEmpty(clientPara) then
    self.sfsObj:PutUtfString("clientPara", clientPara)
  end
end

function GetActivityPreviewInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if nil == t.errorCode and t.pre_infos and table.count(t.pre_infos) > 0 then
    local clientPara = t.clientPara
    if string.IsNullOrEmpty(clientPara) then
      local seasonActivity = DataCenter.SeasonDataManager.seasonActivity or {}
      for k, v in pairs(t.pre_infos) do
        v.startTime = v.start * 1000
        v.previewTime = v.startTime - v.pre * OneHourTime * 1000
        seasonActivity[tostring(v.id)] = v
      end
      DataCenter.SeasonDataManager.seasonActivity = seasonActivity
      DataCenter.SeasonDataManager.ActivityPreviewInfos = seasonActivity
    elseif clientPara == PreviewActivityType.OffSeason then
      local seasonActivity = {}
      for k, v in pairs(t.pre_infos) do
        v.startTime = v.start * 1000
        v.previewTime = v.startTime - v.pre * OneHourTime * 1000
        seasonActivity[tostring(v.id)] = v
      end
      DataCenter.SeasonDataManager.OffSeasonActivityPreviewInfos = seasonActivity
      EventManager:GetInstance():Broadcast(EventId.PreviewActivityOffSeasonGet)
    end
  end
end

return GetActivityPreviewInfoMessage
