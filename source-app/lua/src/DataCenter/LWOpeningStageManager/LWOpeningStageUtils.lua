local EventManager = require("Framework.UI.Message.EventManager")
local LWOpeningStageUtils = {}
local STAGE_NODE_PREFAB = "Assets/Main/Prefabs/LWOpeningStage/StageNode.prefab"
local CLOSED_STAGE_NODE_PREFAB = "Assets/Main/Prefabs/LWOpeningStage/ClosedNode.prefab"
local STAGE_LINE_PREFAB = "Assets/Main/Prefabs/LWOpeningStage/StageLine.prefab"
local STAGE_BUBBLE_PREFAB = "Assets/Main/Prefabs/LWOpeningStage/StageBubble.prefab"
local STAGE_BUBBLE_PREFAB_NEW = "Assets/Main/Prefabs/LWOpeningStage/StageBubbleNew.prefab"
local STAGE_BUBBLE_MARK_PREFAB = "Assets/Main/Prefabs/Monopoly/Effect/Eff_dafuw_jiaozhan_di_red.prefab"
local STARS_HUD_PREFAB = "Assets/Main/Prefabs/LWOpeningStage/Eff_xinshou_xingxing.prefab"
local FLYING_STAR_PREFAB = "Assets/Main/Prefabs/LWOpeningStage/Eff_xinshou_xingxingda_tuowei.prefab"
local OPENING_ROAD_PREFAB = "Assets/Main/Prefabs/LWOpeningStage/opening_stage_road.prefab"
local OPENING_ROAD_PREFAB_B = "Assets/Main/Prefabs/LWOpeningStage/opening_stage_road_B.prefab"
local ARROW_PREFAB = "Assets/Main/Prefabs/LWOpeningStage/A_build_arrow.prefab"
local TroopLinePrefab = "Assets/Main/Prefabs/March/TroopLine.prefab"
local ENTITY_Y_OFFSET_FOR_ROAD_HEIGHT = 0.0
local root, openingRoadHandle, arrowEffReq, upgradeEffReq, arrowEffs, gateArrowEffIdx, arrowEffTimer, arrowEffSeq, showBossTimer, lineInst, line
local color = Color.New(0.46, 0.93, 0.18, 1)
local lightColor = Color.New(0.46, 0.93, 0.18, 0.5)
local marchLineScale = 3
local startPos, marchLineDstPos, fingerSoundTimer, playingFingerSoundId

function LWOpeningStageUtils.CreateRoot()
  if not IsNull(root) then
    return
  end
  root = CS.UnityEngine.GameObject("LWOpeningStageRoot").transform
  root.position = Vector3.zero
  root.rotation = Quaternion.identity
  root.localScale = Vector3.one
  local prefabPath = DataCenter.LWCivilizationSparkExtend:LWOpeningStageUtils_getOpenStagePrefabPath(OPENING_ROAD_PREFAB)
  openingRoadHandle = CS.GameEntry.Resource:InstantiateAsync(prefabPath, ObjectPoolTag.City)
  UpdateManager:GetInstance():AddUpdate(LWOpeningStageUtils.OnUpdate)
end

function LWOpeningStageUtils.StartLoopArrowEffect(stageId)
  if arrowEffTimer then
    arrowEffTimer:Stop()
  end
  DataCenter.LWOpeningStageManager.utils.PlayArrowEffect(stageId)
  arrowEffTimer = TimerManager:GetInstance():GetTimer(6, function()
    if arrowEffs == nil then
      return
    end
    DataCenter.LWOpeningStageManager.utils.PlayArrowEffect(stageId)
  end, false, false, false)
  arrowEffTimer:Start()
end

function LWOpeningStageUtils.PlayArrowEffect(stageId)
  if arrowEffs ~= nil then
    local startIdx = 1
    local endIdx = 1
    if stageId == 2 or stageId == 3 then
      endIdx = gateArrowEffIdx
    else
      startIdx = gateArrowEffIdx + 1
      endIdx = 23
    end
    if arrowEffSeq then
      arrowEffSeq:Kill()
    end
    arrowEffSeq = CS.DG.Tweening.DOTween.Sequence()
    for i = startIdx, endIdx do
      arrowEffSeq:AppendInterval(0.1)
      arrowEffSeq:AppendCallback(function()
        if arrowEffs ~= nil and 0 < #arrowEffs then
          arrowEffs[1].transform:Set_localPosition(0, 0, -41 + i * 4)
          arrowEffs[1]:SetActive(false)
          arrowEffs[1]:SetActive(true)
          local first = table.remove(arrowEffs, 1)
          table.insert(arrowEffs, first)
        end
      end)
    end
  end
end

function LWOpeningStageUtils.PlayUnlockEffect(pos)
  if upgradeEffReq and upgradeEffReq.gameObject then
    upgradeEffReq.gameObject.transform:Set_position(pos.x, pos.y, pos.z)
    upgradeEffReq.gameObject:SetActive(false)
    upgradeEffReq.gameObject:SetActive(true)
  end
end

function LWOpeningStageUtils.DestroyRoot()
  UpdateManager:GetInstance():RemoveUpdate(LWOpeningStageUtils.OnUpdate)
  if not IsNull(root) and not IsNull(root.gameObject) then
    CS.UnityEngine.GameObject.Destroy(root.gameObject)
    root = nil
  end
  if not IsNull(openingRoadHandle) then
    openingRoadHandle:Destroy()
    openingRoadHandle = nil
  end
  if not IsNull(arrowEffReq) then
    arrowEffReq:Destroy()
    arrowEffReq = nil
  end
  if not IsNull(upgradeEffReq) then
    upgradeEffReq:Destroy()
    upgradeEffReq = nil
  end
  if arrowEffs ~= nil then
    for i = 1, #arrowEffs do
      CS.UnityEngine.GameObject.Destroy(arrowEffs[i].gameObject)
    end
    arrowEffs = nil
  end
  if t ~= nil then
    t:Stop()
    t = nil
  end
end

function LWOpeningStageUtils.GetRoot()
  return root
end

local stagePosArrCache = {}

function LWOpeningStageUtils.GetStagePosArr(stageLineData)
  local posArr = stagePosArrCache[stageLineData.id]
  if posArr ~= nil then
    return posArr
  end
  posArr = {}
  for _, posStr in ipairs(stageLineData.nodes) do
    local pos = Vector3.zero
    local arr = string.split(posStr, ",")
    pos.x = tonumber(arr[1])
    pos.y = tonumber(arr[2])
    pos.z = tonumber(arr[3])
    table.insert(posArr, pos)
  end
  stagePosArrCache[stageLineData.id] = posArr
  return posArr
end

local stageSoldierPosArrCache = {}

function LWOpeningStageUtils.GetStageSoldierPosArr(stageLineData)
  local posArr = stageSoldierPosArrCache[stageLineData.id]
  if posArr ~= nil then
    return posArr
  end
  posArr = {}
  for _, posStr in ipairs(stageLineData.soldier_nodes) do
    local pos = Vector3.zero
    local arr = string.split(posStr, ",")
    pos.x = tonumber(arr[1])
    pos.y = tonumber(arr[2])
    pos.z = tonumber(arr[3])
    table.insert(posArr, pos)
  end
  stageSoldierPosArrCache[stageLineData.id] = posArr
  return posArr
end

local nodesResHandles = {}
local bossTrans
local showBossTrans = true

function LWOpeningStageUtils.LoadNodeRes(stage, closed)
  local resPath = closed and CLOSED_STAGE_NODE_PREFAB or STAGE_NODE_PREFAB
  if not closed then
    return
  end
  if nodesResHandles[stage.id] then
    return
  end
  local handle = CS.GameEntry.Resource:InstantiateAsync(resPath, ObjectPoolTag.City)
  handle:completed("+", function(handle)
    if handle.isError then
      Logger.LogError("load res failed:" .. resPath)
      return
    end
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(root, false)
    transform.position = LWOpeningStageUtils.GetStagePosArr(stage)[1] + Vector3(0, ENTITY_Y_OFFSET_FOR_ROAD_HEIGHT, 0)
    gameObject.name = "Node_" .. stage.id
  end)
  nodesResHandles[stage.id] = handle
end

local _nextStageBlockCounter = 0
local enemyResHandles = {}
local touchTriggers = {}

function LWOpeningStageUtils.LoadEnemyRes(stage)
  local enemyPrefabPath = stage.enemy_prefab
  if LuaEntry.Player.JPUser and not string.IsNullOrEmpty(stage.enemy_prefab_JP) then
    enemyPrefabPath = stage.enemy_prefab_JP
  end
  local handle = CS.GameEntry.Resource:InstantiateAsync(enemyPrefabPath, ObjectPoolTag.City)
  handle:completed("+", function(handle)
    if handle.isError then
      Logger.LogError("load res failed:" .. enemyPrefabPath)
      return
    end
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(root, false)
    local position = LWOpeningStageUtils.GetStagePosArr(stage)[1] + Vector3(0, ENTITY_Y_OFFSET_FOR_ROAD_HEIGHT, 0)
    position.y = 0
    transform.position = position
    local rawName = gameObject.name
    gameObject.name = "Enemy_" .. stage.id
    local zombiesRoot = transform:Find("root/zombies")
    if IsNull(zombiesRoot) then
      PostEventLog.Track("opening_stage_zombie_root_missing", {
        path = enemyPrefabPath,
        name = rawName,
        state = tostring(handle.state)
      })
    else
      for i = 0, zombiesRoot.childCount - 1 do
        local zombieGroup = zombiesRoot:GetChild(i)
        for j = 0, zombieGroup.childCount - 1 do
          LWOpeningStageUtils.CreateLingerZombie({
            state = zombieGroup.name,
            stage = stage.id,
            gameObject = zombieGroup:GetChild(j).gameObject
          })
        end
      end
    end
    local isNextStage = DataCenter.LWOpeningStageManager.openStages[1] == stage
    local stageRoot = transform:Find("root/stage")
    if IsNull(stageRoot) then
      PostEventLog.Track("opening_stage_stage_root_missing", {
        path = enemyPrefabPath,
        name = rawName,
        state = tostring(handle.state)
      })
    else
      local stagePos = Vector3(stageRoot.position.x, stageRoot.position.y, stageRoot.position.z)
      local touchTrigger = stageRoot.gameObject:GetComponentInChildren(typeof(CS.TouchObjectEventTrigger))
      table.insert(touchTriggers, touchTrigger)
      
      function touchTrigger.onPointerClick()
        if isNextStage then
          if DataCenter.LWOpeningStageManager.dirtyWorks.flyingStarTasks <= 0 then
            DataCenter.LWOpeningStageManager:OnClickAttack()
          else
            _nextStageBlockCounter = _nextStageBlockCounter + 1
            if 5 <= _nextStageBlockCounter then
              DataCenter.LWOpeningStageManager.dirtyWorks.flyingStarTasks = 0
            end
          end
        elseif stage.id == 6 then
        end
      end
      
      if isNextStage then
        for i = 0, stageRoot.childCount - 1 do
          local child = stageRoot:GetChild(i)
          if not string.startswith(child.name, "A_build_stage") then
            LWOpeningStageUtils.CreateLingerZombie({
              state = "idle",
              stage = stage.id,
              gameObject = child.gameObject,
              boss = true
            })
          end
        end
      end
      bossTrans = stageRoot:Find("A_Monster_dog01_mono/A_Monster@dog01_skin")
      DataCenter.LWCivilizationSparkExtend:LWOpeningStageUtils_bossTransLoaded(LWOpeningStageUtils, bossTrans, showBossTrans)
    end
  end)
  enemyResHandles[stage.id] = handle
end

function LWOpeningStageUtils.HideBoss()
  if not IsNull(bossTrans) then
    bossTrans.gameObject:SetActive(false)
  end
end

function LWOpeningStageUtils.ShowBoss()
  if not IsNull(bossTrans) then
    bossTrans.gameObject:SetActive(true)
    local simpleAnim = bossTrans.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
    if not IsNull(simpleAnim) then
      simpleAnim:Play("born")
      showBossTimer = TimerManager:GetInstance():DelayInvoke(function()
        if not IsNull(simpleAnim) then
          simpleAnim:Play("idle")
        end
      end, 3)
    end
  end
end

function LWOpeningStageUtils.CivilizationSparkHideBoss()
  showBossTrans = false
  if not IsNull(bossTrans) then
    bossTrans.gameObject:SetActive(false)
  end
end

function LWOpeningStageUtils.CivilizationSparkShowBoss()
  showBossTrans = true
  if not IsNull(bossTrans) then
    bossTrans.gameObject:SetActive(true)
    local simpleAnim = bossTrans.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
    if not IsNull(simpleAnim) then
      simpleAnim:Play("idle")
      simpleAnim:Sample()
    end
  end
end

local lineResHandles = {}
local arrowResHandle

local function __LoadLine(posA, posB)
  local handle = CS.GameEntry.Resource:InstantiateAsync(STAGE_LINE_PREFAB)
  handle:completed("+", function(handle)
    if handle.isError then
      Logger.LogError("load res failed:" .. STAGE_LINE_PREFAB)
      return
    end
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(root, false)
    transform.position = posA
    local lineRenderer = gameObject:GetComponentInChildren(typeof(CS.UnityEngine.LineRenderer))
    local positions = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), 2)
    positions[0] = posA + Vector3(0, ENTITY_Y_OFFSET_FOR_ROAD_HEIGHT, 0)
    positions[1] = posB + Vector3(0, ENTITY_Y_OFFSET_FOR_ROAD_HEIGHT, 0)
    lineRenderer.positionCount = positions.Length
    lineRenderer:SetPositions(positions)
  end)
  return handle
end

local function __LoadArrow(posA, posB)
  local handle = CS.GameEntry.Resource:InstantiateAsync(ARROW_PREFAB)
  handle:completed("+", function(handle)
    if handle.isError then
      Logger.LogError("load res failed:" .. ARROW_PREFAB)
      return
    end
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(root, false)
    local dir = (posB - posA).normalized
    transform.position = posA + dir * 3
    transform.transform.forward = -dir
  end)
  return handle
end

function LWOpeningStageUtils.ShowLine(currStage, nextStage)
  local currPosArr = DataCenter.LWCivilizationSparkExtend:LWOpeningStageSquadProxy_getSoldierStagePosArray(currStage)
  local nextPos = LWOpeningStageUtils.GetStagePosArr(nextStage)[1]
  for i = 2, #currPosArr do
    table.insert(lineResHandles, __LoadLine(currPosArr[i - 1], currPosArr[i]))
  end
  table.insert(lineResHandles, __LoadLine(currPosArr[#currPosArr], nextPos))
  if 1 < #currPosArr then
    arrowResHandle = __LoadArrow(currPosArr[1], currPosArr[2])
  else
    arrowResHandle = __LoadArrow(currPosArr[1], nextPos)
  end
end

function LWOpeningStageUtils.CreateMarchLine()
  if lineInst ~= nil then
    return
  end
  lineInst = CS.GameEntry.Resource:InstantiateAsync(TroopLinePrefab)
  lineInst:completed("+", function(req)
    if req.isError then
      return
    end
    req.gameObject.transform:SetParent(nil)
    line = req.gameObject:GetComponent(typeof(CS.WorldTroopLine))
    DataCenter.LWOpeningStageManager.utils.InitMarchLine()
  end)
end

function LWOpeningStageUtils.ClearMarchLine()
  if lineInst then
    lineInst:Destroy()
    lineInst = nil
  end
  line = nil
end

function LWOpeningStageUtils.InitMarchLine()
  if line then
    line:Clear()
    line:SetMidSpriteVisible(false)
    line:SetColor(color, lightColor)
    line:SetWidthScale(marchLineScale)
    line:SetScale(marchLineScale, marchLineScale, marchLineScale)
    local dir = (marchLineDstPos - startPos).normalized
    line:SetRotation(dir)
    line:InitStart(startPos)
    line:InitEnd(marchLineDstPos)
  end
end

local heroCells = {}
local heroResHandles = {}

local function __GetAndCreateHeroCell(index)
  if heroCells[index] == nil then
    heroCells[index] = CS.UnityEngine.GameObject("HeroCell_" .. index).transform
    heroCells[index]:SetParent(root, false)
  end
  return heroCells[index]
end

function LWOpeningStageUtils.LoadHeroRes(model_path, index, effect)
  local cell = __GetAndCreateHeroCell(index)
  local oldHandle = heroResHandles[index]
  local handle = CS.GameEntry.Resource:InstantiateAsync(model_path, ObjectPoolTag.City)
  handle:completed("+", function(handle)
    if handle.isError then
      Logger.LogError("load res failed:" .. model_path)
      return
    end
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("PlaneShadowObject3"))
    transform:SetParent(cell, false)
    transform.localPosition = Vector3(0, ENTITY_Y_OFFSET_FOR_ROAD_HEIGHT, 0)
    transform.localRotation = Quaternion.identity
    local finalSize = 1.8
    transform.localScale = Vector3(finalSize, finalSize, finalSize)
    DataCenter.LWOpeningStageManager.squadProxy:OnHeroLoaded(gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation)))
    if not IsNull(oldHandle) then
      oldHandle:RealDestroy()
      heroResHandles[index] = handle
    end
    local triggerGo = CS.UnityEngine.GameObject("Trigger")
    triggerGo.transform:SetParent(transform, false)
    triggerGo.transform.localPosition = Vector3.zero
    triggerGo.transform.localRotation = Quaternion.identity
    triggerGo.transform.localScale = Vector3.one
    local triggerCollider = triggerGo:AddComponent(typeof(CS.UnityEngine.BoxCollider))
    triggerCollider.center = Vector3(0, 1, 0)
    triggerCollider.size = Vector3(1.2, 2, 1.2)
  end)
  if IsNull(oldHandle) then
    heroResHandles[index] = handle
  end
  return cell
end

function LWOpeningStageUtils.GetLeaderAppearenceByLevel(level)
  local heroId = LocalController:instance():getValue("lw_opening_hero", level, "hero")
  local appearenceId = LocalController:instance():getValue("lw_hero", heroId, "appearance")
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(appearenceId)
  local appearence = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
  return appearence, heroId, appearenceId
end

function LWOpeningStageUtils.GetLeaderLevelInfo(stars)
  stars = stars or 0
  local level = 0
  local needStars = 0
  local sum = 0
  local tbl = LocalController:instance():getTable("lw_opening_hero")
  local list = {}
  for lv, _ in pairs(tbl.data) do
    local data = LocalController:instance():getLine("lw_opening_hero", lv)
    table.insert(list, data)
  end
  table.sort(list, function(a, b)
    return a.id < b.id
  end)
  for lv, data in ipairs(list) do
    needStars = data.stars
    sum = sum + needStars
    if stars < sum then
      break
    end
    level = lv
  end
  return level, needStars, sum - stars
end

local starsHudHandle, starTemplate
local starInstList = {}
local flyingStarHandles = {}
local flyingStarTweens = {}

function LWOpeningStageUtils.UpdateStarsHud(needStars, lackStars)
  if IsNull(starsHudHandle) then
    return
  end
  for i = 1, needStars do
    local isOn = i <= needStars - lackStars
    if starInstList[i] == nil and not IsNull(starTemplate) then
      starInstList[i] = {}
      starInstList[i].root = CS.UnityEngine.GameObject.Instantiate(starTemplate, starTemplate.transform.parent)
      starInstList[i].root.name = "star_" .. i
      starInstList[i].root:SetActive(true)
      starInstList[i].on = starInstList[i].root.transform:Find("on").gameObject
      starInstList[i].off = starInstList[i].root.transform:Find("off").gameObject
      starInstList[i].vfx = starInstList[i].root.transform:Find("vfx").gameObject
      starInstList[i].vfx:SetActive(false)
    end
    if starInstList[i] then
      starInstList[i].on:SetActive(isOn)
      starInstList[i].off:SetActive(not isOn)
      local gap = 2.4 / (needStars - 1)
      local pos = Vector3((i - 1) * gap - 1, 0, 0)
      starInstList[i].root.transform.localPosition = pos
      starInstList[i].alreadyAsFlyingDst = nil
    end
  end
end

function LWOpeningStageUtils.WarmupStarsHud(callback, caller)
  if IsNull(starsHudHandle) then
    starsHudHandle = CS.GameEntry.Resource:InstantiateAsync(STARS_HUD_PREFAB)
    starsHudHandle:completed("+", function(handle)
      if handle.isError then
        Logger.LogError("load res failed:" .. STARS_HUD_PREFAB)
        return
      end
      local gameObject = handle.gameObject
      local transform = gameObject.transform
      transform:SetParent(root, false)
      transform.position = DataCenter.LWOpeningStageManager.squadProxy.cells[1].position + Vector3(0, -2, 0)
      gameObject.name = "StarsHud"
      starTemplate = transform:Find("star_template").gameObject
      starTemplate:SetActive(false)
      if callback ~= nil then
        callback(caller)
      end
    end)
  end
  return starsHudHandle
end

function LWOpeningStageUtils.DoStarAnim(srcPos, jumpPos, callback)
  local starHandle = CS.GameEntry.Resource:InstantiateAsync(FLYING_STAR_PREFAB)
  starHandle:completed("+", function(handle)
    if handle.isError then
      return
    end
    local dstStarInst
    for _, starInst in ipairs(starInstList) do
      if starInst.off.activeSelf and not starInst.alreadyAsFlyingDst then
        starInst.alreadyAsFlyingDst = true
        dstStarInst = starInst
        break
      end
    end
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(root, false)
    transform.position = srcPos
    transform.eulerAngles = Vector3(45, -45, 180)
    transform.localScale = Vector3(0.25, 0.25, 0.25)
    table.insert(flyingStarTweens, transform:DOMove(jumpPos, 0.25):SetEase(CS.DG.Tweening.Ease.OutQuad))
    table.insert(flyingStarTweens, transform:DOScale(Vector3(1, 1, 1), 0.25):SetEase(CS.DG.Tweening.Ease.OutQuad))
    table.insert(flyingStarTweens, transform:DORotateQuaternion(Quaternion.Euler(45, -45, 0), 0.125):SetLoops(2):SetEase(CS.DG.Tweening.Ease.OutQuad))
    if dstStarInst == nil then
      if callback ~= nil then
        callback()
      end
      handle:Destroy()
      return
    end
    table.insert(flyingStarTweens, transform:DOScale(Vector3(0.2, 0.2, 0.2), 0.65):SetDelay(0.6000000000000001):SetEase(CS.DG.Tweening.Ease.Linear))
    table.insert(flyingStarTweens, CS.AnimationHelper.DOBezierCurve3D(transform, jumpPos, dstStarInst.root.transform.position, 0.65, 0.5):SetDelay(0.7):SetEase(CS.DG.Tweening.Ease.OutCubic):OnComplete(function()
      dstStarInst.on:SetActive(true)
      dstStarInst.off:SetActive(false)
      dstStarInst.vfx:SetActive(true)
      DataCenter.LWOpeningStageManager.squadProxy.cells[1]:DOScale(Vector3(1.2, 0.8, 1.2), 0.1):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo):OnComplete(function()
        if callback ~= nil then
          callback()
        end
      end)
      handle:Destroy()
    end))
  end)
end

function LWOpeningStageUtils.LeaderLevelUp()
end

local stageBubbleHandle, stageBubbleMarkHandle
local stageBubbleHide = {}

function LWOpeningStageUtils.LoadBubble(nextStage)
  stageBubbleHandle = CS.GameEntry.Resource:InstantiateAsync(STAGE_BUBBLE_PREFAB)
  stageBubbleHandle:completed("+", function(handle)
    if handle.isError then
      Logger.LogError("load res failed:" .. STAGE_BUBBLE_PREFAB)
      return
    end
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(root, false)
    transform.position = LWOpeningStageUtils.GetStagePosArr(nextStage)[1] + Vector3(0, nextStage.bubble_height, 0)
    gameObject.name = "Bubble_" .. nextStage.id
    local touchTrigger = gameObject:GetComponentInChildren(typeof(CS.TouchObjectEventTrigger))
    table.insert(touchTriggers, touchTrigger)
    
    function touchTrigger.onPointerClick()
      if DataCenter.LWOpeningStageManager.dirtyWorks.flyingStarTasks <= 0 then
        DataCenter.LWOpeningStageManager:OnClickAttack()
        if not IsNull(stageBubbleHandle) and not IsNull(stageBubbleHandle.gameObject) then
          stageBubbleHandle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator)):SetTrigger("click")
        end
      else
        _nextStageBlockCounter = _nextStageBlockCounter + 1
        if 5 <= _nextStageBlockCounter then
          DataCenter.LWOpeningStageManager.dirtyWorks.flyingStarTasks = 0
        end
      end
    end
    
    LWOpeningStageUtils.UpdateStageBubbleVisible()
  end)
  stageBubbleMarkHandle = CS.GameEntry.Resource:InstantiateAsync(STAGE_BUBBLE_MARK_PREFAB)
  stageBubbleMarkHandle:completed("+", function(handle)
    if handle.isError then
      Logger.LogError("load res failed:" .. STAGE_BUBBLE_MARK_PREFAB)
      return
    end
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(root, false)
    transform.position = LWOpeningStageUtils.GetStagePosArr(nextStage)[1] + Vector3(0, 0, 0)
    transform.localScale = Vector3.one * (nextStage.id == DataCenter.LWOpeningStageManager.MaxStageID and 2 or 1)
    gameObject.name = "Bubble_Mark_" .. nextStage.id
    LWOpeningStageUtils.UpdateStageBubbleVisible()
  end)
end

function LWOpeningStageUtils.UpdateStageBubbleVisible(fromEvent)
  local checkResult = DataCenter.LWOpeningStageManager:CheckNextStageConditions()
  local currStageId = DataCenter.LWOpeningStageManager:GetCurStageId()
  if currStageId then
    local vis = stageBubbleHide[currStageId] == nil and 0 or 1
    checkResult = checkResult + vis
  end
  if not IsNull(stageBubbleHandle) and not IsNull(stageBubbleHandle.gameObject) then
    stageBubbleHandle.gameObject:SetActive(checkResult == 0)
  end
  if not IsNull(stageBubbleMarkHandle) and not IsNull(stageBubbleMarkHandle.gameObject) then
    stageBubbleMarkHandle.gameObject:SetActive(checkResult == 0)
  end
end

function LWOpeningStageUtils.SetStageBubbleVisible(stage, visible)
  if visible then
    stageBubbleHide[stage] = nil
  else
    stageBubbleHide[stage] = true
  end
  LWOpeningStageUtils.UpdateStageBubbleVisible()
end

local focusCameraTween

function LWOpeningStageUtils.FocusCamera(pos, duration, callback, zoom)
  zoom = zoom ~= nil and zoom or 150
  local offset = zoom * 0.707
  pos.x = pos.x + offset
  pos.z = pos.z - offset
  pos.y = zoom
  if focusCameraTween ~= nil then
    focusCameraTween:Kill()
    focusCameraTween = nil
  end
  if duration == nil or duration <= 0 or CS.UnityEngine.Camera.main.transform.position == pos then
    CS.UnityEngine.Camera.main.transform.position = pos
    if callback ~= nil then
      callback()
    end
  else
    focusCameraTween = CS.UnityEngine.Camera.main.transform:DOMove(pos, duration):SetEase(CS.DG.Tweening.Ease.OutQuad):OnComplete(function()
      if callback ~= nil then
        callback()
      end
    end)
  end
end

function LWOpeningStageUtils.FocusCameraToNextStage(duration, callback, zoom)
  local currStage = DataCenter.LWOpeningStageManager.closeStages[1]
  local nextStage = DataCenter.LWOpeningStageManager.openStages[1]
  local pos = (DataCenter.LWCivilizationSparkExtend:LWOpeningStageSquadProxy_getSoldierStagePosArray(currStage)[1] + LWOpeningStageUtils.GetStagePosArr(nextStage)[1]) * 0.5
  LWOpeningStageUtils.FocusCamera(pos, duration, callback, zoom)
end

function LWOpeningStageUtils.FocusCameraToLeader(leaderCell, duration, callback, zoom)
  if IsNull(leaderCell) then
    return
  end
  local pos = leaderCell.position
  LWOpeningStageUtils.FocusCamera(pos, duration, callback, zoom)
end

function LWOpeningStageUtils.FocusCameraToStageNode(stageId, duration, callback, zoom)
  for _, stage in ipairs(DataCenter.LWOpeningStageManager.openStages) do
    if stage.id == stageId then
      local pos = LWOpeningStageUtils.GetStagePosArr(stage)[1]
      LWOpeningStageUtils.FocusCamera(Vector3(pos.x, pos.y, pos.z), duration, callback, zoom)
      return
    end
  end
  for _, stage in ipairs(DataCenter.LWOpeningStageManager.closeStages) do
    if stage.id == stageId then
      local pos = LWOpeningStageUtils.GetStagePosArr(stage)[1]
      LWOpeningStageUtils.FocusCamera(Vector3(pos.x, pos.y, pos.z), duration, callback, zoom)
      return
    end
  end
end

function LWOpeningStageUtils.FocusCameraToBuilding(buildingData, duration, callback, zoom)
  local pos = LWOpeningStageUtils.BuildingPointID_to_WorldPos(buildingData.itemId, buildingData.pointId)
  LWOpeningStageUtils.FocusCamera(pos, duration, callback, zoom)
end

function LWOpeningStageUtils.BuildingPointID_to_WorldPos(buildingId, pointId)
  local tile = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.Building), buildingId, "tiles") * TileSize * 0.5
  local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.City) - Vector3(tile, 0, tile) * 0.707
  return pos
end

function LWOpeningStageUtils.BuildingPointID_to_CameraPos(buildingId, pointId, zoom)
  local pos = LWOpeningStageUtils.BuildingPointID_to_WorldPos(buildingId, pointId)
  local offset = zoom * 0.707
  pos.x = pos.x + offset
  pos.z = pos.z - offset
  pos.y = zoom
  return pos
end

local SoloHero = require("DataCenter.LWOpeningStageManager.LWOpeningStageSoloHero")
local soloHeroInst

function LWOpeningStageUtils.CreateSoloHero(config)
  soloHeroInst = SoloHero.New(config)
end

local ZakuZombie = require("DataCenter.LWOpeningStageManager.LWOpeningStageZakuZombie")
local zakuZombieInsts = {}

function LWOpeningStageUtils.CreateZakuZombie(config)
  local inst = ZakuZombie.New(config)
  zakuZombieInsts[config.id] = inst
end

local LingerZombie = require("DataCenter.LWOpeningStageManager.LWOpeningStageLingerZombie")
local lingerZombieInsts = {}

function LWOpeningStageUtils.CreateLingerZombie(data)
  local inst = LingerZombie.New(data)
  table.insert(lingerZombieInsts, inst)
end

local tempLingerZombiePosArr

function LWOpeningStageUtils.NoticeLingerZombies(stage)
  tempLingerZombiePosArr = {}
  for _, inst in ipairs(lingerZombieInsts) do
    if inst.stage == stage.id then
      inst.fsm:Switch("notice", DataCenter.LWOpeningStageManager.squadProxy.cells[1])
      table.insert(tempLingerZombiePosArr, inst.transform.position)
    end
  end
end

local WIN_VFX = "Assets/_Art/Effect/prefab/scene/Common/VFX_victory.prefab"
local LOSE_VFX = "Assets/_Art/Effect/prefab/scene/Common/VFX_failure.prefab"
local DEAD_ZOMBIE = "Assets/Main/Prefabs/LWOpeningStage/DeadZombie.prefab"
local deadZombieHandles = {}
local bubbleTimers = {}
local flagHandle

local function __syncUIHudToWorld(worldPos, rectTransfrom)
  local screenScale = math.max(DefaultScreenHeight / Screen.height, DefaultScreenWidth / Screen.width)
  local screenPos = CS.UnityEngine.Camera.main:WorldToScreenPoint(worldPos)
  screenPos.x = screenPos.x - Screen.width * 0.5
  screenPos.y = screenPos.y - Screen.height * 0.5
  screenPos.x = screenPos.x * screenScale
  screenPos.y = screenPos.y * screenScale
  screenPos.z = 0
  rectTransfrom.anchoredPosition3D = screenPos
end

function LWOpeningStageUtils.ShowBattleResult(isWin)
  if isWin then
    local stage = DataCenter.LWOpeningStageManager.closeStages[1]
    if #stage.plots_coords > 0 then
      for _, coordStr in ipairs(stage.plots_coords) do
        local coordArr = string.split(coordStr, ";")
        local delay = (math.random() * (stage.plots_delay_max - stage.plots_delay_min) + stage.plots_delay_min) * 0.001
        table.insert(bubbleTimers, TimerManager:GetInstance():DelayInvoke(function()
          if stage.finish_plots ~= 0 then
            local evtParams = {}
            evtParams.plotGroupId = stage.finish_plots
            evtParams.anchor = Vector3(tonumber(coordArr[1]), tonumber(coordArr[2]), tonumber(coordArr[3]))
            evtParams.mode = stage.plots_mode
            evtParams.followTarget = stage.plots_mode == "3DFollow" and DataCenter.LWOpeningStageManager.squadProxy.cells[1] or nil
            EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleRandomly, evtParams)
          end
        end, delay))
      end
    end
    if tempLingerZombiePosArr ~= nil and 0 < #tempLingerZombiePosArr then
      for _, pos in ipairs(tempLingerZombiePosArr) do
        local handle = CS.GameEntry.Resource:InstantiateAsync(DEAD_ZOMBIE)
        handle:completed("+", function(handle)
          if handle.isError then
            return
          end
          local gameObject = handle.gameObject
          local transform = gameObject.transform
          transform:SetParent(root, false)
          transform.position = pos
          transform.rotation = Quaternion.Euler(0, math.random() * 360, 0)
          table.insert(deadZombieHandles, handle)
          gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator)):SetBool("dead", true)
          transform:DOMoveY(-5, 2):SetEase(CS.DG.Tweening.Ease.Linear):SetDelay(2)
        end)
      end
      TimerManager:GetInstance():DelayInvoke(function()
        for _, handle in ipairs(deadZombieHandles) do
          if not IsNull(handle) then
            handle:Destroy()
          end
        end
        deadZombieHandles = {}
      end, 4)
    end
  end
  local vfxPath = isWin and WIN_VFX or LOSE_VFX
  flagHandle = CS.GameEntry.Resource:InstantiateAsync(vfxPath)
  flagHandle:completed("+", function(handle)
    if handle.isError then
      return
    end
    if isWin then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Novice_Route_Victory, false)
    end
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Normal.Name).transform, false)
    transform.localScale = Vector3.one
    __syncUIHudToWorld(LWOpeningStageUtils.GetStagePosArr(DataCenter.LWOpeningStageManager.closeStages[1])[1] + Vector3(0, 3, 0), transform)
    TimerManager:GetInstance():DelayInvoke(function()
      handle:Destroy()
    end, 2)
  end)
end

local fingerClickHandles = {}

function LWOpeningStageUtils.ShowFingerClick(worldPos, lastTime, size)
  if not SceneUtils.GetIsInCity() then
    return
  end
  size = size or 1
  local fingerClickHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/LWOpeningStage/finger_click.prefab")
  fingerClickHandle:completed("+", function(handle)
    if handle.isError then
      return
    end
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(root, false)
    transform.position = worldPos
    transform.localScale = Vector3.one * size
    if lastTime ~= nil then
      TimerManager:GetInstance():DelayInvoke(function()
        handle:Destroy()
      end, lastTime)
    end
  end)
  table.insert(fingerClickHandles, fingerClickHandle)
  LWOpeningStageUtils.StartFingerSoundTimer()
end

function LWOpeningStageUtils.ClearAllFingers()
  for _, handle in pairs(fingerClickHandles) do
    if not IsNull(handle) then
      handle:Destroy()
    end
  end
  fingerClickHandles = {}
  LWOpeningStageUtils.StopFingerSound()
  LWOpeningStageUtils.StopFingerSoundTimer()
end

function LWOpeningStageUtils.StartFingerSoundTimer()
  LWOpeningStageUtils.StopFingerSoundTimer()
  fingerSoundTimer = TimerManager:GetInstance():GetTimer(5, function()
    LWOpeningStageUtils.PlayFingerSound()
  end, nil, false, false, false)
  fingerSoundTimer:Start()
end

function LWOpeningStageUtils.StopFingerSoundTimer()
  if fingerSoundTimer then
    fingerSoundTimer:Stop()
    fingerSoundTimer = nil
  end
end

function LWOpeningStageUtils.PlayFingerSound()
  for i = #fingerClickHandles, 1, -1 do
    if IsNull(fingerClickHandles[i]) then
      table.remove(fingerClickHandles, i)
    end
  end
  if table.IsNullOrEmpty(fingerClickHandles) then
    LWOpeningStageUtils.StopFingerSoundTimer()
    LWOpeningStageUtils.StopFingerSound()
    return
  end
  playingFingerSoundId = DataCenter.LWSoundManager:PlaySound(62294, false)
end

function LWOpeningStageUtils.StopFingerSound()
  if playingFingerSoundId then
    DataCenter.LWSoundManager:StopSound(playingFingerSoundId)
    playingFingerSoundId = nil
  end
end

local HUMAN_CANNON_FLYING_SPEED = 10
local HUMAN_CANNON_FLYING_HEIGHT = 5
local flyingWorkerTasks = {}

function LWOpeningStageUtils.FireHumanCannon(workerId, modelPath, srcPos, dstPos, callback)
  local handle = CS.GameEntry.Resource:InstantiateAsync(modelPath)
  handle:completed("+", function(handle)
    if handle.isError then
      return
    end
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(root, false)
    transform.position = srcPos
    transform.forward = dstPos - srcPos
    transform.localScale = Vector3.one
    gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation)):Play("idle")
    local trail = CS.GameEntry.Resource:InstantiateAsync("Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshou_dongwu_trail.prefab")
    trail:completed("+", function(trail)
      trail.gameObject.transform:SetParent(transform, false)
      trail.gameObject:SetActive(true)
    end)
    trail = CS.GameEntry.Resource:InstantiateAsync("Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshou_dongwu_trail_xingxing.prefab")
    trail:completed("+", function(trail)
      trail.gameObject.transform:SetParent(transform, false)
      trail.gameObject:SetActive(true)
    end)
  end)
  local duration = Vector3.Distance(srcPos, dstPos) / HUMAN_CANNON_FLYING_SPEED
  local va = -2 * HUMAN_CANNON_FLYING_HEIGHT / (duration * duration * 0.25)
  local vv0 = -va * duration * 0.5
  local task = {
    id = workerId,
    handle = handle,
    srcPos = srcPos,
    dstPos = dstPos,
    duration = duration,
    va = va,
    vv0 = vv0,
    timer = 0,
    callback = callback
  }
  table.insert(flyingWorkerTasks, task)
end

function LWOpeningStageUtils.OnUpdate()
  local dt = Time.deltaTime
  if soloHeroInst ~= nil then
    soloHeroInst:Update(dt)
  end
  for _, zaku in pairs(zakuZombieInsts) do
    zaku:Update(dt)
  end
  for _, linger in ipairs(lingerZombieInsts) do
    linger:Update(dt)
  end
  if not IsNull(flagHandle) and not IsNull(flagHandle.gameObject) then
    __syncUIHudToWorld(LWOpeningStageUtils.GetStagePosArr(DataCenter.LWOpeningStageManager.closeStages[1])[1] + Vector3(0, 3, 0), flagHandle.gameObject.transform)
  end
  for i = #flyingWorkerTasks, 1, -1 do
    local task = flyingWorkerTasks[i]
    task.timer = task.timer + dt
    if task.timer >= task.duration then
      table.remove(flyingWorkerTasks, i)
      if task.callback ~= nil then
        task.callback()
      end
      if not IsNull(task.handle) then
        task.handle:RealDestroy()
      end
    elseif not IsNull(task.handle) and not IsNull(task.handle.gameObject) then
      local gameObject = task.handle.gameObject
      local transform = gameObject.transform
      local vs = task.vv0 * task.timer + 0.5 * task.va * task.timer * task.timer
      local posH = Vector3.Lerp(task.srcPos, task.dstPos, task.timer / task.duration)
      transform.position = posH + Vector3(0, vs, 0)
      if task.id == 13301 or task.id == 11301 then
        LWOpeningStageUtils.FocusCamera(posH, 0.5, nil, 150)
      end
    end
  end
end

function LWOpeningStageUtils.ClearNodeAndLine()
  for _, nodesResHandle in pairs(nodesResHandles) do
    if not IsNull(nodesResHandle) then
      nodesResHandle:Destroy()
    end
  end
  nodesResHandles = {}
  for _, lineResHandle in ipairs(lineResHandles) do
    if not IsNull(lineResHandle) then
      lineResHandle:Destroy()
    end
  end
  lineResHandles = {}
  if not IsNull(arrowResHandle) then
    arrowResHandle:Destroy()
  end
  arrowResHandle = nil
end

function LWOpeningStageUtils.Clear()
  LWOpeningStageUtils.ClearNodeAndLine()
  for _, enemyResHandle in pairs(enemyResHandles) do
    if not IsNull(enemyResHandle) then
      enemyResHandle:RealDestroy()
    end
  end
  enemyResHandles = {}
  _nextStageBlockCounter = 0
  for _, touchTrigger in pairs(touchTriggers) do
    if not IsNull(touchTrigger) then
      touchTrigger.onPointerClick = nil
    end
  end
  touchTriggers = {}
  for _, heroResHandle in pairs(heroResHandles) do
    if not IsNull(heroResHandle) then
      heroResHandle:RealDestroy()
    end
  end
  heroResHandles = {}
  for _, heroCell in pairs(heroCells) do
    if not IsNull(heroCell) then
      CS.UnityEngine.GameObject.Destroy(heroCell.gameObject)
    end
  end
  heroCells = {}
  for _, starInst in pairs(starInstList) do
    if not IsNull(starInst) then
      CS.UnityEngine.GameObject.Destroy(starInst.root)
    end
  end
  starInstList = {}
  if not IsNull(starsHudHandle) then
    starsHudHandle:Destroy()
    starsHudHandle = nil
    starTemplate = nil
  end
  for _, flyingStarHandle in pairs(flyingStarHandles) do
    if not IsNull(flyingStarHandle) then
      flyingStarHandle:Destroy()
    end
  end
  flyingStarHandles = {}
  for _, flyingStarTween in pairs(flyingStarTweens) do
    if not IsNull(flyingStarTween) then
      flyingStarTween:Kill()
    end
  end
  flyingStarTweens = {}
  if not IsNull(stageBubbleHandle) then
    stageBubbleHandle:RealDestroy()
    stageBubbleHandle = nil
  end
  if not IsNull(stageBubbleMarkHandle) then
    stageBubbleMarkHandle:Destroy()
    stageBubbleMarkHandle = nil
  end
  if soloHeroInst ~= nil then
    soloHeroInst:Delete()
    soloHeroInst = nil
  end
  for _, inst in pairs(zakuZombieInsts) do
    inst:Delete()
  end
  zakuZombieInsts = {}
  for _, inst in pairs(lingerZombieInsts) do
    inst:Delete()
  end
  lingerZombieInsts = {}
  for _, handle in pairs(deadZombieHandles) do
    if not IsNull(handle) then
      handle:Destroy()
    end
  end
  deadZombieHandles = {}
  if not IsNull(flagHandle) then
    flagHandle:Destroy()
    flagHandle = nil
  end
  for _, timer in ipairs(bubbleTimers) do
    if timer ~= nil then
      timer:Stop()
    end
  end
  bubbleTimers = {}
  if showBossTimer then
    showBossTimer:Stop()
  end
  showBossTimer = nil
  if arrowEffTimer then
    arrowEffTimer:Stop()
  end
  arrowEffTimer = nil
  if arrowEffSeq then
    arrowEffSeq:Kill()
  end
  arrowEffSeq = nil
  LWOpeningStageUtils.StopFingerSoundTimer()
  LWOpeningStageUtils.StopFingerSound()
  for _, handle in pairs(fingerClickHandles) do
    if not IsNull(handle) then
      handle:Destroy()
    end
  end
  fingerClickHandles = {}
  if focusCameraTween ~= nil then
    focusCameraTween:Kill()
    focusCameraTween = nil
  end
  stageBubbleHide = {}
  LWOpeningStageUtils.DestroyRoot()
  bossTrans = nil
  LWOpeningStageUtils.ClearMarchLine()
end

function LWOpeningStageUtils.ClearCameraTween()
  if focusCameraTween ~= nil then
    focusCameraTween:Kill()
    focusCameraTween = nil
  end
end

return LWOpeningStageUtils
