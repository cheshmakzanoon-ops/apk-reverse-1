local RedPoint = BaseClass("SeasonGroup", RedPointGroup)
local activityRedPointDefs = {
  [EnumActivity.BattlePass_new.Type] = RedDef.SeasonBattlePass,
  [EnumActivity.CounterAttack.Type] = RedDef.SeasonCounterAttack,
  [EnumActivity.ActHeroPromotion.Type] = RedDef.SeasonHeroPromotion,
  [EnumActivity.SeasonPeriodicCard.Type] = RedDef.SeasonWeekCard,
  [EnumActivity.SeasonPhoto.Type] = RedDef.SeasonPhoto,
  [EnumActivity.VirusResearch.Type] = RedDef.VirusResearch,
  [EnumActivity.BossLogin.Type] = RedDef.BossLogin,
  [EnumActivity.SeasonPreview.Type] = RedDef.SeasonPreview,
  [EnumActivity.ActivityTetris.Type] = RedDef.SeasonActivityTetris,
  [EnumActivity.SeasonCrossAttackCityActivity.Type] = RedDef.SeasonCrossAttackCity,
  [EnumActivity.SeasonCrossDeclareWarActivity.Type] = RedDef.SeasonCrossDeclareWar,
  [EnumActivity.SeasonNuclearPowerPlantActivity.Type] = RedDef.SeasonNuclearPowerPlant,
  [EnumActivity.SnowStormComing.Type] = RedDef.SeasonSnowStormComing,
  [EnumActivity.DiggingGame.Type] = RedDef.SeasonDiggingGame,
  [EnumActivity.SeasonGreen.Type] = RedDef.SeasonGreen,
  [EnumActivity.SandWormHunt.Type] = RedDef.SeasonSandWormHunt,
  [EnumActivity.BloodyNight.Type] = RedDef.SeasonBloodyNight,
  [EnumActivity.GoldTree.Type] = RedDef.SeasonGoldTree,
  [EnumActivity.SeasonLastWar.Type] = RedDef.SeasonLastWar,
  [EnumActivity.SeasonWarZoneOutpostAttack.Type] = RedDef.SeasonWarZoneOutpostAttack,
  [EnumActivity.SeasonBountyShop.Type] = RedDef.SeasonBountyShop,
  [EnumActivity.Season6CampDestroy.Type] = RedDef.Season6CampDestroy,
  [EnumActivity.SeasonCityAltar.Type] = RedDef.SeasonCityAltar,
  [EnumActivity.SeasonMilitary.Type] = RedDef.SeasonMilitary
}
ActivityRedPointDefs = ConstClass("ActivityRedPointDefs", activityRedPointDefs)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.OnPassDay, self.SetData)
end

function RedPoint:RegisterEvent()
  if self.hasRegistered then
    return
  end
  self.hasRegistered = true
  self:AddListener(EventId.OpenUI, self.OpenUI)
  self:AddListener(EventId.CloseUI, self.OnCloseUI)
end

function RedPoint:SetData()
  self:Reset()
  if not SeasonUtil.IsInSeason() and not SeasonUtil.IsInSeasonPrepareMode() then
    self:RemoveAllChild()
    return
  end
  self:RegisterEvent()
  for activityType, nodeType in pairs(ActivityRedPointDefs) do
    self:InitByActivityData(activityType)
  end
  self:GetOrAddOnlyChild(RedDef.SeasonMainTab)
end

function RedPoint:OpenUI(uiName)
  if string.startswith(uiName, "LWSeason") then
    EventManager:GetInstance():Broadcast(EventId.SeasonMainViewOpen)
  end
end

function RedPoint:OnCloseUI(uiName)
  if string.startswith(uiName, "LWSeason") then
    EventManager:GetInstance():Broadcast(EventId.SeasonMainViewClose)
  end
end

function RedPoint:InitByActivityData(activityType)
  self:AddListenerWithParam(EventId.ActivityOneDataUpdate, activityType, self.ActivityOneDataUpdate)
  local list = DataCenter.ActivityListDataManager:GetActivityList()
  for _, data in pairs(list) do
    if data.type == activityType then
      self:ActivityOneDataUpdate(activityType, data.id)
    end
  end
end

function RedPoint:ActivityOneDataUpdate(activityType, activityId)
  local nodeType = ActivityRedPointDefs[activityType]
  if nodeType then
    local data = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
    if data and data:IsActivityForSeason() then
      self:GetOrAddChild(nodeType, activityId, activityId)
    end
  end
end

return RedPoint
