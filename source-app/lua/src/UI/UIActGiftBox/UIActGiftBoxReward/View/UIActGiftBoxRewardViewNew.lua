local UIActGiftBoxRewardViewNew = BaseClass("UIActGiftBoxRewardViewNew", UIBaseView)
local base = UIBaseView
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local UICommonOptionControl = require("UI.UICommonOptionControl.UICommonOptionControl")
local Localization = CS.GameEntry.Localization
local GiftBoxRewardDetailSubPanel = require("UI.UIActGiftBox.UIActGiftBoxReward.Component.GiftBoxRewardDetailSubPanel")
local GiftBoxGeneratePropsSubPanel = require("UI.UIActGiftBox.UIActGiftBoxReward.Component.GiftBoxGeneratePropsSubPanel")
local title_path = "PopUpTitle/Common_img_title/titleText"
local closeBtn_path = "PopUpTitle/CloseBtn"
local maskBtn_path = "panel"
local props_tab_path = "PopUpTitle/propsTab"
local boxes_tab_path = "PopUpTitle/boxesTab"
local boxes_panel_path = "PopUpTitle/boxesPanel"
local props_panel_path = "PopUpTitle/propsPanel"
local option_control_path = "PopUpTitle/optionControl"
local rate_rules_path = "PopUpTitle/rateRules"

function UIActGiftBoxRewardViewNew:OnCreate()
  PostEventLog.Track(PostEventLog.Defines.OpenGiftBoxRewardPreviewPanel, {})
  base.OnCreate(self)
  self.actId = self:GetUserData()
  self:ComponentDefine()
  self:ReInit()
end

function UIActGiftBoxRewardViewNew:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActGiftBoxRewardViewNew:ComponentDefine()
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtnN = self:AddComponent(UIButton, maskBtn_path)
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.title_text:SetLocalText("airdrop_supply_title1")
  self.props_tab = self:AddComponent(UICommonTab, props_tab_path)
  self.boxes_tab = self:AddComponent(UICommonTab, boxes_tab_path)
  self.boxes_panel = self:AddComponent(GiftBoxRewardDetailSubPanel, boxes_panel_path)
  self.props_panel = self:AddComponent(GiftBoxGeneratePropsSubPanel, props_panel_path)
  self.option_control = self:AddComponent(UICommonOptionControl, option_control_path)
  self.rate_rules = self:AddComponent(UITextMeshProUGUIEx, rate_rules_path)
end

function UIActGiftBoxRewardViewNew:ComponentDestroy()
  self.maskBtnN = nil
  self.title_text = nil
  self.closeBtnN = nil
  self.props_tab = nil
  self.boxes_tab = nil
  self.boxes_panel = nil
  self.props_panel = nil
  self.curTab = nil
  self.boxopen_id = nil
end

function UIActGiftBoxRewardViewNew:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActGiftBoxLotteryCount, self.OnRefresh)
end

function UIActGiftBoxRewardViewNew:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActGiftBoxLotteryCount, self.OnRefresh)
end

function UIActGiftBoxRewardViewNew:ReInit()
  if self.actId then
    SFSNetwork.SendMessage(MsgDefines.GetActivityGiftBoxLotteryCount, self.actId)
  end
  local propsTabParam = {}
  propsTabParam.tabId = 1
  propsTabParam.title = Localization:GetString("airdrop_supply_title2")
  propsTabParam.clickHandler = self.OnTabClick
  propsTabParam.containPanel = self.props_panel
  self.props_tab:ReInit(propsTabParam)
  self.props_tab:SetSelect(false)
  local boxesTabParam = {}
  boxesTabParam.tabId = 2
  boxesTabParam.title = Localization:GetString("airdrop_supply_title3")
  boxesTabParam.clickHandler = self.OnTabClick
  boxesTabParam.containPanel = self.boxes_panel
  self.boxes_tab:ReInit(boxesTabParam)
  self.boxes_tab:SetSelect(false)
  self:OnTabClick(self.props_tab)
  local optionParamList = self.ctrl:GetOptionParamList(self.actId)
  local param = {}
  param.defaultOptionId = DataCenter.ActGiftBoxData:GetCurActConfigId(self.actId)
  param.optionParamList = optionParamList
  param.optionClickHandler = self.OnOptionClick
  param.optionPrefabPath = UIAssets.GiftBoxOptionItem
  self.option_control:ReInit(param)
  local boxOpenConfig = DataCenter.ActGiftBoxData:GetBoxOpenConfigById(param.defaultOptionId)
  self.rate_rules:SetLocalText("airdrop_supply_desc13", Localization:GetString(boxOpenConfig.settings_name))
end

function UIActGiftBoxRewardViewNew:OnRefresh()
end

function UIActGiftBoxRewardViewNew:OnTabClick(tabItem)
  if self.curTab ~= nil then
    if self.curTab.tabId == tabItem.tabId then
      return
    else
      self.curTab:SetSelect(false)
    end
  end
  self.curTab = tabItem
  self.curTab:SetSelect(true)
  self.curTab.containPanel:ReInit(self.actId)
end

function UIActGiftBoxRewardViewNew:OnOptionClick(optionItem)
  Logger.Log("OnOptionClick  configId: " .. optionItem.tabId)
  local configId = optionItem.tabId
  local template = DataCenter.ActGiftBoxData:GetBoxOpenConfigById(configId)
  self.curTab.containPanel:Refresh(template.boxopen_id)
  self.boxopen_id = template.boxopen_id
end

return UIActGiftBoxRewardViewNew
