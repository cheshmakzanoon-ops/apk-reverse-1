local UIBuildQueueBubbleView = BaseClass("UIBuildQueueBubbleView", UIBaseView)
local base = UIBaseView
local harmer_path = "icon"
local bubble_path = "bubble"
local bubble_btn = "bubble/bubble_btn/"
local bubble_btn_text_path = "bubble/bubble_btn/bubble_btn_text"
local EMPTY_ICON = "Assets/Main/Sprites/UI/UIBuildQueue/zyf_chengjian_dikuai.png"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.harmer = self:AddComponent(UIBaseContainer, harmer_path)
  self.bubble = self:AddComponent(UIBaseContainer, bubble_path)
  self.bubble_btn = self:AddComponent(UIButton, bubble_btn)
  self.bubble_btn_text = self:AddComponent(UIText, bubble_btn_text_path)
  self.bubble_btn_text:SetLocalText(135226)
  self.bubble_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorkerQueue)
  end)
  self.close = self:AddComponent(UIButton, "bubble/close_btn")
  self.close:SetOnClick(function()
    self:CloseBubble()
  end)
  self.slider = self:AddComponent(UISlider, "bubble/cell/TimeSlider_up")
  self.icon = self:AddComponent(UIImage, "bubble/cell/Common_img_construction")
  self.des_text = self:AddComponent(UIText, "bubble/cell/TimeSlider_up/TimeSliderText")
  self:CloseBubble()
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ShowBuildQueueTip, self.ShowBubble)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ShowBuildQueueTip, self.ShowBubble)
end

local function Refresh(self)
  local uid = DataCenter.BuildQueueManager:GetQueueByIndex(1).itemObj.itemId
  if uid == nil then
    self.state = UIBuildQueueState.Free
  else
    self.state = UIBuildQueueState.Work
  end
  self.uid = uid
  self:RefreshState()
  self:RefreshSlider(UITimeManager:GetInstance():GetServerTime())
end

local function Update(self)
  if self.slider then
    self:RefreshSlider(UITimeManager:GetInstance():GetServerTime())
  end
end

local function CloseBubble(self)
  self.bubble.transform:Set_localScale(0, 0, 0)
end

local function RefreshSlider(self, curTime)
  if self.state == UIBuildQueueState.Work then
    local changeTime = self.endTime - curTime
    local maxTime = self.endTime - self.startTime
    if 0 < changeTime then
      local tempTimeSec = math.ceil(changeTime / 1000)
      if tempTimeSec ~= self.laseTime then
        self.laseTime = tempTimeSec
        local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
        self.des_text:SetText(tempTimeValue)
      end
      if 0 < maxTime then
        local tempValue = 1 - changeTime / maxTime
        self.slider:SetValue(tempValue)
      end
    else
      self:ChangeState(UIBuildQueueState.Free)
    end
  end
end

local function RefreshState(self)
  if self.state == UIBuildQueueState.Free then
    self.icon:LoadSprite(EMPTY_ICON)
    self.icon:SetNativeSize()
    self.icon.transform.localScale = UIBuildQueueImageTypeScale.Unlock
    self.des_text.gameObject:SetActive(false)
    self.slider:SetValue(0)
    self.slider.gameObject:SetActive(false)
  elseif self.state == UIBuildQueueState.Work then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.uid)
    if buildData ~= nil then
      self.des_text.gameObject:SetActive(true)
      self.slider.gameObject:SetActive(true)
      self.endTime = buildData.updateTime
      local cur = UITimeManager:GetInstance():GetServerTime()
      self.startTime = buildData.startTime
      if cur < self.startTime then
        self.startTime = cur
      end
      self.icon:LoadSpriteAsyncWithCallback(DataCenter.BuildManager:GetBuildIconPath(buildData.itemId, buildData.level), function()
        if self and self.icon then
          self.icon:SetNativeSize()
        end
      end)
      self.icon.transform.localScale = UIBuildQueueImageTypeScale.Build
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
      if template ~= nil then
      end
    end
  end
end

local function ShowBubble()
end

local function ChangeState(self, state)
  if self.state ~= nil then
    self.state = state
    self:RefreshState()
  end
end

UIBuildQueueBubbleView.OnCreate = OnCreate
UIBuildQueueBubbleView.OnDestroy = OnDestroy
UIBuildQueueBubbleView.OnEnable = OnEnable
UIBuildQueueBubbleView.OnDisable = OnDisable
UIBuildQueueBubbleView.OnAddListener = OnAddListener
UIBuildQueueBubbleView.OnRemoveListener = OnRemoveListener
UIBuildQueueBubbleView.ComponentDefine = ComponentDefine
UIBuildQueueBubbleView.ComponentDestroy = ComponentDestroy
UIBuildQueueBubbleView.DataDefine = DataDefine
UIBuildQueueBubbleView.DataDestroy = DataDestroy
UIBuildQueueBubbleView.ReInit = ReInit
UIBuildQueueBubbleView.Refresh = Refresh
UIBuildQueueBubbleView.Update = Update
UIBuildQueueBubbleView.ShowBubble = ShowBubble
UIBuildQueueBubbleView.CloseBubble = CloseBubble
UIBuildQueueBubbleView.RefreshSlider = RefreshSlider
UIBuildQueueBubbleView.RefreshState = RefreshState
UIBuildQueueBubbleView.ChangeState = ChangeState
return UIBuildQueueBubbleView
