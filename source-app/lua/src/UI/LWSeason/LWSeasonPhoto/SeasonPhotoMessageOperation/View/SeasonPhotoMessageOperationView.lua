local SeasonPhotoMessageOperationView = BaseClass("SeasonPhotoMessageOperationView", UIBaseView)
local base = UIBaseView
local TranslateCache = {}
local SeasonPhotoOperationItem = require("UI.LWSeason.LWSeasonPhoto.Component.SeasonPhotoOperationItem")
local btn_copy_path = "BG/operationScrollView/Viewport/Content/1/Layout/Btn/btnCopy"
local btn_translate_path = "BG/operationScrollView/Viewport/Content/2/Layout/Btn/btnTranslate"
local btn_translate_all_path = "BG/operationScrollView/Viewport/Content/2/Layout/Btn/btnTranslateAll"
local btn_report_path = "BG/operationScrollView/Viewport/Content/3/Layout/Btn/btnReport"
local btn_close_path = "btnClose"
local report_path = "BG/operationScrollView/Viewport/Content/3"

function SeasonPhotoMessageOperationView:OnCreate()
  base.OnCreate(self)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.reportRoot = self:AddComponent(UIBaseContainer, report_path)
  self.btn_copy = self:AddComponent(UIButton, btn_copy_path)
  self.btn_translate = self:AddComponent(UIButton, btn_translate_path)
  self.btn_translate_all = self:AddComponent(UIButton, btn_translate_all_path)
  self.btn_report = self:AddComponent(UIButton, btn_report_path)
  self.btn_copy:SetOnClick(function()
    self:DoCopyOperator()
  end)
  self.btn_translate:SetOnClick(function()
    self:DoTranslateOperator()
  end)
  self.btn_translate_all:SetOnClick(function()
    self:DoTranslateAllOperator()
  end)
  self.btn_report:SetOnClick(function()
    self:DoReportOperator()
  end)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.param = self:GetUserData()
  self.data = self.param.data
  self.nodeActive = self.param.node
  self.season = self.param.season
  self.allianceId = self.param.allianceId
  self.uid = self.data.uid or self.data.ownerUid or self.data.Uid or self.data.tUid
  self.reportRoot:SetActive(self.uid ~= LuaEntry.Player.uid)
  self.emojiScrollView = self:AddComponent(UIScrollView, "BG/emojiScrollView")
  self.emojiScrollView:SetOnItemMoveIn(function(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.emojiScrollView:AddComponent(SeasonPhotoOperationItem, itemObj)
    self.emojis[index][1].index = index
    item:UpdateItemData(self.emojis[index], self.chatUserData, self.ctrl)
  end)
  self.emojiScrollView:SetOnItemMoveOut(function(itemObj, index)
    self.emojiScrollView:RemoveComponent(itemObj.name, SeasonPhotoOperationItem)
  end)
  self:ReInit()
end

function SeasonPhotoMessageOperationView:OnDestroy()
  self:ClearScrollView(self.emojiScrollView)
  self.emojiScrollView = nil
  self.reportRoot = nil
  self.btn_close = nil
  self.btn_copy = nil
  self.btn_translate = nil
  self.btn_translate_all = nil
  self.btn_report = nil
  base.OnDestroy(self)
end

function SeasonPhotoMessageOperationView:ReInit()
  self.chatUserData = self:GetUserData()
  self.emojis = self.ctrl:GetEmojis()
  self:HideEmojis()
  self:ShowScrollView(self.emojiScrollView, self.emojis)
  self.emojiScrollView:SetActive(true)
end

function SeasonPhotoMessageOperationView:ShowScrollView(scrollView, datas)
  local count = #datas
  self:ClearScrollView(scrollView)
  scrollView:SetTotalCount(count)
  if 0 < count then
    scrollView:RefillCells()
  end
end

function SeasonPhotoMessageOperationView:ClearScrollView(scrollView)
  if not scrollView then
    return
  end
  scrollView:ClearCells()
  scrollView:RemoveComponents(SeasonPhotoOperationItem)
end

function SeasonPhotoMessageOperationView:HideEmojis()
  local showEmojisList = {}
  for i = 1, #self.emojis do
    local singleBtnGroup = {}
    for j = 1, #self.emojis[i] do
      local emojiCfg = self.emojis[i][j]
      if emojiCfg.IsHideEmoji == nil or not emojiCfg.IsHideEmoji() then
        table.insert(singleBtnGroup, emojiCfg)
      end
    end
    if 0 < #singleBtnGroup then
      table.insert(showEmojisList, singleBtnGroup)
    end
  end
  self.emojis = showEmojisList
end

function SeasonPhotoMessageOperationView:DoCopyOperator()
  if self.data ~= nil and self.data.message ~= nil and self.data.message ~= "" then
    CommonUtil.CopyTextToClipboard(self.data.message)
    UIUtil.ShowTipsId(128031)
    self.ctrl:CloseSelf()
  end
end

function SeasonPhotoMessageOperationView:DoTranslateOperator()
  if self.nodeActive and type(self.nodeActive.DoTranslate) == "function" then
    self.nodeActive:DoTranslate()
  elseif self.data ~= nil and self.data.message ~= nil and self.data.message ~= "" then
    self:DoTranslate(self.data)
  end
  self.ctrl:CloseSelf()
end

function SeasonPhotoMessageOperationView:DoTranslateAllOperator()
  local isOpen = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
  if not isOpen then
    UIUtil.ShowTipsId("full_page_translation_notice")
    return
  end
  local data = DataCenter.SeasonPhotoManager:GetCommentData(self.season, self.allianceId)
  if data ~= nil then
    PostEventLog.Track(PostEventLog.Defines.FULL_PAGE_TRANSLATION)
    for k, v in ipairs(data) do
      self:DoTranslate(v)
    end
  end
  self.ctrl:CloseSelf()
end

function SeasonPhotoMessageOperationView:DoReportOperator()
  local isLvEnough = ChatManager2:GetInstance():CheckMainLvEnough()
  if not isLvEnough then
    UIUtil.ShowTipsId(208256)
    return
  end
  if self.data ~= nil and self.data.message ~= nil and self.data.message ~= "" then
    local key = "SeasonPhotoMessageOperation" .. self.data.uid
    local cache = DataCenter.ActivityListDataManager:GetExtraData(key, {})
    if cache then
      for k, v in ipairs(cache) do
        if v == self.data.message then
          UIUtil.ShowTipsId(280064)
          return
        end
      end
    end
  end
  local param = {
    type = ReportType.SeasonAlliancePhotoMessage,
    allianceId = self.allianceId,
    season = self.season,
    name = self.data.name or "",
    msg = self.data.message,
    uid = self.data.uid or self.data.ownerUid or self.data.Uid or self.data.tUid
  }
  if param.uid ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReportSpecificType, {anim = true}, param)
  else
    UIUtil.ShowTipsId(208250)
  end
  self.ctrl:CloseSelf()
end

function SeasonPhotoMessageOperationView:DoTranslate(_data)
  if _data == nil or _data.message == nil or _data.message == "" then
    return
  end
  local theData = _data
  local msg = _data.message
  if not string.IsNullOrEmpty(msg) then
    local userLang = CS.GameEntry.Localization:GetLanguage()
    ChatManager2:GetInstance().Translate:Translate(msg, "", "", function(ok, data)
      if data ~= nil and ok == true and theData ~= nil and not string.IsNullOrEmpty(data.translateMsg) then
        theData.messageTranslate = data.translateMsg
        TranslateCache[msg] = data.translateMsg
        EventManager:GetInstance():Broadcast(EventId.SeasonPhotoTranslateRefresh, data)
      end
    end, userLang, nil)
  end
end

return SeasonPhotoMessageOperationView
