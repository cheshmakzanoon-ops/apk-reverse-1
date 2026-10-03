local UISetAttackTimesView = BaseClass("UISetAttackTimesView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SelectAttackTimesPanel = require("UI.UIFormation.UIFormationSelectListNew.Component.SelectAttackTimesPanel")
local closeBtn_path = "closeBtn"
local selectTimesPanel_path = "offset/SelectAttackTimesPanel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.selectTimesPanelN = self:AddComponent(SelectAttackTimesPanel, selectTimesPanel_path)
end

local function ComponentDestroy(self)
  self.closeBtnN = nil
  self.selectTimesPanelN = nil
end

local function DataDefine(self)
  self.marchUuid = nil
  self.pointInfo = nil
  self.curStamina = nil
end

local function DataDestroy(self)
  self.marchUuid = nil
  self.pointInfo = nil
  self.curStamina = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function InitView(self)
  self.marchUuid, self.pointInfo, self.curStamina = self:GetUserData()
  self.selectTimesPanelN:ShowPanel(1, true, function(timesIndex)
    self:OnConfirmCallback(timesIndex)
  end)
end

local function OnConfirmCallback(self, timesIndex)
  MarchUtil.OnAttackAllianceCity(self.marchUuid, self.pointInfo, self.curStamina, nil, timesIndex)
  self:OnClickCloseBtn()
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

UISetAttackTimesView.OnCreate = OnCreate
UISetAttackTimesView.OnDestroy = OnDestroy
UISetAttackTimesView.ComponentDefine = ComponentDefine
UISetAttackTimesView.ComponentDestroy = ComponentDestroy
UISetAttackTimesView.DataDefine = DataDefine
UISetAttackTimesView.DataDestroy = DataDestroy
UISetAttackTimesView.OnAddListener = OnAddListener
UISetAttackTimesView.OnRemoveListener = OnRemoveListener
UISetAttackTimesView.InitView = InitView
UISetAttackTimesView.OnConfirmCallback = OnConfirmCallback
UISetAttackTimesView.OnClickCloseBtn = OnClickCloseBtn
return UISetAttackTimesView
