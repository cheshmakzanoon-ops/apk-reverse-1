local SeasonPhotoSimpleAllViewMessage = BaseClass("SeasonPhotoSimpleAllViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPhotoSimpleAllViewMessage:OnCreate(param)
  base.OnCreate(self)
end

function SeasonPhotoSimpleAllViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local photoSimpleArr = t.photoSimpleArr
  if photoSimpleArr == nil or type(photoSimpleArr) ~= "table" then
    return
  end
  local dataList = {}
  for _, data in pairs(photoSimpleArr) do
    if data ~= nil and data.season ~= nil then
      table.insert(dataList, data)
    end
  end
  if dataList then
    table.sort(dataList, function(a, b)
      return a.season > b.season
    end)
    DataCenter.SeasonPhotoManager.hasSendAllView = true
    DataCenter.SeasonPhotoManager.photoSimpleArr = dataList
    EventManager:GetInstance():Broadcast(EventId.SeasonPhotoSimpleAllView)
  end
end

return SeasonPhotoSimpleAllViewMessage
