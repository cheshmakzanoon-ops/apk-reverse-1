local base = UIBaseContainer
local SeasonPhotoMessageItem = BaseClass("SeasonPhotoMessageItem", base)
local SeasonPhotoEmojiItem = require("UI.LWSeason.LWSeasonPhoto.Component.SeasonPhotoEmojiItem")
local Localization = CS.GameEntry.Localization
local TranslateCache = {}
local root_path = "Root"
local Head_path = "Root/player"
local TextName_path = "Root/TextName"
local TextMessage_path = "Root/TextMessage"
local TextTime_path = "Root/TextTime"
local BtnEditor_path = "Root/BtnsList/BtnEditor"
local BtnDelete_path = "Root/BtnsList/BtnDelete"
local line_path = "Root/Line"
local line_trans_path = "Root/lineTrans"
local text_trans_path = "Root/TextTrans"
local translate_root_path = "Root/BtnsList/TranslateRoot"
local translating_path = "Root/BtnsList/TranslateRoot/Translating"
local translate_finish_img_path = "Root/BtnsList/TranslateRoot/TranslateFinishImg"
local translate_btn_path = "Root/BtnsList/TranslateRoot/TranslateBtn"
local translate_refresh_btn_path = "Root/BtnsList/TranslateRoot/TranslateRefreshBtn"
local emoji_like_layout = "Root/EmojiLikeLayout"
local emoji_like_item = "Root/EmojiLikeLayout/EmojiLikeItem"
local more_btn_path = "Root/TextTime/MoreBtn"
local more_btn_txt_path = "Root/TextTime/MoreBtn/MoreBtnText"
local maxWidth = 555
local minHeight = 320

function SeasonPhotoMessageItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonPhotoMessageItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonPhotoMessageItem:OnEnable()
  base.OnEnable(self)
end

function SeasonPhotoMessageItem:OnDisable()
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  base.OnDisable(self)
end

function SeasonPhotoMessageItem:ComponentDefine()
  self.root = self:AddComponent(UIButton, root_path)
  self.season_photo_message_item = self:AddComponent(UILayoutElement, "")
  self.Head = self:AddComponent(UIBaseContainer, Head_path)
  self.TextName = self:AddComponent(UIText, TextName_path)
  self.TextMessage = self:AddComponent(UIText, TextMessage_path)
  self.TextTime = self:AddComponent(UIText, TextTime_path)
  self.BtnEditor = self:AddComponent(UIButton, BtnEditor_path)
  self.BtnDelete = self:AddComponent(UIButton, BtnDelete_path)
  self.canvas = self:AddComponent(UICanvasGroup, "")
  self.line = self:AddComponent(UIImage, line_path)
  self.line_trans = self:AddComponent(UIImage, line_trans_path)
  self.text_trans = self:AddComponent(UITextMeshProUGUIEx, text_trans_path)
  self.translate_root = self:AddComponent(UIBaseContainer, translate_root_path)
  self.translating = self:AddComponent(UIImage, translating_path)
  self.translate_finish_img = self:AddComponent(UIImage, translate_finish_img_path)
  self.translate_btn = self:AddComponent(UIButton, translate_btn_path)
  self.translate_refresh_btn = self:AddComponent(UIButton, translate_refresh_btn_path)
  self._moreBtn = self:AddComponent(UIButton, more_btn_path)
  self._moreBtnText = self:AddComponent(UIText, more_btn_txt_path)
  self._moreBtnText:SetColor(ChatUIThemeConfig.MoreBtnColor[ChatInterface.GetChatTheme()])
  self._moreBtn:SetOnClick(BindCallback(self, self.OnFoldClick))
  self.HeadItem = self:AddComponent(UICommonHead, Head_path)
  self.BtnEditor:SetOnClick(BindCallback(self, self.EditMessage))
  self.BtnDelete:SetOnClick(BindCallback(self, self.DeleteMessage))
  self.line_trans:SetActive(false)
  self.text_trans:SetActive(false)
  self.translate_root:SetActive(true)
  self.translate_refresh_btn:SetActive(false)
  self.translate_btn:SetOnClick(function()
    self:DoTranslate()
  end)
  self.root:SetOnClick(function()
    self:ShowChatOperator()
  end)
  self.emoji_like_layout = self:AddComponent(UIBaseContainer, emoji_like_layout)
  self.emoji_like_item = self:AddComponent(UIBaseContainer, emoji_like_item)
  self.emoji_like_item.gameObject:GameObjectCreatePool()
  self.gridLayoutGroupEmoji = self:AddComponent(UIGridLayoutGroup, emoji_like_layout)
end

function SeasonPhotoMessageItem:ComponentDestroy()
  if self.emoji_like_layout then
    self.emoji_like_layout:RemoveComponents(SeasonPhotoEmojiItem)
  end
  if self.emoji_like_item then
    self.emoji_like_item.gameObject:GameObjectRecycleAll()
  end
  self.root = nil
  self.Head = nil
  self.TextName = nil
  self.TextMessage = nil
  self.TextTime = nil
  self.BtnEditor = nil
  self.BtnDelete = nil
  self.line_trans = nil
  self.text_trans = nil
  self.translate_root = nil
  self.translating = nil
  self.translate_finish_img = nil
  self.translate_btn = nil
  self.translate_refresh_btn = nil
  self.season_photo_message_item = nil
end

function SeasonPhotoMessageItem:OnAddListener()
  base.OnAddListener(self)
end

function SeasonPhotoMessageItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonPhotoMessageItem:ReInit(index, data, season, allianceId, canEdit, rootView)
  local msg = data.message
  self.sizeChanged = false
  self.index = index
  self.data = data
  self.season = season
  self.allianceId = allianceId
  self.rootView = rootView
  self.HeadItem:ParseHeadInfo(data)
  self.HeadItem:SetEnableClickShowInfo(true, true)
  self.TextName:SetText(data.name)
  self.TextTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.refreshTime))
  self.line:SetActive(1 < index)
  if msg ~= nil and msg ~= "" then
    self.TextMessage:SetText(msg)
    local translateMsg = data.messageTranslate or TranslateCache[msg]
    if string.IsNullOrEmpty(translateMsg) then
      self.line_trans:SetActive(false)
      self.text_trans:SetActive(false)
      self.translating:SetActive(false)
      self.translate_finish_img:SetActive(false)
      self.translate_btn:SetActive(true)
    else
      self.line_trans:SetActive(true)
      self.text_trans:SetActive(true)
      self.text_trans:SetText(translateMsg)
      self.translating:SetActive(false)
      self.translate_finish_img:SetActive(true)
      self.translate_btn:SetActive(false)
    end
  else
    self.line_trans:SetActive(false)
    self.text_trans:SetActive(false)
    self.translating:SetActive(false)
    self.translate_finish_img:SetActive(false)
    self.translate_btn:SetActive(true)
    self.TextMessage:SetText("")
  end
  if canEdit then
    if data.uid == LuaEntry.Player.uid then
      self.BtnEditor:SetActive(true)
      self.BtnDelete:SetActive(false)
    else
      self.BtnEditor:SetActive(false)
      self.BtnDelete:SetActive(DataCenter.AllianceBaseDataManager:IsR4orR5())
    end
  else
    self.BtnEditor:SetActive(false)
    self.BtnDelete:SetActive(false)
  end
  self:UpdateChatDataEmoji(data)
  if not data.isTextFolding then
    data.isTextFolding = true
  end
  self.isTextFolding = data.isTextFolding
  self:TryFoldText()
  self:UpdateTextFoldState()
  self:UpdateLayout()
end

function SeasonPhotoMessageItem:UpdateLayout()
  if self.data.message and self.TextMessage.activeSelf then
    if self.isShowReadMore and self.isTextFolding then
      self.TextMessage.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, minHeight)
    else
      local preferredValues = self.TextMessage.unity_tmpro:GetPreferredValues(maxWidth, 0)
      self.TextMessage.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, preferredValues.y)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.text_trans.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.TextMessage.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.rectTransform)
  if not self.sizeChanged then
    local sizeW1, sizeH1 = self:GetSizeDeltaXY()
    local sizeW2, sizeH2 = self.root:GetSizeDeltaXY()
    if sizeW1 ~= sizeW2 or sizeH1 ~= sizeH2 then
      sizeH2 = math.max(240, sizeH2)
      self:SetSizeDeltaXY(sizeW2, sizeH2)
      self.season_photo_message_item:SetMinHeight(sizeH2)
      self.season_photo_message_item:SetPreferredHeight(sizeH2)
    end
  end
end

function SeasonPhotoMessageItem:ShowFadeInEffect()
  if self.lastTimeStamp and UITimeManager:GetInstance():GetServerTime() - self.lastTimeStamp < 3000 then
    return
  end
  self.lastTimeStamp = UITimeManager:GetInstance():GetServerTime()
  self.tweenSeq = UIUtil.ShowListItemAnim(self.root, self.index, self.canvas)
end

function SeasonPhotoMessageItem:EditMessage()
  if not DataCenter.SeasonPhotoManager:CanEditPhoto(self.season, self.allianceId, true, true) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonPhotoMessage, {anim = true}, self.season, self.allianceId)
end

function SeasonPhotoMessageItem:DeleteMessage()
  if not DataCenter.SeasonPhotoManager:CanEditPhoto(self.season, self.allianceId, true, true) then
    return
  end
  UIUtil.ShowConfirmNew({
    contentText = CS.GameEntry.Localization:GetString("season_alliance_photo_UI_47"),
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        SFSNetwork.SendMessage(MsgDefines.SeasonPhotoCommentDelete, self.season, self.allianceId, self.data.uid)
      end
    }
  })
end

function SeasonPhotoMessageItem:DoTranslate()
  if self.data == nil or self.data.message == nil or self.data.message == "" or not string.IsNullOrEmpty(self.data.messageTranslate) then
    return
  end
  local msg = self.data.message
  if not string.IsNullOrEmpty(msg) then
    self.translating:SetActive(true)
    self.translate_finish_img:SetActive(false)
    self.translate_btn:SetActive(false)
    local userLang = CS.GameEntry.Localization:GetLanguage()
    ChatManager2:GetInstance().Translate:Translate(msg, "", "", function(ok, data)
      if data ~= nil and ok == true and self.data ~= nil and self.data.message == msg and not string.IsNullOrEmpty(data.translateMsg) then
        self.data.messageTranslate = data.translateMsg
        self.line_trans:SetActive(true)
        self.text_trans:SetActive(true)
        self.text_trans:SetText(data.translateMsg)
        self.translating:SetActive(false)
        self.translate_finish_img:SetActive(true)
        self.translate_btn:SetActive(false)
        if msg and TranslateCache[msg] == nil then
          TranslateCache[msg] = data.translateMsg
        end
        self.isTextFolding = true
        self:OnFoldClick()
      end
    end, userLang, nil)
  end
end

function SeasonPhotoMessageItem:Update100MS()
  if self.sizeChanged then
    local sizeW1, sizeH1 = self:GetSizeDeltaXY()
    local sizeW2, sizeH2 = self.root:GetSizeDeltaXY()
    if sizeW1 ~= sizeW2 or sizeH1 ~= sizeH2 then
      self:SetSizeDeltaXY(sizeW2, sizeH2)
      self.season_photo_message_item:SetMinHeight(sizeH2)
      self.season_photo_message_item:SetPreferredHeight(sizeH2)
      if self.rootView ~= nil then
        self.rootView:OnItemSizeChanged(self.index)
      end
      self.sizeChanged = false
    end
  end
end

function SeasonPhotoMessageItem:ShowChatOperator()
  if self.data == nil or self.data.message == nil or self.data.message == "" then
    return
  end
  local param = {
    index = self.index,
    data = self.data,
    season = self.season,
    allianceId = self.allianceId,
    node = self
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonPhotoMessageOperation, {anim = false}, param)
end

function SeasonPhotoMessageItem:LoadEmojis(emojis, data)
  self.items = {}
  for i = 1, #emojis do
    local item = self.emoji_like_item.gameObject:GameObjectSpawn(self.emoji_like_layout.transform)
    table.insert(self.items, item)
    item.name = "emoji_like_item" .. i
    item:SetActive(true)
    local obj = self.emoji_like_layout:AddComponent(SeasonPhotoEmojiItem, item.name)
    emojis[i].isMe = data:IsMyComment()
    obj:UpdateData(emojis[i], self)
  end
end

local emojiOffset = 30
local emojiLikeDefaultHeight = 79

function SeasonPhotoMessageItem:UpdateChatDataEmoji(data)
  local list = data and data:GetThumbsUpArray()
  self.hasUp = list and 0 < #list
  if self.emoji_like_layout and self.emoji_like_item then
    self.emoji_like_layout:RemoveComponents(SeasonPhotoEmojiItem)
    self.emoji_like_item.gameObject:GameObjectRecycleAll()
    self.emoji_like_layout:SetActive(self.hasUp)
    if self.hasUp then
      self:LoadEmojis(list, data)
      local offset = 0
      if self.remarkTimeText then
        offset = emojiOffset
      end
      self.emoji_like_layout:SetAnchoredPositionXY(self.emoji_like_layout:GetAnchoredPositionX(), emojiLikeDefaultHeight + offset)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.emoji_like_layout.rectTransform)
end

function SeasonPhotoMessageItem:OnClickEmoji(index)
  DataCenter.SeasonPhotoManager:SeasonPhotoThumbsUp(self.season, self.allianceId, self.data.uid, self.data.uuid, index)
end

function SeasonPhotoMessageItem:OnFoldClick()
  self.sizeChanged = true
  self.isTextFolding = not self.isTextFolding
  self.data.isTextFolding = self.isTextFolding
  self:TryFoldText()
  self:UpdateTextFoldState()
  self:UpdateLayout(true)
end

function SeasonPhotoMessageItem:TryFoldText()
  self.isShowReadMore = false
  local dialog = self.data.message
  if dialog and self.TextMessage.activeSelf then
    self.TextMessage.unity_tmpro:ForceMeshUpdate()
    local preferredValues = self.TextMessage.unity_tmpro:GetPreferredValues(maxWidth, 0)
    if preferredValues.y > minHeight then
      self.isShowReadMore = true
    end
  end
  if self.isShowReadMore then
    self._moreBtn:SetActive(true)
  else
    self._moreBtn:SetActive(false)
  end
end

function SeasonPhotoMessageItem:UpdateTextFoldState()
  if self.isTextFolding then
    self._moreBtnText:SetText(Localization:GetString("message_show_more"))
  else
    self._moreBtnText:SetText(Localization:GetString("message_show_less"))
  end
  if self.isShowReadMore then
    local sizeDelta = self.TextMessage:GetSizeDelta()
    local preferredValues = self._moreBtnText.unity_tmpro:GetPreferredValues()
    self.TextMessage.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, math.max(sizeDelta.x, preferredValues.x))
  end
  if self.isTextFolding and self.isShowReadMore then
    self.line_trans:SetActive(false)
    self.text_trans:SetActive(false)
  elseif TranslateCache[self.data.message] then
    self.line_trans:SetActive(true)
    self.text_trans:SetActive(true)
  end
end

return SeasonPhotoMessageItem
