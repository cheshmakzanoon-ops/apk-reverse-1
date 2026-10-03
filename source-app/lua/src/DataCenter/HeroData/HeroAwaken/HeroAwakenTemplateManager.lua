local HeroAwakenTemplateManager = BaseClass("HeroAwakenTemplateManager")
local LwHeroAwakenTemplate = require("DataCenter/HeroData/HeroAwaken/Template/LwHeroAwakenTemplate")
local LwHeroAwakenRankTemplate = require("DataCenter/HeroData/HeroAwaken/Template/LwHeroAwakenRankTemplate")

function HeroAwakenTemplateManager:__init()
  self.lwHeroAwakenTemplateDict = {}
  self.lwHeroAwakenRankTemplateDict = {}
end

function HeroAwakenTemplateManager:__delete()
  self.lwHeroAwakenTemplateDict = nil
  self.lwHeroAwakenRankTemplateDict = nil
end

function HeroAwakenTemplateManager:GetLwHeroAwakenTemplateById(id, isMustExist)
  if self.lwHeroAwakenTemplateDict[id] == nil then
    local rowData
    if isMustExist == true then
      rowData = LocalController:instance():getLine(TableName.LW_HERO_AWAKEN, id)
    else
      rowData = LocalController:instance():tryGetLine(TableName.LW_HERO_AWAKEN, id)
    end
    if rowData ~= nil then
      local template = LwHeroAwakenTemplate.New()
      template:UpdateData(rowData)
      self.lwHeroAwakenTemplateDict[id] = template
    end
  end
  return self.lwHeroAwakenTemplateDict[id]
end

function HeroAwakenTemplateManager:GetLwHeroAwakenRankTemplateById(id)
  if self.lwHeroAwakenRankTemplateDict[id] == nil then
    local rowData = LocalController:instance():getLine(TableName.LW_HERO_AWAKEN_RANK, id)
    if rowData ~= nil then
      local template = LwHeroAwakenRankTemplate.New()
      template:UpdateData(rowData)
      self.lwHeroAwakenRankTemplateDict[id] = template
    end
  end
  return self.lwHeroAwakenRankTemplateDict[id]
end

function HeroAwakenTemplateManager:GetLwHeroAwakenRankTemplateByHeroIdAndLevel(heroId, level)
  local rankId = HeroUtils.GetHeroAwakenRankIdByHeroIdAndLevel(heroId, level)
  if rankId == nil then
    return nil
  end
  return self:GetLwHeroAwakenRankTemplateById(rankId)
end

function HeroAwakenTemplateManager:GetHeroAwakenRankMaxLevelByHeroId(heroId)
  local awakenTemplate = self:GetLwHeroAwakenTemplateById(heroId, false)
  if awakenTemplate == nil then
    return 0
  end
  return awakenTemplate:GetHeroAwakenMaxRankLevel()
end

return HeroAwakenTemplateManager
