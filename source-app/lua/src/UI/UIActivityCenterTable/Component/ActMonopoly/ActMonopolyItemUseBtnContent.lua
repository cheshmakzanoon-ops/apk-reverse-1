local ActMonopolyItemUseBtnContent = BaseClass("ActMonopolyItemUseBtnContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local item_use_btn_path = "bottomContent/Layout/itemUseBtn"
local item_use_btn_red_point_path = "bottomContent/Layout/itemUseBtn/itemUseBtnRedPoint"
local item_use_btn_icon_path = "bottomContent/Layout/itemUseBtn/itemUseBtnIcon"

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

local function ComponentDefine(self)
  self.item_use_btn = self:AddComponent(UIButton, item_use_btn_path)
  self.item_use_btn_red_point = self:AddComponent(UIImage, item_use_btn_red_point_path)
  self.item_use_btn:SetOnClick(function()
    self:OnItemUseBtnClick()
  end)
  self.item_use_btn_icon = self:AddComponent(UIImage, item_use_btn_icon_path)
end

local function ComponentDestroy(self)
  self.item_use_btn_icon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, mainView, activityId, activityInfo, activityDetailData, costData, isBoss)
  self.mainView = mainView
  self.activityId = activityId
  self.activityInfo = activityInfo
  self.activityDetailData = activityDetailData
  self.costData = costData
  self.isBoss = isBoss
  self:SetConfigView()
  self:RefreshView()
end

local function RefreshView(self)
  local redNum = self.activityDetailData:GetItemUseRedNum()
  self.item_use_btn_red_point:SetActive(0 < redNum)
end

local function OnItemUseBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.ActMonopolyItemUse, {anim = true}, self.activityId)
end

local function SetConfigView(self)
  local showTemp = self.activityInfo:GetShowConfigTemp()
  if showTemp and not string.IsNullOrEmpty(showTemp.pic_spec1) then
    local path = string.format(UIAssets.UIActMonopolySpritePath, showTemp.pic_spec1)
    self.item_use_btn_icon:LoadSprite(path)
  end
end

ActMonopolyItemUseBtnContent.OnCreate = OnCreate
ActMonopolyItemUseBtnContent.OnDestroy = OnDestroy
ActMonopolyItemUseBtnContent.ComponentDefine = ComponentDefine
ActMonopolyItemUseBtnContent.ComponentDestroy = ComponentDestroy
ActMonopolyItemUseBtnContent.DataDefine = DataDefine
ActMonopolyItemUseBtnContent.DataDestroy = DataDestroy
ActMonopolyItemUseBtnContent.SetData = SetData
ActMonopolyItemUseBtnContent.SetConfigView = SetConfigView
ActMonopolyItemUseBtnContent.RefreshView = RefreshView
ActMonopolyItemUseBtnContent.OnItemUseBtnClick = OnItemUseBtnClick
return ActMonopolyItemUseBtnContent
