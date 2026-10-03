local ActEasterEggTipsData = BaseClass("ActEasterEggTipsData")
local ActEasterEggTipsTemplate = require("DataCenter.ActEasterEggManager.ActEasterEggTipsTemplate")

function ActEasterEggTipsData:__init()
  self:AddListener()
  self.gatherQuestionPool = {}
  self.voteQuestionPool = {}
  self.defaultGatherQuestion = {}
  self.defaultVoteQuestion = {}
  self.curGatherQuestionPool = {}
  self.curVoteQuestionPool = {}
end

function ActEasterEggTipsData:__delete()
  self:RemoveListener()
  self.gatherQuestionPool = nil
  self.voteQuestionPool = nil
  self.defaultGatherQuestion = nil
  self.defaultVoteQuestion = nil
  self.curGatherQuestionPool = nil
  self.curVoteQuestionPool = nil
end

function ActEasterEggTipsData:AddListener()
end

function ActEasterEggTipsData:RemoveListener()
end

function ActEasterEggTipsData:Init()
  local config = DataCenter.ActEasterEggManager:GetEggConfigData()
  if not config then
    Logger.LogError("config is nil")
    return
  end
  self:InitQuestionMap(config.tipsGroup)
end

function ActEasterEggTipsData:InitQuestionMap(configId)
  if not configId or type(configId) ~= "number" then
    Logger.LogError("config is wrong")
    return
  end
  self.questionMap = {}
  LocalController:instance():visitTable(TableName.ACTIVITY_EASTER_TIPS, function(id, lineData)
    if lineData ~= nil then
      local group = tonumber(lineData:getValue("group")) or 0
      if group == configId then
        local template = ActEasterEggTipsTemplate.New()
        template:UpdateData(lineData)
        local groupList = template:GetGroup()
        for _, v in pairs(groupList) do
          if v and v == ActEasterEggType.Gathering then
            table.insert(self.gatherQuestionPool, template)
          elseif v and v == ActEasterEggType.Vote then
            table.insert(self.voteQuestionPool, template)
          end
        end
        if template.showFirst and template.showFirst == ActEasterEggType.Gathering then
          self.defaultGatherQuestion = template
        elseif template.showFirst and template.showFirst == ActEasterEggType.Vote then
          self.defaultVoteQuestion = template
        end
      end
    end
  end)
  for _, v in pairs(self.gatherQuestionPool) do
    table.insert(self.curGatherQuestionPool, v)
  end
  for _, v in pairs(self.voteQuestionPool) do
    table.insert(self.curVoteQuestionPool, v)
  end
end

function ActEasterEggTipsData:GetDefaultQuestion(eggType)
  if eggType == ActEasterEggType.Gathering then
    return self.defaultGatherQuestion
  end
  if eggType == ActEasterEggType.Vote then
    return self.defaultVoteQuestion
  end
  return nil
end

function ActEasterEggTipsData:GetRandomQuestion(eggType)
  local targetQuestionPool = {}
  if eggType == ActEasterEggType.Gathering then
    if #self.curGatherQuestionPool == 0 then
      for _, v in pairs(self.gatherQuestionPool) do
        table.insert(self.curGatherQuestionPool, v)
      end
    end
    targetQuestionPool = self.curGatherQuestionPool
  end
  if eggType == ActEasterEggType.Vote then
    targetQuestionPool = self.curVoteQuestionPool
    if #self.curVoteQuestionPool == 0 then
      for _, v in pairs(self.voteQuestionPool) do
        table.insert(self.curVoteQuestionPool, v)
      end
    end
  end
  local count = #targetQuestionPool
  if count <= 0 then
    Logger.LogError("count is wrong")
    return nil
  end
  local index = math.random(1, count)
  local randomResult = targetQuestionPool[index]
  table.remove(targetQuestionPool, index)
  return randomResult
end

return ActEasterEggTipsData
