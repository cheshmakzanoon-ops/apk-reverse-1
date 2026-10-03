local SoldierDataTemplate = BaseClass("SoldierDataTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.resourceItemId = 0
  self.trainCost = {}
  self.trainTime = 0
  self.restoreHp = 0
  self.lv = 0
  self.quality = 0
  self.icon = ""
  self.model = ""
  self.effect = ""
  self.cureCost = {}
  self.cure_time = 0
  self.level_factor = 0
  self.life = nil
  self.defense = nil
  self.attack = nil
  self.rebirthCost = {}
  self.rebirthTime = 0
  self.rebirthCostStr = ""
  self.bubble_icon = ""
  self.train_need_buff = 0
end

local function __delete(self)
  self.id = nil
  self.resourceItemId = nil
  self.trainCost = nil
  self.trainTime = nil
  self.restoreHp = nil
  self.lv = nil
  self.quality = nil
  self.icon = nil
  self.model = nil
  self.effect = nil
  self.cureCost = nil
  self.cure_time = nil
  self.life = nil
  self.defense = nil
  self.attack = nil
  self.rebirthCost = nil
  self.rebirthTime = nil
  self.rebirthCostStr = nil
  self.bubble_icon = nil
  self.train_need_buff = nil
end

local function InitConfig(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.resourceItemId = tonumber(row:getValue("resource_item")) or 0
  self.trainCost = row:getValue("train_cost_consume") or {}
  self.trainTime = tonumber(row:getValue("train_time")) or 0
  self.restoreHp = tonumber(row:getValue("restore_hp")) or 0
  self.lv = tonumber(row:getValue("soldier_lv")) or 0
  self.quality = tonumber(row:getValue("quality")) or 0
  self.power = tonumber(row:getValue("power")) or 0
  self.burden = tonumber(row:getValue("plunder")) or 0
  self.attackCd = row:getValue("attackCd") or 0
  self.skillCd = row:getValue("skillCd") or 0
  self.model = row:getValue("model") or ""
  self.playback_hero_id = tonumber(row:getValue("playback_hero_id")) or 0
  self.effect = row:getValue("supply_lock_effect") or ""
  self.cureCost = row:getValue("cure_consume") or {}
  self.cureTime = row:getValue("cure_time") or 0
  self.hero_bonus = row:getValue("hero_bonus") or 0
  local attr_denominatorStr = row:getValue("attr_denominator") or ""
  local attr_denominator_time = row:getValue("attr_denominator_time") or ""
  self.attr_denominator = self:GetAttrDenominator(attr_denominatorStr, attr_denominator_time)
  self.train_need_barrack = row:getValue("train_need_barrack") or 0
  self.model_jc = row:getValue("model_jc") or ""
  self.level_factor = tonumber(row:getValue("level_factor")) or 0
  self.train_need_science = row:getValue("train_need_science") or nil
  local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.resourceItemId)
  if template ~= nil then
    self.icon = template.pic
    self.bubble_icon = template.bubble_icon
  else
    self.icon = ""
    self.bubble_icon = ""
  end
  self.type = tonumber(row:getValue("type")) or 0
  self:InitSoliderEffectNumber(row)
  self.soldier_multiplier = tonumber(row:getValue("soldier_multiplier")) or 1
  self.rebirthCost = {}
  self.rebirthCostStr = row:getValue("rescue_consume") or ""
  self.rebirthTime = tonumber(row:getValue("rescue_time")) or 0
  self.train_need_buff = tonumber(row:getValue("train_need_buff")) or 0
  self:InitRebirthCost()
end

function SoldierDataTemplate:GetOneEffectData(effect)
  return {
    effectId = effect[1],
    value = tonumber(effect[2])
  }
end

function SoldierDataTemplate:InitSoliderEffectNumber(row)
  local effects = row:getValue("soldier_effect_number")
  if string.IsNullOrEmpty(effects) then
    return
  end
  effects = string.split(effects, "|")
  for i = 1, #effects do
    if string.IsNullOrEmpty(effects[i]) then
      return
    end
    local effect = string.split(effects[i], ";")
    if 2 <= #effect then
      if i == 1 then
        self.life = self:GetOneEffectData(effect)
      elseif i == 2 then
        self.attack = self:GetOneEffectData(effect)
      elseif i == 3 then
        self.defense = self:GetOneEffectData(effect)
      end
    end
  end
end

function SoldierDataTemplate:InitRebirthCost()
  self.rebirthCost = {}
  if not string.IsNullOrEmpty(self.rebirthCostStr) then
    local rebirthCostStrList = string.split(self.rebirthCostStr, "|")
    if rebirthCostStrList ~= nil and 0 < #rebirthCostStrList then
      for _, v in pairs(rebirthCostStrList) do
        local singleCostStrList = string.split(v, ";")
        if singleCostStrList ~= nil and #singleCostStrList == 2 then
          self.rebirthCost[tonumber(singleCostStrList[1])] = tonumber(singleCostStrList[2])
        end
      end
    end
  end
end

function SoldierDataTemplate:GetAttrDenominator(denominatorStr, denominatorTime)
  if string.IsNullOrEmpty(denominatorStr) then
    return ""
  end
  local strList = string.split(denominatorStr, "|")
  if string.IsNullOrEmpty(denominatorTime) then
    return strList[1] or ""
  end
  local timeList = string.split(denominatorTime, "|")
  if #strList ~= #timeList then
    Logger.LogError("SoldierDataTemplate:GetAttrDenominator strList count not equal timeList count")
    return strList[1] or ""
  end
  local maxIndex = self:GetMaxDenominatorTimeIndex(denominatorTime)
  return strList[maxIndex] or ""
end

function SoldierDataTemplate:GetMaxDenominatorTimeIndex(denominatorTime)
  local maxIndex = 1
  local timeList = string.split(denominatorTime, "|")
  for i = 1, #timeList do
    local seasonConfig = string.split(timeList[i], ";")
    local seanNum = tonumber(seasonConfig[1]) or 0
    local day = tonumber(seasonConfig[2]) or 0
    local curSeason = SeasonUtil.GetSeason()
    local nowSeasonDay = SeasonUtil.GetSeasonDay()
    if seanNum < curSeason or curSeason == seanNum and day <= nowSeasonDay then
      maxIndex = i
    end
  end
  return maxIndex
end

SoldierDataTemplate.__init = __init
SoldierDataTemplate.__delete = __delete
SoldierDataTemplate.InitConfig = InitConfig
return SoldierDataTemplate
