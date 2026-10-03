local UIHeroRecruitWishCtrl = BaseClass("UIHeroRecruitWishCtrl", UIBaseCtrl)

function UIHeroRecruitWishCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroRecruitWish, {anim = false})
end

function UIHeroRecruitWishCtrl:ClearCache()
  self.selectCacheHeroId = nil
end

function UIHeroRecruitWishCtrl:GetFakeCurSelectHeroId(lotteryId)
  if self.selectCacheHeroId == nil then
    local lotteryInfo = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
    if lotteryInfo then
      return lotteryInfo:GetCurSelectWishHeroId()
    end
  end
  return self.selectCacheHeroId
end

function UIHeroRecruitWishCtrl:SetFakeCurSelectHeroId(lotteryId, heroId)
  if self.selectCacheHeroId ~= nil and self.selectCacheHeroId == heroId then
    return false
  end
  self.selectCacheHeroId = heroId
  return true
end

return UIHeroRecruitWishCtrl
