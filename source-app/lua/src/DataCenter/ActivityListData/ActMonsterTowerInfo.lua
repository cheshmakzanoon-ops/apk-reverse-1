local ActMonsterTowerInfo = BaseClass("ActMonsterTowerInfo")

local function __init(self)
  self.challengeInfo = {}
  self.challengeInfo.difficulty = 0
  self.challengeInfo.curLevel = 0
  self.challengeInfo.callHelpCount = 0
  self.challengeBoss = {}
  self.challengeBoss.pointId = 0
  self.challengeBoss.refreshTime = 0
  self.challengeBoss.callHelp = 0
  self.finishDifficulty = 1
  self.activityId = 0
  self.difficultyRewardArr = {}
  self.memberList = {}
  self.challengeHelp = {}
  self.rewardList = {}
  self.taskArr = {}
  self.curReward = {}
  self.maxLevel = 0
end

local function __delete(self)
end

local function ParseChallengeInfo(self, message)
  if message == nil then
    return
  end
  if message.difficulty ~= nil then
    self.challengeInfo.difficulty = message.difficulty
  end
  if message.curLevel ~= nil then
    self.challengeInfo.curLevel = message.curLevel
  end
  if message.callHelpCount then
    self.challengeInfo.callHelpCount = message.callHelpCount
  end
end

local function ParseChallengeBoss(self, message)
  if message == nil then
    return
  end
  if message.pointId ~= nil then
    self.challengeBoss.pointId = message.pointId
  end
  if message.refreshTime then
    self.challengeBoss.refreshTime = message.refreshTime
  end
  if message.callHelp then
    self.challengeBoss.callHelp = message.callHelp
  end
end

local function ParseDiffRewardArr(self, message)
  if message == nil then
    return
  end
  for i = 1, #message do
    self.difficultyRewardArr[i] = {}
    self.difficultyRewardArr[i].difficulty = message[i].difficulty
    self.difficultyRewardArr[i].reward = DataCenter.RewardManager:ReturnRewardParamForView(message[i].reward)
  end
end

local function ParseCurReward(self, message)
  if message == nil then
    return
  end
  self.curReward = DataCenter.RewardManager:ReturnRewardParamForView(message)
end

local function ParseOther(self, message)
  if message.finishDifficulty then
    self.finishDifficulty = message.finishDifficulty
    self.finishDifficulty = self.finishDifficulty + 1
  end
  if message.activityId then
    self.activityId = message.activityId
  end
  if message.maxLevel then
    self.maxLevel = message.maxLevel
  end
end

local function GetDiffRewardByIndex(self, index)
  return self.difficultyRewardArr[index]
end

local function ParseMemberInfo(self, message)
  if message.memberArr then
    self.memberList = {}
    self.challengeHelp = {}
    local memberArr = message.memberArr
    local list = {}
    list[1] = {}
    list[2] = {}
    for i = 1, #memberArr do
      local param = {}
      param.uid = memberArr[i].uid
      param.name = memberArr[i].name
      param.pic = memberArr[i].pic
      param.picVer = memberArr[i].picVer
      param.monthCardEndTime = memberArr[i].monthCardEndTime
      param.difficulty = memberArr[i].difficulty
      param.curLevel = memberArr[i].curLevel
      if memberArr[i].challengeBoss and memberArr[i].challengeBoss.callHelp == 1 then
        param.challengeBoss = memberArr[i].challengeBoss
        self.challengeHelp[param.uid] = param.challengeBoss
        table.insert(list[1], param)
      else
        table.insert(list[2], param)
      end
    end
    for i = 1, 2 do
      table.sort(list[i], function(a, b)
        if a.difficulty == b.difficulty then
          if a.curLevel > b.curLevel then
            return true
          end
        elseif a.difficulty > b.difficulty then
          return true
        end
        return false
      end)
    end
    self.memberList = table.mergeArray(list[1], list[2])
  end
end

local function GetMember(self)
  return self.memberList
end

local function RefreshReward(self, message)
  if message then
    self.rewardList = {}
    for i = 1, #message do
      local param = {}
      if message[i].startLevel == message[i].endLevel then
        param.title = message[i].startLevel
      else
        param.title = message[i].startLevel .. "-" .. message[i].endLevel
      end
      param.reward = DataCenter.RewardManager:ReturnRewardParamForView(message[i].reward)
      table.insert(self.rewardList, param)
    end
  end
end

local function GetReward(self)
  return self.rewardList
end

local function RefreshTask(self, message)
  self.taskArr = {}
  if message then
    for i = 1, #message do
      local param = {}
      param.id = message[i].id
      param.num = message[i].num
      param.state = message[i].state
      param.reward = DataCenter.RewardManager:ReturnRewardParamForView(message[i].reward)
      table.sort(param.reward, function(a, b)
        if a.rewardType < b.rewardType then
          return true
        end
        return false
      end)
      table.insert(self.taskArr, param)
    end
  end
end

local function UpdateTask(self, message)
  for i = 1, #self.taskArr do
    if self.taskArr[i].id == message.id then
      self.taskArr[i].state = message.state
    end
  end
end

local function GetTask(self)
  return self.taskArr
end

local function RefreshHelp(self, message)
  if self.challengeHelp then
    self.challengeHelp[message.uid] = message.challengeBoss
  end
end

local function GetActRed(self)
  local count = 0
  local helpList = DataCenter.ActMonsterTowerData:GetHelpLisByActId(self.activityId)
  if helpList then
    count = count + 1
  end
  local btnRed = DataCenter.ActMonsterTowerData:GetBtnRedByActId(self.activityId)
  if btnRed then
    count = count + 1
  end
  return count
end

ActMonsterTowerInfo.__init = __init
ActMonsterTowerInfo.__delete = __delete
ActMonsterTowerInfo.ParseChallengeInfo = ParseChallengeInfo
ActMonsterTowerInfo.ParseChallengeBoss = ParseChallengeBoss
ActMonsterTowerInfo.ParseDiffRewardArr = ParseDiffRewardArr
ActMonsterTowerInfo.ParseCurReward = ParseCurReward
ActMonsterTowerInfo.ParseOther = ParseOther
ActMonsterTowerInfo.ParseMemberInfo = ParseMemberInfo
ActMonsterTowerInfo.GetDiffRewardByIndex = GetDiffRewardByIndex
ActMonsterTowerInfo.RefreshHelp = RefreshHelp
ActMonsterTowerInfo.GetMember = GetMember
ActMonsterTowerInfo.RefreshReward = RefreshReward
ActMonsterTowerInfo.GetReward = GetReward
ActMonsterTowerInfo.RefreshTask = RefreshTask
ActMonsterTowerInfo.GetTask = GetTask
ActMonsterTowerInfo.UpdateTask = UpdateTask
ActMonsterTowerInfo.GetActRed = GetActRed
return ActMonsterTowerInfo
