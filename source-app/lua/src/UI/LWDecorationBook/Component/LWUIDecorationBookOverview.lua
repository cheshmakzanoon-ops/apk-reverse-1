local base = UIBaseView
local LWUIDecorationBookOverview = BaseClass("LWUIDecorationBookOverview", base)
local DecorationBookOverviewItem = require("UI.LWDecorationBook.Component.DecorationBookOverviewItem")
local tip1_text_path = "TopContent/Tip1Text"
local ur_slider_content_path = "TopContent/ProgressContent/URSliderContent"
local ssr_slider_content_path = "TopContent/ProgressContent/SSRSliderContent"
local sr_slider_content_path = "TopContent/ProgressContent/SRSliderContent"
local ur_slider_path = "TopContent/ProgressContent/URSliderContent/Slider1"
local ssr_slider_path = "TopContent/ProgressContent/SSRSliderContent/Slider2"
local sr_slider_path = "TopContent/ProgressContent/SRSliderContent/Slider3"
local ur_progress_path = "TopContent/ProgressContent/URSliderContent/Progress1"
local ssr_progress_path = "TopContent/ProgressContent/SSRSliderContent/Progress2"
local sr_progress_path = "TopContent/ProgressContent/SRSliderContent/Progress3"
local power_text_path = "TopContent/PowerBGContent/PowerText"
local power_value_path = "TopContent/PowerBGContent/PowerValue"
local title_text_path = "MiddleContent/TitleText"
local scroll_view_path = "MiddleContent/Scroll View"
local power_info_btn_path = "TopContent/PowerBGContent/PowerInfoBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:ShowPanel()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self.effectTypeList = nil
  base.OnDestroy(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.tip1_text = self:AddComponent(UIText, tip1_text_path)
  self.power_value = self:AddComponent(UIText, power_value_path)
  self.urSlider = self:AddComponent(UISlider, ur_slider_path)
  self.ssrSlider = self:AddComponent(UISlider, ssr_slider_path)
  self.srSlider = self:AddComponent(UISlider, sr_slider_path)
  self.urProgress = self:AddComponent(UIText, ur_progress_path)
  self.ssrProgress = self:AddComponent(UIText, ssr_progress_path)
  self.srProgress = self:AddComponent(UIText, sr_progress_path)
  self.power_info_btn = self:AddComponent(UIButton, power_info_btn_path)
  self.power_info_btn:SetOnClick(function()
    self:OnPowerInfoBtnClick()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
end

local function ShowPanel(self)
  local heroDataList = DataCenter.HeroDataManager:GetAllHeroList()
  local finalPower = LuaEntry.Player.decoPower * table.count(heroDataList)
  self.power_value:SetText(string.GetFormattedSeparatorNum(finalPower))
  self:ShowProgress()
  self:ClearScroll()
  self:ShowEffectList()
end

local function ShowProgress(self)
  local urMaxCount = self:GetMaxDecorationCountByQuality(5)
  local ssrMaxCount = self:GetMaxDecorationCountByQuality(4)
  local srMaxCount = self:GetMaxDecorationCountByQuality(3)
  local urHaveCount = DataCenter.BuildManager:GetDecorationTypeCountByQuality(5)
  local ssrHaveCount = DataCenter.BuildManager:GetDecorationTypeCountByQuality(4)
  local srHaveCount = DataCenter.BuildManager:GetDecorationTypeCountByQuality(3)
  self.urSlider:SetValue(urHaveCount / urMaxCount)
  self.ssrSlider:SetValue(ssrHaveCount / ssrMaxCount)
  self.srSlider:SetValue(srHaveCount / srMaxCount)
  self.urProgress:SetText(urHaveCount .. "/" .. urMaxCount)
  self.ssrProgress:SetText(ssrHaveCount .. "/" .. ssrMaxCount)
  self.srProgress:SetText(srHaveCount .. "/" .. srMaxCount)
end

local function GetMaxDecorationCountByQuality(self, quality)
  local list = DataCenter.BuildTemplateManager:GetNoBuyDecorateDataListByQuality(quality)
  return table.count(list)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(DecorationBookOverviewItem, itemObj)
  local data = {
    type = self.effectTypeList[index].type,
    effectMap = self.effectTypeList[index].value
  }
  cellItem:Refresh(data)
end

local function OnItemMoveOut(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, DecorationBookOverviewItem)
end

local function ShowEffectList(self)
  self.effectTypeMap = DataCenter.BuildManager:GetAllDecoPropertyMap()
  self.effectTypeList = {}
  for k, v in pairs(self.effectTypeMap) do
    local data = {}
    data.type = k
    data.value = v
    table.insert(self.effectTypeList, data)
  end
  table.sort(self.effectTypeList, function(a, b)
    return a.type < b.type
  end)
  if table.count(self.effectTypeList) > 0 then
    self.scroll_view:SetTotalCount(#self.effectTypeList)
    self.scroll_view:RefillCells()
  end
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(DecorationBookOverviewItem)
end

local function OnPowerInfoBtnClick(self)
  UIUtil.ShowTipsId("building_center_tips2")
end

LWUIDecorationBookOverview.OnCreate = OnCreate
LWUIDecorationBookOverview.OnDestroy = OnDestroy
LWUIDecorationBookOverview.OnCreate = OnCreate
LWUIDecorationBookOverview.ComponentDefine = ComponentDefine
LWUIDecorationBookOverview.ComponentDestroy = ComponentDestroy
LWUIDecorationBookOverview.OnAddListener = OnAddListener
LWUIDecorationBookOverview.OnRemoveListener = OnRemoveListener
LWUIDecorationBookOverview.ShowPanel = ShowPanel
LWUIDecorationBookOverview.ShowProgress = ShowProgress
LWUIDecorationBookOverview.GetMaxDecorationCountByQuality = GetMaxDecorationCountByQuality
LWUIDecorationBookOverview.OnItemMoveIn = OnItemMoveIn
LWUIDecorationBookOverview.OnItemMoveOut = OnItemMoveOut
LWUIDecorationBookOverview.ShowEffectList = ShowEffectList
LWUIDecorationBookOverview.ClearScroll = ClearScroll
LWUIDecorationBookOverview.OnPowerInfoBtnClick = OnPowerInfoBtnClick
return LWUIDecorationBookOverview
