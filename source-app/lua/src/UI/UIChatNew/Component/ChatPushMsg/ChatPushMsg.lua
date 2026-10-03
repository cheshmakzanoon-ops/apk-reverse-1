local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatPushMsg = BaseClass("ChatPushMsg", base)
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

function ChatPushMsg:OnCreate()
  base.OnCreate(self)
  self.cellArea = self:AddComponent(UIBaseContainer, "")
  self.raw_image = self:AddComponent(UIRawImage, "Assistant/Role/RawImage")
  self.image = self:AddComponent(UIImage, "Assistant/Role/Image")
  self.bgSprite = self:AddComponent(UIImage, "Assistant")
  self.message = self:AddComponent(UITextMeshProUGUIEx, "Assistant/RichTextRoot/RichText")
  self.messageLayoutGroup = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "Assistant/RichTextRoot")
  self.message:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
end

function ChatPushMsg:OnDestroy()
  self.cellArea = nil
  self.raw_image = nil
  self.image = nil
  self.bgSprite = nil
  self.message = nil
  self.messageLayoutGroup = nil
  self.tmpEventTrigger = nil
  base.OnDestroy(self)
end

function ChatPushMsg:OnAddListener()
  base.OnAddListener(self)
end

function ChatPushMsg:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ChatPushMsg:OnPointerClick(clickPos)
  if self._chatData and self._chatData.post == PostType.NewAllianceRallyPoint and self._chatData.extra and self._chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(self._chatData.extra.customJsonParam)
    if jsonObj and jsonObj.pointId and jsonObj.serverId then
      local serverId = jsonObj.serverId
      local pointId = SceneUtils.BigIndexToStandardIndex(jsonObj.pointId)
      local v3 = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, serverId)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      end, serverId)
      return
    end
  end
  if self._chatData ~= nil then
    local isNeedCheckCrossServer = true
    local isInNineNationTruceMode = UIUtil.IsInNineNationTruceMode()
    local canCrossServer = UIUtil.CheckDetectCanCrossServer()
    if self._chatData.post == PostType.Detect_Treasure_Fin_Info and (canCrossServer or isInNineNationTruceMode) then
      isNeedCheckCrossServer = false
    end
    if isNeedCheckCrossServer and not LuaEntry.Player:IsLoginSourceServer() then
      UIUtil.ShowTipsId("season_tips166")
      return
    end
    if self._chatData.post == PostType.Detect_Treasure_Fin_Info then
      if self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam then
        local jsonObj = rapidjson.decode(self._chatData.extra.customJsonParam)
        if jsonObj and jsonObj.uuid then
          local uuid = jsonObj.uuid
          local targetServer = jsonObj.targetServer
          SFSNetwork.SendMessage(MsgDefines.DetectEventGetTreasureClaimInfo, uuid, nil, targetServer)
        end
      end
    elseif self._chatData.post == PostType.MONSTER_INVASION_BIG_BOSS then
      if self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam then
        local jsonObj = rapidjson.decode(self._chatData.extra.customJsonParam)
        if jsonObj and jsonObj.pointId then
          DataCenter.ActivityMonsterInvasionDataManager:JumpToBossPoint(jsonObj.pointId)
        end
      end
    elseif self._chatData.post == PostType.DiggingGameShareAlliance then
      if self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam then
        local jsonObj = rapidjson.decode(self._chatData.extra.customJsonParam)
        if jsonObj and jsonObj.uuid then
          DataCenter.DiggingDataManager:OpenDiggingMap(jsonObj.uuid, jsonObj.uid, SeasonDigGameType.Alliance)
        end
      end
    elseif self._chatData.post == PostType.OffSeasonDiggingGameShareAlliance then
      if self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam then
        local jsonObj = rapidjson.decode(self._chatData.extra.customJsonParam)
        if jsonObj and jsonObj.uuid then
          DataCenter.OffSeasonDiggingDataManager:OpenDiggingMap(jsonObj.uuid)
        end
      end
    elseif self._chatData.post == PostType.ALLIANCE_MONSTER_CHALLENGE_NEW_BATTLE and self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam then
      local jsonObj = rapidjson.decode(self._chatData.extra.customJsonParam)
      if jsonObj and jsonObj.pointId then
        local pointId = jsonObj.pointId
        DataCenter.ActivityKillZombieManager:GotoWorldPos(pointId)
      end
    end
  end
end

function ChatPushMsg:SetIcon(path)
  if path then
    self.image:LoadSpriteAsync(path)
  end
  self.image:SetActive(true)
  self.raw_image:SetActive(false)
end

function ChatPushMsg:SetRawIcon(path)
  if path then
    self.raw_image:LoadSpriteAsync(path)
  end
  self.raw_image:SetActive(true)
  self.image:SetActive(false)
end

function ChatPushMsg:UpdateItem(_chat_data, _index)
  self:SetRawIcon("Assets/Main/TextureEx/UILWRadarCenter/zyf_leida_wajueji.png")
  local theRoomData
  self._chatIndex = _index
  self._chatData = _chat_data
  self._roomId = _chat_data.roomId
  self._msgSeq = tostring(self._chatData.seqId)
  local _message = _chat_data:getSuperParsedResult()
  if _message == nil then
    _message = _chat_data:getMessageWithExtra(false)
  end
  self.message:SetActive(false)
  self.message:SetText(_message)
  self.message:SetActive(true)
  if self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(self._chatData.extra.customJsonParam)
    if _chat_data.post == PostType.Detect_Treasure_Fin_Info then
      if jsonObj and jsonObj.eventId then
        local eventId = jsonObj.eventId
        local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventId)
        if template then
          local digIcon
          if template.type == DetectEventType.TREASURE then
            digIcon = DataCenter.ActivityListDataManager:GetActivityRadarDigImage()
          end
          if self.bodySprite then
            self.bodySprite:LoadSpriteAsync(digIcon and digIcon or template:GetDetectEventBannerImagePath())
          else
            self:SetRawIcon(digIcon and digIcon or template:GetDetectEventBannerImagePath())
          end
        end
      end
    elseif _chat_data.post == PostType.NewAllianceRallyPoint then
      if jsonObj.markType == MarkType.Alliance_rally then
        self:SetIcon("Assets/Main/Sprites/UI/UIAllianceMark/zyf_lianmengjijiedian_biaoji.png")
      else
        self:SetIcon("Assets/Main/Sprites/UI/UIAllianceMark/zyf_lianmengjijiedian_biaoji 1.png")
      end
    elseif _chat_data.post == PostType.MONSTER_INVASION_BIG_BOSS then
      local actData = DataCenter.ActivityMonsterInvasionDataManager:GetActivityData()
      if actData and actData.chatIcon then
        self:SetRawIcon(actData.chatIcon)
      end
    elseif _chat_data.post == PostType.DiggingGameShareAlliance then
      local uid = jsonObj.uid
      local allianceMember = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid)
      local name = allianceMember and DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(allianceMember.uid, allianceMember.name) or ""
      self.message:SetText(CS.GameEntry.Localization:GetString("season_activity_1000070_desc22", name))
      self:SetRawIcon(string.format(LoadPath.UIDiggingTex, "ljq_saijis3_yindiannaqiongsi_rukou_03"))
    elseif _chat_data.post == PostType.OffSeasonDiggingGameShareAlliance then
      local uid = jsonObj.uid
      local allianceMember = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid)
      local name = allianceMember and DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(allianceMember.uid, allianceMember.name) or ""
      self.message:SetText(CS.GameEntry.Localization:GetString("parkour_260_desc22", name))
      self:SetRawIcon(string.format(LoadPath.UIOffSeasonDiggingTexturePath, "ljq_s4_icon_qiaozhuankuai_rukou_01"))
    elseif _chat_data.post == PostType.ALLIANCE_MONSTER_CHALLENGE_NEW_BATTLE then
      local configId
      if jsonObj and jsonObj.configId then
        configId = jsonObj.configId
      end
      if configId then
        local bossId = GetTableData(TableName.activity_challenge_zombie, configId, "advanced_challenge_boss")
        if bossId then
          local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(bossId)
          local chat_icon = template and template.chat_icon
          if chat_icon ~= nil and chat_icon ~= "" then
            self:SetRawIcon(chat_icon)
          end
        end
      end
    end
  end
end

return ChatPushMsg
