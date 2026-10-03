local UILWPlayerThumbsUpHistoryView = BaseClass("UILWPlayerThumbsUpHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWPlayerThumbsUpHistoryItem = require("UI.LWPlayerInfo.UILWPlayerThumbsUpHistory.Component.UILWPlayerThumbsUpHistoryItem")
local UILWPlayerThumbsUpHistoryTab = require("UI.LWPlayerInfo.UILWPlayerThumbsUpHistory.Component.UILWPlayerThumbsUpHistoryTab")
local LWUIGiftHistoryContentView = require("UI.LWPlayerInfo.UILWGiftSystem.GiftHistory.Component.LWUIGiftHistoryContentView")
local AssistanceHistoryContent = require("UI.LWPlayerInfo.UILWPlayerThumbsUpHistory.Component.AssistanceHistoryContent")
local SkillUseHistoryContent = require("UI.LWPlayerInfo.UILWPlayerThumbsUpHistory.Component.SkillUseHistoryContent")
local panel_path = "panel"
local close_btn_path = "Root/Common_img_title/CloseBtn"
local no_log_txt_path = "Root/MiddleContent/noLogTxt"
local scroll_view_path = "Root/MiddleContent/ScrollView"
local layoutTabs_path = "Root/TabsScrollView/Viewport/layoutTabs"
local assistance_history_content_path = "Root/AssistanceHistoryContent"
local skill_use_history_content_path = "Root/SkillUseHistoryContent"
local toggle_path = "Root/Toggle"
local switch_btn_path = "Root/Toggle/SwitchButton/SwitchBtn"
local slider_path = "Root/Toggle/SwitchButton/Slider"
local text_path = "Root/Toggle/Text"
local tabs_type = {
  thumbsUp = 1,
  gift = 2,
  assistance = 3,
  skillUse = 4
}
local content_path = {
  "Root/MiddleContent",
  "Root/LWUIGiftHistoryContent",
  "Root/AssistanceHistoryContent",
  "Root/SkillUseHistoryContent"
}
local tabs_path = {
  "Root/TabsScrollView/Viewport/layoutTabs/likeTab",
  "Root/TabsScrollView/Viewport/layoutTabs/giftTab",
  "Root/TabsScrollView/Viewport/layoutTabs/assistanceTab",
  "Root/TabsScrollView/Viewport/layoutTabs/skillUseTab"
}
local tabs_key = {
  "alliance_clap_hands_ui_3",
  "string_gifts",
  "record_page_tab_battle",
  "record_page_tab_skill"
}
local Tab2SettingType = {
  [tabs_type.thumbsUp] = UserSettingKey.BE_LIKED_UI_POP,
  [tabs_type.gift] = UserSettingKey.BE_GIFTED_UI_POP,
  [tabs_type.assistance] = UserSettingKey.BE_ASSISTED_UI_POP,
  [tabs_type.skillUse] = UserSettingKey.BE_GIVEN_VOCATIONAL_SKILLS_UI_POP
}
local loaclType = "friendCircle"

function UILWPlayerThumbsUpHistoryView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  if param and param.type then
    self.type = self:GetUserData().type
    self.roomId = self:GetUserData().roomId
  end
  self.dataList = {}
  self:ComponentDefine()
  if param and param.type then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.GetRoomLikeLog, self.roomId)
  else
    self:UpdateData()
    LuaEntry.Player:ResetThumbsUpInfo()
    SFSNetwork.SendMessage(MsgDefines.GetInteractiveHistory)
  end
end

function UILWPlayerThumbsUpHistoryView:OnDestroy()
  self.type = nil
  self.roomId = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPlayerThumbsUpHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshInteractiveHistory, self.UpdateData)
  self:AddUIListener(EventId.GetRoomLikeLogUpdate, self.UpdateData)
  self:AddUIListener(EventId.UserSettingChanged, self.RefreshToggle)
end

function UILWPlayerThumbsUpHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshInteractiveHistory, self.UpdateData)
  self:RemoveUIListener(EventId.GetRoomLikeLogUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.UserSettingChanged, self.RefreshToggle)
  base.OnRemoveListener(self)
end

function UILWPlayerThumbsUpHistoryView:ComponentDefine()
  self.toggle = self:AddComponent(UIBaseContainer, toggle_path)
  self.switch_btn = self:AddComponent(UIButton, switch_btn_path)
  self.switch_btn:SetOnClick(function()
    self:OnClickSwitchBtn()
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.text:SetLocalText("like_ui_setting01")
  self.content = self:AddComponent(LWUIGiftHistoryContentView, "Root/LWUIGiftHistoryContent")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.no_log_txt = self:AddComponent(UITextMeshProUGUIEx, no_log_txt_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.layoutTabs = self:AddComponent(UIBaseContainer, layoutTabs_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.tabComps = {}
  self.contentComps = {}
  self.selectTabIndex = 1
  for i, v in ipairs(content_path) do
    local comp = self:AddComponent(UICanvasGroup, v)
    comp:SetAlpha(self.selectTabIndex == i and 1 or 0)
    comp:SetBlocksRaycasts(self.selectTabIndex == i)
    table.insert(self.contentComps, comp)
  end
  for i, v in ipairs(tabs_path) do
    local tabComp = self:AddComponent(UILWPlayerThumbsUpHistoryTab, v)
    tabComp:SetData(i)
    tabComp:SetText(tabs_key[i], true)
    tabComp:SetIsOn(false)
    tabComp:SetOnClick(self.OnClickTab, self)
    if self.type == loaclType then
      tabComp:SetActive(i == tabs_type.thumbsUp)
    else
      tabComp:SetActive(true)
    end
    table.insert(self.tabComps, tabComp)
  end
  self:OnClickTab(self.tabComps[self.selectTabIndex])
  self:UpdateRedDot()
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.assistance_history_content = self:AddComponent(AssistanceHistoryContent, assistance_history_content_path)
  self.skill_use_history_content = self:AddComponent(SkillUseHistoryContent, skill_use_history_content_path)
end

function UILWPlayerThumbsUpHistoryView:ComponentDestroy()
  self:ClearScroll()
  self.close_btn = nil
  self.no_log_txt = nil
  self.scroll_view = nil
  self.content = nil
  self.assistance_history_content = nil
  self.skill_use_history_content = nil
  self.toggle = nil
  self.switch_btn = nil
  self.slider = nil
  self.text = nil
end

function UILWPlayerThumbsUpHistoryView:UpdateData(tempData)
  local dataCount = 0
  if self.type == loaclType then
    if tempData.roomId == self.roomId then
      self.dataList = tempData.logInfo or {}
      dataCount = #self.dataList
    end
  else
    local data = DataCenter.PlayerInfoDataManager:GetPlayerInteractiveHistory()
    if data ~= nil and data.receive ~= nil then
      local receive = data.receive
      self.dataList = receive
      dataCount = #receive
    end
  end
  if 0 < dataCount then
    self.no_log_txt:SetActive(false)
    self.ScrollView:SetActive(true)
    self.ScrollView:SetTotalCount(dataCount)
    self.ScrollView:RefillCells()
  else
    self.no_log_txt:SetActive(true)
    self.ScrollView:SetActive(false)
  end
end

function UILWPlayerThumbsUpHistoryView:GetRedDotCache()
  if self.redDotInfo then
    return self.redDotInfo
  end
  local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid)
  if info == nil then
    return
  end
  local redDotInfo = CommonUtil.PlayerPrefsGetTable("PLAYER_DETAIL_RED_DOT_INFO")
  if redDotInfo == nil then
    redDotInfo = {
      thumbsUpCount = info.thumbsUpCount or 0,
      newGiftCount = info.newGiftCount or 0
    }
    CommonUtil.PlayerPrefsSetTable("PLAYER_DETAIL_RED_DOT_INFO", redDotInfo)
  end
  self.redDotInfo = redDotInfo
  return redDotInfo
end

function UILWPlayerThumbsUpHistoryView:SetRedDotCache(redDotInfo)
  if not redDotInfo then
    return
  end
  CommonUtil.PlayerPrefsSetTable("PLAYER_DETAIL_RED_DOT_INFO", redDotInfo)
end

function UILWPlayerThumbsUpHistoryView:UpdateRedDot()
  local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid)
  local cache = self:GetRedDotCache()
  if info and cache then
    local newGiftCount = info.newGiftCount or 0
    if newGiftCount > toInt(cache.newGiftCount) then
      self.tabComps[tabs_type.gift]:SetReddotNumber(1)
    else
      self.tabComps[tabs_type.gift]:SetReddotNumber(0)
    end
    local thumbsUp = info.thumbsUpCount or 0
    if thumbsUp > toInt(cache.thumbsUpCount) then
      self.tabComps[tabs_type.thumbsUp]:SetReddotNumber(1)
    else
      self.tabComps[tabs_type.thumbsUp]:SetReddotNumber(0)
    end
  end
end

function UILWPlayerThumbsUpHistoryView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UILWPlayerThumbsUpHistoryItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.dataList[index])
  end
end

function UILWPlayerThumbsUpHistoryView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UILWPlayerThumbsUpHistoryItem)
end

function UILWPlayerThumbsUpHistoryView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UILWPlayerThumbsUpHistoryItem)
end

function UILWPlayerThumbsUpHistoryView:OnClickTab(tabComp)
  if tabComp.isOn then
    return
  end
  self.selectTabIndex = tabComp.data
  for i, comp in ipairs(self.tabComps) do
    comp:SetIsOn(self.selectTabIndex == comp.data)
  end
  for i, comp in ipairs(self.contentComps) do
    comp:SetAlpha(self.selectTabIndex == i and 1 or 0)
    comp:SetBlocksRaycasts(self.selectTabIndex == i)
  end
  if self.selectTabIndex == tabs_type.gift then
    local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid)
    if info then
      info.oldGiftCount = info.newGiftCount
    end
    local cache = self:GetRedDotCache()
    if cache and info then
      cache.newGiftCount = info.newGiftCount
    end
    self:SetRedDotCache(cache)
    self:UpdateRedDot()
  elseif self.selectTabIndex == tabs_type.thumbsUp then
    local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid)
    if info then
      info.thumbsUpCountDiff = 0
    end
    local cache = self:GetRedDotCache()
    if cache and info then
      cache.thumbsUpCount = info.thumbsUpCount
    end
    self:SetRedDotCache(cache)
    self:UpdateRedDot()
  end
  self:RefreshToggle()
end

function UILWPlayerThumbsUpHistoryView:RefreshToggle()
  local settingKey = Tab2SettingType[self.selectTabIndex]
  if not settingKey then
    self.toggle:SetActive(false)
    return
  end
  self.toggle:SetActive(true)
  local isOpen = LuaEntry.Player:GetUserSetting(settingKey) == "1"
  self.slider:SetValue(isOpen and 1 or 0)
end

function UILWPlayerThumbsUpHistoryView:OnClickSwitchBtn()
  local settingKey = Tab2SettingType[self.selectTabIndex]
  if not settingKey then
    return
  end
  local isOpen = LuaEntry.Player:GetUserSetting(settingKey) == "1"
  SFSNetwork.SendMessage(MsgDefines.UserSetting, settingKey, isOpen and "0" or "1")
end

return UILWPlayerThumbsUpHistoryView
