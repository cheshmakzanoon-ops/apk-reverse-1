local HeroTryOutHeroData = BaseClass("HeroTryOutHeroData")

function HeroTryOutHeroData:__init()
  self.heroId = nil
end

function HeroTryOutHeroData:__delete()
  self.heroId = nil
end

function HeroTryOutHeroData:Update(heroId)
  self.heroId = heroId
end

function HeroTryOutHeroData:ShowEntrance()
end

function HeroTryOutHeroData:GetAllTagTemplates()
  local tagTemplates = {}
  LocalController:instance():visitTable(TableName.LW_HERO_TRY_OUT_TAG, function(id, lineData)
    if lineData ~= nil and lineData.hero_id == self.heroId then
      local template = DataCenter.HeroTryOutManager:GetLWHeroTryOutTagTemplateById(id)
      if template then
        table.insert(tagTemplates, template)
      end
    end
  end)
  table.sort(tagTemplates, function(a, b)
    return a.order < b.order
  end)
  return tagTemplates
end

function HeroTryOutHeroData:GetAllOpenUnfinishTagTemplates()
  local allTagTemplates = self:GetAllTagTemplates()
  local result = {}
  for _, tagTemplate in ipairs(allTagTemplates) do
    if tagTemplate:IsTagOpen() and not tagTemplate:IsFinishedAll() then
      table.insert(result, tagTemplate)
    end
  end
  return result
end

function HeroTryOutHeroData:IsShowEntrance()
  local allOpenTagTemplates = self:GetAllOpenUnfinishTagTemplates()
  if table.IsNullOrEmpty(allOpenTagTemplates) then
    return false
  end
  for _, tagTemplate in ipairs(allOpenTagTemplates) do
    local openTryOutTemplatesInGroup = tagTemplate:GetAllTryOutTemplatesInGroup()
    if not table.IsNullOrEmpty(openTryOutTemplatesInGroup) then
      for _, groupData in ipairs(openTryOutTemplatesInGroup) do
        if not table.IsNullOrEmpty(groupData.tryOutTemplates) then
          for _, tryOutTemplate in ipairs(groupData.tryOutTemplates) do
            local tmp = tryOutTemplate
            if not tmp:IsFinished() then
              return true
            end
          end
        end
      end
    end
  end
  return false
end

return HeroTryOutHeroData
