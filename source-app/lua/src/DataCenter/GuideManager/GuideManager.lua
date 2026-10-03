local GuideManager = BaseClass("GuideManager")
local Data = CS.GameEntry.Data
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local WaitLoadTime = 0.5
local WaitMessageLongTime = 5

local function __init(self)
  self.guideId = nil
  self.template = nil
  self.hasDoneGuide = {}
  self.allTriggerGuide = {}
  self.waitUIView = nil
  self.waitUIBtn = nil
  self.obj = nil
  self.objWorldPos = nil
  self.needParam = nil
  self.waitingMessage = {}
  self.isNoOpenUI = false
  self.guideState = GuideCanDoType.Yes
  self.objPositionType = PositionType.Screen
  
  function self.auto_next_timer_action(temp)
    self:AutoNextTimeCallBack()
  end
  
  function self.wait_load_timer_action(temp)
    self:WaitLoadCallBack()
  end
  
  function self.wait_time_timer_action(temp)
    self:WaitTimeCallBack()
  end
  
  function self.tips_wait_time_timer_action(temp)
    self:TipsWaitTimeCallBack()
  end
  
  function self.wait_long_delay_timer_callback(temp)
    self:WaitLongDelayTimerCallBack()
  end
  
  self.guideEndCallBack = nil
  self.dubName = nil
  self.dubId = nil
  self.noGotoTime = false
  self:AddListener()
  self.isDebug = CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor
  self.currentGetRewardGarbage = nil
  self.effectSound = {}
  self.fakeQuest = nil
  self.pveTrigger = {}
  self.specialTriggerGuide = {}
  self.successMarchFlag = SuccessMarchFlagType.No
  self.requestGm = nil
  self.waitTrigger = {}
  self.questTemplate = nil
end

local function __delete(self)
  self:DestroyGm()
  self:DeleteWaitLoadTimer()
  self:DeleteAutoNextTimer()
  self:DeleteWaitTimeTimer()
  self:DeleteTipsWaitTimeTimer()
  self:DeleteWaitLongDelayTimer()
  self.guideId = nil
  self.template = nil
  self.hasDoneGuide = {}
  self.allTriggerGuide = nil
  self.auto_next_timer_action = nil
  self.tips_wait_time_timer_action = nil
  self.waitUIView = nil
  self.waitUIBtn = nil
  self.obj = nil
  self.objPositionType = nil
  self.needParam = nil
  self.objWorldPos = nil
  self.isNoOpenUI = nil
  self.guideState = nil
  self.waitingMessage = nil
  self.guideEndCallBack = nil
  self.dubName = nil
  self.dubId = nil
  self:RemoveListener()
  self.isDebug = nil
  self.noGotoTime = nil
  self.effectSound = nil
  self.fakeQuest = nil
  self.pveTrigger = nil
  self.specialTriggerGuide = {}
  self.successMarchFlag = SuccessMarchFlagType.No
  self.waitTrigger = {}
end

local function Startup()
end

local function InitData(self, data)
  EventManager:GetInstance():Broadcast(EventId.GuideTimelineMarker, GuideTimeLineShowMarkerType.End)
  local guideRecord = data.guideRecord
  if guideRecord ~= nil then
    for k, v in pairs(guideRecord) do
      self.hasDoneGuide[k] = v
      self:ShowLog("shimin ------------------------- guideRecord ", k, "   ", v)
    end
  else
    self:ShowLog("shimin ++++++++++++++++++++++++ guideRecord == nil")
  end
  DataCenter.GuideTemplateManager:InitAllTemplate(DataCenter.GuideManager.allTriggerGuide)
  self:InitSpecialTrigger()
  self:SetCurGuideId(self:GetSaveGuideId())
  EventManager:GetInstance():Broadcast(EventId.GuideInitFinish)
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.Guide_video_Play, self.UILoadingExitSignal)
  EventManager:GetInstance():AddListener(EventId.BuildPlace, self.BuildPlaceSignal)
  EventManager:GetInstance():AddListener(EventId.OpenUI, self.OpenUISignal)
  EventManager:GetInstance():AddListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
  EventManager:GetInstance():AddListener(EventId.Queue_Add, self.QueueAddSignal)
  EventManager:GetInstance():AddListener(EventId.OnClickWorld, self.OnClickWorldSignal)
  EventManager:GetInstance():AddListener(EventId.CityGarbageResult, self.CityGarbageResultSignal)
  EventManager:GetInstance():AddListener(EventId.OpenFogSuccess, self.OpenFogSuccessSignal)
  EventManager:GetInstance():AddListener(EventId.BuildUpgradeFinish, self.BuildUpgradeFinishSignal)
  EventManager:GetInstance():AddListener(EventId.ChapterTaskGetReward, self.ChapterTaskGetRewardSignal)
  EventManager:GetInstance():AddListener(EventId.ShowAllGuideObject, self.ShowAllGuideObjectSignal)
  EventManager:GetInstance():AddListener(EventId.CloseUI, self.CloseUISignal)
  EventManager:GetInstance():AddListener(EventId.ChapterTask, self.ChapterTaskSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceApplySuccess, self.AllianceApplySuccessSignal)
  EventManager:GetInstance():AddListener(EventId.GuideNoOpenUI, self.GuideNoOpenUISignal)
  EventManager:GetInstance():AddListener(EventId.GuideWaitMessage, self.GuideWaitMessageSignal)
  EventManager:GetInstance():AddListener(EventId.MainTaskSuccess, self.MainTaskSuccessSignal)
  EventManager:GetInstance():AddListener(EventId.BuildResourcesStart, self.BuildResourcesStartSignal)
  EventManager:GetInstance():AddListener(EventId.OnWorldInputPointDown, self.OnWorldInputPointDownSignal)
  EventManager:GetInstance():AddListener(EventId.TrainingArmy, self.TrainingArmySignal)
  EventManager:GetInstance():AddListener(EventId.BuildLackConnect, self.BuildLackConnectSignal)
  EventManager:GetInstance():AddListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceDataSignal)
  EventManager:GetInstance():AddListener(EventId.HospitalUpdate, self.HospitalUpdateSignal)
  EventManager:GetInstance():AddListener(EventId.OnScienceQueueResearch, self.OnScienceQueueResearchSignal)
  EventManager:GetInstance():AddListener(EventId.StartAttackMonsterWithoutMsgTip, self.StartAttackMonsterWithoutMsgTipSignal)
  EventManager:GetInstance():AddListener(EventId.UpdateAlCanBeLeader, self.UpdateAlCanBeLeaderSignal)
  EventManager:GetInstance():AddListener(EventId.GarbageCollectStart, self.GarbageCollectStartSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.Guide_video_Play, self.UILoadingExitSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildPlace, self.BuildPlaceSignal)
  EventManager:GetInstance():RemoveListener(EventId.OpenUI, self.OpenUISignal)
  EventManager:GetInstance():RemoveListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
  EventManager:GetInstance():RemoveListener(EventId.Queue_Add, self.QueueAddSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnClickWorld, self.OnClickWorldSignal)
  EventManager:GetInstance():RemoveListener(EventId.CityGarbageResult, self.CityGarbageResultSignal)
  EventManager:GetInstance():RemoveListener(EventId.OpenFogSuccess, self.OpenFogSuccessSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeFinish, self.BuildUpgradeFinishSignal)
  EventManager:GetInstance():RemoveListener(EventId.ChapterTaskGetReward, self.ChapterTaskGetRewardSignal)
  EventManager:GetInstance():RemoveListener(EventId.ShowAllGuideObject, self.ShowAllGuideObjectSignal)
  EventManager:GetInstance():RemoveListener(EventId.CloseUI, self.CloseUISignal)
  EventManager:GetInstance():RemoveListener(EventId.ChapterTask, self.ChapterTaskSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceApplySuccess, self.AllianceApplySuccessSignal)
  EventManager:GetInstance():RemoveListener(EventId.GuideNoOpenUI, self.GuideNoOpenUISignal)
  EventManager:GetInstance():RemoveListener(EventId.GuideWaitMessage, self.GuideWaitMessageSignal)
  EventManager:GetInstance():RemoveListener(EventId.MainTaskSuccess, self.MainTaskSuccessSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildResourcesStart, self.BuildResourcesStartSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnWorldInputPointDown, self.OnWorldInputPointDownSignal)
  EventManager:GetInstance():RemoveListener(EventId.TrainingArmy, self.TrainingArmySignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildLackConnect, self.BuildLackConnectSignal)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceDataSignal)
  EventManager:GetInstance():RemoveListener(EventId.HospitalUpdate, self.HospitalUpdateSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnScienceQueueResearch, self.OnScienceQueueResearchSignal)
  EventManager:GetInstance():RemoveListener(EventId.StartAttackMonsterWithoutMsgTip, self.StartAttackMonsterWithoutMsgTipSignal)
  EventManager:GetInstance():RemoveListener(EventId.UpdateAlCanBeLeader, self.UpdateAlCanBeLeaderSignal)
  EventManager:GetInstance():RemoveListener(EventId.GarbageCollectStart, self.GarbageCollectStartSignal)
end

local function GetGuideId(self)
  return self.guideId
end

local function SetCurGuideId(self, id)
  self:ShowLog("shimin +++++++++++++++++++++ SetCurGuideId ", id)
  self:DeleteWaitLoadTimer()
  self:DeleteAutoNextTimer()
  self:DeleteWaitTimeTimer()
  self:DeleteTipsWaitTimeTimer()
  self:DeleteWaitLongDelayTimer()
  local lastGuideId = self.guideId
  local lastTemplate = self.template
  if self.guideState == GuideCanDoType.Yes and lastTemplate ~= nil and lastTemplate.savedoneid ~= 0 and not self:IsDoneThisGuide(lastTemplate.savedoneid) then
    self:SendSaveGuideMessage(self:GetDoneGuideEndId(lastTemplate.savedoneid), SaveGuideDoneValue)
    EventManager:GetInstance():Broadcast(EventId.GuideSaveId)
  end
  self.guideId = id
  self.waitUIView = nil
  self.waitUIBtn = nil
  self.obj = nil
  self.objWorldPos = nil
  self.objPositionType = PositionType.Screen
  self.needParam = {}
  if lastGuideId ~= nil then
    self:SendLogMessage(lastGuideId, StatTTType.Guide, id)
  end
  if lastTemplate ~= nil and lastTemplate.gototime ~= "" and not self.noGotoTime then
    EventManager:GetInstance():Broadcast(EventId.GotoTime, lastTemplate.gototime)
  end
  self.noGotoTime = false
  if id == GuideEndId then
    DataCenter.CityNpcManager:SetFollowNpc()
    if self.guideState == GuideCanDoType.Yes then
      self:SendSaveGuideMessage(SaveGuideId, tostring(id))
    end
    self:ShowLog("shimin +++++++++++++++++++++++ GuideEndId", GuideEndId)
    self.template = nil
    self.guideState = GuideCanDoType.Yes
    if self.guideEndCallBack ~= nil then
      self.guideEndCallBack()
      self.guideEndCallBack = nil
    end
    if self:InGuide() then
      EventManager:GetInstance():Broadcast(EventId.UINoInput, UINoInputType.ShowNoUI)
    else
      EventManager:GetInstance():Broadcast(EventId.UINoInput, UINoInputType.Close)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshGuide)
    if lastTemplate ~= nil and not lastTemplate:CanShowQuest() then
      EventManager:GetInstance():Broadcast(EventId.GuideEndNoShowQuest)
    end
    if DataCenter.BattleLevel:IsInBattleLevel() then
      DataCenter.BattleLevel:GuideEnd()
    else
      CS.SceneManager.World:ResetCameraMaxHeight()
    end
  else
    self.template = DataCenter.GuideTemplateManager:GetGuideTemplate(id)
    if self.template ~= nil then
      self.guideState = self:GetCanDoGuideState(id)
      self:ShowLog("shimin +++++++++++++++++++ self.guideState", self.guideState)
      if self.guideState == GuideCanDoType.No then
        if self.template.jumpid ~= 0 then
          self:SetCurGuideId(self.template.jumpid)
        else
          self:SetCurGuideId(GuideEndId)
        end
      else
        if self.template.forcetype == GuideForceType.Soft and self.template.savedoneid ~= 0 and not self:IsDoneThisGuide(self.template.savedoneid) then
          self:SendSaveGuideMessage(self:GetDoneGuideEndId(self.template.savedoneid), SaveGuideDoneValue)
          EventManager:GetInstance():Broadcast(EventId.GuideSaveId)
        end
        if self.template.returnstepid ~= 0 and self.template.returnstepid ~= self:GetSaveGuideId() then
          self:SendSaveGuideMessage(SaveGuideId, tostring(self.template.returnstepid))
        end
        if self.template.type == GuideType.ShowTalk then
        elseif self.template.type == GuideType.ClickButton and self.template.para1 ~= nil then
          self.objPositionType = PositionType.Screen
          local para = string.split_ss_array(self.template.para1, "/")
          local paraCount = table.count(para)
          if 0 < paraCount then
            self.waitUIView = para[1]
            local length = string.len(self.waitUIView)
            self:ShowLog("shimin +++++++++++++++++++++++ self.waitUIView", self.waitUIView)
            self.waitUIBtn = string.sub(self.template.para1, length + 2, string.len(self.template.para1))
            self:ShowLog("shimin +++++++++++++++++++++++ self.waitUIBtn", self.waitUIBtn)
          end
        elseif self.template.type == GuideType.Bubble or self.template.type == GuideType.CityGarbage or self.template.type == GuideType.GotoMoveBubble or self.template.type == GuideType.ClickTimeLineBubble or self.template.type == GuideType.ClickPveTriggerBubble or self.template.type == GuideType.ClickWoundedCompensateBubble then
          self.objPositionType = PositionType.World
        elseif (self.template.type == GuideType.OpenFog or self.template.type == GuideType.ClickBuild or self.template.type == GuideType.QueueBuild or self.template.type == GuideType.ClickBuildFinishBox or self.template.type == GuideType.ClickMonster or self.template.type == GuideType.ClickCityPointType or self.template.type == GuideType.ClickLandLockBubble or self.template.type == GuideType.ClickCollectResource or self.template.type == GuideType.ClickLandLockRewardBox) and self.template.para1 ~= nil then
          self.objPositionType = PositionType.World
        elseif self.template.type == GuideType.PlayMovie then
          if self.template.para1 ~= nil then
            local movieType = tonumber(self.template.para1)
            if movieType == GuidePlayMovieType.GameStartRocketFall or movieType == GuidePlayMovieType.BaseZeroUpgrade then
              self:SetCanShowBuild(false)
            end
          end
        elseif self.template.type == GuideType.CityGarbageResultShow then
        elseif self.template.type == GuideType.ClickQuickBuildBtn or self.template.type == GuideType.ClickGolloesCanSubmitOrder then
          self.objPositionType = PositionType.Screen
        elseif self.template.type == GuideType.WaitTroopArrive then
        elseif self.template.type == GuideType.ClickTime then
          self.objPositionType = PositionType.World
        elseif self.template.type == GuideType.ShowGuideTip then
          if self.template.para2 ~= nil and self.template.para2 ~= "" then
            local tempSpl = string.split_ss_array(self.template.para2, ";")
            if 1 < #tempSpl then
              local btnType = tonumber(tempSpl[1])
              if btnType == GuideType.ClickButton then
                self.objPositionType = PositionType.Screen
                local para = string.split_ss_array(tempSpl[2], "/")
                local paraCount = table.count(para)
                if 0 < paraCount then
                  self.waitUIView = para[1]
                end
              end
            end
          end
        elseif self.template.type == GuideType.ClickRadarMonster then
          self.objPositionType = PositionType.World
        elseif self.template.type == GuideType.ClickMonsterReward then
          self.objPositionType = PositionType.World
        elseif self.template.type == GuideType.ClickCollectResource then
          if tonumber(self.template.para1) >= ResourceType.ResourceItem then
            SFSNetwork.SendMessage(MsgDefines.FindResourcePoint, ResourceType.ResourceItem, 0, self.template.para1)
          else
            SFSNetwork.SendMessage(MsgDefines.FindResourcePoint, tonumber(self.template.para1), 0)
          end
        elseif self.template.type == GuideType.BlackHoleMask and self.template.para2 ~= nil and self.template.para2 ~= "" then
          self.objPositionType = PositionType.Screen
          local para = string.split_ss_array(self.template.para2, "/")
          local paraCount = table.count(para)
          if 0 < paraCount then
            self.waitUIView = para[1]
            local length = string.len(self.waitUIView)
            self.waitUIBtn = string.sub(self.template.para2, length + 2, string.len(self.template.para2))
          end
        elseif self.template.type == GuideType.UIPathArrow and self.template.para2 ~= nil and self.template.para2 ~= "" then
          self.objPositionType = PositionType.Screen
          local para = string.split_ss_array(self.template.para2, "/")
          local paraCount = table.count(para)
          if 0 < paraCount then
            self.waitUIView = para[1]
            local length = string.len(self.waitUIView)
            self.waitUIBtn = string.sub(self.template.para2, length + 2, string.len(self.template.para2))
          end
        end
      end
      if id == GuideStartId then
        for k, v in pairs(self.hasDoneGuide) do
          self:SendSaveGuideMessage(k, "")
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideVideo)
        self:SetNoShowUIMain(true)
        self:SetCanShowBuild(false)
        self:SendSaveGuideMessage(SaveNoShowGarbage, SaveGuideDoneValue)
        self:SendSaveGuideMessage(SaveNoShowBusinessBubble, SaveGuideDoneValue)
        self:SendSaveGuideMessage(GuideNoShowRadarBubble, SaveGuideDoneValue)
        self:SendSaveGuideMessage(BeforePrologue, SaveGuideDoneValue)
        self:SendSaveGuideMessage(PrologueNoAttack, SaveGuideDoneValue)
        self:SendSaveGuideMessage(FactoryFirstFreeSpeed, SaveGuideDoneValue)
        self:SendSaveGuideMessage(SearchMonsterInGarbage, SaveGuideDoneValue)
      end
      if self:InGuide() and id ~= GuideStartId then
        EventManager:GetInstance():Broadcast(EventId.UINoInput, UINoInputType.ShowNoUI)
      else
        EventManager:GetInstance():Broadcast(EventId.UINoInput, UINoInputType.Close)
      end
      EventManager:GetInstance():Broadcast(EventId.RefreshGuide)
    end
  end
end

local function GetSaveGuideId(self)
  if self.hasDoneGuide ~= nil then
    local saveId = self.hasDoneGuide[SaveGuideId]
    if saveId ~= nil then
      return tonumber(saveId)
    end
  end
  return GuideEndId
end

local function SendSaveGuideMessage(self, saveKey, saveValue)
  if self.hasDoneGuide ~= nil then
    local param = {}
    param.saveKey = tostring(saveKey)
    param.saveValue = tostring(saveValue)
    self.hasDoneGuide[saveKey] = saveValue
    SFSNetwork.SendMessage(MsgDefines.SaveGuide, param)
  end
end

local function SendLogMessage(self, id, statType, curId)
  local param = {}
  param.id = tostring(id)
  param.type = statType
  if curId == nil then
    curId = GuideEndId
  end
  param.curId = tostring(curId)
  SFSNetwork.SendMessage(MsgDefines.StatTT, param)
end

local function InGuide(self)
  return self.guideId ~= GuideEndId and self.template ~= nil
end

local function UILoadingExitSignal()
  DataCenter.GuideManager:CheckLoginGuide()
  local guideId = DataCenter.GuideManager:GetGuideId()
  if guideId == GuideStartId then
  else
    local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    if mainBuild ~= nil and mainBuild.state == BuildingStateType.FoldUp then
      DataCenter.GuideManager:SetCurGuideId(GuideEndId)
      DataCenter.GuideManager:DoGuide()
    elseif DataCenter.GuideManager:InGuide() then
      DataCenter.GuideManager:DoGuide()
    else
      DataCenter.GuideManager:InitTriggerGuide()
    end
  end
  DataCenter.GuideManager:LoadGuideGm()
end

local function DoGuide(self)
  if self.template ~= nil then
    self:ShowLog("shimin ++++++++++++++++++++++++++++++ DoGuide", self.template.id)
    if self:NeedWaitLoadComplete() then
      self:AddWaitLoadTimer()
    else
      self:DeleteWaitLoadTimer()
      self:CheckTipsWaitTime()
      self:CheckNeedWaitTime()
    end
  end
end

local function BuildPlaceSignal(data)
  if data ~= nil and data:ContainsKey("type") ~= nil then
    local buildId = tonumber(data:GetInt("type"))
    local param = {}
    param.buildId = buildId
    DataCenter.GuideManager:SetCompleteNeedParam(param)
    if buildId == BuildingTypes.FUN_BUILD_TRAINFIELD_1 then
      CS.SceneManager.World:DestroyCityTroop()
    end
    DataCenter.GuideManager:CheckGuideComplete()
    local buildNum = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(buildId)
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PlaceBuild, buildId .. ";" .. buildNum)
  end
end

local function CheckGuideComplete(self)
  if self.template ~= nil then
    if self.template.type == GuideType.ShowTalk then
      if self.needParam ~= nil and self.needParam.clickBtnObj ~= nil then
        self:DoNext()
      end
    elseif self.template.type == GuideType.ClickButton or self.template.type == GuideType.ClickQuest or self.template.type == GuideType.ClickQuickBuildBtn or self.template.type == GuideType.ClickGolloesCanSubmitOrder or self.template.type == GuideType.ClickRadarBubble or self.template.type == GuideType.ClickUISpecialBtn then
      if self.obj == self.needParam.clickBtnObj then
        self:DoNext()
      end
    elseif self.template.type == GuideType.BuildPlace then
      if self.template.para1 ~= nil and self.needParam ~= nil and tonumber(self.template.para1) == self.needParam.buildId then
        self:DoNext()
      end
    elseif self.template.type == GuideType.PlantFarm or self.template.type == GuideType.Factory then
      if self.template.para1 ~= nil and self.needParam ~= nil and tonumber(self.template.para1) == self.needParam.product_id then
        self:DoNext()
      end
    elseif self.template.type == GuideType.GetFarm then
      if self.template.para1 ~= nil and self.needParam ~= nil and self.needParam.queueList ~= nil then
        for k, v in pairs(self.needParam.queueList) do
          local queueData = DataCenter.QueueDataManager:GetQueueByUuid(v)
          if queueData ~= nil and queueData.type == tonumber(self.template.para1) then
            self:DoNext()
            break
          end
        end
      end
    elseif self.template.type == GuideType.Bubble then
      if self.template.para2 ~= nil and self.needParam ~= nil and BuildBubbleType[self.template.para2] == self.needParam.buildBubbleType then
        self:DoNext()
      end
    elseif self.template.type == GuideType.ClickBuildFinishBox then
      if self.template.para1 ~= nil and self.needParam ~= nil and tonumber(self.template.para1) == self.needParam.buildBoxId then
        self:DoNext()
      end
    elseif self.template.type == GuideType.CityGarbage then
      if self.needParam ~= nil and self.needParam.isClickGarbage then
        self:DoNext()
      end
    elseif self.template.type == GuideType.ClickMonster then
      if self.template.para1 ~= nil and self.needParam ~= nil then
        local spl = string.split_ss_array(self.template.para1, ",")
        if table.count(spl) > 1 then
          local vec = {}
          vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
          vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
          local pointId = SceneUtils.TilePosToIndex(vec)
          if pointId == self.needParam.pointId then
            self:DoNext()
          end
        end
      end
    elseif self.template.type == GuideType.ClickCityPointType then
      if self.template.para2 ~= nil and self.needParam ~= nil then
        local spl = string.split_ss_array(self.template.para2, ",")
        if table.count(spl) > 1 then
          local vec = {}
          vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
          vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
          local pointId = SceneUtils.TilePosToIndex(vec)
          if pointId == self.needParam.pointId then
            self:DoNext()
          end
        end
      end
    elseif self.template.type == GuideType.ClickTimeLineBubble or self.template.type == GuideType.ClickPveTriggerBubble or self.template.type == GuideType.ClickWoundedCompensateBubble then
      if self.needParam ~= nil and self.needParam.click then
        self:DoNext()
      end
    elseif self.template.type == GuideType.GotoMoveBubble then
      if self.needParam ~= nil and self.needParam.click then
        self:DoNext()
      end
    elseif self.template.type == GuideType.OpenFog then
      if self.template.para1 ~= nil and self.needParam ~= nil and Data.Fog:GetPointIdCenterByFogIndex(tonumber(self.template.para1), tonumber(self.template.para2)) == self.needParam.pointId then
        self:DoNext()
      end
    elseif self.template.type == GuideType.WaitCloseUI then
      if self.needParam ~= nil and self.needParam.uiName == self.template.para1 then
        self:DoNext()
      end
    elseif self.template.type == GuideType.ClickTime then
      if self.template.para2 ~= nil and self.needParam ~= nil and tonumber(self.template.para2) == self.needParam.buildTimeType then
        self:DoNext()
      end
    elseif self.template.type == GuideType.PlantAnimal then
      if self.template.para2 ~= nil and tonumber(self.template.para2) == self.needParam.stateType then
        self:DoNext()
      end
    elseif self.template.type == GuideType.ShowCommunicationTalk then
      if self.needParam ~= nil and self.needParam.clickBtnObj ~= nil then
        self:DoNext()
      end
    elseif self.template.type == GuideType.ClickLandLockBubble then
      if self.template.para1 ~= nil and self.needParam ~= nil and tonumber(self.template.para1) == self.needParam.landLockId then
        self:DoNext()
      end
    elseif self.template.type == GuideType.ClickCollectResource then
      if self.needParam ~= nil and self.needParam.collectType == tonumber(self.template.para1) then
        self:DoNext()
      end
    elseif self.template.type == GuideType.ClickLandLockRewardBox then
      if self.needParam ~= nil and self.needParam.id == tonumber(self.template.para1) then
        self:DoNext()
      end
    elseif self.template.type == GuideType.WaitMarchFightEnd then
      if self.needParam ~= nil and self.needParam.waitMarchFightEnd then
        CS.SceneManager.World.marchUuid = 0
        CS.SceneManager.World:TrackMarch(0)
        self:DoNext()
      end
    elseif self.template.type == GuideType.ClickRadarMonster then
      if self.needParam ~= nil and self.needParam.monster then
        self:DoNext()
      end
    elseif self.template.type == GuideType.ClickMonsterReward and self.needParam ~= nil and self.needParam.monsterReward then
      self:DoNext()
    end
  end
end

local function CheckOpenUITriggerGuide(self, uiName)
  if not self:InGuide() then
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.UIPanel, uiName)
  end
end

local function OpenUISignal(uiName)
  DataCenter.GuideManager:CheckOpenUITriggerGuide(uiName)
end

local function DeleteAutoNextTimer(self)
  if self.autoNextTimer ~= nil then
    self.autoNextTimer:Stop()
    self.autoNextTimer = nil
  end
end

local function AddAutoNextTimer(self, time)
  self:DeleteAutoNextTimer()
  if self.autoNextTimer == nil then
    self.autoNextTimer = TimerManager:GetInstance():GetTimer(time, self.auto_next_timer_action, self, true, false, false)
    self.autoNextTimer:Start()
  end
end

local function AutoNextTimeCallBack(self)
  self:DeleteAutoNextTimer()
  if self.template ~= nil then
    self:DoNext()
  end
end

local function GetCurTemplate(self)
  return self.template
end

local function HasClick(self, obj)
  if self:InGuide() then
    self.needParam.clickBtnObj = obj
    self:CheckGuideComplete()
  end
end

local function NeedWaitLoadComplete(self)
  local mainData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if mainData ~= nil and mainData.level == 0 and 0 < mainData.updateTime then
    return true
  end
  if self.waitUIView ~= nil and self.waitUIView ~= "" then
    if not UIManager:GetInstance():IsPanelLoadingComplete(self.waitUIView) then
      return true
    end
    if self.waitUIBtn ~= nil and self.waitUIBtn ~= "" then
      local trans
      local luaWindow = UIManager:GetInstance():GetWindow(self.waitUIView)
      if luaWindow ~= nil and luaWindow.View ~= nil and luaWindow.View.transform ~= nil then
        trans = luaWindow.View.transform
      end
      if trans == nil then
        return true
      end
      self.obj = trans:Find(self.waitUIBtn)
      if self.obj == nil then
        return true
      end
    end
  elseif self.template.type == GuideType.ClickBuild and self.objWorldPos == nil then
    local buildId = tonumber(self.template.para1)
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
    if list ~= nil then
      local needPointId
      if self.template.para2 ~= nil and self.template.para2 ~= "" then
        local spl = string.split_ss_array(self.template.para2, ",")
        if table.count(spl) > 1 then
          local vec = {}
          vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
          vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
          needPointId = SceneUtils.TilePosToIndex(vec)
        end
      end
      local needZeroBuild = false
      if self.template.para3 ~= nil and self.template.para3 ~= "" then
        needZeroBuild = true
      end
      for k, v in pairs(list) do
        if needZeroBuild or v.level > 0 then
          if needPointId ~= nil then
            if needPointId == v.pointId then
              self.objWorldPos = v:GetCenterVec()
              break
            end
          else
            self.objWorldPos = v:GetCenterVec()
            break
          end
        end
      end
    end
    if self.objWorldPos == nil then
      return true
    end
  elseif self.template.type == GuideType.PlantFarm or self.template.type == GuideType.PlantAnimal or self.template.type == GuideType.Factory then
    if self.needParam == nil or self.needParam.pointList == nil then
      return true
    end
  elseif self.template.type == GuideType.QueueBuild and self.objWorldPos == nil then
    local queueType = tonumber(self.template.para1)
    local needPointId
    if self.template.para2 ~= nil and self.template.para2 ~= "" then
      local spl = string.split_ss_array(self.template.para2, ",")
      if table.count(spl) > 1 then
        local vec = {}
        vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
        vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
        needPointId = SceneUtils.TilePosToIndex(vec)
      end
    end
    local list = DataCenter.QueueDataManager:GetBuildUuidInFinishQueueByType(queueType)
    if list ~= nil then
      for k, v in pairs(list) do
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
        if buildData ~= nil and buildData.level > 0 then
          if needPointId ~= nil then
            if needPointId == buildData.pointId then
              self.objWorldPos = buildData:GetCenterVec()
              break
            end
          else
            self.objWorldPos = buildData:GetCenterVec()
            break
          end
        end
      end
    end
    if self.objWorldPos == nil then
      return true
    end
  elseif self.template.type == GuideType.GetFarm then
    if self.needParam == nil or self.needParam.pointList == nil then
      return true
    end
  elseif self.template.type == GuideType.Bubble and self.obj == nil then
    local buildId = tonumber(self.template.para1)
    local bubbleType = BuildBubbleType[self.template.para2]
    self.obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(bubbleType, buildId)
    if self.obj == nil then
      return true
    end
  elseif self.template.type == GuideType.CityGarbage and self.objWorldPos == nil then
    local list = CS.SceneManager.World:GetGarbagePoint()
    if list ~= nil and 0 < list.Count then
      for i = 0, list.Count - 1 do
        local pointId = list[i]
        local obj = CS.SceneManager.World:GetObjectByPoint(pointId)
        if obj ~= nil then
          self.objWorldPos = SceneUtils.TileIndexToWorld(pointId)
          break
        end
      end
    end
    if self.objWorldPos == nil then
      return true
    end
  elseif self.template.type == GuideType.ClickMonster and self.obj == nil then
    local spl = string.split_ss_array(self.template.para1, ",")
    if table.count(spl) > 1 then
      local vec = {}
      vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
      vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
      local pointId = SceneUtils.TilePosToIndex(vec)
      local obj = CS.SceneManager.World:GetObjectByPointId(pointId)
      if obj ~= nil then
        cast(obj, typeof(CS.ModelManager.MonsterObject))
        self.obj = obj:GetObject()
      end
      if self.obj == nil then
        return true
      end
    end
  elseif self.template.type == GuideType.ClickCityPointType and self.obj == nil then
    local spl = string.split_ss_array(self.template.para2, ",")
    if table.count(spl) > 1 then
      local vec = {}
      vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
      vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
      local pointId = SceneUtils.TilePosToIndex(vec)
      local cityType = tonumber(self.template.para1)
      if cityType == CityPointType.GarbageReward then
        self.obj = DataCenter.GuidePickGarbageBubbleManager:GetBubbleByPoint(pointId)
      else
        local obj = CS.SceneManager.World:GetObjectByPointId(pointId)
        if obj ~= nil then
          if cityType == CityPointType.Monster then
            cast(obj, typeof(CS.ModelManager.MonsterObject))
          end
          self.obj = obj:GetObject()
        end
      end
      if self.obj == nil then
        return true
      end
    end
  elseif self.template.type == GuideType.GotoMoveBubble and self.obj == nil then
    self.obj = DataCenter.GotoMoveBubbleManager:GetObject()
    if self.obj == nil then
      return true
    end
  elseif self.template.type == GuideType.ClickTimeLineBubble and self.obj == nil then
    local bubbleType = tonumber(self.template.para1)
    if bubbleType == GuideTimeLineBubbleType.OstrichEgg then
      self.obj = DataCenter.GuideCityAnimManager:GetGuideObj(GuideAnimObjectType.ShowOstrichEgg)
    elseif bubbleType == GuideTimeLineBubbleType.ZeroRocket then
      self.obj = DataCenter.BuildZeroUpgradeEffectManager:GetGuideObj()
    elseif bubbleType == GuideTimeLineBubbleType.Migrate then
      self.obj = DataCenter.GuideCityAnimManager:GetGuideObj(GuideAnimObjectType.ShowMigrateScene)
    elseif bubbleType == GuideTimeLineBubbleType.Cow then
      self.obj = DataCenter.GuideCityAnimManager:GetGuideObj(GuideAnimObjectType.ShowCowScene)
    end
    if self.obj == nil then
      return true
    end
  elseif self.template.type == GuideType.OpenFog and self.objWorldPos == nil then
    local pointId = Data.Fog:GetPointIdCenterByFogIndex(tonumber(self.template.para1), tonumber(self.template.para2))
    self.objWorldPos = SceneUtils.TileIndexToWorld(pointId)
  elseif self.template.type == GuideType.DragCityTroop and self.obj == nil then
    self.obj = CS.SceneManager.World:GetCityTroop()
    if self.obj == nil then
      return true
    else
      local spl = string.split_ss_array(self.template.para1, ",")
      if table.count(spl) > 1 then
        local param = {}
        param.pointList = {}
        local startParam = {}
        startParam.pointType = PositionType.World
        startParam.pointObj = self.obj.gameObject
        table.insert(param.pointList, startParam)
        local endParam = {}
        endParam.pointType = PositionType.World
        local vec = {}
        vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
        vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
        local pointId = SceneUtils.TilePosToIndex(vec)
        endParam.pointPosition = SceneUtils.TileIndexToWorld(pointId)
        table.insert(param.pointList, endParam)
        param.arrowtype = self.template.arrowtype
        param.arrowdirection = self.template.arrowdirection
        self:SetCompleteNeedParam(param)
      end
    end
  elseif self.template.type == GuideType.ClickQuest and self.obj == nil then
    if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIChatNew) then
      local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIChatNew)
      if luaWindow ~= nil and luaWindow.View ~= nil then
        self.obj = nil
      end
      if self.obj == nil then
        return true
      end
    end
  elseif self.template.type == GuideType.ClickQuickBuildBtn and self.obj == nil then
    if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIMain) then
      local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
      if luaWindow ~= nil and luaWindow.View ~= nil then
        self.obj = luaWindow.View:GetClickFastObject()
      end
      if self.obj == nil then
        return true
      end
    end
  elseif self.template.type == GuideType.ClickBuildFinishBox and self.objWorldPos == nil then
    local buildId = tonumber(self.template.para1)
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
    if list ~= nil then
      for k, v in pairs(list) do
        if v:IsUpgradeFinish() then
          self.objWorldPos = v:GetCenterVec()
          GoToUtil.CloseAllWindows()
          break
        end
      end
    end
    if self.objWorldPos == nil then
      return true
    end
  elseif self.template.type == GuideType.ClickTime and self.obj == nil then
    local buildId = tonumber(self.template.para1)
    local timeType = tonumber(self.template.para2)
    self.obj = DataCenter.BuildTimeManager:GetTimeObjByTimeTypeAndBuildId(timeType, buildId)
    if self.obj == nil then
      return true
    end
  elseif self.template.type == GuideType.BuildRoad then
    local param = {}
    param.pointList = {}
    if self.template.para1 ~= nil then
      local spl = string.split_ss_array(self.template.para1, ";")
      for k, v in ipairs(spl) do
        local spl1 = string.split_ss_array(v, ",")
        if table.count(spl) > 1 then
          local vec = {}
          vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl1[1])
          vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl1[2])
          local startParam = {}
          startParam.pointType = PositionType.World
          startParam.pointPosition = SceneUtils.TileToWorld(vec)
          table.insert(param.pointList, startParam)
        end
      end
    end
    param.notUseEndFlag = true
    param.arrowtype = self.template.arrowtype
    param.arrowdirection = self.template.arrowdirection
    self:SetCompleteNeedParam(param)
  elseif self.template.type == GuideType.ClickGolloesCanSubmitOrder and self.obj == nil then
    if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIGroceryStore) then
      local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIGroceryStore)
      if luaWindow ~= nil and luaWindow.View ~= nil and self.template.para1 ~= nil then
        local spl = string.split_ss_array(self.template.para1, ";")
        local splCount = table.count(spl)
        if 0 < splCount then
          local guideOrderType = tonumber(spl[1])
          local orderState, orderType, orderProduct
          if 3 < splCount then
            orderState = tonumber(spl[2])
            orderType = tonumber(spl[3])
            orderProduct = spl[4]
          end
          local order = DataCenter.GroceryStoreOrderDataManager:GetOrderTypeOrder(guideOrderType, orderState, orderType, orderProduct)
          if order ~= nil then
            self.obj = luaWindow.View:GetOrderObjectByUuid(order.uuid)
          end
        end
      end
      if self.obj == nil then
        return true
      end
    end
  elseif self.template.type == GuideType.ClickRadarBubble and self.obj == nil then
    if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIDetectEvent) then
      local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIDetectEvent)
      if luaWindow ~= nil and luaWindow.View ~= nil then
        self.obj = luaWindow.View:GetGuideSpecialBubble(tonumber(self.template.para1), tonumber(self.template.para2))
      end
      if self.obj == nil then
        return true
      end
    end
  elseif self.template.type == GuideType.ClickUISpecialBtn and self.obj == nil then
    local btnType = tonumber(self.template.para1)
    if btnType == ClickUISpecialBtnType.UIFormationSelectHero then
      if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIFormationTableNew) then
        local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIFormationTableNew)
        if luaWindow ~= nil and luaWindow.View ~= nil then
          self.obj = luaWindow.View:GetRemoveHeroGuideGameObj()
        end
      end
    elseif btnType == ClickUISpecialBtnType.UIFormationDeleteHero then
      if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIFormationTableNew) then
        local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIFormationTableNew)
        if luaWindow ~= nil and luaWindow.View ~= nil then
          self.obj = luaWindow.View:GetSecondRemoveHeroGuideGameObj()
        end
      end
    elseif btnType == ClickUISpecialBtnType.UIFormationTableAddHero then
      if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIFormationTableNew) then
        local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIFormationTableNew)
        if luaWindow ~= nil and luaWindow.View ~= nil then
          self.obj = luaWindow.View:GetAddHeroGuideGameObj()
        end
      end
    elseif btnType == ClickUISpecialBtnType.UIPVESceneMinHeroRarity then
      if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIPVEScene) then
        local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVEScene)
        if luaWindow ~= nil and luaWindow.View ~= nil then
          local heroData = PveActorMgr:GetInstance():GetRarityMinHero()
          if heroData ~= nil then
            local obj = luaWindow.View:GetHeroObjByHeroId(heroData.heroId)
            if obj ~= nil then
              self.obj = obj
            end
          end
        end
      end
    elseif btnType == ClickUISpecialBtnType.UIPVESceneHeroId then
      if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIPVEScene) then
        local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVEScene)
        if luaWindow ~= nil and luaWindow.View ~= nil then
          local heroId = tonumber(self.template.para2)
          local obj = luaWindow.View:GetHeroObjByHeroId(heroId)
          if obj ~= nil then
            self.obj = obj
          end
        end
      end
    elseif btnType == ClickUISpecialBtnType.UIPVESceneHeroRarity then
      if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIPVEScene) then
        local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVEScene)
        if luaWindow ~= nil and luaWindow.View ~= nil then
          local heroRarity = tonumber(self.template.para2)
          local heroData = PveActorMgr:GetInstance():GetCanAddHeroByHeroRarity(heroRarity)
          if heroData ~= nil then
            local obj = luaWindow.View:GetHeroObjByHeroId(heroData.heroId)
            if obj ~= nil then
              self.obj = obj
            end
          end
        end
      end
    elseif btnType == ClickUISpecialBtnType.UIHeroListCanAdvanceHero then
      if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIHeroList) then
        local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroList)
        if luaWindow ~= nil and luaWindow.View ~= nil then
          local obj = luaWindow.View:GetHeroCellAdvanceGuideBtn()
          if obj ~= nil then
            self.obj = obj.gameObject
          end
        end
      end
    elseif btnType == ClickUISpecialBtnType.UIScience then
      if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIScience) then
        local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIScience)
        if luaWindow ~= nil and luaWindow.View ~= nil then
          local scienceId = tonumber(self.template.para2)
          local obj = luaWindow.View:GetScienceGuideBtn(scienceId)
          if obj ~= nil then
            self.obj = obj.gameObject
          end
        end
      end
    elseif btnType == ClickUISpecialBtnType.UIBuildUpgradeLackResource then
      if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIBuildUpgrade) then
        local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIBuildUpgrade)
        if luaWindow ~= nil and luaWindow.View ~= nil then
          local obj = luaWindow.View:GetGuideLackCellBtn()
          if obj ~= nil then
            self.obj = obj.gameObject
          end
        end
      end
    elseif btnType == ClickUISpecialBtnType.UIHeroAdvanceMainHero then
      if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIHeroAdvance) then
        local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroAdvance)
        if luaWindow ~= nil and luaWindow.View ~= nil then
          local obj = luaWindow.View:GetGuideCoreBtn()
          if obj ~= nil then
            self.obj = obj.gameObject
          end
        end
      end
    elseif btnType == ClickUISpecialBtnType.UIHeroAdvanceSubHero then
      if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIHeroAdvance) then
        local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroAdvance)
        if luaWindow ~= nil and luaWindow.View ~= nil then
          local obj = luaWindow.View:GetGuideDogFoodBtn()
          if obj ~= nil then
            self.obj = obj.gameObject
          end
        end
      end
    elseif btnType == ClickUISpecialBtnType.UIHeroListAdvanceHero then
      if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIHeroList) then
        local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroList)
        if luaWindow ~= nil and luaWindow.View ~= nil then
          local obj = luaWindow.View:GetHeroCellStarGuideBtn()
          if obj ~= nil then
            self.obj = obj.gameObject
          end
        end
      end
    elseif btnType == ClickUISpecialBtnType.UIHeroListHeroId and UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIHeroList) then
      local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroList)
      if luaWindow ~= nil and luaWindow.View ~= nil then
        local heroId = tonumber(self.template.para2)
        local obj = luaWindow.View:GetHeroItem(heroId)
        if obj ~= nil then
          self.obj = obj.gameObject
        end
      end
    end
    if self.obj == nil then
      return true
    end
  elseif self.template.type == GuideType.ClickLandLockBubble and self.obj == nil then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local landId = tonumber(self.template.para1)
      local bubble = DataCenter.LandLockBubbleManager:GetLandLockBubble(landId)
      if bubble ~= nil then
        self.obj = bubble:GetGuideNode()
      end
      if self.obj == nil then
        return true
      end
    end
  elseif self.template.type == GuideType.ClickCollectResource and self.objWorldPos == nil then
    local pointId = DataCenter.CollectResourceManager:GetFindResPoint()
    if pointId then
      DataCenter.CollectResourceManager:SetFindResPoint(nil)
      local obj = CS.SceneManager.World:GetObjectByPoint(pointId)
      if obj ~= nil then
        self.objWorldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
      end
      if self.objWorldPos == nil then
        return true
      end
    end
  elseif self.template.type == GuideType.ClickLandLockRewardBox and self.obj == nil then
    self.obj = DataCenter.LandLockManager:GetRewardGameObject(tonumber(self.template.para1))
    if self.obj == nil then
      return true
    end
  elseif self.template.type == GuideType.WaitMarchFightEnd then
    local movePos
    local allList = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
    if allList ~= nil then
      for _, v in ipairs(allList) do
        if v.state == ArmyFormationState.March then
          local buildId = MarchUtil.GetFormationBuildNameByIndex(v.index)
          local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
          if buildList ~= nil and 0 < table.count(buildList) and buildList[1] ~= nil then
            movePos = SceneUtils.TileIndexToWorld(buildList[1].pointId)
            break
          end
        end
      end
    end
    local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
    if table.csCount(selfMarch) == 0 then
      if movePos ~= nil then
        GoToUtil.GotoPos(movePos)
      end
      return true
    else
      local first = table.getFirst(selfMarch)
      local troop = CS.SceneManager.World:GetTroop(first.uuid)
      if troop == nil then
        GoToUtil.GotoMarchCurPos(first)
        return true
      end
    end
  elseif self.template.type == GuideType.ClickRadarMonster and self.objWorldPos == nil then
    local info = DataCenter.RadarCenterDataManager:GetOneInfoByEventTypeAndState(tonumber(self.template.para1), tonumber(self.template.para2))
    local marchInfo = CS.SceneManager.World:GetMarch(info.uuid)
    if marchInfo ~= nil then
      self.objWorldPos = SceneUtils.TileIndexToWorld(info.pointId)
    end
    if self.objWorldPos == nil then
      return true
    end
  elseif self.template.type == GuideType.ClickMonsterReward and self.objWorldPos == nil then
    local list
    if CS.SceneManager:IsInCity() then
      list = DataCenter.CityPointDataManager:GetPointDataListByType(CityPointType.MonsterReward)
    else
      list = DataCenter.CollectRewardDataManager:GetRewardListBySort()
    end
    if list ~= nil or 0 < table.count(list) then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      for k, v in ipairs(list) do
        if curTime <= v.expireTime then
          self.objWorldPos = SceneUtils.TileIndexToWorld(v.pointId)
          break
        end
      end
    end
    if self.objWorldPos == nil then
      return true
    end
  elseif self.template.type == GuideType.WaitPanelOpen then
    if self.template.para1 ~= nil and self.template.para1 ~= "" and not UIManager:GetInstance():IsPanelLoadingComplete(self.template.para1) then
      return true
    end
  elseif self.template.type == GuideType.AlliancePanelGuide then
    if not UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIAllianceMainTable) then
      return true
    end
  elseif self.template.type == GuideType.WaitGolloesArrived then
    local worldMarch, formationInfo = DataCenter.GolloesCampManager:GetGolloesMarchByType(GolloesType.Explorer)
    if worldMarch == nil then
      return true
    end
  elseif self.template.type == GuideType.ClickPveTriggerBubble and self.obj == nil then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local triggerId = tonumber(self.template.para1)
      local bubble = DataCenter.BattleLevel:GetTriggerBubble(triggerId)
      if bubble ~= nil then
        self.obj = bubble:GetGuideTrigger()
      end
      if self.obj == nil then
        return true
      end
    end
  elseif self.template.type == GuideType.ClickWoundedCompensateBubble and self.obj == nil then
    local bubble = DataCenter.WoundedCompensateManager:GetBubble()
    if bubble ~= nil then
      self.obj = bubble:GetGuideTrigger()
    end
    if self.obj == nil then
      return true
    end
  end
  return false
end

local function DeleteWaitLoadTimer(self)
  if self.waitLoadTimer ~= nil then
    self.waitLoadTimer:Stop()
    self.waitLoadTimer = nil
  end
end

local function AddWaitLoadTimer(self)
  self:DeleteWaitLoadTimer()
  if self.waitLoadTimer == nil then
    self.waitLoadTimer = TimerManager:GetInstance():GetTimer(WaitLoadTime, self.wait_load_timer_action, self, true, false, false)
    self.waitLoadTimer:Start()
  end
end

local function WaitLoadCallBack(self)
  self:DeleteWaitLoadTimer()
  self:DoGuide()
end

local function GetGuideType(self)
  if self:InGuide() and self.template ~= nil then
    return self.template.type
  end
  return 0
end

local function SetCompleteNeedParam(self, param)
  self.needParam = param
end

local function GetGuideIdByTrigger(self, triggerType, TriggerPara)
  if triggerType ~= nil and TriggerPara ~= nil and self.allTriggerGuide[triggerType] ~= nil then
    local guideId = self.allTriggerGuide[triggerType][TriggerPara]
    if guideId == nil or self:IsDoneThisGuide(guideId) or self:InGuide() or DataCenter.RecommendShowManager:IsHaveShowRecommend() then
    else
      return guideId
    end
  end
end

local function GetGuideTemplateParam(self, paramPara)
  if self.template ~= nil and paramPara ~= nil then
    return self.template[paramPara]
  end
end

local function IsCanOpenUI(self, uiName)
  if uiName == UIWindowNames.UIBuildList then
    return DataCenter.UnlockBtnManager:IsShowBtn(UnlockBtnType.Build)
  end
  if self:InGuide() then
    if uiName == UIWindowNames.UINoInput then
      return true
    end
    return not self.isNoOpenUI
  end
  return true
end

local function IsCanCloseUI(self, uiName)
  if self:InGuide() and self.template ~= nil and ((self.template.type == GuideType.PlantAnimal or self.template.type == GuideType.ClickTime) and uiName == UIWindowNames.UIPasture or self.template.type == GuideType.PlantFarm and uiName == UIWindowNames.UIFarm) then
    return false
  end
  return true
end

local function IsCanQuitFocus(self)
  if self:InGuide() and self.template ~= nil and self.template.type == GuideType.PlantAnimal then
    return false
  end
  return true
end

local function QueueTimeEndSignal(queueType)
  if queueType ~= nil then
    local id = tostring(queueType)
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.Queue, id)
    if queueType == NewQueueType.OstrichBarn or queueType == NewQueueType.CattleBarn or queueType == NewQueueType.SandWormBarn then
      DataCenter.GuideManager:CheckWaitMessage()
    end
  end
end

local function QueueAddSignal(queueType)
  if queueType ~= nil then
    local id = tostring(queueType)
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.OwnQueue, id)
  end
end

local function InitTriggerGuide(self)
  self:CheckFirstJoinAllianceGuide()
  self:CheckTreatSoldierGuide()
  self:CheckPlayerLevelGuide(DataCenter.GuideManager:GetSaveGuideValue(SaveTriggerGuidePlayerLevel))
end

local function GetNextGuideTemplateParam(self, paramPara)
  if self.template ~= nil and paramPara ~= nil and self.template.nextid ~= GuideEndId then
    local nextTemplate = DataCenter.GuideTemplateManager:GetGuideTemplate(self.template.nextid)
    if nextTemplate ~= nil then
      return nextTemplate[paramPara]
    end
  end
end

local function OnClickWorldSignal(pointId)
  local point = tonumber(pointId)
  local param = {}
  param.pointId = point
  DataCenter.GuideManager:SetCompleteNeedParam(param)
  DataCenter.GuideManager:CheckGuideComplete()
end

local function CityGarbageResultSignal(data)
  local pointId
  if data:ContainsKey("pointId") then
    pointId = data:GetInt("pointId")
  end
  if pointId ~= nil then
    local pos = SceneUtils.IndexToTilePos(pointId)
    local triggerPara = pos.x - DataCenter.BuildManager.main_city_pos.x .. "," .. pos.y - DataCenter.BuildManager.main_city_pos.y
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.CityGarbage, triggerPara)
  end
  DataCenter.GuideManager.currentGetRewardGarbage = nil
end

local function OpenFogSuccessSignal(fogId)
  if fogId ~= nil then
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.OpenFog, tostring(fogId))
  end
end

local function BuildUpgradeFinishSignal(uuid)
  if uuid ~= nil then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(tonumber(uuid))
    if buildData ~= nil then
      local buildId = buildData.itemId
      local level = buildData.level
      local num = DataCenter.BuildManager:GetOwnNumByBuildIdAndLevel(buildId, level)
      local triggerType = buildId .. "," .. level .. ";" .. num
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.BuildUpgrade, triggerType)
    end
  end
end

local function GetDoneGuideEndId(self, guideId)
  return tostring(guideId) .. "end"
end

local function GetDoneGuideStartId(self, guideId)
  return tostring(guideId) .. "start"
end

local function IsDoneThisGuide(self, guideId)
  return self.hasDoneGuide[self:GetDoneGuideEndId(guideId)] == SaveGuideDoneValue
end

local function PlayMovieCompleteSignal(data)
  if DataCenter.GuideManager:InGuide() then
    local template = DataCenter.GuideManager:GetCurTemplate()
    if template ~= nil and template.type == GuideType.PlayMovie then
      GuideManager:DoNext()
    end
  end
end

local function CheckDoTriggerGuide(self, guideTriggerType, triggerPara)
  local triggerPara = self:GetSpecialTriggerPara(guideTriggerType, triggerPara)
  local guideId = self:GetGuideIdByTrigger(guideTriggerType, triggerPara)
  if guideId ~= nil then
    self:SetCurGuideId(guideId)
    self:DoGuide()
    self:RemoveOneWaitTrigger(guideTriggerType, triggerPara)
    return true
  end
  return false
end

local function SaveFinalGarbageRewardItemId(self, itemId)
  self:SendSaveGuideMessage(FinalGarbageRewardItemId, tostring(itemId))
end

local function GetFinalGarbageRewardItemId(self)
  return self:GetSaveGuideValue(FinalGarbageRewardItemId)
end

local function GetSaveGuideValue(self, keyName)
  return self.hasDoneGuide and self.hasDoneGuide[keyName]
end

local function SaveCityTroopPeopleNum(self, num)
  self:SendSaveGuideMessage(CityTroopPeopleNum, tostring(num))
end

local function GetCityTroopPeopleNum(self)
  return DefaultCityTroopNum
end

local function ChapterTaskGetRewardSignal(chapterId)
  DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ChapterQuestAfterReward, tostring(chapterId))
end

local function IsCanDoUIMainAnim(self)
  return not self.noShowUIMain
end

local function SetNoShowUIMain(self, isNoShow)
  if self.noShowUIMain ~= isNoShow then
    if isNoShow then
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
    end
    self.noShowUIMain = isNoShow
    if not isNoShow then
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
    end
  end
end

local function IsStartCanShowBuild(self)
  return not self.isNoShowBuild
end

local function SetCanShowBuild(self, isShow)
  self.isNoShowBuild = not isShow
end

local function ShowAllGuideObjectSignal()
  DataCenter.GuideManager:SetCanShowBuild(true)
end

local function CloseUISignal(uiName)
  if DataCenter.GuideManager:GetGuideType() == GuideType.WaitCloseUI then
    local param = {}
    param.uiName = uiName
    DataCenter.GuideManager:SetCompleteNeedParam(param)
    DataCenter.GuideManager:CheckGuideComplete()
  end
  DataCenter.GuideManager:DoWaitTriggerAfterBack()
end

local function CheckNeedWaitTime(self)
  if self.template ~= nil and self.template.waittime > 0 then
    self:AddWaitTimeTimer(self.template.waittime / 1000)
  else
    self:WaitTimeCallBack()
  end
end

local function DeleteWaitTimeTimer(self)
  if self.waitTimeTimer ~= nil then
    self.waitTimeTimer:Stop()
    self.waitTimeTimer = nil
  end
end

local function AddWaitTimeTimer(self, time)
  self:DeleteWaitTimeTimer()
  if self.waitTimeTimer == nil then
    self.waitTimeTimer = TimerManager:GetInstance():GetTimer(time, self.wait_time_timer_action, self, true, false, false)
    self.waitTimeTimer:Start()
  end
end

local function WaitTimeCallBack(self)
  self:DeleteWaitTimeTimer()
  self:CallBackDoGuide()
end

local function ChapterTaskSignal()
end

local function MainTaskSuccessSignal()
  local list = DataCenter.TaskManager:GetCanReceivedList()
  if list ~= nil then
    for k, v in ipairs(list) do
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.TaskFinish, tostring(v))
    end
  end
end

local function IsCanBuildRoad(self)
  return true
end

local function CheckFirstJoinAllianceGuide(self)
  if not self:InGuide() and LuaEntry.Player.isFirstJoin == FirstJoinAllianceType.Yes and LuaEntry.Player:IsInAlliance() then
    self:CheckDoTriggerGuide(GuideTriggerType.FirstJoinAlliance, FirstJoinAllianceValue)
  end
end

local function AllianceApplySuccessSignal(self)
  DataCenter.GuideManager:CheckFirstJoinAllianceGuide()
end

local function IsStartId(self)
  return self.guideId == GuideStartId
end

local function GuideNoOpenUISignal(isNoOpenUI)
  DataCenter.GuideManager:SetNoOpenUI(isNoOpenUI)
end

local function SetNoOpenUI(self, isNoOpenUI)
  self.isNoOpenUI = isNoOpenUI
end

local function GetCanDoGuideState(self, guideId)
  local curTemplate = DataCenter.GuideTemplateManager:GetGuideTemplate(guideId)
  if curTemplate ~= nil then
    local state = GuideCanDoType.Yes
    for k5, v5 in ipairs(curTemplate.jumptype) do
      if curTemplate.jumppara[k5] ~= nil then
        state = self:GetReachJumpState(v5, string.split_ss_array(curTemplate.jumppara[k5], ";"))
      end
      if state ~= GuideCanDoType.Yes then
        return state
      end
    end
  end
  return GuideCanDoType.Yes
end

local function GetReachJumpState(self, jumpType, jumpPara)
  local jumpCount = jumpPara == nil and 0 or table.count(jumpPara)
  if jumpType == GuideJumpType.BuildPlace then
    if 0 < jumpCount then
      local buildId = tonumber(jumpPara[1])
      if 1 < jumpCount then
        local spl = string.split_ii_array(jumpPara[2], ",")
        if table.count(spl) > 1 then
          local vec = {}
          vec.x = DataCenter.BuildManager.main_city_pos.x + spl[1]
          vec.y = DataCenter.BuildManager.main_city_pos.y + spl[2]
          local pointId = SceneUtils.TilePosToIndex(vec)
          local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId)
          if buildData ~= nil and buildData.itemId == buildId then
            return GuideCanDoType.No
          end
          local isCanPut = BuildingUtils.IsCanPutDownByBuild(buildId, pointId)
          if isCanPut ~= BuildPutState.Ok then
            return GuideCanDoType.No
          end
        end
      end
      local buildState = DataCenter.BuildManager:GetBuildState(buildId)
      if buildState ~= BuildState.BUILD_LIST_STATE_OK then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.QueueBuild then
    local result = GuideCanDoType.No
    if 0 < jumpCount then
      local queueType = tonumber(jumpPara[1])
      local needPointId
      if 1 < jumpCount then
        local spl = string.split_ii_array(jumpPara[2], ",")
        if table.count(spl) > 1 then
          local vec = {}
          vec.x = DataCenter.BuildManager.main_city_pos.x + spl[1]
          vec.y = DataCenter.BuildManager.main_city_pos.y + spl[2]
          needPointId = SceneUtils.TilePosToIndex(vec)
        end
      end
      local list = DataCenter.QueueDataManager:GetBuildUuidInFinishQueueByType(queueType)
      if list ~= nil then
        for k, v in pairs(list) do
          local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
          if buildData ~= nil and 0 < buildData.level then
            if needPointId ~= nil then
              if needPointId == buildData.pointId then
                result = GuideCanDoType.Yes
                break
              end
            else
              result = GuideCanDoType.Yes
              break
            end
          end
        end
      end
    end
    return result
  elseif jumpType == GuideJumpType.PlantAnimal then
    if 0 < jumpCount then
      local buildId = tonumber(jumpPara[1])
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
      if buildData == nil or buildData.state == BuildingStateType.FoldUp then
        return GuideCanDoType.No
      end
      local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(buildData.uuid)
      if queueList == nil or table.count(queueList) == 0 then
        return GuideCanDoType.No
      end
      if jumpCount <= 2 then
        return GuideCanDoType.No
      end
      local stateType = tonumber(jumpPara[2])
      local itemId = jumpPara[3]
      if stateType == FarmStateType.Plant then
        if not DataCenter.FarmingDataManager:IsHaveEnough(itemId, FarmingEnoughType.Feed) then
          return GuideCanDoType.No
        end
        for k, v in pairs(queueList) do
          if v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Free then
          else
            return GuideCanDoType.No
          end
        end
        return GuideCanDoType.Yes
      elseif stateType == FarmStateType.Feed then
        if not DataCenter.FarmingDataManager:IsHaveEnough(itemId, FarmingEnoughType.Feed) then
          return GuideCanDoType.No
        end
        local result = GuideCanDoType.No
        for k, v in pairs(queueList) do
          if v.itemId == itemId and (v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Finish or v:GetParaState() == QueueProductState.PASTURE_MATURE and v:GetQueueState() == NewQueueState.Free) then
            result = GuideCanDoType.Yes
          end
        end
        return result
      elseif stateType == FarmStateType.HarvestSecond then
        local result = GuideCanDoType.No
        for k, v in pairs(queueList) do
          if v.itemId == itemId and v:GetParaState() == QueueProductState.PASTURE_MATURE and v:GetQueueState() == NewQueueState.Finish then
            result = GuideCanDoType.Yes
          end
        end
        return result
      end
    end
  elseif jumpType == GuideJumpType.WaitMessageFinish then
    if 0 < jumpCount then
      local waitType = tonumber(jumpPara[1])
      if self.waitingMessage[waitType] then
        return GuideCanDoType.Yes
      else
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.ClickTime then
    if 1 < jumpCount then
      local buildId = tonumber(jumpPara[1])
      local timeType = tonumber(jumpPara[2])
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
      if list ~= nil then
        if timeType == BuildTimeType.BuildTime_pasture then
          for k, v in pairs(list) do
            if v.state == BuildingStateType.FoldUp then
              return GuideCanDoType.No
            end
            local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(v.uuid)
            if queueList == nil or table.count(queueList) == 0 then
              return GuideCanDoType.No
            end
            for k1, v1 in pairs(queueList) do
              if v1:GetQueueState() == NewQueueState.Work then
                return GuideCanDoType.Yes
              end
            end
          end
        elseif timeType == BuildTimeType.BuildTime_Farm then
          for k, v in pairs(list) do
            local queueData = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(v.uuid)
            if queueData ~= nil and queueData:GetQueueState() == NewQueueState.Work then
              return GuideCanDoType.Yes
            end
          end
        elseif timeType == BuildTimeType.BuildTime_Upgrading then
          local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
          for k, v in pairs(list) do
            if curTime < v.updateTime and 0 <= v.level then
              return GuideCanDoType.Yes
            end
          end
        elseif timeType == BuildTimeType.BuildTime_CarSoldier or timeType == BuildTimeType.BuildTime_FootSoldier or timeType == BuildTimeType.BuildTime_BowSoldier then
          local queue = DataCenter.QueueDataManager:GetQueueByType(DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(buildId))
          if queue ~= nil then
            local state = queue:GetQueueState()
            if state == NewQueueState.Work then
              return GuideCanDoType.Yes
            end
          end
        end
      end
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.Factory then
    if 1 < jumpCount then
      local buildId = tonumber(jumpPara[1])
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
      if buildData == nil or not DataCenter.FactoryDataManager:IsCanProductByProductId(tonumber(jumpPara[2]), buildData.uuid) then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.ClickBuild then
    if 0 < jumpCount then
      local buildId = tonumber(jumpPara[1])
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
      if list ~= nil then
        local needPointId
        if 1 < jumpCount then
          local spl = string.split_ii_array(jumpPara[2], ",")
          if table.count(spl) > 1 then
            local vec = {}
            vec.x = DataCenter.BuildManager.main_city_pos.x + spl[1]
            vec.y = DataCenter.BuildManager.main_city_pos.y + spl[2]
            needPointId = SceneUtils.TilePosToIndex(vec)
          end
        end
        local result = GuideCanDoType.No
        for k, v in pairs(list) do
          if needPointId == nil or needPointId == v.pointId then
            result = GuideCanDoType.Yes
          end
        end
        return result
      end
    end
  elseif jumpType == GuideJumpType.FactorySpeed then
    if 1 < jumpCount then
      local buildId = tonumber(jumpPara[1])
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
      if list ~= nil then
        local productId = jumpPara[2]
        for k, v in pairs(list) do
          local factoryData = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(v.uuid)
          if factoryData ~= nil then
            for k1, v1 in ipairs(factoryData.planZoneList) do
              if v1 == productId then
                return GuideCanDoType.Yes
              end
            end
          end
        end
      end
    end
    return GuideCanDoType.No
  elseif jumpType == GuideJumpType.WaitCloseUI then
    if 0 < jumpCount and not UIManager:GetInstance():IsWindowOpen(jumpPara[1]) then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.BuildLevel then
    if 0 < jumpCount then
      local spl = string.split_ii_array(jumpPara[1], ",")
      if table.count(spl) > 1 then
        local level = DataCenter.BuildManager:GetMaxBuildingLevel(CommonUtil.GetBuildBaseType(spl[1]))
        if level <= CommonUtil.GetBuildLv(spl[2]) and level >= CommonUtil.GetBuildLv(spl[1]) then
          return GuideCanDoType.Yes
        else
          return GuideCanDoType.No
        end
      end
    end
  elseif jumpType == GuideJumpType.QueueState then
    if 1 < jumpCount then
      local queueType = tonumber(jumpPara[1])
      local queueState = tonumber(jumpPara[2])
      local queue = DataCenter.QueueDataManager:GetQueueByType(queueType)
      if queue ~= nil then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(queue.funcUuid)
        if buildData ~= nil then
          local state = queue:GetQueueState()
          if state == queueState and buildData.state == BuildingStateType.Normal then
            return GuideCanDoType.Yes
          end
        end
      end
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.AllianceMember then
    local member = DataCenter.AllianceMemberDataManager:GetNearMember()
    if member == nil then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.DoneGuide then
    if 0 < jumpCount then
      for k, v in ipairs(jumpPara) do
        if not self:IsDoneThisGuide(tonumber(v)) then
          return GuideCanDoType.Yes
        end
      end
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.CityPointType then
    if 1 < jumpCount then
      local cityType = tonumber(jumpPara[2])
      local spl = string.split_ss_array(jumpPara[1], ",")
      if table.count(spl) > 1 then
        local vec = {}
        vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
        vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
        local pointId = SceneUtils.TilePosToIndex(vec)
        local type = DataCenter.CityPointManager:GetPointType(pointId)
        if type ~= cityType then
          return GuideCanDoType.No
        end
      end
    end
  elseif jumpType == GuideJumpType.BuildRoad then
    local vec = {}
    local mainX = DataCenter.BuildManager.main_city_pos.x
    local mainY = DataCenter.BuildManager.main_city_pos.y
    for k, v in ipairs(jumpPara) do
      local spl = string.split_ii_array(v, ",")
      if table.count(spl) > 1 then
        vec.x = mainX + spl[1]
        vec.y = mainY + spl[2]
        local pointId = SceneUtils.TilePosToIndex(vec)
        local isCanPut = BuildingUtils.IsCanPutDownBoardByPoint(pointId)
        if isCanPut ~= BuildPutState.Ok then
          return GuideCanDoType.No
        end
      end
    end
  elseif jumpType == GuideJumpType.HasBuild then
    if 0 < jumpCount then
      local buildId = tonumber(jumpPara[1])
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
      if list ~= nil then
        local needPointId
        if 1 < jumpCount then
          local spl = string.split_ii_array(jumpPara[2], ",")
          if table.count(spl) > 1 then
            local vec = {}
            vec.x = DataCenter.BuildManager.main_city_pos.x + spl[1]
            vec.y = DataCenter.BuildManager.main_city_pos.y + spl[2]
            needPointId = SceneUtils.TilePosToIndex(vec)
          end
        end
        local result = GuideCanDoType.No
        for k, v in pairs(list) do
          if needPointId == nil or needPointId == v.pointId then
            result = GuideCanDoType.Yes
          end
        end
        return result
      end
    end
  elseif jumpType == GuideJumpType.HasGroceryStoreOrder then
    if 0 < jumpCount then
      local guideOrderType = tonumber(jumpPara[1])
      local orderState, orderType, orderProduct
      if 3 < jumpCount then
        orderState = tonumber(jumpPara[2])
        orderType = tonumber(jumpPara[3])
        orderProduct = tostring(jumpPara[4])
      end
      local order = DataCenter.GroceryStoreOrderDataManager:GetOrderTypeOrder(guideOrderType, orderState, orderType, orderProduct)
      if order == nil then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.ClickRadarBubble then
    if 1 < jumpCount then
      local info = DataCenter.RadarCenterDataManager:GetOneInfoByEventTypeAndState(tonumber(jumpPara[1]), tonumber(jumpPara[2]))
      if info == nil then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.IsHaveCanShopItem then
    if not DataCenter.StorageShopManager:IsHaveCanShopItem() then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.UIStorageShopMainViewTab then
    if 0 < jumpCount then
      if not UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIStorageShopMain) then
        return GuideCanDoType.No
      end
      local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIStorageShopMain)
      if luaWindow == nil or luaWindow.View == nil or tonumber(jumpPara[1]) ~= luaWindow.View:GetCurTab() then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.PlayerCareer then
    if not DataCenter.PlayerCareerManager:Enabled() or 0 < DataCenter.PlayerCareerManager:GetCareerType() then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.AllianceLeader then
    if not LuaEntry.Player:IsInAlliance() or not DataCenter.AllianceBaseDataManager:IsSelfLeader() then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.TreatSoldier then
    if not DataCenter.HospitalManager:IsHaveInjuredSolider() then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.BuildState then
    if 1 < jumpCount then
      local buildId = tonumber(jumpPara[1])
      local guideBuildState = tonumber(jumpPara[2])
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
      if buildData == nil then
        return GuideCanDoType.No
      end
      if guideBuildState == GuideBuildState.Normal then
        if buildData.state == BuildingStateType.Normal and not buildData:IsUpgrading() and not buildData:IsUpgradeFinish() and not buildData:IsInFix() then
          return GuideCanDoType.Yes
        end
      elseif guideBuildState == GuideBuildState.Box then
        if buildData:IsUpgradeFinish() and not buildData:IsInFix() then
          return GuideCanDoType.Yes
        end
      elseif guideBuildState == GuideBuildState.NeedConnect then
      end
    end
    return GuideCanDoType.No
  elseif jumpType == GuideJumpType.LandLockState then
    if 1 < jumpCount then
      local data = DataCenter.LandLockManager:GetLandLockDataById(tonumber(jumpPara[1]))
      if data == nil or data.state ~= tonumber(jumpPara[2]) then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.LandLockHasChest then
    if 0 < jumpCount then
      local data = DataCenter.LandLockManager:GetReward(tonumber(jumpPara[1]))
      if data == nil then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.LandLockPowerEnough then
    if 0 < jumpCount and not DataCenter.LandLockManager:IsArmyEnough(tonumber(jumpPara[1])) then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.PveHasUseBattleHero then
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    if isInBattle and 0 < jumpCount then
      local pveHasUseBattleHeroType = tonumber(jumpPara[1])
      if pveHasUseBattleHeroType == PveHasUseBattleHeroType.Any then
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVEScene) then
          if PveActorMgr:GetInstance():GetCanAddHero() then
            return GuideCanDoType.Yes
          end
        elseif DataCenter.BattleLevel:GetCanAddHero() then
          return GuideCanDoType.Yes
        end
      elseif pveHasUseBattleHeroType == PveHasUseBattleHeroType.HeroId then
        if 1 < jumpCount then
          local heroId = tonumber(jumpPara[2])
          if heroId ~= 0 and PveActorMgr:GetInstance():GetCanAddHeroByHeroId(heroId) then
            return GuideCanDoType.Yes
          end
        end
      elseif pveHasUseBattleHeroType == PveHasUseBattleHeroType.HeroQuality then
        if 1 < jumpCount then
          local heroRarity = tonumber(jumpPara[2])
          if heroRarity ~= nil and PveActorMgr:GetInstance():GetCanAddHeroByHeroRarity(heroRarity) ~= nil then
            return GuideCanDoType.Yes
          end
        end
      elseif pveHasUseBattleHeroType == PveHasUseBattleHeroType.HeroIdWithoutMax then
        if 1 < jumpCount then
          local heroId = tonumber(jumpPara[2])
          if heroId ~= 0 and PveActorMgr:GetInstance():IsHeroExistByHeroId(heroId) then
            return GuideCanDoType.Yes
          end
        end
      elseif pveHasUseBattleHeroType == PveHasUseBattleHeroType.HeroQualityWithoutMax and 1 < jumpCount then
        local heroRarity = tonumber(jumpPara[2])
        if heroRarity ~= nil and PveActorMgr:GetInstance():IsHeroExistByHeroRarity(heroRarity) ~= nil then
          return GuideCanDoType.Yes
        end
      end
    end
    return GuideCanDoType.No
  elseif jumpType == GuideJumpType.PveBattleMinHeroRarity then
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    if isInBattle and 0 < jumpCount then
      local heroRarity = tonumber(jumpPara[1])
      local heroData = PveActorMgr:GetInstance():GetRarityMinHero()
      if heroData ~= nil and heroRarity <= heroData.rarity then
        return GuideCanDoType.Yes
      end
    end
    return GuideCanDoType.No
  elseif jumpType == GuideJumpType.HasCanAdvanceHero then
    if not DataCenter.HeroDataManager:HasBeyondHero() then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.HasOutRangeLevelHero then
    if 0 < jumpCount then
      local maxLevel = tonumber(jumpPara[1])
      local curLevel = DataCenter.HeroDataManager:GetHighestHeroLevel()
      if maxLevel < curLevel then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.FactoryFreeSpeed then
    if not self:IsFactoryFirstFreeSpeed() then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.LockLandBubbleState then
    if 1 < jumpCount then
      local landId = tonumber(jumpPara[1])
      local bubble = DataCenter.LandLockBubbleManager:GetLandLockBubble(landId)
      if bubble ~= nil and bubble:GetBubbleState() == jumpPara[2] then
        return GuideCanDoType.Yes
      end
    end
    return GuideCanDoType.No
  elseif jumpType == GuideJumpType.HaveAlliance then
    if 0 < jumpCount then
      local state = tonumber(jumpPara[1])
      local have = LuaEntry.Player:IsInAlliance()
      if have and state == HaveAllianceType.No then
        return GuideCanDoType.No
      elseif not have and state == HaveAllianceType.Yes then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.IsFormationUnset then
    if 0 < jumpCount then
      local index = tonumber(jumpPara[1])
      if DataCenter.ArmyFormationDataManager:IsFormationUnsetByIndex(index) then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.IsSuccessMarch then
    if self.successMarchFlag == SuccessMarchFlagType.No then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.HaveMonsterReward then
    local list
    if CS.SceneManager:IsInCity() then
      list = DataCenter.CityPointDataManager:GetPointDataListByType(CityPointType.MonsterReward)
    else
      list = DataCenter.CollectRewardDataManager:GetRewardListBySort()
    end
    if list ~= nil or 0 < table.count(list) then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      for k, v in ipairs(list) do
        if curTime <= v.expireTime then
          return GuideCanDoType.Yes
        end
      end
    end
    return GuideCanDoType.No
  elseif jumpType == GuideJumpType.GetMonsterRewardBagFull then
    local list
    if CS.SceneManager:IsInCity() then
      list = DataCenter.CityPointDataManager:GetPointDataListByType(CityPointType.MonsterReward)
    else
      list = DataCenter.CollectRewardDataManager:GetRewardListBySort()
    end
    if list ~= nil or 0 < table.count(list) then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      for k, v in ipairs(list) do
        if curTime <= v.expireTime then
          if v.rewardList ~= nil then
            local totalNum = 0
            for k1, v1 in pairs(v.rewardList) do
              if v1.rewardType == RewardType.RESOURCE_ITEM then
                totalNum = totalNum + v1.count
                if DataCenter.ResourceItemDataManager:CheckIsStorageFull(totalNum) then
                  return GuideCanDoType.No
                end
              end
            end
          end
          return GuideCanDoType.Yes
        end
      end
    end
    return GuideCanDoType.No
  elseif jumpType == GuideJumpType.Bubble then
    if 1 < jumpCount then
      local buildId = tonumber(jumpPara[1])
      local bubbleType = BuildBubbleType[jumpPara[2]]
      if DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(bubbleType, buildId) == nil then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.AttackLevelMonster then
    if 0 < jumpCount then
      local level = tonumber(jumpPara[1])
      if level > DataCenter.MonsterManager:GetCurCanAttackMaxLevel() then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.FinishChapter then
    if 0 < jumpCount then
      local needChapterId = tonumber(jumpPara[1])
      if DataCenter.ChapterTaskManager:IsCompleteAllChapter() == false then
        local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
        if chapterId ~= nil and needChapterId >= chapterId then
          return GuideCanDoType.No
        end
      end
    end
  elseif jumpType == GuideJumpType.HaveLeaderInAlliance then
    if not LuaEntry.Player:IsInAlliance() or DataCenter.AllianceBaseDataManager:CheckIfCanPayAsLeader() then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.FactoryState then
    if 1 < jumpCount then
      local buildId = tonumber(jumpPara[1])
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
      if buildData ~= nil then
        local state = DataCenter.FactoryDataManager:GetFactoryStateByBuildUuid(buildData.uuid)
        if state == tonumber(jumpPara[2]) then
          return GuideCanDoType.Yes
        end
      end
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.PveLevelExploreState then
  elseif jumpType == GuideJumpType.OwnResourceItemNum then
    if 1 < jumpCount then
      local itemId = tonumber(jumpPara[1])
      local num = DataCenter.ResourceItemDataManager:GetCountByItemId(itemId)
      if num < tonumber(jumpPara[2]) then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.UIResourceLackHaveLackTips then
    if 0 < jumpCount then
      if not UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIResourceLackNew) then
        return GuideCanDoType.No
      end
      local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIResourceLackNew)
      if luaWindow == nil or luaWindow.View == nil or not luaWindow.View:GuidHandle(tonumber(jumpPara[1])) then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.OwnResourceNum then
    if 1 < jumpCount then
      local num = LuaEntry.Resource:GetCntByResType(tonumber(jumpPara[1]))
      if num < tonumber(jumpPara[2]) then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.PveTaskNotUnCompleteState then
    if 1 < jumpCount then
      local taskId = jumpPara[2]
      local pveTaskList = DataCenter.TaskManager:GetPVETaskById(tonumber(jumpPara[1]))
      if pveTaskList ~= nil then
        for k, v in pairs(pveTaskList) do
          if v.id == taskId and v.state == TaskState.NoComplete then
            return GuideCanDoType.Yes
          end
        end
      end
    end
    return GuideCanDoType.No
  elseif jumpType == GuideJumpType.HaveUpgradeHero then
    if 0 < jumpCount and not HeroAdvanceController:GetInstance():HasHeroCanAdvance(tonumber(jumpPara[1])) then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.HistoryUpgradeHero then
    if HeroAdvanceController:GetInstance():HasHeroAdvanced() then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.BuildBubble then
    if 1 < jumpCount then
      local buildId = tonumber(jumpPara[1])
      local bubbleType = BuildBubbleType[jumpPara[2]]
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
      for k, v in ipairs(list) do
        local param = DataCenter.BuildBubbleManager:GetBuildNeedShowBuildBubble(v.uuid)
        if param ~= nil and param.buildBubbleType == bubbleType then
          return GuideCanDoType.Yes
        end
      end
    end
    return GuideCanDoType.No
  elseif jumpType == GuideJumpType.SceneType then
    if 0 < jumpCount then
      local sceneType = tonumber(jumpPara[1])
      if sceneType == GuideSceneType.City then
        if not SceneUtils.GetIsInCity() then
          return GuideCanDoType.No
        end
      elseif sceneType == GuideSceneType.World then
        if not SceneUtils.GetIsInWorld() then
          return GuideCanDoType.No
        end
      elseif sceneType == GuideSceneType.Pve and not DataCenter.BattleLevel:IsInBattleLevel() then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.HasStarUpHero then
    if DataCenter.HeroDataManager:hasStarUpHero() then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.HasCanStarUpHero then
    if not DataCenter.HeroDataManager:hasCanStarUpHero() then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.PveBattleResult then
    if 0 < jumpCount then
      local result = tonumber(jumpPara[1])
      if DataCenter.BattleLevel:IsInBattleLevel() and PveActorMgr:GetInstance():GetBattleResult() == result then
        return GuideCanDoType.Yes
      end
    end
    return GuideCanDoType.No
  elseif jumpType == GuideJumpType.OwnItemNum then
    if 1 < jumpCount then
      local itemId = tonumber(jumpPara[1])
      local num = DataCenter.ItemData:GetItemCount(itemId)
      if num < tonumber(jumpPara[2]) then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.ShowQuestId then
    if 0 < jumpCount then
      local taskId = jumpPara[1]
      if not DataCenter.ChapterTaskCellManager:CheckIdIsShow(taskId) then
        return GuideCanDoType.No
      end
    end
  elseif jumpType == GuideJumpType.WorldCollectPoint then
    local resourceType = 0
    local itemId = 0
    if 1 < jumpCount then
      itemId = tonumber(jumpPara[2])
    end
    if 0 < jumpCount then
      resourceType = tonumber(jumpPara[1])
    end
    local state = MarchUtil.GetResourcePointUnlockStateByType(resourceType, itemId)
    if state == 0 then
      return GuideCanDoType.No
    end
  elseif jumpType == GuideJumpType.UIPVEPowerLack and 0 < jumpCount then
    local needType = tonumber(jumpPara[1])
    if not UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIPVEPowerLack) then
      return GuideCanDoType.No
    end
    local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVEPowerLack)
    if luaWindow == nil or luaWindow.View == nil or not luaWindow.View:HasTip(needType) then
      return GuideCanDoType.No
    end
  end
  return GuideCanDoType.Yes
end

local function IsCanClick(self, curIndex)
  if self:InGuide() and self.template ~= nil and self.template.type == GuideType.OpenFog and Data.Fog:GetPointIdCenterByFogIndex(tonumber(self.template.para1), tonumber(self.template.para2)) ~= curIndex then
    return false
  end
  return true
end

local function GuideWaitMessageSignal()
  DataCenter.GuideManager:CheckWaitMessage()
end

local function CheckWaitMessage(self)
  if self:InGuide() and self.template ~= nil and self.template.type == GuideType.WaitMessageFinish and self.template.para1 ~= nil and self.template.para1 ~= "" then
    local guideId = self.template.returnstepid
    local waitType = tonumber(self.template.para1)
    if waitType == WaitMessageFinishType.PlantAnim then
      if self.template.para3 ~= nil and self.template.para3 ~= "" then
        local buildId = tonumber(self.template.para3)
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
        if buildData == nil or buildData.state == BuildingStateType.FoldUp then
          guideId = self.template.returnstepid
        end
        local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(buildData.uuid)
        if queueList == nil or table.count(queueList) == 0 then
          guideId = self.template.returnstepid
        end
        for k, v in pairs(queueList) do
          if v.itemId == self.template.para2 and (v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Finish or v:GetParaState() == QueueProductState.PASTURE_MATURE and v:GetQueueState() == NewQueueState.Free) then
            guideId = self.template.nextid
          end
        end
      end
    elseif waitType == WaitMessageFinishType.PlantFarm then
      if self.template.para2 ~= nil then
        local spl = string.split_ss_array(self.template.para2, ";")
        local mainPos = DataCenter.BuildManager.main_city_pos
        local isCanDone = true
        for k2, v2 in ipairs(spl) do
          local spl1 = string.split_ss_array(v2, ",")
          if table.count(spl) > 1 then
            local vec = {}
            vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl1[1])
            vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl1[2])
            local pointId = SceneUtils.TilePosToIndex(vec)
            local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId)
            if buildData == nil or buildData.itemId ~= BuildingTypes.APS_BUILD_FARM_FIELD then
              isCanDone = false
            end
          end
        end
        if isCanDone then
          guideId = self.template.nextid
        end
      end
    elseif waitType == WaitMessageFinishType.GetAnim then
      if self.template.para3 ~= nil and self.template.para3 ~= "" then
        local buildId = tonumber(self.template.para3)
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
        if buildData == nil or buildData.state == BuildingStateType.FoldUp then
          guideId = self.template.returnstepid
        end
        local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(buildData.uuid)
        if queueList == nil or table.count(queueList) == 0 then
          guideId = self.template.returnstepid
        end
        for k, v in pairs(queueList) do
          if v.itemId == self.template.para2 and v:GetParaState() == QueueProductState.PASTURE_MATURE and v:GetQueueState() == NewQueueState.Finish then
            guideId = self.template.nextid
            self:SetWaitingMessage(WaitMessageFinishType.GetAnim, nil)
          end
        end
      end
    elseif waitType == WaitMessageFinishType.FeedAnim then
      if self.template.para3 ~= nil and self.template.para3 ~= "" then
        local buildId = tonumber(self.template.para3)
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
        if buildData == nil or buildData.state == BuildingStateType.FoldUp then
          guideId = self.template.returnstepid
        end
        local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(buildData.uuid)
        if queueList == nil or table.count(queueList) == 0 then
          guideId = self.template.returnstepid
        end
        for k, v in pairs(queueList) do
          if v.itemId == self.template.para2 and v:GetParaState() == QueueProductState.PASTURE_MATURE and v:GetQueueState() == NewQueueState.Work then
            guideId = self.template.nextid
            local signal = SFSObject.New()
            signal:PutLong("bUuid", buildData.uuid)
            signal:PutLong("queueUuid", v.uuid)
            EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShow, signal)
          end
        end
      end
    elseif waitType == WaitMessageFinishType.AllianceMember then
      guideId = self.template.nextid
    elseif waitType == WaitMessageFinishType.PurchaseOrderFinish then
      guideId = self.template.nextid
    else
      guideId = self.template.nextid
    end
    self:SetCurGuideId(guideId)
    self:DoGuide()
  end
end

local function DoNext(self)
  if self.template ~= nil then
    self:SetCurGuideId(self.template.nextid)
    self:DoGuide()
  end
end

local function LoadGuideGm(self)
  if self.requestGm == nil then
    self.requestGm = ResourceManager:InstantiateAsync(UIAssets.GuideGM)
    self.requestGm:completed("+", function()
      if self.requestGm.isError then
        return
      end
      self.requestGm.gameObject:SetActive(true)
      self.requestGm.gameObject.transform:SetAsFirstSibling()
    end)
  end
end

local function DestroyGm(self)
  if self.requestGm ~= nil then
    self.requestGm:Destroy()
    self.requestGm = nil
  end
end

local function SetWaitingMessage(self, waitType, value)
  self.waitingMessage[waitType] = value
end

local function SaveRecommendShow(self, value)
  self:SendSaveGuideMessage(SaveGuideRecommendShow, value)
end

local function GetRecommendShow(self)
  return self:GetSaveGuideValue(SaveGuideRecommendShow)
end

local function BuildResourcesStartSignal()
  if CS.SceneManager:IsInCity() then
    local buildIdList = DataCenter.QueueDataManager:GetBuildUuidInFreeQueueByType(NewQueueType.Field)
    if buildIdList == nil or table.count(buildIdList) == 0 then
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.NoFreeQueue, tostring(NewQueueType.Field))
    end
  end
end

local function OnWorldInputPointDownSignal(pointId)
  local guideType = DataCenter.GuideManager:GetGuideType()
  if guideType == GuideType.ShowTroopTalk then
    DataCenter.GuideManager:DoNext()
  end
end

local function SetGuideEndCallBack(self, callBack)
  if self:InGuide() then
    self.guideEndCallBack = callBack
  else
    callBack()
  end
end

local function CheckMoveToWorldGuide(self)
  if LuaEntry.Player:IsInAlliance() then
    self:CheckDoTriggerGuide(GuideTriggerType.MoveToWorldJoinAlliance, MoveToWorldJoinAllianceType.Join)
  else
    self:CheckDoTriggerGuide(GuideTriggerType.MoveToWorldJoinAlliance, MoveToWorldJoinAllianceType.No)
  end
end

local function CheckNoInput(self)
  local template = self:GetCurTemplate()
  if template ~= nil and template.forcetype == GuideForceType.Force then
    local guideType = template.type
    if guideType == GuideType.ClickBuild or guideType == GuideType.QueueBuild or guideType == GuideType.Bubble or guideType == GuideType.CityGarbage or guideType == GuideType.GotoMoveBubble or guideType == GuideType.OpenFog or guideType == GuideType.ClickBuildFinishBox or guideType == GuideType.ClickTime or guideType == GuideType.BuildRoad or guideType == GuideType.DragCityTroop or guideType == GuideType.ClickMonster or guideType == GuideType.ClickTimeLineBubble or guideType == GuideType.ClickCityPointType or guideType == GuideType.ClickLandLockBubble or guideType == GuideType.ClickCollectResource or guideType == GuideType.CollectUISpecialGuide or guideType == GuideType.ClickLandLockRewardBox or guideType == GuideType.PveShowBattleSpeedBtn or guideType == GuideType.PveShowBattleFinishBtn or guideType == GuideType.PveShowBattlePowerLight or guideType == GuideType.PveShowBattleBloodLight or guideType == GuideType.ClickRadarMonster or guideType == GuideType.ClickMonsterReward or guideType == GuideType.PveShowStaminaLight or guideType == GuideType.ClickPveTriggerBubble or guideType == GuideType.ClickWoundedCompensateBubble then
      EventManager:GetInstance():Broadcast(EventId.UINoInput, UINoInputType.Close)
    elseif guideType == GuideType.ClickButton or guideType == GuideType.ClickQuest or guideType == GuideType.PlantAnimal or guideType == GuideType.Factory or guideType == GuideType.WaitCloseUI or guideType == GuideType.UnlockBtn or guideType == GuideType.PlantFarm or guideType == GuideType.GetFarm or guideType == GuideType.ClickQuickBuildBtn or guideType == GuideType.ShowBuildRoadAnim or guideType == GuideType.ClickGolloesCanSubmitOrder or guideType == GuideType.ClickRadarBubble or guideType == GuideType.ClickUISpecialBtn or guideType == GuideType.WaitQuestionEnd or guideType == GuideType.ShowFakeHero or guideType == GuideType.AlliancePanelGuide then
      EventManager:GetInstance():Broadcast(EventId.UINoInput, UINoInputType.ShowNoScene)
    else
      EventManager:GetInstance():Broadcast(EventId.UINoInput, UINoInputType.ShowNoUI)
    end
  else
    EventManager:GetInstance():Broadcast(EventId.UINoInput, UINoInputType.Close)
  end
end

local function CheckStopDub(self)
  local template = self:GetCurTemplate()
  if self.dubId ~= nil and (template == nil or template.dub == nil or template.dub == "") then
    DataCenter.LWSoundManager:StopSound(self.dubId)
    self.dubId = nil
    self.dubName = nil
  end
end

local function CheckPlayDub(self)
  local template = self:GetCurTemplate()
  if template ~= nil and template.dub ~= nil and template.dub ~= "" and template.dub ~= self.dubName then
    self:PlayDub(template.dub)
  end
end

local function StopDub(self)
  if self.dubId ~= nil then
    DataCenter.LWSoundManager:StopSound(self.dubId)
    self.dubId = nil
    self.dubName = nil
  end
end

local function PlayDub(self, name)
  if self.dubId ~= nil then
    DataCenter.LWSoundManager:StopSound(self.dubId)
  end
  self.dubName = name
  self.dubId = DataCenter.LWSoundManager:PlayDub(name)
end

local function CheckCanDragGuide(self, inputTilePos, para1)
  local splist = string.split_ss_array(para1, ",")
  if 1 < #splist then
    local tilePos = {}
    local mainPos = BuildingUtils.GetMainPos()
    tilePos.x = mainPos.x + tonumber(splist[1])
    tilePos.y = mainPos.y + tonumber(splist[2])
    local inputTile = {}
    inputTile.x = inputTilePos.x
    inputTile.y = inputTilePos.y
    local list = BuildingUtils.GetAllNeighborsPos(tilePos, 2, 2)
    if list ~= nil and list[tilePos] ~= nil and tilePos.x == inputTile.x and tilePos.y == inputTile.y then
      return true
    end
  end
end

local function CheckTipsWaitTime(self)
  if self.template ~= nil and self.template.tipswaittime > 0 then
    self:AddTipsWaitTimeTimer(self.template.tipswaittime / 1000)
  else
    self:TipsWaitTimeCallBack()
  end
end

local function DeleteTipsWaitTimeTimer(self)
  if self.tipsWaitTimeTimer ~= nil then
    self.tipsWaitTimeTimer:Stop()
    self.tipsWaitTimeTimer = nil
  end
end

local function AddTipsWaitTimeTimer(self, time)
  self:DeleteTipsWaitTimeTimer()
  if self.tipsWaitTimeTimer == nil then
    self.tipsWaitTimeTimer = TimerManager:GetInstance():GetTimer(time, self.tips_wait_time_timer_action, self, true, false, false)
    self.tipsWaitTimeTimer:Start()
  end
end

local function TipsWaitTimeCallBack(self)
  self:DeleteTipsWaitTimeTimer()
  if self.template.tipspic ~= nil and self.template.tipspic ~= "" then
    local param = {}
    param.modelName = self.template.tipspic
    if self.template.tipsdialog ~= nil and self.template.tipsdialog ~= "" then
      param.dialog = Localization:GetString(self.template.tipsdialog)
    end
    if self.template.tipsdirection ~= nil and self.template.tipsdirection ~= "" then
      param.modelPosition = tonumber(self.template.tipsdirection)
    end
    param.isGuide = true
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideHeadTalk) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideHeadTalk, {anim = true, playEffect = false}, param)
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshUIGuideHeadTalk, param)
    end
  end
end

function GuideManager:GetRealAniName(buildname, aniname)
  if buildname ~= "WasteLand_MainBuilding" then
    return ""
  end
  
  local function IsContain(name)
    if self.m_tmpList == nil then
      return false
    end
    for _, v in pairs(self.m_tmpList) do
      if v == name then
        return true
      end
    end
    return false
  end
  
  if aniname == "lv1_show" or aniname == "lv2_show" or aniname == "lv3_show" or aniname == "lv4_show" or aniname == "lv5_show" then
    self.m_tmpList = {}
  end
  if self.m_tmpList == nil then
    self.m_tmpList = {}
  end
  self.m_tmpList[#self.m_tmpList + 1] = aniname
  if aniname == "lv1_car1_show" then
    if IsContain("lv1_car2_show") then
      return "lv1_car2_show"
    else
      return "lv1_car1_show"
    end
  elseif aniname == "lv3_storehouse1_show" then
    if IsContain("lv3_storehouse2_show") then
      return "lv3_storehouse2_show"
    else
      return "lv3_storehouse1_show"
    end
  elseif aniname == "lv4_storehouse1_lv2_show" then
    if IsContain("lv4_storehouse2_lv2_show") then
      return "lv4_storehouse2_lv2_show"
    else
      return "lv4_storehouse1_lv2_show"
    end
  elseif aniname == "lv1_car2_show" then
    if IsContain("lv1_car1_show") then
      return aniname
    else
      return "lv1_car2_show_only"
    end
  elseif aniname == "lv3_storehouse2_show" then
    if IsContain("lv3_storehouse1_show") then
      return aniname
    else
      return "lv3_storehouse2_show_only"
    end
  elseif aniname == "lv4_storehouse2_lv2_show" then
    if IsContain("lv4_storehouse1_lv2_show") then
      return aniname
    else
      return "lv4_storehouse2_lv2_show_only"
    end
  else
    return ""
  end
end

local function CallBackDoGuide(self)
  self:CheckNoInput()
  self:CheckPlayDub()
  if self.template == nil then
    return
  end
  if self.template.type == GuideType.ShowTalk then
    local param = {}
    param.time = self.template:GetAutoDoNextTime() / 1000
    if self.template.para2 ~= nil then
      local spl = string.split_ss_array(self.template.para2, ",")
      if 3 < #spl then
        local spl2 = string.split_ss_array(spl[1], ";")
        local spl2Count = table.count(spl2)
        if 1 < spl2Count then
          local list = {}
          for i = 2, spl2Count do
            local dialogType = tonumber(spl2[i])
            if dialogType == GuideTalkDialogType.AllianceName then
              local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
              if allianceData ~= nil then
                table.insert(list, allianceData.allianceName)
              end
            end
          end
          param.dialog = Localization:GetString(spl2[1], table.unpack(list))
        else
          param.dialog = Localization:GetString(spl[1])
        end
        param.modelName = spl[2]
        param.modelAction = spl[3]
        param.modelPosition = tonumber(spl[4])
      end
    end
    local list = string.split_ss_array(self.template.para4, ";")
    if list ~= nil then
      param.cellParam = {}
      for k, v in ipairs(list) do
        local spl = string.split_ss_array(v, ",")
        if spl ~= nil and 1 < table.count(spl) then
          local param1 = {}
          param1.des = Localization:GetString(spl[1])
          param1.nextId = tonumber(spl[2])
          table.insert(param.cellParam, param1)
        end
      end
    end
    if self.template.para3 ~= nil or self.template.para3 ~= "" then
      param.canCloseTime = tonumber(self.template.para3) / 1000
    end
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideTalk) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideTalk, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide,
        playEffect = false
      }, param)
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
    end
  elseif self:IsGuideArrowType() then
    local param = {}
    param.guideType = self.template.type
    param.obj = self.obj
    param.objPositionType = self.objPositionType
    param.objWorldPos = self.objWorldPos
    param.forceType = self.template.forcetype
    param.arrowType = self.template.arrowtype
    param.showCircleType = self.template.showcircletype
    param.arrowDirection = self.template.arrowdirection
    param.animSpeed = self.template.para5 == "" and 1 or tonumber(self.template.para5)
    param.useGuide = true
    if self.template.type == GuideType.ClickBuildFinishBox or self.template.type == GuideType.ClickBuild then
      if self.template.para1 ~= nil and self.template.para1 ~= "" then
        local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(tonumber(self.template.para1))
        if template ~= nil then
          param.buildTile = template.tileX
        end
      end
    elseif self.template.type == GuideType.ClickQuickBuildBtn then
      param.noAddClick = true
    end
    if self.template.para3 ~= nil and self.template.para3 ~= "" then
      local spl = string.split_ff_array(self.template.para3, ",")
      if 2 <= #spl then
        param.fingerOffset = Vector3.New(spl[1], spl[2], 0)
      end
    end
    param.moveCamera = self.template.type == GuideType.ClickBuildFinishBox
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideArrow) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideArrow, {anim = false, playEffect = false}, param)
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
    end
  elseif self.template.type == GuideType.BuildRoad or self.template.type == GuideType.PlantFarm or self.template.type == GuideType.GetFarm or self.template.type == GuideType.PlantAnimal or self.template.type == GuideType.Factory or self.template.type == GuideType.DragCityTroop then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideMoveArrow) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideMoveArrow, {anim = false, playEffect = false}, self.needParam)
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, self.needParam)
    end
  elseif self.template.type == GuideType.PlayMovie then
    if self.template.para5 ~= nil and self.template.para5 ~= "" then
      local param = {}
      param.gotoGuideId = tonumber(self.template.para5)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITimelineJump, {anim = false, playEffect = false}, param)
    end
    if self.template.para1 ~= nil then
      local movieType = tonumber(self.template.para1)
      if movieType == GuidePlayMovieType.Farm then
        DataCenter.GuideCityManager:PlayTimeline()
      elseif movieType == GuidePlayMovieType.Radar then
        self:DoNext()
      elseif movieType == GuidePlayMovieType.Wind then
        self:DoNext()
      elseif movieType == GuidePlayMovieType.SavePeople then
        CS.SceneManager.World:SetTouchInputControllerEnable(false)
        if self.template.para2 ~= nil then
          local spl = string.split_ss_array(self.template.para2, ",")
          if 1 < table.count(spl) then
            local vec = {}
            vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
            vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
            local pointId = SceneUtils.TilePosToIndex(vec)
            DataCenter.GuideCityAnimManager:LoadSavePeopleScene(pointId)
          end
        end
      elseif movieType == GuidePlayMovieType.FightGetPeople then
        self:DoNext()
        EventManager:GetInstance():Broadcast(EventId.CameraFollowCityTroop, false)
      elseif movieType == GuidePlayMovieType.GameStartRocketFall then
        DataCenter.GuideCityAnimManager:LoadScene()
        EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
      elseif movieType == GuidePlayMovieType.ShowSandMonster then
        self:DoNext()
        EventManager:GetInstance():Broadcast(EventId.CameraFollowCityTroop, false)
      elseif movieType == GuidePlayMovieType.BaseZeroUpgrade then
        self:SetCanShowBuild(false)
        if self.template.para2 ~= nil then
          local spl = string.split_ss_array(self.template.para2, ",")
          if 1 < table.count(spl) then
            local vec = {}
            vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
            vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
            DataCenter.BuildZeroUpgradeEffectManager:ShowShowEffect(SceneUtils.TileToWorld(vec))
          end
        end
      elseif movieType == GuidePlayMovieType.ShowOstrichAnim then
        if self.template.para3 ~= nil then
          local getUuid = 0
          local list = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.OstrichBarn)
          if list ~= nil then
            table.walksort(list, function(leftKey, rightKey)
              return list[leftKey].qid < list[rightKey].qid
            end, function(k, v)
              if v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Free and getUuid == 0 then
                getUuid = v.uuid
              end
            end)
          end
          if getUuid ~= 0 then
            DataCenter.GuideCityAnimManager:LoadShowOstrichScene(getUuid, tonumber(self.template.para3))
          end
        end
      elseif movieType == GuidePlayMovieType.MoveToWorld then
        if CS.SceneManager:IsInCity() then
          GoToUtil.CloseAllWindows()
          if 0 > LuaEntry.Player:GetMainWorldPos() then
            SFSNetwork.SendMessage(MsgDefines.MoveCityToWorld)
          end
          self:DoNext()
        else
          self:DoNext()
        end
      elseif movieType == GuidePlayMovieType.ShowGarbage then
        DataCenter.AirDropGarbageManager:LoadShowGarbageScene()
      elseif movieType == GuidePlayMovieType.FarmWithoutTimeLine then
        local sfsParam = {}
        sfsParam.queueList = {}
        local list = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Field)
        for k, v in pairs(list) do
          table.insert(sfsParam.queueList, k)
        end
        SFSNetwork.SendMessage(MsgDefines.FreeSpeedQueue, sfsParam)
        self:DoNext()
      elseif movieType == GuidePlayMovieType.BusinessPlaneArrive then
        DataCenter.GuideCityAnimManager:LoadBusinessPlaneArriveScene()
      elseif movieType == GuidePlayMovieType.ShowBusinessBubble then
        DataCenter.ResidentOrderDataManager:CheckRefreshOrder()
        DataCenter.GuideManager:SendSaveGuideMessage(SaveNoShowBusinessBubble, "")
        DataCenter.ResidentOrderDataManager:DoWhenBubbleGuideFinish()
        DataCenter.GuideManager:DoNext()
      elseif movieType == GuidePlayMovieType.ShowMigrateScene then
        local hideLockLandList
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          hideLockLandList = string.split_ii_array(self.template.para2, ",")
        end
        DataCenter.GuideCityAnimManager:LoadMigrateScene(hideLockLandList)
      elseif movieType == GuidePlayMovieType.ShowRobotScene then
        DataCenter.GuideCityAnimManager:LoadShowRobotScene()
      elseif movieType == GuidePlayMovieType.ShowBaseLight then
        if not CitySpaceMan:GetInstance():IsNeedCreate() then
          CitySpaceMan:GetInstance():Destroy()
        end
        DataCenter.GuideManager:DoNext()
      elseif movieType == GuidePlayMovieType.ShowChangeFarm then
        DataCenter.GuideManager:DoNext()
      elseif movieType == GuidePlayMovieType.FromMjBuildMainBuild then
        DataCenter.GuideCityAnimManager:LoadFromMjBuildMainBuildScene()
      elseif movieType == GuidePlayMovieType.MainZeroUpgradeScene then
        if DataCenter.BuildManager.MainLv == 0 then
          CS.BuildMainCityMessage.Instance:Send()
        end
        DataCenter.GuideCityAnimManager:LoadMainZeroUpgradeScene()
      elseif movieType == GuidePlayMovieType.SecondMigrateScene then
        local hideLockLandList
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          hideLockLandList = string.split_ii_array(self.template.para2, ",")
        end
        DataCenter.GuideCityAnimManager:LoadSecondMigrateScene(hideLockLandList)
      elseif movieType == GuidePlayMovieType.TilePlaneRuin then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          DataCenter.GuideCityAnimManager:LoadTilePlaneRuin(tonumber(self.template.para2))
        end
      elseif movieType == GuidePlayMovieType.SaveBobScene then
        local pos
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local spl = string.split_ii_array(self.template.para2, ",")
          if 1 < table.count(spl) then
            local vec = {}
            vec.x = spl[1]
            vec.y = spl[2]
            pos = SceneUtils.TileToWorld(vec)
          end
        end
        if pos ~= nil and self.template.para3 ~= nil and self.template.para3 ~= "" then
          DataCenter.BattleLevel:LoadSaveBobScene(pos, tonumber(self.template.para3))
        else
          DataCenter.GuideManager:DoNext()
        end
      elseif movieType == GuidePlayMovieType.PirateFightBobScene then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          DataCenter.GuideCityAnimManager:LoadPirateFightBobScene(tonumber(self.template.para2))
        end
      elseif movieType == GuidePlayMovieType.PirateComeScene then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          DataCenter.GuideCityAnimManager:LoadPirateComeScene(tonumber(self.template.para2))
        end
      elseif movieType == GuidePlayMovieType.PirateAwayScene then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          DataCenter.GuideCityAnimManager:LoadPirateAwayScene(tonumber(self.template.para2))
        end
      elseif movieType == GuidePlayMovieType.PirateShowScene then
        DataCenter.BattleLevel:LoadPirateShowScene()
      elseif movieType == GuidePlayMovieType.RadarScanScene then
        DataCenter.GuideCityAnimManager:LoadRadarScanScene()
      elseif movieType == GuidePlayMovieType.ShowFakePlayerFlag then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local showFakePlayerFlagType = tonumber(self.template.para2)
          if showFakePlayerFlagType == ShowFakePlayerFlagType.Show then
            local pos = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos())
            DataCenter.GuideCityAnimManager:LoadShowFakePlayerFlagScene(pos)
          else
            DataCenter.GuideCityAnimManager:RemoveShowFakePlayerFlagScene()
          end
        end
      elseif movieType == GuidePlayMovieType.ShowRadarBubble then
        self:SendSaveGuideMessage(GuideNoShowRadarBubble, "")
        EventManager:GetInstance():Broadcast(EventId.DetectInfoChange)
        self:DoNext()
      elseif movieType == GuidePlayMovieType.ShowWorldCollectPoint then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local showType = tonumber(self.template.para2)
          if showType == ShowWorldCollectPointType.Show then
            self:SendSaveGuideMessage(GuideNoShowCollectPoint, "")
            local list = CS.SceneManager.World:GetGarbagePoint()
            if list ~= nil and 0 < list.Count then
              for i = 0, list.Count - 1 do
                CS.SceneManager.World:ShowObject(list[i])
              end
            end
          elseif showType == ShowWorldCollectPointType.Hide then
            self:SendSaveGuideMessage(GuideNoShowCollectPoint, SaveGuideDoneValue)
            local list = CS.SceneManager.World:GetGarbagePoint()
            if list ~= nil and 0 < list.Count then
              for i = 0, list.Count - 1 do
                CS.SceneManager.World:HideObject(list[i])
              end
            end
          end
        end
        self:DoNext()
      elseif movieType == GuidePlayMovieType.RadarWorldScanScene then
        DataCenter.GuideCityAnimManager:LoadRadarWorldScanScene()
        DataCenter.GuideManager:DoNext()
      elseif movieType == GuidePlayMovieType.PickUpWeaponScene then
        self:SendSaveGuideMessage(PrologueNoAttack, "")
        DataCenter.GuideCityAnimManager:LoadPickUpWeaponScene()
      elseif movieType == GuidePlayMovieType.TankScene then
        local param = {}
        local showType = tonumber(self.template.para2)
        if showType == TankShowType.Show then
          param.nextType = GuideNpcDoNextType.WaitWalk
          param.follow = true
          if self.template.para3 ~= nil and self.template.para3 ~= "" then
            param.posArr = {}
            local spl1 = string.split_ss_array(self.template.para3, ";")
            for k, v in ipairs(spl1) do
              local spl2 = string.split_ii_array(v, ",")
              if 1 < table.count(spl2) then
                local vec = {}
                vec.x = DataCenter.BuildManager.main_city_pos.x + spl2[1]
                vec.y = DataCenter.BuildManager.main_city_pos.y + spl2[2]
                table.insert(param.posArr, vec)
              end
            end
          end
          if self.template.para4 ~= nil and self.template.para4 ~= "" then
            param.angle = tonumber(self.template.para4)
          end
          if self.template.para5 ~= nil and self.template.para5 ~= "" then
            param.showEffect = true
          end
          if param.posArr ~= nil then
            local count = table.count(param.posArr)
            param.saveParam = param.posArr[count].x .. "," .. param.posArr[count].y
            if param.angle ~= nil then
              param.saveParam = param.saveParam .. "," .. param.angle
            end
          end
        elseif showType == TankShowType.Back then
          param.nextType = GuideNpcDoNextType.WaitWalkDelete
          param.posArr = {}
          local startPos
          local model = DataCenter.GuideNeedLoadManager:GetModel(GuideAnimObjectType.ShowTankScene)
          if model ~= nil then
            startPos = SceneUtils.WorldToTile(model:GetPosition())
            table.insert(param.posArr, startPos)
          end
          local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_TRAINFIELD_1)
          if buildData ~= nil and startPos ~= nil then
            local endPos = SceneUtils.WorldToTile(buildData:GetCenterVec())
            table.insert(param.posArr, endPos)
          end
        end
        if 0 < table.count(param.posArr) then
          DataCenter.GuideNeedLoadManager:LoadTankScene(param)
        end
        if param.nextType == GuideNpcDoNextType.Auto or param.nextType == GuideNpcDoNextType.WaitWalkDelete then
          self:DoNext()
        end
      elseif movieType == GuidePlayMovieType.FactoryShowFreeBtn then
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PvePirateBoomScene then
        DataCenter.BattleLevel.timelineMgr:LoadPvePirateBoomScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.ShowRadarMonsterScene then
        local info = DataCenter.RadarCenterDataManager:GetOneInfoByEventTypeAndState(tonumber(self.template.para2), tonumber(self.template.para3))
        if info ~= nil then
          DataCenter.GuideCityAnimManager:LoadShowRadarMonsterScene(info)
        end
        DataCenter.GuideManager:DoNext()
      elseif movieType == GuidePlayMovieType.PveThreeBombs then
        DataCenter.BattleLevel.timelineMgr:LoadPveThreeBombsScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveDestroyHdc1 then
        DataCenter.BattleLevel.timelineMgr:LoadPveDestroyHdc1Scene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveDestroyHdc2 then
        DataCenter.BattleLevel.timelineMgr:LoadPveDestroyHdc2Scene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveDestroyHdc3 then
        DataCenter.BattleLevel.timelineMgr:LoadPveDestroyHdc3Scene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveMissileAttackMain then
        DataCenter.BattleLevel.timelineMgr:LoadPveMissileAttackMainScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveHdc1Attack then
        DataCenter.BattleLevel.timelineMgr:LoadPveHdc1AttackScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveHdc2Attack then
        DataCenter.BattleLevel.timelineMgr:LoadPveHdc2AttackScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveTurretTurn then
        DataCenter.BattleLevel.timelineMgr:LoadPveTurretTurnScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveDestroyMountain then
        DataCenter.BattleLevel.timelineMgr:LoadPveDestroyMountainScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveHdc3Attack then
        DataCenter.BattleLevel.timelineMgr:LoadPveHdc3AttackScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveMissileInSky then
        if tonumber(self.template.para3) == 1 then
          DataCenter.BattleLevel.timelineMgr:LoadPveMissileInSkyScene(self.template.para2)
        else
          DataCenter.BattleLevel.timelineMgr:DestroyOneScene(GuideAnimObjectType.PveMissileInSky)
        end
        self:DoNext()
      elseif movieType == GuidePlayMovieType.GuluOutFromBaseScene then
        local param = {}
        if self.template.para3 ~= nil and self.template.para3 ~= "" then
          local spl = string.split_ff_array(self.template.para3, ",")
          if 1 < table.count(spl) then
            param.pos = SceneUtils.TileToWorld({
              x = DataCenter.BuildManager.main_city_pos.x + spl[1],
              y = DataCenter.BuildManager.main_city_pos.y + spl[2]
            })
          end
        end
        DataCenter.GuideCityAnimManager:LoadGuluOutFromBaseScene(param)
        self:DoNext()
      elseif movieType == GuidePlayMovieType.GuideTimeline2Scene then
        local pos
        if self.template.para3 ~= nil and self.template.para3 ~= "" then
          local spl = string.split_ff_array(self.template.para3, ",")
          if 1 < table.count(spl) then
            local vec = {}
            vec.x = spl[1]
            vec.y = spl[2]
            pos = SceneUtils.TileToWorld(vec)
          end
        end
        local hideTriggerList
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          hideTriggerList = string.split_ii_array(self.template.para2, ";")
        end
        DataCenter.BattleLevel.timelineMgr:LoadGuideTimeline2Scene(pos, hideTriggerList)
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveMorganAttack then
        DataCenter.BattleLevel.timelineMgr:LoadPveMorganAttackScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveHdcEscape then
        DataCenter.BattleLevel.timelineMgr:LoadPveHdcEscapeScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.DefendWallScene then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local visible = tonumber(self.template.para2)
          if visible == GuideSetNormalVisible.Show then
            local param = {}
            param.pos = SceneUtils.TileToWorld({
              x = DataCenter.BuildManager.main_city_pos.x,
              y = DataCenter.BuildManager.main_city_pos.y
            })
            DataCenter.GuideCityAnimManager:LoadDefendWallScene(param)
          elseif visible == GuideSetNormalVisible.Hide then
            DataCenter.GuideCityAnimManager:RemoveDefendWallScene()
          end
        end
        self:DoNext()
      elseif movieType == GuidePlayMovieType.ShowEnemyAllianceCityEffect then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local visible = tonumber(self.template.para2)
          if visible == GuideSetNormalVisible.Show then
            if CS.SceneManager.World.GetMainByScreen ~= nil then
              TimerManager:GetInstance():DelayInvoke(function()
                local list = CS.SceneManager.World:GetMainByScreen()
                local id = DataCenter.AllianceCompeteDataManager:GetFightAllianceId()
                if id == "" then
                  id = 0
                end
                local showList = {}
                if 0 < list.Count then
                  for i = 0, list.Count - 1 do
                    if list[i].allianceId == id then
                      local param = {}
                      param.pointId = list[i].pointIndex
                      table.insert(showList, param)
                    end
                  end
                  if next(showList) then
                    local enemy = true
                    DataCenter.GuideAllianceMemberEffectManager:ShowAllianceMemberEffect(showList, nil, enemy)
                  end
                else
                  self:DoNext()
                end
              end, 1)
            end
          elseif visible == GuideSetNormalVisible.Hide then
            DataCenter.GuideAllianceMemberEffectManager:RemoveAll()
          end
        end
        self:DoNext()
      elseif movieType == GuidePlayMovieType.GuideTimeline3Scene then
        local pos
        if self.template.para3 ~= nil and self.template.para3 ~= "" then
          local spl = string.split_ff_array(self.template.para3, ",")
          if table.count(spl) > 1 then
            local vec = {}
            vec.x = spl[1]
            vec.y = spl[2]
            pos = SceneUtils.TileToWorld(vec)
          end
        end
        DataCenter.BattleLevel.timelineMgr:LoadGuideTimeline3Scene(pos)
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveHdcEscape31014 then
        DataCenter.BattleLevel.timelineMgr:LoadPveHdcEscape31014Scene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.ConnectElectricityScene then
        DataCenter.GuideCityAnimManager:LoadConnectElectricityScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.Chapter2CameraMoveScene then
        DataCenter.GuideCityAnimManager:LoadChapter2CameraMoveScene()
        self:DoNext()
      end
    end
  elseif self.template.type == GuideType.WaitMovieComplete then
    DataCenter.GuideCityManager:SetTimeLineContinuePlay()
    DataCenter.GuideCityAnimManager:SetTimeLineContinuePlay(true)
  elseif self.template.type == GuideType.CityGarbageResultShow then
    if self.template.para1 ~= nil then
      local showType = tonumber(self.template.para1)
      if showType == CityGarbageResultShowType.People and not self:IsDoneThisGuide(self.template.id) then
        self:SaveCityTroopPeopleNum(self:GetCityTroopPeopleNum() + 1)
        EventManager:GetInstance():Broadcast(EventId.RefreshCityTroopPeopleNum)
      end
      if showType == CityGarbageResultShowType.NoUseItem then
        self:DoNext()
      else
        self:DoNext()
      end
    end
  elseif self.template.type == GuideType.WaitMessageFinish then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local waitType = tonumber(self.template.para1)
      if self.waitingMessage[waitType] then
        self:AddWaitLongDelayTimer(WaitMessageLongTime)
      else
        self:DoNext()
      end
    end
  elseif self.template.type == GuideType.ShowBlackUI then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIShowBlack) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIShowBlack, {anim = true, playEffect = false})
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim)
    end
  elseif self.template.type == GuideType.MoveCamera then
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    if isInBattle then
      DataCenter.BattleLevel:SetFollowNpc()
    else
      DataCenter.CityNpcManager:SetFollowNpc()
    end
    local pos
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local moveType = tonumber(self.template.para1)
      if moveType == GuideMoveCameraType.Point then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local spl = string.split_ii_array(self.template.para2, ",")
          if table.count(spl) > 1 then
            local vec = {}
            if isInBattle then
              vec.x = spl[1]
              vec.y = spl[2]
            else
              vec.x = DataCenter.BuildManager.main_city_pos.x + spl[1]
              vec.y = DataCenter.BuildManager.main_city_pos.y + spl[2]
            end
            pos = SceneUtils.TileToWorld(vec)
          end
        end
      elseif moveType == GuideMoveCameraType.Build then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local buildData = DataCenter.BuildManager:GetFunbuildByItemID(tonumber(self.template.para2))
          if buildData ~= nil then
            pos = buildData:GetCenterVec()
          end
        end
      elseif moveType == GuideMoveCameraType.CityTroop then
        local cityTroop = CS.SceneManager.World:GetCityTroop()
        if cityTroop ~= nil then
          pos = cityTroop.transform.position
        end
      elseif moveType == GuideMoveCameraType.AllianceChief then
        if LuaEntry.Player:IsInAlliance() then
          local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
          if baseData ~= nil and baseData.leaderUid and not baseData:CheckIfIsVirtualLeader() then
            local leaderData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(baseData.leaderUid)
            if leaderData ~= nil and leaderData.pointId ~= 0 then
              pos = SceneUtils.TileIndexToWorld(leaderData.pointId)
            end
          end
        end
        if pos == nil or pos.x == 0 and pos.y == 0 and pos.z == 0 then
          local temp = self:GetSaveGuideValue(AllianceBornPoint)
          if temp ~= nil then
            pos = SceneUtils.TileIndexToWorld(tonumber(temp))
          end
        end
      elseif moveType == GuideMoveCameraType.AllianceMember then
        if LuaEntry.Player:IsInAlliance() then
          local member = DataCenter.AllianceMemberDataManager:GetNearMember()
          if member ~= nil then
            pos = SceneUtils.TileIndexToWorld(member.pointId)
          end
        end
        if pos == nil or pos.x == 0 and pos.y == 0 and pos.z == 0 then
          local temp = self:GetSaveGuideValue(AllianceBornPoint)
          if temp ~= nil then
            pos = SceneUtils.TileIndexToWorld(tonumber(temp))
          end
        end
      elseif moveType == GuideMoveCameraType.NewbieSpaceMan then
        if isInBattle then
          pos = DataCenter.BattleLevel:GetPosition()
        else
          pos = CitySpaceMan:GetInstance():GetPosition()
        end
      elseif moveType == GuideMoveCameraType.Npc then
        if isInBattle then
          pos = DataCenter.BattleLevel:GetNpcPositionByName(self.template.para2)
        else
          pos = DataCenter.CityNpcManager:GetNpcPositionByName(self.template.para2)
        end
      elseif moveType == GuideMoveCameraType.FollowNpc then
        if isInBattle then
          DataCenter.BattleLevel:SetFollowNpc(self.template.para2)
        else
          DataCenter.CityNpcManager:SetFollowNpc(self.template.para2)
        end
      elseif moveType == GuideMoveCameraType.CollectResource then
        if tonumber(self.template.para2) >= ResourceType.ResourceItem then
          SFSNetwork.SendMessage(MsgDefines.FindResourcePoint, ResourceType.ResourceItem, 0, self.template.para2)
        else
          SFSNetwork.SendMessage(MsgDefines.FindResourcePoint, tonumber(self.template.para2), 0)
        end
      elseif moveType == GuideMoveCameraType.Garbage then
        local list = CS.SceneManager.World:GetGarbagePoint()
        if list ~= nil and list.Count > 0 then
          for i = 0, list.Count - 1 do
            local pointId = list[i]
            local obj = CS.SceneManager.World:GetObjectByPoint(pointId)
            if obj ~= nil then
              pos = SceneUtils.TileIndexToWorld(pointId)
              break
            end
          end
        end
      elseif moveType == GuideMoveCameraType.MonsterReward then
        local list
        if CS.SceneManager:IsInCity() then
          list = DataCenter.CityPointDataManager:GetPointDataListByType(CityPointType.MonsterReward)
        else
          list = DataCenter.CollectRewardDataManager:GetRewardListBySort()
        end
        if list ~= nil or table.count(list) > 0 then
          local curTime = UITimeManager:GetInstance():GetServerTime()
          for k, v in ipairs(list) do
            if curTime <= v.expireTime then
              pos = SceneUtils.TileIndexToWorld(v.pointId)
              break
            end
          end
        end
      elseif moveType == GuideMoveCameraType.RadarMonster then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local spl = string.split_ii_array(self.template.para2, ";")
          if table.count(spl) > 1 then
            local info = DataCenter.RadarCenterDataManager:GetOneInfoByEventTypeAndState(spl[1], spl[2])
            if info ~= nil then
              pos = SceneUtils.TileIndexToWorld(info.pointId)
            end
          end
        end
      elseif moveType == GuideMoveCameraType.WorldCity then
        pos = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos())
      elseif moveType == GuideMoveCameraType.LandLock and self.template.para2 ~= nil and self.template.para2 ~= "" then
        local landLockId = tonumber(self.template.para2)
        local info = DataCenter.LandLockManager:GetLandLockDataById(landLockId)
        if info ~= nil then
          pos = info:GetCenterWorldPos()
        end
      end
    end
    local time = LookAtFocusTime
    if self.template.para4 ~= nil and self.template.para4 ~= "" then
      time = tonumber(self.template.para4) / 1000
    end
    if isInBattle then
      local zoom = DataCenter.BattleLevel:GetCameraZoom()
      if self.template.para3 ~= nil and self.template.para3 ~= "" then
        zoom = tonumber(self.template.para3)
        if DataCenter.CityPioneerManager:IsBeforePrologue() then
          CS.GameEntry.Setting:SetPrivateFloat(SettingKeys.DigCameraHeightSnap, zoom)
        end
        DataCenter.BattleLevel:SetGuideMaxHeight(zoom)
      end
      local nowPos = DataCenter.BattleLevel:GetCameraTarget()
      if zoom ~= nil then
        if pos == nil or pos.x == nowPos.x and pos.z == nowPos.z then
          DataCenter.BattleLevel:AutoZoom(zoom, time)
        else
          DataCenter.BattleLevel:AutoLookat(pos, zoom, time)
        end
      end
    else
      local zoom = CS.SceneManager.World.Zoom
      if self.template.para3 ~= nil and self.template.para3 ~= "" then
        zoom = tonumber(self.template.para3)
        if DataCenter.CityPioneerManager:IsBeforePrologue() then
          CS.GameEntry.Setting:SetPrivateFloat(SettingKeys.DigCameraHeightSnap, zoom)
        end
        CS.SceneManager.World:SetCameraMaxHeight(zoom)
      end
      local nowPos = CS.SceneManager.World.CurTarget
      if pos == nil or pos.x == nowPos.x and pos.z == nowPos.z then
        CS.SceneManager.World:AutoZoom(zoom, time)
      else
        GoToUtil.GotoPos(pos, zoom, time)
      end
    end
    local showUIMainType = GuideCameraShowUIMainType.None
    if self.template.para5 ~= nil and self.template.para5 ~= "" and not isInBattle then
      showUIMainType = tonumber(self.template.para5)
    end
    TimerManager:GetInstance():DelayInvoke(function()
      if self.template ~= nil and self.template.type == GuideType.MoveCamera then
        if showUIMainType == GuideCameraShowUIMainType.Hide then
          EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
        elseif showUIMainType == GuideCameraShowUIMainType.Show then
          EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
        end
        self:DoNext()
      end
    end, time + GuideMovieCameraTimeDelta)
  elseif self.template.type == GuideType.CloseAllUI then
    GoToUtil.CloseAllWindows()
    if not DataCenter.BattleLevel:IsInBattleLevel() then
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
    end
    self:DoNext()
  elseif self.template.type == GuideType.ShowUIGuideGrow then
  elseif self.template.type == GuideType.SetRecommendShow then
    local showType = 0
    local showPara = 0
    local buildId = 0
    local buildUuid = 0
    local guideId = 0
    local showHeadPara = {}
    local focusPos
    local waitAnimType = UIGuideMoveArrowNeedWaitType.No
    if self.template.para1 ~= nil then
      local spl = string.split_ii_array(self.template.para1, ";")
      local splCount = table.count(spl)
      if splCount > 0 then
        showType = spl[1]
      end
      if splCount > 1 then
        showPara = spl[2]
      end
    end
    if self.template.para2 ~= nil then
      waitAnimType = tonumber(self.template.para2)
    end
    local uuidList = {}
    if self.template.para3 ~= nil then
      local spl = string.split_ss_array(self.template.para3, ";")
      if #spl >= 1 then
        buildId = tonumber(spl[1])
        if spl[2] ~= nil and spl[2] ~= "" then
          local spl2 = string.split_ss_array(spl[2], "|")
          for k, v in ipairs(spl2) do
            local spl1 = string.split_ss_array(v, ",")
            if table.count(spl1) > 1 then
              local vec = {}
              vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl1[1])
              vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl1[2])
              local pointId = SceneUtils.TilePosToIndex(vec)
              local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId)
              if buildData ~= nil and buildData.itemId == buildId then
                if buildUuid == 0 then
                  buildUuid = buildData.uuid
                end
                if (showType == RecommendShowType.FarmPlant or showType == RecommendShowType.FarmGet) and k == 2 then
                  focusPos = SceneUtils.TileToWorld(vec)
                end
                table.insert(uuidList, buildData.uuid)
              end
            end
          end
        end
      end
    end
    if buildUuid == 0 and buildId ~= 0 then
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
      if list ~= nil and table.count(list) > 0 then
        buildUuid = list[1].uuid
        table.insert(uuidList, buildUuid)
      end
    end
    if self.template.para4 ~= nil then
      guideId = tonumber(self.template.para4)
    end
    if self.template.para5 ~= nil and self.template.para5 ~= "" then
      local spl = string.split_ss_array(self.template.para5, "|")
      for k, v in ipairs(spl) do
        local spl1 = string.split_ss_array(v, ",")
        if 4 <= table.count(spl1) then
          local temp = {}
          temp.dialog = spl1[2]
          temp.modelName = spl1[3]
          temp.modelPosition = tonumber(spl1[4])
          showHeadPara[tonumber(spl1[1])] = temp
        end
      end
    end
    DataCenter.RecommendShowManager:AddOneParam(showType, showPara, buildId, buildUuid, guideId, uuidList, showHeadPara, focusPos, self.template.arrowtype, false, waitAnimType)
    self:DoNext()
  elseif self.template.type == GuideType.UnlockBtn then
    if not string.IsNullOrEmpty(self.template.para1) then
      local unlockType = tonumber(self.template.para1)
      if not string.IsNullOrEmpty(self.template.para2) then
        local spl = string.split_ss_array(self.template.para2, ",")
        local title = #spl >= 1 and Localization:GetString(spl[1]) or ""
        local intro = 2 <= #spl and Localization:GetString(spl[2]) or ""
        DataCenter.UnlockBtnManager:StartUnlockBtn(title, intro, unlockType)
      else
        self:DoNext()
        EventManager:GetInstance():Broadcast(EventId.ShowUnlockBtn, unlockType)
      end
    end
  elseif self.template.type == GuideType.ShowTroopTalk then
  elseif self.template.type == GuideType.ShowGuideTip then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideTip) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideTip, {anim = true, playEffect = false})
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim)
    end
  elseif self.template.type == GuideType.PlayEffectSound then
    self:DoNext()
  elseif self.template.type == GuideType.ShowChapterAnim then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local list = string.split_ss_array(self.template.para1, ";")
      if 3 < table.count(list) then
        local param = {}
        param.chapterId = tonumber(list[1])
        param.bgName = list[2]
        param.titleDes = Localization:GetString(list[3])
        param.des = Localization:GetString(list[4])
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          param.autoDoNext = tonumber(self.template.para2) / 1000
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIRocketFailedLanding, {anim = true, playEffect = false}, param)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIChapterSwitch, {anim = true, playEffect = false}, tonumber(list[1]))
      end
    else
      self:DoNext()
    end
  elseif self.template.type == GuideType.StopAllEffectSound then
    self:StopAllEffectSound()
    self:DoNext()
  elseif self.template.type == GuideType.DoUIMainAnim then
    if self.template.para1 ~= nil then
      local showUIMainType = tonumber(self.template.para1)
      if DataCenter.BattleLevel:IsInBattleLevel() then
        EventManager:GetInstance():Broadcast(EventId.RefreshUIPveMainVisible, showUIMainType)
      elseif showUIMainType == GuideUIMainShowType.Hide then
        self:SetNoShowUIMain(true)
      elseif showUIMainType == GuideUIMainShowType.Show then
        self:SetNoShowUIMain(false)
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.PrologueShowNpc then
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    local nextType = GuideNpcDoNextType.Auto
    if self.template.para3 ~= nil and self.template.para3 ~= "" then
      nextType = tonumber(self.template.para3)
    end
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local posArr = {}
      local spl1 = string.split_ss_array(self.template.para1, ";")
      for k, v in ipairs(spl1) do
        local spl2 = string.split_ii_array(v, ",")
        if table.count(spl2) > 1 then
          local vec = {}
          if isInBattle then
            vec.x = spl2[1]
            vec.y = spl2[2]
          else
            vec.x = DataCenter.BuildManager.main_city_pos.x + spl2[1]
            vec.y = DataCenter.BuildManager.main_city_pos.y + spl2[2]
          end
          table.insert(posArr, vec)
        end
      end
      if isInBattle then
        local param = {}
        param.modelName = self.template.para2
        param.posArr = posArr
        param.animName = self.template.para4
        param.angle = tonumber(self.template.para5)
        param.nextType = nextType
        DataCenter.BattleLevel:AddOneNpc(param)
      else
        DataCenter.CityNpcManager:AddOneNpc(self.template.para2, posArr, self.template.para4, tonumber(self.template.para5), nextType)
        CityPioneerArchive:GetInstance():Save()
      end
    end
    if nextType == GuideNpcDoNextType.Auto or nextType == GuideNpcDoNextType.WaitWalkDelete then
      self:DoNext()
    end
  elseif self.template.type == GuideType.PrologueHideNpc then
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    if isInBattle then
      DataCenter.BattleLevel:RemoveOneNpc(self.template.para2)
    else
      DataCenter.CityNpcManager:RemoveOneNpc(self.template.para2)
      CityPioneerArchive:GetInstance():Save()
    end
    self:DoNext()
  elseif self.template.type == GuideType.Wastelan_ShowFarm then
    if not string.IsNullOrEmpty(self.template.para1) then
      WastelandFarmManager:GetInstance():AddFarm(self.template.para1, self.template.para2)
    end
    self:DoNext()
  elseif self.template.type == GuideType.Wasteland_ShowTank then
    WastelandModelMgr:GetInstance():CreateTank(self.template.para1, self.template.para2)
    self:DoNext()
  elseif self.template.type == GuideType.Wasteland_ShowMonster then
    WastelandModelMgr:GetInstance():CreateMonster(self.template.para1, self.template.para2)
    self:DoNext()
  elseif self.template.type == GuideType.Wasteland_AttackDone then
    WastelandModelMgr:GetInstance():AttackFinishCurRound()
    self:DoNext()
  elseif self.template.type == GuideType.PrologueShowBuild then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local spl1 = string.split_ss_array(self.template.para1, ",")
      if table.count(spl1) > 1 then
        local vec = {}
        vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl1[1])
        vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl1[2])
        local pointId = SceneUtils.TilePosToIndex(vec)
        local buildname = self.template.para2
        local animation_name = self.template.para4
        local build = DataCenter.CityPrologueBuildManager:AddOneBuild(pointId, buildname, animation_name)
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.PrologueUnlockFog then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local spl1 = string.split_ii_array(self.template.para1, ",")
      CityPioneerFog:GetInstance():UnlockFog(spl1)
    end
    self:DoNext()
  elseif self.template.type == GuideType.PrologueShowTrigger then
    if self.template.para2 ~= nil and self.template.para2 ~= "" then
      local spl1 = string.split_ii_array(self.template.para2, ",")
      for k, v in ipairs(spl1) do
        DataCenter.CityTriggerPointDataManager:AddOneTrigger(v)
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.PrologueShowNoMovePoint then
    if self.template.para1 ~= nil and self.template.para1 ~= nil then
      local spl = string.split_ss_array(self.template.para1, "|")
      for k, v in ipairs(spl) do
        local spl1 = string.split_ii_array(v, ",")
        if table.count(spl1) > 1 then
          local vec = {}
          vec.x = DataCenter.BuildManager.main_city_pos.x + spl1[1]
          vec.y = DataCenter.BuildManager.main_city_pos.y + spl1[2]
          local pointId = SceneUtils.TilePosToIndex(vec)
          DataCenter.CityNoMovePointManager:AddOnePoint(pointId)
        end
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.PrologueShowSetManPosition then
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    if isInBattle then
      if self.template.para1 ~= nil and self.template.para1 ~= "" then
        local posArr = {}
        local spl1 = string.split_ss_array(self.template.para1, ";")
        for k, v in ipairs(spl1) do
          local spl2 = string.split_ff_array(v, ",")
          if table.count(spl2) > 1 then
            table.insert(posArr, SceneUtils.TileToWorld({
              x = spl2[1],
              y = spl2[2]
            }))
          end
        end
        local player = DataCenter.BattleLevel:GetPlayer()
        if player ~= nil and #posArr > 0 then
          player:MoveTo(posArr)
        end
      end
      if self.template.para2 ~= nil and self.template.para2 ~= "" then
        local spl1 = string.split_ff_array(self.template.para2, ",")
        if table.count(spl1) > 1 then
          local vec = {}
          vec.x = spl1[1]
          vec.y = spl1[2]
          local player = DataCenter.BattleLevel:GetPlayer()
          if player ~= nil then
            player:TurnToPos(SceneUtils.TileToWorld(vec))
          end
        end
      end
    elseif self.template.para1 ~= nil and self.template.para1 ~= "" then
      local spl1 = string.split_ii_array(self.template.para1, ",")
      if table.count(spl1) > 1 then
        local vec = {}
        vec.x = DataCenter.BuildManager.main_city_pos.x + spl1[1]
        vec.y = DataCenter.BuildManager.main_city_pos.y + spl1[2]
        CitySpaceMan:GetInstance():SetTilePos(vec)
      end
    end
    local nextType = GuideNpcDoNextType.Auto
    if self.template.para3 ~= nil and self.template.para3 ~= "" then
      nextType = tonumber(self.template.para3)
    end
    if nextType == GuideNpcDoNextType.Auto then
      self:DoNext()
    end
  elseif self.template.type == GuideType.Wastelan_Guide then
    local flag = toInt(self.template.para1)
    if flag == GuidePrologueFlag.End then
      DataCenter.CityPioneerManager:EndDig()
      self:DoNext()
    elseif flag == GuidePrologueFlag.Start then
      self:SendSaveGuideMessage(BeforePrologue, SaveGuideDoneValue)
      DataCenter.CityPioneerManager:RefreshPrologueModel()
      if self.template.para2 ~= "" and self.template.para2 ~= nil then
        self:SendSaveGuideMessage(SaveErrorProloguePara, self.template.para2)
        CityTriggerPointManager:GetInstance():DoTriggerAndSave(tonumber(self.template.para2))
      end
    end
  elseif self.template.type == GuideType.Prologure_CarryingFlag then
    CitySpaceMan:GetInstance():HandFlag()
    self:DoNext()
  elseif self.template.type == GuideType.Prologure_PlantFlag then
    if toInt(self.template.para1) == 0 then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_PlantFlag, false)
      CitySpaceMan:GetInstance():WaveFlag()
    elseif toInt(self.template.para1) == 1 then
      CitySpaceMan:GetInstance():RemoveAllFlag()
    end
    self:DoNext()
  elseif self.template.type == GuideType.Wastelan_ResetManState then
    CitySpaceMan:GetInstance():SetGameStateToNormal()
    self:DoNext()
  elseif self.template.type == GuideType.ShowAllianceCityEffect then
    local list = DataCenter.AllianceMemberDataManager:GetAllNearMember()
    if list ~= nil and table.count(list) > 0 and self.template.para1 ~= nil then
      DataCenter.GuideAllianceMemberEffectManager:ShowAllianceMemberEffect(list, tonumber(self.template.para1))
    else
      self:DoNext()
    end
  elseif self.template.type == GuideType.Wastelan_ShowNpcTalk then
    local prefabName = self.template.para1
    local dialogId = tonumber(self.template.para2)
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    if isInBattle then
      DataCenter.BattleLevel:SetNpcDialog(prefabName, dialogId)
    else
      local height = self.template.para5 and tonumber(self.template.para5) or 2
      local bubbleStay = string.split_ss_array(self.template.para4, ";")
      local para4Count = table.count(bubbleStay)
      if para4Count > 0 then
        local stayType = tonumber(bubbleStay[1])
        if stayType == NpcBubbleStayType.Trigger then
          DataCenter.CityNpcManager:ToggleNpcTalkTrigger(prefabName, true, {dialogId = dialogId, height = height})
        elseif stayType == NpcBubbleStayType.All or stayType == NpcBubbleStayType.Time then
          DataCenter.CityNpcManager:ToggleNpcTalkTrigger(prefabName, false)
          local npc = DataCenter.CityNpcManager:GetNpcObjectByName(prefabName)
          if npc ~= nil then
            local talkParam = {}
            talkParam.talkType = NpcTalkType.Right
            talkParam.target = npc.transform
            talkParam.dialogId = dialogId
            talkParam.offset = Vector3.New(0, height, 0)
            if para4Count > 1 then
              talkParam.duration = tonumber(bubbleStay[2]) / 1000
            end
            EventManager:GetInstance():Broadcast(EventId.ShowTalkBubble, talkParam)
          end
        end
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.Wastelan_HideNpcTalk then
    local prefabName = self.template.para1
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    if isInBattle then
      DataCenter.BattleLevel:SetNpcDialog(prefabName, nil)
    else
      local npc = DataCenter.CityNpcManager:GetNpcObjectByName(prefabName)
      if npc ~= nil then
        EventManager:GetInstance():Broadcast(EventId.HideTalkBubble, {
          target = npc.transform
        })
      end
      DataCenter.CityNpcManager:ToggleNpcTalkTrigger(prefabName, false)
    end
    self:DoNext()
  elseif self.template.type == GuideType.Wastelan_GuideNpcTalk then
    local prefabName = self.template.para1
    local blockTime = tonumber(self.template.para4)
    local height = self.template.para5 and tonumber(self.template.para5) or 2
    local npc = DataCenter.CityNpcManager:GetNpcObjectByName(prefabName)
    if npc ~= nil then
      local talkParam = {}
      talkParam.talkType = NpcTalkType.Right
      talkParam.target = npc.transform
      talkParam.dialogId = tonumber(self.template.para2)
      talkParam.offset = Vector3.New(0, height, 0)
      talkParam.blockTime = math.max(0.5, blockTime / 1000.0)
      EventManager:GetInstance():Broadcast(EventId.ShowTalkBubble, talkParam)
    end
    self:DoNext()
  elseif self.template.type == GuideType.Wastelan_ShowYellowArrow then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local posArr = {}
      local spl = string.split_ss_array(self.template.para1, ";")
      for k, v in ipairs(spl) do
        local height
        local splHeight = string.split_ss_array(v, "#")
        if table.count(splHeight) > 0 then
          height = tonumber(splHeight[2])
        end
        local spl1 = string.split_ii_array(splHeight[1], ",")
        if table.count(spl1) > 1 then
          local vec = {}
          vec.x = DataCenter.BuildManager.main_city_pos.x + spl1[1]
          vec.y = DataCenter.BuildManager.main_city_pos.y + spl1[2]
          local param = {}
          param.pos = SceneUtils.TileToWorld(vec)
          param.height = height
          table.insert(posArr, param)
        end
      end
      local param = table.remove(posArr, 1)
      DataCenter.CityPioneerYellowArrowManager:AddOneArrow(param.pos, param.height, posArr)
    end
    self:DoNext()
  elseif self.template.type == GuideType.Wastelan_CheckFarmArrow then
    WastelandFarmManager:GetInstance():ToggleArrowDetection(true)
    self:DoNext()
  elseif self.template.type == GuideType.ShowUIWindow then
    local windowName = self.template.para4
    if not UIManager:GetInstance():IsWindowOpen(windowName) then
      UIManager:GetInstance():OpenWindow(windowName)
    end
    self:DoNext()
  elseif self.template.type == GuideType.Prologure_ManJump then
    CitySpaceMan:GetInstance():Jump()
    self:DoNext()
  elseif self.template.type == GuideType.WaitTime then
    self:DoNext()
  elseif self.template.type == GuideType.FakeQuest then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local spl1 = string.split_ss_array(self.template.para1, ";")
      if table.count(spl1) >= 5 then
        local param = {}
        param.iconName = spl1[1]
        param.npcName = spl1[2]
        param.des = tonumber(spl1[3])
        param.state = tonumber(spl1[4])
        param.nextGuideId = tonumber(spl1[5])
        self.fakeQuest = param
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.PrologueManRotation then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      CitySpaceMan:GetInstance():SetRotation(tonumber(self.template.para1))
    end
  elseif self.template.type == GuideType.ShowCommunicationTalk then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideCommunicationTalk) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideCommunicationTalk, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide,
        playEffect = false
      })
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim)
    end
  elseif self.template.type == GuideType.PrologueAddOneSpaceMan then
    CitySpaceMan:GetInstance():AddOneSpaceMan()
    self:DoNext()
  elseif self.template.type == GuideType.PVEFinishOneTrigger then
    if DataCenter.BattleLevel:IsInBattleLevel() then
      DataCenter.BattleLevel:DoTrigger(DataCenter.BattleLevel:GetTriggerByTriggerId(tonumber(self.template.para1)), true)
    end
    if self.template.type == GuideType.PVEFinishOneTrigger then
      self:DoNext()
    end
  elseif self.template.type == GuideType.SetLandLockBubbleVisible then
    local visible = tonumber(self.template.para1)
    if visible == LandLockBubbleVisibleType.Hide then
      self:SetLandLockBubbleActive(false)
    elseif visible == LandLockBubbleVisibleType.Show then
      self:SetLandLockBubbleActive(true)
    end
    self:DoNext()
  elseif self.template.type == GuideType.PveShowYellowArrow then
    local spl = string.split_ii_array(self.template.para1, ",")
    if table.count(spl) > 1 and DataCenter.BattleLevel:IsInBattleLevel() then
      local vec = {}
      vec.x = spl[1]
      vec.y = spl[2]
      local height
      local vec3 = SceneUtils.TileToWorld(vec)
      if self.template.para3 ~= nil and self.template.para3 ~= "" then
        local spl2 = string.split_ff_array(self.template.para3, ",")
        if 3 <= table.count(spl2) then
          vec3 = Vector3.New(spl2[1], spl2[2], spl2[3])
        end
      end
      if self.template.para2 ~= nil and self.template.para2 ~= "" then
        height = tonumber(self.template.para2)
        vec3.y = height
      end
      DataCenter.BattleLevel:AddOneArrow(SceneUtils.TileToWorld(vec), height, vec3)
    end
    self:DoNext()
  elseif self.template.type == GuideType.ShowUIBlackChangeMask then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBlackChangeMask, {anim = false, playEffect = false})
  elseif self.template.type == GuideType.PveShowBattleBloodLight then
    if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIPVEScene) then
      local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVEScene)
      if luaWindow ~= nil and luaWindow.View ~= nil then
        luaWindow.View:ShowGrayMask(self.template.para1)
      end
    else
      self:DoNext()
    end
  elseif self.template.type == GuideType.PveHideYellowArrow then
    if DataCenter.BattleLevel:IsInBattleLevel() then
      DataCenter.BattleLevel:RemoveAllArrow()
    else
      DataCenter.CityPioneerYellowArrowManager:RemoveAll()
    end
    self:DoNext()
  elseif self.template.type == GuideType.WaitMarchFightEnd then
    local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
    if table.csCount(selfMarch) > 0 then
      local march = table.getFirst(selfMarch)
      local marchUuid = march.uuid
      CS.SceneManager.World:TrackMarch(marchUuid)
    end
  elseif self.template.type == GuideType.OpenSelectQuestionPanel then
    GoToUtil.CloseAllWindows()
    DataCenter.AllianceLeaderManager:TryOpenRoleSelect()
    self:DoNext()
  elseif self.template.type == GuideType.NoNpcTalk then
    local param = {}
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      param.autoNextTime = tonumber(self.template.para1) / 1000
    end
    if self.template.para2 ~= nil and self.template.para2 ~= "" then
      param.des = Localization:GetString(self.template.para2)
    end
    if self.template.para3 ~= nil and self.template.para3 ~= "" then
      param.canClickTime = tonumber(self.template.para3) / 1000
    end
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideNoNpcTalk) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideNoNpcTalk, {anim = true, playEffect = false}, param)
    end
  elseif self.template.type == GuideType.ShowFakeHero then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local heroId = tonumber(self.template.para1)
      local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)
      local fakeParam = {}
      fakeParam.type = RewardType.HERO
      fakeParam.value = {
        heroId = heroId,
        rewardAdd = 1,
        uuid = heroUuid
      }
      if fakeParam ~= nil then
        DataCenter.HeroEntrustManager:AddShowReward({
          reward = {fakeParam}
        })
        local param = {}
        param.heroId = heroId
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          param.canClickTime = tonumber(self.template.para2) / 1000
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIShowFakeNewHero, {anim = false}, param)
      end
    end
  elseif self.template.type == GuideType.PrologueSubmitTrigger then
    local triggerId = tonumber(self.template.para1)
    local data = DataCenter.CityTriggerPointDataManager:GetTriggerPointDataFromId(triggerId)
    if data ~= nil then
      for k, v in pairs(data:GetAllNeedRes()) do
        data:SetGiveRes(k, v)
      end
      local obj = CityTriggerPointManager:GetInstance():GetTriggerObject(triggerId)
      if obj ~= nil then
        obj:RefreshShow()
      end
    end
    CityPioneerArchive:GetInstance():Save()
    self:DoNext()
  elseif self.template.type == GuideType.SetAttackSpecialStateFlag then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      EventManager:GetInstance():Broadcast(EventId.AttackSpecialStateFlag, tonumber(self.template.para1))
    end
    self:DoNext()
  elseif self.template.type == GuideType.WaitPanelOpen then
    self:DoNext()
  elseif self.template.type == GuideType.LandLockChangeModel then
    DataCenter.LandLockManager:DoAlter(tonumber(self.template.para1), self.template.para2)
    self:DoNext()
  elseif self.template.type == GuideType.SetBubbleShow then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local showType = tonumber(self.template.para1)
      if showType == BubbleShowType.Show then
        DataCenter.BuildBubbleManager:ShowBubbleNode()
      elseif showType == BubbleShowType.Hide then
        DataCenter.BuildBubbleManager:HideBubbleNode()
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.AlliancePanelGuide then
    if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIAllianceMainTable) then
      local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIAllianceMainTable)
      if luaWindow ~= nil and luaWindow.View ~= nil then
        local showParam = {}
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
          local spl = string.split_ss_array(self.template.para1, "|")
          for k, v in ipairs(spl) do
            local spl1 = string.split_ss_array(v, ",")
            local count = table.count(spl1)
            local temp = {}
            if count >= 1 then
              temp.btnType = tonumber(spl1[1])
              table.insert(showParam, temp)
            end
            if 4 <= count then
              temp.dialog = spl1[2]
              temp.modelName = spl1[3]
              temp.modelPosition = tonumber(spl1[4])
            end
          end
        end
        luaWindow.View:DoSpecialGuide(showParam)
      end
    else
      self:DoNext()
    end
  elseif self.template.type == GuideType.DoQuestJump then
    local questId
    if self.template.para1 ~= nil then
      questId = tonumber(self.template.para1)
    end
    self:DoNext()
    if questId ~= nil then
      local template = DataCenter.QuestTemplateManager:GetQuestTemplate(questId)
      GoToUtil.GoToByQuestId(template)
    end
  elseif self.template.type == GuideType.CheckBecomeAllianceLeader then
    DataCenter.AllianceLeaderManager:SendCheckCanBeLeader()
  elseif self.template.type == GuideType.ShowLoadMask then
    if self.template.para1 ~= nil then
      local showLoadMaskType = tonumber(self.template.para1)
      if showLoadMaskType == ShowLoadMaskType.Show then
        if self.template.para3 == "" then
          local list = string.split_ss_array(self.template.para2, ";")
          if 3 < table.count(list) then
            local param = {}
            param.chapterId = tonumber(list[1])
            param.bgName = list[2]
            param.titleDes = Localization:GetString(list[3])
            param.des = Localization:GetString(list[4])
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideLoadMask, {anim = true, playEffect = false}, param)
          end
        else
          local param = {}
          param.des = Localization:GetString(self.template.para3)
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideLoadBlackMask, {anim = true, playEffect = false}, param)
        end
      elseif showLoadMaskType == ShowLoadMaskType.Hide then
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideLoadMask) then
          UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideLoadMask, {anim = true, playEffect = false})
        end
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideLoadBlackMask) then
          UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideLoadBlackMask, {anim = true, playEffect = false})
        end
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetShowLandLock then
    if self.template.para1 ~= nil then
      local showLandLockType = tonumber(self.template.para1)
      local list = string.split_ii_array(self.template.para2, ",")
      for k, v in ipairs(list) do
        local data = DataCenter.LandLockManager:GetLandLockDataById(v)
        if data ~= nil and data.state ~= LandLockState.Finished then
          if showLandLockType == ShowLandLockType.Show then
            CS.SceneManager.World:ShowObject(data:GetPointId())
          elseif showLandLockType == ShowLandLockType.Hide then
            CS.SceneManager.World:HideObject(data:GetPointId())
          end
        end
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.ChangeBgm then
    self:SendSaveGuideMessage(GuideBgmName, self.template.para1)
    CommonUtil.PlayGameBgMusic()
    self:DoNext()
  elseif self.template.type == GuideType.PVESetTriggerVisible then
    if self.template.para1 ~= nil then
      local visible = tonumber(self.template.para1) == PveTriggerVisibleType.Show
      local list = string.split_ii_array(self.template.para2, ",")
      for k, v in ipairs(list) do
        DataCenter.BattleLevel:SetOneTriggerVisible(v, visible)
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.ChangeBgmVolume then
    if DataCenter.LWSoundManager.useAudioMixer then
      DataCenter.LWSoundManager:ChangeVolume("MUSIC", tonumber(self.template.para1), tonumber(self.template.para2), true)
    else
      DataCenter.LWSoundManager:ChangeVolume("Music", tonumber(self.template.para1), tonumber(self.template.para2), false)
    end
    self:DoNext()
  elseif self.template.type == GuideType.WaitGolloesArrived then
    local worldMarch, formationInfo = DataCenter.GolloesCampManager:GetGolloesMarchByType(GolloesType.Explorer)
    if worldMarch then
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
      CS.SceneManager.World:TrackMarch(worldMarch.uuid)
    end
  elseif self.template.type == GuideType.SetRadarMonsterVisible then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      EventManager:GetInstance():Broadcast(EventId.ShowWorldMarchByType, NewMarchType.EXPLORE)
    elseif visible == GuideSetNormalVisible.Hide then
      EventManager:GetInstance():Broadcast(EventId.HideWorldMarchByType, NewMarchType.EXPLORE)
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetCityPeopleAndCarVisible then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllShow)
    elseif visible == GuideSetNormalVisible.Hide then
      EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllHide)
    end
    self:DoNext()
  elseif self.template.type == GuideType.PveSkillVisible then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      DataCenter.BattleLevel:SetHideSkill(false)
    elseif visible == GuideSetNormalVisible.Hide then
      DataCenter.BattleLevel:SetHideSkill(true)
    end
    EventManager:GetInstance():Broadcast(EventId.SetPveSkillVisible)
    self:DoNext()
  elseif self.template.type == GuideType.SetPveStaminaNpcVisible then
    self:DoNext()
  elseif self.template.type == GuideType.FullPveSkill then
    if self.template.para1 ~= "" then
      DataCenter.BattleLevel:ChangeSkillNum(tonumber(self.template.para1))
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetPveBuyBuffShopEffectActive then
    EventManager:GetInstance():Broadcast(EventId.SetPveBuyBuffSShopEffectVisible, self.template.para1)
    self:DoNext()
  elseif self.template.type == GuideType.SetPveStopRefreshStamina then
    local param = {}
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      param.eventType = GuideMaskTypeSignalType.UIPveMainStaminaSliderShow
    elseif visible == GuideSetNormalVisible.Hide then
      param.eventType = GuideMaskTypeSignalType.UIPveMainStaminaSliderHide
    end
    EventManager:GetInstance():Broadcast(EventId.SetGuideMask, param)
    self:DoNext()
  elseif self.template.type == GuideType.SetPveNoClickStamina then
    EventManager:GetInstance():Broadcast(EventId.SetPveNoClickStamina, self.template.para1)
    self:DoNext()
  elseif self.template.type == GuideType.OpenHeadTalkPanel then
    if self.template.para2 ~= nil then
      local param = {}
      local list = string.split_ss_array(self.template.para2, "|")
      for k, v in ipairs(list) do
        local spl = string.split_ss_array(v, ";")
        local count = #spl
        if 4 <= count then
          local per = {}
          table.insert(param, per)
          per.dialog = Localization:GetString(spl[1])
          per.modelName = spl[2]
          per.modelPosition = spl[3]
          per.time = tonumber(spl[4]) / 1000
        end
      end
      if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHeadTalk) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeadTalk, {anim = true, playEffect = false}, param)
      else
        EventManager:GetInstance():Broadcast(EventId.RefreshUIHeadTalk, param)
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.CloseHeadTalkPanel then
    EventManager:GetInstance():Broadcast(EventId.CloseUIGuideHeadTalk)
    self:DoNext()
  elseif self.template.type == GuideType.SetPveBagGuide then
    local param = {}
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      param.eventType = GuideMaskTypeSignalType.UIPveMainResourceShow
    elseif visible == GuideSetNormalVisible.Hide then
      param.eventType = GuideMaskTypeSignalType.UIPveMainResourceHide
    end
    EventManager:GetInstance():Broadcast(EventId.SetGuideMask, param)
    self:DoNext()
  elseif self.template.type == GuideType.HeroAdvanceGuide then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local param = {}
      param.eventType = HeroAdvanceGuideSignalType.Enter
      param.quality = tonumber(self.template.para1)
      EventManager:GetInstance():Broadcast(EventId.HeroAdvanceGuide, param)
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetHeroAdvanceGuideHeroVisible then
    local param = {}
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      param.eventType = HeroAdvanceGuideSignalType.ShowMainHeroBlack
    elseif visible == GuideSetNormalVisible.Hide then
      param.eventType = HeroAdvanceGuideSignalType.HideMainHeroBlack
    end
    EventManager:GetInstance():Broadcast(EventId.HeroAdvanceGuide, param)
    self:DoNext()
  elseif self.template.type == GuideType.SetHeroAdvanceGuideSubHeroVisible then
    local param = {}
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      param.eventType = HeroAdvanceGuideSignalType.ShowSubHeroBlack
    elseif visible == GuideSetNormalVisible.Hide then
      param.eventType = HeroAdvanceGuideSignalType.HideSubHeroBlack
    end
    EventManager:GetInstance():Broadcast(EventId.HeroAdvanceGuide, param)
    self:DoNext()
  elseif self.template.type == GuideType.ShakeCamera then
    if DataCenter.BattleLevel ~= nil then
      local paramSpls = string.split(self.template.para1, "|")
      local param = {}
      param.duration = tonumber(paramSpls[1]) or 0.5
      param.strength = tonumber(paramSpls[2]) or 1
      param.vibrato = tonumber(paramSpls[3]) or 20
      DataCenter.BattleLevel:ShakeCameraWithParam(param)
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetAllVisible then
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      if isInBattle then
      else
        self:SetNoShowUIMain(false)
        DataCenter.BuildBubbleManager:ShowBubbleNode()
        DataCenter.WoundedCompensateManager:AddWoundedBubble()
        DataCenter.NpcTaskBubbleManager:AddTaskBubble()
        DataCenter.NpcQAManager:SetNpcQAVisible(true)
      end
    elseif visible ~= GuideSetNormalVisible.Hide or isInBattle then
    else
      self:SetNoShowUIMain(true)
      DataCenter.BuildBubbleManager:HideBubbleNode()
      DataCenter.WoundedCompensateManager:RemoveWoundedBubble()
      DataCenter.NpcTaskBubbleManager:RemoveTaskBubble()
      DataCenter.NpcQAManager:SetNpcQAVisible(false)
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetWoundedBubbleVisible then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      DataCenter.WoundedCompensateManager:AddWoundedBubble()
    elseif visible == GuideSetNormalVisible.Hide then
      DataCenter.WoundedCompensateManager:RemoveWoundedBubble()
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetGuideQuestVisible then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      EventManager:GetInstance():Broadcast(EventId.GuidControlQuest, tonumber(self.template.para1))
    end
    self:DoNext()
  elseif self.template.type == GuideType.ShowCurtain then
    local param = {}
    param.title = Localization:GetString(self.template.para1)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVECurtain, {anim = false}, param)
    self:DoNext()
  elseif self.template.type == GuideType.NetUnConnect then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      CS.ApplicationLaunch.Instance:ReloadGame()
    else
      CS.ApplicationLaunch.Instance.Loading:ReConnect()
    end
    self:DoNext()
  elseif self.template.type == GuideType.UIBuildListSpecial then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local specialType = tonumber(self.template.para1)
      if specialType == GuideUIBuildListSpecialType.OpenUI then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildList)
      elseif specialType == GuideUIBuildListSpecialType.Move then
        local buildId = tonumber(self.template.para2)
        EventManager:GetInstance():Broadcast(EventId.UIBuildListScrollMove, buildId)
        self:DoNext()
      end
    end
  elseif self.template.type == GuideType.BackBuildCollectTime then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_CONDOMINIUM)
    if buildData ~= nil then
      SFSNetwork.SendMessage(MsgDefines.BackBuildingCollectTime, {
        uuid = buildData.uuid
      })
    else
      self:DoNext()
    end
  elseif self.template.type == GuideType.SetHeroAdvanceMaskVisible then
    local param = {}
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      param.eventType = HeroAdvanceGuideSignalType.ShowHeroStarUpBlack
    elseif visible == GuideSetNormalVisible.Hide then
      param.eventType = HeroAdvanceGuideSignalType.HideHeroStarUpBlack
    end
    EventManager:GetInstance():Broadcast(EventId.HeroAdvanceGuide, param)
    self:DoNext()
  elseif self.template.type == GuideType.SetPveOutBagGuide then
    local param = {}
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      param.eventType = GuideMaskTypeSignalType.UIPveMainBagShow
    elseif visible == GuideSetNormalVisible.Hide then
      param.eventType = GuideMaskTypeSignalType.UIPveMainBagHide
    end
    EventManager:GetInstance():Broadcast(EventId.SetGuideMask, param)
    self:DoNext()
  elseif self.template.type == GuideType.SetQuestCanShowInGuide then
    local param = {}
    param.showType = tonumber(self.template.para1)
    param.showIndex = 1
    EventManager:GetInstance():Broadcast(EventId.SetQuestCanShowInGuide, param)
    self:DoNext()
  elseif self.template.type == GuideType.OpenPanel then
    local panelName = self.template.para1
    local panelType = tonumber(self.template.para2)
    if panelType == GuideOpenPanelType.Common and not UIManager:GetInstance():IsWindowOpen(panelName) then
      UIManager:GetInstance():OpenWindow(panelName)
    end
    self:DoNext()
  elseif self.template.type == GuideType.UIScrollToSomeWhere then
    EventManager:GetInstance():Broadcast(EventId.UIScrollToSomeWhere, self.template.para1)
    self:DoNext()
  elseif self.template.type == GuideType.ShowJumpBtn then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      local param = {}
      if self.template.para2 ~= nil and self.template.para2 ~= "" then
        param.gotoGuideId = tonumber(self.template.para2)
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITimelineJump, {anim = false, playEffect = false}, param)
    elseif visible == GuideSetNormalVisible.Hide then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UITimelineJump, {anim = false, playEffect = false})
    end
    self:DoNext()
  elseif self.template.type == GuideType.BlackHoleMask then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      local param = {}
      param.obj = self.obj
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIBlackHoleMask) then
        EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBlackHoleMask, {anim = false, playEffect = false}, param)
      end
    elseif visible == GuideSetNormalVisible.Hide then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBlackHoleMask, {anim = false, playEffect = false})
    end
    self:DoNext()
  elseif self.template.type == GuideType.UIPathArrow then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      local param = {}
      param.obj = self.obj
      param.extraPosition = Vector3.New(0, 0, 0)
      if self.template.para3 ~= nil and self.template.para3 ~= "" then
        local spl = string.split_ff_array(self.template.para3, ",")
        if #spl == 2 then
          param.extraPosition.x = spl[1]
          param.extraPosition.y = spl[2]
        end
      end
      param.rotation = Vector3.New(0, 0, 180)
      if self.template.para4 ~= nil and self.template.para4 ~= "" then
        param.rotation.z = tonumber(self.template.para4)
      end
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPathArrow) then
        EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPathArrow, {anim = false, playEffect = false}, param)
      end
    elseif visible == GuideSetNormalVisible.Hide then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPathArrow, {anim = false, playEffect = false})
    end
    self:DoNext()
  elseif self.template.type == GuideType.BuildCanDoAnim then
    local eventId = 0
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      eventId = EventId.SetBuildCanDoAnim
    elseif visible == GuideSetNormalVisible.Hide then
      eventId = EventId.SetBuildNoDoAnim
    end
    local buildId = 0
    if self.template.para2 ~= nil and self.template.para2 ~= "" then
      buildId = tonumber(self.template.para2)
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
      if list ~= nil and table.count(list) > 0 then
        for k, v in ipairs(list) do
          EventManager:GetInstance():Broadcast(eventId, v.uuid)
        end
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.ShowNewHero then
    local heroId = tonumber(self.template.para2) or 0
    local heroUuid = tonumber(DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)) or 0
    if heroUuid ~= 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UINewHero, heroUuid)
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetWorldArrowVisible then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      WorldArrowManager:GetInstance():SetGuidState(true)
    elseif visible == GuideSetNormalVisible.Hide then
      WorldArrowManager:GetInstance():SetGuidState(false)
    end
    self:DoNext()
  elseif self.template.type == GuideType.ShowWorldArrow then
    local showType = tonumber(self.template.para1)
    if showType == ShowWorldArrowType.FarmGet then
      local uuidList = DataCenter.QueueDataManager:GetBuildUuidInFinishQueueByType(NewQueueType.Field)
      if uuidList ~= nil then
        for k, v in ipairs(uuidList) do
          local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
          if buildData ~= nil then
            WorldArrowManager:GetInstance():ShowArrowEffect(0, buildData:GetCenterVec(), ArrowType.Building)
            break
          end
        end
      end
    elseif showType == ShowWorldArrowType.FarmFree then
      local uuidList = DataCenter.QueueDataManager:GetBuildUuidInFreeQueueByType(NewQueueType.Field)
      if uuidList ~= nil then
        for k, v in ipairs(uuidList) do
          local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
          if buildData ~= nil then
            WorldArrowManager:GetInstance():ShowArrowEffect(0, buildData:GetCenterVec(), ArrowType.Building)
            break
          end
        end
      end
    end
    self:DoNext()
  end
end

local function ShowGuideHand(self)
end

local function RemoveGuideHand(self)
end

local function LookBackToCharacter(self)
end

local function ShowLog(self, ...)
  if self.isDebug then
    Logger.Log(...)
  end
end

local function DoJump(self)
  if self.template ~= nil and self.template.jumpid ~= 0 then
    self:SetCurGuideId(self.template.jumpid)
    self:DoGuide()
  end
end

local function IsDragGuide(self)
  if self.template ~= nil and self.template.forcetype == GuideForceType.Force and self.template.type == GuideType.Factory then
    return true
  end
  return false
end

local function SetNoGotoTime(self, isGo)
  self.noGotoTime = isGo
end

local function TrainingArmySignal(signal)
  if signal:ContainsKey("queueType") then
    local queueType = signal:GetInt("queueType")
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.NoFreeQueue, tostring(queueType))
  end
end

local function ClickMuchStop(self)
  local guideType = self:GetGuideType()
  if guideType ~= GuideType.PlayMovie and guideType ~= GuideType.WaitMovieComplete and guideType ~= GuideType.ShowTalk and guideType ~= GuideType.ShowBlackUI and guideType ~= GuideType.MoveCamera and guideType ~= GuideType.ShowChapterAnim and guideType ~= GuideType.ClickTimeLineBubble and guideType ~= GuideType.Wastelan_ResetManState and guideType ~= GuideType.ClickPveTriggerBubble and guideType ~= GuideType.PrologueShowNpc then
    local id = self.guideId
    self:DoMuchStopJumpGuide()
    local guideName = StatTTType.JumpGuideId .. id
    if self:GetSaveGuideValue(guideName) ~= SaveGuideDoneValue then
      self:SendSaveGuideMessage(guideName, SaveGuideDoneValue)
      self:SendLogMessage(tostring(id), StatTTType.JumpGuideId)
    end
    DataCenter.GuideManager:SetCurGuideId(GuideEndId)
    DataCenter.GuideManager:DoGuide()
  end
end

local function SendLogToNet(self, guideName, recordType)
  if self:GetSaveGuideValue(guideName) ~= SaveGuideDoneValue then
    self:SendSaveGuideMessage(guideName, SaveGuideDoneValue)
    self:SendLogMessage(guideName, recordType)
    self:ShowLog("shimin ------------------------- SendLogToNet  " .. guideName)
  end
end

local function BuildLackConnectSignal(uuid)
  DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.NeedConnect, SaveGuideDoneValue)
end

local function CheckPlayerLevelGuide(self, lastLevel)
  if not self:InGuide() then
    local curLevel = DataCenter.PlayerLevelManager:GetLevel()
    if lastLevel == nil or lastLevel == "" then
      lastLevel = 1
    else
      lastLevel = tonumber(lastLevel)
    end
    if curLevel > lastLevel then
      local needSave = true
      for i = lastLevel, curLevel do
        local next = i + 1
        local cur = tostring(i)
        if self:CheckDoTriggerGuide(GuideTriggerType.PlayerLevel, cur) then
          needSave = false
          self:SetGuideEndCallBack(function()
            self:SendSaveGuideMessage(SaveTriggerGuidePlayerLevel, cur)
            self:CheckPlayerLevelGuide(next)
          end)
          break
        end
      end
      if needSave then
        self:SendSaveGuideMessage(SaveTriggerGuidePlayerLevel, tostring(curLevel))
      end
    end
  end
end

local function UpdateScienceDataSignal(scienceId)
  DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.Science, tostring(scienceId))
end

local function IsShowBusinessBubble(self)
  return DataCenter.GuideManager:GetSaveGuideValue(SaveNoShowBusinessBubble) ~= SaveGuideDoneValue
end

local function IsShowBusinessPlane(self)
  return DataCenter.GuideManager:GetSaveGuideValue(SaveNoShowBusinessPlaneArrive) ~= SaveGuideDoneValue
end

local function DoMuchStopJumpGuide(self)
  if not WorldArrowManager:GetInstance():GetGuidState() then
    WorldArrowManager:GetInstance():SetGuidState(true)
  end
  local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
  if chapterId ~= nil and chapterId <= GuideJumpUnlockBtnChapterId then
    for k, v in ipairs(GuideJumpUnlockBtnType) do
      local template = DataCenter.UnlockBtnTemplateManager:GetUnlockBtnTemplate(v)
      if template ~= nil then
        for k1, v1 in ipairs(template.unlock_noviceboot) do
          if not self:IsDoneThisGuide(v1) then
            self:SendSaveGuideMessage(self:GetDoneGuideEndId(v1), SaveGuideDoneValue)
            EventManager:GetInstance():Broadcast(EventId.GuideSaveId)
            EventManager:GetInstance():Broadcast(EventId.ShowUnlockBtn, v)
          end
        end
      end
    end
  else
    local guideId = self.guideId
    local template
    while guideId ~= GuideEndId do
      template = DataCenter.GuideTemplateManager:GetGuideTemplate(guideId)
      if template == nil then
        guideId = GuideEndId
      else
        if template.type == GuideType.UnlockBtn then
          if not self:IsDoneThisGuide(template.savedoneid) then
            self:SendSaveGuideMessage(self:GetDoneGuideEndId(template.savedoneid), SaveGuideDoneValue)
            EventManager:GetInstance():Broadcast(EventId.GuideSaveId)
          end
          local unlockType = tonumber(template.para1)
          EventManager:GetInstance():Broadcast(EventId.ShowUnlockBtn, unlockType)
        elseif template.type == GuideType.DoUIMainAnim then
          if template.para1 ~= nil then
            local showUIMainType = tonumber(template.para1)
            if showUIMainType == GuideUIMainShowType.Hide then
              self:SetNoShowUIMain(true)
            elseif showUIMainType == GuideUIMainShowType.Show then
              self:SetNoShowUIMain(false)
            end
          end
        elseif template.type == GuideType.WaitMarchFightEnd then
          self:SetNoShowUIMain(false)
        elseif template.type == GuideType.WaitGolloesArrived then
          self:SetNoShowUIMain(false)
        elseif template.type == GuideType.SetAllVisible then
          self:SetNoShowUIMain(false)
          DataCenter.BuildBubbleManager:ShowBubbleNode()
          DataCenter.WoundedCompensateManager:AddWoundedBubble()
          DataCenter.NpcTaskBubbleManager:AddTaskBubble()
          DataCenter.NpcQAManager:SetNpcQAVisible(true)
        end
        guideId = template.nextid
      end
    end
  end
end

local function StopAllEffectSound(self)
  if self.effectSound ~= nil then
    for k, v in pairs(self.effectSound) do
      DataCenter.LWSoundManager:StopSound(v)
    end
    self.effectSound = {}
  end
end

local function RefreshObject(self)
  self.obj = nil
  self.objWorldPos = nil
  self:DoGuide()
end

local function IsSendBuildPlace(self)
  return DataCenter.GuideManager:GetSaveGuideValue(SaveNoSendPlaceBuild) ~= SaveGuideDoneValue
end

local function IsShowPrologue(self)
  return DataCenter.BuildManager:IsInNewUserWorld()
end

local function HospitalUpdateSignal()
  DataCenter.GuideManager:CheckTreatSoldierGuide()
end

local function CheckTreatSoldierGuide(self)
  if DataCenter.HospitalManager:IsHaveInjuredSolider() then
    self:CheckDoTriggerGuide(GuideTriggerType.TreatSoldier, SaveGuideDoneValue)
  end
end

local function IsCanShowQuest(self)
  if (self.template == nil or self.template.type == GuideType.FakeQuest or self.template.type == GuideType.ClickButton and string.contains(self.template.para1, "questObj")) and not DataCenter.RecommendShowManager:IsHaveShowRecommend() then
    return true
  end
  return false
end

local function GetFakeQuest(self)
  return self.fakeQuest
end

local function ClearFakeQuest(self)
  self.fakeQuest = nil
end

local function SaveSpaceManExtraNum(self, num)
  self:SendSaveGuideMessage(SpaceManExtraNum, tostring(num))
end

local function GetSpaceManExtraNum(self)
  local num = self:GetSaveGuideValue(SpaceManExtraNum)
  if num ~= nil and num ~= "" then
    return tonumber(num)
  end
  return 0
end

local function CanShowLandLockBubble(self)
  return DataCenter.GuideManager:GetSaveGuideValue(NoShowLandLockBubble) ~= SaveGuideDoneValue
end

local function GetPveTriggerGuide(self, pveId)
  return self.pveTrigger[pveId]
end

local function InitSpecialTrigger(self)
  local triggerType = GuideTriggerType.PveOwnRes
  local list = self.allTriggerGuide[triggerType]
  if list ~= nil then
    for k, v in pairs(list) do
      local spl = string.split_ss_array(k, "|")
      if table.count(spl) > 1 then
        local pveId = tonumber(spl[1])
        if self.pveTrigger[pveId] == nil then
          self.pveTrigger[pveId] = {}
        end
        local param = {}
        param.triggerType = triggerType
        param.triggerPara = k
        param.needRes = {}
        local spl2 = string.split_ss_array(spl[2], ";")
        for k1, v1 in ipairs(spl2) do
          local spl3 = string.split_ii_array(v1, ",")
          local spl3Count = table.count(spl3)
          if 1 < spl3Count then
            local need = {}
            need.resType = spl3[1]
            need.count = spl3[2]
            table.insert(param.needRes, need)
          end
        end
        table.insert(self.pveTrigger[pveId], param)
      end
    end
  end
  triggerType = GuideTriggerType.PveEnterBattle
  list = self.allTriggerGuide[triggerType]
  if list ~= nil then
    for k, v in pairs(list) do
      if self.specialTriggerGuide[triggerType] == nil then
        self.specialTriggerGuide[triggerType] = {}
      end
      local param = {}
      param.triggerType = triggerType
      param.triggerPara = k
      param.triggers = string.split_ss_array(k, ";")
      table.insert(self.specialTriggerGuide[triggerType], param)
    end
  end
  triggerType = GuideTriggerType.FinishBattleLevel
  list = self.allTriggerGuide[triggerType]
  if list ~= nil then
    for k, v in pairs(list) do
      if self.specialTriggerGuide[triggerType] == nil then
        self.specialTriggerGuide[triggerType] = {}
      end
      local param = {}
      param.triggerType = triggerType
      param.triggerPara = k
      param.triggers = {}
      local spl = string.split_ss_array(k, ";")
      for k1, v1 in ipairs(spl) do
        local spl1 = string.split_ii_array(v1, ",")
        local spl1Count = table.count(spl1)
        if 1 < spl1Count and spl1[1] <= spl1[2] then
          for i = spl1[1], spl1[2] do
            table.insert(param.triggers, i)
          end
        elseif spl1Count == 1 then
          table.insert(param.triggers, spl1[1])
        end
      end
      table.insert(self.specialTriggerGuide[triggerType], param)
    end
  end
  triggerType = GuideTriggerType.PrologueOwnNum
  list = self.allTriggerGuide[triggerType]
  if list ~= nil then
    for k, v in pairs(list) do
      if self.specialTriggerGuide[triggerType] == nil then
        self.specialTriggerGuide[triggerType] = {}
      end
      local param = {}
      param.triggerType = triggerType
      param.triggerPara = k
      param.needRes = {}
      local spl2 = string.split_ss_array(k, ";")
      for k1, v1 in ipairs(spl2) do
        local spl3 = string.split_ii_array(v1, ",")
        local spl3Count = table.count(spl3)
        if 1 < spl3Count then
          local need = {}
          need.resType = spl3[1]
          need.count = spl3[2]
          table.insert(param.needRes, need)
        end
      end
      table.insert(self.specialTriggerGuide[triggerType], param)
    end
  end
end

local function GetSpecialTriggerPara(self, triggerType, triggerPara)
  local list = self.specialTriggerGuide[triggerType]
  if list ~= nil then
    for k, v in ipairs(list) do
      if triggerType == GuideTriggerType.PveEnterBattle then
        for k1, v1 in ipairs(v.triggers) do
          if v1 == triggerPara then
            return v.triggerPara
          end
        end
      elseif triggerType == GuideTriggerType.FinishBattleLevel then
        local numTriggerPara = tonumber(triggerPara)
        for k1, v1 in ipairs(v.triggers) do
          if v1 == numTriggerPara then
            return v.triggerPara
          end
        end
      end
    end
  end
  return triggerPara
end

local function SetLandLockBubbleActive(self, active)
  if active then
    self:SendSaveGuideMessage(NoShowLandLockBubble, "")
    Logger.Log(" Guide SetLandLockBubbleVisible Show")
  else
    self:SendSaveGuideMessage(NoShowLandLockBubble, SaveGuideDoneValue)
    Logger.Log(" Guide SetLandLockBubbleVisible Hide")
  end
  DataCenter.LandLockBubbleManager:RefreshBubbleVisible()
end

local function OnScienceQueueResearchSignal(data)
  if data:ContainsKey("itemId") then
    local scienceType = data:GetInt("itemId")
    local curLevel = DataCenter.ScienceManager:GetScienceLevel(scienceType)
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.StartScience, tostring(scienceType + curLevel))
  end
end

local function IsFactoryFirstFreeSpeed(self)
  return DataCenter.GuideManager:GetSaveGuideValue(FactoryFirstFreeSpeed) == SaveGuideDoneValue
end

local function IsCanShowReward(self)
  if self:InGuide() and self.template.type ~= GuideType.ShowFakeHero and self.template.type ~= GuideType.WaitQuestionEnd and self.template.type ~= GuideType.WaitCloseUI then
    return false
  end
  return true
end

local function SetSuccessMarchFlag(self, flag)
  self.successMarchFlag = flag
end

local function StartAttackMonsterWithoutMsgTipSignal(flag)
  DataCenter.GuideManager:SetSuccessMarchFlag(tonumber(flag))
end

local function IsShowRadarBubble(self)
  return DataCenter.GuideManager:GetSaveGuideValue(GuideNoShowRadarBubble) ~= SaveGuideDoneValue
end

local function IsShowWorldCollectPoint(self)
  return self:GetSaveGuideValue(GuideNoShowCollectPoint) ~= SaveGuideDoneValue
end

local function IsPrologueCanAttack(self)
  return self:GetSaveGuideValue(PrologueNoAttack) ~= SaveGuideDoneValue
end

local function IsGuideArrowType(self)
  return self.template ~= nil and (self.template.type == GuideType.ClickButton or self.template.type == GuideType.ClickBuild or self.template.type == GuideType.QueueBuild or self.template.type == GuideType.Bubble or self.template.type == GuideType.CityGarbage or self.template.type == GuideType.GotoMoveBubble or self.template.type == GuideType.OpenFog or self.template.type == GuideType.ClickQuest or self.template.type == GuideType.ClickBuildFinishBox or self.template.type == GuideType.ClickTime or self.template.type == GuideType.ClickQuickBuildBtn or self.template.type == GuideType.ClickMonster or self.template.type == GuideType.ClickTimeLineBubble or self.template.type == GuideType.ClickCityPointType or self.template.type == GuideType.ClickGolloesCanSubmitOrder or self.template.type == GuideType.ClickRadarBubble or self.template.type == GuideType.ClickUISpecialBtn or self.template.type == GuideType.ClickLandLockBubble or self.template.type == GuideType.ClickCollectResource or self.template.type == GuideType.ClickLandLockRewardBox or self.template.type == GuideType.ClickRadarMonster or self.template.type == GuideType.ClickMonsterReward or self.template.type == GuideType.ClickPveTriggerBubble or self.template.type == GuideType.ClickWoundedCompensateBubble)
end

local function CheckLoginGuide(self)
  local triggerType = GuideTriggerType.Login
  local list = self.allTriggerGuide[triggerType]
  if list ~= nil then
    for k, v in pairs(list) do
      local saveId = tonumber(k)
      if not self:IsDoneThisGuide(saveId) then
        local template = DataCenter.GuideTemplateManager:GetGuideTemplate(v)
        if template ~= nil then
          local state = self:GetCanDoGuideState(v)
          if state == GuideCanDoType.Yes then
            self:SendSaveGuideMessage(self:GetDoneGuideEndId(saveId), SaveGuideDoneValue)
            EventManager:GetInstance():Broadcast(EventId.GuideSaveId)
          end
        end
      end
    end
  end
end

local function UpdateAlCanBeLeaderSignal()
  local template = DataCenter.GuideManager:GetCurTemplate()
  if template ~= nil and template.type == GuideType.CheckBecomeAllianceLeader then
    if DataCenter.AllianceLeaderManager:CheckCanBeLeader() then
      DataCenter.GuideManager:SetCurGuideId(tonumber(template.para1))
      DataCenter.GuideManager:DoGuide()
    else
      DataCenter.GuideManager:SetCurGuideId(tonumber(template.para2))
      DataCenter.GuideManager:DoGuide()
    end
  end
end

local function GetGuideBgmName(self)
  return self:GetSaveGuideValue(GuideBgmName)
end

local function GarbageCollectStartSignal(marchUuid)
  if DataCenter.GuideManager:GetGuideType() == GuideType.WaitGolloesArrived then
    local worldMarch, formationInfo = DataCenter.GolloesCampManager:GetGolloesMarchByType(GolloesType.Explorer)
    if worldMarch and worldMarch.targetUuid == marchUuid then
      CS.SceneManager.World.marchUuid = 0
      CS.SceneManager.World:TrackMarch(0)
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
      DataCenter.GuideManager:DoNext()
    end
  end
end

local function CheckNeedWaitTriggerGuide(self, triggerType, triggerParam)
  if self:InGuide() or DataCenter.BattleLevel:IsInBattleLevel() or UIManager:GetInstance():HasWindow() or not SceneUtils.GetIsInCity() then
    self:AddOneWaitTrigger(triggerType, triggerParam)
  else
    DataCenter.GuideManager:CheckDoTriggerGuide(triggerType, triggerParam)
  end
end

local function AddOneWaitTrigger(self, triggerType, triggerParam)
  for k, v in ipairs(self.waitTrigger) do
    if v.triggerType == triggerType and v.triggerParam == triggerParam then
      return
    end
  end
  local param = {}
  param.triggerType = triggerType
  param.triggerParam = triggerParam
  table.insert(self.waitTrigger, param)
end

local function RemoveOneWaitTrigger(self, triggerType, triggerParam)
  for k, v in ipairs(self.waitTrigger) do
    if v.triggerType == triggerType and v.triggerParam == triggerParam then
      table.remove(self.waitTrigger, k)
      return
    end
  end
end

local function DoWaitTriggerAfterBack(self)
  for k, v in ipairs(self.waitTrigger) do
    self:CheckNeedWaitTriggerGuide(v.triggerType, v.triggerParam)
  end
end

function GuideManager:GetPrologueOwnNumTriggerGuide()
  return self.specialTriggerGuide[GuideTriggerType.PrologueOwnNum]
end

function GuideManager:DeleteWaitLongDelayTimer()
  if self.waitLongDelayTimer ~= nil then
    self.waitLongDelayTimer:Stop()
    self.waitLongDelayTimer = nil
  end
end

function GuideManager:AddWaitLongDelayTimer(time)
  self:DeleteWaitLongDelayTimer()
  if self.waitLongDelayTimer == nil then
    self.waitLongDelayTimer = TimerManager:GetInstance():GetTimer(time, self.wait_long_delay_timer_callback, self, true, false, false)
    self.waitLongDelayTimer:Start()
  end
end

function GuideManager:WaitLongDelayTimerCallBack()
  self:DeleteWaitLongDelayTimer()
  self:SetCurGuideId(GuideEndId)
  self:DoGuide()
end

GuideManager.__init = __init
GuideManager.__delete = __delete
GuideManager.Startup = Startup
GuideManager.InitData = InitData
GuideManager.GetSaveGuideId = GetSaveGuideId
GuideManager.SendSaveGuideMessage = SendSaveGuideMessage
GuideManager.SetCurGuideId = SetCurGuideId
GuideManager.SendLogMessage = SendLogMessage
GuideManager.InGuide = InGuide
GuideManager.GetGuideId = GetGuideId
GuideManager.AddListener = AddListener
GuideManager.RemoveListener = RemoveListener
GuideManager.DoGuide = DoGuide
GuideManager.UILoadingExitSignal = UILoadingExitSignal
GuideManager.BuildPlaceSignal = BuildPlaceSignal
GuideManager.CheckGuideComplete = CheckGuideComplete
GuideManager.CheckOpenUITriggerGuide = CheckOpenUITriggerGuide
GuideManager.OpenUISignal = OpenUISignal
GuideManager.DeleteAutoNextTimer = DeleteAutoNextTimer
GuideManager.AddAutoNextTimer = AddAutoNextTimer
GuideManager.AutoNextTimeCallBack = AutoNextTimeCallBack
GuideManager.GetCurTemplate = GetCurTemplate
GuideManager.HasClick = HasClick
GuideManager.NeedWaitLoadComplete = NeedWaitLoadComplete
GuideManager.DeleteWaitLoadTimer = DeleteWaitLoadTimer
GuideManager.AddWaitLoadTimer = AddWaitLoadTimer
GuideManager.WaitLoadCallBack = WaitLoadCallBack
GuideManager.GetGuideType = GetGuideType
GuideManager.SetCompleteNeedParam = SetCompleteNeedParam
GuideManager.GetGuideIdByTrigger = GetGuideIdByTrigger
GuideManager.GetGuideTemplateParam = GetGuideTemplateParam
GuideManager.IsCanOpenUI = IsCanOpenUI
GuideManager.QueueTimeEndSignal = QueueTimeEndSignal
GuideManager.QueueAddSignal = QueueAddSignal
GuideManager.InitTriggerGuide = InitTriggerGuide
GuideManager.GetNextGuideTemplateParam = GetNextGuideTemplateParam
GuideManager.OnClickWorldSignal = OnClickWorldSignal
GuideManager.CityGarbageResultSignal = CityGarbageResultSignal
GuideManager.OpenFogSuccessSignal = OpenFogSuccessSignal
GuideManager.BuildUpgradeFinishSignal = BuildUpgradeFinishSignal
GuideManager.GetDoneGuideEndId = GetDoneGuideEndId
GuideManager.IsDoneThisGuide = IsDoneThisGuide
GuideManager.PlayMovieCompleteSignal = PlayMovieCompleteSignal
GuideManager.CheckDoTriggerGuide = CheckDoTriggerGuide
GuideManager.SaveFinalGarbageRewardItemId = SaveFinalGarbageRewardItemId
GuideManager.GetFinalGarbageRewardItemId = GetFinalGarbageRewardItemId
GuideManager.GetSaveGuideValue = GetSaveGuideValue
GuideManager.GetCityTroopPeopleNum = GetCityTroopPeopleNum
GuideManager.SaveCityTroopPeopleNum = SaveCityTroopPeopleNum
GuideManager.IsCanCloseUI = IsCanCloseUI
GuideManager.IsCanQuitFocus = IsCanQuitFocus
GuideManager.ChapterTaskGetRewardSignal = ChapterTaskGetRewardSignal
GuideManager.IsCanDoUIMainAnim = IsCanDoUIMainAnim
GuideManager.SetNoShowUIMain = SetNoShowUIMain
GuideManager.SetCanShowBuild = SetCanShowBuild
GuideManager.IsStartCanShowBuild = IsStartCanShowBuild
GuideManager.ShowAllGuideObjectSignal = ShowAllGuideObjectSignal
GuideManager.CloseUISignal = CloseUISignal
GuideManager.CheckNeedWaitTime = CheckNeedWaitTime
GuideManager.DeleteWaitTimeTimer = DeleteWaitTimeTimer
GuideManager.AddWaitTimeTimer = AddWaitTimeTimer
GuideManager.WaitTimeCallBack = WaitTimeCallBack
GuideManager.ChapterTaskSignal = ChapterTaskSignal
GuideManager.GetDoneGuideStartId = GetDoneGuideStartId
GuideManager.IsCanBuildRoad = IsCanBuildRoad
GuideManager.CheckFirstJoinAllianceGuide = CheckFirstJoinAllianceGuide
GuideManager.AllianceApplySuccessSignal = AllianceApplySuccessSignal
GuideManager.IsStartId = IsStartId
GuideManager.GuideNoOpenUISignal = GuideNoOpenUISignal
GuideManager.SetNoOpenUI = SetNoOpenUI
GuideManager.GetCanDoGuideState = GetCanDoGuideState
GuideManager.IsCanClick = IsCanClick
GuideManager.GuideWaitMessageSignal = GuideWaitMessageSignal
GuideManager.CheckWaitMessage = CheckWaitMessage
GuideManager.MainTaskSuccessSignal = MainTaskSuccessSignal
GuideManager.DoNext = DoNext
GuideManager.LoadGuideGm = LoadGuideGm
GuideManager.DestroyGm = DestroyGm
GuideManager.SetWaitingMessage = SetWaitingMessage
GuideManager.SaveRecommendShow = SaveRecommendShow
GuideManager.GetRecommendShow = GetRecommendShow
GuideManager.BuildResourcesStartSignal = BuildResourcesStartSignal
GuideManager.OnWorldInputPointDownSignal = OnWorldInputPointDownSignal
GuideManager.SetGuideEndCallBack = SetGuideEndCallBack
GuideManager.CheckMoveToWorldGuide = CheckMoveToWorldGuide
GuideManager.CheckNoInput = CheckNoInput
GuideManager.CheckStopDub = CheckStopDub
GuideManager.CheckPlayDub = CheckPlayDub
GuideManager.StopDub = StopDub
GuideManager.PlayDub = PlayDub
GuideManager.CheckCanDragGuide = CheckCanDragGuide
GuideManager.CheckTipsWaitTime = CheckTipsWaitTime
GuideManager.DeleteTipsWaitTimeTimer = DeleteTipsWaitTimeTimer
GuideManager.AddTipsWaitTimeTimer = AddTipsWaitTimeTimer
GuideManager.TipsWaitTimeCallBack = TipsWaitTimeCallBack
GuideManager.CallBackDoGuide = CallBackDoGuide
GuideManager.ShowLog = ShowLog
GuideManager.DoJump = DoJump
GuideManager.IsDragGuide = IsDragGuide
GuideManager.SetNoGotoTime = SetNoGotoTime
GuideManager.TrainingArmySignal = TrainingArmySignal
GuideManager.ClickMuchStop = ClickMuchStop
GuideManager.BuildLackConnectSignal = BuildLackConnectSignal
GuideManager.CheckPlayerLevelGuide = CheckPlayerLevelGuide
GuideManager.UpdateScienceDataSignal = UpdateScienceDataSignal
GuideManager.IsShowBusinessBubble = IsShowBusinessBubble
GuideManager.IsShowBusinessPlane = IsShowBusinessPlane
GuideManager.GetReachJumpState = GetReachJumpState
GuideManager.DoMuchStopJumpGuide = DoMuchStopJumpGuide
GuideManager.StopAllEffectSound = StopAllEffectSound
GuideManager.RefreshObject = RefreshObject
GuideManager.IsSendBuildPlace = IsSendBuildPlace
GuideManager.IsShowPrologue = IsShowPrologue
GuideManager.ShowGuideHand = ShowGuideHand
GuideManager.RemoveGuideHand = RemoveGuideHand
GuideManager.LookBackToCharacter = LookBackToCharacter
GuideManager.HospitalUpdateSignal = HospitalUpdateSignal
GuideManager.CheckTreatSoldierGuide = CheckTreatSoldierGuide
GuideManager.IsCanShowQuest = IsCanShowQuest
GuideManager.GetFakeQuest = GetFakeQuest
GuideManager.ClearFakeQuest = ClearFakeQuest
GuideManager.GetSpaceManExtraNum = GetSpaceManExtraNum
GuideManager.SaveSpaceManExtraNum = SaveSpaceManExtraNum
GuideManager.CanShowLandLockBubble = CanShowLandLockBubble
GuideManager.InitSpecialTrigger = InitSpecialTrigger
GuideManager.GetPveTriggerGuide = GetPveTriggerGuide
GuideManager.GetSpecialTriggerPara = GetSpecialTriggerPara
GuideManager.SetLandLockBubbleActive = SetLandLockBubbleActive
GuideManager.OnScienceQueueResearchSignal = OnScienceQueueResearchSignal
GuideManager.IsFactoryFirstFreeSpeed = IsFactoryFirstFreeSpeed
GuideManager.IsCanShowReward = IsCanShowReward
GuideManager.StartAttackMonsterWithoutMsgTipSignal = StartAttackMonsterWithoutMsgTipSignal
GuideManager.SetSuccessMarchFlag = SetSuccessMarchFlag
GuideManager.IsShowRadarBubble = IsShowRadarBubble
GuideManager.IsShowWorldCollectPoint = IsShowWorldCollectPoint
GuideManager.IsPrologueCanAttack = IsPrologueCanAttack
GuideManager.IsGuideArrowType = IsGuideArrowType
GuideManager.CheckLoginGuide = CheckLoginGuide
GuideManager.UpdateAlCanBeLeaderSignal = UpdateAlCanBeLeaderSignal
GuideManager.GetGuideBgmName = GetGuideBgmName
GuideManager.GarbageCollectStartSignal = GarbageCollectStartSignal
GuideManager.SendLogToNet = SendLogToNet
GuideManager.CheckNeedWaitTriggerGuide = CheckNeedWaitTriggerGuide
GuideManager.AddOneWaitTrigger = AddOneWaitTrigger
GuideManager.RemoveOneWaitTrigger = RemoveOneWaitTrigger
GuideManager.DoWaitTriggerAfterBack = DoWaitTriggerAfterBack
return GuideManager
