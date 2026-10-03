local UIStageCtrl = BaseClass("UIStageCtrl", UIBaseCtrl)

local function CloseSelf(self)
  if DataCenter.ZombieBattleManager.gameOver then
    DataCenter.ZombieBattleManager:Exit(nil, PveExitType.ExitBtn)
  elseif DataCenter.ZombieBattleManager.gamePause then
    DataCenter.ZombieBattleManager:SetGamePause(false)
  end
  UIManager.Instance:DestroyWindow(UIWindowNames.UIStage)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetCurrentChapterId(self)
  return DataCenter.StageManager.chapterId
end

local function GetCurrentStageGroupId(self)
  return DataCenter.StageManager.stageGroupMetaId
end

local function GetCurrentStageId(self)
  return DataCenter.StageManager.stageId
end

UIStageCtrl.CloseSelf = CloseSelf
UIStageCtrl.Close = Close
UIStageCtrl.GetCurrentChapterId = GetCurrentChapterId
UIStageCtrl.GetCurrentStageGroupId = GetCurrentStageGroupId
UIStageCtrl.GetCurrentStageId = GetCurrentStageId
return UIStageCtrl
