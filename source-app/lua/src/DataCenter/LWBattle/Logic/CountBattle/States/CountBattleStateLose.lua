local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:OnEnter()
  self.owner.playerGroupProxy:SetBubbleVisible(false)
  local mainView = UIManager:GetInstance():GetWindow(UIWindowNames.LWCountBattleMain).View
  if mainView then
    mainView:OnBattleLose()
  end
  local param = {}
  param.time = self.owner.useTime
  param.kill = self.owner.killCount
  param.stageId = self.owner.cfg.levelId
  param.canSkip = self.owner.cfg.canSkip
  if self.owner.param.enterType == PVEEnterType.StageFeatureBuilding then
    param.enterType = PVEEnterType.StageFeatureBuilding
    param.buildUuid = self.owner.param.buildUuid
    param.featureId = self.owner.param.featureId
    local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(self.owner.param.featureId)
    local index = table.indexof(feature.stages, param.stageId)
    if not (1 <= index) or feature.winType[index] == 1 then
    elseif feature.winType[index] == 2 then
      local memberCount = self.owner.playerGroupProxy:GetPoint()
      DataCenter.StageFeatureBuildingManager:SaveScore(param.buildUuid, memberCount)
      local totalScore = DataCenter.StageFeatureBuildingManager:GetScore(param.buildUuid)
      param.remainNumber = memberCount
      param.remainTotalNumber = totalScore
      param.needTotalNumber = feature.winNeedCount[index]
      if #feature.winType == 1 then
        if param.stageId == feature.stages[#feature.stages] then
          if totalScore >= param.needTotalNumber then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleWin, {anim = false, playEffect = 10024}, param)
            self.owner:NoticeWin()
            PostEventLog.BattleResultLog(PVEType.Count, 1)
            return
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleLose, {anim = false, playEffect = 10023}, param)
          end
        end
      elseif totalScore >= param.needTotalNumber then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleWin, {anim = false, playEffect = 10024}, param)
        self.owner:NoticeWin()
        PostEventLog.BattleResultLog(PVEType.Count, 1)
        return
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleLose, {anim = false, playEffect = 10023}, param)
      end
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultCountBattleDefeat, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide,
      playEffect = 10023
    }, param)
  end
  PostEventLog.BattleResultLog(PVEType.Count, 0)
end

return State
