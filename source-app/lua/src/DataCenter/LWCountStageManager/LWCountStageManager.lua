local LWCountStageManager = BaseClass("LWCountStageManager")

function LWCountStageManager:__init()
  self.currStageId = nil
  self.nextStageId = nil
  self.doneStageIds = {}
  self.chapterCfgs = {}
  self.chapterCfg = nil
  EventManager:GetInstance():AddListener(EventId.GF_count_battle_win, self.OnCountBattleWin)
  EventManager:GetInstance():AddListener(EventId.GF_enter_city, self.OnEnterCity)
end

function LWCountStageManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.GF_count_battle_win, self.OnCountBattleWin)
  EventManager:GetInstance():RemoveListener(EventId.GF_enter_city, self.OnEnterCity)
  self.currStageId = nil
  self.nextStageId = nil
  self.doneStageIds = {}
  self.chapterCfgs = {}
  self.chapterCfg = nil
  self.autoOpenMapUIWhenBackToCity = nil
end

function LWCountStageManager:Startup()
end

local function __FindNextStageId(self, fillDoneStageIds)
  self.nextStageId = nil
  local hitStageId = false
  for _, chapterCfg in ipairs(self.chapterCfgs) do
    if self.nextStageId ~= nil then
      break
    end
    for _, stageId in ipairs(chapterCfg.stageIds) do
      if hitStageId then
        self.nextStageId = stageId
        self.chapterCfg = chapterCfg
        break
      else
        if fillDoneStageIds then
          self.doneStageIds[stageId] = true
        end
        if stageId == self.currStageId then
          self.chapterCfg = chapterCfg
          hitStageId = true
        end
      end
    end
  end
  if not hitStageId and self.nextStageId == nil then
    self.chapterCfg = self.chapterCfgs[1]
    self.nextStageId = self.chapterCfgs[1].stageIds[1]
    if fillDoneStageIds then
      self.doneStageIds = {}
    end
  end
end

function LWCountStageManager:InitData(msg)
  if msg.countStageInfo then
    self.currStageId = msg.countStageInfo.stageId
  end
  self.chapterCfgs = {}
  local chapterTbl = LocalController:instance():getTable("lw_count_stage_chapter")
  for chapterId, _ in pairs(chapterTbl.data) do
    local stageIds = LocalController:instance():getValue("lw_count_stage_chapter", chapterId, "stages")
    local nodePosArr = {}
    local nodePosStrArr = LocalController:instance():getValue("lw_count_stage_chapter", chapterId, "nodePos")
    for _, nodePosStr in ipairs(nodePosStrArr) do
      local nodePos = string.split(nodePosStr, ",")
      table.insert(nodePosArr, Vector3(tonumber(nodePos[1]), tonumber(nodePos[2]), 0))
    end
    local nodeTipStyleArr = LocalController:instance():getValue("lw_count_stage_chapter", chapterId, "nodeTipStyle")
    table.insert(self.chapterCfgs, {
      id = chapterId,
      stageIds = stageIds,
      nodePosArr = nodePosArr,
      nodeTipStyleArr = nodeTipStyleArr
    })
  end
  table.sort(self.chapterCfgs, function(a, b)
    return a.id < b.id
  end)
  if self.chapterCfg == nil then
    self.chapterCfg = self.chapterCfgs[1]
  end
  __FindNextStageId(self, true)
end

function LWCountStageManager:OnEnterGame()
end

function LWCountStageManager:IsAllDone()
  return self.nextStageId == nil
end

function LWCountStageManager:IsOpen()
  local curLevel = DataCenter.BuildManager.MainLv
  local needLevel = DataCenter.LWStageFeatureChapterManager.countBattleMapMainLv
  if curLevel < needLevel then
    return false
  end
  return true
end

function LWCountStageManager.OnCountBattleWin(stageId)
  local self = DataCenter.LWCountStageManager
  if self.nextStageId ~= stageId then
    return
  end
  self.currStageId = stageId
  self.doneStageIds[stageId] = true
  __FindNextStageId(self, false)
end

function LWCountStageManager.OnEnterCity()
  local self = DataCenter.LWCountStageManager
  if self.autoOpenMapUIWhenBackToCity then
    self.autoOpenMapUIWhenBackToCity = nil
    DataCenter.LWBattleManager:SetBattleExitStartTime(BattleExitTimeLogType.Tower_Common)
    DataCenter.LWTrailTowerManager:OpenTrailTowerMainPanel(TrailTowerTabType.Common)
  end
end

return LWCountStageManager
