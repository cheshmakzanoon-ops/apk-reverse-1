local SeasonFishGetConfiscateRecordsMessage = BaseClass("SeasonFishGetConfiscateRecordsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFishGetConfiscateRecordsMessage:OnCreate()
  base.OnCreate(self)
end

function SeasonFishGetConfiscateRecordsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FishingDataManager:HandleConfiscateRecords(t)
  end
end

return SeasonFishGetConfiscateRecordsMessage
