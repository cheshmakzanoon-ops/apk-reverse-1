local base = UIBaseContainer
local UIGhostreconRewardBoxBtn = BaseClass("UIGhostreconRewardBoxBtn", base)
local Localization = CS.GameEntry.Localization
local btn_path = ""
local boxImg_path = "BoxImg"

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
  self.btn = self:AddComponent(UIButton, btn_path)
  self.boxImg = self:AddComponent(UIImage, boxImg_path)
  self.btn:SetOnClick(Bind(self, self.OnClick))
end

local function ComponentDestroy(self)
  self.btn = nil
  self.boxImg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.cfg = nil
end

local function SetData(self, cfg)
  self.boxImg:LoadSprite(UIAssets.UIGhostreconCommonPath .. cfg.supreRewardIcon)
  self.cfg = cfg
end

local function OnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconGetBoxReward, {anim = true}, self.cfg)
end

UIGhostreconRewardBoxBtn.OnCreate = OnCreate
UIGhostreconRewardBoxBtn.OnDestroy = OnDestroy
UIGhostreconRewardBoxBtn.OnEnable = OnEnable
UIGhostreconRewardBoxBtn.OnDisable = OnDisable
UIGhostreconRewardBoxBtn.ComponentDefine = ComponentDefine
UIGhostreconRewardBoxBtn.ComponentDestroy = ComponentDestroy
UIGhostreconRewardBoxBtn.DataDefine = DataDefine
UIGhostreconRewardBoxBtn.DataDestroy = DataDestroy
UIGhostreconRewardBoxBtn.SetData = SetData
UIGhostreconRewardBoxBtn.OnClick = OnClick
return UIGhostreconRewardBoxBtn
