local UIGrowthPlanCell = BaseClass("UIGrowthPlanCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroCellBig = require("UI.UIHero2.Common.UIHeroCellBig")
local UIHeroTipsView = require("UI.UIHeroTips.View.UIHeroTipsView")
local btn_path = "Btn"
local glow_path = "Glow"
local mask_path = "Mask"
local lock_path = "Lock"
local check_path = "Check"
local hero_cell_path = "Root/UIHeroCellBig"

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
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    if self.onClick then
      self.onClick()
    end
  end)
  self.glow_go = self:AddComponent(UIBaseContainer, glow_path)
  self.mask_go = self:AddComponent(UIBaseContainer, mask_path)
  self.lock_go = self:AddComponent(UIBaseContainer, lock_path)
  self.check_go = self:AddComponent(UIBaseContainer, check_path)
  self.hero_cell = self:AddComponent(UIHeroCellBig, hero_cell_path)
end

local function ComponentDestroy(self)
  self.glow_go = nil
  self.mask_go = nil
  self.lock_go = nil
  self.check_go = nil
  self.hero_cell = nil
  self.btn = nil
end

local function DataDefine(self)
  self.data = nil
  self.onClick = nil
end

local function DataDestroy(self)
  self.data = nil
  self.onClick = nil
end

local function SetData(self, data)
  self.data = data
  self.lock_go:SetActive(data.locked)
  self.mask_go:SetActive(data.checked)
  self.check_go:SetActive(data.checked)
  self.glow_go:SetActive(data.canGet)
  self.hero_cell:InitWithConfigId(data.heroId, data.quality)
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

local function ShowTip(self)
  local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), tonumber(self.data.heroId))
  local param = UIHeroTipsView.Param.New()
  param.heroId = self.data.heroId
  param.title = Localization:GetString(heroConfig.name)
  param.content = Localization:GetString(heroConfig.brief_desc)
  param.dir = UIHeroTipsView.Direction.ABOVE
  param.defWidth = 300
  param.pivot = 0.5
  param.position = self.transform.position + Vector3.New(0, 80, 0)
  param.bindObject = self.gameObject
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, {anim = false}, param)
end

UIGrowthPlanCell.OnCreate = OnCreate
UIGrowthPlanCell.OnDestroy = OnDestroy
UIGrowthPlanCell.Param = Param
UIGrowthPlanCell.OnBtnClick = OnBtnClick
UIGrowthPlanCell.OnEnable = OnEnable
UIGrowthPlanCell.OnDisable = OnDisable
UIGrowthPlanCell.ComponentDefine = ComponentDefine
UIGrowthPlanCell.ComponentDestroy = ComponentDestroy
UIGrowthPlanCell.DataDefine = DataDefine
UIGrowthPlanCell.DataDestroy = DataDestroy
UIGrowthPlanCell.SetData = SetData
UIGrowthPlanCell.SetOnClick = SetOnClick
UIGrowthPlanCell.ShowTip = ShowTip
return UIGrowthPlanCell
