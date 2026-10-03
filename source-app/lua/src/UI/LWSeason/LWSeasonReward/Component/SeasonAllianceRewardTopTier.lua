local base = UIBaseContainer
local SeasonAllianceRewardTopTier = BaseClass("SeasonAllianceRewardTopTier", base)
local icon_path = "normal1"
local selected_path = "selected1"
local redPoint_path = "RedPoint1"
local clickBtn_path = ""
local completedFlag_path = "completedIcon"
local selected2_path = "selected2"
local selectedEffect_path = "Eff_lizi_jiangbei"

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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.selected = self:AddComponent(UIBaseContainer, selected_path)
  self.redPoint = self:AddComponent(UIBaseContainer, redPoint_path)
  self.clickBtn = self:AddComponent(UIButton, clickBtn_path)
  self.completedFlag = self:AddComponent(UIBaseContainer, completedFlag_path)
  self.selected2 = self:AddComponent(UIBaseContainer, selected2_path)
  self.selectedEffect = self:AddComponent(UIBaseContainer, selectedEffect_path)
  self.selected:SetActive(false)
  self.selected2:SetActive(false)
  self.redPoint:SetActive(false)
  self.selectedEffect:SetActive(false)
  self.clickBtn:SetOnClick(function()
    if self.clickCall then
      self.clickCall(self.index)
    end
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.selected = nil
  self.redPoint = nil
  self.clickBtn = nil
  self.completedFlag = nil
  self.selected2 = nil
  self.selectedEffect = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.clickCall = nil
  self.index = nil
end

function SeasonAllianceRewardTopTier:Init(index, clickCall)
  self.index = index
  self.clickCall = clickCall
end

function SeasonAllianceRewardTopTier:RefreshTierBg(index)
  self.completedFlag:SetActive(self.index == index)
end

function SeasonAllianceRewardTopTier:SelectTitle(index)
  self.selected:SetActive(index == self.index)
  self.selected2:SetActive(index == self.index)
  self.selectedEffect:SetActive(index == self.index)
end

function SeasonAllianceRewardTopTier:RefreshBtnRed(index, flag)
  self.redPoint:SetActive(flag and self.index == index)
end

SeasonAllianceRewardTopTier.OnCreate = OnCreate
SeasonAllianceRewardTopTier.OnDestroy = OnDestroy
SeasonAllianceRewardTopTier.OnEnable = OnEnable
SeasonAllianceRewardTopTier.OnDisable = OnDisable
SeasonAllianceRewardTopTier.ComponentDefine = ComponentDefine
SeasonAllianceRewardTopTier.ComponentDestroy = ComponentDestroy
SeasonAllianceRewardTopTier.DataDefine = DataDefine
SeasonAllianceRewardTopTier.DataDestroy = DataDestroy
return SeasonAllianceRewardTopTier
