local UIBattlePassGiftPackagePopUp_CommonView = BaseClass("UIBattlePassGiftPackagePopUp_CommonView", UIBaseView)
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
local title4Text_path = "UIScrollPackContent/Title4"
local discount_path = "UIScrollPackContent/Discount"
local discountText_path = "UIScrollPackContent/Discount/DiscountText"
local dec1_path = "UIScrollPackContent/Dec1"
local dec2_path = "UIScrollPackContent/Dec2"
local dec3_path = "UIScrollPackContent/Dec3"
local common_bg_orange2_path = "UIScrollPackContent/Common_bg_orange2"
local common_bg_orange3_path = "UIScrollPackContent/Common_bg_orange3"
local bg1_path = "UIScrollPackContent/Bg1"
local bg2_path = "UIScrollPackContent/Bg2"
local common_bg_orange_path = "UIScrollPackContent/Common_bg_orange"
local common_bg_orange_config_path = "UIScrollPackContent/Common_bg_orange_config"

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
  self.title4Text = self:AddComponent(UIText, title4Text_path)
  self.title3Text:SetText("")
  self.title4Text:SetText("")
  self.discount = self:AddComponent(UIBaseContainer, discount_path)
  self.discountText = self:AddComponent(UIText, discountText_path)
  self.dec1 = self:AddComponent(UIRawImage, dec1_path)
  self.dec2 = self:AddComponent(UIImage, dec2_path)
  self.dec3 = self:AddComponent(UIImage, dec3_path)
  self.common_bg_orange2 = self:AddComponent(UIImage, common_bg_orange2_path)
  self.common_bg_orange3 = self:AddComponent(UIImage, common_bg_orange3_path)
  self.bg1 = self:AddComponent(UIImage, bg1_path)
  self.bg2 = self:AddComponent(UIImage, bg2_path)
  self.common_bg_orange = self:AddComponent(UIImage, common_bg_orange_path)
  self.common_bg_orange_config = self:AddComponent(UIImage, common_bg_orange_config_path)
  self.common_bg_orange_config:SetActive(false)
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
  self.common_bg_orange2 = nil
  self.common_bg_orange3 = nil
  self.bg1 = nil
  self.bg2 = nil
  self.common_bg_orange = nil
  self.common_bg_orange_config = nil
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
  self:AddUIListener(EventId.ActBattlePassRefresh, self.ReInit)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBattlePassRefresh, self.ReInit)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self.actId = self:GetUserData()
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(self.actId)
  if self.actData == nil then
    return
  end
  self.packageInfo = GiftPackageData.get(self.actData:GetExchangeId())
  if self.packageInfo then
    self.buy_btn:SetActive(true)
    local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
    self.buy_text:SetText(price)
    self.point_rect:RefreshPoint(self.packageInfo)
    self.title3Text:SetText(self.packageInfo:getNameText())
    self.title4Text:SetText(self.packageInfo:getNameText())
    if self.packageInfo:hasPercent() then
      self.discount:SetActive(true)
      self.discountText:SetText(string.format("%s%%", self.packageInfo:getPercent()))
    else
      self.discount:SetActive(false)
    end
  else
    self.buy_btn:SetActive(false)
    self.discount:SetActive(false)
    self.title3Text:SetText("")
    self.title4Text:SetText("")
  end
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  local oriFlag = false
  self.common_bg_orange:SetActive(true)
  self.common_bg_orange_config:SetActive(false)
  if actListData then
    self:RefreshCommonNode(actListData:GetShowConfigTemp())
  end
  self.dec1:SetActive(true)
  self.dec2:SetActive(true)
  self.dec3:SetActive(false)
  self.title3Text:SetActive(oriFlag)
  self.common_bg_orange2:SetActive(oriFlag)
  self.title4Text:SetActive(not oriFlag)
  self.common_bg_orange3:SetActive(not oriFlag)
  self:ShowCells()
end

local function ShowCells(self)
  self.rewardList = self.actData:CheckLvGetReward(1, 1, true)
  self.curRewardList = {}
  self.allRewardList = self.rewardList
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
    if self.packageInfo.tryShowBuyAlertCondition ~= nil then
      self.packageInfo:tryShowBuyAlertCondition(function()
        if self.packageInfo == nil then
          return
        end
        if self.actId == nil then
          return
        end
        DataCenter.PayManager:CallPayment(self.packageInfo, UIWindowNames.UIBattlePassGiftPackagePopUp_Common, nil, self.actId)
        self.ctrl:CloseSelf()
      end)
    else
      DataCenter.PayManager:CallPayment(self.packageInfo, UIWindowNames.UIBattlePassGiftPackagePopUp_Common, nil, self.actId)
      self.ctrl:CloseSelf()
    end
  end
end

local function RefreshCommonNode(self, showTemp)
  if not string.IsNullOrEmpty(showTemp.pic_spec3) then
    local picNameList = string.split(showTemp.pic_spec3, "|")
    local name1 = picNameList[1]
    if name1 and not string.IsNullOrEmpty(name1) then
      self.dec1:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.BPNewYearTextureEx, name1))
      self.dec1:SetNativeSize()
    end
    local name2 = picNameList[2]
    if name2 and not string.IsNullOrEmpty(name2) then
      self.dec2:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.BPNewYear, name2))
      self.dec2:SetNativeSize()
    end
    local name3 = picNameList[3]
    if name3 and not string.IsNullOrEmpty(name3) then
      self.common_bg_orange3:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.BPNewYear, name3))
    end
    local name4 = picNameList[4]
    if name4 and not string.IsNullOrEmpty(name4) then
      local color = string.string2array_i_oneSep(name4, ";")
      if #color == 4 then
        self.bg1:SetColorRGBA255(color[1], color[2], color[3], color[4])
        self.bg2:SetColorRGBA255(color[1], color[2], color[3], color[4])
      end
    end
    local name5 = picNameList[5]
    if name5 and not string.IsNullOrEmpty(name5) then
      self.common_bg_orange:SetActive(false)
      self.common_bg_orange_config:SetActive(true)
      self.common_bg_orange_config:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.BPNewYear, name5))
    end
  end
end

UIBattlePassGiftPackagePopUp_CommonView.OnCreate = OnCreate
UIBattlePassGiftPackagePopUp_CommonView.OnDestroy = OnDestroy
UIBattlePassGiftPackagePopUp_CommonView.ComponentDefine = ComponentDefine
UIBattlePassGiftPackagePopUp_CommonView.DataDefine = DataDefine
UIBattlePassGiftPackagePopUp_CommonView.DataDestroy = DataDestroy
UIBattlePassGiftPackagePopUp_CommonView.OnAddListener = OnAddListener
UIBattlePassGiftPackagePopUp_CommonView.OnRemoveListener = OnRemoveListener
UIBattlePassGiftPackagePopUp_CommonView.ReInit = ReInit
UIBattlePassGiftPackagePopUp_CommonView.ShowCells = ShowCells
UIBattlePassGiftPackagePopUp_CommonView.ClearScroll = ClearScroll
UIBattlePassGiftPackagePopUp_CommonView.OnCreateCell = OnCreateCell
UIBattlePassGiftPackagePopUp_CommonView.OnDeleteCell = OnDeleteCell
UIBattlePassGiftPackagePopUp_CommonView.OnBuyClick = OnBuyClick
UIBattlePassGiftPackagePopUp_CommonView.OnEnable = OnEnable
UIBattlePassGiftPackagePopUp_CommonView.OnDisable = OnDisable
UIBattlePassGiftPackagePopUp_CommonView.ComponentDestroy = ComponentDestroy
UIBattlePassGiftPackagePopUp_CommonView.OnCreateCell2 = OnCreateCell2
UIBattlePassGiftPackagePopUp_CommonView.OnDeleteCell2 = OnDeleteCell2
UIBattlePassGiftPackagePopUp_CommonView.RefreshCommonNode = RefreshCommonNode
return UIBattlePassGiftPackagePopUp_CommonView
