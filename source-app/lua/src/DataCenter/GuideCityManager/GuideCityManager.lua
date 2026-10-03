local GuideCityManager = BaseClass("GuideCityManager")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local Data = CS.GameEntry.Data

local function __init(self)
  self.formationParam = nil
  self.useGuideTimelineMarker = false
  self.info = {}
  self.isUnlockFog = false
  self.cityGarbageRoot = nil
  self.cityRoot = nil
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  self.formationParam = nil
  self.useGuideTimelineMarker = nil
  self.info = nil
  self.isUnlockFog = nil
  self.cityGarbageRoot = nil
  self.cityRoot = nil
end

local function CityWorldFightHandle(self, message)
  if message.errorCode == nil then
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
  end
end

local function SetFormationParam(self, param)
  self.formationParam = param
end

local function MoveCityToWorldHandle(self, message)
  DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.MoveCityToWorld, nil)
  if message.errorCode == nil then
    if message.worldMainPoint ~= nil then
      LuaEntry.Player:SetMainWorldPointId(message.worldMainPoint)
    end
    if message.newUserWorld ~= nil then
      DataCenter.BuildManager:SetNewUserWorld(message.newUserWorld)
    end
    if message.allianceBornPoint ~= nil then
      DataCenter.GuideManager:SendSaveGuideMessage(AllianceBornPoint, tostring(message.allianceBornPoint))
    end
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

local function CityPickGarbageFinishHandle(self, message)
  if message.errorCode == nil then
    local uuid = message.uuid
    local signal = SFSObject.New()
    signal:PutLong("uuid", uuid)
    local itemId
    local rewardList = {}
    if message.reward ~= nil then
      rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward)
      for k, v in pairs(message.reward) do
        if v.value ~= nil and type(v.value) == "table" and v.value.itemId ~= nil then
          itemId = v.value.itemId
          DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PickUpGarbageItem, tostring(v.value.itemId))
        end
        local rewardType = v.type
        if rewardType == RewardType.GOODS then
          DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PickUpGarbageItem, rewardType .. "," .. v.value.itemId)
        elseif rewardType == RewardType.OIL or rewardType == RewardType.METAL or rewardType == RewardType.WATER or rewardType == RewardType.FLINT or rewardType == RewardType.OBSIDIAN or rewardType == RewardType.FOOD then
          DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PickUpGarbageItem, rewardType .. "," .. rewardType)
        elseif rewardType == RewardType.RESOURCE_ITEM then
          DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PickUpGarbageItem, rewardType .. "," .. v.value.itemId)
        end
      end
      TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.RewardManager:AddRewardsAndRes(message)
      end, 1.5)
      signal:PutInt("result", CityGarbageResult.Reward)
    else
      signal:PutInt("result", CityGarbageResult.None)
    end
    if itemId ~= nil then
      DataCenter.GuideManager:SaveFinalGarbageRewardItemId(itemId)
    end
    local info = DataCenter.CityPointDataManager:GetPointDataByUuid(uuid)
    local pointId = -1
    if info ~= nil then
      signal:PutInt("pointId", info.pointId)
      pointId = info.pointId
    end
    self.info = info
    DataCenter.CityPointDataManager:RemovePointDataByUuid(uuid)
    EventManager:GetInstance():Broadcast(EventId.CityGarbageResult, signal)
    if not self:IsZeroBaseLevel() and 0 < pointId and rewardList ~= nil and 0 < #rewardList then
      local worldPos = SceneUtils.TileIndexToWorld(pointId)
      local screenPos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
      if 0 > screenPos.x or screenPos.x > Screen.width or 0 > screenPos.y or screenPos.y > Screen.height then
      else
        table.walk(rewardList, function(_, v)
          local pic = DataCenter.RewardManager:GetPicByType(v.rewardType, v.itemId)
          local flyPos = Vector3:New(0, 0, 0)
          local num = v.count
          num = math.max(num, 1)
          if v.rewardType == RewardType.OIL or v.rewardType == RewardType.METAL or v.rewardType == RewardType.WATER or v.rewardType == RewardType.ELECTRICITY or v.rewardType == RewardType.FOOD or v.rewardType == RewardType.FLINT or v.rewardType == RewardType.OBSIDIAN then
            local param = {}
            param.resType = RewardToResType[v.rewardType]
            param.rewardTyp = tonumber(v.rewardType)
            param.num = num
            param.pic = pic
            param.screenPos = screenPos
            param.flyPos = flyPos
            EventManager:GetInstance():Broadcast(EventId.ShowPickGarbageResource, param)
          else
            UIUtil.DoFly(tonumber(RewardType.GOODS), num, pic, screenPos, flyPos)
          end
        end)
      end
    end
    if not DataCenter.GuideManager:InGuide() then
      local chapterCount = DataCenter.ChapterTaskManager:GetAllNum()
      if 0 < chapterCount then
        local fogId = Data.Fog:GetFogIndexByPointId(pointId)
        local openList = Data.Fog:GetCanOpenNeighbourFogIds(fogId)
        if 0 < openList.Count then
          self.isUnlockFog = true
          return
        end
        local chapterlist = DataCenter.ChapterTaskManager:GetAllChapterTask()
        for i = 1, #chapterlist do
          local template = DataCenter.QuestTemplateManager:GetQuestTemplate(chapterlist[i].id)
          if template ~= nil then
            if tonumber(template.gotype2) == QuestGoType.CollectGarbage and chapterlist[i].state == TaskState.NoComplete and template.para1 == 0 then
              local resPoint = DataCenter.CityPointDataManager:SearchGarbagePointData(info.pointId)
              if resPoint ~= nil then
                EventManager:GetInstance():Broadcast(EventId.RefreshGarbageTask, true)
                WorldArrowManager:GetInstance():ShowArrowEffect(0, SceneUtils.TileIndexToWorld(resPoint.pointId), ArrowType.Guide_Garbage)
                break
              end
            else
              EventManager:GetInstance():Broadcast(EventId.RefreshGarbageTask, false)
            end
          end
        end
      end
    end
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
  end
end

local function RefreshGuideSignal()
  local chapterCount = DataCenter.ChapterTaskManager:GetAllNum()
  if not DataCenter.GuideManager:InGuide() and 0 < chapterCount then
    local chapterlist = DataCenter.ChapterTaskManager:GetAllChapterTask()
    for i = 1, #chapterlist do
      local template = DataCenter.QuestTemplateManager:GetQuestTemplate(chapterlist[i].id)
      if template ~= nil then
        if tonumber(template.gotype2) == QuestGoType.CollectGarbage and chapterlist[i].state == TaskState.NoComplete and template.para1 == 0 then
          local resPoint = DataCenter.CityPointDataManager:SearchGarbagePointData(DataCenter.GuideCityManager.info.pointId)
          if resPoint ~= nil then
            EventManager:GetInstance():Broadcast(EventId.RefreshGarbageTask, true)
            WorldArrowManager:GetInstance():ShowArrowEffect(0, SceneUtils.TileIndexToWorld(resPoint.pointId), ArrowType.Guide_Garbage)
            break
          end
        else
          EventManager:GetInstance():Broadcast(EventId.RefreshGarbageTask, false)
        end
      end
    end
  end
end

local function PushCityFightResultHandle(self, message)
  if message.result ~= nil then
    local fightResult = message.result
    if fightResult == CityFightResult.Success then
      UIUtil.ShowTipsId(GameDialogDefine.WIN)
    elseif fightResult == CityFightResult.Fail then
      UIUtil.ShowTipsId(GameDialogDefine.FAIL)
    end
    local uuid = message.targetUuid
    local info = DataCenter.CityPointDataManager:GetPointDataByUuid(uuid)
    if info ~= nil and fightResult == CityFightResult.Success then
      CS.SceneManager.World:RemoveOneObjectByPointType(info.pointId, 4)
      DataCenter.CityPointDataManager:RemovePointDataByUuid(uuid)
    end
    local signal = SFSObject.New()
    signal:PutLong("uuid", uuid)
    signal:PutInt("result", fightResult)
    EventManager:GetInstance():Broadcast(EventId.CityFightResult, signal)
  end
end

local function SendCityWorldFight(self, uuid, formationUuid)
  if self.formationParam ~= nil then
    local param = {}
    param.targetUuid = uuid
    param.formationUuid = formationUuid
    param.formationParam = self.formationParam
    SFSNetwork.SendMessage(MsgDefines.CityWorldFight, param)
  else
    self:AutoAddSoldierForNewTroop(uuid)
  end
end

local function AutoAddSoldierForNewTroop(self, targetUuid)
  local values = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
  local formationUuid = 0
  table.walk(values, function(k, v)
    if v.uuid ~= 0 and formationUuid == 0 then
      formationUuid = v.uuid
    end
  end)
  if formationUuid ~= 0 then
    DataCenter.ArmyFormationDataManager:AutoInitFormationData(formationUuid)
    local hasHero = false
    local hasSolider = false
    local curSoldiers = {}
    local curHeroes = {}
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
    if formation ~= nil then
      curSoldiers = formation.soldiers
      curHeroes = formation.heroes
      table.walk(curSoldiers, function(k, v)
        if 0 < v then
          hasSolider = true
        end
      end)
      table.walk(curHeroes, function(k, v)
        if k ~= 0 then
          hasHero = true
        end
      end)
      if hasHero and hasSolider then
        local sfsObj = SFSObject.New()
        sfsObj:PutLong("uuid", formationUuid)
        local formationArray = SFSArray.New()
        table.walk(curSoldiers, function(k, v)
          local obj = SFSObject.New()
          obj:PutUtfString("armyId", k)
          obj:PutInt("count", v)
          formationArray:AddSFSObject(obj)
        end)
        sfsObj:PutSFSArray("formations", formationArray)
        local heroArray = SFSArray.New()
        table.walk(curHeroes, function(k, v)
          local obj = SFSObject.New()
          obj:PutLong("heroUuid", k)
          obj:PutInt("index", v)
          heroArray:AddSFSObject(obj)
        end)
        sfsObj:PutSFSArray("heroInfos", heroArray)
        self.formationParam = sfsObj
        local param = {}
        param.targetUuid = targetUuid
        param.formationUuid = formationUuid
        param.formationParam = self.formationParam
        SFSNetwork.SendMessage(MsgDefines.CityWorldFight, param)
      else
        UIUtil.ShowTipsId(GameDialogDefine.ADD_SOLDIER)
      end
    end
  end
end

local function SendCityPickGarbageFinish(self, uuid)
  local param = {}
  param.uuid = uuid
  DataCenter.GuideManager.currentGetRewardGarbage = uuid
  SFSNetwork.SendMessage(MsgDefines.CityPickGarbage, param)
end

local function TimelineMarker0(self)
  local template = DataCenter.GuideManager:GetCurTemplate()
  if template ~= nil and (template.type == GuideType.PlayMovie or template.type == GuideType.WaitMovieComplete) then
    local para2 = template.para2
    if para2 ~= nil then
      DataCenter.GuideManager:SetCurGuideId(tonumber(template.para2))
      DataCenter.GuideManager:DoGuide()
    end
  end
end

local function TimelineMarker1(self)
  self.useGuideTimelineMarker = false
  if self.newbieTimeline ~= nil then
    self.newbieTimeline:Destroy()
    self.newbieTimeline = nil
    self.newbieTimeline_IsContinue = nil
  end
  DataCenter.BuildBubbleManager:ShowBubbleNode()
  CS.SceneManager.World.Enabled = true
  CityPioneerFog:GetInstance():SetFogVisible(true)
  CS.SceneManager.World:SetTouchInputControllerEnable(true)
  local sfsParam = {}
  sfsParam.queueList = {}
  local list = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Field)
  for k, v in pairs(list) do
    table.insert(sfsParam.queueList, k)
  end
  SFSNetwork.SendMessage(MsgDefines.FreeSpeedQueue, sfsParam)
  EventManager:GetInstance():Broadcast(EventId.FarmGuideFakePlantShowState, true)
  DataCenter.GuideManager:SetNoShowUIMain(false)
  local template = DataCenter.GuideManager:GetCurTemplate()
  if template ~= nil and (template.type == GuideType.PlayMovie or template.type == GuideType.WaitMovieComplete) then
    DataCenter.GuideManager:DoNext()
  end
end

local function OnTimelineMarker(id)
  if DataCenter.GuideCityManager.useGuideTimelineMarker then
    if id == GuideTimeLineShowMarkerType.Zero then
      DataCenter.GuideCityManager:TimelineMarker0()
    elseif id == GuideTimeLineShowMarkerType.One then
      DataCenter.GuideCityManager:TimelineMarker1()
    end
  end
end

local function PlayTimeline(self)
  EventManager:GetInstance():Broadcast(EventId.FarmGuideFakePlantShowState, false)
  DataCenter.GuideManager:SetNoShowUIMain(true)
  DataCenter.BuildBubbleManager:HideBubbleNode()
  self.newbieTimeline = ResourceManager:InstantiateAsync(UIAssets.UIGuideJianzhangTimeline)
  self.newbieTimeline:completed("+", function()
    CS.SceneManager.World.Enabled = false
    CityPioneerFog:GetInstance():SetFogVisible(false)
    CS.SceneManager.World:SetTouchInputControllerEnable(false)
    self.newbieTimeline.gameObject.transform.position = Vector3.New(97, 0, 81)
    self.isTimelineContinue = false
    local timeline = self.newbieTimeline.gameObject:GetComponentInChildren(typeof(CS.GuideTimelineMarker))
    
    function self.newbieTimeline_IsContinue()
      return self.isTimelineContinue
    end
    
    timeline.IsContinue = self.newbieTimeline_IsContinue
    self.useGuideTimelineMarker = true
  end)
end

local function SetTimeLineContinuePlay(self)
  self.isTimelineContinue = true
end

local function StartMoveCityTroop(self, targetPos)
  local pos = CS.GameEntry.Setting:GetPrivateInt(SettingKeys.CITY_TROOP_POSITION, -1)
  if 0 <= pos then
    EventManager:GetInstance():Broadcast(EventId.CityTroopMove, targetPos)
  else
    local newPosV2 = CS.UnityEngine.Vector2Int(50, 47)
    local createPos = SceneUtils.TilePosToIndex(newPosV2)
    CS.GameEntry.Setting:SetPrivateInt(SettingKeys.CITY_TROOP_POSITION, createPos)
    CS.SceneManager.World:LoadCityTroop(createPos, targetPos)
  end
end

local function IsZeroBaseLevel(self)
  return DataCenter.BuildManager.MainLv == 0
end

local function PushCityPointRefreshHandle(self, message)
  DataCenter.CityPointDataManager:UpdateData(message)
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.GuideTimelineMarker, self.OnTimelineMarker)
  EventManager:GetInstance():AddListener(EventId.RefreshGuide, self.RefreshGuideSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.GuideTimelineMarker, self.OnTimelineMarker)
  EventManager:GetInstance():RemoveListener(EventId.RefreshGuide, self.RefreshGuideSignal)
end

local function RefreshCityGarbageHandle(self, message)
  DataCenter.CityPointDataManager:UpdateData(message)
end

local function CityPickGarbageHandle(self, message)
  if message.cityPoint ~= nil then
    local pointId = message.cityPoint.pointId
    DataCenter.CityPointDataManager:RemovePointDataByPointId(pointId)
    CS.SceneManager.World:RemoveObjectByPoint(pointId)
    DataCenter.CityPointDataManager:SetPointDataByUuid(message.cityPoint.uuid, message.cityPoint)
    local signal = SFSObject.New()
    signal:PutLong("uuid", message.cityPoint.uuid)
    signal:PutInt("result", CityGarbageResult.Reward)
    signal:PutInt("pointId", pointId)
    EventManager:GetInstance():Broadcast(EventId.CityGarbageResult, signal)
    EventManager:GetInstance():Broadcast(EventId.RefreshGarbageTask, true)
  end
end

local function ReceiveCityGarbageRewardHandle(self, message)
  if message.errorCode == nil then
    local uuid = message.uuid
    local signal = SFSObject.New()
    signal:PutLong("uuid", uuid)
    local itemId
    local rewardList = {}
    if message.reward ~= nil then
      rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward)
      for k, v in pairs(message.reward) do
        if v.value ~= nil and type(v.value) == "table" and v.value.itemId ~= nil then
          itemId = v.value.itemId
          DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PickUpGarbageItem, tostring(v.value.itemId))
        end
        local rewardType = v.type
        if rewardType == RewardType.GOODS then
          DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PickUpGarbageItem, rewardType .. "," .. v.value.itemId)
        elseif rewardType == RewardType.OIL or rewardType == RewardType.METAL or rewardType == RewardType.WATER or rewardType == RewardType.FOOD or rewardType == RewardType.FLINT or rewardType == RewardType.OBSIDIAN then
          DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PickUpGarbageItem, rewardType .. "," .. rewardType)
        elseif rewardType == RewardType.RESOURCE_ITEM then
          DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PickUpGarbageItem, rewardType .. "," .. v.value.itemId)
        end
      end
      TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.RewardManager:AddRewardsAndRes(message)
      end, 1.5)
      signal:PutInt("result", CityGarbageResult.Reward)
    else
      signal:PutInt("result", CityGarbageResult.None)
    end
    if itemId ~= nil then
      DataCenter.GuideManager:SaveFinalGarbageRewardItemId(itemId)
    end
    local info = DataCenter.CityPointDataManager:GetPointDataByUuid(uuid)
    local pointId = -1
    if info ~= nil then
      signal:PutInt("pointId", info.pointId)
      pointId = info.pointId
    end
    self.info = info
    DataCenter.CityPointDataManager:RemovePointDataByUuid(uuid)
    EventManager:GetInstance():Broadcast(EventId.CityGarbageResult, signal)
    if not self:IsZeroBaseLevel() and 0 < pointId and rewardList ~= nil and 0 < #rewardList then
      local worldPos = SceneUtils.TileIndexToWorld(pointId)
      local screenPos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
      if 0 > screenPos.x or screenPos.x > Screen.width or 0 > screenPos.y or screenPos.y > Screen.height then
      else
        table.walk(rewardList, function(_, v)
          local pic = DataCenter.RewardManager:GetPicByType(v.rewardType, v.itemId)
          local flyPos = Vector3:New(0, 0, 0)
          local num = v.count
          if v.rewardType == RewardType.OIL or v.rewardType == RewardType.METAL or v.rewardType == RewardType.WATER or v.rewardType == RewardType.ELECTRICITY or v.rewardType == RewardType.FOOD or v.rewardType == RewardType.FLINT or v.rewardType == RewardType.OBSIDIAN then
            local param = {}
            param.resType = RewardToResType[v.rewardType]
            param.rewardTyp = tonumber(v.rewardType)
            param.num = num
            param.pic = pic
            param.screenPos = screenPos
            param.flyPos = flyPos
            param.useTextFormat = true
            EventManager:GetInstance():Broadcast(EventId.ShowPickGarbageResource, param)
          else
            UIUtil.DoFly(tonumber(RewardType.GOODS), num, pic, screenPos, flyPos, 80, 80, nil, true)
          end
        end)
      end
    end
    if not DataCenter.GuideManager:InGuide() then
      local chapterCount = DataCenter.ChapterTaskManager:GetAllNum()
      if 0 < chapterCount then
        local fogId = Data.Fog:GetFogIndexByPointId(pointId)
        local openList = Data.Fog:GetCanOpenNeighbourFogIds(fogId)
        if 0 < openList.Count then
          self.isUnlockFog = true
          return
        end
        local chapterlist = DataCenter.ChapterTaskManager:GetAllChapterTask()
        for i = 1, #chapterlist do
          local template = DataCenter.QuestTemplateManager:GetQuestTemplate(chapterlist[i].id)
          if template ~= nil then
            if tonumber(template.gotype2) == QuestGoType.CollectGarbage and chapterlist[i].state == TaskState.NoComplete and template.para1 == 0 then
              local resPoint = DataCenter.CityPointDataManager:SearchGarbagePointData(info.pointId)
              if resPoint ~= nil then
                EventManager:GetInstance():Broadcast(EventId.RefreshGarbageTask, true)
                WorldArrowManager:GetInstance():ShowArrowEffect(0, SceneUtils.TileIndexToWorld(resPoint.pointId), ArrowType.Guide_Garbage)
                break
              end
            else
              EventManager:GetInstance():Broadcast(EventId.RefreshGarbageTask, false)
            end
          end
        end
      end
    end
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
  end
end

local function SetCityRoot(self, nodeList)
  self.cityRoot = nodeList
  self:RefreshCityRootActive()
end

local function RefreshCityRootActive(self)
  local isShow = not CSharpCallLuaInterface.CanShowLandLock()
  if self.cityRoot ~= nil then
    for k, v in ipairs(self.cityRoot) do
      v.gameObject:SetActive(isShow)
    end
  end
end

local function SetCityRootActive(self, visible)
  if self.cityRoot ~= nil then
    for k, v in ipairs(self.cityRoot) do
      v.gameObject:SetActive(visible)
    end
  end
end

GuideCityManager.__init = __init
GuideCityManager.__delete = __delete
GuideCityManager.CityWorldFightHandle = CityWorldFightHandle
GuideCityManager.MoveCityToWorldHandle = MoveCityToWorldHandle
GuideCityManager.CityPickGarbageFinishHandle = CityPickGarbageFinishHandle
GuideCityManager.RefreshGuideSignal = RefreshGuideSignal
GuideCityManager.PushCityFightResultHandle = PushCityFightResultHandle
GuideCityManager.SendCityWorldFight = SendCityWorldFight
GuideCityManager.SendCityPickGarbageFinish = SendCityPickGarbageFinish
GuideCityManager.TimelineMarker0 = TimelineMarker0
GuideCityManager.TimelineMarker1 = TimelineMarker1
GuideCityManager.OnTimelineMarker = OnTimelineMarker
GuideCityManager.PlayTimeline = PlayTimeline
GuideCityManager.SetTimeLineContinuePlay = SetTimeLineContinuePlay
GuideCityManager.SetFormationParam = SetFormationParam
GuideCityManager.StartMoveCityTroop = StartMoveCityTroop
GuideCityManager.AutoAddSoldierForNewTroop = AutoAddSoldierForNewTroop
GuideCityManager.IsZeroBaseLevel = IsZeroBaseLevel
GuideCityManager.PushCityPointRefreshHandle = PushCityPointRefreshHandle
GuideCityManager.AddListener = AddListener
GuideCityManager.RemoveListener = RemoveListener
GuideCityManager.RefreshCityGarbageHandle = RefreshCityGarbageHandle
GuideCityManager.CityPickGarbageHandle = CityPickGarbageHandle
GuideCityManager.ReceiveCityGarbageRewardHandle = ReceiveCityGarbageRewardHandle
GuideCityManager.SetCityRoot = SetCityRoot
GuideCityManager.RefreshCityRootActive = RefreshCityRootActive
GuideCityManager.SetCityRootActive = SetCityRootActive
return GuideCityManager
