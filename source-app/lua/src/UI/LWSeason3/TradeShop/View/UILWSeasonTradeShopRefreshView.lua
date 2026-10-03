local UILWSeasonTradeShopRefreshView = BaseClass("UILWSeasonTradeShopRefreshView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIDynamicSkin = require("Framework.UI.Component.UIDynamicSkin")
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local desc_text_path = "PopUpTitle/Common_bg_orange2/DescText"
local btn_cancel_path = "PopUpTitle/Common_bg_orange2/BtnCancel"
local btn_confirm_path = "PopUpTitle/Common_bg_orange2/BtnConfirm"
local text_path = "PopUpTitle/Common_bg_orange2/BtnConfirm/Text"

function UILWSeasonTradeShopRefreshView:OnCreate()
  base.OnCreate(self)
  local tradeData = self:GetUserData()
  local shopRefreshNum = tradeData:GetShopRefreshNum()
  self.tradeId = tradeData.tradeId
  self.shopType = DataCenter.SeasonTradeShopDataManager:GetShopType()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.desc_text:SetLocalText("season_s3_trade_city018", shopRefreshNum)
  self.btn_cancel = self:AddComponent(UIButton, btn_cancel_path)
  self.btn_cancel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_confirm = self:AddComponent(UIButton, btn_confirm_path)
  self.btn_confirm:SetOnClick(BindCallback(self, self.OnConfirmBtnClick))
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.text:SetText(string.format([[
%s
%d/1]], Localization:GetString(GameDialogDefine.CONFIRM), shopRefreshNum))
  DataCenter.SeasonTradeDataManager:ChangeSkin(self:AddComponent(UIDynamicSkin, ""), true)
end

function UILWSeasonTradeShopRefreshView:OnDestroy()
  self.panel = nil
  self.close_btn = nil
  self.desc_text = nil
  self.btn_cancel = nil
  self.btn_confirm = nil
  self.text = nil
  base.OnDestroy(self)
end

function UILWSeasonTradeShopRefreshView:OnConfirmBtnClick()
  DataCenter.SeasonTradeShopDataManager:ReqTradeShopRefreshGoods(self.tradeId, self.shopType)
  self.ctrl:CloseSelf()
end

return UILWSeasonTradeShopRefreshView
