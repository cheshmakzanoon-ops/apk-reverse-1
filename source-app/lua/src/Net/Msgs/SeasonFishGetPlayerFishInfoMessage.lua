local SeasonFishGetPlayerFishInfoMessage = BaseClass("SeasonFishGetPlayerFishInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFishGetPlayerFishInfoMessage:OnCreate()
  base.OnCreate(self)
end

function SeasonFishGetPlayerFishInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FishingDataManager:HandleMyFishList(t)
  end
end

return SeasonFishGetPlayerFishInfoMessage
