local UIChannelSettingView = BaseClass("UIChannelSettingView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local redDotOnpenKey = "CHATREDDOT_SETTING_OPEN"
local compBook = {
  {
    path = "curtain",
    name = "curtain",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "panel/btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "panel/txtTitle",
    name = "txtTitle",
    type = UIText,
    textKey = 280012
  },
  {
    path = "panel/content/btnNotification",
    name = "btnNotification",
    type = UIButton,
    onClick = function(self)
      self:OpenNotificationSettings()
    end
  },
  {
    path = "panel/content/btnLanguage",
    name = "btnLanguage",
    type = UIButton,
    onClick = function(self)
      self:OpenLanguageSettings()
    end
  },
  {
    path = "panel/content/btnBlockedList",
    name = "btnBlockedList",
    type = UIButton,
    onClick = function(self)
      self:OpenBlockedList()
    end
  },
  {
    path = "panel/content/btnDecoration",
    name = "btnDecoration",
    type = UIButton,
    onClick = function(self)
      self:OpenCustomDecoration()
    end
  },
  {
    path = "panel/content/btnNightMode",
    name = "btnNightMode",
    type = UIButton,
    onClick = function(self)
      self:SwitchNightMode()
    end
  },
  {
    path = "panel/content/btnGiftEffect",
    name = "btnGiftEffect",
    type = UIButton,
    onClick = function(self)
      self:SetGiftEffectEnabled()
    end
  },
  {
    path = "panel/content/btnRedDot",
    name = "btnRedDot",
    type = UIButton,
    onClick = function(self)
      self:OpenRedDotSetting()
    end
  },
  {
    path = "panel/content/btnCustomerService",
    name = "btnCustomerService",
    type = UIButton,
    onClick = function(self)
      self:OnCustomerServiceClick()
    end
  },
  {
    path = "panel/content/btnGiftEffect/icon",
    name = "imgGiftEffect",
    type = UIImage
  },
  {
    path = "panel/content/btnCustomerService/redDotService",
    name = "serviceRedDot",
    type = UIImage,
    active = false
  },
  {
    path = "panel/content/btnRedDot/redDotSettingRed",
    name = "redDotSettingDot",
    type = UIImage,
    active = false
  },
  {
    path = "panel/content/btnNotification/txtNotification",
    name = "txtNotification",
    type = UIText,
    textKey = 100646
  },
  {
    path = "panel/content/btnNotification/dotNotification",
    name = "dotNotification",
    type = UIImage,
    active = false
  },
  {
    path = "panel/content/btnLanguage/txtLanguage",
    name = "txtLanguage",
    type = UIText,
    textKey = "im_set_translate"
  },
  {
    path = "panel/content/btnBlockedList/txtBlockedList",
    name = "txtBlockedList",
    type = UIText,
    textKey = 280013
  },
  {
    path = "panel/content/btnDecoration/txtDecoration",
    name = "txtDecoration",
    type = UIText,
    textKey = 2900047
  },
  {
    path = "panel/content/btnNightMode/txtNightMode",
    name = "txtNightMode",
    type = UIText,
    textKey = "dark_mode"
  },
  {
    path = "panel/content/btnGiftEffect/txtGiftEffect",
    name = "txtGiftEffect",
    type = UIText
  },
  {
    path = "panel/WorldTimeBg/WorldTimeText",
    name = "worldTimeText",
    type = UIText
  }
}

function UIChannelSettingView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIChannelSettingView:RefreshTime()
  self.worldTimeText:SetText(self.worldText .. UITimeManager:GetInstance():TimeStampToTimeForServer(UITimeManager:GetInstance():GetServerTime()))
end

function UIChannelSettingView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UIPushSettingChange, self.RefreshRedPoints)
  self:AddUIListener(EventId.UpdateAIHelpRedPoint, self.RefreshCustomerServiceRedDot)
end

function UIChannelSettingView:OnRemoveListener()
  self:RemoveUIListener(EventId.UIPushSettingChange, self.RefreshRedPoints)
  self:RemoveUIListener(EventId.UpdateAIHelpRedPoint, self.RefreshCustomerServiceRedDot)
  base.OnRemoveListener(self)
end

function UIChannelSettingView:OpenRedDotSetting()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatRedDotSetting, {anim = true, hideTop = true})
  CommonUtil.PlayerPrefsSetBool(redDotOnpenKey, false)
  self.redDotSettingDot:SetActive(false)
end

function UIChannelSettingView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIChannelSettingView:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function UIChannelSettingView:OnDestroy()
  self:ComponentDestroy()
  self:DeleteTimer()
  base.OnDestroy(self)
end

function UIChannelSettingView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.worldText = Localization:GetString("800811") .. ": "
  self:RefreshTime()
  
  function self.timer_action()
    self:RefreshTime()
  end
  
  self:AddTimer()
  self:RefreshRedPoints()
  self:RefreshGiftEffectBtn()
  self:RefreshCustomerServiceRedDot()
  self.btnCustomerService:SetActive(ChatInterface.ServiceBubbleIsOpen())
  self.redDotSettingDot:SetActive(CommonUtil.PlayerPrefsGetBool(redDotOnpenKey, true))
end

function UIChannelSettingView:RefreshCustomerServiceRedDot()
  local customerServiceRed = DataCenter.LWCustomerServiceManager:GetCustomerServiceRedPointData()
  self.serviceRedDot:SetActive(customerServiceRed)
end

function UIChannelSettingView:OnCustomerServiceClick()
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
end

function UIChannelSettingView:RefreshRedPoints()
  self.dotNotification:SetActive(DataCenter.PushSettingsManager:HasNewPushUnread())
end

function UIChannelSettingView:RefreshGiftEffectBtn()
  local state = DataCenter.GiftSystemManager:GetGiftEffectState()
  self.txtGiftEffect:SetLocalText(state and "chat_set_animation_off" or "chat_set_animation_on")
  local icon = state and "ChatWindow/chat_set_animation_off" or "ChatWindow/chat_set_animation_on"
  self.imgGiftEffect:LoadSprite(ChatInterface.GetChatUIPath(icon))
end

function UIChannelSettingView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIChannelSettingView:OpenNotificationSettings()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPushSettings, {anim = true, hideTop = true})
end

function UIChannelSettingView:OpenLanguageSettings()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingLanguage, {anim = true, hideTop = true}, SettingType.ChatTranslateLanguage)
end

function UIChannelSettingView:OpenBlockedList()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingBlock, {anim = true, hideTop = true})
end

function UIChannelSettingView:OpenCustomDecoration()
  EventManager:GetInstance():Broadcast(EventId.UIDecorationMainViewOpen)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {anim = true})
end

function UIChannelSettingView:SwitchNightMode()
  local theme = ChatInterface.GetChatTheme()
  if theme ~= ChatUIThemeConfig.ChatMode.Normal then
    ChatInterface.SwitchChatTheme(ChatUIThemeConfig.ChatMode.Normal)
  else
    ChatInterface.SwitchChatTheme(ChatUIThemeConfig.ChatMode.Night)
  end
  GoToUtil.CloseAllWindows()
  UIUtil.ShowTipsId("dark_mode_switch_tips")
end

function UIChannelSettingView:SetGiftEffectEnabled()
  DataCenter.GiftSystemManager:SwitchGiftEffectState()
  self:RefreshGiftEffectBtn()
end

return UIChannelSettingView
