local SeasonFishGetFishRankMessage = BaseClass("SeasonFishGetFishRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFishGetFishRankMessage:OnCreate(fishId)
  base.OnCreate(self)
  self.sfsObj:PutInt("fishId", fishId)
end

function SeasonFishGetFishRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FishingDataManager:HandleFishRank(t)
  end
end

return SeasonFishGetFishRankMessage
