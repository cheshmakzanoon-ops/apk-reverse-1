local TabCell = BaseClass("TabCell", UIBaseContainer)
local base = UIBaseContainer
local icon_path = "Icon"
local redDot_path = "redDot"
local this_path = ""

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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.redDot = self:AddComponent(UIBaseContainer, redDot_path)
  self.tab_icon = self:AddComponent(UIImage, this_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_SelectTab, false)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.btn = nil
  self.tab_icon = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self:SetSelect(param.isSelect)
  self.redDot:SetActive(false)
  if self.param.tabType == UICapacityTableTab.Item and self.view.ctrl:GetTabRedState(UICapacityTableTab.Item) > 0 then
    self:RedRefresh(true)
  end
end

local function RedRefresh(self, state)
  self.redDot:SetActive(state)
end

local function OnBtnClick(self)
  if self.param.callBack ~= nil then
    self.param.callBack(self.param.tabType)
  end
end

local function SetSelect(self, value)
  if value then
    self.tab_icon:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_tab_up"))
    self.icon:LoadSprite(CapacityTabSelectImage[self.param.tabType])
  else
    self.tab_icon:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_tab_down"))
    self.icon:LoadSprite(CapacityTabUnSelectImage[self.param.tabType])
  end
end

TabCell.OnCreate = OnCreate
TabCell.OnDestroy = OnDestroy
TabCell.OnEnable = OnEnable
TabCell.OnDisable = OnDisable
TabCell.ComponentDefine = ComponentDefine
TabCell.ComponentDestroy = ComponentDestroy
TabCell.DataDefine = DataDefine
TabCell.DataDestroy = DataDestroy
TabCell.ReInit = ReInit
TabCell.OnBtnClick = OnBtnClick
TabCell.SetSelect = SetSelect
TabCell.RedRefresh = RedRefresh
return TabCell
