local UICampEffectOverviewCanFoldItem = BaseClass("UICampEffectOverviewCanFoldItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICampEffectOverviewCanFoldItemContent = require("UI.LWSeasonShared.UICampEffectOverview.Component.UICampEffectOverviewCanFoldItemContent")
local name_path = "title/Content/name"
local icon_content_path = "title/Content/iconContent"
local empty_content_path = "title/Content/emptyContent"
local value_path = "title/Content/value"
local power_source_type_content_path = "PowerSourceTypeContent"
local property_row_path = "propertyRow"
local button_path = "title/Content/buttonContent/button"
local button_img_path = "title/Content/buttonContent/buttonImg"
local button_content_path = "title/Content/buttonContent"
local BUTT_TITLE_KEYS = {
  [0] = "season_camp_science_ui_4",
  [1] = "season_camp_science_ui_5",
  [2] = "season_camp_science_ui_6"
}

function UICampEffectOverviewCanFoldItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICampEffectOverviewCanFoldItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICampEffectOverviewCanFoldItem:ComponentDefine()
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.icon_content = self:AddComponent(UIBaseContainer, icon_content_path)
  self.empty_content = self:AddComponent(UIBaseContainer, empty_content_path)
  self.value = self:AddComponent(UITextMeshProUGUIEx, value_path)
  self.power_source_type_content = self:AddComponent(UIBaseContainer, power_source_type_content_path)
  self.property_row = self:AddComponent(UIBaseContainer, property_row_path)
  self.button = self:AddComponent(UIButton, button_path)
  self.button_img = self:AddComponent(UIImage, button_img_path)
  self.button_content = self:AddComponent(UIBaseContainer, button_content_path)
  self.goItem = self.property_row.gameObject
  self.goItem:GameObjectCreatePool()
  self.button:SetOnClick(function()
    self:OnClick()
  end)
  self.button_content:SetActive(true)
end

function UICampEffectOverviewCanFoldItem:ComponentDestroy()
  self.goItem:GameObjectRecycleAll()
  self.goItem = nil
  self.name = nil
  self.icon_content = nil
  self.empty_content = nil
  self.value = nil
  self.power_source_type_content = nil
  self.property_row = nil
  self.button = nil
  self.button_img = nil
  self.button_content = nil
end

function UICampEffectOverviewCanFoldItem:Refresh(data, index)
  self.data = data
  self.index = index
  self.name:SetLocalText(BUTT_TITLE_KEYS[index])
  self.goItem:GameObjectRecycleAll()
  self.power_source_type_content:RemoveComponents(UICampEffectOverviewCanFoldItemContent)
  self.foldIndex = 0
  for i = 1, #data do
    local opData = data[i]
    if not string.IsNullOrEmpty(opData.para1) then
      self:AddFoldItemView(opData.para1, opData.para2)
    end
    if not string.IsNullOrEmpty(opData.camp_map_effect) then
      self:AddFoldItemView(opData.camp_map_effect, opData.camp_map_effect_num)
    end
  end
  self:RefreshShowTypeView()
end

function UICampEffectOverviewCanFoldItem:AddFoldItemView(effectStr, effectValueStr)
  local strArray = string.split_ss_array(effectStr, ";")
  local valueStrArray = string.split_ss_array(effectValueStr, ";")
  for k, v in ipairs(strArray) do
    local goObj = self.goItem:GameObjectSpawn(self.power_source_type_content.transform)
    goObj.name = "item_" .. self.foldIndex
    goObj:SetActive(true)
    local itemRender = self.power_source_type_content:AddComponent(UICampEffectOverviewCanFoldItemContent, goObj.name)
    itemRender:Refresh(v, valueStrArray[k], self.index == 0)
    self.foldIndex = self.foldIndex + 1
  end
end

function UICampEffectOverviewCanFoldItem:RefreshShowTypeView()
  if self.data and #self.data > 0 then
    self.power_source_type_content:SetActive(self.data.isShowDetail)
  else
    self.power_source_type_content:SetActive(false)
  end
  if self.data.isShowDetail then
    self.button_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png")
  else
    self.button_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_2.png")
  end
end

function UICampEffectOverviewCanFoldItem:OnClick()
  self.data.isShowDetail = not self.data.isShowDetail
  self:RefreshShowTypeView()
end

return UICampEffectOverviewCanFoldItem
