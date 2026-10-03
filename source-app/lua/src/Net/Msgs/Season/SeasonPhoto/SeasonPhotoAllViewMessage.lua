local SeasonPhotoAllViewMessage = BaseClass("SeasonPhotoAllViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPhotoAllViewMessage:OnCreate()
  base.OnCreate(self)
end

function SeasonPhotoAllViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local manager = DataCenter.SeasonPhotoManager
  manager.hasSendAllView = true
  if t.photoArr then
    local SeasonPhotoInfo = require("DataCenter.SeasonPhoto.SeasonPhotoInfo")
    for i, v in ipairs(t.photoArr) do
      local data = SeasonPhotoInfo.New()
      data:UpdateData(v)
      manager.photoInfoDic[data.id] = data
    end
  end
  if t.userSeasonSettleRecordArr then
    local SeasonPhotoSettleRecordInfo = require("DataCenter.SeasonPhoto.SeasonPhotoSettleRecordInfo")
    for i, v in ipairs(t.userSeasonSettleRecordArr) do
      local data = SeasonPhotoSettleRecordInfo.New()
      data:UpdateData(v)
      manager.userSettleRecordDic[data.id] = data
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonPhotoAllView)
end

return SeasonPhotoAllViewMessage
