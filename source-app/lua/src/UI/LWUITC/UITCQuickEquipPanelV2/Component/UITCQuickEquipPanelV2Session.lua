local UITCQuickEquipPanelV2Session = {}
local RECOMMEND_PLAN_COUNT = 5

local function SortSlotDataList()
  local allSlotData = TacticalCardUtil.QuickGetAllSlotDataList()
  local slotArr = {}
  if not allSlotData then
    return slotArr
  end
  for _, slotData in pairs(allSlotData) do
    if slotData:IsCanEquipCard(false) then
      table.insert(slotArr, slotData)
    end
  end
  table.sort(slotArr, function(a, b)
    return a.slotId < b.slotId
  end)
  return slotArr
end

local function BuildCurrentEquipSnapshot()
  local cards = {}
  for _, slotData in ipairs(SortSlotDataList()) do
    local cardData = slotData:GetCardData()
    if cardData then
      local isCore = cardData:GetCardType() == TacticalCardType.Core
      if isCore then
      end
      cards[slotData.slotId] = {
        slotId = slotData.slotId,
        slotType = slotData:GetSlotType(),
        cardType = cardData:GetCardType(),
        cardId = cardData.cardId,
        uuid = cardData.uuid
      }
    end
  end
  return cards
end

local function BuildRecommendPlanByIndex(styleIndex)
  local ret = {}
  local quickEquipMap = TacticalCardUtil.GetCurQuickEquipCardList(styleIndex) or {}
  for _, slotData in ipairs(SortSlotDataList()) do
    local cardData = quickEquipMap[slotData.slotId]
    if cardData then
      ret[slotData.slotId] = {
        slotId = slotData.slotId,
        slotType = slotData:GetSlotType(),
        cardType = cardData:GetCardType(),
        cardId = cardData.cardId,
        uuid = cardData.uuid
      }
    end
  end
  return ret
end

local function ResolveRecommendStyleIndex(index)
  local realIndex = index
  local styleTypes = DataCenter.TacticalCardDataManager:GetCurSeasonQuickEquipStyleTypes() or {}
  if #styleTypes <= 0 then
    realIndex = 1
  elseif realIndex > #styleTypes then
    realIndex = (realIndex - 1) % #styleTypes + 1
  end
  return realIndex, styleTypes
end

local function GetAllCardsById(cardId)
  local result = {}
  local cardIdDic = DataCenter.TacticalCardDataManager.cardIdDic
  if not cardIdDic or not cardIdDic[cardId] then
    return result
  end
  for uuid, _ in pairs(cardIdDic[cardId]) do
    local cardData = DataCenter.TacticalCardDataManager:GetCardData(uuid)
    if cardData then
      table.insert(result, cardData)
    end
  end
  table.sort(result, function(a, b)
    local aPower = a:GetPower()
    local bPower = b:GetPower()
    if aPower ~= bPower then
      return aPower > bPower
    end
    return a.uuid < b.uuid
  end)
  return result
end

local function ResolvePlanCard(planCard, usedUuids)
  if not planCard then
    return nil
  end
  
  local function IsUsed(cardData)
    return usedUuids and cardData and usedUuids[cardData.uuid] == true
  end
  
  local function FindByCardId(cardId)
    if not cardId then
      return nil
    end
    for _, cardData in ipairs(GetAllCardsById(cardId)) do
      if cardData and not IsUsed(cardData) then
        return cardData
      end
    end
    return nil
  end
  
  if planCard.cardType == TacticalCardType.Core then
    return FindByCardId(planCard.cardId)
  end
  if planCard.uuid then
    local cardData = DataCenter.TacticalCardDataManager:GetCardData(planCard.uuid)
    if cardData and not IsUsed(cardData) then
      return cardData
    end
  end
  return FindByCardId(planCard.cardId)
end

local function CheckSlotOpsAndBuild(planCards)
  local putOnParams = {}
  local putOffSlots = {}
  local hasMissing = false
  local usedUuids = {}
  for _, slotData in ipairs(SortSlotDataList()) do
    local slotId = slotData.slotId
    local currentCard = slotData:GetCardData()
    local planCard = planCards[slotId]
    local targetCardData = ResolvePlanCard(planCard, usedUuids)
    if planCard and not targetCardData then
      hasMissing = true
    elseif targetCardData then
      usedUuids[targetCardData.uuid] = true
      if not slotData:IsCanEquipCard(true) then
        return false, hasMissing, nil, nil
      end
      if not currentCard or currentCard.uuid ~= targetCardData.uuid then
        table.insert(putOnParams, {
          uuid = targetCardData.uuid,
          slotId = slotId
        })
      end
    elseif currentCard then
      if not slotData:IsCanUnEquipCard(true) then
        return false, hasMissing, nil, nil
      end
      table.insert(putOffSlots, slotId)
    end
  end
  return true, hasMissing, putOnParams, putOffSlots
end

function UITCQuickEquipPanelV2Session.InitByCurrentEquip()
end

function UITCQuickEquipPanelV2Session.GetCustomPlanCount()
  return DataCenter.TacticalCardDataManager:GetCustomPlanCount()
end

function UITCQuickEquipPanelV2Session.SetPlanListChangedCallback(cb, owner)
  DataCenter.TacticalCardDataManager:SetCustomPlanChangedCallback(cb, owner)
end

function UITCQuickEquipPanelV2Session.ReqPlanList()
  DataCenter.TacticalCardDataManager:ReqCustomPlanList()
end

function UITCQuickEquipPanelV2Session.GetCustomPlan(index)
  return DataCenter.TacticalCardDataManager:GetCustomPlan(index)
end

function UITCQuickEquipPanelV2Session.SaveCurrentToCustom(index)
  DataCenter.TacticalCardDataManager:SaveCustomPlan(index, BuildCurrentEquipSnapshot())
end

function UITCQuickEquipPanelV2Session.GetRecommendPlanCount()
  return RECOMMEND_PLAN_COUNT
end

function UITCQuickEquipPanelV2Session.GetRecommendPlan(index)
  local realIndex, styleTypes = ResolveRecommendStyleIndex(index)
  local styleData = styleTypes[realIndex]
  local styleKey = styleData and styleData.sort_name or nil
  local styleName = styleKey
  if not string.IsNullOrEmpty(styleName) and CS.GameEntry and CS.GameEntry.Localization then
    local localized = CS.GameEntry.Localization:GetString(styleName)
    if not string.IsNullOrEmpty(localized) and localized ~= styleName then
      styleName = localized
    end
  end
  return {
    name = styleName,
    cards = BuildRecommendPlanByIndex(realIndex)
  }
end

function UITCQuickEquipPanelV2Session.GetMissingState(cards)
  local missing = false
  local missingBySlot = {}
  local usedUuids = {}
  for _, slotData in ipairs(SortSlotDataList()) do
    local slotId = slotData.slotId
    local planCard = cards and cards[slotId] or nil
    local targetCardData = ResolvePlanCard(planCard, usedUuids)
    if targetCardData then
      usedUuids[targetCardData.uuid] = true
    elseif planCard then
      missing = true
      missingBySlot[slotId] = true
    end
  end
  return missing, missingBySlot
end

function UITCQuickEquipPanelV2Session.TryInstall(cards)
  local ok, hasMissing, putOnParams, putOffSlots = CheckSlotOpsAndBuild(cards or {})
  if not ok then
    return false, hasMissing
  end
  if putOffSlots and 0 < #putOffSlots then
    SFSNetwork.SendMessage(MsgDefines.BattleCardPutOff, putOffSlots)
  end
  if putOnParams and 0 < #putOnParams then
    SFSNetwork.SendMessage(MsgDefines.BattleCardPutOn, putOnParams, true)
  end
  if (not putOffSlots or #putOffSlots == 0) and (not putOnParams or #putOnParams == 0) then
    UIUtil.ShowTips("\229\189\147\229\137\141\230\150\185\230\161\136\229\183\178\232\163\133\233\133\141")
  end
  return true, hasMissing
end

return UITCQuickEquipPanelV2Session
