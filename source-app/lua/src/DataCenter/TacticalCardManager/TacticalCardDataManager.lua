local TacticalCardDataManager = BaseClass("TacticalCardDataManager")
local TacticalCardData = require("DataCenter.TacticalCardManager.TacticalCardData")
local BattleCardTemplate = require("DataCenter.TacticalCardManager.Template.BattleCardTemplate")
local BattleCardStarTemplate = require("DataCenter.TacticalCardManager.Template.BattleCardStarTemplate")
local BattleCardLevelTemplate = require("DataCenter.TacticalCardManager.Template.BattleCardLevelTemplate")
local BattleCardSkillTemplate = require("DataCenter.TacticalCardManager.Template.BattleCardSkillTemplate")
local BattleCardBoxTemplate = require("DataCenter.TacticalCardManager.Template.BattleCardBoxTemplate")
local BattleCardRandomAttrShowTemplate = require("DataCenter.TacticalCardManager.Template.BattleCardRandomAttrShowTemplate")
local TacticalCardCustomPresetData = require("DataCenter.TacticalCardManager.TacticalCardCustomPresetData")
local TacticalCardRecommendPresetData = require("DataCenter.TacticalCardManager.TacticalCardRecommendPresetData")
local ArmyFormationUtils = require("DataCenter.ArmyFormationData.ArmyFormationUtils")

local function __init(self)
  self.allCardDataDic = {}
  self.curEquipCardDic = {}
  self.allCoreCardDataDic = {}
  self.allIdleCardDic = {}
  self.cardIdDic = {}
  self.cardCollections = {}
  self.cardBookData = {}
  self.templateData = {}
  self.starTemplateData = {}
  self.lvTemplateData = {}
  self.skillTemplateData = {}
  self.hasRequestCardBookData = false
end

local function __delete(self)
  self.allCardDataDic = nil
  self.curEquipCardDic = nil
  self.allIdleCardDic = nil
  self.cardIdDic = nil
  self.cardCollections = nil
  self.cardBookData = nil
  self.allCoreCardDataDic = nil
  self.templateData = nil
  self.starTemplateData = nil
  self.lvTemplateData = nil
  self.skillTemplateData = nil
  self.hasRequestCardBookData = nil
  self.randomAttributeShowTemplateDic = nil
  self.cardSkillUseInfoList = nil
  self.customPresetData = nil
  self.recommendPresetData = nil
end

function TacticalCardDataManager:InitData(t)
  self:InitMessage(t)
end

function TacticalCardDataManager:InitMessage(msg)
  self.allCardDataDic = {}
  self.curEquipCardDic = {}
  self.allCoreCardDataDic = {}
  self.allIdleCardDic = {}
  self.cardIdDic = {}
  self.cardCollections = {}
  self.cardBookData = {}
  self.hasRequestCardBookData = false
  self.customPresetData = TacticalCardCustomPresetData.New()
  self.recommendPresetData = TacticalCardRecommendPresetData.New()
  self:UpdateCardCollections(msg.cardCollects, true)
  if not TacticalCardUtil.IsFunctionOpen() then
    return
  end
  self:UpdateDataFromServerData(msg, false)
  self:ReqAllCardData()
  self:SetCardVersionStateCache(msg.cardVersionChange, msg.cardVersion)
end

function TacticalCardDataManager:ReqAllCardData()
  SFSNetwork.SendMessage(MsgDefines.BattleCardList)
  SFSNetwork.SendMessage(MsgDefines.BattleCardScoreInfo)
end

function TacticalCardDataManager:UpdateDataFromServerData(msg, updateBook)
  if updateBook == nil then
    updateBook = true
  end
  if msg.userBattleCards then
    for _, v in ipairs(msg.userBattleCards) do
      self:UpdateOneCardData(v, updateBook)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.TacticalCardDataChanged)
end

TacticalCardDataManager.StageStateType = {
  unavailable = 0,
  available = 1,
  received = 2
}

function TacticalCardDataManager:UpdateCardCollections(cardCollections, isFull)
  if not cardCollections then
    return
  end
  if isFull then
    self.cardCollections = {}
  end
  for _, v in ipairs(cardCollections) do
    local cfgId = v.cfgId
    local cardType = v.cardType
    local rewardStr = v.rewardStr
    local stageStateList = {}
    for _, reward in ipairs(rewardStr:split("|")) do
      local index, state = string.match(reward, "(%d+);(%d+)")
      if index and state then
        table.insert(stageStateList, {
          index = tonumber(index),
          state = tonumber(state)
        })
      end
    end
    self.cardCollections[cardType] = {
      cfgId = cfgId,
      cardType = cardType,
      stageStateList = stageStateList
    }
    local collectionLineData = LocalController:instance():getLine(TableName.TacticalCardStageReward, cfgId)
    if collectionLineData then
      local needCnt = collectionLineData:getValue("card_num")
      local reward = collectionLineData:getValue("reward")
      for _, stageState in ipairs(stageStateList) do
        if needCnt[stageState.index + 1] then
          stageState.needCnt = needCnt[stageState.index + 1]
        end
        if reward[stageState.index + 1] then
          stageState.reward = reward[stageState.index + 1]
        end
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.TacticalCardStageRewardChanged)
end

function TacticalCardDataManager:HasCanReceiveBox(cardType)
  for _, v in ipairs(self.cardCollections) do
    if not cardType or v.cardType == cardType then
      local activeCards
      for _, stageState in ipairs(v.stageStateList) do
        if stageState.state == TacticalCardDataManager.StageStateType.available then
          return true
        elseif stageState.state == TacticalCardDataManager.StageStateType.unavailable then
          activeCards = activeCards or self:GetActiveCardsByType(v.cardType)
          if activeCards and table.count(activeCards) >= stageState.needCnt then
            return true
          end
        end
      end
    end
  end
  return false
end

function TacticalCardDataManager:UpdateCardBookData(cards)
  if not cards then
    return
  end
  self.hasRequestCardBookData = true
  for _, v in ipairs(cards) do
    local cardType = v.cardType
    local cards = v.cards
    if not string.IsNullOrEmpty(cards) then
      local cardList = string.split(cards, ";")
      for _, card in ipairs(cardList) do
        local cardId = tonumber(card)
        if not self.cardBookData[cardType] then
          self.cardBookData[cardType] = {}
        end
        self.cardBookData[cardType][cardId] = true
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.TacticalCardBookDataChanged)
end

function TacticalCardDataManager:IsCardActivated(cardType, cardId)
  if not cardType or not cardId then
    return false
  end
  if not self.cardBookData[cardType] then
    return false
  end
  return self.cardBookData[cardType][cardId] and true or false
end

function TacticalCardDataManager:GetActiveCardsByType(cardType)
  if not cardType then
    return {}
  end
  return self.cardBookData[cardType]
end

function TacticalCardDataManager:UpdateOneCardData(data, updateBook)
  local uuid = data.uuid
  local cardData = self.allCardDataDic[uuid]
  cardData = cardData or TacticalCardData.New()
  cardData:UpdateData(data)
  self:OnUpdateOneCardData(cardData)
  if updateBook then
    self:OnUpdateCardBook(cardData)
  end
end

function TacticalCardDataManager:OnUpdateOneCardData(addCardData)
  local isNew = not table.containsKey(self.allCardDataDic, addCardData.uuid)
  self.allCardDataDic[addCardData.uuid] = addCardData
  if addCardData:IsEquip() then
    self.curEquipCardDic[addCardData.slotId] = addCardData
  else
    self.allIdleCardDic[addCardData.uuid] = addCardData
  end
  for slotId, cardData in pairs(self.curEquipCardDic) do
    if cardData.uuid == addCardData.uuid and slotId ~= addCardData.slotId then
      self.curEquipCardDic[slotId] = nil
      break
    end
  end
  if isNew and addCardData.cardType == TacticalCardType.Core then
    self:CheckMainCoreCardOnAddCard(addCardData)
  end
  if not self.cardIdDic[addCardData.cardId] then
    self.cardIdDic[addCardData.cardId] = {}
  end
  self.cardIdDic[addCardData.cardId][addCardData.uuid] = true
end

function TacticalCardDataManager:OnUpdateCardBook(cardData)
  local cardType = cardData:GetCardType()
  if not self.cardBookData[cardType] then
    self.cardBookData[cardType] = {}
  end
  if not self.cardBookData[cardType][cardData.cardId] then
    self.cardBookData[cardType][cardData.cardId] = true
    EventManager:GetInstance():Broadcast(EventId.TacticalCardBookDataChanged)
  end
end

function TacticalCardDataManager:TryRequestCardBookData()
  if not self.hasRequestCardBookData then
    SFSNetwork.SendMessage(MsgDefines.GetBattleCardBookData)
  end
end

function TacticalCardDataManager:OnRemoveOneCardData(removeCardData)
  self.allCardDataDic[removeCardData.uuid] = nil
  if removeCardData:IsEquip() then
    local slot = removeCardData:GetEquipSlot()
    self.curEquipCardDic[slot] = nil
  end
  self.allIdleCardDic[removeCardData.uuid] = nil
  self:CheckMainCoreCardOnRemoveCard(removeCardData)
  if self.cardIdDic[removeCardData.cardId] then
    self.cardIdDic[removeCardData.cardId][removeCardData.uuid] = nil
  end
end

function TacticalCardDataManager:CheckMainCoreCardOnAddCard(addCardData)
  local cardId = addCardData.cardId
  local curAllCardDataList = self.allCoreCardDataDic[cardId]
  if not curAllCardDataList then
    curAllCardDataList = {}
    self.allCoreCardDataDic[cardId] = curAllCardDataList
    table.insert(curAllCardDataList, addCardData)
    return
  end
  local curCoreMainCard = self:GetCoreMainByCardId(cardId)
  local ret, newCoreMainCard = TacticalCardUtil.GetMainCoreCardFromSameCard(curCoreMainCard, addCardData)
  if ret and newCoreMainCard.uuid ~= curCoreMainCard.uuid then
    table.insert(curAllCardDataList, 1, addCardData)
  else
    table.insert(curAllCardDataList, addCardData)
  end
end

function TacticalCardDataManager:CheckMainCoreCardOnRemoveCard(removeCardData)
  if not removeCardData or removeCardData.cardType ~= TacticalCardType.Core then
    return
  end
  local cardId = removeCardData.cardId
  local curAllCardDataList = self.allCoreCardDataDic[cardId]
  local curCoreMainCard = self:GetCoreMainByCardId(cardId)
  if removeCardData.uuid == curCoreMainCard.uuid then
    table.remove(curAllCardDataList, 1)
    return
  end
  local targetCardIndex
  for index, v in ipairs(curAllCardDataList) do
    if v.uuid == removeCardData.uuid then
      targetCardIndex = index
      break
    end
  end
  if targetCardIndex then
    table.remove(curAllCardDataList, targetCardIndex)
  end
end

function TacticalCardDataManager:GetCoreMainByCardId(cardId)
  if not self.allCoreCardDataDic or not cardId then
    return
  end
  local allCardDataList = self.allCoreCardDataDic[cardId]
  if not allCardDataList or #allCardDataList == 0 then
    return
  end
  return allCardDataList[1]
end

function TacticalCardDataManager:GetCoreFeedNumByCardId(cardId)
  if not self.allCoreCardDataDic or not cardId then
    return 0
  end
  local allCardDataList = self.allCoreCardDataDic[cardId]
  if not allCardDataList or #allCardDataList <= 1 then
    return 0
  end
  return #allCardDataList - 1
end

function TacticalCardDataManager:GetCardDataBySlot(slotId)
  if not table.containsKey(self.curEquipCardDic, slotId) then
    Logger.LogError(string.format("slotId :%s is not equip card!", slotId))
    return
  end
  return self.curEquipCardDic[slotId]
end

function TacticalCardDataManager:GetAllEquipCardData()
  local result = {}
  for _, v in pairs(self.curEquipCardDic) do
    table.insert(result, v)
  end
  return result
end

function TacticalCardDataManager:GetAllEquipCardDataByCardType(cardType)
  local result = {}
  for _, v in pairs(self.curEquipCardDic) do
    if v:GetCardType() == cardType then
      table.insert(result, v)
    end
  end
  return result
end

function TacticalCardDataManager:RemoveCards(cardList)
  if not cardList then
    return
  end
  for _, v in ipairs(cardList) do
    self:RemoveOneCard(v)
  end
  EventManager:GetInstance():Broadcast(EventId.TacticalCardDataChanged)
end

function TacticalCardDataManager:RemoveOneCard(card)
  local uuid = card
  local targetCard = self.allCardDataDic[uuid]
  if not targetCard then
    Logger.LogError(string.format("recycle target not found. uuid: %s", uuid))
    return
  end
  self:OnRemoveOneCardData(targetCard)
end

function TacticalCardDataManager:ShowCardLog(info)
  UIUtil.ShowTips(info)
  Logger.LogError(info)
end

function TacticalCardDataManager:GetTemplateData(templateId)
  if not templateId then
    return nil
  end
  local numId = tonumber(templateId)
  if not numId then
    return nil
  end
  if self.templateData[numId] then
    return self.templateData[numId]
  end
  local line = LocalController:instance():getLine(TableName.TacticalCard, numId)
  if not line then
    return nil
  end
  self.templateData[numId] = BattleCardTemplate.New()
  self.templateData[numId]:UpdateData(line)
  return self.templateData[numId]
end

function TacticalCardDataManager:GetStarTemplateData(templateId)
  if not templateId then
    return nil
  end
  local numId = tonumber(templateId)
  if not numId then
    return nil
  end
  if self.starTemplateData[numId] then
    return self.starTemplateData[numId]
  end
  local line = LocalController:instance():getLine(TableName.TacticalCardStar, numId)
  if not line then
    return nil
  end
  self.starTemplateData[numId] = BattleCardStarTemplate.New()
  self.starTemplateData[numId]:UpdateData(line)
  return self.starTemplateData[numId]
end

function TacticalCardDataManager:GetLevelTemplateData(templateId)
  if not templateId then
    return nil
  end
  local numId = tonumber(templateId)
  if not numId then
    return nil
  end
  if self.lvTemplateData[numId] then
    return self.lvTemplateData[numId]
  end
  local line = LocalController:instance():getLine(TableName.TacticalCardLevel, numId)
  if not line then
    return nil
  end
  self.lvTemplateData[numId] = BattleCardLevelTemplate.New()
  self.lvTemplateData[numId]:UpdateData(line)
  return self.lvTemplateData[numId]
end

function TacticalCardDataManager:GetSkillTemplateData(templateId)
  if not templateId then
    return nil
  end
  local numId = tonumber(templateId)
  if not numId then
    return nil
  end
  if self.skillTemplateData[numId] then
    return self.skillTemplateData[numId]
  end
  local line = LocalController:instance():getLine(TableName.TacticalCardSkill, numId)
  if not line then
    return nil
  end
  self.skillTemplateData[numId] = BattleCardSkillTemplate.New()
  self.skillTemplateData[numId]:UpdateData(line)
  return self.skillTemplateData[numId]
end

function TacticalCardDataManager:InitAllCardBoxData()
  if self.hasInitBoxData then
    return
  end
  self.boxTemplates = {}
  self.seasonBoxMap = {}
  LocalController:instance():visitTable(TableName.TacticalCardBox, function(id, lineData)
    local template = BattleCardBoxTemplate.New()
    template:UpdateData(lineData)
    self.boxTemplates[tonumber(id)] = template
    if not self.seasonBoxMap[template.season] then
      self.seasonBoxMap[template.season] = {}
    end
    table.insert(self.seasonBoxMap[template.season], template)
  end)
  self.hasInitBoxData = true
end

function TacticalCardDataManager:GetAllBoxIdCurSeason()
  self:InitAllCardBoxData()
  local season = DataCenter.SeasonDataManager:GetSeason()
  if not season then
    return {}
  end
  if not self.seasonBoxMap[season] then
    return {}
  end
  local result = {}
  for _, v in ipairs(self.seasonBoxMap[season]) do
    result[v.id] = v
  end
  return result
end

function TacticalCardDataManager:GetBoxTemplate(boxId)
  if not boxId then
    return nil
  end
  if not table.containsKey(self.boxTemplates, boxId) then
    self:InitAllCardBoxData()
  end
  return self.boxTemplates[boxId]
end

function TacticalCardDataManager:GetAllBoxGoodsIdBySeason(season)
  self:InitAllCardBoxData()
  if not season then
    return {}
  end
  if not self.seasonBoxMap[season] then
    return {}
  end
  if not self.boxSortState or not self.boxSortState[season] then
    local boxList = self.seasonBoxMap[season]
    local tmp = {}
    for _, v in ipairs(boxList) do
      local quality = v:GetQuality()
      if not tmp[quality] then
        tmp[quality] = {}
      end
      tmp[v.id] = quality
    end
    table.sort(boxList, function(a, b)
      local aQuality = tmp[a.id]
      local bQuality = tmp[b.id]
      if aQuality ~= bQuality then
        return aQuality < bQuality
      end
      return a.id < b.id
    end)
    if not self.boxSortState then
      self.boxSortState = {}
    end
    self.boxSortState[season] = true
  end
  return self.seasonBoxMap[season]
end

function TacticalCardDataManager:GetBoxIdByQuality(quality)
  if not quality then
    return nil
  end
  self:InitAllCardBoxData()
  local season = DataCenter.SeasonDataManager:GetSeason()
  if not season then
    return nil
  end
  if not self.seasonBoxMap[season] then
    return nil
  end
  for _, v in ipairs(self.seasonBoxMap[season]) do
    if v:GetQuality() == quality then
      return v
    end
  end
  return nil
end

function TacticalCardDataManager:GetCardData(uuid)
  if not uuid then
    return nil
  end
  return self.allCardDataDic[uuid]
end

function TacticalCardDataManager:HasCard(cardId)
  if not cardId then
    return false
  end
  return not table.IsNullOrEmpty(self.cardIdDic[cardId]) and true or false
end

function TacticalCardDataManager:GetAllCanBeMaterialCards(uuid, cardId, needCnt)
  local result = {}
  if not cardId then
    return nil
  end
  if self.cardIdDic[cardId] then
    local cnt = 0
    for _uuid, _ in pairs(self.cardIdDic[cardId]) do
      if uuid ~= _uuid then
        table.insert(result, _uuid)
        cnt = cnt + 1
      end
      if needCnt and needCnt <= cnt then
        return result
      end
    end
  end
  return result
end

function TacticalCardDataManager:InitSeasonCardsMap()
  if not self.hasInitSeasonCards then
    self.seasonCardsMap = {}
    LocalController:instance():visitTable(TableName.TacticalCard, function(id, lineData)
      local can_see_seasons = lineData:getValue("season_can_see") or {}
      if can_see_seasons and 0 < #can_see_seasons then
        for _, can_see_season in ipairs(can_see_seasons) do
          local cardType = tonumber(lineData:getValue("type")) or 0
          if not self.seasonCardsMap[can_see_season] then
            self.seasonCardsMap[can_see_season] = {}
          end
          if not self.seasonCardsMap[can_see_season][cardType] then
            self.seasonCardsMap[can_see_season][cardType] = {}
          end
          table.insert(self.seasonCardsMap[can_see_season][cardType], tonumber(id))
        end
      end
    end)
    self.hasInitSeasonCards = true
  end
end

function TacticalCardDataManager:GetSeasonCards(season, cardType)
  self:InitSeasonCardsMap()
  if not self.seasonCardsMap[season] then
    return {}
  end
  if not self.seasonCardsMap[season][cardType] then
    return {}
  end
  return self.seasonCardsMap[season][cardType]
end

function TacticalCardDataManager:GetCardCollectionByType(cardType)
  if not cardType then
    return nil
  end
  for _, v in ipairs(self.cardCollections) do
    if v.cardType == cardType then
      return v
    end
  end
  return nil
end

local REQUEST_INTERVAL_LIMIT = 3

function TacticalCardDataManager:TryReqDailyLimit()
  local canRequest = false
  local Time = UITimeManager:GetInstance()
  local now = Time:GetServerSeconds()
  if not self.lastReqDailyLimitTime then
    canRequest = true
  else
    local afterResetTime = false
    if self.nextResetTime and now >= self.nextResetTime then
      afterResetTime = true
    end
    if afterResetTime or now - self.lastReqDailyLimitTime > REQUEST_INTERVAL_LIMIT then
      canRequest = true
    end
  end
  if canRequest then
    self.lastReqDailyLimitTime = now
    DataCenter.DispatchRequestManager:Append(function()
      SFSNetwork.SendMessage(MsgDefines.TacticalCardDailyLimit)
    end)
  end
end

function TacticalCardDataManager:UpdateDailyLimit(msg)
  if not msg then
    return
  end
  self.nextResetTime = msg.nextResetTime
  self.dailyLimits = msg.boxLimitArr
  EventManager:GetInstance():Broadcast(EventId.TacticalCardDailyLimitChanged)
end

function TacticalCardDataManager:GetDailyLimit(boxId)
  if not boxId then
    return 0, 0
  end
  if not self.dailyLimits then
    return 0, 0
  end
  for _, v in ipairs(self.dailyLimits) do
    if v.boxId == boxId then
      return v.curNum, v.dailyMax
    end
  end
  return 0, 0
end

function TacticalCardDataManager:CheckCoreStarUpgrade(cardId)
  if not self.allCoreCardDataDic then
    return false
  end
  local canUpgrade = false
  local list = self.allCoreCardDataDic[cardId]
  if list and 1 < #list then
    local mainCardData = list[1]
    local id, cost = mainCardData:GetStarUpgradeCost()
    local feeCount = #list - 1
    if cost and 0 < cost and cost <= feeCount then
      canUpgrade = true
    end
  end
  return canUpgrade
end

function TacticalCardDataManager:CheckAllCoreStarUpgrade()
  if not self.allCoreCardDataDic then
    return false
  end
  local canUpgrade = false
  for cardId, list in pairs(self.allCoreCardDataDic) do
    if self:CheckCoreStarUpgrade(cardId) then
      canUpgrade = true
      break
    end
  end
  return canUpgrade
end

function TacticalCardDataManager:InitBattleReportEffectMap()
  if not self.battleReportEffect then
    self.battleReportEffect = {}
    self.baseEffect2Group = {}
    self.skillEffect2Group = {}
    LocalController:instance():visitTable(TableName.TacticalCardBattleReport, function(id, lineData)
      local id = lineData:getValue("id")
      local desc = lineData:getValue("desc") or ""
      local effectId = lineData:getValue("effectId") or {}
      local skillEffectId = lineData:getValue("skill_effectId") or {}
      local effectIdMap = {}
      for i = 1, #effectId do
        effectIdMap[effectId[i]] = true
      end
      local skillEffectIdMap = {}
      for i = 1, #skillEffectId do
        skillEffectIdMap[skillEffectId[i]] = true
      end
      local effectData = {
        id = id,
        desc = desc,
        effectId = effectIdMap,
        skillEffectId = skillEffectIdMap
      }
      self.battleReportEffect[id] = effectData
    end)
  end
end

function TacticalCardDataManager:GetBattleReportEffect()
  self:InitBattleReportEffectMap()
  return self.battleReportEffect
end

function TacticalCardDataManager:GetBattleReportDesc(id)
  self:InitBattleReportEffectMap()
  local effectData = self.battleReportEffect[id]
  if not effectData then
    return ""
  end
  return effectData.desc
end

function TacticalCardDataManager:GetTcCardExpItemId()
  if not self.tcCardExpItemId then
    local config = LuaEntry.DataConfig:TryGetStr("battle_card_param", "k9")
    if not string.IsNullOrEmpty(config) then
      local list = string.split(config, "|")
      if 1 <= #list then
        self.tcCardExpItemId = tonumber(list[1])
      end
    end
    if not self.tcCardExpItemId then
      self.tcCardExpItemId = 14501
    end
  end
  return self.tcCardExpItemId
end

function TacticalCardDataManager:GetCurSeasonQuickEquipStyleTypes()
  self:InitQuickEquipStyleTypes()
  local season = DataCenter.SeasonDataManager:GetSeason()
  if not self.quickEquipStyleTypes[season] then
    return {}
  end
  return self.quickEquipStyleTypes[season]
end

function TacticalCardDataManager:InitQuickEquipStyleTypes()
  if self.quickEquipStyleTypes then
    return
  end
  self.quickEquipStyleTypes = {}
  LocalController:instance():visitTable(TableName.TacticalCardRecommendSeason, function(id, lineData)
    local id = lineData:getValue("id")
    local season = lineData:getValue("season")
    local sort = lineData:getValue("sort")
    local sort_name = lineData:getValue("sort_name") or ""
    local recommend_cardId_list = lineData:getValue("recommend_card") or {}
    if not self.quickEquipStyleTypes[season] then
      self.quickEquipStyleTypes[season] = {}
    end
    table.insert(self.quickEquipStyleTypes[season], {
      id = id,
      sort = sort,
      sort_name = sort_name,
      cardIds = recommend_cardId_list
    })
  end)
  for season, v in pairs(self.quickEquipStyleTypes) do
    table.sort(v, function(a, b)
      if a.sort ~= b.sort then
        return a.sort < b.sort
      end
      return a.id < b.id
    end)
  end
end

function TacticalCardDataManager:ParseQuickEquipSpecialLogic4Formation()
  self.quickEquipSpecialDic = {}
  local checkInfo = LuaEntry.DataConfig:TryGetStr("battle_card_param", "k20")
  if not checkInfo then
    return nil
  end
  local infoArr = string.split(checkInfo, "|")
  if not infoArr then
    return nil
  end
  for _, v in ipairs(infoArr) do
    local arr = string.split(v, ";")
    if #arr == 3 then
      local season = toInt(arr[1])
      local targetRecommendId = toInt(arr[2])
      local formationCardStrList = string.split(arr[3], ",")
      if #formationCardStrList == 3 then
        local cardId4Tank = toInt(formationCardStrList[1])
        local cardId4Air = toInt(formationCardStrList[2])
        local cardId4Missile = toInt(formationCardStrList[3])
        local realId = season * 10000 + targetRecommendId
        self.quickEquipSpecialDic[realId] = {
          [HeroType.Tank] = cardId4Tank,
          [HeroType.Aircraft] = cardId4Air,
          [HeroType.Missile] = cardId4Missile
        }
      end
    end
  end
end

function TacticalCardDataManager:GetQuickEquipSortWeight(cardTemplate, index)
  local recommendId = cardTemplate.recommend_id
  local fixedWeight = self:GetQuickEquipFixedSortWeight(recommendId, index)
  local isDynamicWeight = self:CheckIsDynamicWeight(recommendId)
  if not isDynamicWeight then
    return fixedWeight
  end
  return self:DynamicModifyWeight(cardTemplate, fixedWeight)
end

function TacticalCardDataManager:GetQuickEquipFixedSortWeight(recommendId, index)
  if self.cachedQuickEquipSortWeight and self.cachedQuickEquipSortWeight[recommendId] then
    return self.cachedQuickEquipSortWeight[recommendId][index] or 0
  end
  local recommendId = recommendId
  if recommendId <= 0 then
    return 0
  end
  local realId = DataCenter.SeasonDataManager:GetSeason() * 10000 + recommendId
  local meta = LocalController:instance():getLine(TableName.TacticalCardRecommend, tostring(realId))
  if not meta then
    return 0
  end
  local recommendRank = meta:getValue("recommend_rank") or {}
  if not self.cachedQuickEquipSortWeight then
    self.cachedQuickEquipSortWeight = {}
    self:ParseQuickEquipSpecialLogic4Formation()
  end
  self.cachedQuickEquipSortWeight[recommendId] = recommendRank
  local weight = recommendRank[index] or 0
  return weight
end

function TacticalCardDataManager:CheckIsDynamicWeight(recommendId)
  local realId = DataCenter.SeasonDataManager:GetSeason() * 10000 + recommendId
  return self.quickEquipSpecialDic and self.quickEquipSpecialDic[realId]
end

function TacticalCardDataManager:DynamicModifyWeight(cardTemplate, fixedWeight)
  local newWeight = self:DynamicModify4Formation(cardTemplate, fixedWeight)
  return newWeight
end

function TacticalCardDataManager:DynamicModify4Formation(cardTemplate, fixedWeight)
  if not cardTemplate then
    return fixedWeight
  end
  local recommendId = cardTemplate.recommend_id
  local realId = DataCenter.SeasonDataManager:GetSeason() * 10000 + recommendId
  local specialWeightGroupData = self.quickEquipSpecialDic[realId]
  if not specialWeightGroupData then
    return fixedWeight
  end
  local bestStrongHeroType = ArmyFormationUtils.GetStrongestHeroType()
  if not bestStrongHeroType then
    return fixedWeight
  end
  local cardId = cardTemplate.id
  local winCardId = specialWeightGroupData[bestStrongHeroType]
  return winCardId == cardId and fixedWeight or 99
end

function TacticalCardDataManager:GetCardRecycleDays()
  if self.cardRecycleDays then
    return self.cardRecycleDays
  end
  local config = LuaEntry.DataConfig:TryGetNum("battle_card_param", "k11", 0)
  self.cardRecycleDays = config
  return config
end

function TacticalCardDataManager:UpdatePointReward(rewardList)
  local stages = self:GetCurSeasonPointRewardStages()
  if stages then
    local list2Map = {}
    if rewardList then
      for _, v in ipairs(rewardList) do
        list2Map[v] = true
      end
    end
    for _, v in ipairs(stages) do
      v.claimState = list2Map[v.id] and 1 or 0
    end
  end
end

function TacticalCardDataManager:GetScoreInfo()
  return self.scoreInfo
end

function TacticalCardDataManager:UpdateScoreInfo(score)
  self.scoreInfo = score
end

function TacticalCardDataManager:InitPointRewardStages()
  if not self.hasInitPointRewardStages then
    self.hasInitPointRewardStages = true
    self.seasonPointRewardStages = {}
    LocalController:instance():visitTable(TableName.BattleCardBoxReward, function(id, lineData)
      local season = lineData:getValue("season")
      local point = lineData:getValue("point")
      local reward = lineData:getValue("reward") or {}
      if not self.seasonPointRewardStages[season] then
        self.seasonPointRewardStages[season] = {}
      end
      table.insert(self.seasonPointRewardStages[season], {
        id = id,
        season = season,
        point = point,
        goodsId = reward[1] or 0,
        goodsNum = reward[2] or 0
      })
    end)
    for season, v in pairs(self.seasonPointRewardStages) do
      table.sort(v, function(a, b)
        return a.point < b.point
      end)
    end
  end
end

function TacticalCardDataManager:GetPointRewardStages(season)
  self:InitPointRewardStages()
  if not self.seasonPointRewardStages[season] then
    return {}
  end
  return self.seasonPointRewardStages[season]
end

function TacticalCardDataManager:GetCurSeasonPointRewardStages()
  local season = DataCenter.SeasonDataManager:GetSeason()
  local stages = self:GetPointRewardStages(season)
  if not stages or #stages == 0 then
    return nil
  end
  return stages
end

function TacticalCardDataManager:HasClaimableBoxPointReward()
  local currentScore = self:GetScoreInfo() or 0
  local season = DataCenter.SeasonDataManager:GetSeason()
  local scoreRewardStages = self:GetPointRewardStages(season)
  if not scoreRewardStages then
    return false
  end
  for i, stageData in ipairs(scoreRewardStages) do
    if currentScore >= stageData.point and stageData.claimState ~= 1 then
      return true
    end
  end
  return false
end

function TacticalCardDataManager:GetCardAttributeQuality(attributeConfigId)
  local quality = 1
  local detailTemplate = LocalController:instance():getLine("battle_card_random_attr_detail", attributeConfigId)
  if detailTemplate then
    return self:GetCardAttributeQualityByEffectId(detailTemplate.effect_num, detailTemplate.quality_range[1], detailTemplate.quality_range[2])
  end
  return quality
end

function TacticalCardDataManager:GetCardAttributeQualityByEffectId(effectId, min, max)
  local quality = 1
  if not (effectId and min) or not max then
    return quality
  end
  local showTemplate = self:GetRandomAttributeShowTemplate(effectId)
  if showTemplate then
    for i, v in ipairs(showTemplate.qualityList) do
      if min <= v.rangeMax and min >= v.rangeMin then
        if max > v.rangeMax then
          Logger.LogError("\231\173\150\229\136\146\233\133\141\233\148\153\228\186\134 max:" .. tostring(max) .. " rangeMax:" .. tostring(v.rangeMax) .. " effectId:" .. tostring(effectId))
        end
        quality = v.quality
        break
      end
    end
  end
  return quality
end

function TacticalCardDataManager:GetCardAttributeQualityByValue(effectId, value)
  local quality = 1
  if not effectId or not value then
    return quality
  end
  local showTemplate = self:GetRandomAttributeShowTemplate(effectId)
  if showTemplate then
    for i, v in ipairs(showTemplate.qualityList) do
      if value >= v.rangeMin and value <= v.rangeMax then
        quality = v.quality
        break
      end
    end
  end
  return quality
end

function TacticalCardDataManager:GetRandomAttributeShowTemplate(id)
  if not id then
    return
  end
  if not self.randomAttributeShowTemplateDic then
    self.randomAttributeShowTemplateDic = {}
  end
  if self.randomAttributeShowTemplateDic[id] then
    return self.randomAttributeShowTemplateDic[id]
  end
  local line = LocalController:instance():getLine(TableName.BATTLE_CARD_RANDOM_ATTR_SHOW, id)
  if not line then
    return nil
  end
  local template = BattleCardRandomAttrShowTemplate.New()
  template:UpdateData(line)
  self.randomAttributeShowTemplateDic[id] = template
  return template
end

function TacticalCardDataManager:GetAttributeQualityColor(quality)
  if self.attributeColorFormatList then
    return self.attributeColorFormatList[quality]
  end
  local colorStr = LuaEntry.DataConfig:TryGetStr("battle_card_param", "k13")
  if not string.IsNullOrEmpty(colorStr) then
    local split = string.split(colorStr, "|")
    self.attributeColorFormatList = {}
    for i, v in ipairs(split) do
      local format = "<color=#" .. split[i] .. ">%s</color>"
      table.insert(self.attributeColorFormatList, format)
    end
  end
  return self.attributeColorFormatList[quality]
end

function TacticalCardDataManager:SetCardVersionStateCache(isVerUpdate, versionId)
  self.cardVersionId = versionId
  self.cardVersionNeedUpdate = isVerUpdate
end

function TacticalCardDataManager:GetCardVersionStateCache()
  return self.cardVersionNeedUpdate, self.cardVersionId
end

function TacticalCardDataManager:PushFormationViewCardSkillUseCache(cardSkillUseInfoList)
  self.cardSkillUseInfoList = cardSkillUseInfoList
end

function TacticalCardDataManager:PopFormationViewCardSkillUseCache()
  local cache = self.cardSkillUseInfoList
  self.cardSkillUseInfoList = nil
  return cache
end

function TacticalCardDataManager:OnCardVersionUpdate(message)
  if not self.cardVersionNeedUpdate then
    return
  end
  if not message or not message.changeDetail then
    return
  end
  self.cardVersionNeedUpdate = false
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalCardVersionChangePreview, {anim = true}, message.changeDetail)
end

function TacticalCardDataManager:GetRecommendPresetData()
  return self.recommendPresetData
end

function TacticalCardDataManager:GetCustomPresetData()
  return self.customPresetData
end

function TacticalCardDataManager:SetCustomPlanChangedCallback(cb, owner)
  self.customPresetData:SetChangedCallback(cb, owner)
end

function TacticalCardDataManager:UpdateCustomPresetData(msg)
  self.customPresetData:UpdateData(msg)
end

function TacticalCardDataManager:SaveCustomPlan(index, cards)
  self.customPresetData:SaveCustomPlan(index, cards)
end

function TacticalCardDataManager:DeleteCustomPlan(index)
  self.customPresetData:DeleteCustomPlan(index)
end

function TacticalCardDataManager:ReqRenameCustomPlan(index, newName)
  SFSNetwork.SendMessage(MsgDefines.BattleCardPlanName, {index = index, name = newName})
end

function TacticalCardDataManager:ReqCustomPlanList()
  SFSNetwork.SendMessage(MsgDefines.BattleCardPlanGet)
end

function TacticalCardDataManager:ReqSaveCustomPlan(index)
  SFSNetwork.SendMessage(MsgDefines.BattleCardPlanSave, index)
end

function TacticalCardDataManager:ReqDeleteCustomPlan(index)
  SFSNetwork.SendMessage(MsgDefines.BattleCardPlanDel, index)
end

function TacticalCardDataManager:ReqApplyCustomPlan(index)
  if index < 1 or index > self.customPresetData:GetCustomPlanCount() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BattleCardPlanApply, index)
end

TacticalCardDataManager.__init = __init
TacticalCardDataManager.__delete = __delete
return TacticalCardDataManager
