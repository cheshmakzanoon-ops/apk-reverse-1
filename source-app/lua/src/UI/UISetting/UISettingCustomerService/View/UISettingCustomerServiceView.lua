local UISettingCustomerServiceView = BaseClass("UISettingCustomerServiceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local close_btn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local customerService_btn_path = "Root/Content/CustomerServiceBtn"
local discordCommunity_btn_path = "Root/Content/DiscordCommunityBtn"
local customerService_redDot = "Root/Content/CustomerServiceBtn/RedPoint"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshCustomerServiceRedDot()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.txt_tile = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.customerService_btn = self:AddComponent(UIButton, customerService_btn_path)
  self.discordCommunity_btn = self:AddComponent(UIButton, discordCommunity_btn_path)
  self.customerService_redDot_img = self:AddComponent(UIImage, customerService_redDot)
  self.txt_tile:SetText(Localization:GetString("457608"))
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.customerService_btn:SetOnClick(function()
    local vip = DataCenter.VIPManager.vipinfo
    local id = "E006"
    if vip and vip.level then
      if vip.level <= 7 then
        id = "E006"
      elseif vip.level <= 12 then
        id = "E007"
      else
        id = "E008"
      end
    end
    CS.AIHelp.AIHelpProxy.Show(id, Localization:GetString("2700006"))
    DataCenter.LWCustomerServiceManager:CloseCustomerServiceRedPointData()
  end)
  self.discordCommunity_btn:SetOnClick(function()
    if Localization:GetLanguageName() == "ja" then
      CS.SDKManager.OpenURL("https://discord.gg/kDGB3jZBwT")
    else
      CS.SDKManager.OpenURL("https://discord.gg/lastwarsurvival")
    end
  end)
end

local function ComponentDestroy(self)
  self.txt_tile = nil
  self.close_btn = nil
  self.customerService_btn = nil
  self.discordCommunity_btn = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateAIHelpRedPoint, self.RefreshCustomerServiceRedDot)
end

local function OnRemoveListener(self)
  base.OnAddListener(self)
  self:RemoveUIListener(EventId.UpdateAIHelpRedPoint, self.RefreshCustomerServiceRedDot)
end

local function RefreshCustomerServiceRedDot(self)
  local show = DataCenter.LWCustomerServiceManager:GetCustomerServiceRedPointData()
  self.customerService_redDot_img:SetActive(show)
end

UISettingCustomerServiceView.OnCreate = OnCreate
UISettingCustomerServiceView.OnDestroy = OnDestroy
UISettingCustomerServiceView.ComponentDefine = ComponentDefine
UISettingCustomerServiceView.ComponentDestroy = ComponentDestroy
UISettingCustomerServiceView.OnAddListener = OnAddListener
UISettingCustomerServiceView.OnRemoveListener = OnRemoveListener
UISettingCustomerServiceView.RefreshCustomerServiceRedDot = RefreshCustomerServiceRedDot
return UISettingCustomerServiceView
