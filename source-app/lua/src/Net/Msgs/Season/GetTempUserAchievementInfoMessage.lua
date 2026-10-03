local GetTempUserAchievementInfoMessage = BaseClass("GetTempUserAchievementInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetTempUserAchievementInfoMessage:OnCreate()
  base.OnCreate(self)
end

function GetTempUserAchievementInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.list then
    DataCenter.SeasonDataManager.theUserAchievementInfo = t.list
    local theSeasonType = SeasonUtil.GetSeasonType()
    if theSeasonType == SeasonMapType.Snow then
      DataCenter.TemperatureManager:HandleAchieve(t.list)
    elseif theSeasonType == SeasonMapType.Mummy then
      EventManager:GetInstance():Broadcast(EventId.GetMummyAchievementInfo, t.list)
    elseif theSeasonType == SeasonMapType.Darkness then
      EventManager:GetInstance():Broadcast(EventId.GetDarknessAchievementInfo, t.list)
    elseif theSeasonType == SeasonMapType.NineNation then
      EventManager:GetInstance():Broadcast(EventId.GetNineNationAchievementInfo, t.list)
    else
      EventManager:GetInstance():Broadcast(EventId.GetAchievementInfo, t.list)
    end
  end
end

return GetTempUserAchievementInfoMessage
