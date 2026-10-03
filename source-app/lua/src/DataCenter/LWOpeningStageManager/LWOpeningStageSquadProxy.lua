local LWOpeningStageSquadProxy = {}
local MARCHING_SPEED = 8
local MARCHING_REACH_ADVANCE = 5

function LWOpeningStageSquadProxy:Init(nextStage)
  local starItemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(ResourceItemRealType.OpeningHeroStar)
  self.stars = starItemData ~= nil and starItemData.number or 0
  self.leaderSegIdx = nil
  self.cells = {}
  self.animCtrls = {}
  self.currAnimName = "idle"
  self:LoadLeader()
  self:LoadFellows(nextStage)
  self.reached = false
end

function LWOpeningStageSquadProxy:LoadLeader()
  local utils = DataCenter.LWOpeningStageManager.utils
  local data = DataCenter.LWOpeningStageManager.openStages[1]
  local model_path = data.hero_prefab
  if LuaEntry.Player.JPUser and DataCenter.LWSaveGirlManager:IsJPGirlOpen() then
    model_path = data.hero_prefab_JP
  end
  self.cells[1] = utils.LoadHeroRes(model_path, 1)
end

function LWOpeningStageSquadProxy:LoadFellows(nextStage)
  local utils = DataCenter.LWOpeningStageManager.utils
  local idx = 2
  for _, hero in pairs(DataCenter.HeroDataManager.allHero) do
    local heroId = hero.heroId
    local isIgnoreHero = self:CheckIsIgnoreHero(heroId)
    if heroId ~= 10001 and self.newHero ~= hero and not isIgnoreHero then
      local appearenceId = LocalController:instance():getValue("lw_hero", heroId, "appearance")
      local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(appearenceId)
      local appearence = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
      self.cells[idx] = utils.LoadHeroRes(appearence.model_path, idx)
      idx = idx + 1
    end
  end
  DataCenter.LWOpeningStageManager.dirtyWorks:ShowFakeHero(nextStage.id, idx, self.newHero)
end

function LWOpeningStageSquadProxy:WelcomeNewFellow()
  local utils = DataCenter.LWOpeningStageManager.utils
  if self.newHero ~= nil then
    local isIgnoreHero = self:CheckIsIgnoreHero(self.newHero.heroId)
    if isIgnoreHero then
      self.newHero = nil
      return
    end
    local blockHandle = UIManager:GetInstance():EnableInteractionBlocker(2, 4)
    self.cells[#self.cells + 1] = CS.UnityEngine.GameObject("TempHeroCell").transform
    self:UpdateCells()
    utils.FocusCameraToLeader(self.cells[#self.cells], 0.25, function()
      TimerManager:GetInstance():DelayInvoke(function()
        local appearenceId = LocalController:instance():getValue("lw_hero", self.newHero.heroId, "appearance")
        local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(appearenceId)
        local appearence = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
        CS.UnityEngine.GameObject.Destroy(self.cells[#self.cells].gameObject)
        self.cells[#self.cells] = utils.LoadHeroRes(appearence.model_path, #self.cells + 1)
        self:UpdateCells()
        local bubblePlotGroupId = #self.cells == 2 and (self.newHero.heroId == 30005 and 6041 or 6007) or 6009
        local bubblePos = Vector3(self.cells[#self.cells].position.x, self.cells[#self.cells].position.y + 3, self.cells[#self.cells].position.z)
        self.newHero = nil
        DataCenter.LWSoundManager:PlaySound(62238, false)
        local vfxHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_xinshou_xiangzi_open.prefab")
        vfxHandle:completed("+", function(handle)
          if handle.isError then
            return
          end
          handle.gameObject.transform.position = self.cells[#self.cells].transform.position
          TimerManager:GetInstance():DelayInvoke(function()
            vfxHandle:Destroy()
            local checkResult = DataCenter.LWOpeningStageManager:CheckNextStageConditions()
            if checkResult == 0 then
              utils.FocusCameraToNextStage(0.5, nil, 150)
            end
            UIManager:GetInstance():DisableInteractionBlocker(blockHandle)
          end, 1)
          EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleRandomly, {
            plotGroupId = bubblePlotGroupId,
            anchor = bubblePos,
            mode = "3D"
          })
          DataCenter.LWOpeningStageManager.dirtyWorks:OnWelcomeNewFellowFinish()
        end)
      end, 0.3)
    end, 130)
  end
end

function LWOpeningStageSquadProxy:OnHeroLoaded(animCtrl)
  table.insert(self.animCtrls, animCtrl)
  animCtrl:Play(self.currAnimName)
end

local _roadSegments, _reversedRoadSegments, _currSegIdx

function LWOpeningStageSquadProxy:UpdateSegments(prevStage, currStage, nextStage)
  local utils = DataCenter.LWOpeningStageManager.utils
  _roadSegments = {}
  _reversedRoadSegments = {}
  local currPosArr = DataCenter.LWCivilizationSparkExtend:LWOpeningStageSquadProxy_getSoldierStagePosArray(currStage)
  local posB = currPosArr[1]
  if prevStage == nil then
    local posA = Vector3(posB.x, posB.y, posB.z - 100)
    table.insert(_roadSegments, {
      start = posA,
      vec = posB - posA,
      dir = Vector3.Normalize(posB - posA),
      mag = Vector3.Distance(posA, posB)
    })
    table.insert(_reversedRoadSegments, {
      start = posB,
      vec = posA - posB,
      dir = Vector3.Normalize(posA - posB),
      mag = Vector3.Distance(posA, posB)
    })
  else
    local prevPosArr = utils.GetStagePosArr(prevStage)
    for i = #prevPosArr, 1, -1 do
      local posA = prevPosArr[i]
      table.insert(_roadSegments, 1, {
        start = posA,
        vec = posB - posA,
        dir = Vector3.Normalize(posB - posA),
        mag = Vector3.Distance(posA, posB)
      })
      table.insert(_reversedRoadSegments, {
        start = posB,
        vec = posA - posB,
        dir = Vector3.Normalize(posA - posB),
        mag = Vector3.Distance(posA, posB)
      })
      posB = posA
    end
  end
  _currSegIdx = #_roadSegments + 1
  local posA = currPosArr[1]
  for i = 2, #currPosArr do
    local posB = currPosArr[i]
    table.insert(_roadSegments, {
      start = posA,
      vec = posB - posA,
      dir = Vector3.Normalize(posB - posA),
      mag = Vector3.Distance(posA, posB)
    })
    table.insert(_reversedRoadSegments, 1, {
      start = posB,
      vec = posA - posB,
      dir = Vector3.Normalize(posA - posB),
      mag = Vector3.Distance(posA, posB)
    })
    posA = posB
  end
  posA = currPosArr[#currPosArr]
  posB = utils.GetStagePosArr(nextStage)[1]
  table.insert(_roadSegments, {
    start = posA,
    vec = posB - posA,
    dir = Vector3.Normalize(posB - posA),
    mag = Vector3.Distance(posA, posB)
  })
  table.insert(_reversedRoadSegments, 1, {
    start = posB,
    vec = posA - posB,
    dir = Vector3.Normalize(posA - posB),
    mag = Vector3.Distance(posA, posB)
  })
end

function LWOpeningStageSquadProxy:ResetLeaderCell(currStage, nextStage)
  local utils = DataCenter.LWOpeningStageManager.utils
  self.leaderSegIdx = _currSegIdx
  self.cells[1].position = DataCenter.LWCivilizationSparkExtend:LWOpeningStageSquadProxy_getSoldierStagePosArray(currStage)[1]
  self.cells[1].forward = _roadSegments[self.leaderSegIdx].dir
  self:UpdateCells()
  self:PlayAnim("idle")
  utils.FocusCameraToLeader(self.cells[1])
  self:SyncStarsHudPos()
end

function LWOpeningStageSquadProxy:SyncStarsHudPos()
  if not IsNull(self.starsHud) and not IsNull(self.starsHud.gameObject) then
    self.starsHud.gameObject.transform.position = self.cells[1].position + Vector3(0, -2, 0)
  end
end

function LWOpeningStageSquadProxy:UpdateCells()
  local gap = 4
  local segRIdx = #_reversedRoadSegments - self.leaderSegIdx + 1
  local segR = _reversedRoadSegments[segRIdx]
  local prevPos = self.cells[1].position
  for i = 2, #self.cells do
    local cell = self.cells[i]
    local offset = segR.dir * gap
    local pos = prevPos + offset
    local dist = Vector3.Distance(pos, segR.start)
    while dist > segR.mag do
      segRIdx = segRIdx + 1
      if segRIdx > #_reversedRoadSegments then
        pos = segR.start + segR.vec
        break
      else
        local overDist = dist - segR.mag
        segR = _reversedRoadSegments[segRIdx]
        prevPos = segR.start
        offset = segR.dir * overDist
        pos = prevPos + offset
        dist = Vector3.Distance(pos, segR.start)
      end
    end
    cell.position = pos
    cell.forward = -segR.dir
    prevPos = pos
  end
end

function LWOpeningStageSquadProxy.OnUpdate()
  local self = DataCenter.LWOpeningStageManager.squadProxy
  if not self or self.leaderSegIdx == nil or IsNull(self.cells[1]) then
    DataCenter.LWOpeningStageManager:OnMarchReach()
    return
  end
  local utils = DataCenter.LWOpeningStageManager.utils
  local dt = Time.deltaTime
  local leaderCell = self.cells[1]
  local leaderSeg = _roadSegments[self.leaderSegIdx]
  local leaderSegR = _reversedRoadSegments[#_reversedRoadSegments - self.leaderSegIdx + 1]
  local speed = DataCenter.LWCivilizationSparkExtend:LWOpeningStageSquadProxy_getSoldierStageSpeed(MARCHING_SPEED)
  local leaderPos = leaderCell.position + leaderSeg.dir * speed * dt
  while Vector3.Dot(leaderSegR.start - leaderPos, leaderSegR.dir) > 0 do
    if self.leaderSegIdx + 1 > #_roadSegments then
      return
    end
    local overDist = Vector3.Distance(leaderPos, leaderSegR.start)
    self.leaderSegIdx = self.leaderSegIdx + 1
    leaderSeg = _roadSegments[self.leaderSegIdx]
    leaderSegR = _reversedRoadSegments[#_reversedRoadSegments - self.leaderSegIdx + 1]
    leaderPos = leaderSeg.start + leaderSeg.dir * overDist
  end
  leaderCell.position = leaderPos
  leaderCell.forward = leaderSeg.dir
  self:UpdateCells()
  self:SyncStarsHudPos()
  utils.FocusCameraToLeader(leaderCell, 0.75, nil, 150)
  if not self.reached and self.leaderSegIdx == #_roadSegments and Vector3.Distance(leaderSegR.start, leaderPos) <= MARCHING_REACH_ADVANCE then
    self.reached = true
    DataCenter.LWOpeningStageManager:OnMarchReach()
  end
end

function LWOpeningStageSquadProxy:PlayAnim(animName)
  self.currAnimName = animName
  for i = #self.animCtrls, 1, -1 do
    local animCtrl = self.animCtrls[i]
    if IsNull(animCtrl) then
      table.remove(self.animCtrls, i)
    else
      animCtrl:Play(animName)
      animCtrl:Sample()
    end
  end
end

function LWOpeningStageSquadProxy:SampleAnim()
  for i = #self.animCtrls, 1, -1 do
    local animCtrl = self.animCtrls[i]
    if not IsNull(animCtrl) then
      animCtrl:Sample()
    end
  end
end

function LWOpeningStageSquadProxy:CheckIsIgnoreHero(heroId)
  if heroId == DataCenter.LWArmedUpgradeManager.monicaHeroId then
    return true
  end
  return false
end

function LWOpeningStageSquadProxy:HideLeader()
  if self.cells and self.cells[1] and IsNotNull(self.cells[1].gameObject) then
    self.cells[1].gameObject:SetActive(false)
  end
end

function LWOpeningStageSquadProxy:ShowLeader()
  if self.cells and self.cells[1] and IsNotNull(self.cells[1].gameObject) then
    self.cells[1].gameObject:SetActive(true)
  end
end

return LWOpeningStageSquadProxy
