local base = UIBaseContainer
local UIOfficialApplyPlayerPanel = BaseClass("UIOfficialApplyPlayerPanel", base)
local UITimeManager = _ENV.UITimeManager
local nameText_path = "NameText"
local timeTipText_path = "TimeTextPanel/TimeTipText"
local timeText_path = "TimeTextPanel/TimeText"
local playerHead_Path = "PlayerHead/UIPlayerHead"
local conqueror_cd_text_path = "ConquerorCdText"

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
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.timeTipText = self:AddComponent(UIText, timeTipText_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
  self.playerHead = self:AddComponent(UICommonHead, playerHead_Path)
  self.playerHead:SetEnableClickShowInfo(true, true)
  self.conqueror_cd_text = self:AddComponent(UITextMeshProUGUIEx, conqueror_cd_text_path)
  self.conqueror_cd_text:SetText("")
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.timeTipText = nil
  self.timeText = nil
  self.playerHead = nil
  self.conqueror_cd_text = nil
end

local function DataDefine(self)
  self.endTime = nil
end

local function DataDestroy(self)
  self.appointTime = nil
  self.endTime = nil
end

local function SetData(self, positionInfo)
  self.nameText:SetText(positionInfo:GetFullName(false, positionInfo.uid))
  self.conqueror_cd_text:SetText("")
  self.playerHead:SetHead(positionInfo.uid, positionInfo.pic, positionInfo.picVer, nil, positionInfo:GetHeadBgImg())
  self.appointTime = positionInfo.appointTime
  self.endTime = nil
  if DataCenter.GovernmentTemplateManager:IsConqueror(positionInfo.positionId) and positionInfo and positionInfo.endTime > 0 then
    self.endTime = positionInfo.endTime
  end
  self:Update1000MS()
end

local function Update1000MS(self)
  if self.appointTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local appointDeltaTime = curTime - self.appointTime
    self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(appointDeltaTime))
  end
  if self.endTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - now
    if 0 < remainTime then
      self.conqueror_cd_text:SetLocalText("zone_war_government_18", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.endTime = nil
      self.conqueror_cd_text:SetText("")
    end
  end
end

UIOfficialApplyPlayerPanel.OnCreate = OnCreate
UIOfficialApplyPlayerPanel.OnDestroy = OnDestroy
UIOfficialApplyPlayerPanel.OnEnable = OnEnable
UIOfficialApplyPlayerPanel.OnDisable = OnDisable
UIOfficialApplyPlayerPanel.ComponentDefine = ComponentDefine
UIOfficialApplyPlayerPanel.ComponentDestroy = ComponentDestroy
UIOfficialApplyPlayerPanel.DataDefine = DataDefine
UIOfficialApplyPlayerPanel.DataDestroy = DataDestroy
UIOfficialApplyPlayerPanel.SetData = SetData
UIOfficialApplyPlayerPanel.Update1000MS = Update1000MS
return UIOfficialApplyPlayerPanel
