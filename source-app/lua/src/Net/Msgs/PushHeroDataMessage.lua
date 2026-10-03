local PushHeroDataMessage = BaseClass("PushHeroDataMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  local newHero = false
  local isLevelUp = false
  local isMaster = false
  if message.uuid ~= nil then
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(message.uuid)
    if heroData == nil then
      newHero = true
      isLevelUp = false
    else
      local oldLevel = heroData.level
      local newLevel = message.lev
      if newLevel ~= nil and oldLevel < newLevel then
        isLevelUp = true
      end
    end
  end
  DataCenter.HeroDataManager:UpdateOneHero(message)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(message.uuid)
  isMaster = heroData.isMaster
  if not HeroUtils.IsInTheLottery then
    EventManager:GetInstance():Broadcast(EventId.CheckPubBubble, true)
  end
  if newHero then
    if not isMaster or DataCenter.BattleLevel:IsInBattleLevel() and DataCenter.GuideManager:InGuide() then
    else
      local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroRecruit)
      local heroQualityRecruitWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroQualityRecruit)
      local isInBattle = UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIParkourBattleMain) or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIZombieBattleMain)
      if message.addAction == "VisitorRecruit" then
        UIUtil.ShowTipsId(110276)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.HeroExChange)
  end
  if isLevelUp then
    EventManager:GetInstance():Broadcast(EventId.HeroLevelUpgrade)
  end
end

PushHeroDataMessage.OnCreate = OnCreate
PushHeroDataMessage.HandleMessage = HandleMessage
return PushHeroDataMessage
