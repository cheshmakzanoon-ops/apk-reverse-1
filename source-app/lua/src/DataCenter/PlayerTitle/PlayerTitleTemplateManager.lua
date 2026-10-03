local PlayerTitleTemplateManager = BaseClass("PlayerTitleTemplateManager")
local PlayerTitleTemplate = require("DataCenter.PlayerTitle.PlayerTitleTemplate")

function PlayerTitleTemplateManager:__init()
  self.titleList = {}
  self.levelLinkDic = {}
end

function PlayerTitleTemplateManager:__delete()
  self.titleList = {}
end

function PlayerTitleTemplateManager:CreateTitleInfo(id)
  local lineData = LocalController:instance():tryGetLine(TableName.LW_TITLE, id)
  if lineData == nil then
    return
  end
  local template = PlayerTitleTemplate.New()
  template:InitData(lineData)
  if template.nextCfgId then
    self.levelLinkDic[template.nextCfgId] = template.id
  end
  self.titleList[id] = template
  return template
end

function PlayerTitleTemplateManager:GetTitleInfo(id)
  if id == nil then
    return
  end
  if self.titleList[id] then
    return self.titleList[id]
  end
  return self:CreateTitleInfo(id)
end

function PlayerTitleTemplateManager:GetLastTitleInfo(id)
  if id == nil then
    return
  end
  local cfgId = self.levelLinkDic[id]
  if cfgId == nil then
    return
  end
  return self:GetTitleInfo(cfgId)
end

return PlayerTitleTemplateManager
