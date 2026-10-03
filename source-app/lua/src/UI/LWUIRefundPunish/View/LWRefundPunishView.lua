local LWRefundPunishView = BaseClass("LWRefundPunishView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWRefundPenaltyContentItem = require("UI.LWUIRefundPunish.Component.LWRefundPenaltyContentItem")
local LWRefundRepayContentItem = require("UI.LWUIRefundPunish.Component.LWRefundRepayContentItem")
local M = LWRefundPunishView
local TabType = {Penalty = 1, Repayment = 2}
local Setting = CS.GameEntry.Setting

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compPenaltyContent = self:AddComponent(LWRefundPenaltyContentItem, "Root/MiddleContent/LWRefundPenaltyContent")
  self.compRepayContent = self:AddComponent(LWRefundRepayContentItem, "Root/MiddleContent/LWRefundRepayContent")
  self.toggleTabItemPenalty = self:AddComponent(UIToggle, "Root/TabHolder/TabContent/TabItemPenalty")
  self.compTabItemPenaltySelect = self:AddComponent(UIBaseContainer, "Root/TabHolder/TabContent/TabItemPenalty/TabItemPenaltySelect")
  self.compTabItemPenaltyUnSelect = self:AddComponent(UIBaseContainer, "Root/TabHolder/TabContent/TabItemPenalty/TabItemPenaltyUnSelect")
  self.textTabItemPenalty = self:AddComponent(UITextMeshProUGUIEx, "Root/TabHolder/TabContent/TabItemPenalty/TabItemPenaltyText")
  self.compTabItemRepaymentSelect = self:AddComponent(UIBaseContainer, "Root/TabHolder/TabContent/TabItemRepayment/TabItemRepaymentSelect")
  self.compTabItemRepaymentUnSelect = self:AddComponent(UIBaseContainer, "Root/TabHolder/TabContent/TabItemRepayment/TabItemRepaymentUnSelect")
  self.textTabItemRepayment = self:AddComponent(UITextMeshProUGUIEx, "Root/TabHolder/TabContent/TabItemRepayment/TabItemRepaymentText")
  self.toggleTabItemRepayment = self:AddComponent(UIToggle, "Root/TabHolder/TabContent/TabItemRepayment")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/Title")
  self.btnNewGame = self:AddComponent(UIButton, "Root/BtnNode/NewGameBtn")
  self.btnNewGame:SetOnClick(function()
    self:OnBtnNewGameClick()
  end)
  self.textNewGameBtn = self:AddComponent(UITextMeshProUGUIEx, "Root/BtnNode/NewGameBtn/LW_Btn_Common_New_Base/NewGameBtnText")
  self.btnExit = self:AddComponent(UIButton, "Root/BtnNode/ExitBtn")
  self.btnExit:SetOnClick(function()
    self:OnBtnExitClick()
  end)
  self.textExitBtn = self:AddComponent(UITextMeshProUGUIEx, "Root/BtnNode/ExitBtn/LW_Btn_Common_New_Base/ExitBtnText")
  self.closeBtn = self:AddComponent(UIButton, "Root/CloseBtn")
  self.closeBtn:SetOnClick(function()
    self:OnBtnExitClick()
  end)
  self.bg = self:AddComponent(UIBaseContainer, "Root/bg")
  self.ai_help_btn = self:AddComponent(UIButton, "Root/BtnNode/AiHelpBtn")
  self.ai_help_btn:SetOnClick(function()
    self:OnAIHelpBtnClick()
  end)
  self.toggleTabItemPenalty:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(TabType.Penalty)
    end
  end)
  self.toggleTabItemRepayment:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(TabType.Repayment)
    end
  end)
end

function M:ComponentDestroy()
  self.btnPanel = nil
  self.compLWRefundPenaltyContent = nil
  self.compLWRefundRepayContent = nil
  self.toggleTabItemPenalty = nil
  self.compTabItemPenaltySelect = nil
  self.compTabItemPenaltyUnSelect = nil
  self.textTabItemPenalty = nil
  self.compTabItemRepaymentSelect = nil
  self.compTabItemRepaymentUnSelect = nil
  self.textTabItemRepayment = nil
  self.toggleTabItemRepayment = nil
  self.textTitle = nil
  self.btnNewGame = nil
  self.textNewGameBtn = nil
  self.btnExit = nil
  self.textExitBtn = nil
  self.closeBtn = nil
  self.bg = nil
end

function M:DataDefine()
end

function M:DataDestroy()
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWRefundOpenPayItem, self.OnRecOpenPay)
  self:AddUIListener(EventId.GoldBrickUpdate, self.OnGoldBrickUpdate)
  self:AddUIListener(EventId.GoldBrickShopGetData, self.OnRecGoldBrickShopData)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.LWRefundOpenPayItem, self.OnRecOpenPay)
  self:RemoveUIListener(EventId.GoldBrickUpdate, self.OnGoldBrickUpdate)
  self:RemoveUIListener(EventId.GoldBrickShopGetData, self.OnRecGoldBrickShopData)
  base.OnRemoveListener(self)
end

function M:InitView()
  self.curChannel = TabType.Penalty
  self:SetLocalization()
  self.compPenaltyContent:ReInit()
  self.compRepayContent:ReInit()
  self:OnTabChanged(self.curChannel)
  local canLogIn = DataCenter.LWRefundPunishManager:GetCanLogIn()
  self.btnNewGame:SetActive(not Config.IsPC() and not canLogIn)
  self.btnExit:SetActive(not canLogIn)
  self.closeBtn:SetActive(canLogIn)
  if Config.IsPC() or WelfareController.IsShowGoldBrickStoreRegion() then
    SFSNetwork.SendMessage(MsgDefines.GetGoldBrickInfo)
  end
end

function M:OnBtnPanelClick()
  self.ctrl:CloseSelf()
  local canLogIn = DataCenter.LWRefundPunishManager:GetCanLogIn()
  if not canLogIn then
    CS.ApplicationLaunch.Instance:Quit()
  end
end

function M:SetLocalization()
  self.textTitle:SetLocalText("refund_window_limit_subject")
  self.textTabItemPenalty:SetLocalText("refund_window_limit_tab1")
  self.textTabItemRepayment:SetLocalText("refund_window_limit_tab2")
  self.textExitBtn:SetLocalText("refund_window_limit_quit")
  self.textNewGameBtn:SetLocalText("refund_window_limit_restart")
end

function M:OnTabChanged(tab)
  self.compTabItemPenaltySelect:SetActive(tab == TabType.Penalty)
  self.compTabItemPenaltyUnSelect:SetActive(tab == TabType.Repayment)
  self.compTabItemRepaymentSelect:SetActive(tab == TabType.Repayment)
  self.compTabItemRepaymentUnSelect:SetActive(tab == TabType.Penalty)
  self.curChannel = tab
  self.compPenaltyContent:SetActive(tab == TabType.Penalty)
  self.compRepayContent:SetActive(tab == TabType.Repayment)
end

function M:OnRecOpenPay()
  self.curChannel = TabType.Repayment
  self:OnTabChanged(self.curChannel)
end

function M:OnBtnNewGameClick()
  self.ctrl:CloseSelf()
  CS.AccountCredentialManager.ClearAll()
  CS.ApplicationLaunch.Instance:ReloadGame()
end

function M:OnBtnExitClick()
  self.ctrl:CloseSelf()
  local canLogIn = DataCenter.LWRefundPunishManager:GetCanLogIn()
  if not canLogIn then
    CS.ApplicationLaunch.Instance:Quit()
  end
end

function M:OnAIHelpBtnClick()
  CS.AIHelp.AIHelpProxy.Show("E003", Localization:GetString("2700006"))
end

function M:OnGoldBrickUpdate()
  local goldBrickCount = DataCenter.GoldBrickDataManager:GetGoldBrickCount() or 0
  if goldBrickCount and 0 < goldBrickCount then
    self.ctrl:CloseSelf()
  end
end

function M:OnRecGoldBrickShopData()
  self.compRepayContent:OnRecGoldBrickShopData()
end

return LWRefundPunishView
