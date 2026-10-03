local base = UIBaseView
local BankHelp = BaseClass("BankHelp", base)
local Localization = CS.GameEntry.Localization
local BankHelpLevelItem = require("UI.LWSeason5.LWBank.Component.BankHelpLevelItem")
local BankInterestItem = require("UI.LWSeason5.LWBank.Component.BankInterestItem")
local panelBtn_path = "panel"
local closeBtn_path = "PopUpContent/CloseBtn"
local content2_path = "PopUpContent/ScrollView2/Viewport/Content2"
local content1_path = "PopUpContent/ScrollView1/Viewport/Content1"
local toggle2_path = "PopUpContent/TabRoot/TabItem2"
local toggle1_path = "PopUpContent/TabRoot/TabItem1"
local icon2_path = "PopUpContent/ScrollView2/Viewport/Content2/Title/icon2"
local icon3_path = "PopUpContent/ScrollView2/Viewport/Content2/Title/icon3"
local icon4_path = "PopUpContent/ScrollView2/Viewport/Content2/Title/icon4"
local icon5_path = "PopUpContent/ScrollView2/Viewport/Content2/Title/icon5"
local icon2_2_path = "PopUpContent/ScrollView1/Viewport/Content1/Title/icon2_2"
local icon2_3_path = "PopUpContent/ScrollView1/Viewport/Content1/Title/icon3_2"
local icon2_4_path = "PopUpContent/ScrollView1/Viewport/Content1/Title/icon4_2"
local iconTips = {
  [1] = nil,
  [2] = "s5_bank_ui10",
  [3] = "s5_bank_ui11",
  [4] = "s5_bank_ui12",
  [5] = "s5_bank_ui13"
}
local iconTips2 = {
  [1] = nil,
  [2] = "s5_bank_ui18",
  [3] = "s5_bank_ui19",
  [4] = "s5_bank_ui20"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.data = self:GetUserData()
  self:RefreshView()
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
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.content2 = self:AddComponent(UIBaseContainer, content2_path)
  self.content1 = self:AddComponent(UIBaseContainer, content1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.icon2 = self:AddComponent(UIButton, icon2_path)
  self.icon3 = self:AddComponent(UIButton, icon3_path)
  self.icon4 = self:AddComponent(UIButton, icon4_path)
  self.icon5 = self:AddComponent(UIButton, icon5_path)
  self.icon2_2 = self:AddComponent(UIButton, icon2_2_path)
  self.icon2_3 = self:AddComponent(UIButton, icon2_3_path)
  self.icon2_4 = self:AddComponent(UIButton, icon2_4_path)
  self.panelBtn:SetOnClick((BindCallback(self.ctrl, self.ctrl.CloseSelf)))
  self.closeBtn:SetOnClick((BindCallback(self.ctrl, self.ctrl.CloseSelf)))
  for i = 1, 5 do
    local icon = self["icon" .. i]
    if icon and iconTips[i] then
      icon:SetOnClick(function()
        UIUtil.ShowBubbleTips(Localization:GetString(iconTips[i]), icon.transform.position, 0, -30, 0)
      end)
    end
    local icon2 = self["icon2_" .. i]
    if icon2 and iconTips2[i] then
      icon2:SetOnClick(function()
        UIUtil.ShowBubbleTips(Localization:GetString(iconTips2[i]), icon2.transform.position, 0, -30, 0)
      end)
    end
  end
  self.toggle1:SetOnValueChanged(function(isOn)
    if isOn then
      self:RefreshInterestList()
    end
  end)
  self.toggle2:SetOnValueChanged(function(isOn)
    if isOn then
      self:RefreshLevelList()
    end
  end)
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.closeBtn = nil
  self.content2 = nil
  self.content1 = nil
  self.toggle2 = nil
  self.toggle1 = nil
  self.icon2 = nil
  self.icon3 = nil
  self.icon4 = nil
  self.icon5 = nil
  self.icon2_2 = nil
  self.icon2_3 = nil
  self.icon2_4 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function BankHelp:RefreshView()
  self.list = DataCenter.SeasonBankTemplateManager:GetStrongholdListByLevel(self.data.serverId)
  self.level = self.data.meta.level
  self.toggle1:SetIsOn(true)
  self:RefreshInterestList()
end

function BankHelp:RefreshLevelList()
  if self.levelItems then
    return
  end
  self.levelItems = {}
  local index, trans = 0, self.content2.transform
  local itemPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/Component/BankHelpLevelItem.prefab"
  for k, v in ipairs(self.list) do
    self.levelItems[k] = self:GameObjectInstantiateAsync(itemPath, function(req)
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      obj.transform:SetParent(trans)
      index = index + 1
      local name = string.format("BankHelpLevelItem%s", index)
      obj.name = name
      local item = self.content2:AddComponent(BankHelpLevelItem, name)
      item:SetLocalScaleXYZ(1, 1, 1)
      item:ReInit(v, index, self.level)
    end)
  end
end

function BankHelp:RefreshInterestList()
  if self.interestItems then
    return
  end
  self.interestItems = {}
  local index, trans = 0, self.content1.transform
  local itemPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/Component/BankInterestItem.prefab"
  for k, v in ipairs(self.list) do
    self.interestItems[k] = self:GameObjectInstantiateAsync(itemPath, function(req)
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      obj.transform:SetParent(trans)
      index = index + 1
      local name = string.format("BankInterestItem%s", index)
      obj.name = name
      local item = self.content1:AddComponent(BankInterestItem, name)
      item:SetLocalScaleXYZ(1, 1, 1)
      item:ReInit(v, index, self.level)
    end)
  end
end

BankHelp.OnCreate = OnCreate
BankHelp.OnDestroy = OnDestroy
BankHelp.OnEnable = OnEnable
BankHelp.OnDisable = OnDisable
BankHelp.ComponentDefine = ComponentDefine
BankHelp.ComponentDestroy = ComponentDestroy
BankHelp.DataDefine = DataDefine
BankHelp.DataDestroy = DataDestroy
return BankHelp
