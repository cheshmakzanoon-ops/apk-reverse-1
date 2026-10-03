local UpgradeHeroAwakenMessage = BaseClass("UpgradeHeroAwakenMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UpgradeHeroAwakenMessage:OnCreate(heroUuid, useCommonItem)
  base.OnCreate(self)
  self.sfsObj:PutLong("heroUuid", heroUuid)
  self.sfsObj:PutBool("exchange", useCommonItem)
end

function UpgradeHeroAwakenMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HeroDataManager:UpdateOneHero(t.hero)
    if t.hero and t.hero.uuid then
      local heroUuid = t.hero.uuid
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData then
        local isUnlocking = heroData:GetHeroAwakenRankLevel() == 1
        if isUnlocking then
          UIManager:GetInstance():OpenWindow(UIWindowNames.HeroAwakenUpgradeStarEffect, {anim = false}, heroData:GetHeroAwakenRankLevel(), heroData, function()
            EventManager:GetInstance():Broadcast(EventId.HeroAwakenUpgradeSuccess, heroUuid)
            EventManager:GetInstance():Broadcast(EventId.HeroDetailPanelRefreshArrowPosition)
            EventManager:GetInstance():Broadcast(EventId.HeroDetailPanelReloadHeroSpine)
          end)
          EventManager:GetInstance():Broadcast(EventId.HeroModelChange, heroData.heroId)
        else
          EventManager:GetInstance():Broadcast(EventId.HeroAwakenUpgradeSuccess, heroUuid)
          EventManager:GetInstance():Broadcast(EventId.HeroDetailPanelRefreshArrowPosition)
          EventManager:GetInstance():Broadcast(EventId.HeroDetailPanelReloadHeroSpine)
          if heroData:IsHeroAwakenReachMaxLevel() then
            EventManager:GetInstance():Broadcast(EventId.HeroModelChange, heroData.heroId)
          end
        end
      else
        Logger.LogError("UpgradeHeroAwakenMessage:HandleMessage heroData is nil, uuid:" .. tostring(heroUuid))
      end
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Hero_Upgrade3, false)
  end
end

return UpgradeHeroAwakenMessage
