local rapidjson = require("rapidjson")
local util = require("Common.Tools.cjson.util")
local DataConfig = BaseClass("DataConfig")

function DataConfig:__init()
  self.dataConfig = {}
  self.itemMd5 = ""
  self.alreadyInit = false
end

function DataConfig:InitFromTable()
  local path = util.GetPersistentDataPath()
  local name = path .. "/" .. "data_config.txt"
  local jsonStr = util.file_load(name)
  if jsonStr ~= nil then
    local message = rapidjson.decode(jsonStr)
    if message ~= nil then
      self.dataConfig = message
      self.alreadyInit = false
      if self.dataConfig.monster_interval ~= nil then
        local str = self.dataConfig.monster_interval
        local strArr = string.split(str, ";")
        if #strArr == 2 then
          CS.GameEntry.GlobalData:SetGlobalValue("staminaIntervalTime", strArr[2])
          CS.GameEntry.GlobalData:SetGlobalValue("staminaIntervalNum", strArr[1])
        end
      end
      if self.dataConfig.itemMd5 ~= nil then
        self.itemMd5 = self.dataConfig.itemMd5
      end
      self:LoadNewCommonResItem()
    end
  end
end

function DataConfig:InitFromLocalTable()
  if self.alreadyInit then
    return
  end
  LocalController:instance():visitTable(TableName.DataConfig, function(id, lineData)
    local tempData = DeepCopy(lineData)
    self.dataConfig[id] = tempData
  end)
  self.alreadyInit = true
  EventManager:GetInstance():Broadcast(EventId.PlayerSwitchStateInitCompleted)
end

function DataConfig:GetMd5()
  return self.itemMd5
end

function DataConfig:InitFromNet(msg)
  if msg.dataConfig ~= nil then
    self.dataConfig = msg.dataConfig
    self.alreadyInit = false
    if self.dataConfig.monster_interval ~= nil then
      local str = self.dataConfig.monster_interval
      local strArr = string.split(str, ";")
      if #strArr == 2 then
        CS.GameEntry.GlobalData:SetGlobalValue("staminaIntervalTime", strArr[2])
        CS.GameEntry.GlobalData:SetGlobalValue("staminaIntervalNum", strArr[1])
      end
    end
    if self.dataConfig.itemMd5 ~= nil then
      self.itemMd5 = self.dataConfig.itemMd5
    end
    self:LoadNewCommonResItem()
    local path = util.GetPersistentDataPath()
    local name = path .. "/" .. "data_config.txt"
    local jsonStr = rapidjson.encode(self.dataConfig)
    util.file_save(name, jsonStr)
  end
  self:InitFromLocalTable()
end

function DataConfig:CheckSwitch(key)
  local isSwitch = false
  if self.dataConfig ~= nil and self.dataConfig[key] ~= nil then
    local num = tonumber(self.dataConfig[key])
    if num == 1 then
      isSwitch = true
    end
    if CS.CommonUtils.IsDebug() and num == nil then
      Logger.LogError(string.format("\229\188\128\229\133\179%s\229\156\168item\232\161\168\228\184\173\228\185\159\229\173\152\229\156\168\239\188\140\232\175\183\230\163\128\230\159\165\233\133\141\231\189\174", key))
    end
  end
  return isSwitch
end

function DataConfig:GMManualSetSwitch(key, val)
  if not GMUtils.IsGM() then
    return
  end
  if not self.dataConfig then
    return
  end
  self.dataConfig[key] = val and 1 or 0
  CS.GameEntry.Data.Player:ClearAllCacheSwitch()
  UIUtil.ShowTips(string.format("[GM]\232\174\190\231\189\174\229\188\128\229\133\179%s\229\128\188\228\184\186%s", key, val and "\230\137\147\229\188\128" or "\229\133\179\233\151\173"))
end

function DataConfig:CheckSwitchSafe(key)
  if self.dataConfig ~= nil and self.dataConfig[key] ~= nil then
    local num = tonumber(self.dataConfig[key])
    return num == 1
  else
    return nil
  end
end

function DataConfig:GetObj(key1)
  if not self.alreadyInit then
    self:InitFromLocalTable()
  end
  if self.dataConfig ~= nil and self.dataConfig[key1] ~= nil then
    return self.dataConfig[key1]
  end
end

function DataConfig:GetValue(key1, key2, default)
  local obj = self:GetObj(key1)
  if obj ~= nil and obj[key2] ~= nil then
    return obj[key2]
  end
  return default
end

function DataConfig:TryGetStr(key1, key2, default)
  local value = self:GetValue(key1, key2)
  if value ~= nil then
    return tostring(value) or default or ""
  else
    return default or ""
  end
end

function DataConfig:TryGetNum(key1, key2, default)
  local value = self:GetValue(key1, key2)
  if value ~= nil then
    return tonumber(value) or default or 0
  else
    return default or 0
  end
end

function DataConfig:CheckServerIn(key1, key2, _serverId)
  local str = LuaEntry.DataConfig:TryGetStr(key1, key2)
  if str == nil or str == "" then
    return false
  end
  local arr = string.split_ss_array(str, ";")
  local serverId = toInt(_serverId)
  for k, v in ipairs(arr) do
    if v then
      local sMin, sMax = string.split_ss(v, "-")
      if sMin == nil then
      elseif sMax == nil then
        if serverId == tonumber(sMin) then
          return true
        end
      elseif serverId >= tonumber(sMin) and serverId <= tonumber(sMax) then
        return true
      end
    end
  end
  return false
end

function DataConfig:LoadNewCommonResItem()
  local oldCommonResItemLua = "UI.UICommonResItem.UICommonResItem"
  local newCommonResItemLua = "UI.UICommonResItem.UICommonResItemV2.UICommonResItem"
  if self.dataConfig.ui_common_res_item_V2 and tonumber(self.dataConfig.ui_common_res_item_V2) == 1 then
    UICommonResItem = require(newCommonResItemLua)
  elseif self.dataConfig.ui_common_res_item_V2 and tonumber(self.dataConfig.ui_common_res_item_V2) == 0 then
    UICommonResItem = require(oldCommonResItemLua)
  end
end

return DataConfig
