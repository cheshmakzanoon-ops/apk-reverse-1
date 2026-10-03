local baseItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local baseClass = require("UI.UIChatNew.Component.AIAssistant.ChatAIAssistantCell")
local ChatAIAssistantEmojiItem = require("UI.UIChatNew.Component.AIAssistant.ChatAIAssistantEmojiItem")
local ChatAISecretaryCell = BaseClass("ChatAISecretaryCell", baseClass)
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local Localization = CS.GameEntry.Localization
local layout_path = "ChatAnchor/Layout"
local normal_bg_path = "ChatAnchor/Layout/Bg/NormalBg"
local flower_path = "ChatAnchor/Layout/Bg/NormalBg/flower"
local translating_root = "ChatAnchor/Layout/Bg/NormalBg/Translating"
local translating_text = "ChatAnchor/Layout/Bg/NormalBg/Translating/TranslatingText"
local translate_finish_img_path = "ChatAnchor/Layout/Bg/NormalBg/TranslateFinishImg"
local translate_btn_path = "ChatAnchor/Layout/Bg/NormalBg/TranslateBtn"
local dialog_path = "ChatAnchor/Layout/DialogText"
local dialog_text = "ChatAnchor/Layout/DialogText/Text1"
local translate_path = "ChatAnchor/Layout/TranslateText"
local translate_text = "ChatAnchor/Layout/TranslateText/Text2"

function ChatAISecretaryCell:OnCreate()
  baseItem.OnCreate(self)
  self.flower = self:AddComponent(UIImage, flower_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.normal_bg = self:AddComponent(UIImage, normal_bg_path)
  self.translateBtn = self:AddComponent(UIButton, translate_btn_path)
  self.translateFinishImg = self:AddComponent(UIBaseContainer, translate_finish_img_path)
  self.translating = self:AddComponent(UIBaseContainer, translating_root)
  self.translatingText = self:AddComponent(UIText, translating_text)
  self.translatingText:SetText(Localization:GetString("120039"))
  self.translateBtn:SetOnClick(function()
    self:OnTranslationBtn()
  end)
  self.dialog_root = self:AddComponent(UIBaseContainer, dialog_path)
  self.message = self:AddComponent(UITextMeshProUGUIEx, dialog_text)
  self.message:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.translate_root = self:AddComponent(UIBaseContainer, translate_path)
  self.translate_text = self:AddComponent(UITextMeshProUGUIEx, translate_text)
  if self.transform:Find("ChatNameLayout") ~= nil then
    self._chatUserName = self:AddComponent(ChatUserName, "ChatNameLayout")
  end
  if self.transform:Find("ChatHead") ~= nil then
    self._chatHead = self:AddComponent(ChatHead, "ChatHead")
  end
  self.theCellItem = self.transform:Find("ChatAnchor/Layout/EmojiItemCell").gameObject
  self.theCellItem:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, "ChatAnchor/Layout/ChatAIAssistant")
  self.buttons = self:AddComponent(UIBaseContainer, "ChatAnchor/Layout/Buttons")
  self.btnGo = self:AddComponent(UIButton, "ChatAnchor/Layout/Buttons/BtnGo")
  self.textGo = self:AddComponent(UIText, "ChatAnchor/Layout/Buttons/BtnGo/Txt_Use")
  self.buttons:SetActive(false)
  self.btnGo:SetOnClick(function()
    self:OnJumpBtnClick()
  end)
  baseClass.AddBtnClick(self)
end

function ChatAISecretaryCell:OnAddListener()
  baseClass.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, self.UpdateItemWithNew)
end

function ChatAISecretaryCell:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, self.UpdateItemWithNew)
  baseClass.OnRemoveListener(self)
end

function ChatAISecretaryCell:OnJumpBtnClick()
  if self._roomData ~= nil and self._roomData.jump_ui_name ~= nil then
    local ok = DataCenter.LWChatAIManager:DoJump(self._roomData.jump_ui_name, self._roomData.jump_ui_para, self._roomData.jump_tips)
    if ok then
      EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
    end
  end
end

function ChatAISecretaryCell:OnPointerClick(clickPos)
  if not self:CheckTopViewSlideStateWhenClick() then
    return
  end
  if self.message == nil or self.isInDrag then
    return
  end
  local linkId = self.message:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    self:ShowChatOperator()
    return
  end
  local linkMsg = base64.decode(linkId)
  linkMsg = rapidjson.decode(linkMsg)
  if linkMsg ~= nil and linkMsg.action == "Jump" then
    GoToUtil.TryJumpToWorld(linkMsg)
    return
  end
  if self:HandleFaqMessage(linkMsg) then
    EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
    return
  end
  self:ShowChatOperator()
end

function ChatAISecretaryCell:ShowChatOperator()
  local param = {}
  param.chatdata = self._chatData
  param.userinfo = nil
  param.targetPos = self.gameObject.transform
  param.chatItem = self
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatItemOperatorView, {anim = false}, param)
end

function ChatAISecretaryCell:UpdateItemWithNew(t)
  if t ~= nil and self._chatData ~= nil and t.roomId == self._chatData.roomId and t.seqId == self._chatData.seqId then
    local room = ChatInterface.getRoomData(t.roomId)
    if room ~= nil then
      local chatData = room:getChatDataBySeqId(t.seqId)
      if chatData ~= nil then
        if self._chatData ~= chatData then
          self._chatData:setTranslationMsg(chatData:getTranslationMsg())
        end
        self:UpdateItem(chatData, self._chatIndex)
        self._contentViewScript:ReloadAfterTranslateRecv(self._chatIndex)
      end
    end
  end
end

function ChatAISecretaryCell:UpdateItem(_chat_data, _index)
  baseClass.UpdateItem(self, _chat_data, _index)
  baseItem.UpdateUserInfoWithNew(self)
  if self._roomData ~= nil then
    self.buttons:SetActive(self._roomData.jump_ui_name ~= nil and self._roomData.jump_ui_name ~= "")
  else
    self.buttons:SetActive(false)
  end
  self:UpdateCellSize()
end

function ChatAISecretaryCell:UpdateEmojiCell(theRoomData, theCharacterData, theSkin, isEmojiOn)
  baseClass.UpdateEmojiCell(self, theRoomData, theCharacterData, theSkin, isEmojiOn)
  local _translationMsg = self._chatData:getTranslationMsg()
  local isTranslating = self._chatData:IsTranslating()
  local hasTranslated = _translationMsg ~= nil and _translationMsg ~= ""
  self.translate_root:SetActive(false)
  if hasTranslated then
    self.translate_root:SetActive(true)
    self.translate_text:SetText(_translationMsg)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.translate_root.rectTransform)
  end
  self.translating.gameObject:SetActive(isTranslating and not hasTranslated)
  self.translateBtn.gameObject:SetActive(not isTranslating and not hasTranslated)
  self.translateFinishImg.gameObject:SetActive(hasTranslated)
  self:UpdateCellSize()
end

function ChatAISecretaryCell:UpdateEmojiStatus(userData)
  baseClass.UpdateEmojiStatus(self, userData)
end

function ChatAISecretaryCell:UpdateCellSize()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.dialog_root.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
  local fullHeight = self.layout.rectTransform.sizeDelta.y
  local rect_sizeDelta_cx, _ = self.rectTransform:Get_sizeDelta()
  self.normal_bg.rectTransform:Set_sizeDelta(520, fullHeight)
  self.rectTransform:Set_sizeDelta(rect_sizeDelta_cx, Mathf.Ceil(fullHeight + 33))
  if 196 < fullHeight then
    self.flower.rectTransform:Set_sizeDelta(260, 186)
  else
    self.flower.rectTransform:Set_sizeDelta((fullHeight - 10) * 1.38, fullHeight - 10)
  end
end

function ChatAISecretaryCell:OnDestroy()
  self.content:RemoveComponents(ChatAIAssistantEmojiItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  baseItem.OnDestroy(self)
  self.message = nil
  self.content = nil
end

function ChatAISecretaryCell:OnTranslationBtn()
  if not self._chatData:IsTranslating() then
    self._chatData:setTranslateState(1)
    local _translationMsg = self._chatData:getTranslationMsg()
    if string.IsNullOrEmpty(_translationMsg) then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE, self._chatData)
    else
      self._chatData:setTranslateState(0)
    end
    self:UpdateItem(self._chatData, self._chatIndex)
    self._contentViewScript:ReloadAfterTranslateRecv(self._chatIndex)
  end
end

return ChatAISecretaryCell
