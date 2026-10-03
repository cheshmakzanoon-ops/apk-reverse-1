local SeasonFishLeaveFishPondMessage = BaseClass("SeasonFishLeaveFishPondMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFishLeaveFishPondMessage:OnCreate(serverId, pondId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("pondId", pondId)
end

function SeasonFishLeaveFishPondMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.success == 1 then
    DataCenter.FishingDataManager:HandleLeaveFishPond(t)
  end
end

return SeasonFishLeaveFishPondMessage
