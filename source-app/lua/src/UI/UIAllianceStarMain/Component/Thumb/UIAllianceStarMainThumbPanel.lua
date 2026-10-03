local UIAllianceStarMainThumbPanel = BaseClass("UIAllianceStarMainThumbPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIAllianceStarMainThumbFirstPanel = require("UI.UIAllianceStarMain.Component.Thumb.UIAllianceStarMainThumbFirstPanel")
local UIAllianceStarMainThumbNormalPanel = require("UI.UIAllianceStarMain.Component.Thumb.UIAllianceStarMainThumbNormalPanel")

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
  self.compFirstPanel = self:AddComponent(UIAllianceStarMainThumbFirstPanel, "FirstPanel")
  self.compSecondPanel = self:AddComponent(UIAllianceStarMainThumbNormalPanel, "SecondPanel")
  self.compThirdPanel = self:AddComponent(UIAllianceStarMainThumbNormalPanel, "ThirdPanel")
  self.textTitle = self:AddComponent(UIText, "TitleText")
end

local function ComponentDestroy(self)
  self.compFirstPanel = nil
  self.compSecondPanel = nil
  self.compThirdPanel = nil
  self.textTitle = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceStarRefreshThumb, self.OnAllianceStarRefreshThumb)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceStarRefreshThumb, self.OnAllianceStarRefreshThumb)
  base.OnRemoveListener(self)
end

local function Refresh(self, param)
  self.textTitle:SetText(param.tipText)
  self.ceremonyInfo = param.ceremonyInfo
  local firstInfo = self.ceremonyInfo.ceremonyInfoList[1]
  if firstInfo then
    self.compFirstPanel:SetActive(true)
    local score = firstInfo.score
    self.compFirstPanel:Refresh(self.ceremonyInfo, self.ceremonyInfo.roleInfoMap[firstInfo.uid], score)
    local thumbInfo = DataCenter.AllianceStarManager:GetThumbInfo(self.ceremonyInfo.configId, firstInfo.uid)
    self.compFirstPanel:RefreshThumbsPanel(thumbInfo, param.closeThumb)
  else
    self.compFirstPanel:SetActive(false)
  end
  local secondInfo = self.ceremonyInfo.ceremonyInfoList[2]
  if secondInfo then
    self.compSecondPanel:SetActive(true)
    local score = secondInfo.score
    self.compSecondPanel:Refresh(self.ceremonyInfo, self.ceremonyInfo.roleInfoMap[secondInfo.uid], score)
  else
    self.compSecondPanel:SetActive(false)
  end
  local thirdInfo = self.ceremonyInfo.ceremonyInfoList[3]
  if thirdInfo then
    self.compThirdPanel:SetActive(true)
    local score = thirdInfo.score
    self.compThirdPanel:Refresh(self.ceremonyInfo, self.ceremonyInfo.roleInfoMap[thirdInfo.uid], score)
  else
    self.compThirdPanel:SetActive(false)
  end
end

local function OnAllianceStarRefreshThumb(self, thumbInfo)
  if thumbInfo.configId == self.ceremonyInfo.configId then
    self.compFirstPanel:RefreshThumbsPanel(thumbInfo)
  end
end

UIAllianceStarMainThumbPanel.OnCreate = OnCreate
UIAllianceStarMainThumbPanel.OnDestroy = OnDestroy
UIAllianceStarMainThumbPanel.OnEnable = OnEnable
UIAllianceStarMainThumbPanel.OnDisable = OnDisable
UIAllianceStarMainThumbPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainThumbPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainThumbPanel.DataDefine = DataDefine
UIAllianceStarMainThumbPanel.DataDestroy = DataDestroy
UIAllianceStarMainThumbPanel.OnAddListener = OnAddListener
UIAllianceStarMainThumbPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainThumbPanel.Refresh = Refresh
UIAllianceStarMainThumbPanel.OnAllianceStarRefreshThumb = OnAllianceStarRefreshThumb
return UIAllianceStarMainThumbPanel
