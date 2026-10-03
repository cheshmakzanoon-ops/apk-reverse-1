local ChapterTemplateManager = BaseClass("ChapterTemplateManager")

local function __init(self)
  self.questTemplateDic = nil
end

local function __delete(self)
  self.questTemplateDic = nil
end

local function GetQuestTemplate(self, questId)
  if not self.questTemplateDic then
    self.questTemplateDic = {}
    LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.Chapter), function(id, lineData)
      local id = lineData:getValue("id")
      local quest = lineData:getValue("quest")
      local str = string.split(quest, "|")
      self.questTemplateDic[id] = str
    end)
  end
  if self.questTemplateDic then
    for i = 1, #self.questTemplateDic do
      for k = 1, #self.questTemplateDic[i] do
        if tonumber(self.questTemplateDic[i][k]) == tonumber(questId) then
          return i
        end
      end
    end
  end
  return nil
end

ChapterTemplateManager.__init = __init
ChapterTemplateManager.__delete = __delete
ChapterTemplateManager.GetQuestTemplate = GetQuestTemplate
return ChapterTemplateManager
