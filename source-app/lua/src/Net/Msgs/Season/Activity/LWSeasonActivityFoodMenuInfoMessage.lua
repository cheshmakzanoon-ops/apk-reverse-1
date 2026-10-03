local LWSeasonActivityFoodMenuInfoMessage = BaseClass("LWSeasonActivityFoodMenuInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LWSeasonActivityFoodMenuInfoMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("act_id", activityId)
end

function LWSeasonActivityFoodMenuInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonFoodActivityDataManager:UpdateSeasonFoodData(t, true)
end

return LWSeasonActivityFoodMenuInfoMessage
