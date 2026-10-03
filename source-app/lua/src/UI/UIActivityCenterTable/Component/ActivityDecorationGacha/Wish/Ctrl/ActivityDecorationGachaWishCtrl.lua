local ActivityDecorationGachaWishCtrl = BaseClass("ActivityDecorationGachaWishCtrl", UIBaseCtrl)

function ActivityDecorationGachaWishCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityDecorationGachaWish)
end

function ActivityDecorationGachaWishCtrl:ClearCurSelectWishData()
  self.wishData = nil
end

function ActivityDecorationGachaWishCtrl:GetCurSelectWishData(activityId)
  if self.wishData == nil then
    local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(activityId)
    if activityData ~= nil then
      local realData = activityData:GetCurSelectWishData()
      return realData
    end
  end
  return self.wishData
end

function ActivityDecorationGachaWishCtrl:GetRealCurSelectWishData()
  return self.wishData
end

function ActivityDecorationGachaWishCtrl:SetCurSelectWishData(wishData)
  if wishData == nil then
    return false
  end
  if self.wishData == nil then
    self.wishData = wishData
    return true
  end
  if self.wishData.itemId ~= wishData.itemId or self.wishData.count ~= wishData.count then
    self.wishData = wishData
    return true
  end
  UIUtil.ShowTipsId("decoration_recruit_desc47")
  return false
end

return ActivityDecorationGachaWishCtrl
