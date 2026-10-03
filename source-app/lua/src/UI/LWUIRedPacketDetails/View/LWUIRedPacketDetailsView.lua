local LWUIRedPacketDetailsView = BaseClass("LWUIRedPacketDetailsView", UIBaseView)
local UILWParticipantItem = require("UI.LWUIRedPacketDetails.Component.UILWParticipantItem")
local base = UIBaseView
local key = "redPackSendthank"
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local BirthdayBtnItem = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Bottom.Btns.BirthdayBtnItem")
local red_packet_path = "RedPacket"
local like_text_path = "bottomBtnContent/likeBtn/likeText"
local gift_btn_path = "bottomBtnContent/giftBtn"
local gift_btn_text_path = "bottomBtnContent/giftBtn/giftBtnText"

function LWUIRedPacketDetailsView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function LWUIRedPacketDetailsView:ComponentDefine()
  self.playerHead = self:AddComponent(UICommonHead, "RedPacket/UIPlayerHead")
  self.playerName = self:AddComponent(UITextMeshProUGUIEx, "RedPacket/playerName")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "RedPacket/title")
  self.playerCountText = self:AddComponent(UITextMeshProUGUIEx, "RedPacket/playerCount")
  self.rewardCountText = self:AddComponent(UITextMeshProUGUIEx, "RedPacket/rewardCount")
  self.rewardIcon = self:AddComponent(UIImage, "RedPacket/rewardIcon")
  self.sendBtn = self:AddComponent(UIButton, "sendBtn")
  self.sendBtnText = self:AddComponent(UITextMeshProUGUIEx, "sendBtn/sendText")
  self.sendBtnText:SetLocalText("451020")
  self.panelBtn = self:AddComponent(UIButton, "Panel")
  self.optionCom = self:AddComponent(UIBaseContainer, "option")
  self.optionBtn = self:AddComponent(UIButton, "option/optionBtn")
  self.optionIcon = self:AddComponent(UIImage, "option/optionBtn/optionIcon")
  self.optionText = self:AddComponent(UITextMeshProUGUIEx, "option/optionText")
  self.getText = self:AddComponent(UITextMeshProUGUIEx, "getText")
  self.effectObj = self:AddComponent(UIBaseContainer, "effectObj")
  self.effectCfg = self:AddComponent(UIBaseContainer, "effectCfg")
  self.optionText:SetLocalText("red_pocket_desc17")
  self.getText:SetLocalText("170003")
  self.closeBtn = self:AddComponent(UIButton, "BtnClose")
  self.likeBtnIcon = self:AddComponent(UIImage, "bottomBtnContent/likeBtn/Bg/Icon")
  self.likeBtnIconObj = self:AddComponent(UIBaseContainer, "bottomBtnContent/likeBtn/Bg/Icon")
  self.likeBtn = self:AddComponent(UIButton, "bottomBtnContent/likeBtn")
  self.likeBtn:SetOnClick(function()
    if self.param and self.param.sendUid and self.param.sendUid ~= LuaEntry.Player.uid and self.redPocketTemp and self.redPocketTemp.like_type == 1 then
      local roomData = ChatInterface.getRoomData(self.param.roomId)
      local chatData = roomData:getChatDataBySeqId(self.param.seqId)
      if chatData == nil then
        return
      end
      local channelType = 0
      if chatData.group == ChatGroupType.GROUP_ALLIANCE then
        channelType = DataCenter.RedPacketManager.ChannelType.Alliance
      elseif chatData.group == ChatGroupType.GROUP_SEASON_ROOM then
        channelType = DataCenter.RedPacketManager.ChannelType.Season
      elseif chatData.group == ChatGroupType.GROUP_COUNTRY then
        channelType = DataCenter.RedPacketManager.ChannelType.World
      elseif chatData.group == ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM then
        channelType = DataCenter.RedPacketManager.ChannelType.AliFriend
      end
      local seqId = chatData.seqId
      local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
      local packetId = jsonObj and jsonObj.packetId
      local serverId = jsonObj.serverId or 0
      local extra = string.format("%s|%s|%s|%s|%s|%s", tostring(self.param.uuid), tostring(self.param.roomId), tostring(seqId), tostring(packetId), tostring(channelType), tostring(serverId))
      local thumbsUpType = InteractiveUtil.ThumbsUpType.GoldenEgg
      local identifier = "GoldenEgg"
      if self.redPocketTemp.type == RedPacketType.Birthday then
        thumbsUpType = InteractiveUtil.ThumbsUpType.BirthdayRedPacket
        identifier = nil
      elseif self.redPocketTemp.type == RedPacketType.LuckyBuff or self.redPocketTemp.type == RedPacketType.LuckyWithoutBuff then
        thumbsUpType = InteractiveUtil.ThumbsUpType.AllianceLuckSiphonRedPacket
        identifier = nil
      end
      InteractiveUtil.TryThumbsUp(self.param.sendUid, thumbsUpType, identifier, function()
        if self.redPocketTemp.type == RedPacketType.LuckyBuff or self.redPocketTemp.type == RedPacketType.LuckyWithoutBuff then
          UIUtil.ShowTipsId("like_tips_redpacket_6")
        else
          UIUtil.ShowTipsId("activity_sports_uitips_021")
        end
      end, extra)
    end
  end)
  self.sendBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.optionBtn:SetOnClick(function()
    self.isSend = not self.isSend
    self:RefreshOptionState()
  end)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.participantScrollView = self:AddComponent(UIScrollView, "RedPacket/scrollView_participant")
  self.participantScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.participantScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.red_packet = self:AddComponent(UIRawImage, red_packet_path)
  self.like_text = self:AddComponent(UITextMeshProUGUIEx, like_text_path)
  self.gift_btn = self:AddComponent(UIButton, gift_btn_path)
  self.gift_btn_text = self:AddComponent(UITextMeshProUGUIEx, gift_btn_text_path)
  self.like_text:SetLocalText("thumbs_up_player_city")
  self.gift_btn_text:SetLocalText("birthday_tips_26")
  self.gift_btn:SetOnClick(function()
    self:OnGiftBtnClick()
  end)
end

function LWUIRedPacketDetailsView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BirthdayThumbsUpAniFin, self.OnBirthdayThumbsUpAniFin)
end

function LWUIRedPacketDetailsView:OnRemoveListener()
  self:RemoveUIListener(EventId.BirthdayThumbsUpAniFin, self.OnBirthdayThumbsUpAniFin)
  base.OnRemoveListener(self)
end

function LWUIRedPacketDetailsView:OnSendBtnClick()
end

function LWUIRedPacketDetailsView:ShowScroll()
  self:ClearScroll()
  if self.param.buffReceiverUid ~= nil then
    self.param.detail = self.ctrl.InitLuckyPacketPlayers(self.param.detail, self.param.buffReceiverUid)
  else
    self.param.detail = self.ctrl.InitPlayers(self.param.detail, self.redPocketTemp.num)
  end
  local index = 1
  local count = #self.param.detail
  for i, v in pairs(self.param.detail) do
    if tostring(v.uid) == tostring(LuaEntry.Player.uid) then
      index = i
      break
    end
  end
  self.participantScrollView:SetTotalCount(count)
  if 0 < count then
    self.participantScrollView:RefillCells(index, true)
  end
end

function LWUIRedPacketDetailsView:ClearScroll()
  self.participantScrollView:ClearCells()
  self.participantScrollView:RemoveComponents(UILWParticipantItem)
end

function LWUIRedPacketDetailsView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.participantScrollView:AddComponent(UILWParticipantItem, itemObj)
  self.param.detail[index].redPocketTemp = self.redPocketTemp
  item:Refresh(self.param.detail[index])
end

function LWUIRedPacketDetailsView:OnDeleteCell(itemObj, index)
  self.participantScrollView:RemoveComponent(itemObj.name, UILWParticipantItem)
end

function LWUIRedPacketDetailsView:ComponentDestroy()
  self.playerHead = nil
  self.playerName = nil
  self.titleText = nil
  self.playerCountText = nil
  self.rewardCountText = nil
  self.rewardIcon = nil
  self.sendBtn = nil
  self.sendBtnText = nil
  self.closeBtn = nil
  self.optionCom = nil
  self.optionBtn = nil
  self.optionIcon = nil
  self.optionText = nil
  self.optionText = nil
  self.red_packet = nil
  self.like_text = nil
  self.gift_btn = nil
  self.gift_btn_text = nil
end

function LWUIRedPacketDetailsView:RefreshOptionState()
  self.optionIcon:SetActive(self.isSend)
end

function LWUIRedPacketDetailsView:ReInit()
  self.param = self:GetUserData()
  local count = 0
  local hasMyself = false
  for i, info in pairs(self.param.detail) do
    count = count + info.count
    if tostring(info.uid) == tostring(LuaEntry.Player.uid) then
      hasMyself = true
    end
  end
  self.redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplate(self.param.goodsId)
  if not self.redPocketTemp then
    self.redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplateByGoodsId(self.param.goodsId)
  end
  local isHaveCfgEffect = not string.IsNullOrEmpty(self.redPocketTemp.fx_hongbao)
  self.effectObj:SetActive(not isHaveCfgEffect)
  self.effectCfg:SetActive(isHaveCfgEffect)
  self.playerCountText:SetLocalText("red_pocket_desc14", #self.param.detail, self.redPocketTemp.num)
  if self.redPocketTemp.type == 3 and self.param.setGold then
    self.rewardCountText:SetText(count .. "/" .. self.param.setGold)
  else
    self.rewardCountText:SetText(count .. "/" .. self.redPocketTemp.reward.num)
  end
  self.senderUserInfo = ChatManager2:GetInstance().User:getChatUserInfo(self.param.sendUid)
  self.rewardIcon:LoadSpriteAuto(self.redPocketTemp.reward.pic)
  self.playerHead:SetHeadAndFrame(self.senderUserInfo.uid, self.senderUserInfo.headPic, self.senderUserInfo.headPicVer, false, self.senderUserInfo.headSkinId, self.senderUserInfo.headSkinET)
  local sendPlayerSrcServerId = self.senderUserInfo.srcServer
  local receivePlayerSrcServerId = LuaEntry.Player:GetSourceServerId()
  local isShowRedName = false
  if sendPlayerSrcServerId ~= nil and sendPlayerSrcServerId ~= 0 and receivePlayerSrcServerId ~= nil and receivePlayerSrcServerId ~= 0 then
    isShowRedName = sendPlayerSrcServerId ~= receivePlayerSrcServerId
  end
  if isShowRedName then
    local showName = "#" .. tostring(sendPlayerSrcServerId) .. " " .. DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.senderUserInfo.uid, self.senderUserInfo.userName)
    self.playerName:SetText(showName)
    self.playerName:SetColor(Color.red)
  else
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.senderUserInfo.uid, self.senderUserInfo.userName)
    self.playerName:SetText(showName)
    self.playerName:SetColor(Color.black)
  end
  self.titleText:SetLocalText(self.redPocketTemp:GetName())
  self.isSend = CommonUtil.PlayerPrefsGetBool(key, self.redPocketTemp.init_send == 1)
  local isShowLike = false
  if self.redPocketTemp and self.redPocketTemp.like_type == 1 and tostring(self.param.sendUid) ~= tostring(LuaEntry.Player.uid) then
    isShowLike = true
  end
  self.likeBtn:SetActive(isShowLike)
  local isShowGift = false
  if self.redPocketTemp and self.redPocketTemp.gift_type == 1 and tostring(self.param.sendUid) ~= tostring(LuaEntry.Player.uid) then
    isShowGift = true
  end
  self.gift_btn:SetActive(isShowGift)
  if isShowLike then
    self.likeBtnIcon:SetEnable(true)
    self:DestroyBirthdayBtn()
    if self.redPocketTemp.type == RedPacketType.Birthday then
      self.like_text:SetLocalText("birthday_tips_25")
      self.likeBtnIcon:SetEnable(false)
      self:TryShowBirthdayBtn(self.senderUserInfo)
    else
      self.likeBtnIcon:LoadSpriteAsyncWithCallback("Assets/Main/Sprites/UI/UIChatNew1/icon_great_light.png", function()
        if self.likeBtnIcon == nil then
          return
        end
        self.likeBtnIcon:SetNativeSize()
      end)
      self.like_text:SetLocalText("thumbs_up_player_city")
    end
  end
  self.optionCom:SetActive(false)
  self.sendBtn:SetActive(not hasMyself and not self.param.isDetails)
  self.getText:SetActive(hasMyself or self.param.isDetails)
  if hasMyself then
    self.getText:SetLocalText("170003")
  else
    self.getText:SetLocalText("red_pocket_desc7")
  end
  self:RefreshOptionState()
  self:ShowScroll()
  local bgImgName = "FX_ui_HB_hongbao03"
  if self.redPocketTemp and not string.IsNullOrEmpty(self.redPocketTemp.pic_tanban) then
    bgImgName = self.redPocketTemp.pic_tanban
  end
  local bgImgPath = "Assets/Main/TextureEx/ChatRedPacket/" .. bgImgName
  self.red_packet:LoadSpriteAuto(bgImgPath)
  self:TryLoadCfgEffect()
end

function LWUIRedPacketDetailsView:TryShowBirthdayBtn(data)
  local btnPrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/PlayerDetailBtnPrefab/birthdayBtn.prefab"
  self.prefabBirthdayBtnReq = self:GameObjectInstantiateAsync(btnPrefabPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.likeBtnIconObj.transform)
    local btnItem = self.likeBtnIconObj:AddComponent(BirthdayBtnItem, go)
    btnItem:SetActive(true)
    btnItem:SetLocalScaleXYZ(0.7, 0.7, 0.7)
    btnItem:SetLocalPositionXYZ(0, 0, 0)
    self.birthdayBtnItem = btnItem
    self:OnRefreshBirthdayBtn()
  end)
end

function LWUIRedPacketDetailsView:DestroyBirthdayBtn()
  self.likeBtnIconObj:RemoveComponents(BirthdayBtnItem)
  if self.prefabBirthdayBtnReq then
    self:GameObjectDestroy(self.prefabBirthdayBtnReq)
    self.prefabBirthdayBtnReq = nil
    self.birthdayBtnItem = nil
  end
end

function LWUIRedPacketDetailsView:OnBirthdayThumbsUpAniFin()
  self:OnRefreshBirthdayBtn()
end

function LWUIRedPacketDetailsView:OnRefreshBirthdayBtn()
  if self.birthdayBtnItem then
    self.birthdayBtnItem:SetData(nil, self.param)
    self.like_text.unity_tmpro:ForceMeshUpdate()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.likeBtn.transform)
    local curScaleX = self.birthdayBtnItem:GetLocalScaleXYZ()
    local curSizeX, curSizeY = self.likeBtn:GetSizeDeltaXY()
    self.birthdayBtnItem.click_arean:SetSizeDeltaXY(curSizeX / curScaleX, curSizeY / curScaleX)
    self.birthdayBtnItem.click_arean:SetPosition(self.likeBtn:GetPosition())
  end
end

function LWUIRedPacketDetailsView:OnDestroy()
  self:TryDestroyCfgEffect()
  self:DestroyBirthdayBtn()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIRedPacketDetailsView:OnEnable()
  base.OnEnable(self)
end

function LWUIRedPacketDetailsView:OnDisable()
  base.OnDisable(self)
end

function LWUIRedPacketDetailsView:DataDefine()
end

function LWUIRedPacketDetailsView:DataDestroy()
  CommonUtil.PlayerPrefsSetBool(key, self.isSend)
end

function LWUIRedPacketDetailsView:OnGiftBtnClick()
  if self.param and self.param.sendUid and self.param.sendUid ~= LuaEntry.Player.uid then
    DataCenter.GiftSystemManager:OpenOperationView({
      windowType = GiftSystemConst.WindowType.Send,
      targetUid = self.param.sendUid
    })
  end
end

function LWUIRedPacketDetailsView:TryLoadCfgEffect()
  self:TryDestroyCfgEffect()
  if self.redPocketTemp and not string.IsNullOrEmpty(self.redPocketTemp.fx_hongbao) then
    local effectPath = self.redPocketTemp.fx_hongbao
    self.cfgEffectReq = self:GameObjectInstantiateAsync(effectPath, function(request)
      if request.isError then
        return
      end
      local effectObj = request.gameObject
      if IsNull(effectObj) then
        return
      end
      effectObj.transform:SetParent(self.effectCfg.transform)
      local rectTransform = effectObj:GetComponent(typeof(CS.UnityEngine.RectTransform))
      if not IsNull(rectTransform) then
        rectTransform:Set_anchorMin(0.5, 0.5)
        rectTransform:Set_anchorMax(0.5, 0.5)
        rectTransform:Set_pivot(0.5, 0.5)
        rectTransform:Set_anchoredPosition(0, 0)
        rectTransform:Set_localScale(1, 1, 1)
      end
      effectObj:SetActive(true)
    end)
  end
end

function LWUIRedPacketDetailsView:TryDestroyCfgEffect()
  if self.cfgEffectReq then
    self:GameObjectDestroy(self.cfgEffectReq)
    self.cfgEffectReq = nil
  end
end

return LWUIRedPacketDetailsView
