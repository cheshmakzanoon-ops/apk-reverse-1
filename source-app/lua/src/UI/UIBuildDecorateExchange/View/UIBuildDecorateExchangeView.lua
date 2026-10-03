local UIBuildDecorateExchangeView = BaseClass("UIBuildDecorateExchangeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "UICommonPopUpTitle/panel"
local title_text_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local tips1_path = "MiddleBg/Tips1"
local icon_content_path = "MiddleBg/IconContent"
local tips2_path = "MiddleBg/Tips2"
local enough_btn_path = "MiddleBg/EnoughBtn"
local lack_btn_path = "MiddleBg/LackBtn"
local item_count_path = "MiddleBg/IconContent/ItemIcon/ItemCount"
local decorator_count_path = "MiddleBg/IconContent/DecoratorIcon/DecoratorCount"
local decorator_icon_path = "MiddleBg/IconContent/DecoratorIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.data = self:GetUserData()
  self:Refresh()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tips1 = self:AddComponent(UIText, tips1_path)
  self.icon_content = self:AddComponent(UIBaseContainer, icon_content_path)
  self.tips2 = self:AddComponent(UIText, tips2_path)
  self.enough_btn = self:AddComponent(UIButton, enough_btn_path)
  self.lack_btn = self:AddComponent(UIButton, lack_btn_path)
  self.enough_btn:SetOnClick(function()
    self:OnClickEnoughBtn()
  end)
  self.lack_btn:SetOnClick(function()
    self:OnClickLackBtn()
  end)
  self.item_count = self:AddComponent(UIText, item_count_path)
  self.decorator_count = self:AddComponent(UIText, decorator_count_path)
  self.decorator_icon = self:AddComponent(UIImage, decorator_icon_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.close_btn = nil
  self.title_text = nil
  self.icon_content = nil
  self.tips1 = nil
  self.tips2 = nil
  self.enough_btn = nil
  self.lack_btn = nil
  self.item_count = nil
  self.decorator_count = nil
  self.decorator_icon = nil
end

local function Refresh(self)
  self.data.haveGlueCount = DataCenter.ItemData:GetItemCount(GLUE_GOOD_ID)
  local oneLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.data.buildingData.itemId, 1)
  local needCount = self.data.needGlueCount // oneLevelTemplate.equal_glue_value
  self.tips1:SetLocalText("building_center_desc30", needCount)
  self.tips2:SetLocalText("building_center_desc27", oneLevelTemplate.equal_glue_value)
  self.item_count:SetText(self.data.haveGlueCount < self.data.needGlueCount and string.format("<color=#F97077>%d</color>/%d", self.data.haveGlueCount, self.data.needGlueCount) or string.format("<color=#5FEF87>%d</color>/%d", self.data.needGlueCount, self.data.needGlueCount))
  self.decorator_count:SetText(needCount)
  self.enough_btn:SetActive(self.data.haveGlueCount >= self.data.needGlueCount)
  self.lack_btn:SetActive(self.data.haveGlueCount < self.data.needGlueCount)
  self.decorator_icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.data.buildingData.itemId, 1), DefaultImage)
end

local function OnClickEnoughBtn(self)
  local levelUpInfos = BuildingUtils.GetDecorateUpLevelBuilds(self.data.buildingData)
  local glueData = {}
  glueData.itemId = GLUE_GOOD_ID
  glueData.count = self.data.needGlueCount
  table.insert(levelUpInfos, glueData)
  SFSNetwork.SendMessage(MsgDefines.DecoratorUpgrade, self.data.buildingData.uuid, levelUpInfos)
  self.ctrl:CloseSelf()
end

local function OnClickLackBtn(self)
  LWResourceLackUtil:GotoGoodsItemLack(GLUE_GOOD_ID, self.data.needGlueCount - self.data.haveGlueCount)
end

function UIBuildDecorateExchangeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.Refresh)
end

function UIBuildDecorateExchangeView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.Refresh)
end

UIBuildDecorateExchangeView.OnCreate = OnCreate
UIBuildDecorateExchangeView.OnDestroy = OnDestroy
UIBuildDecorateExchangeView.Refresh = Refresh
UIBuildDecorateExchangeView.ComponentDefine = ComponentDefine
UIBuildDecorateExchangeView.ComponentDestroy = ComponentDestroy
UIBuildDecorateExchangeView.OnClickEnoughBtn = OnClickEnoughBtn
UIBuildDecorateExchangeView.OnClickLackBtn = OnClickLackBtn
return UIBuildDecorateExchangeView
