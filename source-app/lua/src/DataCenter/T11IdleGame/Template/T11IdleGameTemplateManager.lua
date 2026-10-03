local T11IdleGameTemplateManager = BaseClass("T11IdleGameTemplateManager")
local T11IdleGameTemplate = require("DataCenter/T11IdleGame/Template/T11IdleGameTemplate")
local T11IdleGameNodeTemplate = require("DataCenter/T11IdleGame/Template/T11IdleGameNodeTemplate")
local T11IdleGameBossTemplate = require("DataCenter/T11IdleGame/Template/T11IdleGameBossTemplate")
local T11IdleGameEventTemplate = require("DataCenter/T11IdleGame/Template/T11IdleGameEventTemplate")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")

function T11IdleGameTemplateManager:__init()
  self.levelTemplateDict = nil
  self.nodeTemplateDict = {}
  self.bossTemplateDict = {}
  self.gameEventTemplateDict = {}
  self.bossTotalCount = -1
  self.idleGameSoldierAssetPathDict = nil
  self.idleGameSoldierAssetPathDictT11 = nil
  self.surpriseBoxRewardDataList = nil
  self.soldierSkillIdDict = nil
end

function T11IdleGameTemplateManager:__delete()
  self.levelTemplateDict = nil
  self.nodeTemplateDict = nil
  self.bossTemplateDict = nil
  self.gameEventTemplateDict = nil
  self.bossTotalCount = nil
  self.idleGameSoldierAssetPathDict = nil
  self.idleGameSoldierAssetPathDictT11 = nil
  self.surpriseBoxRewardDataList = nil
  self.soldierSkillIdDict = nil
end

function T11IdleGameTemplateManager:TryInitLevelTemplate()
  if self.levelTemplateDict == nil then
    self.levelTemplateDict = {}
    LocalController:instance():visitTable(TableName.LW_IDLE_GAME, function(id, lineData)
      if self.levelTemplateDict[id] == nil and lineData ~= nil then
        local template = T11IdleGameTemplate.New()
        template:UpdateData(lineData)
        self.levelTemplateDict[id] = template
      end
    end)
  end
end

function T11IdleGameTemplateManager:GetAllLevelTemplatesInOrder()
  self:TryInitLevelTemplate()
  local res = {}
  if self.levelTemplateDict then
    for i, v in pairs(self.levelTemplateDict) do
      table.insert(res, v)
    end
  end
  table.sort(res, function(a, b)
    return a.stage_order < b.stage_order
  end)
  return res
end

function T11IdleGameTemplateManager:GetLevelTemplateById(id)
  id = tonumber(id)
  if id == nil then
    return nil
  end
  self:TryInitLevelTemplate()
  return self.levelTemplateDict[id]
end

function T11IdleGameTemplateManager:GetLevelTemplateByLevel(level)
  self:TryInitLevelTemplate()
  for i, v in pairs(self.levelTemplateDict) do
    if v.stage_order == level then
      return v
    end
  end
  return nil
end

function T11IdleGameTemplateManager:GetNodeTemplateById(id)
  id = tonumber(id)
  if id == nil then
    return nil
  end
  if self.nodeTemplateDict[id] == nil then
    local rowData = LocalController:instance():getLine(TableName.LW_IDLE_GAME_NODE, id)
    if rowData ~= nil then
      local template = T11IdleGameNodeTemplate.New()
      template:UpdateData(rowData)
      self.nodeTemplateDict[id] = template
    end
  end
  return self.nodeTemplateDict[id]
end

function T11IdleGameTemplateManager:GetBossTemplateById(id)
  id = tonumber(id)
  if id == nil then
    return nil
  end
  if self.bossTemplateDict[id] == nil then
    local rowData = LocalController:instance():getLine(TableName.LW_IDLE_GAME_BOSS, id)
    if rowData ~= nil then
      local template = T11IdleGameBossTemplate.New()
      template:UpdateData(rowData)
      self.bossTemplateDict[id] = template
    end
  end
  return self.bossTemplateDict[id]
end

function T11IdleGameTemplateManager:GetIdleBattleSoldierAssetPath(soldierId)
  local soldierMeta = DataCenter.SoldierDataManager:GetTemplate(soldierId)
  if soldierMeta == nil then
    return nil
  end
  local isSuper = T11Util.IsSuperSoldier(soldierMeta.lv)
  if not isSuper then
    if self.idleGameSoldierAssetPathDict == nil then
      self.idleGameSoldierAssetPathDict = {}
      local str = LuaEntry.DataConfig:TryGetStr("idle_game_para", "k9")
      if not string.IsNullOrEmpty(str) then
        local pair1 = string.split(str, "|")
        for i, v in ipairs(pair1) do
          local pair2 = string.split(v, ";")
          if #pair2 == 2 then
            local id = checknumber(pair2[1])
            local path = pair2[2]
            self.idleGameSoldierAssetPathDict[id] = path
          end
        end
      end
    end
    return self.idleGameSoldierAssetPathDict[soldierId]
  else
    local t11TmpData = T11Util.GetCurT11SoldierTmpData()
    if t11TmpData then
      if self.idleGameSoldierAssetPathDictT11 == nil then
        self.idleGameSoldierAssetPathDictT11 = {}
        local str = LuaEntry.DataConfig:TryGetStr("idle_game_para", "k15")
        if not string.IsNullOrEmpty(str) then
          local pair1 = string.split(str, "|")
          for i, v in ipairs(pair1) do
            local pair2 = string.split(v, ";")
            if #pair2 == 2 then
              local id = checknumber(pair2[1])
              local path = pair2[2]
              self.idleGameSoldierAssetPathDictT11[id] = path
            end
          end
        end
      end
      return self.idleGameSoldierAssetPathDictT11[t11TmpData.id]
    end
  end
end

function T11IdleGameTemplateManager:GetIdleBattleSoldierHeroAppearanceMeta(soldierId)
  local soldierMeta = DataCenter.SoldierDataManager:GetTemplate(soldierId)
  if soldierMeta == nil then
    return nil
  end
  local isSuper = T11Util.IsSuperSoldier(soldierMeta.lv)
  if not isSuper then
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(soldierMeta.playback_hero_id)
    if heroTemplate ~= nil then
      return DataCenter.AppearanceTemplateManager:GetTemplate(heroTemplate.appearance)
    end
  else
    local t11TmpData = T11Util.GetCurT11SoldierTmpData()
    if t11TmpData then
      return DataCenter.AppearanceTemplateManager:GetTemplate(t11TmpData.hero_appearance_id)
    end
  end
end

function T11IdleGameTemplateManager:GetIdleBattleSoldierIconPath(soldierId)
  local soldierMeta = DataCenter.SoldierDataManager:GetTemplate(soldierId)
  if soldierMeta == nil then
    return nil
  end
  local isSuper = T11Util.IsSuperSoldier(soldierMeta.lv)
  if not isSuper then
    return string.format(LoadPath.ItemPath, soldierMeta.icon)
  else
    local t11TmpData = T11Util.GetCurT11SoldierTmpData()
    if t11TmpData then
      return t11TmpData.icon
    end
  end
end

function T11IdleGameTemplateManager:GetGameEventTemplateById(id)
  id = tonumber(id)
  if id == nil then
    return nil
  end
  if self.gameEventTemplateDict[id] == nil then
    local rowData = LocalController:instance():getLine(TableName.LW_IDLE_GAME_EVENT, id)
    if rowData ~= nil then
      local template = T11IdleGameEventTemplate.New()
      template:UpdateData(rowData)
      self.gameEventTemplateDict[id] = template
    end
  end
  return self.gameEventTemplateDict[id]
end

function T11IdleGameTemplateManager:GetSurpriseBoxRewardData()
  if self.surpriseBoxRewardDataList == nil then
    self.surpriseBoxRewardDataList = {}
    local rewardStr = LuaEntry.DataConfig:TryGetStr("idle_game_para", "k10")
    if not string.IsNullOrEmpty(rewardStr) then
      local split1 = string.split(rewardStr, "|")
      for i, v in ipairs(split1) do
        local split2 = string.split(v, ";")
        if #split2 == 4 then
          local reward = {
            rewardType = checknumber(split2[1]),
            itemId = checknumber(split2[2]),
            count = checknumber(split2[3])
          }
          table.insert(self.surpriseBoxRewardDataList, reward)
        end
      end
    end
  end
  return self.surpriseBoxRewardDataList
end

function T11IdleGameTemplateManager:GetSoldierSkillId(soldierId)
  if self.soldierSkillIdDict == nil then
    self.soldierSkillIdDict = {}
    local dataStr = LuaEntry.DataConfig:TryGetStr("idle_game_para", "k11")
    if not string.IsNullOrEmpty(dataStr) then
      local split1 = string.split(dataStr, "|")
      for i, v in ipairs(split1) do
        local split2 = string.split(v, ";")
        if #split2 == 2 then
          self.soldierSkillIdDict[split2[1]] = tonumber(split2[2])
        end
      end
    end
  end
  return self.soldierSkillIdDict[tostring(soldierId)]
end

function T11IdleGameTemplateManager:GetBattleContentStayTipsSeconds()
  return LuaEntry.DataConfig:TryGetNum("idle_game_para", "k16", 0) * 60
end

return T11IdleGameTemplateManager
