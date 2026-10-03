local UILWScienceMainItem = BaseClass("UILWScienceMainItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local btn_path = "btn"
local icon_path = "btn/Icon"
local lock_img_path = "btn/LockIcon"
local tab_name_path = "btn/TabName"
local no_unlock_text_path = "btn/NoUnlockText"
local pro_text_path = "btn/ProText"
local max_lv_go_path = "btn/MaxTextBg"
local max_lv_txt_path = "btn/MaxTextBg/MaxText"
local researching_txt_path = "btn/ResearchingTxt"
local researching_frame = "btn/ResearchFrame"
local queue1_path = "btn/Queues/Queue1"
local queue2_path = "btn/Queues/Queue2"
local queue3_path = "btn/Queues/Queue3"
local commend1_path = "btn/commend1"
local commend2_path = "btn/commend2"
local commend_tip_bg_path = "btn/commendTipBg"
local common_tip_txt_path = "btn/commendTipBg/commonTipMask/commonTipTxt"
local light_frame_ani_path = "LightFrameAni"
local common_tip_max_width = 180
local LOCK_COLOR = Color.New(0.7137255, 0.5372549, 0.4392157, 1)
local RESEARCHNG_TXT = GameDialogDefine.SCIENCE_RESEARCHING
local MAX_LV_TXT = GameDialogDefine.MAX

function UILWScienceMainItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWScienceMainItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWScienceMainItem:ComponentDefine()
  self.tabNameText = self:AddComponent(UIText, tab_name_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.lockImgGo = self:AddComponent(UIBaseContainer, lock_img_path)
  self.noUnlockText = self:AddComponent(UIText, no_unlock_text_path)
  self.proText = self:AddComponent(UIText, pro_text_path)
  self.researchingText = self:AddComponent(UIText, researching_txt_path)
  self.maxLvGo = self:AddComponent(UIBaseContainer, max_lv_go_path)
  self.maxLvText = self:AddComponent(UIText, max_lv_txt_path)
  self.timeBg = self:AddComponent(UIBaseContainer, "btn/timeBG")
  self.timeText = self:AddComponent(UIText, "btn/timeBG/timerText")
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  
  function self.timer_action()
    self:UpdateEndTime()
  end
  
  self.researchingFrameGo = self:AddComponent(UIBaseContainer, researching_frame)
  self.researchingFrameGo:SetActive(false)
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  self.researchingText:SetLocalText(RESEARCHNG_TXT)
  self.maxLvText:SetLocalText(MAX_LV_TXT)
  self.queue1 = self:AddComponent(UIBaseContainer, queue1_path)
  self.queue2 = self:AddComponent(UIBaseContainer, queue2_path)
  self.queue3 = self:AddComponent(UIBaseContainer, queue3_path)
  self.commend1 = self:AddComponent(UIBaseContainer, commend1_path)
  self.commend2 = self:AddComponent(UIBaseContainer, commend2_path)
  self.commend_tip_bg = self:AddComponent(UIImage, commend_tip_bg_path)
  self.common_tip_txt = self:AddComponent(UITextMeshProUGUIEx, common_tip_txt_path)
  self.lightFramePoint = self:AddComponent(UIBaseContainer, light_frame_ani_path)
end

function UILWScienceMainItem:ComponentDestroy()
  self.tabNameText = nil
  self.icon = nil
  self.lockImgGo = nil
  self.noUnlockText = nil
  self.proText = nil
  self.researchingText = nil
  self.maxLvGo = nil
  self.maxLvText = nil
  self.btn = nil
  self.researchingFrameGo = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.timer_action = nil
  self.timeBg = nil
  self.timeText = nil
  self.queue1 = nil
  self.queue2 = nil
  self.queue3 = nil
  self.commend1 = nil
  self.commend2 = nil
  self.commend_tip_bg = nil
  self.common_tip_txt = nil
  self.lightFramePoint = nil
end

function UILWScienceMainItem:DataDefine()
  self.state = nil
  self.tweenSeq = nil
  self.isShow = false
end

function UILWScienceMainItem:DataDestroy()
  self:CloseCommendTipTweenSeq()
  self.param = nil
  self.state = nil
  self.meta = nil
  self.isShow = nil
end

function UILWScienceMainItem:OnEnable()
  base.OnEnable(self)
end

function UILWScienceMainItem:OnDisable()
  base.OnDisable(self)
  self:StopDelayLightTimer()
end

function UILWScienceMainItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWScienceMainItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWScienceMainItem:SetData(param)
  self.isShow = false
  self.param = param
  self.meta = param.template
  self.lockedTip = ""
  self.state, self.lockedTip = DataCenter.ScienceTemplateManager:GetTabState(param.template.id)
  if self.state == ScienceTabState.UnLock then
    self.progress = DataCenter.ScienceTemplateManager:GetScienceTabPro(self.meta.id)
  end
  self.isLightFrame = param.isLightFrame
  self:RefreshView()
end

function UILWScienceMainItem:SetDataByCfgId(tabCfgId, progress)
  self.isShow = true
  self.meta = DataCenter.ScienceTemplateManager:GetScienceTabTemplate(tabCfgId)
  self.state = ScienceTabState.UnLock
  self.progress = progress
  self:RefreshView()
end

function UILWScienceMainItem:RefreshView()
  self.tabNameText:SetLocalText(self.meta.name)
  self.researchingFrameGo:SetActive(false)
  if self.state == ScienceTabState.UnLock then
    self.noUnlockText:SetActive(false)
    self.researchingText:SetActive(false)
    local pro = self.progress
    if 1 <= pro then
      self.proText:SetActive(false)
      self.maxLvGo:SetActive(true)
    else
      self.proText:SetActive(true)
      self.maxLvGo:SetActive(false)
      self.proText:SetText(tostring(Mathf.Round(pro * 100)) .. "%")
    end
    if self.param and self.param.isResearching then
      local sciencesIds = self.param.isResearchingScienceId
      local queue1Working = false
      local queue2Working = false
      local queue3Working = false
      self.workingQueues = {}
      if not table.IsNullOrEmpty(sciencesIds) then
        for i = 1, #sciencesIds do
          local scienceId = sciencesIds[i]
          local queue = DataCenter.ScienceManager:GetScienceQueueByScienceId(tostring(scienceId))
          if queue and (queue:GetQueueState() == NewQueueState.Work or queue:GetQueueState() == NewQueueState.Finish) and queue.funcUuid then
            local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(queue.funcUuid)
            if buildData then
              if buildData.itemId == BuildingTypes.FUN_BUILD_SCIENE then
                queue1Working = true
                table.insert(self.workingQueues, queue)
              elseif buildData.itemId == BuildingTypes.LW_BUILE_SCIENCE_TWO then
                queue2Working = true
                table.insert(self.workingQueues, queue)
              elseif buildData.itemId == BuildingTypes.LW_BUILE_SCIENCE_THREE then
                queue3Working = true
                table.insert(self.workingQueues, queue)
              end
            end
          end
        end
      end
      self.queue1:SetActive(queue1Working)
      self.queue2:SetActive(queue2Working)
      self.queue3:SetActive(queue3Working)
      if queue1Working or queue2Working or queue3Working then
        self.researchingFrameGo:SetActive(true)
      else
        self.researchingFrameGo:SetActive(false)
      end
      self:UpdateEndTime()
      self.timer:Start()
    else
      self.queue1:SetActive(false)
      self.queue2:SetActive(false)
      self.queue3:SetActive(false)
    end
    self.lockImgGo:SetActive(false)
    self.icon:LoadSprite(string.format(LoadPath.UILWScience, self.meta.icon))
    UIGray.SetGray(self.btn.transform, false, true)
  elseif self.state == ScienceTabState.Lock then
    self.icon:LoadSprite(string.format(LoadPath.UILWScience, self.meta.icon))
    UIGray.SetGray(self.btn.transform, true, false)
    self.timeBg:SetActive(false)
    self.proText:SetActive(false)
    self.noUnlockText:SetActive(true)
    self.noUnlockText:SetText(self.lockedTip)
    self.noUnlockText:SetColor(LOCK_COLOR)
    self.lockImgGo:SetActive(true)
    self.queue1:SetActive(false)
    self.queue2:SetActive(false)
    self.queue3:SetActive(false)
  elseif self.state == ScienceTabState.LockShow then
    self.icon:LoadSprite(string.format(LoadPath.UILWScience, self.meta.icon))
    UIGray.SetGray(self.btn.transform, true, true)
    self.timeBg:SetActive(false)
    self.proText:SetActive(false)
    self.maxLvGo:SetActive(false)
    self.researchingText:SetActive(false)
    self.noUnlockText:SetActive(true)
    self.noUnlockText:SetText(self.lockedTip)
    self.lockImgGo:SetActive(true)
    self.queue1:SetActive(false)
    self.queue2:SetActive(false)
    self.queue3:SetActive(false)
  elseif self.state == ScienceTabState.CanUnlock then
    self.icon:LoadSprite(string.format(LoadPath.UILWScience, self.meta.icon))
    UIGray.SetGray(self.btn.transform, true, false)
    self.timeBg:SetActive(false)
    self.proText:SetActive(false)
    self.noUnlockText:SetActive(true)
    self.noUnlockText:SetLocalText(GameDialogDefine.UNLOCK)
    self.noUnlockText:SetColor(LOCK_COLOR)
    self.queue1:SetActive(false)
    self.queue2:SetActive(false)
    self.queue3:SetActive(false)
  end
  self.icon:SetNativeSize()
  if not self.isShow then
    local showRecommend1Data, showRecommend2Data = DataCenter.ScienceRecommendManager:GetRecommendScience()
    if showRecommend1Data and showRecommend1Data.tab == self.meta.id then
      self.commend1:SetActive(true)
      self.commend2:SetActive(false)
      self.commend_tip_bg:SetActive(true)
      self:ShowCommendTip("rec_tech_tip1")
    elseif showRecommend2Data and showRecommend2Data.tab == self.meta.id then
      self.commend1:SetActive(false)
      self.commend2:SetActive(true)
      self.commend_tip_bg:SetActive(true)
      self:ShowCommendTip("rec_tech_tip2")
    else
      self.commend1:SetActive(false)
      self.commend2:SetActive(false)
      self.commend_tip_bg:SetActive(false)
      self:ShowCommendTip()
    end
  else
    self.commend1:SetActive(false)
    self.commend2:SetActive(false)
    self.commend_tip_bg:SetActive(false)
    self:ShowCommendTip()
  end
  if self.isLightFrame then
    self:ShowLightFrameSomeTime(3)
  end
end

function UILWScienceMainItem:UpdateEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.workingQueues then
    local minTime
    for i = 1, #self.workingQueues do
      local queue = self.workingQueues[i]
      if queue then
        if minTime == nil then
          minTime = queue.endTime
        elseif minTime > queue.endTime then
          minTime = queue.endTime
        end
      end
    end
    if not minTime or curTime < minTime then
    end
  end
end

function UILWScienceMainItem:OnBtnClick()
  if not self.param then
    return
  end
  if self.state == ScienceTabState.UnLock then
    if self.param.isResearching ~= nil and self.param.isResearching == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWScienceTree, {anim = true, hideTop = true}, self.param.template.id, self.param.isResearchingScienceId[1], true, self.view.bUuid)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWScienceTree, {anim = true, hideTop = true}, self.param.template.id, nil, true, self.view.bUuid)
    end
  elseif self.state == ScienceTabState.CanUnlock then
    if self.param.isResearching ~= nil and self.param.isResearching == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWScienceTree, {anim = true, hideTop = true}, self.param.template.id, self.param.isResearchingScienceId[1], false, self.view.bUuid)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWScienceTree, {anim = true, hideTop = true}, self.param.template.id, nil, true, self.view.bUuid)
    end
    DataCenter.ScienceTemplateManager:SetScienceTabSetting(self.param.template.id)
    self:SetData(self.param)
  elseif self.state == ScienceTabState.Lock then
  elseif self.state == ScienceTabState.LockShow and self.meta and self.meta.id == month_card_science_tab_id then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.MonthCard)
  end
end

function UILWScienceMainItem:CloseCommendTipTweenSeq()
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
  self.tweenSeq = nil
end

function UILWScienceMainItem:ShowCommendTip(textKey)
  self:CloseCommendTipTweenSeq()
  if not textKey then
    return
  end
  self.common_tip_txt:SetLocalText(textKey)
  local txtWidth = self.common_tip_txt:GetWidth()
  if txtWidth > common_tip_max_width then
    local startPos = (txtWidth - common_tip_max_width) / 2
    local speed = 60
    local moceTime = startPos * 2 / speed
    self.common_tip_txt:SetAnchoredPositionXY(startPos, 0)
    self.tweenSeq = DOTween.Sequence()
    self.tweenSeq:AppendInterval(0.5)
    self.tweenSeq:Append(self.common_tip_txt.transform:DOAnchorPosX(-startPos, moceTime):SetEase(CS.DG.Tweening.Ease.Linear))
    self.tweenSeq:AppendInterval(0.5)
    self.tweenSeq:SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
  else
    self.common_tip_txt:SetAnchoredPositionXY(0, 0)
  end
end

function UILWScienceMainItem:ShowLightFrameSomeTime(duration)
  local time = duration or 2
  self:SetLightFrameShowHideState(true)
  self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
    self:SetLightFrameShowHideState(false)
    self:StopDelayLightTimer()
  end, time)
end

function UILWScienceMainItem:SetLightFrameShowHideState(isShow)
  if IsNull(self.lightFramePoint) then
    return
  end
  self.lightFramePoint:SetActive(isShow)
end

function UILWScienceMainItem:StopDelayLightTimer()
  if self.delayTime ~= nil then
    self.delayTime:Stop()
    self.delayTime = nil
  end
end

return UILWScienceMainItem
