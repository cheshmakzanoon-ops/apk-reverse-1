local UIGrowthPlanItem = BaseClass("UIGrowthPlanItem", UIBaseContainer)
local base = UIBaseContainer
local UIGrowthPlanCell = require("UI.UIGiftPackage.Component.UIGrowthPlanCell")
local UIGrowthPlanHeroCell = require("UI.UIGiftPackage.Component.UIGrowthPlanHeroCell")
local root_path = "Root"
local cell_top_path = "Root/CellTop"
local cell_bottom_1_path = "Root/CellBottom1"
local cell_bottom_2_path = "Root/CellBottom2"
local cell_bottom_3_path = "Root/CellBottom3"
local desc_path = "Root/Desc"
local slider_bg_first_path = "Root/SliderRoot/SliderBgFirst"
local slider_bg_normal_path = "Root/SliderRoot/SliderBgNormal"
local slider_bg_last_path = "Root/SliderRoot/SliderBgLast"
local slider_path = "Root/SliderRoot/Slider"
local slider_ball_right_path = "Root/SliderRoot/SliderBallRight"
local slider_ball_left_path = "Root/SliderRoot/SliderBallLeft"
local CellPos = {
  Top = 1,
  Bottom1 = 2,
  Bottom2 = 3,
  Bottom3 = 4
}

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
  self.root_go = self:AddComponent(UIBaseContainer, root_path)
  self.cell_top = self:AddComponent(UIGrowthPlanCell, cell_top_path)
  self.cell_top:SetOnClick(function()
    self:OnCellClick(CellPos.Top)
  end)
  self.cell_bottom_1 = self:AddComponent(UIGrowthPlanCell, cell_bottom_1_path)
  self.cell_bottom_1:SetOnClick(function()
    self:OnCellClick(CellPos.Bottom1)
  end)
  self.cell_bottom_2 = self:AddComponent(UIGrowthPlanCell, cell_bottom_2_path)
  self.cell_bottom_2:SetOnClick(function()
    self:OnCellClick(CellPos.Bottom2)
  end)
  self.cell_bottom_3 = self:AddComponent(UIGrowthPlanHeroCell, cell_bottom_3_path)
  self.cell_bottom_3:SetOnClick(function()
    self:OnCellClick(CellPos.Bottom3)
  end)
  self.slider_bg_first_go = self:AddComponent(UIBaseContainer, slider_bg_first_path)
  self.slider_bg_normal_go = self:AddComponent(UIBaseContainer, slider_bg_normal_path)
  self.slider_bg_last_go = self:AddComponent(UIBaseContainer, slider_bg_last_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_ball_right_go = self:AddComponent(UIBaseContainer, slider_ball_right_path)
  self.slider_ball_left_go = self:AddComponent(UIBaseContainer, slider_ball_left_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
end

local function ComponentDestroy(self)
  self.root_go = nil
  self.cell_top = nil
  self.cell_bottom_1 = nil
  self.cell_bottom_2 = nil
  self.slider_bg_first_go = nil
  self.slider_bg_normal_go = nil
  self.slider_bg_last_go = nil
  self.slider = nil
  self.slider_ball_go = nil
  self.desc_text = nil
end

local function DataDefine(self)
  self.view = nil
  self.data = nil
  self.onClick = nil
end

local function DataDestroy(self)
  self.view = nil
  self.data = nil
  self.onClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data, view)
  self.view = view
  self.data = data
  self.root_go:SetActive(true)
  if data.needLevel == view.nextLevel then
    self.desc_text:SetLocalText(320314, data.needLevel)
  else
    self.desc_text:SetLocalText(300665, data.needLevel)
  end
  self.slider_bg_first_go:SetActive(data.isFirst)
  self.slider_bg_normal_go:SetActive(not data.isFirst and not data.isLast)
  self.slider_bg_last_go:SetActive(data.isLast)
  self.slider:SetValue(data.pro)
  self.slider_ball_right_go:SetActive(data.showBallRight)
  self.slider_ball_left_go:SetActive(data.showBallLeft)
  local locked, checked, canGet
  locked = DataCenter.BuildManager.MainLv < data.needLevel
  checked = data.normalState == 1
  canGet = not locked and not checked
  if data.normalReward[1] then
    local dataTop = {
      locked = locked,
      checked = checked,
      canGet = canGet,
      reward = data.normalReward[1]
    }
    self.cell_top:SetActive(true)
    self.cell_top:SetData(dataTop)
  else
    self.cell_top:SetActive(false)
  end
  locked = DataCenter.BuildManager.MainLv < data.needLevel or not self.view.specialUnlocked
  checked = data.specialState == 1
  canGet = not locked and not checked
  if #data.specialReward == 1 and data.specialReward[1].type == RewardType.HERO then
    self.cell_bottom_1:SetActive(false)
    self.cell_bottom_2:SetActive(false)
    self.cell_bottom_3:SetActive(true)
    local heroId = data.specialReward[1].value.id
    local quality = tonumber(GetTableData(HeroUtils.GetHeroXmlName(), heroId, "init_quality_level"))
    local dataBottom3 = {
      locked = locked,
      checked = checked,
      canGet = canGet,
      reward = data.specialReward[1],
      heroId = heroId,
      quality = quality
    }
    self.cell_bottom_3:SetData(dataBottom3)
  else
    self.cell_bottom_3:SetActive(false)
    if #data.specialReward == 2 then
      table.sort(data.specialReward, function(a, b)
        return a.type == RewardType.GOLD
      end)
    end
    if data.specialReward[1] then
      local dataBottom1 = {
        locked = locked,
        checked = checked,
        canGet = canGet,
        reward = data.specialReward[1]
      }
      self.cell_bottom_1:SetActive(true)
      self.cell_bottom_1:SetData(dataBottom1)
    else
      self.cell_bottom_1:SetActive(false)
    end
    if data.specialReward[2] then
      local dataBottom2 = {
        locked = locked,
        checked = checked,
        canGet = canGet,
        reward = data.specialReward[2]
      }
      self.cell_bottom_2:SetActive(true)
      self.cell_bottom_2:SetData(dataBottom2)
    else
      self.cell_bottom_2:SetActive(false)
    end
  end
end

local function SetBlank(self)
  self.root_go:SetActive(false)
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

local function OnCellClick(self, cellPos)
  if self.onClick then
    self.onClick(cellPos)
  end
end

local function ShowCellTip(self, cellPos)
  if cellPos == CellPos.Top then
    self.cell_top:OnBtnClick()
  elseif cellPos == CellPos.Bottom1 then
    self.cell_bottom_1:OnBtnClick()
  elseif cellPos == CellPos.Bottom2 then
    self.cell_bottom_2:OnBtnClick()
  elseif cellPos == CellPos.Bottom3 then
    self.cell_bottom_3:ShowTip()
  end
end

UIGrowthPlanItem.OnCreate = OnCreate
UIGrowthPlanItem.OnDestroy = OnDestroy
UIGrowthPlanItem.OnEnable = OnEnable
UIGrowthPlanItem.OnDisable = OnDisable
UIGrowthPlanItem.ComponentDefine = ComponentDefine
UIGrowthPlanItem.ComponentDestroy = ComponentDestroy
UIGrowthPlanItem.DataDefine = DataDefine
UIGrowthPlanItem.DataDestroy = DataDestroy
UIGrowthPlanItem.OnAddListener = OnAddListener
UIGrowthPlanItem.OnRemoveListener = OnRemoveListener
UIGrowthPlanItem.CellPos = CellPos
UIGrowthPlanItem.SetData = SetData
UIGrowthPlanItem.SetBlank = SetBlank
UIGrowthPlanItem.SetOnClick = SetOnClick
UIGrowthPlanItem.OnCellClick = OnCellClick
UIGrowthPlanItem.ShowCellTip = ShowCellTip
return UIGrowthPlanItem
