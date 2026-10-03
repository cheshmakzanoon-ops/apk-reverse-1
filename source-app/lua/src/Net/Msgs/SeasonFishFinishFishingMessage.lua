local SeasonFishFinishFishingMessage = BaseClass("SeasonFishFinishFishingMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFishFinishFishingMessage:OnCreate(serverId, pondId, color)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("pondId", pondId)
  self.sfsObj:PutInt("status", color)
end

function SeasonFishFinishFishingMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FishingDataManager:HandleFishingReelIn(t)
  end
end

return SeasonFishFinishFishingMessage
