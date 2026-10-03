local DetectEventCompleteOneClickBtnView = BaseClass("DetectEventCompleteOneClickBtnView", UIBaseContainer)
local base = UIBaseContainer
local sendMsgTime = 0
local sendMsgIntervalTime = 2000

function DetectEventCompleteOneClickBtnView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function DetectEventCompleteOneClickBtnView:OnDestroy()
  self:ComponentDestroy()
  if self.ClaimCoroutine ~= nil then
    coroutine.stopwaiting(self.ClaimCoroutine)
    self.ClaimCoroutine = nil
  end
  base.OnDestroy(self)
end

function DetectEventCompleteOneClickBtnView:ComponentDefine()
  self.btnDo = self:AddComponent(UIButton, "BtnCompleteOnClick")
  self.btnDo:SetOnClick(function()
    self:OnBtnDoClick()
  end)
  self.textBtnDo = self:AddComponent(UITextMeshProUGUIEx, "BtnCompleteOnClick/BtnCompleteOnClickTxt")
  self.btnDo:SetOnClick(BindCallback(self, self.OnBtnDoClick))
  self.btnTipTxt = self:AddComponent(UITextMeshProUGUIEx, "BtnCompleteOnClick/BtnTipTxt")
  self.btn_claim_on_click = self:AddComponent(UIButton, "BtnClaimOnClick")
  self.btn_claim_on_click:SetOnClick(BindCallback(self, self.OnQuickClaimClicked))
  self.btn_claim_tip_txt = self:AddComponent(UITextMeshProUGUIEx, "BtnClaimOnClick/BtnClaimTipTxt")
end

function DetectEventCompleteOneClickBtnView:ComponentDestroy()
  self.btnDo = nil
  self.textBtnDo = nil
  self.btnTipTxt = nil
  self.btn_claim_on_click = nil
  self.btn_claim_tip_txt = nil
end

function DetectEventCompleteOneClickBtnView:ReInit()
  sendMsgTime = 0
  self.btn_claim_on_click:SetActive(false)
  local needLv = self:GetOpenLevel()
  local currentLv = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  local needShowLv = needLv - 1
  if currentLv < needShowLv then
    self.btnDo:SetActive(false)
    return
  end
  self.IsQuickFinishFuncOpen = DataCenter.RadarFakeUIMarchManager:IsFuncOpen()
  if self.IsQuickFinishFuncOpen then
    self.textBtnDo:SetLocalText("detect_quick_operation_btn")
  else
    self.textBtnDo:SetLocalText("radar_btn_1")
  end
  if currentLv >= needShowLv and needLv > currentLv then
    self.btnDo:SetActive(true)
    CS.UIGray.SetGray(self.btnDo.transform, true, false)
    self.btnTipTxt:SetLocalText("radar_tips_23", needLv)
    return
  end
  self:UpdateBtnState()
end

function DetectEventCompleteOneClickBtnView:OnEnable()
  base.OnEnable(self)
end

function DetectEventCompleteOneClickBtnView:OnDisable()
  base.OnDisable(self)
end

function DetectEventCompleteOneClickBtnView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DetectEventGetBatchRealPoint, self.TryStartArmyList)
end

function DetectEventCompleteOneClickBtnView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.DetectEventGetBatchRealPoint, self.TryStartArmyList)
end

function DetectEventCompleteOneClickBtnView:UpdateBtnState()
  local eventNum, costNum
  self.haveEvent, eventNum, costNum = self:GetHaveEventToComplete()
  self.btnDo:SetActive(self.haveEvent)
  if self.haveEvent then
    CS.UIGray.SetGray(self.btnDo.transform, false, true)
    self.btnTipTxt:SetLocalText("radar_tips_9", eventNum, costNum)
  else
    self.hasEventToClaim, eventNum = self:GetHaveEventToClaim()
    local anyDoing = DataCenter.RadarFakeUIMarchManager:IsAnyDoing()
    self.hasEventToClaim = self.hasEventToClaim and not anyDoing
    self.btn_claim_on_click:SetActive(self.hasEventToClaim and self.IsQuickFinishFuncOpen)
    self.btn_claim_tip_txt:SetLocalText("detect_quick_reward_desc", eventNum)
  end
  local hasQuickBtn = not self.IsQuickFinishFuncOpen or self.haveEvent or self.hasEventToClaim
  if hasQuickBtn then
    DataCenter.RadarFakeUIMarchManager:TryPlot()
  end
end

function DetectEventCompleteOneClickBtnView:OnBtnDoClick()
  if not self.haveEvent then
    return
  end
  local needApplyEventUidList = {}
  local allEvent = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  table.walk(allEvent, function(_, v)
    local event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(v)
    if event ~= nil and event.state == DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD then
      local isGoto = DataCenter.RadarCenterDataManager:IsDetectEventDoing(v)
      if not isGoto then
        local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(event.eventId)
        if template.type == DetectEventType.DetectEventPickGarbage or template.type == DetectEventType.HELPER or template.type == DetectEventType.DOMINATOR_CURE or template.type == DetectEventType.SEASON_VISITOR then
          table.insert(needApplyEventUidList, v)
        end
      end
    end
  end)
  if 0 < #needApplyEventUidList then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > sendMsgTime + sendMsgIntervalTime then
      sendMsgTime = curTime
      SFSNetwork.SendMessage(MsgDefines.DetectEventBatchPutPointInWorld, needApplyEventUidList)
    end
  else
    self:TryStartArmyList()
  end
end

function DetectEventCompleteOneClickBtnView:TryStartArmyList()
  local pickGarbageEventList = {}
  local helperEventList = {}
  local allEvent = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  table.walk(allEvent, function(_, v)
    local event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(v)
    if event ~= nil and event.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
      local isGoto = DataCenter.RadarCenterDataManager:IsDetectEventDoing(v)
      if not isGoto then
        local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(event.eventId)
        if template.type == DetectEventType.DetectEventPickGarbage or template.type == DetectEventType.DOMINATOR_CURE or template.type == DetectEventType.SEASON_VISITOR then
          table.insert(pickGarbageEventList, event)
        elseif template.type == DetectEventType.HELPER then
          table.insert(helperEventList, event)
        end
      end
    end
  end)
  local curNum = LuaEntry.Player:GetCurStamina()
  local CostNum = DataCenter.RadarCenterDataManager:GetDetectHelpTypeCostNum()
  local curCostNum = 0
  for k, v in pairs(helperEventList) do
    if v.cost ~= 1 then
      curCostNum = curCostNum + CostNum
    end
  end
  local isEnough = false
  if curNum >= curCostNum then
    isEnough = true
  else
    LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy, nil, true)
  end
  if isEnough then
    if self.IsQuickFinishFuncOpen then
      self:HandleUIFakeMarch(pickGarbageEventList, helperEventList)
      self:UpdateBtnState()
    else
      self:HandleSendFakeMarch(pickGarbageEventList, helperEventList)
    end
  end
end

function DetectEventCompleteOneClickBtnView:HandleSendFakeMarch(garbageList, helperList)
  self.view.ctrl:CloseSelf()
  SceneUtils.ChangeToWorld(function()
    TimerManager:GetInstance():DelayInvoke(function()
      local loginServerId = LuaEntry.Player:GetSelfServerId()
      GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos()), CS.SceneManager.World.InitZoom, nil, nil, loginServerId)
      local isHaveLackTip = false
      local curNum = LuaEntry.Player:GetCurStamina()
      local playerNumber = DataCenter.SoldierDataManager:GetPlayerSoldiersTotalNum()
      for index, data in pairs(garbageList) do
        DataCenter.FakeCollectGarbageMarchManager:AddMarchIndex(data.pointId, data.eventId)
      end
      for index, helpDetectData in pairs(helperList) do
        if isHaveLackTip then
          return
        end
        if helpDetectData.cost == 1 then
          DataCenter.FakeHelperMarchManager:AddMarchIndex(helpDetectData.pointId, helpDetectData.serverId)
        else
          local CostNum = DataCenter.RadarCenterDataManager:GetDetectHelpTypeCostNum()
          if curNum >= CostNum then
            curNum = curNum - CostNum
            DataCenter.FakeHelperMarchManager:AddMarchIndex(helpDetectData.pointId, helpDetectData.serverId)
          else
            LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy, nil, true)
            isHaveLackTip = true
          end
        end
      end
    end, 1)
  end)
end

function DetectEventCompleteOneClickBtnView:HandleUIFakeMarch(garbageList, helperList)
  local isHaveLackTip = false
  local curNum = LuaEntry.Player:GetCurStamina()
  for index, data in pairs(garbageList) do
    self.view:AddFakeUIMarch(data)
  end
  for index, helpDetectData in pairs(helperList) do
    if isHaveLackTip then
      return
    end
    if helpDetectData.cost == 1 then
      self.view:AddFakeUIMarch(helpDetectData)
    else
      local CostNum = DataCenter.RadarCenterDataManager:GetDetectHelpTypeCostNum()
      if curNum >= CostNum then
        curNum = curNum - CostNum
        self.view:AddFakeUIMarch(helpDetectData)
      else
        LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy, nil, true)
        isHaveLackTip = true
      end
    end
  end
end

function DetectEventCompleteOneClickBtnView:GetOpenLevel()
  local need = 0
  local key1 = "detect_config"
  if LuaEntry.Player:IsMonopolyDetectB() then
    key1 = "detect_config_new"
  end
  need = LuaEntry.DataConfig:TryGetNum(key1, "k100")
  return need
end

function DetectEventCompleteOneClickBtnView:GetHaveEventToComplete()
  local pickGarbageEventList = {}
  local helperEventList = {}
  local allEvent = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  table.walk(allEvent, function(_, v)
    local event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(v)
    if event ~= nil and (event.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH or event.state == DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD) then
      local isGoto = DataCenter.RadarCenterDataManager:IsDetectEventDoing(v)
      if not isGoto then
        local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(event.eventId)
        if template.type == DetectEventType.DetectEventPickGarbage or template.type == DetectEventType.DOMINATOR_CURE or template.type == DetectEventType.SEASON_VISITOR then
          table.insert(pickGarbageEventList, event)
        elseif template.type == DetectEventType.HELPER then
          table.insert(helperEventList, event)
        end
      end
    end
  end)
  if 0 < #pickGarbageEventList or 0 < #helperEventList then
    local eventNum = #pickGarbageEventList + #helperEventList
    local CostNum = DataCenter.RadarCenterDataManager:GetDetectHelpTypeCostNum()
    local curCostNum = 0
    for k, v in pairs(helperEventList) do
      if v.cost ~= 1 then
        curCostNum = curCostNum + CostNum
      end
    end
    return true, eventNum, curCostNum
  end
  return false, 0, 0
end

function DetectEventCompleteOneClickBtnView:GetHaveEventToClaim()
  local count = table.count(self:GetCanClaimUuids())
  return 0 < count, count
end

function DetectEventCompleteOneClickBtnView:OnQuickClaimClicked()
  if not self.IsQuickFinishFuncOpen then
    return
  end
  local canClaim = self:GetCanClaimUuids()
  if not table.IsNullOrEmpty(canClaim) then
    local function sendClaim()
      DataCenter.RadarFakeUIMarchManager:AddClaimingTasks(canClaim)
      
      self.ClaimCoroutine = coroutine.start(function()
        for _, uuid in pairs(canClaim) do
          coroutine.waitforseconds(0.05)
          SFSNetwork.SendMessage(MsgDefines.DetectEventRewardReceive, uuid)
          if self.view ~= nil then
            self.view:SetLastReceiveDetectEventRewardTime()
          end
        end
      end)
      self.view:PlayRewardSound()
      self.view:SetCurrentSelectItemId(nil)
      self.btn_claim_on_click:SetActive(false)
    end
    
    if DataCenter.RadarFakeUIMarchManager:NeedConfirm() then
      local param = {
        contentText = CS.GameEntry.Localization:GetString("detect_quick_reward_confirm_text", table.count(canClaim)),
        btnNum = 2,
        showToggle = true,
        confirmBtnParam = {
          context = GameDialogDefine.CONFIRM,
          action = function()
            sendClaim()
          end
        },
        cancelBtnParam = {
          context = GameDialogDefine.CANCEL
        }
      }
      UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.RADAR_QUICK_CLAIM_DAILY_ALERT, param)
    else
      sendClaim()
    end
  end
end

function DetectEventCompleteOneClickBtnView:GetCanClaimUuids()
  local canClaim = {}
  if not self.IsQuickFinishFuncOpen then
    return canClaim
  end
  local allEvent = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  for _, v in pairs(allEvent) do
    local event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(v)
    if event ~= nil and not DataCenter.RadarFakeUIMarchManager:IsClaiming(event.uuid) and event.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
      do
        local valid = true
        local resourceItemNum = 0
        local soldierItemNum = 0
        table.walk(event.rewardList, function(_, v)
          if v.rewardType == RewardType.RESOURCE_ITEM then
            resourceItemNum = resourceItemNum + v.count
            if event.template and event.template.type == DetectEventType.RESCUE and v.itemId and LocalController:instance():hasLine(TableName.LW_Soldier, tostring(v.itemId)) then
              soldierItemNum = soldierItemNum + v.count
            end
          end
        end)
        if 0 <= resourceItemNum and DataCenter.ResourceItemDataManager:CheckIsStorageFull(resourceItemNum) then
          valid = false
        end
        if 0 < soldierItemNum then
          local number = math.modf(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SOLDIER_MAX_STOCK))
          local playerNumber = DataCenter.SoldierDataManager:GetPlayerSoldiersTotalNum()
          local maxCount = number - playerNumber
          if soldierItemNum > maxCount then
            valid = false
          end
        end
        if valid then
          table.insert(canClaim, event.uuid)
        end
      end
    end
  end
  return canClaim
end

return DetectEventCompleteOneClickBtnView
