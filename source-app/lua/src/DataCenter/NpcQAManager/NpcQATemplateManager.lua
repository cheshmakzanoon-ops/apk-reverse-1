local NpcQATemplateManager = BaseClass("NpcQATemplateManager")
local NpcQATemplate = require("DataCenter.NpcQAManager.NpcQATemplate")

local function __init(self)
  self.allNpcQA = nil
  self.currentLv = 0
  self.currentLvQa = {}
  self.currentAllComplete = false
  self.questionnaire = nil
end

local function __delete(self)
  self.allNpcQA = nil
  self.currentAllComplete = nil
  self.questionnaire = nil
end

local function GetNpcQATemplate(self, id)
  if self.allNpcQA == nil then
    self:InitAllTemplate()
  end
  return self.allNpcQA[tonumber(id)]
end

local function GetQuestionnaireTemplate(self, id)
  if self.questionnaire == nil then
    self:InitAllTemplate()
  end
  return self.questionnaire[tonumber(id)]
end

local function InitAllTemplate(self)
  self.allNpcQA = {}
  self.questionnaire = {}
  LocalController:instance():visitTable(TableName.QuestionAndAnswer, function(_, lineData)
    local tempType = lineData.type
    if tempType == QuestionAndAnswerType.Q_A_TYPE_NPC then
      local item = NpcQATemplate.New()
      item:InitData(lineData)
      self.allNpcQA[item.id] = item
    elseif tempType == QuestionAndAnswerType.Q_A_TYPE_NPC_ALL_RIGHT then
      local item = NpcQATemplate.New()
      item:InitData(lineData)
      self.questionnaire[item.id] = item
    end
  end)
end

local function GetRandomQAId(self, exceptMap)
  if self.allNpcQA == nil then
    self:InitAllTemplate()
  end
  local mainLv = DataCenter.BuildManager.MainLv
  if mainLv ~= self.currentLv then
    self.currentAllComplete = false
    self.currentLv = mainLv
    self.currentLvQa = {}
    table.walk(self.allNpcQA, function(k, v)
      if v:IsValid() then
        table.insert(self.currentLvQa, k)
      end
    end)
  end
  if self.currentAllComplete == true then
    return nil
  end
  local max = table.count(self.currentLvQa)
  if max == 0 then
    return nil
  end
  local tmp = {}
  for _, v in ipairs(self.currentLvQa) do
    if exceptMap[tostring(v)] == nil then
      table.insert(tmp, v)
    end
  end
  local total = table.count(tmp)
  if total == 0 then
    self.currentAllComplete = true
    return nil
  end
  local index = math.random(1, total)
  return tmp[index]
end

NpcQATemplateManager.__init = __init
NpcQATemplateManager.__delete = __delete
NpcQATemplateManager.GetNpcQATemplate = GetNpcQATemplate
NpcQATemplateManager.GetQuestionnaireTemplate = GetQuestionnaireTemplate
NpcQATemplateManager.InitAllTemplate = InitAllTemplate
NpcQATemplateManager.GetRandomQAId = GetRandomQAId
return NpcQATemplateManager
