local LWCommonHeroCardShowCtrl = BaseClass("LWCommonHeroCardShowCtrl", UIBaseCtrl)

function LWCommonHeroCardShowCtrl:CloseSelf(activityId)
  if activityId then
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
    if activityInfo then
      local plotGroupId = tonumber(activityInfo.para)
      if plotGroupId then
        EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = 2094})
      end
    end
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWCommonHeroCardShow)
end

return LWCommonHeroCardShowCtrl
