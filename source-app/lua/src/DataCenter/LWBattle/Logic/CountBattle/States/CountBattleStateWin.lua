local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Const = require("Scene.LWBattle.Const")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:OnExit()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function State:OnEnter()
  self.owner.playerGroupProxy:SetBubbleVisible(false)
  local mainView = UIManager:GetInstance():GetWindow(UIWindowNames.LWCountBattleMain).View
  if mainView then
    mainView:OnBattleWin()
  end
  local param = {}
  param.time = self.owner.useTime
  param.kill = self.owner.killCount
  param.stageId = self.owner.cfg.levelId
  param.score = self.owner.playerGroupProxy:GetPoint()
  param.rank = string.format("%02d.%02d%%", param.score >= self.owner.cfg.baseScore and 99 or math.floor(param.score / self.owner.cfg.baseScore * 100), math.random(1, 99))
  if self.owner.param.enterType == PVEEnterType.StageFeatureBuilding then
    param.enterType = PVEEnterType.StageFeatureBuilding
    param.buildUuid = self.owner.param.buildUuid
    param.featureId = self.owner.param.featureId
    param.rank = math.random(94, 99)
    local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(self.owner.param.featureId)
    local index = table.indexof(feature.stages, param.stageId)
    if not (1 <= index) or feature.winType[index] == 1 then
    elseif feature.winType[index] == 2 then
      local memberCount = param.score
      DataCenter.StageFeatureBuildingManager:SaveScore(param.buildUuid, memberCount)
      local totalScore = DataCenter.StageFeatureBuildingManager:GetScore(param.buildUuid)
      local needTotal = feature.winNeedCount[index]
      if #feature.winType == 1 then
        if param.stageId == feature.stages[#feature.stages] then
          if totalScore >= needTotal then
            param.remainNumber = memberCount
            param.remainTotalNumber = totalScore
            param.needTotalNumber = needTotal
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleWin, {anim = false, playEffect = 10024}, param)
          else
            param.remainNumber = memberCount
            param.remainTotalNumber = totalScore
            param.needTotalNumber = needTotal
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleLose, {anim = false, playEffect = 10024}, param)
            PostEventLog.BattleResultLog(PVEType.Count, 0)
            return
          end
        else
          param.remainNumber = memberCount
          param.remainTotalNumber = totalScore
          param.needTotalNumber = needTotal
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleWin, {anim = false, playEffect = 10024}, param)
        end
      elseif totalScore >= needTotal then
        param.remainNumber = memberCount
        param.remainTotalNumber = totalScore
        param.needTotalNumber = needTotal
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleWin, {anim = false, playEffect = 10024}, param)
      else
        param.remainNumber = memberCount
        param.remainTotalNumber = totalScore
        param.needTotalNumber = needTotal
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleLose, {anim = false, playEffect = 10024}, param)
        PostEventLog.BattleResultLog(PVEType.Count, 0)
        return
      end
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultCountBattleVictory, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide,
      playEffect = 10024
    }, param)
  end
  self.owner:NoticeWin()
  PostEventLog.BattleResultLog(PVEType.Count, 1)
  for _, trap in pairs(self.owner.traps) do
    if trap and trap.OnBattleWin then
      trap:OnBattleWin()
    end
  end
  local cfg = self.owner.cfg
  if cfg and cfg.stageType and cfg.stageType == Const.CountBattleType.Defense and self.owner.playerGroupProxy and self.owner.playerGroupProxy.unitProxies then
    for _, unitProxy in pairs(self.owner.playerGroupProxy.unitProxies) do
      if unitProxy then
        unitProxy:ResetSyncUnit()
        unitProxy:PlayAnim("Default", 0.2)
      end
    end
    self.owner.playerGroupProxy:SetVelocity(0, 30)
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      if self.owner and self.owner.playerGroupProxy then
        self.owner.playerGroupProxy:SetVelocity(0, 0)
      end
    end, 5)
  end
end

return State
