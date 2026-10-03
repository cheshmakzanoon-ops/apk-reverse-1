local StatusManager = BaseClass("StatusManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.warFeverConfirmFlag = true
  self.statusTempEffectData = {}
end

local function __delete(self)
  self.warFeverConfirmFlag = nil
  self.shieldStatusIds = nil
  self.statusTempEffectData = nil
end

local function Startup(self)
  LocalController:instance():visitTable(TableName.StatusTab, function(id, lineData)
    if lineData and tonumber(lineData.effect) == EffectDefine.MAIN_SHIELD then
      self.shieldStatusIds[id] = true
    end
  end)
end

local function GetShieldStatusIds(self)
  if not self.shieldStatusIds then
    self.shieldStatusIds = {}
    LocalController:instance():visitTable(TableName.StatusTab, function(id, lineData)
      if lineData and tonumber(lineData.effect) == EffectDefine.MAIN_SHIELD then
        self.shieldStatusIds[id] = true
      end
    end)
  end
  return self.shieldStatusIds
end

local function GetAllStatusItem(self)
  local list = LuaEntry.Effect:GetStatusMap()
  local param = {}
  for k, v in pairs(list) do
    if param[k] == nil then
      param[k] = v
    end
  end
  return param
end

local function GetWarFeverData(self)
  local value = LuaEntry.DataConfig:TryGetStr("war_attack", "k1")
  local warFeverData = {}
  if value ~= nil and value ~= "" then
    local vec = string.split(value, "|")
    for k, v in ipairs(vec) do
      local vec1 = string.split(v, ";")
      if 2 <= #vec1 then
        local need = {}
        need.level = tonumber(vec1[1])
        need.status = tonumber(vec1[2])
        table.insert(warFeverData, need)
      end
    end
  end
  return warFeverData
end

local function GetWarFeverStatuByLevel(self, level)
  local warFeverData = self:GetWarFeverData()
  for i, v in pairs(warFeverData) do
    if level == v.level then
      local statItem = LocalController:instance():getLine(TableName.StatusTab, tostring(v.status))
      return statItem
    end
  end
end

local function ShowTipForWarFever(self)
  local needBrokenProtect = false
  local needConfirm = false
  local isPop = false
  local isFeverStatu = self:WarFeverStatu()
  local statuData = DataCenter.StatusManager:GetWarFeverStatuByLevel(DataCenter.BuildManager.MainLv)
  local protectEndTime = DataCenter.DefenceWallDataManager:GetDefenceWallData().protectEndTime
  local leftTime = protectEndTime - UITimeManager:GetInstance():GetServerTime()
  local content, title
  if isPop and statuData ~= nil and isFeverStatu == nil then
    needConfirm = true
    title = Localization:GetString("100378")
    local time = math.modf(statuData.time / 60)
    if 0 < leftTime then
      content = Localization:GetString("129033", statuData.effect_num, time)
    else
      content = Localization:GetString("129029", statuData.effect_num, time)
    end
  elseif 0 < leftTime then
    needBrokenProtect = true
    content = Localization:GetString("120016")
  end
  if BattleFieldUtil.InBattleField() then
    needConfirm = false
    needBrokenProtect = false
  end
  return needConfirm, statuData, title, content, needBrokenProtect
end

local function GetWarFeverConfirmFlag(self)
  return self.warFeverConfirmFlag
end

local function SetWarFeverConfirmFlag(self, value)
  self.warFeverConfirmFlag = value
end

local function WarFeverStatu(self)
  local param
  local effectStatus = self:GetAllStatusItem()
  local now = UITimeManager:GetInstance():GetServerTime()
  local leftTime = 0
  for k, v in pairs(effectStatus) do
    local intKey = tonumber(k)
    local numValue = tonumber(v)
    local statItem = LocalController:instance():getLine(TableName.StatusTab, tostring(intKey))
    if statItem and tonumber(statItem.type2) == CityBuffType.WarFever then
      leftTime = numValue - now
      if 0 < leftTime then
        param = statItem.effect_num
        break
      end
    end
  end
  return param, leftTime
end

local function GetBuffTimeInfo(self, buffId)
  local intBuffId = tonumber(buffId)
  local effectStatus = self:GetAllStatusItem()
  if effectStatus[intBuffId] then
    local statItem = LocalController:instance():getLine(TableName.StatusTab, intBuffId)
    local param = {}
    param.endTime = effectStatus[intBuffId]
    param.totalTime = statItem.time * 1000
    param.intKey = intBuffId
    return param
  end
end

local function GetBuffPerformanceInfo(self, buffId)
  local info = {modelName = "", troopState = 0}
  local line = LocalController:instance():getLine(TableName.StatusTab, buffId)
  if line ~= nil then
    info.modelName = line.model
    info.troopState = line.troop_state
  end
  return info
end

local function GetAllBuffData(self, checkRange)
  local ret = {}
  local effectStatus = self:GetAllStatusItem()
  local now = UITimeManager:GetInstance():GetServerTime()
  local meta
  local mgr = LocalController:instance()
  for k, v in pairs(effectStatus) do
    local intKey = toInt(k)
    local numValue = tonumber(v)
    if mgr:hasLine(TableName.StatusEffect, intKey) then
      local StatusEffect = mgr:getLine(TableName.StatusEffect, intKey)
      if StatusEffect == nil or StatusEffect.is_show == nil or toInt(StatusEffect.is_show) ~= 1 then
        meta = mgr:getLine(TableName.StatusTab, intKey)
      end
    else
      meta = mgr:getLine(TableName.StatusTab, intKey)
    end
    if meta ~= nil and (toInt(meta.type2) ~= StatusType2.SkinAnimationType or not not string.IsNullOrEmpty(meta.buff_show_config)) and toInt(meta.type2) ~= StatusType2.SkinAnimationType2025Easter and intKey ~= CityState.VirusCityMax and intKey ~= CityState.VirusCityMaxEffect then
      local time = numValue - now
      if 0 < time then
        local param = {}
        param.endTime = numValue
        if meta.time and meta.time ~= "" and meta.time ~= "-1" then
          param.totalTime = meta.time * 1000
        else
          param.totalTime = IntMaxValue * 1000
        end
        param.id = intKey
        param.meta = meta
        param.order = meta.order or 1
        if string.IsNullOrEmpty(meta.color) then
          param.color = Color.white
        else
          local RR, GG, BB = string.match(meta.color or "ffffff", "(%w%w)(%w%w)(%w%w)")
          if RR and GG and BB then
            param.color = Color.New(tonumber("0x" .. RR) / 255, tonumber("0x" .. GG) / 255, tonumber("0x" .. BB) / 255, 1)
          else
            param.color = Color.white
          end
        end
        local isInsert = true
        if checkRange == true then
          local isInRange = UIUtil.CheckStateIsInRange(intKey)
          if isInRange == false then
            isInsert = false
          end
        end
        if isInsert == true then
          table.insert(ret, param)
        end
      end
    end
  end
  table.sort(ret, function(a, b)
    if a.order == b.order then
      return a.id > b.id
    end
    return a.order > b.order
  end)
  return ret
end

function StatusManager:GetBuff(statusId, checkRange)
  if not statusId then
    return
  end
  local id = tonumber(statusId)
  local list = self:GetAllBuffData(checkRange)
  for i, v in ipairs(list) do
    if v and v.id == id then
      return v
    end
  end
  return nil
end

local function GetTemplate(self, statusId)
  local line = LocalController:instance():getLine(TableName.StatusTab, statusId)
  return line
end

function StatusManager:GetDescByStatusId(statusId)
  local template = self:GetTemplate(statusId)
  if not template then
    return ""
  end
  local desc = template.description
  local effectIds = string.split(template.effect, "|")
  local effectValues = string.split(template.effect_num, "|")
  if effectIds and effectValues and 0 < #effectIds and #effectIds == #effectValues then
    local effectValueStringArr = {}
    for i, effectId in ipairs(effectIds) do
      local effectValueString = UIUtil.GetEffectStr(nil, effectValues[i], tonumber(effectId))
      table.insert(effectValueStringArr, effectValueString)
    end
    desc = CS.GameEntry.Localization:GetString(desc, table.unpack(effectValueStringArr))
  else
    desc = CS.GameEntry.Localization:GetString(desc)
  end
  return desc
end

local function CheckStatusType2(self, statusId, type2)
  local result = false
  local meta = LocalController:instance():getLine(TableName.StatusTab, tostring(statusId))
  if meta ~= nil and meta.type2 == tostring(type2) then
    result = true
  end
  return result
end

local function GetStatusType2(self, statusId)
  local type2 = 0
  local meta = LocalController:instance():getLine(TableName.StatusTab, tostring(statusId))
  if meta ~= nil then
    type2 = tonumber(meta.type2) or 0
  end
  return type2
end

function StatusManager:GetStatusSoundName(statusId)
  local template = self:GetTemplate(statusId)
  local sound = tonumber(template.music_sound) or 0
  if sound then
    return DataCenter.LWSoundManager:GetSound(sound)
  end
  return nil
end

function StatusManager:GetStatusSoundId(statusId)
  local template = self:GetTemplate(statusId)
  return tonumber(template.music_sound) or 0
end

function StatusManager:SetUseShieldCD()
  local now = UITimeManager:GetInstance():GetServerSeconds()
  self.shieldCDReady = now + 5
end

function StatusManager:IsUseShieldCD()
  if self.shieldCDReady and UITimeManager:GetInstance():GetServerSeconds() < self.shieldCDReady then
    UIUtil.ShowTipsId("shield_status_tips_1001")
    return true
  end
  return false
end

local function CheckHasStatusByType2(self, type2)
  local effectStatus = LuaEntry.Effect:GetStatusMap()
  local now = UITimeManager:GetInstance():GetServerTime()
  for statusId, endTime in pairs(effectStatus) do
    local intKey = tonumber(statusId)
    local numValue = tonumber(endTime)
    local statItem = LocalController:instance():getLine(TableName.StatusTab, intKey)
    if statItem and tonumber(statItem.type2) == type2 and now < numValue then
      return true
    end
  end
  return false
end

StatusManager.__init = __init
StatusManager.__delete = __delete
StatusManager.Startup = Startup
StatusManager.GetShieldStatusIds = GetShieldStatusIds
StatusManager.GetWarFeverData = GetWarFeverData
StatusManager.GetWarFeverStatuByLevel = GetWarFeverStatuByLevel
StatusManager.ShowTipForWarFever = ShowTipForWarFever
StatusManager.GetAllStatusItem = GetAllStatusItem
StatusManager.GetWarFeverConfirmFlag = GetWarFeverConfirmFlag
StatusManager.SetWarFeverConfirmFlag = SetWarFeverConfirmFlag
StatusManager.WarFeverStatu = WarFeverStatu
StatusManager.GetBuffTimeInfo = GetBuffTimeInfo
StatusManager.GetBuffPerformanceInfo = GetBuffPerformanceInfo
StatusManager.GetAllBuffData = GetAllBuffData
StatusManager.GetTemplate = GetTemplate
StatusManager.CheckStatusType2 = CheckStatusType2
StatusManager.GetStatusType2 = GetStatusType2
StatusManager.CheckHasStatusByType2 = CheckHasStatusByType2
return StatusManager
