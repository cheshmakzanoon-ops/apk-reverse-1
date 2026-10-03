local LwSeasonCampTierRewardInfoMessage = BaseClass("LwSeasonCampTierRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwSeasonCampTierRewardInfoMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutBool("nextSeason", param == true)
end

function LwSeasonCampTierRewardInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonRewardDataManager:SeasonCampInfoUpdate(t)
  end
end

return LwSeasonCampTierRewardInfoMessage
