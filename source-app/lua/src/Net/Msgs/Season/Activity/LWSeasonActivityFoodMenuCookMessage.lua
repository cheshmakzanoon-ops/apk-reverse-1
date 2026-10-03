local LWSeasonActivityFoodMenuCookMessage = BaseClass("LWSeasonActivityFoodMenuCookMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LWSeasonActivityFoodMenuCookMessage:OnCreate(activityId, items)
  base.OnCreate(self)
  self.sfsObj:PutInt("act_id", toInt(activityId))
  self.sfsObj:PutIntArray("foods", items)
end

function LWSeasonActivityFoodMenuCookMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonFoodActivityDataManager:UpdateSeasonFoodCookData(t)
end

return LWSeasonActivityFoodMenuCookMessage
