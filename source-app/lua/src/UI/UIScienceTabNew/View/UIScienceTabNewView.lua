local UIScienceTabNewView = BaseClass("UIScienceTabNewView", UIBaseView)
local base = UIBaseView
local ScienceTabNewPanel = require("UI.UIScienceTabNew.Component.ScienceTabNewPanel.ScienceTabNewPanel")
local ScienceTabOldPanel = require("UI.UIScienceTabNew.Component.ScienceTabOldPanel.ScienceTabOldPanel")
local SubPanelType = {Old = 1, New = 2}
local subPanelConf = {
  [SubPanelType.Old] = {
    Script = ScienceTabOldPanel,
    Asset = "Assets/Main/Prefabs/UI/UIScience/scienceTabOldPanel.prefab"
  },
  [SubPanelType.New] = {
    Script = ScienceTabNewPanel,
    Asset = "Assets/Main/Prefabs/UI/UIScience/scienceTabNewPanel.prefab"
  }
}
local panelContainer_path = "panelContainer"
local closeBtn_path = "safeArea/CloseBtn"
local title_path = "safeArea/TitleText"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  EventManager:GetInstance():Broadcast(EventId.SetMainEnergyVisible, false)
  self:InitUI()
end

local function OnDestroy(self)
  EventManager:GetInstance():Broadcast(EventId.SetMainEnergyVisible, true)
  self:HideElectric()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(GameDialogDefine.SCIENCE)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.panelContainerN = self:AddComponent(UIBaseContainer, panelContainer_path)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.panelContainerN = nil
end

local function DataDefine(self)
  self.curPanelType = nil
  self.curPanel = nil
  self.model = nil
end

local function DataDestroy(self)
  self.curPanelType = nil
  self.curPanel = nil
  self.model = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function InitUI(self)
  local useNewUI = self.ctrl:CheckIfShowNewUI()
  local tempType
  if useNewUI then
    tempType = SubPanelType.New
  else
    tempType = SubPanelType.Old
  end
  if self.curPanelType and self.curPanelType ~= tempType then
    self:ClearPanel()
  end
  self.curPanelType = tempType
  self:ShowPanel()
  self:ShowElectric()
end

local function ShowPanel(self)
  local tab, bUuid = self:GetUserData()
  self.bUuid = bUuid
  if self.curPanel then
    self.curPanel:InitUI(tab, bUuid)
  else
    local tempConf = subPanelConf[self.curPanelType]
    self.model = self:GameObjectInstantiateAsync(tempConf.Asset, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.panelContainerN.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local v3 = go.transform.position
      v3.x = 0
      v3.y = 0
      go.transform.position = v3
      local cell = self.panelContainerN:AddComponent(tempConf.Script, go)
      self.curPanel = cell
      self.curPanel:SetActive(true)
      self.curPanel:InitUI(tab, bUuid)
    end)
  end
end

local function ShowElectric(self)
  local param = {}
  param.list = {
    ResourceType.Electricity
  }
  param.uiName = UIWindowNames.UIScienceTab
  EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
end

local function HideElectric(self)
  EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIScienceTab)
end

local function ClearPanel(self)
  self.panelContainerN:RemoveComponents(subPanelConf[self.curPanelType].Script)
  if self.model ~= nil then
    self:GameObjectDestroy(self.model)
  end
  self.curPanel = nil
  self.model = nil
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

UIScienceTabNewView.OnCreate = OnCreate
UIScienceTabNewView.OnDestroy = OnDestroy
UIScienceTabNewView.OnEnable = OnEnable
UIScienceTabNewView.OnDisable = OnDisable
UIScienceTabNewView.ComponentDefine = ComponentDefine
UIScienceTabNewView.ComponentDestroy = ComponentDestroy
UIScienceTabNewView.DataDefine = DataDefine
UIScienceTabNewView.DataDestroy = DataDestroy
UIScienceTabNewView.OnAddListener = OnAddListener
UIScienceTabNewView.OnRemoveListener = OnRemoveListener
UIScienceTabNewView.InitUI = InitUI
UIScienceTabNewView.ShowPanel = ShowPanel
UIScienceTabNewView.ShowElectric = ShowElectric
UIScienceTabNewView.HideElectric = HideElectric
UIScienceTabNewView.ClearPanel = ClearPanel
UIScienceTabNewView.OnClickCloseBtn = OnClickCloseBtn
return UIScienceTabNewView
