local CityCompetitionS0CityClueUnlockRewardMessage = BaseClass("CityCompetitionS0CityClueUnlockRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityCompetitionS0CityClueUnlockRewardMessage:OnCreate(configId)
  base.OnCreate(self)
  self.sfsObj:PutInt("configId", configId)
end

function CityCompetitionS0CityClueUnlockRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return CityCompetitionS0CityClueUnlockRewardMessage
