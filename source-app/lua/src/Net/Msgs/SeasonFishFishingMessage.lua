local SeasonFishFishingMessage = BaseClass("SeasonFishFishingMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFishFishingMessage:OnCreate(serverId, pondId, senior, multiThread)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("pondId", pondId)
  self.sfsObj:PutInt("senior", senior or 0)
  self.sfsObj:PutInt("multiThread", multiThread and 1 or 0)
end

function SeasonFishFishingMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FishingDataManager:HandleFishingCast(t)
  end
end

return SeasonFishFishingMessage
