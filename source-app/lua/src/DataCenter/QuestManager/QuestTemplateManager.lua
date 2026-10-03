local QuestTemplateManager = BaseClass("QuestTemplateManager")

local function __init(self)
  self.questTemplateDic = {}
end

local function __delete(self)
  self.questTemplateDic = nil
end

local function GetQuestTemplate(self, id)
  local numId = tonumber(id)
  local item = self.questTemplateDic[numId]
  if item == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.QuestXml, tostring(id))
    if oneTemplate ~= nil then
      item = QuestTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.questTemplateDic[item.id] = item
      end
    end
  end
  return item
end

QuestTemplateManager.__init = __init
QuestTemplateManager.__delete = __delete
QuestTemplateManager.GetQuestTemplate = GetQuestTemplate
return QuestTemplateManager
