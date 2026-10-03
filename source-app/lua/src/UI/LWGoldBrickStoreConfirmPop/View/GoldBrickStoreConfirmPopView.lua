local GoldBrickStoreConfirmPopView = BaseClass("GoldBrickStoreConfirmPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

function GoldBrickStoreConfirmPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GoldBrickStoreConfirmPopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GoldBrickStoreConfirmPopView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.imgIcon = self:AddComponent(UIImage, "icon")
  self.imgBrick = self:AddComponent(UIImage, "reward/brick")
  self.imgBrickJP = self:AddComponent(UIImage, "reward/brickJP")
  self.textNumberReward = self:AddComponent(UITextMeshProUGUIEx, "reward/numberReward")
  self.textTitleAdd = self:AddComponent(UITextMeshProUGUIEx, "Additional/titleAdd")
  self.imgAddIcon = self:AddComponent(UIImage, "Additional/reward/addIcon")
  self.imgAddIconJP = self:AddComponent(UIImage, "Additional/reward/addIconJP")
  self.textNumberAdd = self:AddComponent(UITextMeshProUGUIEx, "Additional/reward/numberAdd")
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.btnMinus = self:AddComponent(UIButton, "amount/minus")
  self.btnMinus:SetOnClick(function()
    self:OnBtnMinusClick()
  end)
  self.textNumber = self:AddComponent(UITextMeshProUGUIEx, "amount/number")
  self.btnPlus = self:AddComponent(UIButton, "amount/plus")
  self.btnPlus:SetOnClick(function()
    self:OnBtnPlusClick()
  end)
  self.btnBuy = self:AddComponent(UIButton, "LW_Btn_BuyGiftPackage/Btn")
  self.btnBuy:SetOnClick(function()
    self:OnBtnBuyClick()
  end)
  self.textPrice = self:AddComponent(UITextMeshProUGUIEx, "LW_Btn_BuyGiftPackage/Btn/PriceLayout/PriceText")
  self.btnClose = self:AddComponent(UIButton, "CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
end

function GoldBrickStoreConfirmPopView:ComponentDestroy()
  self.btnPanel = nil
  self.imgIcon = nil
  self.imgBrick = nil
  self.imgBrickJP = nil
  self.textNumberReward = nil
  self.textTitleAdd = nil
  self.imgAddIcon = nil
  self.imgAddIconJP = nil
  self.textNumberAdd = nil
  self.textDesc = nil
  self.btnMinus = nil
  self.textNumber = nil
  self.btnPlus = nil
  self.btnBuy = nil
  self.textPrice = nil
  self.btnClose = nil
end

function GoldBrickStoreConfirmPopView:DataDefine()
  self.token_lock = false
  local goods_id = self:GetUserData()
  self.data = WelfareController.GetGoldBrickItemById(goods_id)
  local icon_path = WelfareController.GetGoldBrickIcon(self.data)
  self.imgIcon:LoadSprite(icon_path)
  local showGoldDetail = DataCenter.PlayerInfoDataManager:CanShowGoldBrickDetail()
  self.imgBrick:SetActive(not showGoldDetail)
  self.imgBrickJP:SetActive(showGoldDetail)
  self.imgAddIcon:SetActive(not showGoldDetail)
  self.imgAddIconJP:SetActive(showGoldDetail)
  self.textNumberReward:SetText(self.data.pay_brick_num)
  self.textNumberAdd:SetText(self.data.free_brick_num)
  self.count = 1
  self.textNumber:SetText("1")
  self.textPrice:SetText(self.data.currency_symbol .. self.data.amount)
  self.textTitleAdd:SetLocalText("goldbrick_store_labeljp")
  self.textDesc:SetLocalText("goldbrick_store_choose")
end

function GoldBrickStoreConfirmPopView:DataDestroy()
  self.data = nil
  self.count = 0
  self.token_lock = false
end

function GoldBrickStoreConfirmPopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GoldBrickShopGetToken, self.OnGetToken)
end

function GoldBrickStoreConfirmPopView:OnRemoveListener()
  self:RemoveUIListener(EventId.GoldBrickShopGetToken, self.OnGetToken)
  base.OnRemoveListener(self)
end

function GoldBrickStoreConfirmPopView:OnGetToken(data)
  if self.token_lock then
    DataCenter.PayManager:PayPCGoldBrickStore(data, self.data, self.count)
    self.token_lock = false
    self.ctrl:CloseSelf()
  else
    Logger.LogError("Gold Brick Token is not locked or already used.")
  end
end

function GoldBrickStoreConfirmPopView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function GoldBrickStoreConfirmPopView:OnBtnMinusClick()
  if self.count > 1 then
    self.count = self.count - 1
    self.textNumber:SetText(tostring(self.count))
  end
end

function GoldBrickStoreConfirmPopView:OnBtnPlusClick()
  local total_max = WelfareController.GetGoldBrickBuyLimit()
  local target_number = self.count + 1
  local target_brick_num = target_number * self.data.pay_brick_num
  if total_max < target_brick_num then
    return
  end
  self.count = target_number
  self.textNumber:SetText(tostring(self.count))
end

function GoldBrickStoreConfirmPopView:OnBtnBuyClick()
  if self.token_lock then
    Logger.LogWarning("Gold Brick Token is already locked, please wait for the previous request to complete.")
    return
  end
  self.token_lock = true
  SFSNetwork.SendMessage(MsgDefines.GetGoldBrickToken)
end

function GoldBrickStoreConfirmPopView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return GoldBrickStoreConfirmPopView
