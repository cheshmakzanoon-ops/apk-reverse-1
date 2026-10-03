local GoldTreeCombinations = BaseClass("GoldTreeCardTemplate")

local function __init(self)
  self.id = 0
  self.group = 0
  self.name = ""
  self.help_name = ""
  self.desc = ""
  self.desc_help = ""
  self.weight = 0
  self.card_combination = ""
  self.reward = ""
  self.card_display = ""
  self.hide = 0
end

local function __delete(self)
  self.id = 0
  self.group = 0
  self.name = nil
  self.help_name = nil
  self.desc = nil
  self.desc_help = nil
  self.weight = nil
  self.card_combination = nil
  self.reward = nil
  self.card_display = nil
  self.hide = 0
end

function GoldTreeCombinations:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.group = tonumber(row:getValue("group")) or 0
  self.name = row:getValue("name") or ""
  self.help_name = row:getValue("help_name") or ""
  self.desc = row:getValue("desc") or ""
  self.desc_help = row:getValue("desc_help") or ""
  self.weight = tonumber(row:getValue("weight")) or 0
  self.reward = row:getValue("reward") or ""
  self.card_display = row:getValue("card_display") or ""
  self.hide = tonumber(row:getValue("hide")) or 0
  local card_combination = row:getValue("card_combination") or ""
  local combinationList = string.split(card_combination, "|")
  self.cardCombinationType = combinationList[1] and tonumber(combinationList[1]) or 0
  if combinationList[2] then
    self.card_combination = string.split(combinationList[2], ",")
    for i, v in ipairs(self.card_combination) do
      self.card_combination[i] = tonumber(v) or 0
    end
  end
end

function GoldTreeCombinations:GetRewardList()
  if string.IsNullOrEmpty(self.reward) then
    return nil
  end
  return DataCenter.RewardTemplateManager:GetList(self.reward)
end

function GoldTreeCombinations:GetCardDisplayList()
  if string.IsNullOrEmpty(self.card_display) then
    return nil
  end
  local list = {}
  local cardList = string.split(self.card_display, ";")
  for i, idStr in ipairs(cardList) do
    list[i] = DataCenter.SeasonGoldTreeTemplateManager:GetCardTemp(idStr)
  end
  return list
end

local function getCardCounts(cardTypes)
  local countDic = {}
  for _, type in ipairs(cardTypes) do
    countDic[type] = (countDic[type] or 0) + 1
  end
  return countDic
end

local function MarchCardType1(cardTypes, param)
  for i, v in ipairs(param) do
    if cardTypes[i] ~= v then
      return false
    end
  end
  return true
end

local function MarchCardType2(cardTypes, param)
  local haveDic = {}
  for i, v in ipairs(cardTypes) do
    haveDic[v] = true
  end
  for i, v in ipairs(param) do
    if not haveDic[v] then
      return false
    end
  end
  return true
end

local function MarchCardType3(cardTypes, param)
  if not param or not param[1] then
    return false
  end
  param = tonumber(param[1])
  local countDic = getCardCounts(cardTypes)
  for _, count in pairs(countDic) do
    if count >= param then
      return true
    end
  end
  return false
end

local function MarchCardType4(cardTypes)
  local countDic = getCardCounts(cardTypes)
  local hasThree = false
  local hasTwo = false
  for _, count in pairs(countDic) do
    if 3 <= count then
      hasThree = true
    elseif 2 <= count then
      hasTwo = true
    end
  end
  return hasThree and hasTwo
end

local function MarchCardType5(cards)
  local countDic = getCardCounts(cards)
  local twoCount = 0
  for _, count in pairs(countDic) do
    if 2 <= count then
      twoCount = twoCount + 1
    end
  end
  return 2 <= twoCount
end

local __CheckFuncList = {
  [1] = MarchCardType1,
  [2] = MarchCardType2,
  [3] = MarchCardType3,
  [4] = MarchCardType4,
  [5] = MarchCardType5
}

function GoldTreeCombinations:GetCardCombinationsId(cards)
  local checkFunc = self.cardCombinationType and __CheckFuncList[self.cardCombinationType]
  if checkFunc and checkFunc(cards, self.card_combination) then
    return self.id
  end
  return 0
end

GoldTreeCombinations.__init = __init
GoldTreeCombinations.__delete = __delete
return GoldTreeCombinations
