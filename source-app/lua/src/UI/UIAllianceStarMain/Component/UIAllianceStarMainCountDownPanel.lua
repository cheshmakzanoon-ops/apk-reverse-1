local UIAllianceStarMainCountDownPanel = BaseClass("UIAllianceStarMainCountDownPanel", UIBaseContainer)
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
  self.textTitle = self:AddComponent(UIText, "TitleText")
  self.textCountDown = self:AddComponent(UIText, "CountDownText")
  self.textLastCountDown = self:AddComponent(UIText, "LastCountDownText")
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textCountDown = nil
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

local function Refresh(self, param)
  self.textTitle:SetText(param.titleText)
  self.endTimeStamp = UITimeManager:GetInstance():GetServerTime() + param.cdTimeStamp or 0
  if param.textStyle and param.textStyle == 2 then
    self.textLastCountDown:SetActive(true)
    self.textCountDown:SetActive(false)
  else
    self.textLastCountDown:SetActive(false)
    self.textCountDown:SetActive(true)
  end
  self:Update()
end

local function Update(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  local diff = self.endTimeStamp - now
  if 0 < diff then
    local lastNum = math.floor(diff / 1000)
    if self.textCountDown:GetActive() then
      self.textCountDown:SetText(UITimeManager:GetInstance():SecondToFmtString(lastNum))
    end
    if self.textLastCountDown:GetActive() then
      if self.textLastCountDown:GetText() ~= tostring(lastNum) then
        self.textLastCountDown:SetActive(false)
        self.textLastCountDown:SetActive(true)
      end
      self.textLastCountDown:SetText(lastNum)
    end
  else
    if self.textCountDown:GetActive() then
      self.textCountDown:SetText(UITimeManager:GetInstance():SecondToFmtString(0))
    end
    if self.textLastCountDown:GetActive() then
      self.textLastCountDown:SetText(0)
    end
  end
end

UIAllianceStarMainCountDownPanel.OnCreate = OnCreate
UIAllianceStarMainCountDownPanel.OnDestroy = OnDestroy
UIAllianceStarMainCountDownPanel.OnEnable = OnEnable
UIAllianceStarMainCountDownPanel.OnDisable = OnDisable
UIAllianceStarMainCountDownPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainCountDownPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainCountDownPanel.DataDefine = DataDefine
UIAllianceStarMainCountDownPanel.DataDestroy = DataDestroy
UIAllianceStarMainCountDownPanel.OnAddListener = OnAddListener
UIAllianceStarMainCountDownPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainCountDownPanel.Refresh = Refresh
UIAllianceStarMainCountDownPanel.Update = Update
return UIAllianceStarMainCountDownPanel
