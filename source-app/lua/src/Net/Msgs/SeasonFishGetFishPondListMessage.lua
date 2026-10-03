local SeasonFishGetFishPondListMessage = BaseClass("SeasonFishGetFishPondListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFishGetFishPondListMessage:OnCreate(type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

function SeasonFishGetFishPondListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FishingDataManager:HandlePondList(t)
  end
end

return SeasonFishGetFishPondListMessage
