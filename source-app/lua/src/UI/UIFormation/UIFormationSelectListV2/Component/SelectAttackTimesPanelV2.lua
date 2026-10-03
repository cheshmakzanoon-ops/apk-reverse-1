local SelectAttackTimesPanelV2 = BaseClass("SelectAttackTimesPanelV2", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local desTxt_path = "bg/headBg/desTxt"
local confirmBtn_path = "enterBtn"
local confirmBtnTxt_path = "enterBtn/enterText"
local toggle_path = "checkObj/item"

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

local function ComponentDefine(self)
  self.descTxtN = self:AddComponent(UIText, desTxt_path)
  self.descTxtN:SetText(Localization:GetString("302319"))
  self.confirmBtnN = self:AddComponent(UIButton, confirmBtn_path)
  self.confirmBtnN:SetOnClick(function()
    self:OnClickConfirmBtn()
  end)
  self.confirmBtnTxtN = self:AddComponent(UIText, confirmBtnTxt_path)
  self.confirmBtnTxtN:SetText(Localization:GetString("150122"))
  self.toggleItemsTb = {}
  for i = 1, 4 do
    local togglePath = toggle_path .. i
    local newTog = {}
    local tempTog = self:AddComponent(UIToggle, togglePath)
    tempTog:SetOnValueChanged(function(tf)
      if tf then
        self:SetSelectedIndex(i)
      end
    end)
    newTog.togN = tempTog
    newTog.TogTxtN = tempTog:AddComponent(UIText, "Text_num")
    table.insert(self.toggleItemsTb, newTog)
  end
end

local function ComponentDestroy(self)
  self.descTxtN = nil
  self.confirmBtnN = nil
  self.confirmBtnTxtN = nil
  self.toggleItemsTb = nil
end

local function DataDefine(self)
  self.curSelectIndex = 1
  self.OnConfirmCallBack = nil
end

local function DataDestroy(self)
  self.curSelectIndex = nil
  self.OnConfirmCallBack = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ShowPanel(self, defaultIndex, isMarch, confirmCallback)
  self:SetSelectedIndex(defaultIndex)
  self.OnConfirmCallBack = confirmCallback
  for i, v in ipairs(self.toggleItemsTb) do
    if i == self.curSelectIndex then
      v.togN:SetIsOn(true)
    else
      v.togN:SetIsOn(false)
    end
  end
  if isMarch then
    self.confirmBtnTxtN:SetText(Localization:GetString("150122"))
  else
    self.confirmBtnTxtN:SetText(Localization:GetString("100645"))
  end
  for i, v in ipairs(self.toggleItemsTb) do
    local kn = "k" .. i
    local times = LuaEntry.DataConfig:TryGetNum("destroy_times", kn) or 0
    if times <= 1000 then
      v.TogTxtN:SetText(Localization:GetString("302317", times))
    else
      v.TogTxtN:SetText(Localization:GetString("302318"))
    end
  end
end

local function SetSelectedIndex(self, tempIndex)
  self.curSelectIndex = tempIndex or 1
  local kn = "k" .. self.curSelectIndex
  local times = LuaEntry.DataConfig:TryGetNum("destroy_times", kn) or 0
  self.view.ctrl:SetAttackTimes(times)
  self.view:RefreshCost()
end

local function OnClickConfirmBtn(self)
  local costPoint = 0
  if self.view.ctrl.targetType ~= nil and 0 <= self.view.ctrl.targetType then
    costPoint = self.view.ctrl:GetCostStaminaByTargetType(self.view.ctrl.targetType)
  end
  if costPoint > LuaEntry.Player:GetCurStamina() then
    UIUtil.ShowTipsId(134004)
    return
  end
  if self.OnConfirmCallBack then
    self.OnConfirmCallBack(self.curSelectIndex)
  end
end

SelectAttackTimesPanelV2.OnCreate = OnCreate
SelectAttackTimesPanelV2.OnDestroy = OnDestroy
SelectAttackTimesPanelV2.ComponentDefine = ComponentDefine
SelectAttackTimesPanelV2.ComponentDestroy = ComponentDestroy
SelectAttackTimesPanelV2.DataDefine = DataDefine
SelectAttackTimesPanelV2.DataDestroy = DataDestroy
SelectAttackTimesPanelV2.OnAddListener = OnAddListener
SelectAttackTimesPanelV2.OnRemoveListener = OnRemoveListener
SelectAttackTimesPanelV2.ShowPanel = ShowPanel
SelectAttackTimesPanelV2.SetSelectedIndex = SetSelectedIndex
SelectAttackTimesPanelV2.OnClickConfirmBtn = OnClickConfirmBtn
return SelectAttackTimesPanelV2
