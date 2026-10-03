local LWGuideUtil = BaseClass("LWGuideUtil")
local Const = require("DataCenter.LWGuideManager.Const")
local GuideSoldie = require("DataCenter.LWGuideManager.GuideModel.GuideSoldie")
local GuideWorker = require("DataCenter.LWGuideManager.GuideModel.GuideWorker")
local GuideWorker1 = require("DataCenter.LWGuideManager.GuideModel.GuideWorker1")
local UniversalAdditionalCameraData = CS.UnityEngine.Rendering.Universal.UniversalAdditionalCameraData
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local guildPosList = "guildPosList"
local guideList = {}

function LWGuideUtil:OnLevelOne()
  DataCenter.LWOpeningStageManager:OnMarchReach(true)
end

function LWGuideUtil:OnOpeningDebut()
  DataCenter.LWCivilizationSparkExtend:LWGuideUtil_onOpeningDebut(self)
end

function LWGuideUtil:OnOpeningDebut_2()
  if CS.SceneManager.World then
    CS.SceneManager.World:LockCamera(Vector3(204.5, 150, 2), 0)
  end
  local blockHandle = UIManager:GetInstance():EnableInteractionBlocker(2, 8.5)
  local camTrans = CS.UnityEngine.Camera.main.transform
  TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.LWSoundManager:PlaySound(62239, false)
  end, 0.5)
  camTrans:DOMove(Vector3(271, 240, -60), 0.5):SetDelay(1):OnComplete(function()
    camTrans:DOMove(Vector3(253.7, 240, -139.7), 4):SetDelay(0.25):SetEase(CS.DG.Tweening.Ease.InOutQuad):OnComplete(function()
      camTrans:DOMove(Vector3(204.05, 150, -45.05), 2.2):SetDelay(0.8):OnComplete(function()
        if CS.SceneManager.World then
          CS.SceneManager.World:FreeCamera()
        end
        UIManager:GetInstance():DisableInteractionBlocker(blockHandle)
        local t = {
          lwGuideRecord = GuideState.CityCopter
        }
        DataCenter.LWGuideManager:UpdateGuide(t)
        SFSNetwork.SendMessage(MsgDefines.LWSaveGuide, GuideState.CityCopter)
      end)
    end)
    TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWOpeningStageManager.dirtyWorks:HeroDebut(DataCenter.LWOpeningStageManager)
    end, 3)
    TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWOpeningStageManager.dirtyWorks:HideAllFences()
      local leaderPos = DataCenter.LWOpeningStageManager.squadProxy.cells[1].position
      leaderPos.z = -10
      DataCenter.LWOpeningStageManager.squadProxy.cells[1].position = leaderPos
    end, 1.5)
  end)
  local stage = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Opening_Stage), 1)
  if 0 < #stage.plots_coords then
    for _, coordStr in ipairs(stage.plots_coords) do
      local coordArr = string.split(coordStr, ";")
      local delay = (math.random() * (stage.plots_delay_max - stage.plots_delay_min) + stage.plots_delay_min) * 0.001
      TimerManager:GetInstance():DelayInvoke(function()
        if stage.finish_plots ~= 0 then
          local evtParams = {}
          evtParams.plotGroupId = stage.finish_plots
          evtParams.anchor = Vector3(tonumber(coordArr[1]), tonumber(coordArr[2]), tonumber(coordArr[3]))
          evtParams.mode = "3D"
          EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleRandomly, evtParams)
        end
      end, delay)
    end
  end
end

function LWGuideUtil:SoldierComing(chapter)
  PostEventLog.Track(PostEventLog.Defines.NewbiesSoldierComing)
  local self = LWGuideUtil
  if self.tweens == nil then
    self.tweens = {}
  end
  if self.timers == nil then
    self.timers = {}
  end
  local blockHandle = UIManager:GetInstance():EnableInteractionBlocker(2, 8.5)
  local camTrans = CS.UnityEngine.Camera.main.transform
  table.insert(self.tweens, camTrans:DOMove(Vector3(203.7, 150, -45.8), 2.2):SetDelay(1.5):OnComplete(function()
    if CS.SceneManager.World then
      CS.SceneManager.World:FreeCamera()
    end
    UIManager:GetInstance():DisableInteractionBlocker(blockHandle)
    local t = {
      lwGuideRecord = GuideState.CityCopter
    }
    DataCenter.LWGuideManager:UpdateGuide(t)
    SFSNetwork.SendMessage(MsgDefines.LWSaveGuide, GuideState.CityCopter)
  end))
  DataCenter.LWOpeningStageManager.dirtyWorks:HideAllFences()
  local leader = DataCenter.LWOpeningStageManager.squadProxy.cells[1]
  local leaderPos = leader.position
  leaderPos.z = 10
  DataCenter.LWOpeningStageManager.squadProxy.cells[1].position = leaderPos
  DataCenter.LWOpeningStageManager.squadProxy.cells[1].gameObject:SetActive(false)
  table.insert(self.timers, TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.LWOpeningStageManager.squadProxy.cells[1].gameObject:SetActive(true)
    leader.gameObject:SetActive(true)
    DataCenter.LWOpeningStageManager.dirtyWorks:HeroDebut(DataCenter.LWOpeningStageManager)
  end, 0.1))
  table.insert(self.timers, TimerManager:GetInstance():DelayInvoke(function()
    local curStageId = DataCenter.LWOpeningStageManager:GetCurStageId()
    DataCenter.LWOpeningStageManager.utils.StartLoopArrowEffect(curStageId)
    table.insert(self.timers, TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWOpeningStageManager.utils.PlayUnlockEffect(Vector3.New(98, 0, 60))
      DataCenter.LWOpeningStageManager.utils.SetStageBubbleVisible(curStageId, true)
    end, 1.2))
  end, 2))
end

function LWGuideUtil:OnCityCopter_New2()
  local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(buildDataList[1].pointId)
  self.cityObj = cityObj.transform:Find("ModelGo/Normal/A_build_tingjiping/army_t6_06c")
  self.cityObj.gameObject:SetActive(false)
  DataCenter.GainWorkerManager:SetIsShowAllBubble(false)
end

function LWGuideUtil:OnCityCopter_New2_Done()
  local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(buildDataList[1].pointId)
  self.cityObj = cityObj.transform:Find("ModelGo/Normal/A_build_tingjiping/army_t6_06c")
  self.cityObj.gameObject:SetActive(true)
  DataCenter.GainWorkerManager:SetIsShowAllBubble(true)
  local t = {
    lwGuideRecord = GuideState.CityCopter
  }
  DataCenter.LWGuideManager:UpdateGuide(t)
  SFSNetwork.SendMessage(MsgDefines.LWSaveGuide, GuideState.CityCopter)
end

function LWGuideUtil:GetOpenDialogueWindowFun(unit, modelId, name, desList, closeCallBack)
  local function fun()
    local param = {}
    
    param.data = {}
    param.data.modelId = modelId
    param.data.name = Localization:GetString(name)
    param.desList = desList
    param.type = OptionType.Normal
    if unit then
      function param.callBack()
        unit:Delete()
      end
    end
    param.isNotShowMain = true
    param.isHide = true
    param.closeCallBack = closeCallBack
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICityVisitor, {anim = false}, param)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonPanelBtn)
  end
  
  return fun
end

function LWGuideUtil:OnSoldier()
  guideList = {}
  local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
  GoToUtil.GotoPos(buildDataList[1]:GetCenterVec(), CS.SceneManager.World.InitZoom, 0)
  local soldie = GuideSoldie:New()
  local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(buildDataList[1].pointId)
  local p_entry = cityObj.gameObject.transform:Find(guildPosList)
  local pathList = {}
  for i = 0, p_entry.childCount - 1 do
    table.insert(pathList, Vector3.New(p_entry:GetChild(i).position.x, p_entry:GetChild(i).position.y, p_entry:GetChild(i).position.z))
  end
  DataCenter.BuildBubbleManager:HideBubbleNode()
  local data = {}
  data.path = Const.soldierPath
  data.birthPos = p_entry.transform.position
  data.posList = DeepCopy(pathList)
  local desList = {
    {
      model = 10001,
      des = Localization:GetString(260001)
    },
    {
      model = 22101,
      des = Localization:GetString(260002)
    }
  }
  
  local function closeCallBack()
    local t = {
      lwGuideRecord = GuideState.Soldier
    }
    DataCenter.LWGuideManager:UpdateGuide(t)
    DataCenter.BuildBubbleManager:ShowBubbleNode()
    SFSNetwork.SendMessage(MsgDefines.LWSaveGuide, GuideState.Soldier)
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
    local pos = buildData:GetCenterVec()
    GoToUtil.GotoPos(pos, CS.SceneManager.World.InitZoom, 0)
    DataCenter.ArrowManager:ShowWorldFingerArrow(Vector3.New(pos.x + 1, pos.y, pos.z + 1))
    EventManager:GetInstance():Broadcast(EventId.CloseMainUIFingerArrow)
  end
  
  soldie:SetData(data)
  table.insert(guideList, soldie)
  data.openUIFun = self:GetOpenDialogueWindowFun(soldie, 10001, 153421, desList, closeCallBack)
  self:CreateSoldierList(0, 2, guideList)
end

function LWGuideUtil:PlayZombieDirector()
  if self.zombieDirector then
    self.zombieDirector:Play()
  end
end

function LWGuideUtil:CreateSoldierList(index, delay_time, soldier_list)
  index = index and index or 0
  index = index + 1
  if index > #soldier_list then
    return
  end
  soldier_list[index].index = index
  soldier_list[index]:CreateModel(function()
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      self:CreateSoldierList(index, delay_time, soldier_list)
    end, delay_time)
  end)
end

local __loopOpSoundId

function LWGuideUtil:LoadGuideTimeLine()
  local logic = DataCenter.LWBattleManager.logic
  local initPos = logic:GetInitPos()
  local offsetPos = logic.GetGuideTimelineOffset and logic.GetGuideTimelineOffset() or Vector3(0, 0, 14)
  local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Scene.Name).gameObject
  CanvasNormal:SetActive(false)
  local timelineOne = Const.BattleTimeLineOne
  self.zombieResource = ResourceManager:InstantiateAsync(timelineOne)
  self.zombieResource:completed("+", function(req)
    if logic.TeamObjectActive then
      logic:TeamObjectActive(false)
    end
    self.zombieDirector = req.gameObject:GetComponent(typeof(PlayableDirector))
    req.gameObject.transform.position = initPos + offsetPos
    self.zombieTimelineObj = req.gameObject
    local camera = self.zombieTimelineObj.transform:GetComponentInChildren(typeof(UniversalAdditionalCameraData))
    local delayTime = 3.5
    local isLevelOneGuide = DataCenter.LWGuideManager:GetCurGuideId() == GuideState.LevelOne
    local bannedByShumeiInGame = DataCenter.AccountManager:IsShumeiCreateAccountRisk()
    if isLevelOneGuide and not bannedByShumeiInGame and CS.ClientSwitch.IsOn(CS.ClientSwitch.ENABLE_ACCOUNT_SELECT_STATE) and CS.GameEntry.GlobalData.LoginServerError == false then
      delayTime = 4.8
    end
    self.timeLinedelayr = TimerManager:GetInstance():DelayInvoke(function()
      local camera = self.zombieTimelineObj.transform:GetComponentInChildren(typeof(UniversalAdditionalCameraData))
      if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIParkourBattleMain) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourBattleMain, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, {
          showGuide = true,
          enterType = PVEEnterType.OpeningStage,
          absoluteBtn = true
        })
      end
      __loopOpSoundId = DataCenter.LWSoundManager:PlaySound(10006, true)
    end, delayTime)
    self.zombieDirector:Play()
    DataCenter.LWSoundManager:PlayAMBSound(10005)
    CS.GameEntry.Sound:ResetAMBSoundVolumeInternal()
  end)
  local timelineTwo = Const.BattleTimeLineTwo_B
  self.parachuteResource = ResourceManager:InstantiateAsync(timelineTwo)
  self.parachuteResource:completed("+", function(req)
    self.parachuteDirector = req.gameObject:GetComponent(typeof(PlayableDirector))
    req.gameObject.transform.position = initPos + offsetPos
    self.parachuteTimelineObj = req.gameObject
    self.parachuteTimelineObj:SetActive(false)
    
    local function directorStopped()
      DataCenter.LWBattleManager:SetGamePause(false)
      Logger.Log("director parachuteResource stop")
      local logic = DataCenter.LWBattleManager.logic
      if logic and logic.team then
        if logic.TeamObjectActive then
          logic:TeamObjectActive(true)
        end
        CanvasNormal:SetActive(true)
        if logic.MonsterInit then
          logic:MonsterInit()
        end
        if logic.OnGuideTimelineDone then
          logic:OnGuideTimelineDone()
        end
      end
      self.parachuteResource:Destroy()
    end
    
    self.parachuteDirector:stopped("-", directorStopped)
    self.parachuteDirector:stopped("+", directorStopped)
  end)
end

function LWGuideUtil:BattleWinUpdateGuide(levelId)
  if DataCenter.LWGuideManager:GetCurGuideId() == GuideState.LevelOne then
    local message
    if levelId == LEVEL_ONE_ID then
      message = {}
      message.lwGuideRecord = GuideState.LevelOne
      SFSNetwork.SendMessage(MsgDefines.LWSaveGuide, message.lwGuideRecord)
      if CS.GameEntry.Network.IsConnected then
        DataCenter.LWGuideManager:UpdateGuide(message)
      end
    end
  end
end

function LWGuideUtil:GuideStartGame()
  if self.zombieResource then
    self.zombieResource:Destroy()
  end
  if self.parachuteTimelineObj then
    self.parachuteTimelineObj:SetActive(true)
  end
  if self.parachuteDirector then
    self.parachuteDirector:Play()
    DataCenter.LWSoundManager:PlayAMBSound(10007)
    if __loopOpSoundId then
      TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.LWSoundManager:StopSound(__loopOpSoundId)
        __loopOpSoundId = nil
      end, 5)
    end
  end
  DataCenter.LWGuideManager:SetIsStart(true)
  TimerManager:GetInstance():GetTimer(10, function()
    local logic = DataCenter.LWBattleManager.logic
    if logic.OnGuideTimelineStart and self.parachuteTimelineObj then
      logic:OnGuideTimelineStart(self.parachuteTimelineObj)
    end
  end, self, true, true):Start()
end

function LWGuideUtil:ClearData()
  if guideList ~= nil then
    for i = 1, #guideList do
      guideList[i]:Delete()
    end
  end
  guideList = nil
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  if self.zombieResource then
    self.zombieResource:Destroy()
    self.zombieDirector = nil
    self.zombieTimelineObj = nil
  end
  if self.parachuteResource then
    if not IsNull(self.parachuteDirector) then
      self.parachuteDirector:Stop()
      self.parachuteDirector = nil
    end
    self.parachuteResource:Destroy()
    self.parachuteTimelineObj = nil
  end
  if self.timeLinedelayr then
    self.timeLinedelayr:Stop()
    self.timeLinedelayr = nil
  end
  for i = 1, table.count(self.timers) do
    if self.timers[i] then
      self.timers[i]:Stop()
    end
  end
  self.timers = {}
  for i = 1, table.count(self.tweens) do
    if self.tweens[i] then
      self.tweens[i]:Kill()
    end
  end
  self.tweens = {}
end

function LWGuideUtil:OnWorkerAppear(id)
  local landData = DataCenter.LandLockManager:GetLandLockDataById(id)
  local pos = landData:GetCenterWorldPos()
  GoToUtil.GotoPos(pos, 150, LookAtFocusTime)
  guideList = {}
  local workerBuildDataList1 = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_QUARRY)
  local workerBuildDataList = {
    workerBuildDataList1[1]
  }
  local workerBirthPos = {pos}
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(22101)
  local workerCfg = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
  for i = 1, #workerBuildDataList do
    local workerData = {}
    workerData.path = workerCfg.Temporary_model
    workerData.birthPos = workerBirthPos[i]
    workerData.posList = {}
    workerData.buildData = workerBuildDataList[i]
    workerData.worker = workerCfg
    local worker = GuideWorker1:New()
    if i == 1 then
      function workerData.CreateCallBack()
        self.delay = TimerManager:GetInstance():DelayInvoke(function()
          DataCenter.ArrowManager:RemoveFingerArrow()
          
          local param = {}
          param.position = CS.CSUtils.WorldPositionToUISpacePosition(pos)
          param.arrowType = ArrowType.CityNpc
          param.positionType = PositionType.Screen
          DataCenter.ArrowManager:ShowArrow(param)
        end, 1)
      end
    end
    worker:SetData(workerData)
    worker.isWorker = true
    table.insert(guideList, worker)
  end
  self:CreateSoldierList(0, 0.2, guideList)
  self:OpenUnLanLackDialogueWindow()
end

function LWGuideUtil:OnWorkerDoing()
  for _, worker in ipairs(guideList) do
    worker:OnDialogueEnd()
  end
end

function LWGuideUtil:SendUpdateGuideMessage()
end

function LWGuideUtil:OpenWorkerCommPanelBtnView()
  local param = {}
  param.isCanClick = false
  param.clickDataList = {}
  local fun
  for i = 1, #guideList do
    if guideList[i].isWorker then
      if i == #guideList then
        function fun()
          guideList[i]:OnTriggerClick()
          
          local t = {
            lwGuideRecord = GuideState.Soldier
          }
          DataCenter.LWGuideManager:UpdateGuide(t)
          DataCenter.BuildBubbleManager:ShowBubbleNode()
          SFSNetwork.SendMessage(MsgDefines.LWSaveGuide, GuideState.Soldier)
        end
      else
        function fun()
          guideList[i]:OnTriggerClick()
        end
      end
      table.insert(param.clickDataList, fun)
    end
  end
  self:OpenPanelBtn(param)
end

function LWGuideUtil:OpenPanelBtn(param)
  local UICommonPanelBtn = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonPanelBtn)
  if UICommonPanelBtn ~= nil and UICommonPanelBtn.View then
    UICommonPanelBtn.View:ReInit(param)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonPanelBtn, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    }, param)
  end
end

function LWGuideUtil:OpenUnLanLackDialogueWindow()
  local param = {}
  param.isCanClick = true
  param.clickDataList = {}
  local desList = {
    {
      model = 22204,
      des = Localization:GetString(260005)
    },
    {
      model = 22204,
      des = Localization:GetString(260006)
    }
  }
  
  local function closeCallBack()
    for i = 1, #guideList do
      guideList[i]:OnDialogueEnd()
    end
  end
  
  local fun1 = self:GetOpenDialogueWindowFun(nil, 10001, 153340, desList, closeCallBack)
  table.insert(param.clickDataList, fun1)
  self:OpenPanelBtn(param)
end

return LWGuideUtil
