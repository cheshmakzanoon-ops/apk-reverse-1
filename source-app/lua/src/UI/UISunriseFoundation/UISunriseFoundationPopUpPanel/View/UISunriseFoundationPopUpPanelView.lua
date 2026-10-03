local UISunriseFoundationPopUpPanelView = BaseClass("UISunriseFoundationPopUpPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local close_path = "Close"
local back_path = "UIScrollPackContent/CloseBtn"
local allRewardsScroll_view_path = "UIScrollPackContent/AllRewardScrollView"
local buy_btn_path = "UIScrollPackContent/BuyButton"
local buy_text_path = "UIScrollPackContent/BuyButton/BuyButtonText"
local point_path = "UIScrollPackContent/BuyButton/UIGiftPackagePoint"
local CurRewardScroll_view_path = "UIScrollPackContent/CurRewardScrollView"
local title3Text_path = "UIScrollPackContent/Title3"
local dec1_path = "UIScrollPackContent/Dec1"
local dec2_path = "UIScrollPackContent/Dec2"
local dec3_path = "UIScrollPackContent/Dec3"
local common_bg_orange3_path = "UIScrollPackContent/Common_bg_orange3"
local bg1_path = "UIScrollPackContent/Bg1"
local bg2_path = "UIScrollPackContent/Bg2"
local common_bg_orange_path = "UIScrollPackContent/Common_bg_orange"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ClearScroll()
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
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.back_btn = self:AddComponent(UIButton, back_path)
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.allRewardsScroll_view = self:AddComponent(UIScrollView, allRewardsScroll_view_path)
  self.allRewardsScroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.allRewardsScroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn:SetOnClick(function()
    self:OnBuyClick()
  end)
  self.buy_btn:SetSafeClickMode(true)
  self.buy_text = self:AddComponent(UIText, buy_text_path)
  self.point_rect = self:AddComponent(UIGiftPackagePoint, point_path)
  self.curRewardsScroll_view = self:AddComponent(UIScrollView, CurRewardScroll_view_path)
  self.curRewardsScroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell2(itemObj, index)
  end)
  self.curRewardsScroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell2(itemObj, index)
  end)
  self.title3Text = self:AddComponent(UIText, title3Text_path)
  self.title3Text:SetText("")
  self.dec1 = self:AddComponent(UIRawImage, dec1_path)
  self.dec2 = self:AddComponent(UIImage, dec2_path)
  self.dec3 = self:AddComponent(UIImage, dec3_path)
  self.common_bg_orange3 = self:AddComponent(UIImage, common_bg_orange3_path)
  self.bg1 = self:AddComponent(UIImage, bg1_path)
  self.bg2 = self:AddComponent(UIImage, bg2_path)
  self.common_bg_orange = self:AddComponent(UIImage, common_bg_orange_path)
end

local function ComponentDestroy(self)
  self.allRewardsScroll_view = nil
  self.buy_btn = nil
  self.buy_text = nil
  self.point_rect = nil
  self.curRewardsScroll_view = nil
  self.dec1 = nil
  self.dec2 = nil
  self.dec3 = nil
  self.common_bg_orange3 = nil
  self.bg1 = nil
  self.bg2 = nil
  self.common_bg_orange = nil
end

local function DataDefine(self)
  self.allRewardList = nil
  self.timer = nil
  self.packageInfo = nil
end

local function DataDestroy(self)
  self.allRewardList = nil
  self.timer_action = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self.actId = self:GetUserData()
  self.actData = DataCenter.ActSunriseFoundationDataManager:GetActData(self.actId)
  if self.actData == nil then
    return
  end
  self.packageInfo = GiftPackageData.get(self.actData.exchangeId)
  if self.packageInfo then
    self.buy_btn:SetActive(true)
    local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
    self.buy_text:SetText(price)
    self.point_rect:RefreshPoint(self.packageInfo)
    self.title3Text:SetText(self.packageInfo:getNameText())
  else
    self.buy_btn:SetActive(false)
    self.title3Text:SetText("")
  end
  self:ShowCells()
end

local function ShowCells(self)
  local level = 0
  level = DataCenter.BuildManager.MainLv or 0
  self.curRewardList, self.allRewardList = self.actData:CheckLvGetReward(1, level, 1)
  if self.packageInfo then
    local exchangeReward = self.packageInfo:getItems(true)
    if not table.IsNullOrEmpty(exchangeReward) then
      for i, v in pairs(exchangeReward) do
        table.insert(self.curRewardList, i, v)
        table.insert(self.allRewardList, i, v)
      end
    end
  end
  local count = table.count(self.allRewardList)
  if 0 < count then
    self.allRewardsScroll_view:SetTotalCount(count)
    self.allRewardsScroll_view:RefillCells()
  end
  local count2 = table.count(self.curRewardList)
  if 0 < count2 then
    self.curRewardsScroll_view:SetTotalCount(count2)
    self.curRewardsScroll_view:RefillCells()
  end
end

local function ClearScroll(self)
  self.allRewardsScroll_view:ClearCells()
  self.allRewardsScroll_view:RemoveComponents(UICommonResItem)
  self.curRewardsScroll_view:ClearCells()
  self.curRewardsScroll_view:RemoveComponents(UICommonResItem)
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  itemObj.transform:Set_localScale(0.8, 0.8, 1)
  local item = self.allRewardsScroll_view:AddComponent(UICommonResItem, itemObj)
  item:ReInit(self.allRewardList[index])
end

local function OnDeleteCell(self, itemObj, index)
  self.allRewardsScroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

local function OnCreateCell2(self, itemObj, index)
  itemObj.name = tostring(index)
  itemObj.transform:Set_localScale(0.8, 0.8, 1)
  local item = self.curRewardsScroll_view:AddComponent(UICommonResItem, itemObj)
  item:ReInit(self.curRewardList[index])
end

local function OnDeleteCell2(self, itemObj, index)
  self.curRewardsScroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

local function OnBuyClick(self)
  if self.packageInfo then
    DataCenter.PayManager:CallPayment(self.packageInfo, nil)
    self.ctrl:CloseSelf()
  end
end

UISunriseFoundationPopUpPanelView.OnCreate = OnCreate
UISunriseFoundationPopUpPanelView.OnDestroy = OnDestroy
UISunriseFoundationPopUpPanelView.ComponentDefine = ComponentDefine
UISunriseFoundationPopUpPanelView.DataDefine = DataDefine
UISunriseFoundationPopUpPanelView.DataDestroy = DataDestroy
UISunriseFoundationPopUpPanelView.OnAddListener = OnAddListener
UISunriseFoundationPopUpPanelView.OnRemoveListener = OnRemoveListener
UISunriseFoundationPopUpPanelView.ReInit = ReInit
UISunriseFoundationPopUpPanelView.ShowCells = ShowCells
UISunriseFoundationPopUpPanelView.ClearScroll = ClearScroll
UISunriseFoundationPopUpPanelView.OnCreateCell = OnCreateCell
UISunriseFoundationPopUpPanelView.OnDeleteCell = OnDeleteCell
UISunriseFoundationPopUpPanelView.OnBuyClick = OnBuyClick
UISunriseFoundationPopUpPanelView.OnEnable = OnEnable
UISunriseFoundationPopUpPanelView.OnDisable = OnDisable
UISunriseFoundationPopUpPanelView.ComponentDestroy = ComponentDestroy
UISunriseFoundationPopUpPanelView.OnCreateCell2 = OnCreateCell2
UISunriseFoundationPopUpPanelView.OnDeleteCell2 = OnDeleteCell2
return UISunriseFoundationPopUpPanelView
