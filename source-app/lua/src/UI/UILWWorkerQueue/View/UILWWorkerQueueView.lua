local UILWWorkerQueueView = BaseClass("UILWWorkerQueueView", UIBaseView)
local base = UIBaseView
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local close_btn_path = "Panel"
local return_btn_path = "Root/Content/UICommonPopBg/CloseBtn"
local title_text_path = "Root/Content/TitleTxt"
local reminds_text_path_2 = "Root/Content/RemindsTxt2"
local contract_btn_path = "Root/Content/BtnLayout/PurchaseBtn"
local price_text_path = "Root/Content/BtnLayout/PurchaseBtn/price_text"
local discount_price_text_path = "Root/Content/BtnLayout/PurchaseBtn/discount_price_text"
local rent_btn_path = "Root/Content/BtnLayout/RentBtn"
local rent_btn_text_path = "Root/Content/BtnLayout/RentBtn/RentBtnText"
local rent_price_text_path = "Root/Content/BtnLayout/RentBtn/CostGroup/CostText"
local CONTRACT_TITLE_TXT = "2000365"
local CONTRACT_REMINDS_TXT_1 = "2000366"
local CONTRACT_REMINDS_TXT_2 = "2000367"
local giftPackPoint_path = "Root/Content/BtnLayout/PurchaseBtn/UIGiftPackagePoint"
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")

function UILWWorkerQueueView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.LWSoundManager:PlaySound(62267, false)
end

function UILWWorkerQueueView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWWorkerQueueView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.returnBtn = self:AddComponent(UIButton, return_btn_path)
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.buyBtn = self:AddComponent(LWBtnBuyRefundRemind, contract_btn_path)
  self.buyBtn:SetBuyClickAction(function()
    self:OnClickPurchase()
  end)
  self.rentBtn = self:AddComponent(UIButton, rent_btn_path)
  self.rentBtn:SetOnClick(function()
    self:OnRentBtnClick()
  end)
  self.rentBtnText = self:AddComponent(UIText, rent_btn_text_path)
  self.rentPriceText = self:AddComponent(UIText, rent_price_text_path)
  self.contractTitleTxt = self:AddComponent(UIText, title_text_path)
  self.contractRemindsTxt2 = self:AddComponent(UIText, reminds_text_path_2)
end

function UILWWorkerQueueView:ComponentDestroy()
  self.closeBtn = nil
  self.returnBtn = nil
  self.buyBtn = nil
  self.rentBtn = nil
  self.rentBtnText = nil
  self.rentPriceText = nil
  self.contractTitleTxt = nil
  self.contractRemindsTxt2 = nil
end

function UILWWorkerQueueView:DataDefine()
  self.pack = nil
end

function UILWWorkerQueueView:DataDestroy()
  self.queueId = nil
  self.pack = nil
end

function UILWWorkerQueueView:OnEnable()
  base.OnEnable(self)
  self.queueId = self:GetUserData()
  if self.queueId then
    self:ReInit()
  end
end

function UILWWorkerQueueView:OnDisable()
  base.OnDisable(self)
end

function UILWWorkerQueueView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshUIBuildQueue, self.OnBuildQueueUpdate)
end

function UILWWorkerQueueView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshUIBuildQueue, self.OnBuildQueueUpdate)
end

function UILWWorkerQueueView:OnBuildQueueUpdate()
  if not self.queueId then
    return
  end
  self.queueData = DataCenter.BuildQueueManager:GetQueueDataById(self.queueId)
  if not self.queueData then
    self.ctrl:CloseSelf()
    return
  end
  if self.queueData:IsOwned() then
    self.ctrl:CloseSelf()
    return
  end
  self:ReInit()
end

function UILWWorkerQueueView:ReInit()
  self.queueData = DataCenter.BuildQueueManager:GetQueueDataById(self.queueId)
  self.contractTitleTxt:SetLocalText("build_queue_tips_3", self.queueData.order)
  self.contractRemindsTxt2:SetLocalText("build_queue_tips_4", self.queueData.order)
  local pack = GiftPackageData.get(tostring(self.queueData.giftId))
  self.buyBtn:SetActive(false)
  if not table.IsNullOrEmpty(pack) then
    self.buyBtn:SetActive(true)
    self.pack = pack
    self.buyBtn:Init(pack)
    self.buyBtn:SetDiscountText(Localization:GetString("2000369"))
    self.buyBtn:RefreshPoint()
  end
  if self.queueData then
    local showRentBtn = false
    if self.queueData.rent_price > 0 and 0 < self.queueData.rent_time then
      if self.queueData:IsRentQueue() then
        showRentBtn = self.queueData:IsExpired()
      else
        showRentBtn = true
      end
    end
    if showRentBtn then
      self.rentBtn:SetActive(true)
      self.buyBtn:SetLocalPositionXYZ(171.8, 0, 0)
      self.rentBtnText:SetLocalText(2000422, self.queueData.rent_time / 60)
      self.rentPriceText:SetText(string.GetFormattedStr(self.queueData.rent_price))
    else
      self.rentBtn:SetActive(false)
      self.buyBtn:SetLocalPositionXYZ(0, 0, 0)
    end
  else
    self.rentBtn:SetActive(false)
    self.buyBtn:SetLocalPositionXYZ(0, 0, 0)
  end
end

function UILWWorkerQueueView:OnClickPurchase()
  if not self.queueData then
    return
  end
  if self.queueData:IsConstructing() and self.queueData:IsExpired() then
    UIUtil.ShowMessage(Localization:GetString("buy_buildingqueue_alert2"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.PayManager:BuyGift(self.pack)
      self.ctrl:CloseSelf()
    end, nil, nil, "100378")
  else
    DataCenter.PayManager:BuyGift(self.pack)
  end
end

function UILWWorkerQueueView:OnRentBtnClick()
  if not self.queueData then
    return
  end
  if self.queueData.rent_price > 0 and 0 < self.queueData.rent_time then
    if self.queueData:IsRentQueue() and not self.queueData:IsExpired() then
      return
    end
  else
    return
  end
  local have = LuaEntry.Player.gold
  local need = self.queueData.rent_price
  if have < need then
    GoToUtil.GotoPayTips(need)
  else
    SFSNetwork.SendMessage(MsgDefines.BuildQueueLease, self.queueId)
    self.ctrl:CloseSelf()
  end
end

return UILWWorkerQueueView
