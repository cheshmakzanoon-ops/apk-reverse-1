local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local content_path = "Content"
local u_i_player_head_path = "Content/UIPlayerHead"
local u_i_player_head_receiver_path = "Content/UIPlayerHead_Receiver"
local player_name_text_path = "Content/PlayerNameText"
local player_name_text_receiver_path = "Content/PlayerNameText_Receiver"
local des_text_path = "Content/txtContent/DesText"
local icon_path = "Content/Icon"
local gift_icon_show_content_path = "Content/GiftIconShowContent"
local num_path = "Content/Num"
local black_mask_path = "Content/BlackMask"
local btn_path = "Content/Btn"
local bg_path = "Content/bgContent/bg"
local diwen_path = "Content/bgContent/diwenContent/diwen"
local line1_path = "Content/bgContent/lineContent/line1"
local line2_path = "Content/bgContent/lineContent/line2"
local line3_path = "Content/bgContent/lineContent/line3"
local line4_path = "Content/bgContent/lineContent/line4"
local gift_bg_path = "Content/bgContent/giftBg"
local arrow_bg_path = "Content/bgContent/arrowBg"
local head_bg1_path = "Content/bgContent/headBg1"
local head_bg2_path = "Content/bgContent/headBg2"
local txt_content_bg_path = "Content/bgContent/txtContentBg"
local translate_content_path = "Content/txtContent/translateContent"
local translating_path = "Content/txtContent/translateContent/Translating"
local translate_finish_img_path = "Content/txtContent/translateContent/TranslateFinishImg"
local translate_btn_path = "Content/txtContent/translateContent/TranslateBtn"
local translate_refresh_btn_path = "Content/txtContent/translateContent/TranslateRefreshBtn"
local translating_text_path = "Content/txtContent/translateContent/Translating/TranslatingText"
local extra_send_content_path = "Content/extraSendContent"
local extra_send_tip_path = "Content/extraSendContent/extraSendTip"
local extra_send_icon_content_path = "Content/extraSendContent/extraSendTip/extraSendIconContent"
local extra_send_icon_path = "Content/extraSendContent/extraSendTip/extraSendIconContent/extraSendIcon"
local extra_send_num_path = "Content/extraSendContent/extraSendNum"
local txt_content_path = "Content/txtContent"
local GiftIconShowContent = require("UI/LWPlayerInfo/UILWGiftSystem/Common/GiftIconShowContent")
local ChatGiftGiving = BaseClass("ChatGiftGiving", base)
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local sin15d = 0.2588
local cos15d = 0.9659
local itemMinH = 334
local itemWidth = 752
local translateBtnH = 50
local txtMinH = 42
local txtContentMinH = 92
local txtContentDiffItemH = 242
local sendContentH = 50
local txtContentBgMinH = 118

function ChatGiftGiving:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatGiftGiving:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatGiftGiving:ComponentDefine()
  self.content = self:AddComponent(UIRawImage, content_path)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.u_i_player_head_receiver = self:AddComponent(UICommonHead, u_i_player_head_receiver_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.player_name_text_receiver = self:AddComponent(UITextMeshProUGUIEx, player_name_text_receiver_path)
  self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.num = self:AddComponent(UITextMeshProUGUIEx, num_path)
  self.black_mask = self:AddComponent(UIImage, black_mask_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.diwen = self:AddComponent(UIImage, diwen_path)
  self.line1 = self:AddComponent(UIImage, line1_path)
  self.line2 = self:AddComponent(UIImage, line2_path)
  self.line3 = self:AddComponent(UIImage, line3_path)
  self.line4 = self:AddComponent(UIImage, line4_path)
  self.gift_bg = self:AddComponent(UIImage, gift_bg_path)
  self.arrow_bg = self:AddComponent(UIImage, arrow_bg_path)
  self.head_bg1 = self:AddComponent(UIImage, head_bg1_path)
  self.head_bg2 = self:AddComponent(UIImage, head_bg2_path)
  self.txt_content_bg = self:AddComponent(UIImage, txt_content_bg_path)
  self.translate_content = self:AddComponent(UIBaseContainer, translate_content_path)
  self.translating = self:AddComponent(UIImage, translating_path)
  self.translating_text = self:AddComponent(UIText, translating_text_path)
  self.translating_text:SetLocalText("120039")
  self.translate_finish_img = self:AddComponent(UIImage, translate_finish_img_path)
  self.translate_btn = self:AddComponent(UIButton, translate_btn_path)
  self.translate_refresh_btn = self:AddComponent(UIButton, translate_refresh_btn_path)
  self.gift_icon_show_content = self:AddComponent(GiftIconShowContent, gift_icon_show_content_path)
  self.extra_send_content = self:AddComponent(UIBaseContainer, extra_send_content_path)
  self.extra_send_tip = self:AddComponent(UITextMeshProUGUIEx, extra_send_tip_path)
  self.extra_send_icon_content = self:AddComponent(UIBaseContainer, extra_send_icon_content_path)
  self.extra_send_icon = self:AddComponent(UIImage, extra_send_icon_path)
  self.extra_send_num = self:AddComponent(UITextMeshProUGUIEx, extra_send_num_path)
  self.translate_btn:SetOnClick(function()
    self:TranslateMsg()
  end)
  self.translate_refresh_btn:SetOnClick(function()
    self:TranslateMsgThenChangeType()
  end)
  self.txt_content = self:AddComponent(UIImage, txt_content_path)
  self.extra_send_tip:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  ChatInterface.SetEmojiTextProperty(self.des_text, true)
end

function ChatGiftGiving:ComponentDestroy()
  self.content = nil
  self.u_i_player_head = nil
  self.u_i_player_head_receiver = nil
  self.player_name_text = nil
  self.player_name_text_receiver = nil
  self.des_text = nil
  self.icon = nil
  self.num = nil
  self.black_mask = nil
  self.btn = nil
  self.bg = nil
  self.diwen = nil
  self.line1 = nil
  self.line2 = nil
  self.line3 = nil
  self.line4 = nil
  self.gift_bg = nil
  self.arrow_bg = nil
  self.head_bg1 = nil
  self.head_bg2 = nil
  self.txt_content_bg = nil
  self.translate_content = nil
  self.translating = nil
  self.translating_text = nil
  self.translate_finish_img = nil
  self.translate_btn = nil
  self.translate_refresh_btn = nil
  self.gift_icon_show_content = nil
  self.extra_send_content = nil
  self.extra_send_tip = nil
  self.extra_send_icon_content = nil
  self.extra_send_icon = nil
  self.extra_send_num = nil
  self.txt_content = nil
end

function ChatGiftGiving:UpdateItem(chatData, index)
  self._chatData = chatData
  local customJsonParam = self._chatData.extra and self._chatData.extra.customJsonParam
  if customJsonParam == nil then
    return
  end
  local extraJson
  if type(self._chatData.extra.customJsonParam) == "string" then
    extraJson = rapidjson.decode(self._chatData.extra.customJsonParam)
  elseif type(self._chatData.extra.customJsonParam) == "table" then
    extraJson = self._chatData.extra.customJsonParam
  else
    return
  end
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(extraJson.itemId)
  if template == nil then
    return
  end
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(template.id)
  local targetInfo = extraJson.targetInfo or {}
  local senderInfo = extraJson.senderInfo or {}
  local sendNum = extraJson.num
  local giftName = Localization:GetString(template.name)
  local sendPlayerName = extraJson.sendName
  local hOffset, minScale, midScale, maxScale = DataCenter.GiftSystemManager.GetGiftIconParam(goods)
  if #goods.show_fx > 0 then
    self.icon:SetActive(false)
    self.gift_icon_show_content:SetActive(true)
    self.gift_icon_show_content:SetShowData(goods.id, 1)
    self.gift_icon_show_content:SetLocalScaleXYZ(midScale, midScale, midScale)
  else
    self.icon:SetActive(true)
    self.gift_icon_show_content:SetActive(false)
    self.icon:LoadSpriteAsyncWithCallback(GiftSystemConst.GetIconPathNew(goods.icon_big), function()
      if self.icon then
        self.icon:SetNativeSize()
      end
    end)
    self.icon:SetLocalScaleXYZ(midScale, midScale, midScale)
  end
  self:SetTxtShowAndBgPicContent(template.quality, extraJson)
  self.num:SetText("x" .. sendNum)
  senderInfo.isActiveAnonymity = extraJson.isAnonymous == 1
  local abbr = not string.IsNullOrEmpty(senderInfo.abbr) and "[" .. tostring(senderInfo.abbr) .. "]" or ""
  local senderName = abbr .. tostring(senderInfo.name)
  if extraJson.isAnonymous == 1 then
    senderName = Localization:GetString("390810")
  end
  self.u_i_player_head:ParseHeadInfo(senderInfo)
  self.u_i_player_head:SetEnableClickShowInfo(extraJson.isAnonymous ~= 1, true)
  self.player_name_text:SetText(senderName)
  self.u_i_player_head_receiver:ParseHeadInfo(targetInfo)
  self.u_i_player_head_receiver:SetEnableClickShowInfo(true, true)
  local abbr_receiver = not string.IsNullOrEmpty(targetInfo.abbr) and "[" .. tostring(targetInfo.abbr) .. "]" or ""
  self.player_name_text_receiver:SetText(abbr_receiver .. tostring(targetInfo.name))
  self.black_mask:SetActive(ChatInterface.GetChatTheme() == ChatUIThemeConfig.ChatMode.Night)
  if goods.ep_gift == 1 then
    local id = extraJson.chatGiftUuid or self._chatData.seqId
    DataCenter.GiftSystemManager:TryPlayAnim(id, goods.id, nil, senderInfo, targetInfo, extraJson.giftExtraItemNum)
  elseif next(goods.group_id) then
    local index = 0
    for i, v in ipairs(goods.group_id) do
      if sendNum >= tonumber(v) then
        index = i
      end
    end
    local effect = goods.group_effect[index]
    if not string.IsNullOrEmpty(effect) then
      local id = extraJson.chatGiftUuid or self._chatData.seqId
      DataCenter.GiftSystemManager:TryPlayAnim(id, goods.id, index, senderInfo, targetInfo, extraJson.giftExtraItemNum)
    end
  end
end

function ChatGiftGiving:SetTxtShowAndBgPicContent(quality, extraJson)
  local bg, gift_bg, txt_bg, head_bg, arrow, line = GiftSystemConst.GetGiftPostQualityPic(quality)
  self.bg:LoadSprite(bg)
  self.diwen:SetAlpha(GiftSystemConst.GetGiftDiwenAlpha(quality))
  self.gift_bg:LoadSprite(gift_bg)
  self.txt_content:LoadSprite(txt_bg)
  self.head_bg1:LoadSprite(head_bg)
  self.head_bg2:LoadSprite(head_bg)
  self.arrow_bg:LoadSprite(arrow)
  self.line1:LoadSprite(line)
  self.line2:LoadSprite(line)
  self.line3:LoadSprite(line)
  self.line4:LoadSprite(line)
  local isTranslateBtnShow = false
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(extraJson.itemId)
  local defaultKey, curCanEditor = DataCenter.GiftSystemManager:GetDefaultMsgKey(goods.id, extraJson.num)
  if extraJson.isAnonymous ~= 1 then
    if not string.IsNullOrEmpty(extraJson.context) then
      isTranslateBtnShow = true
      local showTxt = extraJson.context
      if self._chatData:GetTranslateState() == TranslateStateType.TranslationCompleted then
        showTxt = self._chatData:getTranslationMsg()
      end
      self.des_text:SetText(showTxt)
    else
      self.des_text:SetLocalText(defaultKey)
    end
  else
    self.des_text:SetLocalText(defaultKey)
  end
  if isTranslateBtnShow then
    self.translate_content:SetActive(true)
    self:UpdateTranslateBtnState(self._chatData:IsTranslating(), self._chatData:GetTranslateState() == TranslateStateType.TranslationCompleted)
  else
    self.translate_content:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.des_text.transform)
  local txtContX, txtContY = self.des_text:GetSizeDeltaXY()
  local curtranslateBtnH = isTranslateBtnShow and translateBtnH or 0
  local txtContentH = txtContY + curtranslateBtnH
  local isSendContentH = 0
  if extraJson.giftExtraItemNum and 0 < tonumber(extraJson.giftExtraItemNum) then
    self.extra_send_content:SetActive(true)
    local tipStr = Localization:GetString("gift_coupon_limit2")
    local addNumStr = "x" .. extraJson.giftExtraItemNum
    local addNumStrLen = string.len(addNumStr)
    self.extra_send_num:SetText("")
    local goodsId = tonumber(extraJson.giftExtraItemId)
    local goodsTemp = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
    if goodsTemp then
      local iconPath = string.format(LoadPath.ItemPath, goodsTemp.icon)
      self.extra_send_icon:LoadSpriteAsyncWithCallback(iconPath, function()
        if self.extra_send_icon then
          self.extra_send_icon:SetNativeSize()
          local contentX, contentY = self.extra_send_icon_content:GetSizeDeltaXY()
          local iconX, iconY = self.extra_send_icon:GetSizeDeltaXY()
          local iconScale = contentX / iconX
          self.extra_send_icon:SetLocalScaleXYZ(iconScale, iconScale, iconScale)
        end
      end)
    end
    local lineContentW, lineContentH = self.extra_send_icon_content:GetSizeDeltaXY()
    local spaceNum = 0
    local oneSpaceW = 5.8335
    local oneSpaceW2 = 5
    if 0 < lineContentW then
      if lineContentW > oneSpaceW * 2 then
        spaceNum = 2 + math.ceil((lineContentW - oneSpaceW * 2) / oneSpaceW2)
      else
        spaceNum = math.ceil(lineContentW / oneSpaceW)
      end
    end
    local spaceStr = ""
    if 2 < spaceNum then
      spaceStr = string.rep("\194\160", spaceNum - 2)
      spaceStr = " " .. spaceStr .. " "
    else
      spaceStr = " " .. "\194\160"
    end
    self.extra_send_tip:SetText(tipStr .. "<link=" .. goodsId .. ">" .. "<u>" .. spaceStr .. addNumStr .. "</u></link>")
    local txtSizeX = self.extra_send_content:GetSizeDelta().x
    local txtPrefabSize = self.extra_send_tip.unity_tmpro:GetPreferredValues(txtSizeX, 0)
    local txtPrefabH = txtPrefabSize.y
    self.extra_send_tip:SetSizeDeltaXY(txtSizeX, txtPrefabH)
    self.extra_send_tip.unity_tmpro:ForceMeshUpdate()
    local textInfo = self.extra_send_tip.unity_tmpro.textInfo
    local lineCount = textInfo.lineCount
    isSendContentH = txtPrefabH
    if textInfo.characterCount >= spaceNum + addNumStrLen then
      local charInfo1 = textInfo.characterInfo[textInfo.characterCount - spaceNum - addNumStrLen]
      local charInfo2 = textInfo.characterInfo[textInfo.characterCount - 1 - addNumStrLen]
      local position1 = charInfo1.bottomLeft
      local position2 = charInfo2.bottomRight
      self.extra_send_icon_content:SetLocalPosition((position1 + position2) / 2, true)
      local lineH = textInfo.lineInfo[lineCount - 1].lineHeight
      local aPosX = self.extra_send_icon_content:GetAnchoredPositionX()
      local aPosY = self.extra_send_icon_content:GetAnchoredPositionY()
      aPosX = CommonUtil.ArabicAutoMirrorFactor() * aPosX
      self.extra_send_icon_content:SetAnchoredPositionXY(aPosX, aPosY + lineH / 4, true)
    end
  else
    self.extra_send_content:SetActive(false)
  end
  local itemTargetH = 0
  if txtContentH < txtContentMinH then
    itemTargetH = itemMinH
  else
    itemTargetH = txtContentH + txtContentDiffItemH
  end
  itemTargetH = itemTargetH + isSendContentH
  self:SetSizeDeltaXY(itemWidth, itemTargetH)
  local textBgH = 0
  if txtContentH < txtContentMinH then
    textBgH = txtContentBgMinH
  else
    textBgH = txtContentBgMinH + (txtContentH - txtContentMinH)
  end
  self.txt_content:SetSizeDeltaY(textBgH)
end

function ChatGiftGiving:OnPointerClick(clickPos)
  local linkId = self.extra_send_tip:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local goodsId = tonumber(linkId) or 0
  if 0 < goodsId then
    local des_txt = DataCenter.ItemTemplateManager:GetDes(goodsId)
    UIUtil.ShowBubbleTips(des_txt, self.extra_send_icon.transform.position, 0, 20, 0, nil, nil, {reversal = true})
  end
end

function ChatGiftGiving:TranslateMsg()
  if self._chatData:IsTranslating() then
    return
  end
  local _translationMsg = self._chatData:getTranslationMsg()
  if self._chatData.translatedLang == ChatInterface.GetChatTranslateLanguageAbbr() and not string.IsNullOrEmpty(_translationMsg) and self._chatData:GetCanRefreshTranslate() == 1 then
    return
  end
  self._chatData:setTranslateState(1)
  if string.IsNullOrEmpty(_translationMsg) or self._chatData.translatedLang ~= ChatInterface.GetChatTranslateLanguageAbbr() then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE, self._chatData)
  elseif self._chatData:GetCanRefreshTranslate() ~= 1 then
    self:TranslateMsgThenChangeType()
  else
    self._chatData:setTranslateState(0)
  end
  self:UpdateTranslateBtnState(self._chatData:IsTranslating(), self._chatData:GetTranslateState() == 2)
end

function ChatGiftGiving:TranslateMsgThenChangeType()
  self._chatData:setTranslateState(1)
  local transType = self._chatData:GetTranslateType()
  if transType == nil then
    transType = 1
  elseif transType == 0 then
    transType = 1
  elseif transType == 1 then
    transType = 0
  end
  self._chatData:SetTranslateType(transType)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE, self._chatData)
end

function ChatGiftGiving:UpdateTranslateBtnState(isTranslating, hasTranslated)
  if self.translate_btn == nil then
    return
  end
  self.translating:SetActive(isTranslating and not hasTranslated)
  self.translate_btn:SetActive(not isTranslating and not hasTranslated)
  self.translate_finish_img:SetActive(hasTranslated and self._chatData:GetCanRefreshTranslate() == 1)
  self.translate_refresh_btn:SetActive(hasTranslated and self._chatData:GetCanRefreshTranslate() ~= 1)
end

function ChatGiftGiving:ResetTranslatePart()
  if self.translate_btn == nil then
    return
  end
  self.translate_btn:SetActive(false)
  self.translate_refresh_btn:SetActive(false)
  self.translate_finish_img:SetActive(false)
  self.translating:SetActive(false)
end

return ChatGiftGiving
