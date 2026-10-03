local MomentLikePlayersItem = BaseClass("MomentLikePlayersItem", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "Bg/Leftpart/TxtLikeNum",
    name = "txtLikeNum",
    type = UIText
  },
  {
    path = "Bg/Leftpart/ImgLike",
    name = "ImgLike",
    type = UIImage
  },
  {
    path = "Bg",
    name = "bgImg",
    type = UIImage
  },
  {
    path = "Bg/Line",
    name = "BottomLine",
    type = UIBaseComponent
  },
  {
    path = "Bg/RightPart/PlayerIconList",
    name = "RootPlayerIconList",
    type = UIBaseContainer
  },
  {
    path = "Bg/RightPart/PlayerIconList/BtnMorePlayer",
    name = "BtnMorePlayer",
    type = UIButton,
    onClick = function(self)
      self:OnClickMorePlayer()
    end
  },
  {
    path = "Bg/RightPart/PlayerIconList/BtnMorePlayer",
    name = "morePlayerBg",
    type = UIImage
  },
  {
    path = "MoreBtn",
    name = "moreBtn",
    type = UIButton,
    onClick = function(self)
      self:OnMoreBtnClick()
    end
  }
}
local maxCunt = 13
local upImg = "Moment/zyf_pyq_dianzai_icon"
local upFinImg = "Moment/zyf_pyq_yidianzai_icon"

function MomentLikePlayersItem:OnCreate()
  base.OnCreate(self)
  self:DefineCompsByBook(compBook)
  self.bgImg:SetColorHex(ChatUIThemeConfig.MomentColor[ChatInterface.GetChatTheme()].momentImgBg)
  self.playHeadScript = {}
  self.itemIndex = 0
  self.goUIPlayerHead = self.transform:Find("Bg/RightPart/PlayerIconList/UIPlayerHead").gameObject
  self.goUIPlayerHead:GameObjectCreatePool()
end

function MomentLikePlayersItem:OnDestroy()
  self:ClearItemCell()
  self:ClearCompsByBook(compBook)
  self.itemIndex = 0
  base.OnDestroy(self)
end

function MomentLikePlayersItem:OnAddListener()
  self:AddUIListener(EventId.PlayerMessageInfo, self.RefreshPlayerInfo)
end

function MomentLikePlayersItem:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.RefreshPlayerInfo)
end

function MomentLikePlayersItem:OnMoreBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerThumbsUpHistory, {anim = true}, {
    type = "friendCircle",
    roomId = self.view.circleCommentRoomId
  })
end

function MomentLikePlayersItem:InitData(chatData)
  self.chataData = {}
  self.likeNum = 442
  self.playerUidList = chatData.players
end

function MomentLikePlayersItem:RefreshView(chatData)
  self:InitData(chatData)
  self:RefreshPlayerList()
  self:CalculateTotolHeight()
end

function MomentLikePlayersItem:SetContentViewScript()
end

function MomentLikePlayersItem:UpdateItem(chatData, index)
  self.index = index
  self:InitData(chatData)
  self:RefreshPlayerList()
  self:CalculateTotolHeight()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.RootPlayerIconList.rectTransform)
  self:UpdateSize()
  self.txtLikeNum:SetText(chatData.likeCount)
  self.txtLikeNum:SetColorHex(ChatUIThemeConfig.MomentColor[ChatInterface.GetChatTheme()].countText)
  local index = ChatUIThemeConfig.ChatMode.Normal
  local isSelfLike = false
  local selfPlayerUid = LuaEntry.Player.uid
  if self.playerUidList and #self.playerUidList > 0 then
    for i = 1, #self.playerUidList do
      local playerUid = self.playerUidList[i]
      if playerUid == selfPlayerUid then
        isSelfLike = true
        break
      end
    end
  end
  if isSelfLike then
    self.ImgLike:LoadSprite(ChatUIThemeConfig.UIPrefix[index] .. upFinImg)
  else
    self.ImgLike:LoadSprite(ChatUIThemeConfig.UIPrefix[index] .. upImg)
  end
  self.morePlayerBg:SetColorHex(ChatUIThemeConfig.MomentColor[ChatInterface.GetChatTheme()].morePlayerBg)
end

function MomentLikePlayersItem:SetContentViewScript(chatMainView)
  self._contentViewScript = chatMainView
end

function MomentLikePlayersItem:UpdateSize()
  local posy = self.RootPlayerIconList:GetSizeDelta().y
  self.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, posy + 85)
  self._contentViewScript._scrollView.unity_looplistview2:OnItemSizeChanged(self.index)
end

function MomentLikePlayersItem:RefreshPlayerList()
  if self.playerUidList == nil or #self.playerUidList <= 0 then
    return
  end
  self:ClearItemCell()
  local finalShowPlayerNum = #self.playerUidList > maxCunt and maxCunt or #self.playerUidList
  for i = 1, finalShowPlayerNum do
    local item = self.goUIPlayerHead.gameObject:GameObjectSpawn(self.RootPlayerIconList.transform)
    self.itemIndex = self.itemIndex + 1
    item.name = tostring(self.itemIndex)
    local script = self.RootPlayerIconList:AddComponent(UICommonHead, item.name)
    script:SetActive(true)
    local maskAlpha = ChatInterface.GetChatTheme() == ChatUIThemeConfig.ChatMode.Night and 0.3 or 0
    ChatInterface.GetUtil().CreateOrGetBlackMask(item, maskAlpha)
    local playerUid = self.playerUidList[i]
    self.playHeadScript[playerUid] = script
    self:RefreshPlayerInfo(playerUid)
  end
  self.moreBtn:SetActive(#self.playerUidList > maxCunt)
  self.BtnMorePlayer:SetActive(#self.playerUidList > maxCunt)
  self.BtnMorePlayer.transform:SetAsLastSibling()
end

function MomentLikePlayersItem:RefreshPlayerInfo(uid)
  local userInfo = ChatInterface.getUserData(uid)
  if self.playHeadScript[uid] and userInfo then
    self.playHeadScript[uid]:SetData(userInfo.uid, userInfo.headPic, userInfo.headPicVer)
    self.playHeadScript[uid]:SetEnableClickShowInfo(true, true)
  end
end

function MomentLikePlayersItem:ClearItemCell()
  self.RootPlayerIconList:RemoveComponents(UICommonHead)
  self.goUIPlayerHead:GameObjectRecycleAll()
  self.playHeadScript = {}
end

function MomentLikePlayersItem:CalculateTotolHeight()
end

function MomentLikePlayersItem:OnClickMorePlayer()
end

return MomentLikePlayersItem
