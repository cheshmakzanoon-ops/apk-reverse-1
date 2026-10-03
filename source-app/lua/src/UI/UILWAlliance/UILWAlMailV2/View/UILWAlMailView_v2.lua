local UILWAlMailView = BaseClass("UILWAlMailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AlPostEventLog = require("DataCenter.AllianceData.AlliancePostEventLog")
local close_btn_path = "Root/BottomBar/BtnBack"
local use_btn_path = "Root/BottomBar/ChangeBtn"
local use_btn_txt_path = "Root/BottomBar/ChangeBtn/CreateBtnTxt"
local use_btn_time_path = "Root/BottomBar/ChangeBtn/sendTime/TimeLayout/Time"
local use_btn_time_layout_path = "Root/BottomBar/ChangeBtn/sendTime"
local input_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/Content/InputField"
local titleInput_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/Title/titleInputField"
local UIGray = CS.UIGray
local content_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/Recipient/receiverSet/Content"
local item_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/Recipient/receiverSet/Item"
local content_close_keyboard_btn_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/Content/ContentCloseKeyboardBtn"
local close_keyboard_btn_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/CloseKeyboardBtn"
local maxCount = 3000
local Item = require("UI.UILWAlliance.UILWAlMailV2.Component.UILWAlMailItem_v2")
local list = {
  LWAlMemberRankType.R4,
  LWAlMemberRankType.R3,
  LWAlMemberRankType.R2,
  LWAlMemberRankType.R1
}
local ALLIANCE_MAIL_AUTO_SAVE_KEY = "ALLIANCE_MAIL_AUTO_SAVE_KEY"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitView()
end

local function OnDestroy(self)
  self:AutoSaveMail()
  self:ComponentDestroy()
  self:DeleteTimer()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function __CalcKeyboardHeight(height)
  local layer = UIManager:GetInstance():GetLayer(UILayer.Normal.Name)
  local uiFullHeight = layer.rectTransform.rect.height
  local keyboardHeight = uiFullHeight * height / Screen.height
  return keyboardHeight
end

local function ComponentDefine(self)
  self.titleInput = self:AddComponent(UIInput, titleInput_path)
  self.titleInput:SetOnValueChange(function(value)
    self:TitleIptOnValueChange(value)
  end)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSendBtnClick()
  end)
  self.input = self:AddComponent(UIInput, input_path)
  self.input:SetCharacterLimit(3000)
  self.input:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.input_text = self:AddComponent(UITextMeshProUGUIEx, input_path .. "/Text Area/Text")
  ChatInterface.SetEmojiTextProperty(self.input_text)
  self.mobileInputField = self.input.gameObject:GetComponent(typeof(CS.Mopsicus.Plugins.MobileInputField))
  self.mobileInputField2 = self.titleInput.gameObject:GetComponent(typeof(CS.Mopsicus.Plugins.MobileInputField))
  self.mobilId = self.mobileInputField:GetMobilId()
  self.mobileInputField:SetVisible(true)
  
  function self.OnShowKeyboard(mobilId, isShow, height)
    if isShow then
      local newHeight = __CalcKeyboardHeight(height) - 260
      self.input:SetOffsetMinXY(0, math.max(0, newHeight))
    else
      self.input:SetOffsetMinXY(0, 0)
    end
    self.contentCloseKeyboardBtn:SetActive(isShow)
  end
  
  if ChatInterface.GetMobilSupportMultiple() then
    self.mobileInputField.OnShowKeyboard = self.OnShowKeyboard
    self.mobileInputField2.OnShowKeyboard = self.OnShowKeyboard
  else
    CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = self.OnShowKeyboard
  end
  if CS.SDKManager.IS_UNITY_ANDROID() then
    self.mobileInputField:SetMaxLine(500)
  elseif CS.SDKManager.IS_UNITY_IOS() then
    self.mobileInputField:SetMaxLine(1)
  end
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
  self.createBtnTxt = self:AddComponent(UIText, use_btn_txt_path)
  self.timeText = self:AddComponent(UIText, use_btn_time_path)
  self.sendTextLayout = self:AddComponent(UIBaseContainer, use_btn_time_layout_path)
  self.listContent = self:AddComponent(UIBaseContainer, content_path)
  self.listItemPrefab = self.transform:Find(item_path).gameObject
  self.listItemPrefab:GameObjectCreatePool()
  self.btnCells = {}
  self.contentCloseKeyboardBtn = self:AddComponent(UIButton, content_close_keyboard_btn_path)
  self.contentCloseKeyboardBtn:SetActive(false)
  self.contentCloseKeyboardBtn:SetOnClick(function()
    self.mobileInputField:SetFocus(false)
  end)
  self.closeKeyboardBtn = self:AddComponent(UIButton, close_keyboard_btn_path)
  self.closeKeyboardBtn:SetOnClick(function()
    self.mobileInputField:SetFocus(false)
  end)
end

function UILWAlMailView:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, function()
      self:RefreshTime()
    end, self, false, false, false)
  end
  self.timer:Start()
end

function UILWAlMailView:DeleteTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function UILWAlMailView:RefreshTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if not self.sendTime then
    return
  end
  local time = self.sendTime - curTime
  if time <= 0 then
    self:DeleteTimer()
    self:RefreshSendBtn()
  end
  self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(self.sendTime - curTime))
end

function UILWAlMailView:RefreshSendBtn()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local cd = LuaEntry.DataConfig:TryGetNum("alliance_mail_config", "k2", 600)
  local sendTime = DataCenter.AllianceBaseDataManager:GetAllianceBaseData().sendMailTime
  self.sendTime = sendTime + cd * 1000
  if curTime < self.sendTime then
    self.createBtnTxt:SetActive(false)
    self.sendTextLayout:SetActive(true)
    UIGray.SetGray(self.use_btn.transform, true, false)
    self:AddTimer()
  else
    self.createBtnTxt:SetActive(true)
    self.sendTextLayout:SetActive(false)
    UIGray.SetGray(self.use_btn.transform, false, true)
    self:DeleteTimer()
  end
  self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(self.sendTime - curTime))
end

local function ComponentDestroy(self)
  self.use_btn = nil
  self.input = nil
  self.close_btn = nil
  self.listContent = nil
  self.listItemPrefab = nil
  self.btnCells = nil
  if ChatInterface.GetMobilSupportMultiple() then
    self.mobileInputField.OnShowKeyboard = nil
    self.mobileInputField2.OnShowKeyboard = nil
  else
    CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = nil
  end
  self.OnShowKeyboard = nil
end

local function InitView(self)
  self.inputValue = ""
  self.selectRank = {}
  self.titleInputValue = ""
  self.input:SetText("")
  self.titleInput:SetText("")
  self.mobileInputField:SetVisible(true)
  self.mobileInputField2:SetVisible(true)
  self:InitMailByDraft()
  self:RefreshContent()
  self:RefreshTime()
  self:RefreshSendBtn()
end

local function IptOnValueChange(self, value)
  local maxNum = maxCount
  if maxNum < #value then
    value = string.SubStr(value, 1, maxNum)
    self.input:SetText(value)
    return
  end
  self.inputValue = value
end

local function TitleIptOnValueChange(self, value)
  local maxNum = maxCount
  if maxNum < #value then
    value = string.SubStr(value, 1, maxNum)
    self.titleInput:SetText(value)
    return
  end
  self.titleInputValue = value
end

local function OnSendBtnClick(self)
  local selectList = {}
  for k, v in pairs(self.selectRank) do
    table.insert(selectList, k)
  end
  if #selectList == 0 then
    UIUtil.ShowTipsId(455142)
    return
  end
  self.titleInputValue = self.titleInput:GetText()
  if string.IsNullOrEmpty(self.titleInputValue) then
    UIUtil.ShowTipsId(455143)
    return
  end
  self.inputValue = self.input:GetText()
  if string.IsNullOrEmpty(self.inputValue) then
    UIUtil.ShowTipsId(455144)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.AlGroupMailSend, selectList, self.titleInputValue, self.inputValue)
  self:SaveMailDraft()
  self.ctrl:CloseSelf()
  AlPostEventLog.PostEventLog_Mail_Send(self.inputValue)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:AddUIListener(EventId.GF_window_closed, self.OnWindowClosed)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:RemoveUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  base.OnRemoveListener(self)
end

local function RefreshContent(self)
  self:ClearContent()
  self.listItemPrefab.gameObject:GameObjectRecycleAll()
  for k, v in ipairs(list) do
    local item = self.listItemPrefab:GameObjectSpawn(self.listContent.transform)
    item.name = "item" .. k
    local cell = self.listContent:AddComponent(Item, item.name)
    local beSelect = self.selectRank[v] ~= nil and true or false
    cell:SetData(v, beSelect)
    self.btnCells[v] = cell
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.listContent.rectTransform)
end

local function ClearContent(self)
  self.listContent:RemoveComponents(Item)
end

local function OnClickItem(self, type)
  if self.selectRank[type] == nil then
    self.selectRank[type] = 1
  else
    self.selectRank[type] = nil
  end
  local beSelect = self.selectRank[type] ~= nil and true or false
  self.btnCells[type]:SetData(type, beSelect)
end

function UILWAlMailView:InitMailByDraft()
  self.autoSave = true
  local data = self:GetMailDraft()
  self:SetTitleAndContent(data.title, data.content, data.selectRank)
end

function UILWAlMailView:SetTitleAndContent(title, content, selectRank)
  self.input:SetText(content)
  self.mobileInputField.Text = content
  self.titleInput:SetText(title)
  self.mobileInputField2.Text = title
  if selectRank then
    self.selectRank = selectRank
  end
end

function UILWAlMailView:GetTitleAndContent()
  return self.titleInput:GetText(), self.input:GetText(), self.selectRank
end

function UILWAlMailView:AutoSaveMail()
  if self.autoSave then
    self:SaveMailDraft(self:GetTitleAndContent())
  end
end

function UILWAlMailView:OnCloseBtnClick()
  local title, content, selectRank = self:GetTitleAndContent()
  if not (string.IsNullOrEmpty(title) and string.IsNullOrEmpty(content)) or next(selectRank) then
    UIUtil.ShowMessage(Localization:GetString("announcement_draft_tips"), 2, "btn_save", "announcement_draft_btn", function()
      self:SaveMailDraft(title, content, selectRank)
      self.ctrl:CloseSelf()
    end, function()
      self:SaveMailDraft()
      self.ctrl:CloseSelf()
    end)
  else
    self:SaveMailDraft()
    self.ctrl:CloseSelf()
  end
end

function UILWAlMailView:SaveMailDraft(title, content, selectRank)
  self.autoSave = false
  local selectList = {}
  if selectRank then
    for k, v in pairs(selectRank) do
      table.insert(selectList, tonumber(k))
    end
  end
  CommonUtil.PlayerPrefsSetTable(ALLIANCE_MAIL_AUTO_SAVE_KEY, {
    title = title or "",
    content = content or "",
    selectRank = selectList or {}
  })
end

function UILWAlMailView:GetMailDraft()
  local data = CommonUtil.PlayerPrefsGetTable(ALLIANCE_MAIL_AUTO_SAVE_KEY, {
    title = "",
    content = "",
    selectRank = {}
  })
  if data.selectRank then
    for k, v in pairs(data.selectRank) do
      self.selectRank[tonumber(v)] = 1
    end
    data.selectRank = self.selectRank
  end
  return data
end

local IgnoreWindowNames = {
  [UIWindowNames.UINoticeTips] = true,
  [UIWindowNames.UICommonMessageSpecialBar] = true,
  [UIWindowNames.UICommonSingleMsgBar] = true,
  [UIWindowNames.UICommonMessageBar] = true,
  [UIWindowNames.UICommonMessageBarOld] = true,
  [UIWindowNames.UIBattleMessageBar] = true
}

function UILWAlMailView:OnWindowOpened(windowName)
  if IgnoreWindowNames[windowName] then
    return
  end
  local config = UIManager:GetInstance():GetWindowConfig(windowName)
  if not config then
    return
  end
  if config.Layer ~= UILayer.Dialog and config.Layer ~= UILayer.Info then
    return
  end
  self.mobileInputField:SetVisible(false)
  self.mobileInputField2:SetVisible(false)
end

function UILWAlMailView:OnWindowClosed(windowName)
  if IgnoreWindowNames[windowName] then
    return
  end
  local config = UIManager:GetInstance():GetWindowConfig(windowName)
  if not config then
    return
  end
  if config.Layer ~= UILayer.Dialog and config.Layer ~= UILayer.Info then
    return
  end
  self.mobileInputField:SetVisible(true)
  self.mobileInputField2:SetVisible(true)
end

UILWAlMailView.OnCreate = OnCreate
UILWAlMailView.OnDestroy = OnDestroy
UILWAlMailView.InitView = InitView
UILWAlMailView.OnEnable = OnEnable
UILWAlMailView.OnDisable = OnDisable
UILWAlMailView.IptOnValueChange = IptOnValueChange
UILWAlMailView.TitleIptOnValueChange = TitleIptOnValueChange
UILWAlMailView.OnSendBtnClick = OnSendBtnClick
UILWAlMailView.OnAddListener = OnAddListener
UILWAlMailView.OnRemoveListener = OnRemoveListener
UILWAlMailView.RefreshContent = RefreshContent
UILWAlMailView.ClearContent = ClearContent
UILWAlMailView.ComponentDefine = ComponentDefine
UILWAlMailView.ComponentDestroy = ComponentDestroy
UILWAlMailView.OnClickItem = OnClickItem
return UILWAlMailView
