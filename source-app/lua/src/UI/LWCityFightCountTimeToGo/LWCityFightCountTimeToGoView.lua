local LWCityFightCountTimeToGoView = BaseClass("LWCityFightCountTimeToGoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local main_animatorPath = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textTip1 = self:AddComponent(UIText, "Bg/node/tip1")
  self.textTip2 = self:AddComponent(UIText, "Bg/node/tip2")
  self.mainAnimator = self:AddComponent(UIAnimator, main_animatorPath)
  self:ReInit()
end

function LWCityFightCountTimeToGoView:ReInit()
  self.valid = false
  local userData = self:GetUserData()
  self.protectTime = userData and userData.protectTime
  if not self.protectTime or self.protectTime <= 0 then
    local declareInfo = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
    if not declareInfo or not declareInfo.content then
      return
    end
    self.protectTime = DataCenter.WorldAllianceCityDataManager:GetCityProtectTime(tonumber(declareInfo.content))
  end
  self.finalTxt = userData and userData.finalTxt or "GO"
  local lastTips = userData and userData.lastTips or "city_event_desc73"
  self.textTip2:SetLocalText(lastTips)
  local now = UITimeManager:GetInstance():GetServerTime()
  self.valid = now < self.protectTime
  if self.valid and self.mainAnimator then
    self.mainAnimator:Play("V_ui_LWCityFightCountTimeToGo_go", 0, 0)
  end
  self:UpdateTime()
end

function LWCityFightCountTimeToGoView:Update1000MS()
  if self.valid then
    self:UpdateTime()
  end
end

function LWCityFightCountTimeToGoView:UpdateTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local diff = self.protectTime - curTime
  self.textTip1:SetText(diff // 1000)
  if diff <= 0 then
    self.valid = false
    if self.closeAnimTimer then
      self.closeAnimTimer:Stop()
      self.closeAnimTimer = nil
    end
    if self.mainAnimator then
      local success, time = self.mainAnimator:PlayAnimationReturnTime("V_ui_LWCityFightCountTimeToGo_text")
      if success then
        self.closeAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
          self.ctrl:CloseSelf()
        end, time)
      else
        self.ctrl:CloseSelf()
      end
    end
    self.textTip1:SetText(self.finalTxt)
  end
end

local function ComponentDestroy(self)
  if self.closeAnimTimer then
    self.closeAnimTimer:Stop()
    self.closeAnimTimer = nil
  end
  self.mainAnimator = nil
  self.textTip1 = nil
  self.textTip2 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnBgClick(self)
end

LWCityFightCountTimeToGoView.OnCreate = OnCreate
LWCityFightCountTimeToGoView.OnDestroy = OnDestroy
LWCityFightCountTimeToGoView.OnEnable = OnEnable
LWCityFightCountTimeToGoView.OnDisable = OnDisable
LWCityFightCountTimeToGoView.ComponentDefine = ComponentDefine
LWCityFightCountTimeToGoView.ComponentDestroy = ComponentDestroy
LWCityFightCountTimeToGoView.DataDefine = DataDefine
LWCityFightCountTimeToGoView.DataDestroy = DataDestroy
LWCityFightCountTimeToGoView.OnAddListener = OnAddListener
LWCityFightCountTimeToGoView.OnRemoveListener = OnRemoveListener
LWCityFightCountTimeToGoView.OnBtnBgClick = OnBtnBgClick
return LWCityFightCountTimeToGoView
