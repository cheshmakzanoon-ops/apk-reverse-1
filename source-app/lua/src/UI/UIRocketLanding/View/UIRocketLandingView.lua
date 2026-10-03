local UIRocketLandingView = BaseClass("UIRocketLandingView", UIBaseView)
local base = UIBaseView
local RocketLandingScene = require("Scene.RocketLandingScene.RocketLandingScene")
local DubName = "controlTower1"
local drag_go_path = "AnimGo/DragGo"
local left_btn_path = "AnimGo/LeftBtn"
local right_btn_path = "AnimGo/RightBtn"
local arrived_btn_path = "AnimGo/ArrivedBtn"
local anim_go_path = "AnimGo"
local RecordStart = 1102
local HideBtnState = {
  ClickLeft = 1,
  ClickRight = 2,
  Show = 3
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:DestroyScene()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.drag_go = self:AddComponent(UIEventTrigger, drag_go_path)
  self.left_btn = self:AddComponent(UIEventTrigger, left_btn_path)
  self.right_btn = self:AddComponent(UIEventTrigger, right_btn_path)
  self.arrived_btn = self:AddComponent(UIButton, arrived_btn_path)
  self.anim_go = self:AddComponent(UIAnimator, anim_go_path)
  self.arrived_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.left_btn:OnPointerDown(function()
    self:StartRotateModel(true)
  end)
  self.left_btn:OnPointerUp(function()
    self:StopRotateModel()
  end)
  self.right_btn:OnPointerDown(function()
    self:StartRotateModel(false)
  end)
  self.right_btn:OnPointerUp(function()
    self:StopRotateModel()
  end)
  self.drag_go:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.drag_go:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.drag_go:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
end

local function ComponentDestroy(self)
  self.drag_go = nil
  self.left_btn = nil
  self.right_btn = nil
  self.arrived_btn = nil
  self.anim_go = nil
end

local function DataDefine(self)
  self.scene = nil
  self.lastPosX = 0
  self.isCanDrag = nil
  self.selectTimer = nil
  self.rightActive = true
  self.leftActive = true
  self.canClick = false
  self.dubId = nil
  self.isNeedPreLoad = false
end

local function DataDestroy(self)
  DataCenter.LWSoundManager:StopSound(self.dubId)
  self:RemoveCloseTimer()
  self.selectTimer = nil
  self.scene = nil
  self.lastPosX = nil
  self.isCanDrag = nil
  self.rightActive = nil
  self.leftActive = nil
  self.canClick = nil
  self.dubId = nil
  self.isNeedPreLoad = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self:Refresh()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UIRocketLandingPlay, self.UIRocketLandingPlaySignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UIRocketLandingPlay, self.UIRocketLandingPlaySignal)
end

local function Refresh(self)
  self:LoadScene()
end

local function OnBtnClick(self)
  if self.canClick then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.canClick = false
    if self.isNeedPreLoad then
      DataCenter.GuideCityAnimManager:StartPlay(GuideAnimObjectType.Scene)
    else
      DataCenter.GuideManager:DoGuide()
    end
    self.ctrl:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMain, {})
  end
end

local function LoadScene(self)
  self:GameObjectInstantiateAsync(UIAssets.RocketLandingScene, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:Set_localPosition(0, -1000, 0)
    self.scene = RocketLandingScene.New()
    self.scene:OnCreate(request)
    self.scene:ReInit()
  end)
end

local function DestroyScene(self)
  if self.scene ~= nil then
    self.scene:OnDestroy()
    self.scene = nil
  end
end

local function StartRotateModel(self, isLeft)
  if self.isCanDrag then
    if isLeft then
      self:RefreshHideBtnState(HideBtnState.ClickLeft)
    else
      self:RefreshHideBtnState(HideBtnState.ClickRight)
    end
    if self.scene ~= nil then
      self.scene:StartRotateModel(isLeft)
    end
  end
end

local function StopRotateModel(self)
  if self.isCanDrag then
    self:RefreshHideBtnState(HideBtnState.Show)
    if self.scene ~= nil then
      self.scene:StopRotateModel()
    end
  end
end

local function OnDrag(self, eventData)
  if self.isCanDrag then
    local curX = eventData.position.x
    if curX < self.lastPosX then
      self:RefreshHideBtnState(HideBtnState.ClickRight)
    elseif curX > self.lastPosX then
      self:RefreshHideBtnState(HideBtnState.ClickLeft)
    end
    self.lastPosX = curX
    if self.scene ~= nil then
      self.scene:OnDrag(eventData)
    end
  end
end

local function OnEndDrag(self, eventData)
  self:StopRotateModel()
end

local function OnBeginDrag(self, eventData)
  if self.isCanDrag then
    self.lastPosX = eventData.position.x
    if self.scene ~= nil then
      self.scene:OnBeginDrag(eventData)
    end
  end
end

local function Update(self)
  if self.scene ~= nil and self.isCanDrag then
    self.scene:Update()
  end
end

local function UIRocketLandingPlaySignal(self, playType)
  local guideName = tostring(RecordStart)
  DataCenter.GuideManager:SendLogToNet(guideName, StatTTType.Special)
  if playType ~= nil then
    self.rightActive = true
    self.leftActive = true
    self.isCanDrag = true
    self.canClick = false
    CommonUtil.PlayGameBgMusic()
    self.dubId = DataCenter.LWSoundManager:PlayDub(DubName)
    local playTypeNum = tonumber(playType)
    local animName = "EnterQuick"
    if playTypeNum == UIRocketLandingPlayType.Enter then
      animName = "Enter"
    elseif playTypeNum == UIRocketLandingPlayType.Quick then
      animName = "EnterQuick"
    end
    local ret, time = self.anim_go:PlayAnimationReturnTime(animName)
    if ret and self.selectTimer == nil then
      self.selectTimer = TimerManager:GetInstance():GetTimer(time, function()
        self:RemoveCloseTimer()
        self.left_btn:SetActive(false)
        self.right_btn:SetActive(false)
        self.isCanDrag = false
        self.canClick = true
      end, self, true, false, false)
      self.selectTimer:Start()
    end
    TimerManager:GetInstance():DelayInvoke(function()
      self.isNeedPreLoad = DataCenter.GuideManager:GetGuideType() == GuideType.PlayMovie
      if self.isNeedPreLoad then
        DataCenter.GuideManager:DoGuide()
      end
    end, 1)
  end
end

local function RefreshHideBtnState(self, hideBtnState)
  local leftActive = hideBtnState == HideBtnState.ClickLeft or hideBtnState == HideBtnState.Show
  local rightActive = hideBtnState == HideBtnState.ClickRight or hideBtnState == HideBtnState.Show
  if self.leftActive ~= leftActive then
    self.leftActive = leftActive
    self.left_btn:SetActive(leftActive)
  end
  if self.rightActive ~= rightActive then
    self.rightActive = rightActive
    self.right_btn:SetActive(rightActive)
  end
end

local function RemoveCloseTimer(self)
  if self.selectTimer ~= nil then
    self.selectTimer:Stop()
    self.selectTimer = nil
  end
end

UIRocketLandingView.OnCreate = OnCreate
UIRocketLandingView.OnDestroy = OnDestroy
UIRocketLandingView.OnEnable = OnEnable
UIRocketLandingView.OnDisable = OnDisable
UIRocketLandingView.OnAddListener = OnAddListener
UIRocketLandingView.OnRemoveListener = OnRemoveListener
UIRocketLandingView.ComponentDefine = ComponentDefine
UIRocketLandingView.ComponentDestroy = ComponentDestroy
UIRocketLandingView.DataDefine = DataDefine
UIRocketLandingView.DataDestroy = DataDestroy
UIRocketLandingView.ReInit = ReInit
UIRocketLandingView.Refresh = Refresh
UIRocketLandingView.OnBtnClick = OnBtnClick
UIRocketLandingView.DestroyScene = DestroyScene
UIRocketLandingView.LoadScene = LoadScene
UIRocketLandingView.StartRotateModel = StartRotateModel
UIRocketLandingView.StopRotateModel = StopRotateModel
UIRocketLandingView.OnDrag = OnDrag
UIRocketLandingView.OnBeginDrag = OnBeginDrag
UIRocketLandingView.Update = Update
UIRocketLandingView.UIRocketLandingPlaySignal = UIRocketLandingPlaySignal
UIRocketLandingView.RefreshHideBtnState = RefreshHideBtnState
UIRocketLandingView.RemoveCloseTimer = RemoveCloseTimer
UIRocketLandingView.OnEndDrag = OnEndDrag
return UIRocketLandingView
