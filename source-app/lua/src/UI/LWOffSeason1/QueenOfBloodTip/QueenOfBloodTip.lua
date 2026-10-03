local QueenOfBloodTip = BaseClass("QueenOfBloodTip", UIBaseContainer)
local base = UIBaseContainer
local frenzyCD = 30000

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.textTitle = self:AddComponent(UIText, "Title")
  self.textTime = self:AddComponent(UIText, "Time")
  self.btnBg = self:AddComponent(UIButton, "Bg")
  self.btnBg:SetOnClick(function()
    GoToUtil.GoToWindow(JumpWindowType.Activity, EnumActivity.OffSeason1QueenOfBlood.Type, true)
  end)
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textTime = nil
  self.btnBg = nil
end

local function DataDefine(self)
  local cfg = LuaEntry.DataConfig:TryGetNum("s1_offSeason_rerecapture", "k9", 30)
  frenzyCD = cfg * 1000
end

local function DataDestroy(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function Refresh(self)
  local info = DataCenter.OffSeason1QueenOfBloodManager:GetRoundInfo()
  if info and info.nextRound then
    self:SetActive(true)
    self.info = info
    self:Update1000MS()
  else
    self:SetActive(false)
  end
end

local function Update1000MS(self)
  local endTime = self.info.nextRoundTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.info.nextRound == self.info.maxRound and endTime <= curTime then
    local diffTime = frenzyCD - (curTime - endTime)
    if 0 < diffTime then
      self.textTitle:SetLocalText("s1_QueenChallenge_state_rampage0")
      self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diffTime))
    else
      self.textTitle:SetLocalText("s1_QueenChallenge_state_rampage1")
      self.textTime:SetLocalText("s1_QueenChallenge_state_rampage_tips")
    end
  else
    self.textTitle:SetLocalText("s1_QueenChallenge_state_attack", self.info.nextRound, self.info.maxRound)
    local diffTime = endTime - curTime
    if 0 <= diffTime then
      self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diffTime))
    end
  end
end

QueenOfBloodTip.OnCreate = OnCreate
QueenOfBloodTip.OnDestroy = OnDestroy
QueenOfBloodTip.OnEnable = OnEnable
QueenOfBloodTip.OnDisable = OnDisable
QueenOfBloodTip.ComponentDefine = ComponentDefine
QueenOfBloodTip.ComponentDestroy = ComponentDestroy
QueenOfBloodTip.DataDefine = DataDefine
QueenOfBloodTip.DataDestroy = DataDestroy
QueenOfBloodTip.OnAddListener = OnAddListener
QueenOfBloodTip.OnRemoveListener = OnRemoveListener
QueenOfBloodTip.Refresh = Refresh
QueenOfBloodTip.Update1000MS = Update1000MS
return QueenOfBloodTip
