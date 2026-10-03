local UIReachLimitView = BaseClass("UIReachLimitView", UIBaseView)
local base = UIBaseView
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local txt_des_path = "DesText"
local txt_des1_path = "DesText1"
local txt_next_title_path = "NextTitle"
local title_text_path = "UICommonMiniPopUpTitle/titleText"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"

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
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.txt_des = self:AddComponent(UIText, txt_des_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.txt_des1 = self:AddComponent(UIText, txt_des1_path)
  self.txt_next_title = self:AddComponent(UIText, txt_next_title_path)
  self.txt_next_title:SetLocalText(130346)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.return_btn = nil
  self.txt_des = nil
  self.close_btn = nil
end

local function DataDefine(self)
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.type = self:GetUserData()
  self.endTime = 0
  self.rewardList = {}
end

local function DataDestroy(self)
  self.timer_action = nil
  self:DeleteTimer()
  self.endTime = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  if self.type == NextBusinessComeType.RESIDENT_ORDER or self.type == NextBusinessComeType.GROCERY_STORE then
    local resTime = UITimeManager:GetInstance():GetResSecondsTo24() + 1
    self.endTime = UITimeManager:GetInstance():GetServerTime() + resTime * 1000
    self.txt_des1:SetActive(false)
    self.txt_next_title:SetActive(false)
    self.txt_des:SetActive(true)
  end
  self:AddTimer()
  self:RefreshTime()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.endTime - now
  leftTime = math.max(0, leftTime)
  local timeText = GameDialogDefine.EARTH_ORDER_NO_ARRIVED_TIP
  if self.type == NextBusinessComeType.GROCERY_STORE then
    timeText = GameDialogDefine.GROCERY_STORE_REACH_MAX_TIP
  elseif self.type == NextBusinessComeType.RESIDENT_ORDER then
    timeText = GameDialogDefine.RESIDENT_ORDER_REACH_MAX_TIP
  end
  if self.txt_des:GetActive() then
    self.txt_des:SetLocalText(timeText, UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  else
    self.txt_des1:SetLocalText(timeText, UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  end
end

UIReachLimitView.OnCreate = OnCreate
UIReachLimitView.OnDestroy = OnDestroy
UIReachLimitView.OnEnable = OnEnable
UIReachLimitView.OnDisable = OnDisable
UIReachLimitView.OnAddListener = OnAddListener
UIReachLimitView.OnRemoveListener = OnRemoveListener
UIReachLimitView.ComponentDefine = ComponentDefine
UIReachLimitView.ComponentDestroy = ComponentDestroy
UIReachLimitView.DataDefine = DataDefine
UIReachLimitView.DataDestroy = DataDestroy
UIReachLimitView.ReInit = ReInit
UIReachLimitView.DeleteTimer = DeleteTimer
UIReachLimitView.AddTimer = AddTimer
UIReachLimitView.RefreshTime = RefreshTime
return UIReachLimitView
