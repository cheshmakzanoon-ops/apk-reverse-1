local TacticalCardGroupData = BaseClass("TacticalCardGroupData")
local Localization = CS.GameEntry.Localization
local ArmyFormationUtils = require("DataCenter.ArmyFormationData.ArmyFormationUtils")
local QUICK_EQUIP_SLOT_IDS = {
  1,
  2,
  4,
  5,
  6,
  7,
  10,
  11,
  12,
  13
}

local function __init(self)
  self.name = nil
  self.cardDataList = nil
end

local function __delete(self)
  self.name = nil
  self.cardDataList = nil
end

function TacticalCardGroupData:Init(index)
  self.index = index
end

function TacticalCardGroupData:UpdateDataFromTemplate(tmpData)
  if not tmpData then
    return
  end
  self.name = Localization:GetString(tmpData.sort_name)
  self.sort = tmpData.sort
  local cardDataList = {}
  if tmpData.cardIds then
    for index, v in ipairs(tmpData.cardIds) do
      local cardData = {}
      local cardsInfoList = string.split(v, ";")
      if #cardsInfoList <= 1 then
        cardData.cardId = toInt(cardsInfoList[1])
      elseif #cardsInfoList == 3 then
        local tempDic = {}
        tempDic[HeroType.Tank] = toInt(cardsInfoList[1])
        tempDic[HeroType.Aircraft] = toInt(cardsInfoList[2])
        tempDic[HeroType.Missile] = toInt(cardsInfoList[3])
        local bestStrongHeroType = ArmyFormationUtils.GetStrongestHeroType()
        cardData.cardId = bestStrongHeroType and tempDic[bestStrongHeroType] or toInt(cardsInfoList[1])
      else
        cardData.cardId = toInt(cardsInfoList[1])
      end
      cardData.slot = index <= #QUICK_EQUIP_SLOT_IDS and QUICK_EQUIP_SLOT_IDS[index] or nil
      table.insert(cardDataList, cardData)
    end
  end
  self:SetCardDataList(cardDataList)
end

function TacticalCardGroupData:UpdateDataFromServerData(sData)
  if not sData then
    return
  end
  self.name = sData.name
  if not sData.plan then
    return
  end
  self.cardDataList = {}
  for _, v in ipairs(sData.plan) do
    local cardData = {}
    cardData.cardId = v.cardId
    cardData.uuid = v.uuid
    cardData.slot = v.slot
    cardData.cardType = v.slotType
    table.insert(self.cardDataList, cardData)
  end
end

function TacticalCardGroupData:ClearCardData()
  self.cardDataList = {}
end

function TacticalCardGroupData:SetCardDataList(cardDataList)
  self.cardDataList = cardDataList
end

function TacticalCardGroupData:IsEmptyCardGroup()
  return not self.cardDataList or #self.cardDataList <= 0
end

function TacticalCardGroupData:GetCardDataList()
  return self.cardDataList or {}
end

function TacticalCardGroupData:GetExistCardDataList()
  local ret = {}
  if not self.cardDataList then
    return ret
  end
  for _, v in ipairs(self.cardDataList) do
    if v.uuid and DataCenter.TacticalCardDataManager:GetCardData(v.uuid) then
      table.insert(ret, v)
    end
    if v.cardId and DataCenter.TacticalCardDataManager:HasCard(v.cardId) then
      table.insert(ret, v)
    end
  end
  return ret
end

function TacticalCardGroupData:GetCardGroupName()
  if self:IsEmptyCardGroup() then
    return self:GetDefaultName()
  end
  return not string.IsNullOrEmpty(self.name) and self.name or self:GetDefaultName()
end

function TacticalCardGroupData:GetDefaultName()
  return Localization:GetString(LuaEntry.DataConfig:TryGetStr("battle_card_param", "k21", "") or "battle_card_new_recommend_desc_4", self.index)
end

TacticalCardGroupData.__init = __init
TacticalCardGroupData.__delete = __delete
return TacticalCardGroupData
