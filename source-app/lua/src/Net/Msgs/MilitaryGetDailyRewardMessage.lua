local MilitaryGetDailyRewardMessage = BaseClass("MilitaryGetDailyRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MilitaryGetDailyRewardMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("viewLevel", param.level)
end

function MilitaryGetDailyRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t ~= nil then
    DataCenter.SeasonMilitaryManager:OnClaimDailyCallback(t)
  end
end

return MilitaryGetDailyRewardMessage
