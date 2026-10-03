local CallerUnit = require("Scene.CityVisitor.Visitors.VisitorUnit")
local base = CallerUnit
local VisitorGift = BaseClass("VisitorGift", CallerUnit)
local Const = require("Scene.CityVisitor.Const")

function VisitorGift:FinishVisitor()
  local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)
  local mainEntryPos
  if buildDataList and buildDataList[1] and buildDataList[1].pointId and CS.SceneManager.World then
    local mainCityObj = CS.SceneManager.World:GetBuildingByPoint(buildDataList[1].pointId)
    if mainCityObj and mainCityObj.gameObject then
      local mainEntryTrans = mainCityObj.gameObject.transform:Find("ModelGo/point/p_entry")
      if not IsNull(mainEntryTrans) then
        mainEntryPos = Vector3.New(mainEntryTrans.position.x, mainEntryTrans.position.y, mainEntryTrans.position.z)
      end
    end
  end
  self.isFinish = true
  if self.visitorData and tonumber(self.visitorData.type) == Const.VisitorType.SURVIVOR_PACK_GiFT then
    local buildData = DataCenter.BuildManager and DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_TALENT_HALL)
    local target
    if buildData and buildData.pointId and CS.SceneManager.World then
      local cityObj = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
      if cityObj and cityObj.gameObject then
        local trans = cityObj.gameObject.transform:Find("ModelGo/point/p_entry")
        if not IsNull(trans) then
          target = Vector3.New(trans.position.x, trans.position.y, trans.position.z)
        end
      end
      if target == nil then
        target = SceneUtils.TileIndexToWorld(buildData.pointId)
      end
    end
    local inCity, outCity = DataCenter.InnerCityMapManager:GetCityDoorManager():GetDoorPos()
    if outCity == nil then
      self:SetFinishTargetPos()
    elseif target ~= nil then
      self:SetTargetEndPos({outCity, target})
    elseif mainEntryPos ~= nil then
      self:SetTargetEndPos({outCity, mainEntryPos})
    else
      self:SetFinishTargetPos()
    end
  else
    self:SetFinishTargetPos()
  end
  self:PlayAni(Const.animation.Walk)
  if self.questionIcon then
    self.questionIcon.gameObject:SetActive(false)
  elseif self.visitorData then
    Logger.LogError(string.format("visitor questionIcon cpt is nil. eventId:%s modelPath:%s", self.visitorData.eventId, self.visitorData.modelPath))
  end
  local plot = 0
  local showPlot = false
  if self.param and self.param.finishPlotList then
    local count = #self.param.finishPlotList
    if 0 < count then
      local random = math.random(1, count)
      plot = self.param.finishPlotList[random]
    end
  end
  if 0 < plot and not IsNull(self.transform) then
    if self.plotDelay then
      self.plotDelay:Stop()
    end
    local duration = 0
    local plotData = LocalController:instance():getLine("lw_plot", plot)
    if plotData then
      duration = plotData.duration or 0
    end
    if 0 < duration then
      self.plotDelay = TimerManager:GetInstance():DelayInvoke(function()
        self.plotDelay = nil
        if self.smilingFaceIcon and self.smilingFaceIcon.gameObject then
          self.smilingFaceIcon.gameObject:SetActive(true)
          if self.tipRoot then
            self.tipRoot.gameObject:SetActive(true)
          end
        end
        if self.tipRoot then
          self.delay = TimerManager:GetInstance():DelayInvoke(function()
            if self.tipRoot then
              self.tipRoot.gameObject:SetActive(false)
            end
          end, Const.showEmojiTime)
        end
      end, duration)
      showPlot = true
      if self.tipRoot then
        self.tipRoot.gameObject:SetActive(false)
      end
      local bubbleParams = {}
      bubbleParams.plotId = plot
      bubbleParams.anchor = Vector3.New(0, 3, 0)
      bubbleParams.mode = "3DFollow"
      bubbleParams.followTarget = self.transform
      EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
    end
  end
  if not showPlot then
    if self.smilingFaceIcon then
      self.smilingFaceIcon.gameObject:SetActive(true)
    end
    if self.tipRoot then
      self.tipRoot.gameObject:SetActive(true)
    end
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      if self.tipRoot then
        self.tipRoot.gameObject:SetActive(false)
      end
    end, Const.showEmojiTime)
  end
  if self.modelTrigger then
    self.modelTrigger.onPointerClick = nil
  end
  if self.trigger then
    self.trigger.onPointerClick = nil
  end
  if self.visitorData then
    DataCenter.CityVisitorManager:DeleteVisitor(self.visitorData.uid, self.visitorData.type)
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshVisitorBtnState)
end

function VisitorGift:OnTriggerClick()
  if self.visitorData and tonumber(self.visitorData.type) == VisitorType.SURVIVOR_PACK_GiFT then
    local key = self.visitorData.uid
    if key ~= nil and DataCenter and DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager.TryInvokeGiftBubbleClick and DataCenter.SurvivorPackManager:TryInvokeGiftBubbleClick(key) then
      return
    end
  end
  if not self.param then
    return
  end
  if self.visitorData.eventType and self.visitorData.eventType == VisitorType.SKY_BATTLE and not DataCenter.LWSkyBattleChapterManager:IsOpen() then
    UIUtil.ShowTipsId("plane_activity_end_tips_01")
    self:OnConfirmClick()
    return
  end
  if self.param.isNewLogic then
    base.OnTriggerClick(self)
  else
    self:OnConfirmClick()
  end
end

function VisitorGift:OnConfirmClick()
  self:OnDelayClick(function()
    if self.visitorData then
      SFSNetwork.SendMessage(MsgDefines.VisitorOperateMessage, self.visitorData.uid, 1)
    else
      UIManager.Instance:DestroyWindow(UIWindowNames.UICityVisitor, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllShow
      })
    end
  end)
end

function VisitorGift:CancelClick()
  self:OnDelayClick(function()
    if self.visitorData then
      SFSNetwork.SendMessage(MsgDefines.VisitorOperateMessage, self.visitorData.uid, 0)
    else
      UIManager.Instance:DestroyWindow(UIWindowNames.UICityVisitor, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllShow
      })
    end
  end)
end

function VisitorGift:OnFinish()
  DataCenter.CityVisitorManager.RemoveDeleteCacheListToUid(self.uid)
end

function VisitorGift:ClearData()
  if self.plotDelay then
    self.plotDelay:Stop()
    self.plotDelay = nil
  end
  base.ClearData(self)
end

return VisitorGift
