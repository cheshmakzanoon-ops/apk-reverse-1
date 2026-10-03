local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatAIAssistantCell = BaseClass("ChatAIAssistantCell", base)
local ChatAIAssistantEmojiItem = require("UI.UIChatNew.Component.AIAssistant.ChatAIAssistantEmojiItem")
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local UnityHorizontalOrVerticalLayoutGroup = typeof(CS.UnityEngine.UI.HorizontalOrVerticalLayoutGroup)
local skin_config = {
  zyf_aijieruliaotian_di2 = {
    select_image = "Assets/Main/Sprites/UI/UIChatAI/zyf_aijieruliaotian_andi2",
    txt_color = {
      {
        r = 0.6470588235294118,
        g = 0.5254901960784314,
        b = 0.47058823529411764,
        a = 1
      },
      {
        r = 0.6470588235294118,
        g = 0.5254901960784314,
        b = 0.47058823529411764,
        a = 1
      }
    }
  },
  zyf_liaotian_fenlei_xuanzhong = {
    select_image = "Assets/Main/Sprites/UI/UIChatAI/zyf_aijieruliaotian_andi1",
    txt_color = {
      {
        r = 0.3843137254901961,
        g = 0.43137254901960786,
        b = 0.5411764705882353,
        a = 1
      },
      {
        r = 0.43137254901960786,
        g = 0.5098039215686274,
        b = 0.7254901960784313,
        a = 1
      }
    }
  }
}

function ChatAIAssistantCell:OnCreate()
  base.OnCreate(self)
  self.cellArea = self:AddComponent(UIBaseContainer, "")
  self.bodySprite = self:AddComponent(UIImage, "Assistant/Role/icon")
  self.bgSprite = self:AddComponent(UIImage, "Assistant")
  self.message = self:AddComponent(UITextMeshProUGUIEx, "Assistant/RichTextRoot/RichText")
  self.messageLayoutGroup = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "Assistant/RichTextRoot")
  self.content = self:AddComponent(UIBaseContainer, "Assistant/Content")
  self.theCellItem = self.transform:Find("ItemCell").gameObject
  self.theCellItem:GameObjectCreatePool()
  self.theVerticalLayoutGroup = self.bgSprite.gameObject:GetComponent(UnityHorizontalOrVerticalLayoutGroup)
  self.message:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.iconEx = self:AddComponent(UIImage, "Assistant/RichTextRoot/iconEx")
  self.iconEx:SetActive(false)
  self.message:SetMargin(0, 0, 0, 0)
end

function ChatAIAssistantCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_GPT_EMOJI_UPDATE, self.UpdateEmojiStatus)
end

function ChatAIAssistantCell:OnRemoveListener()
  self:RemoveUIListener(EventId.CHAT_GPT_EMOJI_UPDATE, self.UpdateEmojiStatus)
  base.OnRemoveListener(self)
end

function ChatAIAssistantCell:OnPointerClick(clickPos)
  if self.message == nil or self.isInDrag then
    return
  end
  local linkId = self.message:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  if linkId:find("EffectId:") then
    local effectId = string.match(linkId, "EffectId:(.+)")
    if not string.IsNullOrEmpty(effectId) then
      effectId = tonumber(effectId)
      local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.OffSeason1RecaptureBuffTip)
      local effectInfo = {}
      effectInfo.unlock = true
      effectInfo.effectId = effectId
      effectInfo.cfg = LocalController:instance():getLine(TableName.StatusTab, effectId)
      param.effectInfo = effectInfo
      param.screenPos = clickPos
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIOffSeason1RecaptureBuffTip, {anim = true}, param)
    end
    return
  end
  local linkMsg = base64.decode(linkId)
  linkMsg = rapidjson.decode(linkMsg)
  if linkMsg ~= nil and linkMsg.action == "SeasonAllyFriend" then
    local applyUuid = linkMsg.applyUuid
    local now = UITimeManager:GetInstance():GetServerTime()
    local applyData = DataCenter.SeasonAllyFriendManager:GetAllyDataByApplyUuid(applyUuid)
    if applyData == nil or applyData.applyBaseInfo and now >= applyData.applyBaseInfo.expireTime then
      UIUtil.ShowTipsId(391049)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsShowInvite, {anim = false}, 2, applyData)
    end
  elseif linkMsg ~= nil and linkMsg.action == "Jump" then
    if linkMsg.server == nil or linkMsg.server == 0 then
      linkMsg.server = LuaEntry.Player:GetSelfServerId()
    end
    if linkMsg.s then
      linkMsg.server = toInt(linkMsg.s)
    end
    if linkMsg.ots ~= nil then
      local overtime = toInt(linkMsg.ots)
      local now = UITimeManager:GetInstance():GetServerSeconds()
      if overtime ~= 0 and overtime < now then
        UIUtil.ShowTipsId("2000228")
        return
      end
    end
    if linkMsg.t == PostType.HelpMePutAresMissile then
      local pointId = toInt(linkMsg.pointId)
      local serverId = linkMsg.server or LuaEntry.Player:GetCurServerId()
      local worldId = linkMsg.worldId or 0
      if pointId == 0 and linkMsg.x ~= nil and linkMsg.y ~= nil then
        pointId = SceneUtils.TilePosToIndex(linkMsg, ForceChangeScene.World)
      end
      GoToUtil.DoPlayerAssistance(serverId, worldId, pointId)
    else
      GoToUtil.TryJumpToWorld(linkMsg)
    end
  elseif self:HandleFaqMessage(linkMsg) then
    EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
  end
end

function ChatAIAssistantCell:UpdateEmojiStatus(userData)
  if userData == nil or userData.infos == nil or userData.roomId ~= self._roomId then
    return
  end
  local emoji_mine = userData.infos[tostring(self._chatData.seqId)]
  if emoji_mine == nil or self._chatData == nil then
    return
  end
  local isAIOpen = LuaEntry.DataConfig:TryGetNum(KeySwitchOnChatGPT, "k1")
  local theRoomData = self._roomData
  local theCharacterData = theRoomData:GetCharacterData()
  local isEmojiOn = isAIOpen == 1 and theRoomData:IsEmojiOn() and self._chatData:isEmojiOnAndFromAI()
  local theSkin = skin_config[theCharacterData:GetMessageBg()]
  self.emoji_mine = emoji_mine
  self:UpdateEmojiCell(theRoomData, theCharacterData, theSkin, isEmojiOn)
end

function ChatAIAssistantCell:whenEmojiClick(emoji_id)
  local roomId = self._chatData.roomId
  local msgSeq = self._chatData.seqId
  local msgTime = self._chatData.serverTime
  local emoId = emoji_id
  local targetUid = self._customJsonData.user_id
  SFSNetwork.SendMessage(MsgDefines.ChatGPTMessageLike, roomId, msgSeq, msgTime, emoId, targetUid)
end

function ChatAIAssistantCell:ClickExistEmoji(emoji_id)
  local emoji_mine = self.emoji_mine
  if 0 < #emoji_mine then
    local ai_chat_send_emo_num = LuaEntry.DataConfig:TryGetNum("ai_chat_send_emo_num", "k1")
    for k, v in ipairs(emoji_mine) do
      if v == emoji_id then
        self:whenEmojiClick(emoji_id)
        return
      end
    end
    if ai_chat_send_emo_num <= #emoji_mine then
      UIUtil.ShowTipsId(900526)
      return
    end
  end
  self:whenEmojiClick(emoji_id)
end

function ChatAIAssistantCell:AddNewEmoji(emoji_id)
  local ai_chat_send_emo_num = LuaEntry.DataConfig:TryGetNum("ai_chat_send_emo_num", "k1")
  local emoji_info = self.emoji_info
  local emoji_mine = self.emoji_mine
  if 0 < #emoji_info and ai_chat_send_emo_num <= #emoji_mine then
    UIUtil.ShowTipsId(900509)
    return
  end
  for k, v in ipairs(emoji_mine) do
    if v == emoji_id then
      return false
    end
  end
  self:whenEmojiClick(emoji_id)
  return true
end

function ChatAIAssistantCell:UpdateItem(_chat_data, _index)
  local jsonObj, theRoomData, theCharacterData
  local theSkin = skin_config.zyf_liaotian_fenlei_xuanzhong
  self._chatIndex = _index
  self._chatData = _chat_data
  self._roomId = _chat_data.roomId
  self._msgSeq = tostring(self._chatData.seqId)
  if _chat_data.extra ~= nil and _chat_data.extra.customJsonParam ~= nil then
    jsonObj = rapidjson.decode(_chat_data.extra.customJsonParam)
  end
  local tabCityInfo
  if _chat_data.extra ~= nil and _chat_data.extra.allianceCityInfo ~= nil then
    tabCityInfo = rapidjson.decode(_chat_data.extra.allianceCityInfo)
  end
  local isAIOpen = LuaEntry.DataConfig:TryGetNum(KeySwitchOnChatGPT, "k1")
  if jsonObj ~= nil and jsonObj.room_id ~= nil then
    theRoomData = DataCenter.LWChatAIManager:GetChatRoomConfigById(jsonObj.room_id)
    if theRoomData ~= nil then
      theCharacterData = theRoomData:GetCharacterData()
      theSkin = skin_config[theCharacterData:GetMessageBg()]
    end
  elseif self.bodySprite and _chat_data.post == PostType.CityAttachmentBuildStart then
    self.bodySprite:LoadSprite("Assets/Main/Sprites/UI/UIAllianceNew/zyf_lianmengjianshezhe_liaotian_icon1.png")
  elseif self.bodySprite and _chat_data.post == PostType.CityAttachmentBuildFinish then
    self.bodySprite:LoadSprite("Assets/Main/Sprites/UI/UIAllianceNew/zyf_lianmengjianshezhe_liaotian_icon1.png")
  elseif self.bodySprite and _chat_data.post == PostType.CityAttachmentConvert then
    self.bodySprite:LoadSprite("Assets/Main/Sprites/UI/UIAllianceNew/zyf_lianmengjianshezhe_liaotian_icon2.png")
  elseif self.bodySprite and jsonObj and jsonObj.noticeType == 1 and _chat_data.post == PostType.SkillGuardianTower then
    local path = DataCenter.AllianceGovernmentSkillManager:GetSkillBigIconBySkillType(AlOfficialSkillType.GuardianTower)
    self.bodySprite:LoadSprite(path)
  elseif self.bodySprite and jsonObj and jsonObj.noticeType == 1 and _chat_data.post == PostType.SkillAresMissile then
    local path = DataCenter.AllianceGovernmentSkillManager:GetSkillBigIconBySkillType(AlOfficialSkillType.AresMissile)
    if jsonObj.skillId ~= nil and jsonObj.skillId > 0 then
      local skillConfig = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(jsonObj.skillId)
      if skillConfig and not string.IsNullOrEmpty(skillConfig.skill_show) then
        path = skillConfig.skill_show
      end
    end
    self.bodySprite:LoadSprite(path)
  elseif self.bodySprite and jsonObj and jsonObj.noticeType == 1 and _chat_data.post == PostType.GoddessMummy then
    local path = DataCenter.AllianceGovernmentSkillManager:GetSkillBigIconBySkillType(AlOfficialSkillType.GoddessMummy)
    if jsonObj.skillId ~= nil and jsonObj.skillId > 0 then
      local skillConfig = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(jsonObj.skillId)
      if skillConfig and not string.IsNullOrEmpty(skillConfig.skill_show) then
        path = skillConfig.skill_show
      end
    end
    self.bodySprite:LoadSprite(path)
  elseif self.bodySprite and jsonObj and jsonObj.noticeType == 4 and (_chat_data.post == PostType.ALLIANCE_SKILL_TESLACOIL_TIP or _chat_data.post == PostType.ALLIANCE_SKILL_REINFORCEMENT_TIP or _chat_data.post == PostType.ALLIANCE_SKILL_REFRESH_BALL_TIP or _chat_data.post == PostType.ALLIANCE_SKILL_ABUNDANT_HARVEST_TIP) then
    local path = "Assets/Main/Sprites/UI/UIChatAI/zyf_aijieruliaotian_renwu1.png"
    if jsonObj.skillId ~= nil and jsonObj.skillId > 0 then
      local skillConfig = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(jsonObj.skillId)
      if skillConfig and not string.IsNullOrEmpty(skillConfig.skill_show) then
        path = skillConfig.skill_show
      end
    end
    self.bodySprite:LoadSprite(path)
  elseif self.bodySprite and tabCityInfo and tabCityInfo.noticeType == 9 then
    self.bodySprite:LoadSpriteAuto("Assets/Main/Sprites/HeroIconsBig/world_monster_boss_big_new_S1_daodan.png")
  elseif self.bodySprite then
    self.bodySprite:LoadSprite("Assets/Main/Sprites/UI/UIChatAI/zyf_aijieruliaotian_renwu1.png")
  end
  if _chat_data.post == PostType.HelpMeAttackCityStronghold then
    self.iconEx:SetActive(false)
    self.message:SetMargin(0, 0, 0, 0)
  elseif _chat_data.post == PostType.ALLIANCE_INVITE_FRIEND then
    self.iconEx:SetActive(true)
    self.iconEx:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_icon_1_jiemeng.png")
    self.message:SetMargin(95, 0, 0, 0)
  elseif _chat_data.post == PostType.ALLIANCE_ASSISTANCE_FRIEND then
    self.iconEx:SetActive(true)
    self.iconEx:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_icon_1_jiemeng.png")
    self.message:SetMargin(95, 0, 0, 0)
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(jsonObj.cityId, jsonObj.serverId)
    if cityTemplate then
      self.bodySprite:LoadSpriteAuto(cityTemplate:GetIconPath())
    end
  else
    self.iconEx:SetActive(false)
    self.message:SetMargin(0, 0, 0, 0)
  end
  self.bodySprite:SetColor(ChatUIThemeConfig.ChatAIBodyColor[ChatInterface.GetChatTheme()])
  local isEmojiOn = isAIOpen == 1 and theRoomData ~= nil and theRoomData:IsEmojiOn() and _chat_data:isEmojiOnAndFromAI()
  local _message = _chat_data:getSuperParsedResult()
  if _message == nil then
    _message = _chat_data:getMessageWithExtra(false)
    _message = FindAndAppendLinkInfo(_message)
    _chat_data:setSuperParsedResult(_message)
  end
  self.message:SetActive(false)
  self.message:SetText(_message)
  self.message:SetColor(theSkin.txt_color[ChatInterface.GetChatTheme()])
  self.message:SetActive(true)
  self._customJsonData = jsonObj
  self._roomData = theRoomData
  if self.bgSprite ~= nil and theCharacterData ~= nil then
    self.bgSprite:LoadSprite(theCharacterData:GetMessageBgPath())
  end
  self:UpdateEmojiCell(theRoomData, theCharacterData, theSkin, isEmojiOn)
end

function ChatAIAssistantCell:UpdateEmojiCell(theRoomData, theCharacterData, theSkin, isEmojiOn)
  self.content:RemoveComponents(ChatAIAssistantEmojiItem)
  self.theCellItem:GameObjectRecycleAll()
  self.content:SetActive(isEmojiOn)
  if isEmojiOn and theRoomData ~= nil and theCharacterData ~= nil then
    local romMgr = ChatManager2:GetInstance().Room
    local ai_chat_send_emo_num = LuaEntry.DataConfig:TryGetNum("ai_chat_send_emo_num", "k1")
    local ai_chat_emo_max = LuaEntry.DataConfig:TryGetNum("ai_chat_emo_max", "k1")
    local emoji_mine_cache = romMgr:GetMineChatEmojiData(self._roomId, self._msgSeq)
    self.emoji_info = self._chatData.emoji_info or {}
    self.emoji_mine = emoji_mine_cache or {}
    local emoji_info = self.emoji_info
    local emoji_mine = self.emoji_mine
    local goItem, theEmojiItem, nameStr
    local emoji_array = DataCenter.LWChatAIManager:GetEmojiList()
    local emoji_key_values = DataCenter.LWChatAIManager:GetEmojiKeyValues()
    local emojiBgPath = theSkin.select_image
    local emojiCount = #emoji_info
    if self.bgSprite == nil then
      emojiBgPath = "Assets/Main/Sprites/UI/UIChatAI/zyf_aierliaotian_qipao_bantoudiban"
    end
    for _, v in ipairs(emoji_info) do
      nameStr = "Item" .. v.emoji_id
      goItem = self.theCellItem:GameObjectSpawn(self.content.transform)
      goItem.name = nameStr
      goItem:SetActive(true)
      theEmojiItem = self.content:AddComponent(ChatAIAssistantEmojiItem, nameStr)
      theEmojiItem:SetData(self, emoji_mine, v, emoji_key_values[v.emoji_id], emoji_array, emojiBgPath)
    end
    if emojiCount == 0 or ai_chat_emo_max > emojiCount and ai_chat_send_emo_num > #emoji_mine then
      nameStr = "ItemEmpty"
      goItem = self.theCellItem:GameObjectSpawn(self.content.transform)
      goItem.name = nameStr
      goItem:SetActive(true)
      theEmojiItem = self.content:AddComponent(ChatAIAssistantEmojiItem, nameStr)
      theEmojiItem:SetData(self, nil, nil, nil, emoji_array, nil)
    end
    if 0 < emojiCount and emoji_mine_cache == nil then
      SFSNetwork.SendMessage(MsgDefines.ChatGPTMessageLikeFetch, self._roomId, {
        self._chatData.seqId
      })
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  end
  if self.bgSprite == nil then
    return
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bgSprite.rectTransform)
  local fullHeight = self.bgSprite.rectTransform.sizeDelta.y
  self.messageLayoutGroup:SetPaddingTop(0)
  self.messageLayoutGroup:SetPaddingBottom(0)
  if theCharacterData ~= nil then
    local bodySmall = theCharacterData:GetMessageSmallIconPath()
    local bodyBig = theCharacterData:GetMessageBigIconPath()
    if fullHeight < 200 then
      self.rectTransform:Set_sizeDelta(DefaultScreenWidth, 180)
      self.bodySprite:LoadSprite(bodySmall)
      if not isEmojiOn and fullHeight < 120 then
        self.messageLayoutGroup:SetPaddingTop(12)
        self.messageLayoutGroup:SetPaddingBottom(12)
      end
    elseif 220 < fullHeight then
      self.bodySprite:LoadSprite(bodyBig)
      self.rectTransform:Set_sizeDelta(DefaultScreenWidth, math.max(280, fullHeight))
    else
      self.bodySprite:LoadSprite(bodySmall)
      self.rectTransform:Set_sizeDelta(DefaultScreenWidth, 220)
    end
    self.bodySprite:SetNativeSize()
  elseif not isEmojiOn and fullHeight < 120 then
    self.messageLayoutGroup:SetPaddingTop(12)
    self.messageLayoutGroup:SetPaddingBottom(12)
  end
end

function ChatAIAssistantCell:ReloadData()
  self._contentViewScript:RefreshScrollView()
  if self._chatIndex == self._contentViewScript:GetItemCount() then
    self._contentViewScript:OnMoveToBottom()
  end
end

function ChatAIAssistantCell:OnDestroy()
  self.content:RemoveComponents(ChatAIAssistantEmojiItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.iconEx = nil
  self.bgSprite = nil
  self.message = nil
  self.content = nil
  self.theCellItem = nil
  self.bodySprite = nil
  base.OnDestroy(self)
end

return ChatAIAssistantCell
