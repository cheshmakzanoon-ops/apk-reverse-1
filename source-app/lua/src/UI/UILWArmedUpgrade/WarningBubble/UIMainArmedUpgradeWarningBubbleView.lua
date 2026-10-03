local base = UIBaseContainer
local UIMainArmedUpgradeWarningBubbleView = BaseClass("UIMainArmedUpgradeWarningBubbleView", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local bgPos = Vector3.New(-12, -24, 0)
local anchorOffset = Vector3.New(10, 30, 0)
local anchorOffset_arabic = Vector3.New(-10, 30, 0)
local skeleton_path_normal = "Assets/Main/Prefabs/UI/LWMainSaveGirlWarningSkeleton/SaveGirlWarningSkeleton_Normal.prefab"
local effectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/Savegirlwarning/Eff_ui_savegirlwarning2.prefab"
local levelUpEffectPath = "Assets/Main/Prefabs/ArmedUpgrade/Eff_Monica_Up/Eff_ui_savegirlwarning_loop.prefab"
local spineAnim = {
  Idle = "Idle",
  Happy = "Gaoxing",
  Encourage = "Guli",
  Comfort = "Anwei"
}
local state = {
  Idle = 1,
  Happy = 2,
  Encourage = 3,
  Comfort = 4
}

function UIMainArmedUpgradeWarningBubbleView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainArmedUpgradeWarningBubbleView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainArmedUpgradeWarningBubbleView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBg = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBg:SetOnClick(function()
    self:OnBtnBgClick()
  end)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgRedDot = self.viewSkin:AddComponent(self, UIImage, 3)
  self.compEffNode = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compSkeletonNode = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.sliderProgress = self.viewSkin:AddComponent(self, UISlider, 6)
  self.textProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.imgMonikaIcon = self.viewSkin:AddComponent(self, UIImage, 8)
  self.textTip:SetLocalText("armed_upgrade_tips_1")
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.textTip:SetSizeDeltaXY(155, 35)
    self.textTip:SetAnchoredPositionXY(196, -22)
  else
    self.textTip:SetSizeDeltaXY(170, 35)
    self.textTip:SetAnchoredPositionXY(189, -22)
  end
end

function UIMainArmedUpgradeWarningBubbleView:ComponentDestroy()
  self.viewSkin = nil
  self.btnBg = nil
  self.textTip = nil
  self.imgRedDot = nil
  self.compEffNode = nil
  self.compSkeletonNode = nil
  self.sliderProgress = nil
  self.textProgress = nil
  self.imgMonikaIcon = nil
  self:DestroySpine()
end

function UIMainArmedUpgradeWarningBubbleView:DataDefine()
  self.state = state.Idle
  self.ignorePlotBubbleOnce = nil
  self.curPlayPlotId = 0
  self.canLevelUp = false
end

function UIMainArmedUpgradeWarningBubbleView:DataDestroy()
  self.state = state.Idle
  self.ignorePlotBubbleOnce = nil
  self.curPlayPlotId = nil
  self.canLevelUp = nil
end

function UIMainArmedUpgradeWarningBubbleView:OnEnable()
  base.OnEnable(self)
  EventManager:GetInstance():Broadcast(EventId.MainUILeftPosRefresh)
end

function UIMainArmedUpgradeWarningBubbleView:OnDisable()
  EventManager:GetInstance():Broadcast(EventId.MainUILeftPosRefresh)
  self:ClearTween()
  self:ClearEffect()
  self:ClearTimer()
  self:TryRemovePlotBubble()
  self:ClearCanLevelUpEffect()
  self.btnBg:SetActive(false)
  base.OnDisable(self)
end

function UIMainArmedUpgradeWarningBubbleView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshRed)
  self:AddUIListener(EventId.MonopolyPlayerCreated, self.OnPlayerCreated)
  self:AddUIListener(EventId.MonopolyPlayerWin, self.OnPlayerWin)
  self:AddUIListener(EventId.MonopolyPlayerLose, self.OnPlayerLose)
  self:AddUIListener(EventId.MonopolyPlayerExit, self.OnPlayerLose)
end

function UIMainArmedUpgradeWarningBubbleView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshRed)
  self:RemoveUIListener(EventId.MonopolyPlayerCreated, self.OnPlayerCreated)
  self:RemoveUIListener(EventId.MonopolyPlayerWin, self.OnPlayerWin)
  self:RemoveUIListener(EventId.MonopolyPlayerLose, self.OnPlayerLose)
  self:RemoveUIListener(EventId.MonopolyPlayerExit, self.OnPlayerLose)
  base.OnRemoveListener(self)
end

function UIMainArmedUpgradeWarningBubbleView:ReInit()
  local old = self.btnBg:GetActive()
  self.btnBg:SetActive(true)
  if old == false then
    self:ClearTween()
    self.btnBg.transform:Set_localPosition(-400, -24, 0)
    self.tween = self.btnBg.transform:DOLocalMove(bgPos, 0.5)
  end
  self:RefreshRed()
  self:RefreshArmedUpgradeProgress()
  local iconPath = string.format(LoadPath.UILWArmedUpgradeIconPath, "zxl_xinshou_jichenv")
  if LuaEntry.Player.JPUser then
    iconPath = string.format(LoadPath.UILWArmedUpgradeIconPath, "mjc_xinshou_jichenv")
  end
  self.imgMonikaIcon:LoadSpriteAuto(iconPath)
  self:PlayState()
end

function UIMainArmedUpgradeWarningBubbleView:LoadSpine()
  if self.spineReq == nil then
    self.spineReq = ResourceManager:InstantiateAsync(skeleton_path_normal)
    self.spineReq:completed("+", function(request)
      if request.isError then
        return
      end
      if IsNull(self.compSkeletonNode) then
        request:Destroy()
        return
      end
      local go = request.gameObject
      if self.compSkeletonNode then
        go:SetActive(true)
        go.transform:SetParent(self.compSkeletonNode.transform)
        go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local sp = go.transform:Find("ImgSpine")
        if not IsNull(sp) then
          self.spine = sp:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
        end
        self:PlayState()
      end
    end)
  end
end

function UIMainArmedUpgradeWarningBubbleView:DestroySpine()
  if self.spineReq then
    self.spineReq:Destroy()
    self.spineReq = nil
  end
  self.spine = nil
end

function UIMainArmedUpgradeWarningBubbleView:OnPlayerCreated(idle)
  if idle then
    self.state = state.Idle
    self:PlayState()
  end
end

function UIMainArmedUpgradeWarningBubbleView:OnPlayerWin()
  self.state = state.Encourage
  local HappyMonopolyIdMap = DataCenter.LWArmedUpgradeManager:GetHappyMonopolyIdMap()
  local cur = 0
  local mgr = DataCenter.MonopolyManager
  if mgr and mgr.player then
    cur = mgr.player.curId or 0
  end
  if HappyMonopolyIdMap and HappyMonopolyIdMap[cur] then
    self.state = state.Happy
  end
  self:PlayState()
end

function UIMainArmedUpgradeWarningBubbleView:OnPlayerLose()
  self.state = state.Comfort
  self:PlayState()
end

function UIMainArmedUpgradeWarningBubbleView:PlayState()
  local ignorePlotBubbleOnce = self.ignorePlotBubbleOnce
  self.ignorePlotBubbleOnce = nil
  local plotId = 0
  if self.state == state.Idle then
    plotId = DataCenter.LWArmedUpgradeManager:GetUIMainIdlePlot()
  elseif self.state == state.Happy then
    plotId = DataCenter.LWArmedUpgradeManager:GetUIMainHappyPlot()
  elseif self.state == state.Encourage then
    plotId = DataCenter.LWArmedUpgradeManager:GetUIMainEncouragePlot()
  elseif self.state == state.Comfort then
    plotId = DataCenter.LWArmedUpgradeManager:GetUIMainComfortPlot()
  end
  if 0 < plotId and not ignorePlotBubbleOnce then
    self:TryRemovePlotBubble()
    self:ShowPlotBubble(plotId)
  end
  if self.timer == nil then
    local interval = DataCenter.LWArmedUpgradeManager:GetUIMainPlotInterval()
    self.timer = TimerManager:GetInstance():GetTimer(interval, self.LoopState, self, false, false, false)
    self.timer:Start()
  else
    self.timer:Reset()
  end
end

function UIMainArmedUpgradeWarningBubbleView:LoopState()
  if self.state ~= state.Idle then
    self.state = state.Idle
  end
  local plotId = DataCenter.LWArmedUpgradeManager:GetUIMainIdlePlot()
  if 0 < plotId and self:GetActive() then
    self:TryRemovePlotBubble()
    self:ShowPlotBubble(plotId)
  end
end

function UIMainArmedUpgradeWarningBubbleView:ClearTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainArmedUpgradeWarningBubbleView:ShowPlotBubble(plotId)
  self.curPlayPlotId = plotId
  local bubbleParams = {}
  bubbleParams.plotId = plotId
  bubbleParams.anchor = CommonUtil.IsArabicAutoMirrorOpen() and anchorOffset_arabic or anchorOffset
  bubbleParams.mode = "2DFollow"
  bubbleParams.followTarget = self.compSkeletonNode.transform
  bubbleParams.uiLayer = UILayer.UIResource.Name
  EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleOnlyId, bubbleParams)
end

function UIMainArmedUpgradeWarningBubbleView:TryRemovePlotBubble()
  if self.curPlayPlotId > 0 then
    EventManager:GetInstance():Broadcast(EventId.RemovePlotBubbleById, self.curPlayPlotId)
    self.curPlayPlotId = 0
  end
end

function UIMainArmedUpgradeWarningBubbleView:OnEffect()
  self:ClearEffect()
  if self.effectReq == nil then
    self.effectReq = self:GameObjectInstantiateAsync(effectPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      local effectTransform = go.transform
      if self.compEffNode then
        effectTransform:SetParent(self.compEffNode.transform)
        effectTransform:Set_localPosition(0, 0, 0)
        effectTransform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      end
    end)
  end
end

function UIMainArmedUpgradeWarningBubbleView:ClearEffect()
  if self.effectReq then
    self:GameObjectDestroy(self.effectReq)
    self.effectReq = nil
  end
end

function UIMainArmedUpgradeWarningBubbleView:RefreshShowCanLevelUpEffect()
  if self.levelUpEffectReq == nil then
    self.levelUpEffectReq = self:GameObjectInstantiateAsync(levelUpEffectPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(self.canLevelUp)
      self.canLevelUpEffectObj = go
      local effectTransform = go.transform
      if self.compEffNode then
        effectTransform:SetParent(self.compEffNode.transform)
        effectTransform:Set_localPosition(0, 0, 0)
        effectTransform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      end
    end)
  elseif not IsNull(self.canLevelUpEffectObj) then
    self.canLevelUpEffectObj:SetActive(self.canLevelUp)
  end
end

function UIMainArmedUpgradeWarningBubbleView:ClearCanLevelUpEffect()
  if self.levelUpEffectReq then
    self:GameObjectDestroy(self.levelUpEffectReq)
    self.canLevelUpEffectObj = nil
    self.levelUpEffectReq = nil
  end
end

function UIMainArmedUpgradeWarningBubbleView:RefreshArmedUpgradeProgress()
  local curLevel = DataCenter.LWArmedUpgradeManager.armedUpgradeLevel
  local maxLevel = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeMaxLevel()
  local value = Mathf.Clamp01(curLevel / maxLevel)
  self.sliderProgress:SetValue(value)
  self.textProgress:SetText(string.format("%s/%s", curLevel, maxLevel))
end

function UIMainArmedUpgradeWarningBubbleView:RefreshRed()
  local isMaxLevel = DataCenter.LWArmedUpgradeManager:IsAchieveArmedUpgradeMaxLevel()
  if isMaxLevel then
    return
  end
  local levelUpCondition, canLevelUp = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeCanLevelUpData()
  self.canLevelUp = canLevelUp
  self.imgRedDot:SetActive(canLevelUp)
  self:RefreshShowCanLevelUpEffect()
end

function UIMainArmedUpgradeWarningBubbleView:OnPreFly()
  self.btnBg:SetActive(false)
end

function UIMainArmedUpgradeWarningBubbleView:SetIgnorePlotBubbleOnce()
  self.ignorePlotBubbleOnce = true
end

function UIMainArmedUpgradeWarningBubbleView:ClearTween()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
end

function UIMainArmedUpgradeWarningBubbleView:OnBtnBgClick()
  DataCenter.LWArmedUpgradeManager:JumpToArmedUpgradeCityModel()
  CommonUtil.FeatureExplorationTrack(FeatureExplorationType.MonicaUI)
end

return UIMainArmedUpgradeWarningBubbleView
