local ParkourBonusTimeConditionPanel = BaseClass("ParkourBonusTimeConditionPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.slider = self:AddComponent(UISlider, "Slider")
  self.imgWinIcon = self:AddComponent(UIImage, "WinIcon")
  self.textWinBar = self:AddComponent(UITextMeshProUGUIEx, "WinBarText")
end

local function ComponentDestroy(self)
  self.slider = nil
  self.imgWinIcon = nil
  self.textWinBar = nil
  if IsNotNull(self.winConditionTextTweener) then
    self.winConditionTextTweener:Kill()
  end
  self.winConditionTextTweener = nil
end

local function DataDefine(self)
  self.punchOK = 0
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, useTime, winCondition)
  self.beginUseTime = useTime
  self.fullUseTime = winCondition.needTime or 1
  self:Refresh(0)
end

local function Refresh(self, useTime)
  local nowUseTime = useTime or 0
  local curValue = math.max(nowUseTime - self.beginUseTime, 0)
  local needValue = self.fullUseTime
  self.slider:SetValue(Mathf.Clamp((needValue - curValue) / needValue, 0, 1))
  self.textWinBar:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutHour(needValue - curValue))
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > self.punchOK then
    self.punchOK = now + PUNCH_CD * 1000
    self.textWinBar.transform:DOKill()
    self.textWinBar.transform:Set_localScale(1, 1, 1)
    self.winConditionTextTweener = self.textWinBar.transform:DOPunchScale(Vector3.New(1, 1, 1), PUNCH_CD, 1, 0.4)
  end
end

ParkourBonusTimeConditionPanel.OnCreate = OnCreate
ParkourBonusTimeConditionPanel.OnDestroy = OnDestroy
ParkourBonusTimeConditionPanel.OnEnable = OnEnable
ParkourBonusTimeConditionPanel.OnDisable = OnDisable
ParkourBonusTimeConditionPanel.ComponentDefine = ComponentDefine
ParkourBonusTimeConditionPanel.ComponentDestroy = ComponentDestroy
ParkourBonusTimeConditionPanel.DataDefine = DataDefine
ParkourBonusTimeConditionPanel.DataDestroy = DataDestroy
ParkourBonusTimeConditionPanel.OnAddListener = OnAddListener
ParkourBonusTimeConditionPanel.OnRemoveListener = OnRemoveListener
ParkourBonusTimeConditionPanel.SetData = SetData
ParkourBonusTimeConditionPanel.Refresh = Refresh
return ParkourBonusTimeConditionPanel
