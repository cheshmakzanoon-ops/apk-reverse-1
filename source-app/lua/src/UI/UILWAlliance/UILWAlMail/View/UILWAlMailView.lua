local UILWAlMailView = BaseClass("UILWAlMailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local use_btn_path = "ImgBg/changeBtn"
local input_path = "ImgBg/InputField"
local titleInput_path = "ImgBg/titleInputField"
local UIGray = CS.UIGray
local content_path = "ImgBg/receiverSet/Content"
local item_path = "ImgBg/receiverSet/Item"
local maxCount = 3000
local Item = require("UI.UILWAlliance.UILWAlMail.Component.UILWAlMailItem")
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

local function ComponentDefine(self)
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
  self.titleInput = self:AddComponent(UIInput, titleInput_path)
  self.titleInput:SetOnValueChange(function(value)
    self:TitleIptOnValueChange(value)
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
  self.createBtnTxt = self:AddComponent(UIText, "ImgBg/changeBtn/CreateBtnTxt")
  self.timeText = self:AddComponent(UIText, "ImgBg/changeBtn/sendTime/TimeLayout/Time")
  self.sendTextLayout = self:AddComponent(UIBaseContainer, "ImgBg/changeBtn/sendTime")
  self.listContent = self:AddComponent(UIBaseContainer, content_path)
  self.listItemPrefab = self.transform:Find(item_path).gameObject
  self.listItemPrefab:GameObjectCreatePool()
  self.btnCells = {}
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
  self.return_btn = nil
  self.listContent = nil
  self.listItemPrefab = nil
  self.btnCells = nil
end

local function InitView(self)
  self.inputValue = ""
  self.selectRank = {}
  self.titleInputValue = ""
  self.input:SetText("")
  self.titleInput:SetText("")
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
    self.titleInputValue = value
    return
  end
  self.inputValue = value
end

local function TitleIptOnValueChange(self, value)
  local maxNum = maxCount
  if maxNum < #value then
    value = string.SubStr(value, 1, maxNum)
    self.titleInput:SetText(value)
    self.titleInputValue = value
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
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
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
  self.titleInput:SetText(title)
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
