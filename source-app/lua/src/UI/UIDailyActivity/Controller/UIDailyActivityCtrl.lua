local UIDailyActivityCtrl = BaseClass("UIDailyActivityCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIDailyActivity, {anim = true})
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

local function GetPuzzleData(self)
  local data = DataCenter.ActivityPuzzleDataManager:GetPuzzleData()
  if data == nil then
    return nil
  end
  local result = {}
  result.IsOver = false
  local complete = {}
  table.walk(data.puzzleInfo.blockArr, function(_, v)
    complete[v] = true
  end)
  result.complete = complete
  result.canCreatePuzzleMonster = data:CanCreatePuzzleBoss()
  result.createPuzzleMonsterNum = data:GetUnCreatePuzzleMonsterNum()
  result.puzzleNumPerStage = MaxPuzzlePerStage
  result.currentStateCompletePuzzle = table.count(complete)
  result.canGetStageReward = result.currentStateCompletePuzzle >= result.puzzleNumPerStage
  local puzzleInfo = {}
  puzzleInfo.taskId = data.currentTask.taskId
  puzzleInfo.num = data.currentTask.num
  puzzleInfo.state = data.currentTask.state
  puzzleInfo.hasNext = result.hasNext
  puzzleInfo.needNum = 1
  puzzleInfo.canGetStageReward = result.canGetStageReward
  local template = DataCenter.QuestTemplateManager:GetQuestTemplate(puzzleInfo.taskId)
  if template then
    puzzleInfo.needNum = template.para2
  end
  puzzleInfo.num = math.min(puzzleInfo.num, puzzleInfo.needNum)
  puzzleInfo.blockNum = data.currentTask.blockNum
  puzzleInfo.nextPuzzleTime = data.lastRecoverTime
  result.puzzleInfo = puzzleInfo
  local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(data.puzzleInfo.reward)
  result.rewardList = rewardList
  return result
end

UIDailyActivityCtrl.CloseSelf = CloseSelf
UIDailyActivityCtrl.Close = Close
UIDailyActivityCtrl.GetPuzzleData = GetPuzzleData
return UIDailyActivityCtrl
