local LWTriggerItemTemplate = BaseClass("LWTriggerItemTemplate")
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")

local function __init(self)
end

local function __delete(self)
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.para = row:getValue("para")
  self.mutual_group = row:getValue("mutual_group")
  self.desc = row:getValue("desc")
  self.text = row:getValue("text")
  self.icon = row:getValue("icon")
  self.effect = row:getValue("effect")
  self.dead_effect = row:getValue("dead_effect")
  if self.type == TriggerEnum.EventType.ThreeChoices then
    local strArr = string.split(self.para, "|")
    self.paraArray = {}
    if 0 < #strArr then
      for i = 1, #strArr do
        table.insert(self.paraArray, tonumber(strArr[i]))
      end
    end
  elseif self.type == TriggerEnum.EventType.SummonMonsterBatch then
    local strArr = string.split(self.para, "|")
    self.summonMonsterBatchData = {}
    if 0 < #strArr then
      for i = 1, #strArr do
        table.insert(self.summonMonsterBatchData, tonumber(strArr[i]))
      end
    end
  elseif self.type == TriggerEnum.EventType.SummonFriendlyPet then
    if string.IsNullOrEmpty(self.para) then
      Logger.LogError("[LWTriggerItemTemplate.InitData] SummonFriendlyPet para is empty, triggerId\228\184\186:" .. tostring(self.id))
    end
    local strArr = string.split(self.para or "", "|")
    self.summonFriendlyPetData = {}
    self.summonFriendlyPetData.posType = tonumber(strArr[1]) or 0
    self.summonFriendlyPetData.petId = tonumber(strArr[2]) or 0
    if 0 >= self.summonFriendlyPetData.petId then
      Logger.LogError("[LWTriggerItemTemplate.InitData] SummonFriendlyPet petId is invalid, triggerId\228\184\186:" .. tostring(self.id))
    end
    if self.summonFriendlyPetData.posType == 1 then
      self.summonFriendlyPetData.slotIndex = tonumber(strArr[3]) or -1
    elseif self.summonFriendlyPetData.posType == 2 then
      local x = tonumber(strArr[3])
      local z = tonumber(strArr[4])
      if x == nil or z == nil then
        local posStr = strArr[3]
        if not string.IsNullOrEmpty(posStr) then
          local posArr = string.split(posStr, ",")
          if 2 <= #posArr then
            x = tonumber(posArr[1])
            z = tonumber(posArr[2])
          end
        end
      end
      if x == nil or z == nil then
        Logger.LogError("[LWTriggerItemTemplate.InitData] SummonFriendlyPet fixed pos parse failed, triggerId\228\184\186:" .. tostring(self.id))
      end
      self.summonFriendlyPetData.posX = x or 0
      self.summonFriendlyPetData.posZ = z or 0
    else
      Logger.LogError("[LWTriggerItemTemplate.InitData] SummonFriendlyPet posType is invalid, triggerId\228\184\186:" .. tostring(self.id))
    end
  end
  self.text_time = row:getValue("text_time") or 1
  self.gain_effect = row:getValue("gain_effect")
  self.gain_sound = row:getValue("gain_sound")
  self.gain_vibrate = row:getValue("gain_vibrate")
  self.desc_gaintext = row:getValue("desc_gaintext")
  self.gain_effect_multi = row:getValue("gain_effect_multi")
  self.gain_effect_multi_text = row:getValue("gain_effect_multi_text")
  local gainShake = row:getValue("gain_shake")
  if string.IsNullOrEmpty(gainShake) then
    self.gainShakeParam = nil
  else
    local strs = string.split(gainShake, "|")
    self.gainShakeParam = {}
    self.gainShakeParam.duration = tonumber(strs[1])
    self.gainShakeParam.strength = Vector3.New(tonumber(strs[2]), tonumber(strs[3]), tonumber(strs[4]))
    self.gainShakeParam.vibrato = tonumber(strs[5])
  end
  self.isUnAddEnergyType = self.type ~= TriggerEnum.EventType.AddEnergy and self.type ~= TriggerEnum.EventType.AddHeroIdEnergy
end

LWTriggerItemTemplate.__init = __init
LWTriggerItemTemplate.__delete = __delete
LWTriggerItemTemplate.InitData = InitData
return LWTriggerItemTemplate
