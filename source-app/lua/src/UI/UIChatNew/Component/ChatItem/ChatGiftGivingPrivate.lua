local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_GiftGiving = BaseClass("ChatGiftGivingPrivate", IChatItemPost)
local base = IChatItemPost
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local RootPath = "Assets/Main/Sprites/UI/LWUIGiftSystem/"
local GiftIconShowContent = require("UI/LWPlayerInfo/UILWGiftSystem/Common/GiftIconShowContent")
local bg_path = "Bg"
local send_btn_path = "SendBtn"
local texts_path = "Texts"
local title_path = "Texts/Title"
local desc_path = "Texts/Desc"
local icon_path = "IconContent/Icon"
local num_path = "IconContent/Num"
local bg_bottom_path = "BgContent/BgBottom"
local bg_pattern_path = "BgContent/BgPattern"
local bg_start_path = "BgContent/BgStart"
local bg_frame_path = "BgContent/BgFrame"
local gift_icon_show_content_path = "IconContent/GiftIconShowContent"
local icon_content_path = "IconContent"
local extra_send_content_path = "extraSendContent"
local extra_send_txt_path = "extraSendContent/extraSendTipContent/extraSendTxt"
local extra_send_icon_content_path = "extraSendContent/extraSendTipContent/extraSendTxt/extraSendObjContent/extraSendIconContent"
local extra_send_icon_path = "extraSendContent/extraSendTipContent/extraSendTxt/extraSendObjContent/extraSendIconContent/extraSendIcon"
local extra_send_num_path = "extraSendContent/extraSendTipContent/extraSendTxt/extraSendObjContent/extraSendNum"
local extra_send_obj_content_path = "extraSendContent/extraSendTipContent/extraSendTxt/extraSendObjContent"
local ChatConfig = {
  Right = {
    Width = 486,
    Icon = 356,
    Text = 20,
    TextWidth = 336,
    StartPosX = 314,
    extraContentW = 336
  },
  Left = {
    Width = 511,
    Icon = 12,
    Text = 160,
    TextWidth = 336,
    StartPosX = 178,
    extraContentW = 336
  }
}
local ItemMinHeight = 164
local TxtWithItemDiffH = 26
local sendContentH = 88
local sendContentTxtH = 68
local sendContentDiffH = 20

function ChatItemPost_GiftGiving:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_GiftGiving:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.bg = self:AddComponent(UIImage, bg_path)
  self.texts = self:AddComponent(UIBaseContainer, texts_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.num = self:AddComponent(UITextMeshProUGUIEx, num_path)
  self.bg_bottom = self:AddComponent(UIImage, bg_bottom_path)
  self.bg_pattern = self:AddComponent(UIImage, bg_pattern_path)
  self.bg_start = self:AddComponent(UIImage, bg_start_path)
  self.bg_frame = self:AddComponent(UIImage, bg_frame_path)
  self.gift_icon_show_content = self:AddComponent(GiftIconShowContent, gift_icon_show_content_path)
  self.icon_content = self:AddComponent(UIBaseContainer, icon_content_path)
  self.extra_send_content = self:AddComponent(UIBaseContainer, extra_send_content_path)
  self.extra_send_txt = self:AddComponent(UITextMeshProUGUIEx, extra_send_txt_path)
  self.extra_send_icon_content = self:AddComponent(UIImage, extra_send_icon_content_path)
  self.extra_send_icon = self:AddComponent(UIImage, extra_send_icon_path)
  self.extra_send_num = self:AddComponent(UITextMeshProUGUIEx, extra_send_num_path)
  self.extra_send_obj_content = self:AddComponent(UIBaseContainer, extra_send_obj_content_path)
  self.extra_send_txt:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  ChatInterface.SetEmojiTextProperty(self.desc, true)
end

function ChatItemPost_GiftGiving:OnSendBtnClick()
  if self.sendUid == nil then
    return
  end
  DataCenter.GiftSystemManager:OpenOperationView({
    windowType = GiftSystemConst.WindowType.Send,
    targetUid = self.sendUid
  })
end

function ChatItemPost_GiftGiving:OnLoaded()
  local _chatdata = self:ChatData()
  if _chatdata == nil then
    return
  end
  self._chatData = _chatdata
  local isMyChat = self._chatData:isMyChat()
  local config = isMyChat and ChatConfig.Right or ChatConfig.Left
  self.texts:SetSizeDeltaX(config.TextWidth)
  self.texts:SetAnchoredPositionXY(config.Text, -16)
  self.root:SetSizeDeltaX(config.Width)
  self.bg_start:SetAnchoredPositionXY(config.StartPosX, 0)
  local bgScaleX = isMyChat and -1 or 1
  self.bg_bottom:SetLocalScaleXYZ(bgScaleX, 1, 1)
  self.bg_start:SetLocalScaleXYZ(-1 * bgScaleX, 1, 1)
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
  self.sendUid = extraJson.sendUid
  self.senderInfo = extraJson.senderInfo or {}
  self.targetInfo = extraJson.targetInfo or {}
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(extraJson.itemId)
  if template == nil then
    return
  end
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(template.id)
  local sendNum = extraJson.num
  local giftName = Localization:GetString(template.name)
  local sendPlayerName = extraJson.sendName
  local defaultKey, curCanEditor = DataCenter.GiftSystemManager:GetDefaultMsgKey(goods.id, sendNum)
  if self._chatData.group == ChatGroupType.GROUP_CUSTOM then
    if string.IsNullOrEmpty(extraJson.context) then
      if extraJson.isFollow then
        self.desc:SetLocalText("moment_follow_gift_des")
      else
        self.desc:SetLocalText(defaultKey)
      end
    else
      local showTxt = extraJson.context
      if self._chatData:GetTranslateState() == TranslateStateType.TranslationCompleted then
        showTxt = self._chatData:getTranslationMsg()
      end
      self.desc:SetText(showTxt)
    end
  elseif extraJson.isAnonymous ~= 1 then
    self.desc:SetLocalText("gift_sent_msg_des1", sendNum, sendPlayerName, giftName)
  else
    self.desc:SetLocalText("gift_sent_msg_des2", sendNum, giftName)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.texts.transform)
  local txtContX, txtContY = self.texts:GetSizeDeltaXY()
  local isSendContentH = 0
  if extraJson.giftExtraItemNum and 0 < tonumber(extraJson.giftExtraItemNum) then
    self.extra_send_content:SetActive(true)
    self.extra_send_content:SetSizeDeltaX(config.extraContentW)
    self.extra_send_content:SetAnchoredPositionXY(config.Text, -16 - txtContY)
    self.extra_send_txt:SetSizeDeltaX(config.extraContentW)
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
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.extra_send_obj_content.transform)
    local lineContentW, lineContentH = self.extra_send_obj_content:GetSizeDeltaXY()
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
    self.extra_send_txt:SetText(Localization:GetString("gift_coupon_limit2") .. "<link=" .. goodsId .. ">" .. "<u>" .. spaceStr .. addNumStr .. "</u></link>")
    local txtSizeX = self.extra_send_txt:GetSizeDelta().x
    local txtPrefabSize = self.extra_send_txt.unity_tmpro:GetPreferredValues(txtSizeX, 0)
    local txtPrefabH = txtPrefabSize.y
    self.extra_send_txt:SetSizeDeltaXY(txtSizeX, txtPrefabH)
    self.extra_send_txt.unity_tmpro:ForceMeshUpdate()
    local textInfo = self.extra_send_txt.unity_tmpro.textInfo
    local lineCount = textInfo.lineCount
    isSendContentH = txtPrefabH + sendContentDiffH
    if textInfo.characterCount >= spaceNum + addNumStrLen then
      local charInfo1 = textInfo.characterInfo[textInfo.characterCount - spaceNum - addNumStrLen]
      local charInfo2 = textInfo.characterInfo[textInfo.characterCount - 1 - addNumStrLen]
      local position1 = charInfo1.bottomLeft
      local position2 = charInfo2.bottomRight
      self.extra_send_obj_content:SetLocalPosition((position1 + position2) / 2, true)
      local lineH = textInfo.lineInfo[lineCount - 1].lineHeight
      local aPosX = self.extra_send_obj_content:GetAnchoredPositionX()
      local aPosY = self.extra_send_obj_content:GetAnchoredPositionY()
      aPosX = CommonUtil.ArabicAutoMirrorFactor() * aPosX
      self.extra_send_obj_content:SetAnchoredPositionXY(aPosX, aPosY + lineH / 4, true)
    end
  else
    self.extra_send_content:SetActive(false)
  end
  local itemHeight = txtContY + TxtWithItemDiffH + isSendContentH
  itemHeight = math.max(itemHeight, ItemMinHeight)
  self.root:SetSizeDeltaY(itemHeight)
  local hOffset, minScale, midScale, maxScale = DataCenter.GiftSystemManager.GetGiftIconParam(goods)
  if 0 < #goods.show_fx then
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
  local pic1Path, pic2Path = GiftSystemConst.GetChatQualityPicPrivate(template.quality)
  self.bg:LoadSprite(RootPath .. "zyf_liwufenxiang_di1")
  self.bg_bottom:LoadSprite(pic1Path)
  self.bg_pattern:LoadSprite(RootPath .. "zyf_liwufenxiang_diwen")
  self.bg_start:LoadSprite(pic2Path)
  self.bg_frame:LoadSprite(RootPath .. "zyf_liwufenxiang_di2")
  self.num:SetText("x" .. sendNum)
  if goods.ep_gift == 1 then
    local id = extraJson.chatGiftUuid or self._chatData.seqId
    DataCenter.GiftSystemManager:TryPlayAnim(id, goods.id, nil, self.senderInfo, self.targetInfo, extraJson.giftExtraItemNum)
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
      DataCenter.GiftSystemManager:TryPlayAnim(id, goods.id, index, self.senderInfo, self.targetInfo, extraJson.giftExtraItemNum)
    end
  end
  self.icon_content:SetAnchoredPositionXY(config.Icon, -(self:GetSizeDelta().y / 2))
  ChatInterface.DarkMode(self)
end

function ChatItemPost_GiftGiving:OnPointerClick(clickPos)
  local linkId = self.extra_send_txt:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local goodsId = tonumber(linkId) or 0
  if 0 < goodsId then
    local des_txt = DataCenter.ItemTemplateManager:GetDes(goodsId)
    UIUtil.ShowBubbleTips(des_txt, self.extra_send_icon.transform.position, 0, 20, 0, nil, nil, {reversal = true})
  end
end

function ChatItemPost_GiftGiving:OnRecycle()
end

return ChatItemPost_GiftGiving
