local SeasonFishEnterFishPondMessage = BaseClass("SeasonFishEnterFishPondMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFishEnterFishPondMessage:OnCreate(serverId, pondId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("pondId", pondId)
end

function SeasonFishEnterFishPondMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.FishingDataManager:SetEnterPondFinished()
  elseif t.success == 1 then
    DataCenter.FishingDataManager:HandleEnterFishPond(t)
  end
end

return SeasonFishEnterFishPondMessage
