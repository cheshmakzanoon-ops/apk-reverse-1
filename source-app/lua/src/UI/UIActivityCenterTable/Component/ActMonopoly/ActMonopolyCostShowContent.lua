local ActMonopolyCostShowContent = BaseClass("ActMonopolyCostShowContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local resourceNum_path = "ActivityTopGo/ResBar/root/resourceNum"
local resourceIcon_path = "ActivityTopGo/ResBar/root/resourceIcon"
local addBtn_path = "ActivityTopGo/ResBar/addBtn"
local addBtnRedPoint_path = "ActivityTopGo/ResBar/addBtn/addRedPoint"
local item_click_mask_path = "ActivityTopGo/ItemBar1/itemClickMask"
local item_bar1_path = "ActivityTopGo/ItemBar1"

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
  self.addBtn = self:AddComponent(UIButton, addBtn_path)
  self.addBtn:SetOnClick(function()
    self:OnGotoBtnClick()
  end)
  self.addBtnRedPoint = self:AddComponent(UIBaseContainer, addBtnRedPoint_path)
  self.resourceNum = self:AddComponent(UIText, resourceNum_path)
  self.resourceIcon = self:AddComponent(UIImage, resourceIcon_path)
  self.item_bar1 = self:AddComponent(UITopItem, item_bar1_path)
  self.item_bar1:SetData(nil, ResourceType.Gold)
  self.item_click_mask = self:AddComponent(UIButton, item_click_mask_path)
  self.item_click_mask:SetOnClick(function()
    self:OnItemClickFunc()
  end)
end

local function ComponentDestroy(self)
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
  self:RefreshView()
end

local function RefreshView(self)
  local costData = self.costData[1][1]
  if costData then
    local costId = costData.itemId
    local iconPath = DataCenter.RewardManager:GetPicByType(costData.type, costData.itemId)
    self.resourceIcon:LoadSprite(iconPath)
    local curNum = DataCenter.ItemData:GetItemCount(costId)
    self.resourceNum:SetText(curNum)
  end
  self.addBtnRedPoint:SetActive(DataCenter.ActMonopolyDataManager:CanGetFreePack(tonumber(self.activityId)))
  self.item_bar1:RefreshData()
end

local function OnGotoBtnClick(self)
  local costData = self.costData[1][1]
  local costId = costData.itemId
  local canGotoPackShop = DataCenter.ActMonopolyDataManager:CanGotoPackShop(tonumber(self.activityId))
  if canGotoPackShop then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.activityId, DataCenter.ActMonopolyDataManager:GetKeyGiftPackId(tonumber(self.activityId)), costId)
  else
    UIUtil.ShowTipsId(2000655)
  end
end

local function OnItemClickFunc(self)
  GoToUtil.GotoPay()
end

ActMonopolyCostShowContent.OnCreate = OnCreate
ActMonopolyCostShowContent.OnDestroy = OnDestroy
ActMonopolyCostShowContent.ComponentDefine = ComponentDefine
ActMonopolyCostShowContent.ComponentDestroy = ComponentDestroy
ActMonopolyCostShowContent.DataDefine = DataDefine
ActMonopolyCostShowContent.DataDestroy = DataDestroy
ActMonopolyCostShowContent.SetData = SetData
ActMonopolyCostShowContent.RefreshView = RefreshView
ActMonopolyCostShowContent.OnGotoBtnClick = OnGotoBtnClick
ActMonopolyCostShowContent.OnItemClickFunc = OnItemClickFunc
return ActMonopolyCostShowContent
