local TacticalCardUtil = {}
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local TacticalCardData = require("DataCenter.TacticalCardManager.TacticalCardData")
local TCSkillFactory = require("DataCenter.TacticalCardManager.Skill.TCSkillFactory")
local CORE_SIMPLE_FRAME_PATH = {
  [TacticalCardQualityType.White] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_hexing01.png",
  [TacticalCardQualityType.Green] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_hexing01.png",
  [TacticalCardQualityType.Blue] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_hexing01.png",
  [TacticalCardQualityType.Purple] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_hexing01.png",
  [TacticalCardQualityType.Orange] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_hexing01.png"
}
local CORE_DELUXE_FRAME_PATH = {
  [TacticalCardQualityType.White] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_hexing03.png",
  [TacticalCardQualityType.Green] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_hexing03.png",
  [TacticalCardQualityType.Blue] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_hexing03.png",
  [TacticalCardQualityType.Purple] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_hexing03.png",
  [TacticalCardQualityType.Orange] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_hexing03.png"
}
local SINGLE_SIMPLE_FRAME_PATH = {
  [TacticalCardQualityType.White] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_lvse.png",
  [TacticalCardQualityType.Green] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_lvse.png",
  [TacticalCardQualityType.Blue] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_lanse.png",
  [TacticalCardQualityType.Purple] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_zise.png",
  [TacticalCardQualityType.Orange] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_zise.png"
}
local SINGLE_DELUXE_FRAME_PATH = {
  [TacticalCardQualityType.White] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_lvse.png",
  [TacticalCardQualityType.Green] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_lvse.png",
  [TacticalCardQualityType.Blue] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_lanse.png",
  [TacticalCardQualityType.Purple] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_zise.png",
  [TacticalCardQualityType.Orange] = "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_binakuang_zise.png"
}
TacticalCardUtil.CARD_BOX_PANEL_ICON_VFX = {
  [TacticalCardQualityType.Green] = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_bag_green.prefab",
  [TacticalCardQualityType.Blue] = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_bag_blue.prefab",
  [TacticalCardQualityType.Purple] = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_bag_purple.prefab",
  [TacticalCardQualityType.Orange] = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_bag_gold.prefab"
}
TacticalCardUtil.CARD_BOX_PANEL_TITLE_VFX = {
  [TacticalCardQualityType.Purple] = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_bag_tittle_purple.prefab",
  [TacticalCardQualityType.Orange] = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_bag_tittle_gold.prefab"
}
TacticalCardUtil.CommonDeck = 0
local CARDS_ROW_TYPE = {
  UP = 1,
  MID = 2,
  DOWN = 3
}
local SLOT_ROW_MAP = {
  [1] = CARDS_ROW_TYPE.MID,
  [2] = CARDS_ROW_TYPE.MID,
  [3] = CARDS_ROW_TYPE.UP,
  [4] = CARDS_ROW_TYPE.UP,
  [5] = CARDS_ROW_TYPE.UP,
  [6] = CARDS_ROW_TYPE.UP,
  [7] = CARDS_ROW_TYPE.UP,
  [8] = CARDS_ROW_TYPE.UP,
  [9] = CARDS_ROW_TYPE.DOWN,
  [10] = CARDS_ROW_TYPE.DOWN,
  [11] = CARDS_ROW_TYPE.DOWN,
  [12] = CARDS_ROW_TYPE.DOWN,
  [13] = CARDS_ROW_TYPE.DOWN,
  [14] = CARDS_ROW_TYPE.DOWN
}
local ROW_SLOT_MAP = {
  [CARDS_ROW_TYPE.MID] = {1, 2},
  [CARDS_ROW_TYPE.UP] = {
    3,
    4,
    5,
    6,
    7,
    8
  },
  [CARDS_ROW_TYPE.DOWN] = {
    9,
    10,
    11,
    12,
    13,
    14
  }
}
TacticalCardUtil.CARDS_ROW_TYPE = CARDS_ROW_TYPE
TacticalCardUtil.SLOT_ROW_MAP = SLOT_ROW_MAP
TacticalCardUtil.ROW_SLOT_MAP = ROW_SLOT_MAP
TacticalCardUtil.Effect_Card_Upgrade = 76405

function TacticalCardUtil.GetCardRealId(baseId, lv)
  return baseId + (lv - 1)
end

function TacticalCardUtil.IsSlotEquipCard(slotId)
  if not slotId then
    return false
  end
  local slotDic = DataCenter.TacticalCardDataManager.curEquipCardDic
  if not slotDic then
    return false
  end
  return slotDic[slotId] ~= nil
end

function TacticalCardUtil.IsEmptySlot(slotId)
  return not TacticalCardUtil.IsSlotEquipCard(slotId)
end

function TacticalCardUtil.GetCardConfigByCardType(cardType)
  local prefabPath = TacticalCardPrefabPathConfig[cardType]
  local cls = TacticalCardClsPathConfig[cardType]
  return prefabPath, cls
end

function TacticalCardUtil.GetCardSlotConfigByCardType(slotType)
  local prefabPath = TacticalCardSlotPrefabConfig[slotType]
  local cls = TacticalCardSlotClsConfig[slotType]
  return prefabPath, cls
end

function TacticalCardUtil:CreateOneSlotItem(slotType, parent, callback)
  local prefabPath, cls = TacticalCardUtil.GetCardSlotConfigByCardType(slotType)
  if not prefabPath or not cls then
    return nil
  end
  return TacticalCardUtil.InstantiateAsyncLoadItem(self, prefabPath, cls, parent, callback)
end

function TacticalCardUtil.GetConfigCardSlotConfigByCardType(slotType)
  local prefabPath = TacticalCardSlotPrefabConfig[slotType]
  local cls = TacticalCardConfigSlotClsConfig[slotType]
  return prefabPath, cls
end

function TacticalCardUtil:CreateOneConfigSlotItem(slotType, parent, callback)
  local prefabPath, cls = TacticalCardUtil.GetConfigCardSlotConfigByCardType(slotType)
  if not prefabPath or not cls then
    return nil
  end
  return TacticalCardUtil.InstantiateAsyncLoadItem(self, prefabPath, cls, parent, callback)
end

function TacticalCardUtil:CreateOneCardItem(cardType, parent, callback)
  local prefabPath, cls = TacticalCardUtil.GetCardConfigByCardType(cardType)
  if not prefabPath or not cls then
    return nil
  end
  return TacticalCardUtil.InstantiateAsyncLoadItem(self, prefabPath, cls, parent, callback)
end

function TacticalCardUtil.ClearTargetAllCardItemCpt(target)
  if not target then
    return
  end
  target:RemoveComponents(require("UI.LWUITCCardMain.Component.CardEntity.TCCoreCardItemComponent"))
  target:RemoveComponents(require("UI.LWUITCCardMain.Component.CardEntity.TCNormalCardItemComponent"))
end

function TacticalCardUtil:InstantiateAsyncLoadItem(prefabPath, cls, parent, callback)
  local request = self:GameObjectInstantiateAsync(prefabPath)
  request:completed("+", function(req)
    if req.isError then
      return
    end
    local go = req.gameObject
    local name = tostring(NameCount)
    go.name = name
    NameCount = NameCount + 1
    local trans = go.transform
    local handle = parent or self
    trans:SetParent(handle.transform)
    trans.transform:Reset()
    local slotItem = handle:AddComponent(require(cls), name)
    if callback then
      callback(slotItem)
    end
  end)
  return request
end

function TacticalCardUtil.GetMainCoreCardFromSameCard(cardDataA, cardDataB)
  if not cardDataA or not cardDataB then
    return false
  end
  if cardDataA.cardId ~= cardDataB.cardId then
    return false
  end
  if cardDataA.cardType ~= TacticalCardType.Core or cardDataB.cardType ~= TacticalCardType.Core then
    return false
  end
  if cardDataA.slotId ~= cardDataB.slotId then
    return true, cardDataA.slotId > cardDataB.slotId and cardDataA or cardDataB
  end
  if cardDataA.star ~= cardDataB.star then
    return true, cardDataA.star > cardDataB.star and cardDataA or cardDataB
  end
  if cardDataA.level ~= cardDataB.level then
    return true, cardDataA.level > cardDataB.level and cardDataA or cardDataB
  end
  return true, cardDataA
end

function TacticalCardUtil.GetAllIdleCardDataList(cardType, qualityFilter)
  local ret = {}
  if cardType == TacticalCardSlotType.Core then
    ret = TacticalCardUtil.GetAllUnEquipCoreMainCardList()
  else
    local allIdleCardDic = DataCenter.TacticalCardDataManager.allIdleCardDic
    for _, v in pairs(allIdleCardDic) do
      local isPassQualityFilter = not qualityFilter or TacticalCardUtil.IsTargetQualityOrBelow(v, qualityFilter)
      if v.cardType == cardType and not v:IsEquip() and isPassQualityFilter then
        table.insert(ret, v)
      end
    end
  end
  return ret
end

function TacticalCardUtil.IsTargetQualityOrBelow(cardData, quality)
  if not quality then
    return true
  end
  return quality >= cardData:GetCardQuality()
end

function TacticalCardUtil.GetAllUnEquipCoreMainCardList()
  local ret = {}
  local allCoreMainDic = DataCenter.TacticalCardDataManager.allCoreCardDataDic
  for _, v in pairs(allCoreMainDic) do
    local cardList = v
    local coreMainCard = cardList[1]
    if coreMainCard and not coreMainCard:IsEquip() then
      table.insert(ret, coreMainCard)
    end
  end
  return ret
end

function TacticalCardUtil.GetAllCoreMainCardList()
  local ret = {}
  local allCoreMainDic = DataCenter.TacticalCardDataManager.allCoreCardDataDic
  for _, v in pairs(allCoreMainDic) do
    local cardList = v
    local coreMainCard = cardList[1]
    if coreMainCard then
      table.insert(ret, coreMainCard)
    end
  end
  return ret
end

function TacticalCardUtil.GetSlotTypeIconPath(slotType)
  if slotType == TacticalCardSlotType.Battle then
    return "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_zhandou.png"
  elseif slotType == TacticalCardSlotType.Economy then
    return "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_jingji.png"
  else
    return "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_zhandou.png"
  end
end

function TacticalCardUtil.GetCardQualityColorBarImgPath(quality)
  if quality == TacticalCardQualityType.White then
    return "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_biaotou01.png"
  elseif quality == TacticalCardQualityType.Green then
    return "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_biaotou02.png"
  elseif quality == TacticalCardQualityType.Blue then
    return "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_biaotou03.png"
  elseif quality == TacticalCardQualityType.Purple then
    return "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_biaotou04.png"
  elseif quality == TacticalCardQualityType.Orange then
    return "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_biaotou05.png"
  else
    return "Assets/Main/Sprites/UI/UILWTC/FX_zhanshukapai_biaotou01.png"
  end
end

function TacticalCardUtil.GetQualityColorHex(quality)
  if quality == TacticalCardQualityType.White then
    return "#8d8d8d"
  elseif quality == TacticalCardQualityType.Green then
    return "#29b76b"
  elseif quality == TacticalCardQualityType.Blue then
    return "#3193e4"
  elseif quality == TacticalCardQualityType.Purple then
    return "#b243e5"
  elseif quality == TacticalCardQualityType.Orange then
    return "#ED9031"
  else
    return "#8d8d8d"
  end
end

function TacticalCardUtil.GetCardFrameByQuality(cardType, showType, quality)
  local isCore = cardType == TacticalCardType.Core
  local isSimpleShow = showType == TacticalCardShowType.SimpleShow
  if isCore then
    return isSimpleShow and CORE_SIMPLE_FRAME_PATH[quality] or CORE_DELUXE_FRAME_PATH[quality]
  else
    return isSimpleShow and SINGLE_SIMPLE_FRAME_PATH[quality] or SINGLE_DELUXE_FRAME_PATH[quality]
  end
end

function TacticalCardUtil.GetLevelStrLv(cardLv)
  local lvStr = cardLv and tostring(cardLv) or "0"
  return Localization:GetString("140002", lvStr)
end

function TacticalCardUtil.GetLevelStr(cardData)
  if not cardData then
    return Localization:GetString("140002", 1)
  end
  local baseLvDesc = Localization:GetString("140002", cardData:GetRealLevel())
  local extraLv = cardData:GetRandomEffectValue(TacticalCardUtil.Effect_Card_Upgrade)
  if 0 < extraLv then
    extraLv = math.floor(extraLv + 0.5)
    return string.format("%s+<color=#5FEF87>%s</color>", baseLvDesc, extraLv)
  else
    return baseLvDesc
  end
end

function TacticalCardUtil.GetCardFullNameStr(cardData)
  if not cardData or not cardData.template then
    return ""
  end
  local name = Localization:GetString(cardData.template.name)
  local cardTypeName = TacticalCardUtil.GetCardTypeNameStr(cardData:GetCardType())
  return Localization:GetString("battle_card_name", cardTypeName, name)
end

function TacticalCardUtil.GetCardTypeNameStr(cardType)
  if not cardType then
    return ""
  end
  if cardType == TacticalCardType.Core then
    return Localization:GetString("battle_card_core")
  elseif cardType == TacticalCardType.Battle then
    return Localization:GetString("battle_card_battle")
  elseif cardType == TacticalCardType.Economy then
    return Localization:GetString("battle_card_economic")
  end
  return Localization:GetString("battle_card_core")
end

function TacticalCardUtil.QuickGetSlotDataById(slotId)
  local mData = DataCenter.MasteryManager:GetData()
  if not mData then
    Logger.LogError("mastery data is not exist")
    return
  end
  local masteryId = mData.home_id
  local season = SeasonUtil.GetSeason()
  return DataCenter.TacticalCardSlotDataManager:GetSlotDataBySlotId(masteryId, season, slotId)
end

function TacticalCardUtil.IsFunctionOpen()
  local openInfo = LuaEntry.DataConfig:TryGetStr("battle_card_param", "k6", "")
  openInfo = string.split(openInfo, ";")
  if not openInfo or #openInfo < 2 then
    return false
  end
  local openSeason = toInt(openInfo[1])
  local startDay = toInt(openInfo[2])
  local curSeasonId = SeasonUtil.GetSeason()
  local curSeasonDay = SeasonUtil.GetSeasonDay()
  if openSeason > curSeasonId then
    return false
  elseif curSeasonId == openSeason then
    return startDay <= curSeasonDay
  else
    return true
  end
end

function TacticalCardUtil.GetCardLvRealId(type, color, lv, lvGroup)
  lvGroup = lvGroup or 0
  return lvGroup * 100000000 + type * 100000 + color * 1000 + lv
end

function TacticalCardUtil.GetCardStarRealId(id, star)
  return id * 100 + star
end

function TacticalCardUtil.GetCardSkillId(groupId, lv)
  return groupId * 1000 + lv
end

function TacticalCardUtil.GetBaseAttrs(id, lv, star)
  local template = DataCenter.TacticalCardDataManager:GetTemplateData(id)
  if not template then
    return nil
  end
  local attrs = {}
  local attr = template:GetBaseAttrs(lv)
  for attrId, value in pairs(attr) do
    attrs[attrId] = value
  end
  if star and 0 < star then
    local starId = TacticalCardUtil.GetCardStarRealId(id, star)
    local starTemplate = DataCenter.TacticalCardDataManager:GetStarTemplateData(starId)
    if starTemplate then
      for attrId, value in pairs(starTemplate.attr) do
        if attrs[attrId] then
          attrs[attrId] = attrs[attrId] + value
        else
          attrs[attrId] = value
          Logger.LogError("StarTemplate.attr not found in base attrs, attrId: " .. attrId)
        end
      end
    end
  end
  return attr
end

function TacticalCardUtil.GetCardSkills(id, star, lv)
  if 0 < star then
    local starId = TacticalCardUtil.GetCardStarRealId(id, star)
    local starTemplate = DataCenter.TacticalCardDataManager:GetStarTemplateData(starId)
    if starTemplate then
      return starTemplate.skill_list
    end
  else
    local template = DataCenter.TacticalCardDataManager:GetTemplateData(id)
    if template then
      local skills = template.skill
      local cardType = template.type
      if cardType == TacticalCardType.Core then
        return skills
      else
        local ret = {}
        for _, skillId in pairs(skills) do
          local skillTemplate = DataCenter.TacticalCardDataManager:GetSkillTemplateData(skillId)
          if skillTemplate then
            local skillGroup = skillTemplate.group
            local skillLv = lv
            local realSkillId = TacticalCardUtil.GetCardSkillId(skillGroup, skillLv)
            skillTemplate = DataCenter.TacticalCardDataManager:GetSkillTemplateData(realSkillId)
            if skillTemplate then
              table.insert(ret, realSkillId)
            end
          end
        end
        return ret
      end
    end
  end
  return {}
end

function TacticalCardUtil.GetCardPassiveSkills(id, lv, star, containNextValue)
  local template = DataCenter.TacticalCardDataManager:GetTemplateData(id)
  if template then
    local skills = template.skill
    local ret = {}
    for _, skillId in pairs(skills) do
      local skillTemplate = DataCenter.TacticalCardDataManager:GetSkillTemplateData(skillId)
      if skillTemplate and not skillTemplate:IsActive() then
        local skillGroup = skillTemplate.group
        local skillLv = lv
        local realSkillId = TacticalCardUtil.GetCardSkillId(skillGroup, skillLv)
        skillTemplate = DataCenter.TacticalCardDataManager:GetSkillTemplateData(realSkillId)
        if skillTemplate then
          local skill = {
            id = realSkillId,
            desc = skillTemplate:GetDesc(),
            val = skillTemplate:GetFormattedViewAttr()
          }
          if containNextValue and skillTemplate.lv < skillTemplate.max_lv then
            local nextLvSkillTemplate = DataCenter.TacticalCardDataManager:GetSkillTemplateData(TacticalCardUtil.GetCardSkillId(skillTemplate.group, skillTemplate.lv + 1))
            if nextLvSkillTemplate then
              skill.nextVal = nextLvSkillTemplate:GetFormattedViewAttr()
            end
          end
          table.insert(ret, skill)
        end
      end
    end
    return ret
  end
  return {}
end

function TacticalCardUtil.QuickGetCardSkills(cardId, star, lv)
  local cardTmp = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
  if not cardTmp then
    return {}
  end
  local cardType = cardTmp.type
  if cardType == TacticalCardType.Core then
    return TacticalCardUtil.GetCardSkills(cardId, star)
  else
    local ret = {}
    local initSkillIdList = cardTmp:GetSkills()
    for _, skillId in pairs(initSkillIdList) do
      local skillTmp = DataCenter.TacticalCardDataManager:GetSkillTemplateData(skillId)
      local skillGroup = skillTmp.group
      local realSkillId = TacticalCardUtil.GetCardSkillId(skillGroup, lv)
      table.insert(ret, realSkillId)
    end
    return ret
  end
  return {}
end

function TacticalCardUtil.GetCardUpgradeCost(type, color, curLv, lvGroup)
  local lvId = TacticalCardUtil.GetCardLvRealId(type, color, curLv + 1, lvGroup)
  local lvTemplate = DataCenter.TacticalCardDataManager:GetLevelTemplateData(lvId)
  if not lvTemplate then
    return nil
  end
  local cost = lvTemplate.cost
  if cost == nil or #cost < 2 then
    return nil, nil
  end
  local itemId = cost[1]
  local itemCnt = cost[2]
  return itemId, itemCnt
end

function TacticalCardUtil.GetCardStarUpgradeCost(id, star)
  local starId = TacticalCardUtil.GetCardStarRealId(id, star + 1)
  local starTemplate = DataCenter.TacticalCardDataManager:GetStarTemplateData(starId)
  if not starTemplate then
    return nil, nil
  end
  return starTemplate.card_id, starTemplate.cost
end

function TacticalCardUtil.GetCardSalvageMat(type, color, curLv, lvGroup)
  local lvId = TacticalCardUtil.GetCardLvRealId(type, color, curLv, lvGroup)
  local lvTemplate = DataCenter.TacticalCardDataManager:GetLevelTemplateData(lvId)
  if not lvTemplate then
    return nil
  end
  local matInfo = string.split(lvTemplate.resolve_reward, ";")
  if matInfo == nil or #matInfo < 2 then
    return nil, nil
  end
  local itemId = toInt(matInfo[1])
  local itemCnt = toInt(matInfo[2])
  return itemId, itemCnt
end

function TacticalCardUtil.GetNextLvBaseAttrs(cardId, lv, star, maxLv)
  local baseAttrs = TacticalCardUtil.GetBaseAttrs(cardId, lv, star)
  local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
  if not cardTemplate then
    return {}
  end
  local nextBaseAttrs
  if maxLv then
    if lv < maxLv then
      nextBaseAttrs = TacticalCardUtil.GetBaseAttrs(cardId, lv + 1, star)
    end
  elseif lv < cardTemplate.max_lv then
    nextBaseAttrs = TacticalCardUtil.GetBaseAttrs(cardId, lv + 1, star)
  end
  local attr = {}
  for k, v in pairs(baseAttrs) do
    attr[k] = {id = k, value = v}
  end
  if nextBaseAttrs then
    for k, v in pairs(nextBaseAttrs) do
      if not attr[k] then
        attr[k] = {
          id = k,
          value = 0,
          nextValue = v
        }
      else
        attr[k].nextValue = v
      end
    end
  end
  local arr = {}
  for _, v in pairs(attr) do
    table.insert(arr, v)
  end
  local orders = {}
  for _, v in ipairs(arr) do
    local order = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateSequence(v.id)
    orders[v.id] = order
  end
  table.sort(arr, function(a, b)
    if orders[a.id] ~= orders[b.id] then
      return orders[a.id] < orders[b.id]
    end
    return a.id < b.id
  end)
  return arr
end

function TacticalCardUtil.GetNextStarBaseAttrs(cardId, lv, star)
  local baseAttrs = TacticalCardUtil.GetBaseAttrs(cardId, lv, star)
  local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
  if not cardTemplate then
    return {}
  end
  local nextBaseAttrs
  if star < cardTemplate.max_star then
    nextBaseAttrs = TacticalCardUtil.GetBaseAttrs(cardId, lv, star + 1)
  end
  local attr = {}
  for k, v in pairs(baseAttrs) do
    attr[k] = {id = k, value = v}
  end
  if nextBaseAttrs then
    for k, v in pairs(nextBaseAttrs) do
      if not attr[k] then
        attr[k] = {
          id = k,
          value = 0,
          nextValue = v
        }
      else
        attr[k].nextValue = v
      end
    end
  end
  local arr = {}
  for _, v in pairs(attr) do
    table.insert(arr, v)
  end
  local orders = {}
  for _, v in ipairs(arr) do
    local order = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateSequence(v.id)
    orders[v.id] = order
  end
  table.sort(arr, function(a, b)
    if orders[a.id] ~= orders[b.id] then
      return orders[a.id] < orders[b.id]
    end
    return a.id < b.id
  end)
  return arr
end

function TacticalCardUtil.GetNextStarSkills(cardId, star)
  local skillList = TacticalCardUtil.GetCardSkills(cardId, star)
  local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
  if not cardTemplate then
    return {}
  end
  local nextStarSkillList
  if star < cardTemplate.max_star then
    nextStarSkillList = TacticalCardUtil.GetCardSkills(cardId, star + 1)
  end
  local skills = {}
  for _, v in ipairs(skillList) do
    local skillTemplate = DataCenter.TacticalCardDataManager:GetSkillTemplateData(v)
    if skillTemplate then
      skills[skillTemplate.group] = {
        group = skillTemplate.group,
        id = v
      }
    end
  end
  if nextStarSkillList then
    for _, v in ipairs(nextStarSkillList) do
      local skillTemplate = DataCenter.TacticalCardDataManager:GetSkillTemplateData(v)
      if skillTemplate then
        if skills[skillTemplate.group] and skills[skillTemplate.group].id ~= v then
          skills[skillTemplate.group].nextId = v
        elseif not skills[skillTemplate.group] then
          skills[skillTemplate.group] = {
            group = skillTemplate.group,
            nextId = v
          }
        end
      end
    end
  end
  local ret = {}
  for _, v in pairs(skills) do
    table.insert(ret, v)
  end
  table.sort(ret, function(a, b)
    return a.group < b.group
  end)
  return ret
end

function TacticalCardUtil.OpenTacticalCardMain()
  if not TacticalCardUtil.IsFunctionOpen() then
    UIUtil.ShowTipsId(120105)
    return false
  end
  local isOpen = DataCenter.MasteryManager:Enabled()
  if isOpen then
    local data = DataCenter.MasteryManager:GetData()
    if data == nil then
      UIUtil.ShowTipsId("season_mastery_error_code_01")
    elseif data.home_id == 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMastery, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
    else
      local params = {}
      params.tabType = MasteryTabType.TacticalCard
      params.data = {
        homeId = data.home_id
      }
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryCenterTab, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, params)
      return true
    end
  else
    UIUtil.ShowTipsId("season_mastery_error_code_01")
  end
  return false
end

function TacticalCardUtil.CreateFakeCardData(cardId, level, star, randomAttr)
  local fakeServerData = {}
  fakeServerData.uuid = "fake_" .. tostring(math.random(10000, 99999))
  fakeServerData.cardId = cardId
  fakeServerData.level = level or 0
  fakeServerData.star = star or 0
  fakeServerData.randomAttr = randomAttr or {}
  local fakeCardData = TacticalCardData.New()
  fakeCardData:UpdateData(fakeServerData)
  return fakeCardData
end

function TacticalCardUtil.CheckSlotLockState(slotId)
  if not TacticalCardUtil.IsFunctionOpen() then
    return true
  end
  local slotData = TacticalCardUtil.QuickGetSlotDataById(slotId)
  if not slotData then
    return false
  end
  return slotData:IsLock()
end

function TacticalCardUtil.CheckSlotIsShowRedDot(slotId)
  if not TacticalCardUtil.IsFunctionOpen() then
    return false
  end
  local slotData = TacticalCardUtil.QuickGetSlotDataById(slotId)
  if not slotData then
    return false
  end
  if slotData:IsLock() or slotData:IsEquipCard() then
    return false
  end
  local slotCardType = slotData:GetSlotType()
  local curAllIdleCardList = TacticalCardUtil.GetAllIdleCardDataList(slotCardType)
  local canEquipCardCount = 0
  for _, v in ipairs(curAllIdleCardList) do
    local isEquippedSameCardId = TacticalCardUtil.IsEquippedSameCardId(v.cardId)
    if not isEquippedSameCardId then
      local isExistCardTypeGroup, cardTypeGroup = v:GetCardTypeGroup()
      if isExistCardTypeGroup then
        local isEquippedSameCardTypeGroup = TacticalCardUtil.IsEquippedSameCardTypeGroup(cardTypeGroup)
        if isEquippedSameCardTypeGroup then
          goto lbl_49
        end
      end
      canEquipCardCount = canEquipCardCount + 1
    end
    ::lbl_49::
  end
  return 0 < canEquipCardCount
end

function TacticalCardUtil.IsExistAnySlotShowRedDot()
  if not TacticalCardUtil.IsFunctionOpen() then
    return false
  end
  local masteryData = DataCenter.MasteryManager:GetData()
  if not masteryData then
    return false
  end
  local masteryId = masteryData.home_id
  local season = SeasonUtil.GetSeason()
  local allSlotDataList = DataCenter.TacticalCardSlotDataManager:GetAllSlotDataList(masteryId, season)
  if not allSlotDataList then
    return false
  end
  for _, v in pairs(allSlotDataList) do
    local isCanEquipCard = TacticalCardUtil.CheckSlotIsShowRedDot(v.slotId)
    if isCanEquipCard then
      return true
    end
  end
  return false
end

function TacticalCardUtil.IsExistCardCachaRed()
  if not TacticalCardUtil.IsFunctionOpen() then
    return false
  end
  if DataCenter.TacticalCardDataManager:HasClaimableBoxPointReward() then
    return true
  end
  local showRedWhenBeyondNum = LuaEntry.DataConfig:TryGetNum("battle_card_param", "k7", 1)
  local currentSeason = DataCenter.SeasonDataManager:GetSeason()
  local allBoxDataList = DataCenter.TacticalCardDataManager:GetAllBoxGoodsIdBySeason(currentSeason)
  if not allBoxDataList then
    return false
  end
  for _, v in pairs(allBoxDataList) do
    local boxGoodsId = v.goods_id
    local hadCount = DataCenter.ItemData:GetItemCount(boxGoodsId)
    if showRedWhenBeyondNum <= hadCount then
      return true
    end
  end
  return false
end

function TacticalCardUtil.QuickGetAllSlotDataList()
  local mData = DataCenter.MasteryManager:GetData()
  if not mData then
    Logger.LogError("mastery data is not exist")
    return
  end
  local masteryId = mData.home_id
  local season = SeasonUtil.GetSeason()
  return DataCenter.TacticalCardSlotDataManager:GetAllSlotDataList(masteryId, season)
end

function TacticalCardUtil.GetCurQuickEquipCardList(sortIndex, wantEquipCardIdDic)
  local ret = {}
  local allSlotData = TacticalCardUtil.QuickGetAllSlotDataList()
  if not allSlotData then
    return ret
  end
  local wantCardIdDic = {}
  local wantEquipSlotIdList = {}
  if wantEquipCardIdDic then
    wantCardIdDic = {}
    wantEquipSlotIdList = {}
    for slotId, cardId in pairs(wantEquipCardIdDic) do
      wantCardIdDic[cardId] = true
      table.insert(wantEquipSlotIdList, slotId)
    end
    table.sort(wantEquipSlotIdList, function(a, b)
      return b < a
    end)
  end
  local slotArr = {}
  for _, v in pairs(allSlotData) do
    if v:IsCanEquipCard() then
      table.insert(slotArr, v)
    end
  end
  table.sort(slotArr, function(a, b)
    return a.slotId < b.slotId
  end)
  local temp = {}
  
  local function AddSortWeightToTemp(cardData, sortIndex)
    if cardData then
      local sortWeight = cardData:GetSortWeightByIndex(sortIndex) or 0
      if wantCardIdDic and wantCardIdDic[cardData.cardId] then
        temp[cardData] = -1
      else
        temp[cardData] = sortWeight
      end
    end
  end
  
  local allCardTypeDic = {}
  local allCardType = {
    TacticalCardType.Core,
    TacticalCardType.Battle,
    TacticalCardType.Economy
  }
  for _, v in pairs(allCardType) do
    allCardTypeDic[v] = TacticalCardUtil.GetAllIdleCardDataList(v)
  end
  local curEquipCardList = DataCenter.TacticalCardDataManager:GetAllEquipCardData()
  for _, v in pairs(curEquipCardList) do
    local cardType = v:GetCardType()
    if not v:IsInCd() and allCardTypeDic[cardType] then
      table.insert(allCardTypeDic[cardType], v)
    end
  end
  for _, v in pairs(allCardTypeDic) do
    for _, cardData in ipairs(v) do
      AddSortWeightToTemp(cardData, sortIndex)
    end
    table.sort(v, function(a, b)
      local aWeight = temp[a] or 0
      local bWeight = temp[b] or 0
      if aWeight ~= bWeight then
        return aWeight < bWeight
      end
      local aPower = a:GetPower()
      local bPower = b:GetPower()
      if aPower ~= bPower then
        return aPower > bPower
      end
      return a.uuid < b.uuid
    end)
  end
  local equippedCardIdDic = {}
  local equippedCardTypeGroupDic = {}
  local equippedCoreCardCache
  
  local function IsCardCanEquip(cardData, slotCardData)
    local isExistSameCardId = equippedCardIdDic[cardData.cardId]
    if isExistSameCardId then
      return false, nil
    end
    local isExistCardTypeGroup, cardTypeGroup = cardData:GetCardTypeGroup()
    if isExistCardTypeGroup then
      local isExistSameCardTypeGroup = equippedCardTypeGroupDic[cardTypeGroup]
      if isExistSameCardTypeGroup then
        return false, nil
      end
    end
    if slotCardData then
      local isSameCard = slotCardData.uuid == cardData.uuid
      if isSameCard then
        return false, slotCardData
      end
      local isSameCardId = slotCardData.cardId == cardData.cardId
      local isSamePower = slotCardData:GetPower() == cardData:GetPower()
      if isSameCardId and isSamePower then
        return false, slotCardData
      end
    end
    return true, cardData
  end
  
  for _, v in ipairs(slotArr) do
    if v:IsCanEquipCard() then
      local cardType = v:GetSlotType()
      local cardList = allCardTypeDic[cardType]
      local slotCardData = v:GetCardData()
      for i, cardData in ipairs(cardList) do
        local isCanEquip, equipCardData = IsCardCanEquip(cardData, slotCardData)
        if equipCardData then
          equippedCardIdDic[equipCardData.cardId] = true
          local isExistCardTypeGroup, cardTypeGroup = equipCardData:GetCardTypeGroup()
          if isExistCardTypeGroup then
            equippedCardTypeGroupDic[cardTypeGroup] = true
          end
          ret[v.slotId] = equipCardData
          if equippedCoreCardCache == nil and equipCardData:IsCoreCard() then
            equippedCoreCardCache = equipCardData
          end
          break
        end
      end
    end
  end
  return ret
end

function TacticalCardUtil.GetPreferGuideBoxId(cardId)
  if not cardId then
    return nil
  end
  local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
  if not cardTemplate then
    return nil
  end
  local guideId
  local box_quality = cardTemplate.get_more_color
  local firstBoxId
  if not table.IsNullOrEmpty(box_quality) then
    for i, v in pairs(box_quality) do
      local boxTemplate = DataCenter.TacticalCardDataManager:GetBoxIdByQuality(v)
      if boxTemplate then
        local goodsId = boxTemplate:GetGoodsId()
        local hadCount = DataCenter.ItemData:GetItemCount(goodsId)
        if i == 1 then
          firstBoxId = boxTemplate.id
        end
        if 0 < hadCount then
          guideId = boxTemplate.id
          break
        end
      end
    end
    guideId = guideId or firstBoxId
  end
  return guideId
end

function TacticalCardUtil.CreateSkillClass(skillTmp)
  return TCSkillFactory.CreateSkill(skillTmp)
end

function TacticalCardUtil.IsEquippedSameCardId(cardId, excludeSlotId)
  local allEquipCardList = DataCenter.TacticalCardDataManager:GetAllEquipCardData()
  if not allEquipCardList then
    return false
  end
  for _, v in ipairs(allEquipCardList) do
    if v:GetCardId() == cardId and v.slotId ~= excludeSlotId then
      return true
    end
  end
  return false
end

function TacticalCardUtil.IsEquippedSameCardTypeGroup(cardTypeGroup, excludeSlotId)
  if cardTypeGroup < 0 then
    return false
  end
  local allEquipCardList = DataCenter.TacticalCardDataManager:GetAllEquipCardData()
  if not allEquipCardList then
    return false
  end
  for _, v in ipairs(allEquipCardList) do
    if v.cardTypeGroup == cardTypeGroup and v.slotId ~= excludeSlotId then
      return true
    end
  end
  return false
end

function TacticalCardUtil.IsEquippedSameCardIdOrGroup(cardId, cardTypeGroup, excludeSlotId)
  local isExistSameCardId = TacticalCardUtil.IsEquippedSameCardId(cardId, excludeSlotId)
  if isExistSameCardId then
    return true
  end
  local isExistSameCardTypeGroup = TacticalCardUtil.IsEquippedSameCardTypeGroup(cardTypeGroup, excludeSlotId)
  if isExistSameCardTypeGroup then
    return true
  end
  return false
end

function TacticalCardUtil.CheckIsSameCard(cardDataA, cardDataB)
  if not cardDataA or not cardDataB then
    return false
  end
  if cardDataA.cardId == cardDataB.cardId then
    return true
  end
  local isExistCardTypeGroupA, cardTypeGroupA = cardDataA:GetCardTypeGroup()
  local isExistCardTypeGroupB, cardTypeGroupB = cardDataB:GetCardTypeGroup()
  if not isExistCardTypeGroupA or not isExistCardTypeGroupB then
    return false
  end
  return cardTypeGroupA == cardTypeGroupB
end

function TacticalCardUtil.IsShowWorldMasteryBtn()
  local isFunctionOpen = TacticalCardUtil.IsFunctionOpen()
  return isFunctionOpen
end

function TacticalCardUtil.GetAllActiveSkillDataList()
  local equipCardList = DataCenter.TacticalCardDataManager:GetAllEquipCardData()
  local ret = {}
  for _, v in pairs(equipCardList) do
    local skillDataList = v:GetAllSkillDataList(TacticalCardSkillType.Active)
    if skillDataList then
      for _, skillData in ipairs(skillDataList) do
        table.insert(ret, skillData)
      end
    end
  end
  return ret
end

function TacticalCardUtil.GetCardCollectSkillParams(worldPointId)
  if not worldPointId then
    return MarchTargetType.COLLECT, nil
  end
  local resourceInfo = CS.SceneManager.World:GetPointInfo(worldPointId)
  if not resourceInfo then
    return MarchTargetType.COLLECT, nil
  end
  local pointType = resourceInfo.PointType
  if pointType == WorldPointType.WorldResource then
    return MarchTargetType.COLLECT, nil
  elseif pointType == WorldPointType.WorldAllianceCollectResource then
    return MarchTargetType.ALLIANCE_RESOURCE_COLLECT, resourceInfo.uuid
  else
    return MarchTargetType.COLLECT, nil
  end
end

function TacticalCardUtil.GetCardSkillCDState(skillData)
  if not skillData then
    return TCCardSkillState.None, 0
  end
  local skill = skillData.skillId
  if skill == nil or skill <= 0 then
    return TCCardSkillState.None, 0
  end
  local chargeData = skillData.chargeData
  if not chargeData then
    return TCCardSkillState.Normal, 0
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local cdOverTime = chargeData:GetAvailableTime()
  if curTime < cdOverTime then
    return TCCardSkillState.CD, cdOverTime
  end
  return TCCardSkillState.Normal, 0
end

function TacticalCardUtil.IsInAnyBattleField()
  local isInAnyBattleField = BattleFieldUtil.InBattleField()
  return isInAnyBattleField
end

function TacticalCardUtil.IsEquipTargetCardSkillEffect(targetSkillEffect)
  local curAllActiveSkillDataList = TacticalCardUtil.GetAllActiveSkillDataList()
  if not curAllActiveSkillDataList then
    return false
  end
  for _, v in ipairs(curAllActiveSkillDataList) do
    local skillData = v
    if skillData:GetSkillEffectType() == targetSkillEffect then
      return true
    end
  end
  return false
end

function TacticalCardUtil.OpenCardBox(gotoId)
  if not TacticalCardUtil.IsFunctionOpen() then
    UIUtil.ShowTipsId(120105)
    return
  end
  local isOpen = DataCenter.MasteryManager:Enabled()
  if isOpen then
    local data = DataCenter.MasteryManager:GetData()
    if data and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIMasteryCenterTab) then
      local params = {}
      params.tabType = MasteryTabType.TacticalCard
      params.data = {
        homeId = data.home_id
      }
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryCenterTab, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, params)
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardBoxPanel, {anim = true}, gotoId)
end

local CardInfoPanelWindowParam

function TacticalCardUtil:OpenViewCard(cardId, lv, star, randomAttr)
  if not CardInfoPanelWindowParam then
    CardInfoPanelWindowParam = require("UI.LWUITC.UITCCardInfoPanel.Ctrl.CardInfoPanelUtil")
  end
  local windowParam = CardInfoPanelWindowParam.New()
  windowParam.id = cardId
  windowParam.level = lv
  windowParam.star = star
  windowParam.randomAttr = randomAttr
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardInfoPanel, {anim = true}, windowParam)
end

function TacticalCardUtil:OpenViewCardDeck(ownerName, cards)
  local windowParam = {}
  windowParam.ownerName = ownerName
  windowParam.cards = cards
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCViewCardDeckPanel, {anim = true}, windowParam)
end

local OnGoingGotoWorldCastSkill

function TacticalCardUtil.GotoWorldCastSkill(skillData)
  if not skillData then
    return
  end
  local curSkillState = skillData:GetCastSkillState()
  if curSkillState ~= TCCardSkillState.Normal then
    return
  end
  local cardUuid = skillData.cardUuid
  local skillGroupId = skillData:GetSkillGroupId()
  if not skillGroupId then
    Logger.LogError("not find skill groupId. skillId" .. skillData.skillId)
    return
  end
  local skillTmp = skillData.template
  if not skillTmp then
    Logger.LogError("not find skill template. skillId" .. skillData.skillId)
    return
  end
  GoToUtil.CloseAllWindows()
  if SceneUtils.CheckCanGotoWorld() then
    if OnGoingGotoWorldCastSkill then
      OnGoingGotoWorldCastSkill:Stop()
    end
    SceneUtils.ChangeToWorld(function()
      OnGoingGotoWorldCastSkill = TimerManager:GetInstance():DelayInvoke(function()
        OnGoingGotoWorldCastSkill = nil
        SFSNetwork.SendMessage(MsgDefines.BattleCardUseSkill, cardUuid, skillGroupId, {})
      end, 0.25)
    end)
  else
    SFSNetwork.SendMessage(MsgDefines.BattleCardUseSkill, cardUuid, skillGroupId, {})
  end
end

function TacticalCardUtil.GetCardAttrValue(id, value)
  local effName
  local showTemp = DataCenter.TacticalCardDataManager:GetRandomAttributeShowTemplate(id)
  if showTemp and not string.IsNullOrEmpty(showTemp.effect_name) then
    effName = showTemp.effect_name
  else
    effName = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(id)
  end
  local formatType = DataCenter.EffectNumberTemplateManager:GetEffectNumberType(id)
  local effValStr = HeroUtils.GetFormattedValue(formatType, value, false)
  return Localization:GetString(effName), effValStr
end

function TacticalCardUtil.GetCardDecomposeMat(cardData)
  if not cardData then
    return nil, nil
  end
  local cardType = cardData:GetCardType()
  local quality = cardData:GetCardQuality()
  local cardLv = cardData:GetLevel()
  local lvGroup = cardData:GetLvGroup()
  local lvUpgradeValue = cardData:GetRandomEffectValue(TacticalCardUtil.Effect_Card_Upgrade)
  if lvUpgradeValue then
    cardLv = cardLv - math.floor(lvUpgradeValue + 0.5)
  end
  local itemId, count = TacticalCardUtil.GetCardSalvageMat(cardType, quality, cardLv, lvGroup)
  return itemId, count
end

function TacticalCardUtil.GetCardConsumeExp(cardData)
  if not cardData then
    return 0, 0
  end
  local cardType = cardData:GetCardType()
  local quality = cardData:GetCardQuality()
  local currentLevel = cardData:GetLevel()
  local lvGroup = cardData:GetLvGroup()
  if currentLevel <= 1 then
    return 0, 0
  end
  local totalExp = 0
  local itemId = 0
  for lv = 1, currentLevel - 1 do
    local id, cnt = TacticalCardUtil.GetCardUpgradeCost(cardType, quality, lv, lvGroup)
    if id and cnt then
      totalExp = totalExp + cnt
      itemId = id
    end
  end
  return itemId, totalExp
end

function TacticalCardUtil.HasScoreRewardRedDot()
  if not TacticalCardUtil.IsFunctionOpen() then
    return false
  end
  return DataCenter.TacticalCardDataManager:HasClaimableBoxPointReward()
end

function TacticalCardUtil.GetEquipCoreDeck()
  local deck = TacticalCardUtil.CommonDeck
  local equipList = DataCenter.TacticalCardDataManager:GetAllEquipCardData()
  if equipList then
    for i, v in ipairs(equipList) do
      if v and v:IsCoreCard() and v:GetDeck() ~= TacticalCardUtil.CommonDeck then
        deck = v:GetDeck()
        break
      end
    end
  end
  return deck
end

function TacticalCardUtil.GetEquipCoreCardList()
  local list = {}
  local equipCards = DataCenter.TacticalCardDataManager:GetAllEquipCardData()
  for i, v in ipairs(equipCards) do
    if v and v:IsCoreCard() then
      table.insert(list, v)
    end
  end
  return list
end

function TacticalCardUtil.CanEquipCoreCardCheckDeck(curSlotCard, selectCard)
  local coreList = TacticalCardUtil.GetEquipCoreCardList()
  local result = true
  for i, v in ipairs(coreList) do
    if (not curSlotCard or v:GetEquipSlot() ~= curSlotCard:GetEquipSlot()) and v:GetDeck() ~= TacticalCardUtil.CommonDeck and selectCard:GetDeck() ~= TacticalCardUtil.CommonDeck and v:GetDeck() ~= selectCard:GetDeck() then
      result = false
      break
    end
  end
  return result
end

function TacticalCardUtil.GetSeasonCards(cardType)
  local curSeason = DataCenter.SeasonDataManager:GetSeason()
  local cards = DataCenter.TacticalCardDataManager:GetSeasonCards(curSeason, cardType)
  local cardsOnServer = {}
  for i, cardId in ipairs(cards) do
    local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
    if cardTemplate and cardTemplate:CheckServerCanSee() then
      table.insert(cardsOnServer, cardId)
    end
  end
  return cardsOnServer
end

function TacticalCardUtil.IsAnyCardInCD()
  local curEquipCardList = DataCenter.TacticalCardDataManager:GetAllEquipCardData()
  for _, v in pairs(curEquipCardList) do
    if v:IsInCd() then
      return true
    end
  end
  return false
end

return ConstClass("TacticalCardUtil", TacticalCardUtil)
