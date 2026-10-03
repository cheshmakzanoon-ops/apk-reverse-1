local UIMainSaveGirlBubbleView = BaseClass("UIMainSaveGirlBubbleView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local bgPos = Vector3.New(-12, -24, 0)
local bg_path = "bg"
local tip_path = "bg/tip"
local time_path = "bg/time"
local red_dot_path = "bg/redDot"
local eff_node_path = "bg/effNode"
local skeleton_node_path = "bg/SkeletonNode"
local anchorOffset = Vector3.New(10, 30, 0)
local anchorOffset_arabic = Vector3.New(-10, 30, 0)
local skeleton_path_normal = "Assets/Main/Prefabs/UI/LWMainSaveGirlWarningSkeleton/SaveGirlWarningSkeleton_Normal.prefab"
local skeleton_path_jp = "Assets/Main/Prefabs/UI/LWMainSaveGirlWarningSkeleton/SaveGirlWarningSkeleton_Jp.prefab"
local effectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/Savegirlwarning/Eff_ui_savegirlwarning2.prefab"
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

function UIMainSaveGirlBubbleView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainSaveGirlBubbleView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainSaveGirlBubbleView:ComponentDefine()
  self.bg = self:AddComponent(UIButton, bg_path)
  self.tip = self:AddComponent(UITextMeshProUGUIEx, tip_path)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.red_dot = self:AddComponent(UIImage, red_dot_path)
  self.eff_node = self:AddComponent(UIBaseContainer, eff_node_path)
  self.tip:SetText(Localization:GetString("save_girl_tips_4"))
  self.bg:SetOnClick(function()
    self:OnClick()
  end)
  self.skeleton_node = self:AddComponent(UIBaseContainer, skeleton_node_path)
  self.state = state.Idle
  self.ignorePlotBubbleOnce = nil
end

function UIMainSaveGirlBubbleView:LoadSpine()
  if self.bg == nil then
    return
  end
  if self.req == nil then
    local path = skeleton_path_normal
    if LuaEntry.Player.JPUser and DataCenter.LWSaveGirlManager:IsJPGirlOpen() then
      path = skeleton_path_jp
    end
    self.req = ResourceManager:InstantiateAsync(path)
    self.req:completed("+", function(handle)
      if handle.isError then
        return
      end
      if IsNull(self.skeleton_node) then
        handle:Destroy()
        return
      end
      local go = handle.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.skeleton_node.transform)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local sp = go.transform:Find("ImgSpine")
      if not IsNull(sp) then
        self.spine = sp:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
      end
      self:PlayState()
    end)
  end
end

function UIMainSaveGirlBubbleView:ComponentDestroy()
  self.bg = nil
  self.tip = nil
  self.time = nil
  self.red_dot = nil
  self.eff_node = nil
  self.ignorePlotBubbleOnce = nil
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.spine = nil
  self.skeleton_node = nil
end

function UIMainSaveGirlBubbleView:OnEnable()
  base.OnEnable(self)
  EventManager:GetInstance():Broadcast(EventId.MainUILeftPosRefresh)
end

function UIMainSaveGirlBubbleView:OnDisable()
  EventManager:GetInstance():Broadcast(EventId.MainUILeftPosRefresh)
  self:ClearTween()
  self:ClearEffect()
  self:ClearTimer()
  self.bg:SetActive(false)
  base.OnDisable(self)
end

function UIMainSaveGirlBubbleView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshRed)
  self:AddUIListener(EventId.MonopolyPlayerCreated, self.OnPlayerCreated)
  self:AddUIListener(EventId.MonopolyPlayerWin, self.OnPlayerWin)
  self:AddUIListener(EventId.MonopolyPlayerLose, self.OnPlayerLose)
  self:AddUIListener(EventId.MonopolyPlayerExit, self.OnPlayerLose)
end

function UIMainSaveGirlBubbleView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshRed)
  self:RemoveUIListener(EventId.MonopolyPlayerCreated, self.OnPlayerCreated)
  self:RemoveUIListener(EventId.MonopolyPlayerWin, self.OnPlayerWin)
  self:RemoveUIListener(EventId.MonopolyPlayerLose, self.OnPlayerLose)
  self:RemoveUIListener(EventId.MonopolyPlayerExit, self.OnPlayerLose)
  base.OnRemoveListener(self)
end

function UIMainSaveGirlBubbleView:OnPlayerCreated(idle)
  if idle then
    self.state = state.Idle
    self:PlayState()
  end
end

function UIMainSaveGirlBubbleView:OnPlayerWin()
  self.state = state.Encourage
  local HappyMonopolyIdMap = DataCenter.LWSaveGirlManager:GetHappyMonopolyIdMap()
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

function UIMainSaveGirlBubbleView:OnPlayerLose()
  self.state = state.Comfort
  self:PlayState()
end

function UIMainSaveGirlBubbleView:SetIgnorePlotBubbleOnce()
  self.ignorePlotBubbleOnce = true
end

function UIMainSaveGirlBubbleView:PlayState()
  if IsNull(self.spine) then
    return
  end
  local ignorePlotBubbleOnce = self.ignorePlotBubbleOnce
  self.ignorePlotBubbleOnce = nil
  local plotId = 0
  if self.state == state.Idle then
    self.spine.AnimationState:SetAnimation(0, spineAnim.Idle, true)
    plotId = DataCenter.LWSaveGirlManager:GetUIMainIdlePlot()
  elseif self.state == state.Happy then
    self.spine.AnimationState:SetAnimation(0, spineAnim.Happy, true)
    plotId = DataCenter.LWSaveGirlManager:GetUIMainHappyPlot()
  elseif self.state == state.Encourage then
    self.spine.AnimationState:SetAnimation(0, spineAnim.Encourage, true)
    plotId = DataCenter.LWSaveGirlManager:GetUIMainEncouragePlot()
  elseif self.state == state.Comfort then
    self.spine.AnimationState:SetAnimation(0, spineAnim.Comfort, true)
    plotId = DataCenter.LWSaveGirlManager:GetUIMainComfortPlot()
  end
  if 0 < plotId and self:GetActive() and not ignorePlotBubbleOnce then
    local bubbleParams = {}
    bubbleParams.plotId = plotId
    bubbleParams.anchor = CommonUtil.IsArabicAutoMirrorOpen() and anchorOffset_arabic or anchorOffset
    bubbleParams.mode = "2DFollow"
    bubbleParams.followTarget = self.skeleton_node.transform
    bubbleParams.uiLayer = UILayer.UIResource.Name
    EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
  end
  if self.timer == nil then
    local interval = DataCenter.LWSaveGirlManager:GetUIMainPlotInterval()
    self.timer = TimerManager:GetInstance():GetTimer(interval, self.LoopState, self, false, false, false)
    self.timer:Start()
  else
    self.timer:Reset()
  end
end

function UIMainSaveGirlBubbleView:LoopState()
  if self.state ~= state.Idle then
    self.state = state.Idle
    self.spine.AnimationState:SetAnimation(0, spineAnim.Idle, true)
  end
  local plotId = DataCenter.LWSaveGirlManager:GetUIMainIdlePlot()
  if 0 < plotId and self:GetActive() then
    local bubbleParams = {}
    bubbleParams.plotId = plotId
    bubbleParams.anchor = CommonUtil.IsArabicAutoMirrorOpen() and anchorOffset_arabic or anchorOffset
    bubbleParams.mode = "2DFollow"
    bubbleParams.followTarget = self.skeleton_node.transform
    bubbleParams.uiLayer = UILayer.UIResource.Name
    EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
  end
end

function UIMainSaveGirlBubbleView:ClearTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainSaveGirlBubbleView:OnPreFly()
  self.bg:SetActive(false)
end

function UIMainSaveGirlBubbleView:OnEffect()
  self:ClearEffect()
  if not self.effectObj then
    self.effectObj = self:GameObjectInstantiateAsync(effectPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      local effectTransform = go.transform
      effectTransform:SetParent(self.eff_node.transform)
      effectTransform:Set_localPosition(0, 0, 0)
      effectTransform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    end)
  end
end

function UIMainSaveGirlBubbleView:ClearEffect()
  if self.effectObj then
    self:GameObjectDestroy(self.effectObj)
    self.effectObj = nil
  end
end

function UIMainSaveGirlBubbleView:ReInit()
  local old = self.bg:GetActive()
  self.bg:SetActive(true)
  if old == false then
    self:ClearTween()
    self.bg.transform:Set_localPosition(-400, -24, 0)
    self.tween = self.bg.transform:DOLocalMove(bgPos, 0.5)
  end
  self:UpdateTime()
  self:RefreshRed()
  self:LoadSpine()
end

function UIMainSaveGirlBubbleView:RefreshRed()
  local costItemId = DataCenter.LWSaveGirlManager:GetCostItemId()
  local itemCount = DataCenter.ItemData:GetItemCount(costItemId)
  if 0 < itemCount then
    self.red_dot:SetActive(true)
  else
    self.red_dot:SetActive(false)
  end
end

function UIMainSaveGirlBubbleView:UpdateTime()
  local endTime = DataCenter.LWSaveGirlManager:GetWarningEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local diff = endTime - curTime
  self.time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff))
end

function UIMainSaveGirlBubbleView:OnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSaveGirl)
end

function UIMainSaveGirlBubbleView:ClearTween()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
end

return UIMainSaveGirlBubbleView
