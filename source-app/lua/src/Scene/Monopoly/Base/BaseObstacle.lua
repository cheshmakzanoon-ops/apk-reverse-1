local base = require("Scene.Monopoly.Base.BaseObject")
local BaseObstacle = BaseClass("BaseObstacle", base)
local Placeality = require("Scene.Monopoly.Placeality.Placeality")
local Const = require("Scene.Monopoly.Const")
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local PlacealityBubbleTip = require("Scene.Monopoly.Placeality.Bubble.PlacealityBubbleTip")

function BaseObstacle:ArrivalBefore()
  self:ShowObstacleByType(MonplolyObstacleShowCondition.Every)
  self:CreatePlaceality()
end

function BaseObstacle:OnInit()
  self.delayList = {}
  self.initModel = false
  self.ObstableRelatedAppearanceVisible = nil
end

function BaseObstacle:OnDelete()
  for i, v in pairs(self.delayList) do
    if v then
      v:Stop()
    end
  end
  if self.tileEffectRes then
    self.tileEffectRes:Destroy()
  end
  if self.battleEffectRes then
    self.battleEffectRes:Destroy()
    if not IsNull(self.battleEffectTrigger) then
      self.battleEffectTrigger.onPointerClick = nil
      self.battleEffectTrigger = nil
    end
  end
  if self.placealityDelay then
    self.placealityDelay:Stop()
    self.placealityDelay = nil
  end
  if self.battleEffDelay then
    self.battleEffDelay:Stop()
    self.battleEffDelay = nil
  end
  self:DestroyObstacleRes()
  self:ClearBubble()
  self.ObstableRelatedAppearanceVisible = nil
  self.initModel = false
end

function BaseObstacle:GetEffectPath()
  local topPath
  if not string.IsNullOrEmpty(self.data.top_effect_path) then
    topPath = self.data.top_effect_path
  end
  if self.data.eventType == 4 then
    return Const.boxBottomEffectPath, topPath or Const.boxTopEffectPath
  else
    return Const.battleBottomEffectPath, topPath or Const.battleTopEffectPath
  end
end

function BaseObstacle:ShowBattleEffectObj()
  if self.data.state ~= MonopolyPlacealityType.Arrive then
    return
  end
  local effectActive = true
  if self.ObstableRelatedAppearanceVisible ~= nil then
    effectActive = self.ObstableRelatedAppearanceVisible
  end
  local patch1, patch2 = self:GetEffectPath()
  if self.tileEffectRes == nil then
    self.tileEffectRes = self:CreateObject(patch1, function(req)
      local pos = self.data:GetCenterWorldPos()
      req.gameObject.transform:Set_position(pos.x, pos.y + 0.3, pos.z)
      req.gameObject.transform:SetParent(self.mgr.parent.transform)
      self.tileEffect = req.gameObject
      self.tileEffect:SetActive(effectActive)
    end)
  end
  if self.battleEffectRes == nil then
    self.battleEffectRes = self:CreateObject(patch2, function(req)
      local pos = self.data:GetCenterWorldPos()
      self.battleEffect = req.gameObject
      self.battleEffect:SetActive(effectActive)
      req.gameObject.transform:Set_position(pos.x, pos.y + self.modelHeight + 2.5, pos.z)
      self.battleEffectTrigger = req.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
      if self.battleEffectTrigger then
        function self.battleEffectTrigger.onPointerClick()
          self:OnBattleEffectTriggerClick()
        end
      end
    end)
  end
  self:RefreshBubble()
end

function BaseObstacle:RefreshBattleEffect()
end

function BaseObstacle:RefreshBubble()
  local unlock, buildId, buildLevel = self.data:IsUnLockPlaceality()
  if unlock then
    self:ClearBubble()
  elseif self.bubbleRes == nil then
    self.bubbleRes = self:CreateObject("Assets/Main/Prefabs/UI/Monopoly/PlacealityBubbleTip.prefab", function(req)
      if self.bubble ~= nil then
        self.bubble:OnDestroy()
        self.bubble.request:Destroy()
      end
      self.bubble = PlacealityBubbleTip.New()
      self.bubble:OnCreate(req)
      if self.bubbleParam == nil then
        local pos = self.data:GetCenterWorldPos()
        local param = {}
        param.bgScale = Vector3.New(2, 2, 2)
        param.pos = pos
        self.bubbleParam = param
      end
      self.bubbleParam.buildId = buildId
      self.bubbleParam.buildLevel = buildLevel
      self.bubble:ReInit(self.bubbleParam)
    end)
  elseif self.bubble ~= nil and self.bubbleParam ~= nil and (self.bubbleParam.buildId ~= buildId or self.bubbleParam.buildLevel ~= buildLevel) then
    self.bubbleParam.buildId = buildId
    self.bubbleParam.buildLevel = buildLevel
    self.bubble:ReInit(self.bubbleParam)
  end
end

function BaseObstacle:ClearBubble()
  if self.bubbleRes then
    self.bubbleRes:Destroy()
    self.bubbleRes = nil
  end
  if self.bubble ~= nil then
    self.bubble:OnDestroy()
    self.bubble.request:Destroy()
    self.bubble = nil
  end
  self.bubbleParam = nil
end

function BaseObstacle:IsLock()
  if self.data.needBuild ~= nil and #self.data.needBuild > 0 then
    if self.data.needBuild[1].buildId == -1000 then
      UIUtil.ShowTipsId("city_unlock_tips_1")
      return true
    end
    for _, v in ipairs(self.data.needBuild) do
      if not DataCenter.BuildManager:HasBuildByIdAndLevel(v.buildId, v.level) then
        local buildingTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(v.buildId)
        UIUtil.ShowTips(Localization:GetString(800371, Localization:GetString(buildingTemplate.name), v.level))
        local dataList = DataCenter.BuildManager:GetBuildingDatasByBuildingId(v.buildId)
        if dataList and 0 < #dataList and dataList[1] then
          GoToUtil.GotoPos(dataList[1]:GetCenterVec(), CS.SceneManager.World.InitZoom, 0.5, function()
            local uiPos = CS.CSUtils.WorldPositionToUISpacePosition(dataList[1]:GetCenterVec())
            local param = {}
            param.position = Vector3.New(uiPos.x, uiPos.y, uiPos.z)
            param.arrowType = ArrowType.Building
            param.positionType = PositionType.Screen
            param.isPanel = false
            DataCenter.ArrowManager:ShowArrow(param)
          end)
        else
          local obj = DataCenter.MonopolyManager:GetMinLandRewardObj()
          if obj then
            GoToUtil.GotoPos(obj.transform.position, CS.SceneManager.World.InitZoom, 0.5, function()
              local uiPos = CS.CSUtils.WorldPositionToUISpacePosition(obj.transform.position)
              local param = {}
              param.position = Vector3.New(uiPos.x, uiPos.y, uiPos.z)
              param.arrowType = ArrowType.Building
              param.positionType = PositionType.Screen
              param.isPanel = false
              DataCenter.ArrowManager:ShowArrow(param)
            end)
          end
        end
        return true
      end
    end
  end
  local seasonTimeCondition, openSeasonId, openSeasonPassDay = self.data:CheckSeasonOpenCondition()
  if not seasonTimeCondition then
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString("monopoly_time_condition_tips", openSeasonId, openSeasonPassDay))
    return true
  end
end

function BaseObstacle:OnBattleEffectTriggerClick()
  if self:IsLock() then
    return
  end
  if self.data.plot_before ~= nil and not string.IsNullOrEmpty(tostring(self.data.plot_before)) then
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
      plotGroupId = tonumber(self.data.plot_before),
      hideMainUI = true
    })
  else
    self:Fire()
  end
end

function BaseObstacle:Morph()
  self:DestroyObstacleRes()
  if self.data and not string.IsNullOrEmpty(self.data.pawn_after) then
    self:CreatedModel(nil, self.data.pawn_after, true)
  end
end

function BaseObstacle:DestroyObstacleRes()
  if not IsNull(self.modelTrigger) then
    self.modelTrigger.onPointerClick = nil
    self.modelTrigger = nil
  end
  if self.obstacleRes then
    self.obstacleRes:Destroy()
    self.transform = nil
    self.gameObject = nil
    self.simpleAnim = nil
    self.modelHeight = 0
    self.effectNode = nil
  end
  self.arrivalTime = nil
end

function BaseObstacle:Fire()
end

function BaseObstacle:Arrive()
  self.arrivalTime = Time.realtimeSinceStartup
  self:ShowObstacleByType(MonplolyObstacleShowCondition.Every)
  self:ShowObstacleByType(MonplolyObstacleShowCondition.ReMove)
end

function BaseObstacle:UnLandLock(callBack)
  if self.placeality then
    local time = self.placeality:GetClicpLength("rotate")
    self.placeality:PlayAnim("rotate")
    self.placealityDelay = TimerManager:GetInstance():DelayInvoke(function()
      if callBack then
        callBack()
      end
      if self.data then
        local pos = self.data:GetCenterWorldPos()
        self.mgr.effectMgr:ShowEffectObj(Const.deleteEffectPath, pos)
        self.mgr:DestroyById(self.data.id)
      end
    end, time)
  end
end

function BaseObstacle:GetRotateClipLength()
  return self.placeality and self.placeality:GetClicpLength("rotate") or 0
end

function BaseObstacle:LandLockObstacleShow()
  self:ShowObstacleByType(MonplolyObstacleShowCondition.UnLandLock)
end

function BaseObstacle:MainLvObstacleShow()
  self:ShowObstacleByType(MonplolyObstacleShowCondition.MainLv)
end

function BaseObstacle:CheckShowCondition(data, type)
  if (self.data.showCondition == type or self.data.showCondition == MonplolyObstacleShowCondition.Every or self.data.showCondition == MonplolyObstacleShowCondition.UnLandLock and data and DataCenter.LWCivilizationSparkExtend:MonopolyManager_getLandLockIdDiff(data.land_lock, self.data.land_lock) >= 0 or self.data.showCondition == MonplolyObstacleShowCondition.MainLv and self.data.showConditionMainLv and self.data.showConditionMainLv <= DataCenter.BuildManager:GetMainLevel() or self.data.showCondition == MonplolyObstacleShowCondition.ArriveGrid and self.data.show_condition_param and data and data.id >= self.data.show_condition_param or self.data.showCondition == MonplolyObstacleShowCondition.PlayerGo and self.data.show_condition_param and data and data.id >= self.data.show_condition_param) and self.data.state ~= MonopolyPlacealityType.Leave then
    return true
  end
  return false
end

function BaseObstacle:ShowObstacleByType(type, isShow, showIconBorn, showTimeline)
  local data = DataCenter.MonopolyManager.dataManager:GetCurData()
  if not isShow then
    if not data or not self.data then
      return
    end
    if not DataCenter.MonopolyManager:CheckObstacleVisible() then
      return
    end
  end
  if self:CheckShowCondition(data, type) then
    if self.obstacleRes == nil then
      local fun
      if self.data.pawn_show == 1 then
        function fun(req)
          self:Down()
        end
      elseif self.data.pawn_show == 3 then
        function fun(req)
          self:ShowBattleEffectObj()
          
          self:PlayAnim(Const.animNames.idle)
        end
      else
        function fun(req)
          self:Bron()
          
          if showIconBorn then
            self:TryShowIconBorn()
          end
        end
      end
      self:CreatedModel(fun)
    else
      self:ShowBattleEffectObj()
    end
  end
end

function BaseObstacle:Bron()
  if self.obstacleRes then
    if not self.data.isShow then
      self:PlayAnim(Const.animNames.born)
      self.data.isShow = true
      local length = self:GetClicpLength(Const.animNames.born)
      if length and 0 < length then
        local delay = TimerManager:GetInstance():DelayInvoke(function()
          self:PlayAnim(Const.animNames.idle)
        end, length)
        table.insert(self.delayList, delay)
      else
        self:PlayAnim(Const.animNames.idle)
      end
    end
    self:ShowBattleEffectObj()
  end
end

function BaseObstacle:TryShowIconBorn()
end

function BaseObstacle:Down()
  if not self.data.isShow then
    self.transform:Set_position(self.transform.position.x, self.transform.position.y + 20, self.transform.position.z)
    self.transform:DOMoveY(0.3, 1.5)
  end
  self:ShowObstacleCallBack()
  if self.battleEffect then
    local pos = self.data:GetCenterWorldPos()
    self.battleEffect.transform:Set_position(pos.x, pos.y + self.modelHeight + 2.5, pos.z)
  end
end

function BaseObstacle:ShowObstacleCallBack()
  self:ShowBattleEffectObj()
end

function BaseObstacle:PlayPalcealityAnim(animName)
  if self.placeality then
    self.placeality:PlayAnim(animName)
  end
end

function BaseObstacle:CreatedModel(callBack, path, ignoreModelTrigger)
  if self.obstacleRes ~= nil then
    return
  end
  local loadPath = path and path or self.data.pawn_before
  local newLoadPath = DataCenter.LWArmedUpgradeManager:TryGetJPMonopolyPawnBeforeResPath(loadPath)
  self.obstacleRes = Resource:InstantiateAsync(string.format(UIAssets.MonopolyObstacle, newLoadPath))
  self.obstacleRes:completed("+", function(req)
    local pos = self.data:GetCenterWorldPos()
    req.gameObject.transform:Set_position(pos.x, pos.y + 0.3, pos.z)
    self.transform = req.gameObject.transform
    self.gameObject = req.gameObject
    if self.ObstableRelatedAppearanceVisible == nil then
      if not self.initModel then
        self.initModel = true
        self.gameObject:SetActive(not self.data.initInvisible)
      else
        self.gameObject:SetActive(true)
      end
    else
      self.gameObject:SetActive(self.ObstableRelatedAppearanceVisible)
    end
    self.simpleAnim = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if not IsNull(self.simpleAnim) then
      if self.ObstableRelatedAppearanceVisible == false then
        self.simpleAnim.cullingMode = CS.UnityEngine.AnimatorCullingMode.AlwaysAnimate
      else
        self.simpleAnim.cullingMode = CS.UnityEngine.AnimatorCullingMode.CullCompletely
      end
    end
    self.modelTrigger = self.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
    local id = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(self.data.id)
    local data = DataCenter.MonopolyManager:GetPlacealityDataById(id)
    if data and self.data:IsRotate() then
      local pos1 = data:GetCenterWorldPos()
      local lookRot = Vector3.Normalize(pos1 - pos)
      if lookRot ~= Vector3.zero then
        lookRot = Quaternion.LookRotation(lookRot, Vector3.up)
      end
      self.transform.rotation = lookRot
    end
    self.transform:SetParent(self.mgr.parent.transform)
    if self.modelTrigger and not ignoreModelTrigger then
      function self.modelTrigger.onPointerClick()
        self:OnTriggerClick()
      end
    end
    local modelHeightCom = self.gameObject:GetComponent(typeof(CS.ModelHeight))
    if modelHeightCom then
      self.modelHeight = modelHeightCom:GetHeight()
    end
    self.effectNode = self.transform:Find("EffectNode")
    if not IsNull(self.effectNode) then
      local curLandLock = DataCenter.MonopolyManager:GetCurrentLandLock()
      local diff = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getLandLockIdDiff(self.data.land_lock, curLandLock)
      local show = 0 <= diff and diff <= 1
      self.effectNode.gameObject:SetActive(show)
    end
    self.obstacle = req.gameObject
    self:PlayAnim(Const.animNames.idle)
    if callBack then
      callBack()
    end
  end)
end

function BaseObstacle:OnTriggerClick()
  local maxUnlockEndId = DataCenter.MonopolyManager.maxUnlockEndId
  if maxUnlockEndId and maxUnlockEndId >= self.data.id then
    return
  end
  local tempData = DataCenter.MonopolyManager.dataManager:GetCurData()
  if tempData and self.data.id ~= tempData.id then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMonopolyObstacleInfo, {anim = true}, self.data)
    return
  else
    self:OnBattleEffectTriggerClick()
  end
end

function BaseObstacle:OnEventEnd()
end

function BaseObstacle:SetObstableRelatedAppearanceVisible(visible, onlyModel)
  self.ObstableRelatedAppearanceVisible = visible
  if not IsNull(self.gameObject) then
    if not IsNull(self.simpleAnim) then
      if visible then
        self.simpleAnim:Sample()
        if not IsNull(self.simpleAnim) then
          self.simpleAnim.cullingMode = CS.UnityEngine.AnimatorCullingMode.CullCompletely
        end
      else
        self.simpleAnim.cullingMode = CS.UnityEngine.AnimatorCullingMode.AlwaysAnimate
      end
    end
    self.gameObject:SetActive(visible)
  end
  if not IsNull(self.battleEffect) and not onlyModel then
    self.battleEffect:SetActive(visible)
  end
  if not IsNull(self.tileEffect) and not onlyModel then
    self.tileEffect:SetActive(visible)
  end
end

function BaseObstacle:Occupy()
  if self.placeality then
    self.placeality:DeleteMoveEffect()
    self.placeality:ShowOccupyEffect()
  end
  self:DestroyObstacleRes()
  self:ChangeState(MonopolyPlacealityType.Leave)
  self.data.state = MonopolyPlacealityType.Leave
end

function BaseObstacle:CreatePlaceality()
  if self.placeality == nil then
    self.placeality = Placeality.New(self.mgr, self)
    self.placeality:SetData(self.data)
    self.placeality:CreatedModel()
  end
end

function BaseObstacle:OnRefreshManifestation()
  self:CreatePlaceality()
end

return BaseObstacle
