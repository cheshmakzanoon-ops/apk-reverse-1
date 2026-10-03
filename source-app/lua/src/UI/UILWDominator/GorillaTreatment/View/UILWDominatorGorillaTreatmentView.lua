local UILWDominatorGorillaTreatmentView = BaseClass("UILWDominatorGorillaTreatmentView", UIBaseView)
local Localization = CS.GameEntry.Localization
local base = UIBaseView
local UILWDominatorGorillaTreatmentItemComponent = require("UI/UILWDominator/GorillaTreatment/Component/UILWDominatorGorillaTreatmentItemComponent")
local UILWDominatorMainModelSceneViewer = require("UI/UILWDominator/Main/Scene/UILWDominatorMainModelSceneViewer")

function UILWDominatorGorillaTreatmentView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWDominatorGorillaTreatmentView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorGorillaTreatmentView:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.btnInfo = self:AddComponent(UIButton, "Root/Top/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textUserName = self:AddComponent(UIText, "Root/NameContent/UserNameText")
  self.imgStateIconRed = self:AddComponent(UIImage, "Root/InfoContent/Content/StateIcon_red")
  self.imgStateIconYellow = self:AddComponent(UIImage, "Root/InfoContent/Content/StateIcon_yellow")
  self.imgStateIconGreen = self:AddComponent(UIImage, "Root/InfoContent/Content/StateIcon_green")
  self.textRankProgressTotal = self:AddComponent(UIText, "Root/InfoContent/Content/RankProgressTotalText")
  self.textName = self:AddComponent(UIText, "Root/InfoContent/Content/NameText")
  self.sliderSlider01 = self:AddComponent(UISlider, "Root/InfoContent/Content/Layout/ProgressItem01/Slider01")
  self.imgFill01 = self:AddComponent(UIImage, "Root/InfoContent/Content/Layout/ProgressItem01/Slider01/Fill Area/Fill01")
  self.sliderSlider02 = self:AddComponent(UISlider, "Root/InfoContent/Content/Layout/ProgressItem02/Slider02")
  self.imgFill02 = self:AddComponent(UIImage, "Root/InfoContent/Content/Layout/ProgressItem02/Slider02/Fill Area/Fill02")
  self.sliderSlider03 = self:AddComponent(UISlider, "Root/InfoContent/Content/Layout/ProgressItem03/Slider03")
  self.imgFill03 = self:AddComponent(UIImage, "Root/InfoContent/Content/Layout/ProgressItem03/Slider03/Fill Area/Fill03")
  self.compTreatContent = self:AddComponent(UIBaseContainer, "Root/TreatContent")
  self.compDragContent = self:AddComponent(UIBaseContainer, "Root/TreatContent/DragContent")
  self.compUILWDominatorGorillaTreatmentItem1 = self:AddComponent(UILWDominatorGorillaTreatmentItemComponent, "Root/TreatContent/UILWDominatorGorillaTreatmentItem1")
  self.compUILWDominatorGorillaTreatmentItem2 = self:AddComponent(UILWDominatorGorillaTreatmentItemComponent, "Root/TreatContent/UILWDominatorGorillaTreatmentItem2")
  self.compUILWDominatorGorillaTreatmentItem3 = self:AddComponent(UILWDominatorGorillaTreatmentItemComponent, "Root/TreatContent/UILWDominatorGorillaTreatmentItem3")
  self.compUILWDominatorGorillaTreatmentItems = {
    self.compUILWDominatorGorillaTreatmentItem1,
    self.compUILWDominatorGorillaTreatmentItem2,
    self.compUILWDominatorGorillaTreatmentItem3
  }
  self.textStateItemMax = self:AddComponent(UIText, "Root/InfoContent/Content/Layout/StateContent/StateItem03/bg/StateItemMaxText")
  self.textStateItemMax:SetText("MAX")
  self.textTips = self:AddComponent(UIText, "Root/TipsText")
  self.textTips:SetLocalText("dominator_cure_desc_6")
  self.compStateItem01 = self:AddComponent(UIBaseContainer, "Root/InfoContent/Content/Layout/StateContent/StateItem01")
  self.compStateItem02 = self:AddComponent(UIBaseContainer, "Root/InfoContent/Content/Layout/StateContent/StateItem02")
  self.compStateItem03 = self:AddComponent(UIBaseContainer, "Root/InfoContent/Content/Layout/StateContent/StateItem03")
  self.compEffUiDominatorSaoguang = self:AddComponent(UIBaseContainer, "Root/InfoContent/Content/Layout/VFX_lightsweep")
  self.compModelViewer = self:AddComponent(UILWDominatorMainModelSceneViewer, "WeaponImg", false)
  local uiContainerRect = UIManager:GetInstance():GetUIContainerRect()
  local parentWidth = uiContainerRect.sizeDelta.x
  local parentHeight = uiContainerRect.sizeDelta.y
  self.rtWidth = math.floor(parentWidth)
  self.rtHeight = math.floor(parentHeight)
  if Config.IsPC() then
    self.rtWidth = DefaultScreenWidth
    self.rtHeight = DefaultScreenHeight
  end
  self.compModelViewer:SetRTSize(self.rtWidth, self.rtHeight)
  self.btnBack = self:AddComponent(UIButton, "Root/BtnBack")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnArchive = self:AddComponent(UIButton, "Root/InfoContent/ArchiveBtn")
  self.btnArchive:SetOnClick(function()
    self:OnBtnArchiveClick()
  end)
  self.textArchive = self:AddComponent(UIText, "Root/InfoContent/ArchiveBtn/ArchiveText")
  self.textArchive:SetText(Localization:GetString("dominator_story_enter_name"))
  self.compArchiveRed = self:AddComponent(UIBaseContainer, "Root/InfoContent/ArchiveBtn/ArchiveRed")
end

function UILWDominatorGorillaTreatmentView:ComponentDestroy()
  self.animator = nil
  self.btnInfo = nil
  self.textUserName = nil
  self.imgStateIconRed = nil
  self.imgStateIconYellow = nil
  self.imgStateIconGreen = nil
  self.textRankProgressTotal = nil
  self.textName = nil
  self.sliderSlider01 = nil
  self.imgFill01 = nil
  self.sliderSlider02 = nil
  self.imgFill02 = nil
  self.sliderSlider03 = nil
  self.imgFill03 = nil
  self.compTreatContent = nil
  self.compDragContent = nil
  self.compUILWDominatorGorillaTreatmentItem1 = nil
  self.compUILWDominatorGorillaTreatmentItem2 = nil
  self.compUILWDominatorGorillaTreatmentItem3 = nil
  self.compUILWDominatorGorillaTreatmentItems = nil
  self.textStateItemMax = nil
  self.textTips = nil
  self.compStateItem01 = nil
  self.compStateItem02 = nil
  self.compStateItem03 = nil
  self.compEffUiDominatorSaoguang = nil
  self.compModelViewer = nil
  self.btnBack = nil
  self.btnArchive = nil
  self.textArchive = nil
  self.compArchiveRed = nil
end

function UILWDominatorGorillaTreatmentView:DataDefine()
  self.isTreatmentAnimPlaying = false
end

function UILWDominatorGorillaTreatmentView:DataDestroy()
  if self.delayAnimTimer ~= nil then
    self.delayAnimTimer:Stop()
  end
  self.delayAnimTimer = nil
  if self.delayOpenSuccessTimer ~= nil then
    self.delayOpenSuccessTimer:Stop()
  end
  self.delayOpenSuccessTimer = nil
  if self.delayPlayIdleAnimTimer then
    self.delayPlayIdleAnimTimer:Stop()
  end
  self.delayPlayIdleAnimTimer = nil
end

function UILWDominatorGorillaTreatmentView:OnDisable()
  base.OnDisable(self)
  if self.compModelViewer then
    self.compModelViewer:ReleaseModel()
  end
end

function UILWDominatorGorillaTreatmentView:OnOpen()
  self.info = DataCenter.DominatorManager:GetInfoById(DominatorId.Gorilla)
  if not self.info then
    return
  end
  self.mainTemplate = self.info:GetMainTemplate()
  if not self.mainTemplate or self.mainTemplate.id ~= DominatorId.Gorilla then
    return
  end
  self.compEffUiDominatorSaoguang:SetActive(false)
  self:UpdateUserName()
  self:UpdateInfo()
  self:UpdateItems()
  self:UpdateHeart(false)
  self:UpdateModelViewer()
  self:UpdateArchiveBtn()
  self:PlayIdleAnim(true)
  self:PlayUIAnim("V_ui_UILWDominatorGorillaTreatment_heartbreath", 1)
end

function UILWDominatorGorillaTreatmentView:UpdateModelViewer()
  if self.info then
    local appearanceId = self.info:GetAppearanceId()
    self.compModelViewer:SetModel(appearanceId, nil, self.info.dominatorId)
  end
end

function UILWDominatorGorillaTreatmentView:PlayUIAnim(anim, delay)
  if self.delayAnimTimer ~= nil then
    self.delayAnimTimer:Stop()
  end
  self.delayAnimTimer = nil
  if delay ~= nil and 0 < delay then
    self.delayAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.animator then
        self.animator:Play(anim)
      end
    end, delay)
  elseif self.animator then
    self.animator:Play(anim)
  end
end

function UILWDominatorGorillaTreatmentView:UpdateUserName()
  if not self.info then
    return
  end
  self.textUserName:SetText(self.info:GetUserName())
end

function UILWDominatorGorillaTreatmentView:UpdateHeart(keepPreviousHeart)
  if not self.info or not self.imgStateIconRed then
    return
  end
  local curStage = self.info:GetCurTreatmentStage()
  if not keepPreviousHeart then
    self.imgStateIconRed:SetActive(curStage == DominatorGorillaTreatmentStage.One)
    self.imgStateIconYellow:SetActive(curStage == DominatorGorillaTreatmentStage.Two)
    self.imgStateIconGreen:SetActive(curStage == DominatorGorillaTreatmentStage.Three)
    self.compStateItem01:SetActive(curStage == DominatorGorillaTreatmentStage.One)
    self.compStateItem02:SetActive(curStage == DominatorGorillaTreatmentStage.One or curStage == DominatorGorillaTreatmentStage.Two)
    self.compStateItem03:SetActive(true)
  else
    self.imgStateIconRed:SetActive(curStage == DominatorGorillaTreatmentStage.One or curStage == DominatorGorillaTreatmentStage.Two)
    self.imgStateIconYellow:SetActive(curStage == DominatorGorillaTreatmentStage.Two or curStage == DominatorGorillaTreatmentStage.Three)
    self.imgStateIconGreen:SetActive(curStage == DominatorGorillaTreatmentStage.Three or curStage == DominatorGorillaTreatmentStage.Finish)
    self.compStateItem01:SetActive(curStage == DominatorGorillaTreatmentStage.One or curStage == DominatorGorillaTreatmentStage.Two)
    self.compStateItem02:SetActive(curStage == DominatorGorillaTreatmentStage.Two or curStage == DominatorGorillaTreatmentStage.Three)
    self.compStateItem03:SetActive(curStage == DominatorGorillaTreatmentStage.Two or curStage == DominatorGorillaTreatmentStage.Three or curStage == DominatorGorillaTreatmentStage.Finish)
  end
end

function UILWDominatorGorillaTreatmentView:UpdateInfo()
  if not self.info or not self.imgStateIconRed then
    return
  end
  local maxOne = self.info:GetStageMaxProgress(DominatorGorillaTreatmentStage.One)
  local maxTwo = self.info:GetStageMaxProgress(DominatorGorillaTreatmentStage.Two)
  local maxThree = self.info:GetStageMaxProgress(DominatorGorillaTreatmentStage.Three)
  local curProgress = self.info:GetCurProgress()
  local curStage = self.info:GetCurTreatmentStage()
  if curStage == DominatorGorillaTreatmentStage.One then
    if 0 < maxOne then
      self.sliderSlider01:SetValue(curProgress / maxOne)
    end
    self.sliderSlider02:SetValue(0)
    self.sliderSlider03:SetValue(0)
    self.imgFill01:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorTreatment/lrb_zhuzaijiesuo_exp-red.png")
    self.imgFill02:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorTreatment/lrb_zhuzaijiesuo_exp-red.png")
    self.imgFill03:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorTreatment/lrb_zhuzaijiesuo_exp-red.png")
    self.textName:SetText(Localization:GetString("dominator_cure_desc_1", Localization:GetString("dominator_cure_desc_2")))
  elseif curStage == DominatorGorillaTreatmentStage.Two then
    if 0 < maxTwo then
      self.sliderSlider02:SetValue((curProgress - maxOne) / maxTwo)
    end
    self.sliderSlider01:SetValue(1)
    self.sliderSlider03:SetValue(0)
    self.imgFill01:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorTreatment/lrb_zhuzaijiesuo_exp-yellow.png")
    self.imgFill02:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorTreatment/lrb_zhuzaijiesuo_exp-yellow.png")
    self.imgFill03:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorTreatment/lrb_zhuzaijiesuo_exp-yellow.png")
    self.textName:SetText(Localization:GetString("dominator_cure_desc_1", Localization:GetString("dominator_cure_desc_3")))
  elseif curStage == DominatorGorillaTreatmentStage.Three or curStage == DominatorGorillaTreatmentStage.Finish then
    if 0 < maxThree then
      self.sliderSlider03:SetValue((curProgress - maxOne - maxTwo) / maxThree)
    end
    self.sliderSlider01:SetValue(1)
    self.sliderSlider02:SetValue(1)
    self.imgFill01:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorTreatment/lrb_zhuzaijiesuo_exp-green.png")
    self.imgFill02:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorTreatment/lrb_zhuzaijiesuo_exp-green.png")
    self.imgFill03:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorTreatment/lrb_zhuzaijiesuo_exp-green.png")
    self.textName:SetText(Localization:GetString("dominator_cure_desc_1", Localization:GetString("dominator_cure_desc_4")))
  end
  local maxTotal = maxOne + maxTwo + maxThree
  self.textRankProgressTotal:SetText(curProgress .. "/" .. maxTotal)
end

function UILWDominatorGorillaTreatmentView:UpdateItems()
  if not self.info or not self.compTreatContent then
    return
  end
  local configDataDict = self.info:GetTreatmentCostInfo()
  if not table.IsNullOrEmpty(configDataDict) then
    for i, v in ipairs(configDataDict) do
      if self.compUILWDominatorGorillaTreatmentItems[i] then
        self.compUILWDominatorGorillaTreatmentItems[i]:ReInit(self.info, v, self)
      end
    end
  end
end

function UILWDominatorGorillaTreatmentView:UpdateArchiveBtn()
  self.compArchiveRed:SetActive(self.info ~= nil and self.info:HasAnyArchiveCanUnlock())
end

function UILWDominatorGorillaTreatmentView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DominatorGorillaTreatmentSuccess, self.OnTreatSuccess)
  self:AddUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  self:AddUIListener(EventId.DominatorArchiveUnlockSuccess, self.OnArchiveUnlock)
end

function UILWDominatorGorillaTreatmentView:OnRemoveListener()
  self:RemoveUIListener(EventId.DominatorGorillaTreatmentSuccess, self.OnTreatSuccess)
  self:RemoveUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  self:RemoveUIListener(EventId.DominatorArchiveUnlockSuccess, self.OnArchiveUnlock)
  base.OnRemoveListener(self)
end

function UILWDominatorGorillaTreatmentView:OnTreatSuccess(evtData)
  if not self.info or not evtData then
    return
  end
  self:PlayTreatmentAnim(evtData.preState)
  self:PlaySaoguangEffect(evtData.preState)
  if evtData.preState ~= evtData.curState then
    self:UpdateItems()
    self:UpdateInfo()
    self:UpdateHeart(true)
    if self.delayPlayIdleAnimTimer then
      self.delayPlayIdleAnimTimer:Stop()
      self.delayPlayIdleAnimTimer = nil
    end
    local isTreatmentFinish = evtData ~= nil and evtData.curState == DominatorGorillaTreatmentStage.Finish
    if not isTreatmentFinish then
      local crossStageAnim = self:GetCrossStageAnimByStage(evtData.preState)
      if not string.IsNullOrEmpty(crossStageAnim) then
        self:PlayUIAnim(crossStageAnim)
      end
      if self.delayOpenSuccessTimer ~= nil then
        self.delayOpenSuccessTimer:Stop()
      end
      self.delayOpenSuccessTimer = TimerManager:GetInstance():DelayInvoke(function()
        local function closeCallback()
          self.isTreatmentAnimPlaying = false
          
          self:PlayIdleAnim(true)
        end
        
        local function openCallback()
        end
        
        local param = {
          evtData = evtData,
          closeCallback = closeCallback,
          openCallback = openCallback
        }
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorGorillaTreatmentSuccess, {anim = true}, param)
      end, 2.5)
    else
      local plotEvtData = {
        plotGroupId = DominatorGorillaTreatmentFinishPlotGroupId.One
      }
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, plotEvtData)
    end
  else
    self.isTreatmentAnimPlaying = false
    self:UpdateItems()
    self:UpdateInfo()
    self:UpdateHeart(false)
  end
end

function UILWDominatorGorillaTreatmentView:GetCrossStageAnimByStage(stage)
  local anim = ""
  if stage == DominatorGorillaTreatmentStage.One then
    anim = "V_ui_UILWDominatorGorillaTreatment_switch_01"
  elseif stage == DominatorGorillaTreatmentStage.Two then
    anim = "V_ui_UILWDominatorGorillaTreatment_switch_02"
  elseif stage == DominatorGorillaTreatmentStage.Three then
    anim = "V_ui_UILWDominatorGorillaTreatment_switch_03"
  end
  return anim
end

function UILWDominatorGorillaTreatmentView:GetIdleAnimByStage(stage)
  local anim = ""
  if stage == DominatorGorillaTreatmentStage.One then
    anim = "weak01"
  elseif stage == DominatorGorillaTreatmentStage.Two then
    anim = "weak02"
  elseif stage == DominatorGorillaTreatmentStage.Three then
    anim = "weak03"
  end
  return anim
end

function UILWDominatorGorillaTreatmentView:GetTreatmentAnimByStage(stage)
  local anim = ""
  if stage == DominatorGorillaTreatmentStage.One then
    anim = "interact01"
  elseif stage == DominatorGorillaTreatmentStage.Two then
    anim = "interact02"
  elseif stage == DominatorGorillaTreatmentStage.Three then
    anim = "interact03"
  end
  return anim
end

function UILWDominatorGorillaTreatmentView:PlayIdleAnim(noFadeTime)
  if self.delayPlayIdleAnimTimer then
    self.delayPlayIdleAnimTimer:Stop()
    self.delayPlayIdleAnimTimer = nil
  end
  if not self.info or not self.compModelViewer then
    return
  end
  local curStage = self.info:GetCurTreatmentStage()
  local anim = self:GetIdleAnimByStage(curStage)
  if not string.IsNullOrEmpty(anim) and self.compModelViewer then
    if noFadeTime then
      self.compModelViewer:PlayModelAnim(anim)
    else
      self.compModelViewer:PlayModelAnim(anim, 0.2)
    end
  end
end

function UILWDominatorGorillaTreatmentView:PlayTreatmentAnim(stage)
  if not self.info then
    return
  end
  local idleAnim = self:GetIdleAnimByStage(stage)
  local treatmentAnim = self:GetTreatmentAnimByStage(stage)
  if not string.IsNullOrEmpty(treatmentAnim) and not string.IsNullOrEmpty(idleAnim) and not self.compModelViewer:IsPlayingModelAnim(treatmentAnim) then
    self.compModelViewer:PlayModelAnim(treatmentAnim, 0.2)
    if self.delayPlayIdleAnimTimer then
      self.delayPlayIdleAnimTimer:Stop()
      self.delayPlayIdleAnimTimer = nil
    end
    local animLength = self.compModelViewer:GetModelAnimClipLength(treatmentAnim)
    if animLength then
      self.delayPlayIdleAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:PlayIdleAnim(false)
      end, animLength)
    end
  end
end

function UILWDominatorGorillaTreatmentView:PlaySaoguangEffect(index)
  self.compEffUiDominatorSaoguang:SetActive(false)
  self.compEffUiDominatorSaoguang:SetActive(true)
end

function UILWDominatorGorillaTreatmentView:OnPlotGroupDone(plotGroupId)
  if plotGroupId ~= DominatorGorillaTreatmentFinishPlotGroupId.One then
    return
  end
  local crossStageAnim = self:GetCrossStageAnimByStage(DominatorGorillaTreatmentStage.Three)
  if not string.IsNullOrEmpty(crossStageAnim) then
    self:PlayUIAnim(crossStageAnim)
    if self.compUILWDominatorGorillaTreatmentItems then
      local delay = 0.5
      for i, v in pairs(self.compUILWDominatorGorillaTreatmentItems) do
        v:PlayFinishAnim(delay)
        delay = delay + 0.2
      end
    end
  end
  if self.delayOpenSuccessTimer ~= nil then
    self.delayOpenSuccessTimer:Stop()
  end
  self.delayOpenSuccessTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
    if not self.info then
      return
    end
    local curRankTemplate = self.info:GetCurRankTemplate()
    if curRankTemplate then
      local curRankShowTemplate = curRankTemplate:GetRankShowTemplate()
      if curRankShowTemplate and not string.IsNullOrEmpty(curRankShowTemplate.timeline_path) then
        local param = {
          curRankShowTemplate = curRankShowTemplate,
          closeCallback = function()
            local mainParam = {}
            mainParam.DefaultDominatorId = DominatorId.Gorilla
            mainParam.DefaultPageTag = UILWDominatorMainPageTag.Basic
            
            function mainParam.OpenCallback()
              local plotEvtData = {
                plotGroupId = DominatorGorillaTreatmentFinishPlotGroupId.Two
              }
              EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, plotEvtData)
            end
            
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorMain, {anim = true}, mainParam)
          end
        }
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorUpgradeBigRank, {anim = false}, param)
      end
    end
  end, 2)
end

function UILWDominatorGorillaTreatmentView:OnBtnInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("dominator_cure_desc_7")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UILWDominatorGorillaTreatmentView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UILWDominatorGorillaTreatmentView:OnBtnArchiveClick()
  if self.info then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorArchive, {anim = true}, self.info.uuid)
  end
end

function UILWDominatorGorillaTreatmentView:OnArchiveUnlock()
  self:UpdateArchiveBtn()
end

return UILWDominatorGorillaTreatmentView
