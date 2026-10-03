local DominatorTemplateManager = BaseClass("DominatorTemplateManager")
local DominatorMainTemplate = require("DataCenter/Dominator/TemplateManager/DominatorMainTemplate")
local DominatorRankTemplate = require("DataCenter/Dominator/TemplateManager/DominatorRankTemplate")
local DominatorRankShowTemplate = require("DataCenter/Dominator/TemplateManager/DominatorRankShowTemplate")
local DominatorTrainGroupTemplate = require("DataCenter/Dominator/TemplateManager/DominatorTrainGroupTemplate")
local DominatorTrainLevelTemplate = require("DataCenter/Dominator/TemplateManager/DominatorTrainLevelTemplate")
local DominatorStoryShowTemplate = require("DataCenter/Dominator/TemplateManager/DominatorStoryShowTemplate")
local Localization = CS.GameEntry.Localization

function DominatorTemplateManager:__init()
  self.mainTemplateDict = nil
  self.rankShowTemplateDict = nil
  self.trainGroupTemplateDict = nil
  self.rankTemplateDict = {}
  self.trainLevelTemplateDict = {}
  self.maxLevelRankTemplateDict = {}
  self.minLevelRankTemplateDict = {}
  self.storyShowTemplateDict = {}
  self.storyShowTemplateDictByGroup = {}
  self.allMainTrainGroupBigLevelTemplates = nil
end

function DominatorTemplateManager:__delete()
  self.mainTemplateDict = nil
  self.rankTemplateDict = nil
  self.rankShowTemplateDict = nil
  self.trainGroupTemplateDict = nil
  self.trainLevelTemplateDict = nil
  self.maxLevelRankTemplateDict = nil
  self.minLevelRankTemplateDict = nil
  self.storyShowTemplateDict = nil
  self.storyShowTemplateDictByGroup = nil
  self.allMainTrainGroupBigLevelTemplates = nil
end

function DominatorTemplateManager:TryInitMainTemplate()
  if self.mainTemplateDict == nil then
    self.mainTemplateDict = {}
    LocalController:instance():visitTable(TableName.DOMINATOR_MAIN, function(id, lineData)
      if self.mainTemplateDict[id] == nil and lineData ~= nil then
        local template = DominatorMainTemplate.New()
        template:UpdateData(lineData)
        self.mainTemplateDict[id] = template
      end
    end)
  end
end

function DominatorTemplateManager:TryInitRankShowTemplate()
  if self.rankShowTemplateDict == nil then
    self.rankShowTemplateDict = {}
    LocalController:instance():visitTable(TableName.DOMINATOR_RANK_SHOW, function(id, lineData)
      if self.rankShowTemplateDict[id] == nil and lineData ~= nil then
        local template = DominatorRankShowTemplate.New()
        template:UpdateData(lineData)
        self.rankShowTemplateDict[id] = template
      end
    end)
  end
end

function DominatorTemplateManager:TryInitTrainGroupTemplate()
  if self.trainGroupTemplateDict == nil then
    self.trainGroupTemplateDict = {}
    LocalController:instance():visitTable(TableName.DOMINATOR_TRAIN_GROUP, function(id, lineData)
      if self.trainGroupTemplateDict[id] == nil and lineData ~= nil then
        local template = DominatorTrainGroupTemplate.New()
        template:UpdateData(lineData)
        self.trainGroupTemplateDict[id] = template
      end
    end)
    table.sort(self.trainGroupTemplateDict, function(a, b)
      return a.id < b.id
    end)
  end
end

function DominatorTemplateManager:GetTrainGroupTemplateById(id)
  id = tonumber(id)
  if id == nil then
    return nil
  end
  self:TryInitTrainGroupTemplate()
  if self.trainGroupTemplateDict[id] == nil then
    Logger.LogWarning("DominatorTemplateManager train group template warning: trying to get nonexistent id " .. id)
    return nil
  end
  return self.trainGroupTemplateDict[id]
end

function DominatorTemplateManager:GetMainTrainGroupTemplate()
  self:TryInitTrainGroupTemplate()
  if self.trainGroupTemplateDict then
    for i, v in pairs(self.trainGroupTemplateDict) do
      if v:IsMainGroup() then
        return v
      end
    end
  end
end

function DominatorTemplateManager:GetAllNormalTrainGroupTemplates()
  self:TryInitTrainGroupTemplate()
  local res = {}
  if self.trainGroupTemplateDict then
    for i, v in pairs(self.trainGroupTemplateDict) do
      if not v:IsMainGroup() then
        table.insert(res, v)
      end
    end
  end
  table.sort(res, function(a, b)
    return a.id < b.id
  end)
  return res
end

function DominatorTemplateManager:GetTrainLevelTemplateById(id)
  id = tonumber(id)
  if id == nil then
    return nil
  end
  if self.trainLevelTemplateDict[id] == nil then
    local rowData = LocalController:instance():getLine(TableName.DOMINATOR_TRAIN_LEVEL, id)
    if rowData ~= nil then
      local template = DominatorTrainLevelTemplate.New()
      template:UpdateData(rowData)
      self.trainLevelTemplateDict[id] = template
    end
  end
  return self.trainLevelTemplateDict[id]
end

function DominatorTemplateManager:GetMainTemplateById(mainId, printNotFoundLog)
  if printNotFoundLog == nil then
    printNotFoundLog = true
  end
  local id = tonumber(mainId)
  if id == nil then
    return nil
  end
  self:TryInitMainTemplate()
  if self.mainTemplateDict[id] == nil then
    if printNotFoundLog then
      Logger.LogWarning("DominatorTemplateManager main template warning: trying to get nonexistent id " .. mainId)
    end
    return nil
  end
  return self.mainTemplateDict[id]
end

function DominatorTemplateManager:GetMainTemplateByRankGroup(group)
  group = tonumber(group)
  if group == nil then
    return group
  end
  self:TryInitMainTemplate()
  for i, v in pairs(self.mainTemplateDict) do
    if v.dominator_star_id == group then
      return v
    end
  end
end

function DominatorTemplateManager:GetAllShowMainTemplates()
  self:TryInitMainTemplate()
  local res = {}
  if self.mainTemplateDict then
    for i, v in pairs(self.mainTemplateDict) do
      local info = DataCenter.DominatorManager:GetInfoById(v.id)
      if info and info:IsUnlocked() then
        table.insert(res, v)
      end
    end
  end
  return res
end

function DominatorTemplateManager:GetRankTemplateById(rankId)
  local id = tonumber(rankId)
  if id == nil then
    return nil
  end
  if self.rankTemplateDict[id] == nil then
    local rowData = LocalController:instance():getLine(TableName.DOMINATOR_RANK, id)
    if rowData ~= nil then
      local template = DominatorRankTemplate.New()
      template:UpdateData(rowData)
      self.rankTemplateDict[id] = template
    end
  end
  return self.rankTemplateDict[id]
end

function DominatorTemplateManager:GetRankShowTemplateById(id)
  id = tonumber(id)
  if id == nil then
    return nil
  end
  self:TryInitRankShowTemplate()
  if self.rankShowTemplateDict[id] == nil then
    Logger.LogWarning("DominatorTemplateManager rank show template warning: trying to get nonexistent id " .. id)
    return nil
  end
  return self.rankShowTemplateDict[id]
end

function DominatorTemplateManager:GetAllRankShowTemplatesInOrderByGroup(group)
  self:TryInitRankShowTemplate()
  local res = {}
  for i, v in pairs(self.rankShowTemplateDict) do
    if v.group_id == group then
      table.insert(res, v)
    end
  end
  table.sort(res, function(a, b)
    return a.star_level < b.star_level
  end)
  return res
end

function DominatorTemplateManager:GetMaxBigLevelRankShowTemplateByGroup(group)
  local allTemplates = self:GetAllRankShowTemplatesInOrderByGroup(group)
  if not table.IsNullOrEmpty(allTemplates) then
    return allTemplates[#allTemplates]
  end
  return nil
end

function DominatorTemplateManager:GetRankLevelName(rankGroup, rankLevel)
  local rankId = rankGroup + rankLevel
  local rankTemplate = self:GetRankTemplateById(rankId)
  if rankTemplate then
    local rankShowTemplate = rankTemplate:GetRankShowTemplate()
    if rankShowTemplate then
      return rankShowTemplate:GetName() .. "Lv." .. rankTemplate.level_order
    end
  end
  return ""
end

function DominatorTemplateManager:GetAppearanceId(dominatorId, rankLv)
  local mainTemplate = self:GetMainTemplateById(dominatorId)
  if mainTemplate then
    local rankId = mainTemplate.dominator_star_id + (rankLv or 0)
    local rankTemplate = self:GetRankTemplateById(rankId)
    if rankTemplate then
      local id = rankTemplate:GetRankShowAppearanceId()
      return id
    end
  end
  return 0
end

function DominatorTemplateManager:GetRankShowTemplateByIdAndRank(dominatorId, rankLv)
  local mainTemplate = self:GetMainTemplateById(dominatorId)
  if mainTemplate then
    local rankId = mainTemplate.dominator_star_id + (rankLv or 0)
    local rankTemplate = self:GetRankTemplateById(rankId)
    if rankTemplate then
      return rankTemplate:GetRankShowTemplate()
    end
  end
  return nil
end

function DominatorTemplateManager:GetMaxLevelRankTemplateByRankShowId(rankShowId)
  rankShowId = tonumber(rankShowId)
  if rankShowId == nil then
    return nil
  end
  if self.maxLevelRankTemplateDict == nil then
    self.maxLevelRankTemplateDict = {}
  end
  if self.maxLevelRankTemplateDict[rankShowId] == nil then
    local maxId, maxLevel
    LocalController:instance():visitTable(TableName.DOMINATOR_RANK, function(id, lineData)
      if lineData and lineData:getValue("star_judge") == rankShowId then
        local level = lineData:getValue("level_num") or 0
        if maxLevel == nil or level > maxLevel then
          maxId = id
          maxLevel = level
        end
      end
    end)
    if maxId then
      self.maxLevelRankTemplateDict[rankShowId] = self:GetRankTemplateById(maxId)
    end
  end
  return self.maxLevelRankTemplateDict[rankShowId]
end

function DominatorTemplateManager:GetMinLevelRankTemplateByRankShowId(rankShowId)
  rankShowId = tonumber(rankShowId)
  if rankShowId == nil then
    return nil
  end
  if self.minLevelRankTemplateDict == nil then
    self.minLevelRankTemplateDict = {}
  end
  if self.minLevelRankTemplateDict[rankShowId] == nil then
    local minId, minLevel
    LocalController:instance():visitTable(TableName.DOMINATOR_RANK, function(id, lineData)
      if lineData and lineData:getValue("star_judge") == rankShowId then
        local level = lineData:getValue("level_num") or 0
        if minLevel == nil or level < minLevel then
          minId = id
          minLevel = level
        end
      end
    end)
    if minId then
      self.minLevelRankTemplateDict[rankShowId] = self:GetRankTemplateById(minId)
    end
  end
  return self.minLevelRankTemplateDict[rankShowId]
end

function DominatorTemplateManager:GetStoryShowTemplateById(id)
  id = tonumber(id)
  if id == nil then
    return nil
  end
  if self.storyShowTemplateDict[id] == nil then
    local rowData = LocalController:instance():getLine(TableName.DOMINATOR_STORY_SHOW, id)
    if rowData ~= nil then
      local template = DominatorStoryShowTemplate.New()
      template:UpdateData(rowData)
      self.storyShowTemplateDict[id] = template
    end
  end
  return self.storyShowTemplateDict[id]
end

function DominatorTemplateManager:GetAllStoryShowTemplatesByGroupId(groupId)
  groupId = tonumber(groupId)
  if groupId == nil then
    return nil
  end
  if self.storyShowTemplateDictByGroup[groupId] == nil then
    self.storyShowTemplateDictByGroup[groupId] = {}
    LocalController:instance():visitTable(TableName.DOMINATOR_STORY_SHOW, function(id, lineData)
      if lineData ~= nil and lineData.group_id == groupId then
        local template = self:GetStoryShowTemplateById(id)
        if template then
          table.insert(self.storyShowTemplateDictByGroup[groupId], template)
        end
      end
    end)
    table.sort(self.storyShowTemplateDictByGroup[groupId], function(a, b)
      return a:GetOrder() < b:GetOrder()
    end)
  end
  return self.storyShowTemplateDictByGroup[groupId]
end

function DominatorTemplateManager:GetAllMainTrainGroupBigLevelTemplates()
  if self.allMainTrainGroupBigLevelTemplates == nil then
    self.allMainTrainGroupBigLevelTemplates = {}
    local mainGroupTemplate = self:GetMainTrainGroupTemplate()
    if mainGroupTemplate then
      do
        local tmpDict = {}
        LocalController:instance():visitTable(TableName.DOMINATOR_TRAIN_LEVEL, function(id, lineData)
          if lineData ~= nil and lineData.level_group == mainGroupTemplate.id then
            local fillMin = false
            local fillMax = false
            if tmpDict[lineData.grade_order] == nil then
              fillMin = true
              fillMax = true
            else
              local curGradeNumMin = tmpDict[lineData.grade_order].grade_num_min
              if curGradeNumMin == nil or curGradeNumMin > lineData.grade_num then
                fillMin = true
              end
              local curGradeNumMax = tmpDict[lineData.grade_order].grade_num_max
              if curGradeNumMax == nil or curGradeNumMax < lineData.grade_num then
                fillMax = true
              end
            end
            if fillMin then
              if tmpDict[lineData.grade_order] == nil then
                tmpDict[lineData.grade_order] = {}
              end
              tmpDict[lineData.grade_order].grade_num_min = lineData.grade_num
              tmpDict[lineData.grade_order].minId = id
            end
            if fillMax then
              if tmpDict[lineData.grade_order] == nil then
                tmpDict[lineData.grade_order] = {}
              end
              tmpDict[lineData.grade_order].grade_num_max = lineData.grade_num
              tmpDict[lineData.grade_order].maxId = id
            end
          end
        end)
        for i, v in pairs(tmpDict) do
          local minTemplate = self:GetTrainLevelTemplateById(v.minId)
          local maxTemplate = self:GetTrainLevelTemplateById(v.maxId)
          local data = {
            grade_order = checknumber(i),
            minTemplate = minTemplate,
            maxTemplate = maxTemplate
          }
          table.insert(self.allMainTrainGroupBigLevelTemplates, data)
        end
        table.sort(self.allMainTrainGroupBigLevelTemplates, function(a, b)
          return a.grade_order < b.grade_order
        end)
      end
    end
  end
  return self.allMainTrainGroupBigLevelTemplates
end

function DominatorTemplateManager:GetDominatorIdByUpgradeRankItem(rankItemId)
  self:TryInitMainTemplate()
  local dominatorId = 0
  for i, v in pairs(self.mainTemplateDict) do
    if v:GetUpgradeRankCostItemId() == rankItemId then
      dominatorId = v.id
      break
    end
  end
  return dominatorId
end

return DominatorTemplateManager
