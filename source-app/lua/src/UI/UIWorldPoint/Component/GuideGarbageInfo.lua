local GuideGarbageInfo = BaseClass("GuideGarbageInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local panel_path = "GuidePanelBG"
local reward_title_path = "GuidePanelBG/Reward_title"
local name_path = "GuidePanelBG/Head/Name_text"
local cell_container_path = "GuidePanelBG/RewardItemContainer"
local dig_btn_path = "GuidePanelBG/Dig_btn"
local cell_1_path = "GuidePanelBG/RewardItemContainer/Cell_1"
local cell_2_path = "GuidePanelBG/RewardItemContainer/Cell_2"
local cell_3_path = "GuidePanelBG/RewardItemContainer/Cell_3"
local cell_1_icon_path = "GuidePanelBG/RewardItemContainer/Cell_1/bg_1"
local cell_2_icon_path = "GuidePanelBG/RewardItemContainer/Cell_2/bg_2"
local cell_3_icon_path = "GuidePanelBG/RewardItemContainer/Cell_3/bg_3"
local cell_1_num_path = "GuidePanelBG/RewardItemContainer/Cell_1/bg_1/Item_num_1"
local cell_2_num_path = "GuidePanelBG/RewardItemContainer/Cell_2/bg_2/Item_num_2"
local cell_3_num_path = "GuidePanelBG/RewardItemContainer/Cell_3/bg_3/Item_num_3"
local min_panel_width = 500
local max_panel_width = 570
local max_num = 3

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
  self.reward_title = self:AddComponent(UIText, reward_title_path)
  self.reward_title:SetLocalText(130065)
  self.name = self:AddComponent(UIText, name_path)
  self.name:SetLocalText(104196)
  self.dig_btn = self:AddComponent(UIButton, dig_btn_path)
  self.dig_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDigClick()
  end)
  self.cell_container = self:AddComponent(UIBaseContainer, cell_container_path)
  self.panel = self:AddComponent(UIImage, panel_path)
  self.cell_1 = self:AddComponent(UIBaseContainer, cell_1_path)
  self.cell_2 = self:AddComponent(UIBaseContainer, cell_2_path)
  self.cell_3 = self:AddComponent(UIBaseContainer, cell_3_path)
  self.cell_icon_1 = self:AddComponent(UIImage, cell_1_icon_path)
  self.cell_icon_2 = self:AddComponent(UIImage, cell_2_icon_path)
  self.cell_icon_3 = self:AddComponent(UIImage, cell_3_icon_path)
  self.cell_num_1 = self:AddComponent(UIText, cell_1_num_path)
  self.cell_num_2 = self:AddComponent(UIText, cell_2_num_path)
  self.cell_num_3 = self:AddComponent(UIText, cell_3_num_path)
end

local function ComponentDestroy(self)
  self.reward_title = nil
  self.name = nil
  self.dig_btn = nil
  self.cell_container = nil
  self.panel = nil
  self.cell_1 = nil
  self.cell_2 = nil
  self.cell_3 = nil
  self.cell_icon_1 = nil
  self.cell_icon_2 = nil
  self.cell_icon_3 = nil
  self.cell_num_1 = nil
  self.cell_num_2 = nil
  self.cell_num_3 = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function RefreshData(self, param)
  self.data = param
  local index = 1
  while index <= max_num do
    self:RefreshCell(index, param.rewardStr[index])
    index = index + 1
  end
  local _, sy = self.panel.rectTransform:Get_sizeDelta()
  if #param.rewardStr > 2 then
    self.panel.rectTransform:Set_sizeDelta(max_panel_width, sy)
  else
    self.panel.rectTransform:Set_sizeDelta(min_panel_width, sy)
  end
end

local function RefreshCell(self, index, data)
  local cell = self["cell_" .. index]
  if cell ~= nil then
    if data ~= nil then
      local icon = self["cell_icon_" .. index]
      local num = self["cell_num_" .. index]
      cell:SetActive(true)
      if icon ~= nil and num ~= nil then
        icon:LoadSprite(data.iconName)
        num:SetText(tostring(data.count))
      end
    else
      cell:SetActive(false)
    end
  end
end

local function OnDigClick(self)
  if CS.SceneManager:IsInCity() then
    if self.view:CheckResourceItemIsFull() == true then
      GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
      return
    end
    DataCenter.GuideCityManager:StartMoveCityTroop(self.view.ctrl.pointId)
    DataCenter.PickGarbageDataManager:AddIndexToGarbageQueue(self.view.ctrl.pointId)
    self.view.ctrl:CloseSelf(false)
    return
  end
end

GuideGarbageInfo.OnCreate = OnCreate
GuideGarbageInfo.OnDestroy = OnDestroy
GuideGarbageInfo.OnEnable = OnEnable
GuideGarbageInfo.OnDisable = OnDisable
GuideGarbageInfo.ComponentDefine = ComponentDefine
GuideGarbageInfo.ComponentDestroy = ComponentDestroy
GuideGarbageInfo.DataDefine = DataDefine
GuideGarbageInfo.DataDestroy = DataDestroy
GuideGarbageInfo.RefreshData = RefreshData
GuideGarbageInfo.RefreshCell = RefreshCell
GuideGarbageInfo.OnDigClick = OnDigClick
return GuideGarbageInfo
