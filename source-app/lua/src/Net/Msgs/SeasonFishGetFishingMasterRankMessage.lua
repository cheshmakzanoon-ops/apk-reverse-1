local SeasonFishGetFishingMasterRankMessage = BaseClass("SeasonFishGetFishingMasterRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFishGetFishingMasterRankMessage:OnCreate()
  base.OnCreate(self)
  self.sfsObj:PutInt("type", 2)
end

function SeasonFishGetFishingMasterRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FishingDataManager:HandleFishingMasterRank(t)
  end
end

return SeasonFishGetFishingMasterRankMessage
