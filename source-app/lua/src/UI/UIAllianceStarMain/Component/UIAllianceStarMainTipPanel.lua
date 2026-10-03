local UIAllianceStarMainTipPanel = BaseClass("UIAllianceStarMainTipPanel", UIBaseContainer)
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
  self.textTip = self:AddComponent(UIText, "TipText")
end

local function ComponentDestroy(self)
  self.textTip = nil
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
  if string.IsNullOrEmpty(param.tipText) then
    self.textTip:SetActive(false)
  else
    self.textTip:SetActive(true)
    self.textTip:SetText(param.tipText)
  end
end

UIAllianceStarMainTipPanel.OnCreate = OnCreate
UIAllianceStarMainTipPanel.OnDestroy = OnDestroy
UIAllianceStarMainTipPanel.OnEnable = OnEnable
UIAllianceStarMainTipPanel.OnDisable = OnDisable
UIAllianceStarMainTipPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainTipPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainTipPanel.DataDefine = DataDefine
UIAllianceStarMainTipPanel.DataDestroy = DataDestroy
UIAllianceStarMainTipPanel.OnAddListener = OnAddListener
UIAllianceStarMainTipPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainTipPanel.Refresh = Refresh
return UIAllianceStarMainTipPanel
