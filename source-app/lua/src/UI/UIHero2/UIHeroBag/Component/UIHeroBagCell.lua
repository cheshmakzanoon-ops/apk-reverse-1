local UIHeroBagCell = BaseClass("UIHeroBagCell", UIBaseContainer)
local base = UIBaseContainer
local DetectEventRewardCell = require("UI.UIRadarCenter.UIDetectEvent.Component.DetectEventRewardCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
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
  self.itemCell = self:AddComponent(DetectEventRewardCell, "ItemCell")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
end

local function SetData(self, param, clickFun)
  self.param = param
  local cellParam = DetectEventRewardCell.Param.New()
  cellParam.rewardType = RewardType.GOODS
  cellParam.itemId = self.param.itemId
  cellParam.count = self.param.count
  self.itemCell:ReInit(cellParam)
  self.clickFun = clickFun
end

local function OnBtnClick(self)
  if self.clickFun ~= nil then
    self.clickFun(self.param)
  end
end

UIHeroBagCell.OnCreate = OnCreate
UIHeroBagCell.OnDestroy = OnDestroy
UIHeroBagCell.OnEnable = OnEnable
UIHeroBagCell.OnDisable = OnDisable
UIHeroBagCell.ComponentDefine = ComponentDefine
UIHeroBagCell.ComponentDestroy = ComponentDestroy
UIHeroBagCell.SetData = SetData
UIHeroBagCell.OnBtnClick = OnBtnClick
return UIHeroBagCell
