local base = UIBaseView
local LWUIAllianceCompeteProtectTipView = BaseClass("LWUIAllianceCompeteProtectTipView", base)
local blackBtn_path = "ImgBg"
local clostBtn_path = "Root/content/closeBtn"
local hourText_path = "Root/content/time/hourText"
local minText_path = "Root/content/time/minText"
local secText_path = "Root/content/time/secText"
local accessBtn1_path = "Root/content/access/item1/access1"
local accessBtn2_path = "Root/content/access/item2/access2"
local totayFlag_path = "Root/content/backToggle"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ShowAlCompeteNoticeTime()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.blackBtn = self:AddComponent(UIButton, blackBtn_path)
  self.clostBtn = self:AddComponent(UIButton, clostBtn_path)
  self.hourText = self:AddComponent(UIText, hourText_path)
  self.minText = self:AddComponent(UIText, minText_path)
  self.secText = self:AddComponent(UIText, secText_path)
  self.accessBtn1 = self:AddComponent(UIButton, accessBtn1_path)
  self.accessBtn2 = self:AddComponent(UIButton, accessBtn2_path)
  self.back_toggle = self:AddComponent(UIToggle, totayFlag_path)
  self.back_toggle:SetIsOn(false)
  self.blackBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.clostBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.accessBtn1:SetOnClick(function()
    self.ctrl:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCityShield, {anim = true})
  end)
  self.accessBtn2:SetOnClick(function()
    local selfRallyInfo = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint()
    if selfRallyInfo then
      self.ctrl:CloseSelf()
      local index = selfRallyInfo:GetPointIndex()
      local position = SceneUtils.TileIndexToWorld(index, ForceChangeScene.World)
      SceneUtils.ChangeToWorld(function()
        GoToUtil.GotoWorldPos(position, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        end, selfRallyInfo.server)
      end)
    end
  end)
  self.hourText:SetText(0)
  self.minText:SetText(0)
  self.secText:SetText(0)
  local countStr = CommonUtil.PlayerPrefsGetString("PROTECT_COVER_TIP_DAILY_COUNT", "")
  local day = 0
  local count = 0
  local today = UITimeManager:GetInstance():GetDayOfYear(UITimeManager:GetInstance():GetServerTime())
  if not string.IsNullOrEmpty(countStr) then
    local day_count = string.split(countStr, "_")
    day = tonumber(day_count[1])
    count = tonumber(day_count[2])
    if day == today then
      CommonUtil.PlayerPrefsSetString("PROTECT_COVER_TIP_DAILY_COUNT", tostring(day) .. "_" .. tostring(count + 1))
    else
      day = today
      count = 0
      CommonUtil.PlayerPrefsSetString("PROTECT_COVER_TIP_DAILY_COUNT", tostring(day) .. "_" .. tostring(count + 1))
    end
  else
    CommonUtil.PlayerPrefsSetString("PROTECT_COVER_TIP_DAILY_COUNT", tostring(today) .. "_" .. tostring(count + 1))
  end
end

local function ComponentDestroy(self)
  if self.back_toggle:GetIsOn() then
    local now = UITimeManager:GetInstance():GetServerTime()
    local time = math.modf(now / 1000)
    local format = os.date("!*t", time)
    CommonUtil.PlayerPrefsSetLong("PROTECT_COVER_TIP_MONTH_FLAG", format.month)
  end
  self.blackBtn = nil
  self.clostBtn = nil
  self.hourText = nil
  self.minText = nil
  self.secText = nil
  self.accessBtn1 = nil
  self.accessBtn2 = nil
  self.totayFlag = nil
end

local function DataDefine(self)
  self.allyDuelNextTime = nil
  
  function self.timer_call_back()
    self:RefreshPerSecond()
  end
  
  self.timer = nil
end

local function DataDestroy(self)
  self.timer_call_back = nil
  self.allyDuelNextTime = nil
  self:RemoveTimer()
end

local function ShowAlCompeteNoticeTime(self)
  self.allyDuelNextTime = nil
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if not actInfo then
    return
  end
  local eventInfo = actInfo:GetEventInfo()
  local finish
  local now = UITimeManager:GetInstance():GetServerTime()
  if eventInfo then
    local _, startT, endT = eventInfo:CheckIfShowCrossServer()
    if now < startT then
      finish = startT
    end
  end
  if finish then
    self.allyDuelNextTime = finish
    self:AddTimer()
    self:RefreshPerSecond()
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_call_back, self, false, false, false)
  end
  self.timer:Start()
end

local function RemoveTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function RefreshPerSecond(self)
  local needTimer = self:RefreshAlCompeteNoticeRemainT()
  if not needTimer then
    self:RemoveTimer()
  end
end

local function RefreshAlCompeteNoticeRemainT(self)
  if not self.allyDuelNextTime then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.allyDuelNextTime - curTime
  if 0 < remainTime then
    local secs, delta = math.modf(remainTime / 1000)
    if 0 < delta then
      secs = secs + 1
    end
    local hour = math.modf(secs / 3600)
    local minute = math.modf(secs / 60) % 60
    local second = math.floor(secs % 60)
    self.hourText:SetText(hour < 10 and "0" .. hour or hour)
    self.minText:SetText(minute < 10 and "0" .. minute or minute)
    self.secText:SetText(second < 10 and "0" .. second or second)
    return true
  else
    self.hourText:SetText("00")
    self.minText:SetText("00")
    self.secText:SetText("00")
    self.allyDuelNextTime = nil
    return false
  end
end

LWUIAllianceCompeteProtectTipView.OnCreate = OnCreate
LWUIAllianceCompeteProtectTipView.OnDestroy = OnDestroy
LWUIAllianceCompeteProtectTipView.OnEnable = OnEnable
LWUIAllianceCompeteProtectTipView.OnDisable = OnDisable
LWUIAllianceCompeteProtectTipView.ComponentDefine = ComponentDefine
LWUIAllianceCompeteProtectTipView.ComponentDestroy = ComponentDestroy
LWUIAllianceCompeteProtectTipView.DataDefine = DataDefine
LWUIAllianceCompeteProtectTipView.DataDestroy = DataDestroy
LWUIAllianceCompeteProtectTipView.ShowAlCompeteNoticeTime = ShowAlCompeteNoticeTime
LWUIAllianceCompeteProtectTipView.AddTimer = AddTimer
LWUIAllianceCompeteProtectTipView.RemoveTimer = RemoveTimer
LWUIAllianceCompeteProtectTipView.RefreshPerSecond = RefreshPerSecond
LWUIAllianceCompeteProtectTipView.RefreshAlCompeteNoticeRemainT = RefreshAlCompeteNoticeRemainT
return LWUIAllianceCompeteProtectTipView
