local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local UILWChatGetDoubleRewardMsg = BaseClass("UILWChatGetDoubleRewardMsg", base)
local rapidjson = require("rapidjson")
local hasIconWidth = 540
local notIconWidth = 590
local hight = 60
local content_path = "Content"
local ui_player_head_path = "Content/UIPlayerHead"
local player_name_text_path = "Content/PlayerNameText"
local player_name_outline_text_path = "Content/PlayerNameText_outline"
local des_text_path = "Content/DesText"
local des_outline_text_path = "Content/DesText_outline"
local btn_path = "Content/Btn"
local defPath = "Assets/Main/TextureEx/UILWRadarCenter/mjc_liaotian_jinli_bg01.png"

function UILWChatGetDoubleRewardMsg:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWChatGetDoubleRewardMsg:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWChatGetDoubleRewardMsg:ComponentDefine()
  self.ui_player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.player_name_outline_text = self:AddComponent(UITextMeshProUGUIEx, player_name_outline_text_path)
  self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
  self.des_outline_text = self:AddComponent(UITextMeshProUGUIEx, des_outline_text_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.bg = self:AddComponent(UIRawImage, "Content")
  self.btn:SetOnClick(function()
    self:BtnClick()
  end)
  self.bg:SetColor(ChatUIThemeConfig.ChatAIBodyColor[ChatInterface.GetChatTheme()])
  self._headCanvasGroup = self:AddComponent(UICanvasGroup, ui_player_head_path)
  self._headCanvasGroup:SetAlpha(ChatUIThemeConfig.HeadAlpha[ChatInterface.GetChatTheme()])
  self.multipleImage = self:AddComponent(UIImage, "Content/multipleImage")
end

function UILWChatGetDoubleRewardMsg:ComponentDestroy()
  self.ui_player_head = nil
  self.player_name_text = nil
  self.des_text = nil
  self.btn = nil
  self.player_name_outline_text = nil
  self.des_outline_text = nil
  self.multipleImage = nil
end

function UILWChatGetDoubleRewardMsg:UpdateItem(_chat_data, _index)
  self._chatData = _chat_data
  self.des_text:SetLocalText("radar_tips_7")
  self.bg:LoadSprite(defPath)
  self:ShowOutLineName(false)
  self.player_name_text:SetColorHex("#693600")
  self.des_text:SetColorHex("#693600")
  self.multipleImage:SetActive(false)
  if _chat_data and _chat_data.extra and _chat_data.extra.customJsonParam then
    local jsonObj = rapidjson.decode(_chat_data.extra.customJsonParam)
    if jsonObj then
      local uid
      if jsonObj.bigRewardInfo then
        local rewardInfo = jsonObj.bigRewardInfo
        uid = rewardInfo.uid
        local playerName = rewardInfo.name
        local pic = ""
        local picVer = 0
        local headSkinId, headSkinET
        local bigRewardMultiple = 0
        local bigRewardClaimOrder = 0
        if rewardInfo.headPic then
          pic = rewardInfo.headPic
        end
        if rewardInfo.headPicVer then
          picVer = rewardInfo.headPicVer
        end
        if rewardInfo.headSkinId then
          headSkinId = rewardInfo.headSkinId
        end
        if rewardInfo.headSkinET then
          headSkinET = rewardInfo.headSkinET
        end
        if jsonObj.haveLuckyBuff == true then
          self.des_text:SetLocalText("luckyBuff_desc_diggerReward", jsonObj.bigRewardMultiple or 3)
        end
        if jsonObj.treasureType and jsonObj.treasureType == WorldTreasureType.OffSeasonDetect then
          if jsonObj.bigRewardMultiple then
            bigRewardMultiple = jsonObj.bigRewardMultiple
            self.des_outline_text:SetLocalText("s1_qingdian_double_banner_chat", bigRewardMultiple)
            local bannerName = DataCenter.ActDetectTreasureDataManager:GetBannerNameByMultiple(bigRewardMultiple)
            if not string.IsNullOrEmpty(bannerName) then
              self.bg:LoadSpriteAsync(bannerName)
            end
            local iconName = RewardMultipleIcon[bigRewardMultiple]
            if iconName then
              self.multipleImage:SetActive(true)
              self.multipleImage:LoadSprite(string.format(LoadPath.RadarCenterPath, iconName))
            end
          end
          self:ShowOutLineName(true)
        end
        if jsonObj.bigRewardClaimOrder then
          bigRewardClaimOrder = jsonObj.bigRewardClaimOrder
        end
        local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, playerName)
        self.player_name_text:SetText(showName)
        self.player_name_outline_text:SetText(showName)
        self.ui_player_head:SetHeadAndFrame(uid, pic, picVer, nil, headSkinId, headSkinET)
        self.ui_player_head:SetEnableClickShowInfo(true, true)
      end
      if _chat_data.post == PostType.BestReward then
        if jsonObj.senderInfo then
          local palyerInfo = jsonObj.senderInfo
          local playerName = palyerInfo.name
          if jsonObj.packetId then
            local temp = DataCenter.RedPacketTemplateManager:GetTemplate(jsonObj.packetId)
            if palyerInfo.uid == uid then
              self.des_text:SetLocalText(temp.mySendKey)
            else
              self.des_text:SetLocalText(temp.otherSendKey, playerName)
            end
            self.des_text:SetPreferSize({x = hasIconWidth, y = hight})
            self.bg:LoadSprite(temp.GetRawImgPath(temp.luky_pic))
          end
        end
        self.btn:SetActive(false)
      elseif _chat_data.post == PostType.ZOMBIE_RUSH_ELITE_ALTER_BOSS_REWARD then
        local name
        if jsonObj.monsterId then
          local monsterId = jsonObj.monsterId
          name = GetTableData(TableName.Monster, monsterId, "name")
          name = CS.GameEntry.Localization:GetString(name)
        end
        self.des_text:SetLocalText("zombierush_eliteBoss_alter_succeed", name)
        self.des_text:SetPreferSize({x = hasIconWidth, y = hight})
        self.btn:SetActive(true)
      elseif _chat_data.post == PostType.FIREWORK_GIFT_REWARD_DOUBLE then
        self.des_text:SetLocalText("firework_interface_1010", jsonObj.sendName)
        self.des_text:SetPreferSize({x = notIconWidth, y = hight})
        self.btn:SetActive(true)
        self.player_name_text:SetText(jsonObj.name)
        self.player_name_text:SetColorHex("#4b096d")
        self.des_text:SetColorHex("#4b096d")
        self.ui_player_head:SetHeadAndFrame(jsonObj.uid, jsonObj.pic, jsonObj.picVer, nil, jsonObj.headSkinId, jsonObj.headSkinET)
        self.ui_player_head:SetEnableClickShowInfo(true, true)
        self.bg:LoadSprite("Assets/Main/TextureEx/ChatRedPacket/mjc_liaotian_yanhua_x2_bg01.png")
      else
        self.des_text:SetPreferSize({x = notIconWidth, y = hight})
        self.btn:SetActive(true)
      end
    end
  end
end

function UILWChatGetDoubleRewardMsg:BtnClick()
  if self._chatData.post == PostType.BestReward then
    return
  end
  if self._chatData.post == PostType.FIREWORK_GIFT_REWARD_DOUBLE then
    local jsonObj = rapidjson.decode(self._chatData.extra.customJsonParam)
    if jsonObj then
      local viewData = {
        uuid = jsonObj.uuid,
        ownerUid = jsonObj.uid
      }
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local existTime = LuaEntry.DataConfig:TryGetNum("fireworks", "k2", 120)
      local expiredTime = tonumber(self._chatData.serverTime + existTime * 60 * 1000) or 0
      local time = expiredTime - curTime
      if time <= 0 then
        UIUtil.ShowTipsId("alliance_duel_gacha_tips_1018")
        return
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFireworkGiftRecord, {anim = true}, viewData)
    end
    return
  end
  local isInNineNationTruceMode = UIUtil.IsInNineNationTruceMode()
  if not UIUtil.CheckDetectCanCrossServer() and not isInNineNationTruceMode and not LuaEntry.Player:IsLoginSourceServer() then
    UIUtil.ShowTipsId("season_tips166")
    return
  end
  if self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(self._chatData.extra.customJsonParam)
    if jsonObj then
      local uuid = jsonObj.uuid
      local targetServer = jsonObj.targetServer
      if not string.IsNullOrEmpty(uuid) then
        SFSNetwork.SendMessage(MsgDefines.DetectEventGetTreasureClaimInfo, uuid, nil, targetServer)
        return
      end
    end
  end
  if self._chatData and self._chatData.post == PostType.ZOMBIE_RUSH_ELITE_ALTER_BOSS_REWARD and self._chatData.extra and self._chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(self._chatData.extra.customJsonParam)
    if jsonObj then
      local zombieRushId = jsonObj.zombieRushId
      local infoList = jsonObj.infoList
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZREliteBossRewardInfoView, {anim = true}, {zombieRushId = zombieRushId, infoList = infoList})
    end
  end
end

function UILWChatGetDoubleRewardMsg:ShowOutLineName(isShow)
  self.des_text:SetActive(not isShow)
  self.des_outline_text:SetActive(isShow)
  self.player_name_text:SetActive(not isShow)
  self.player_name_outline_text:SetActive(isShow)
end

return UILWChatGetDoubleRewardMsg
