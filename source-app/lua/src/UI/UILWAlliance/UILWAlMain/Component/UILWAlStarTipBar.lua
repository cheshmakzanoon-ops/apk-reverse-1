local UILWAlStarTipBar = BaseClass("UILWAlStarTipBar", UIAsyncContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:SetAnchoredPositionXY(0, 0)
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
  self.textTip = self:AddComponent(UIText, "TipText")
  self.textTime = self:AddComponent(UIText, "TimeText")
  self.btn = self:AddComponent(UIButton, "Btn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.textBtn = self:AddComponent(UIText, "Btn/BtnImg/BtnText")
end

local function ComponentDestroy(self)
  self.textTip = nil
  self.textTime = nil
  self.btn = nil
  self.textBtn = nil
end

local function DataDefine(self)
  self:UpdateData()
end

local function DataDestroy(self)
  self.diffTime = nil
  self.openCD = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AlStarChangePlanTimeStamp, self.UpdateData)
  self:AddUIListener(EventId.AllianceStarGainActivityInfoNewRefresh, self.UpdateData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AlStarChangePlanTimeStamp, self.UpdateData)
  self:RemoveUIListener(EventId.AllianceStarGainActivityInfoNewRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

local function OnBtnClick(self)
  if DataCenter.AllianceStarManager:IsShowAlStarTipBar() then
    SFSNetwork.SendMessage(MsgDefines.AllianceStarGainCeremonyInfoNew)
  else
    self:SetActive(false)
  end
end

local function UpdateData(self)
  if not GameObjectIsValid(self.gameObject) then
    return
  end
  self.textTip:SetLocalText("alliance_weeklyStar_title_01", DataCenter.AllianceStarManager:GetCeremonyEdition())
  self.textBtn:SetLocalText("alliance_weeklyStar_btn_enter")
  self.endTime = DataCenter.AllianceStarManager.endTime
  self:Update1000MS()
end

local function Update1000MS(self)
  if self.endTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local diff = self.endTime - now
    if 0 < diff then
      self.textTime:SetLocalText("activity_slots_tips004", UITimeManager:GetInstance():MilliSecondToFmtString(diff))
    else
      self.textTime:SetLocalText("activity_slots_tips004", UITimeManager:GetInstance():MilliSecondToFmtString(0))
    end
  else
    self.textTime:SetLocalText("activity_slots_tips004", UITimeManager:GetInstance():MilliSecondToFmtString(0))
  end
end

UILWAlStarTipBar.OnCreate = OnCreate
UILWAlStarTipBar.OnDestroy = OnDestroy
UILWAlStarTipBar.OnEnable = OnEnable
UILWAlStarTipBar.OnDisable = OnDisable
UILWAlStarTipBar.ComponentDefine = ComponentDefine
UILWAlStarTipBar.ComponentDestroy = ComponentDestroy
UILWAlStarTipBar.DataDefine = DataDefine
UILWAlStarTipBar.DataDestroy = DataDestroy
UILWAlStarTipBar.OnAddListener = OnAddListener
UILWAlStarTipBar.OnRemoveListener = OnRemoveListener
UILWAlStarTipBar.OnBtnClick = OnBtnClick
UILWAlStarTipBar.UpdateData = UpdateData
UILWAlStarTipBar.Update1000MS = Update1000MS
return UILWAlStarTipBar
