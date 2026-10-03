local MomentContentDetailItem = BaseClass("MomentContentDetailItem", UIBaseContainer)
local base = UIBaseContainer
local ChatSendPhotoLoadingBgPath = _ENV.ChatSendPhotoLoadingBgPath
local ChatSendPhotoReloadBgPath = _ENV.ChatSendPhotoReloadBgPath
local ChatSendPhotoShowMaxSize = _ENV.ChatSendPhotoShowMaxSize
local compBook = {
  {
    path = "Leftpart/UIPlayerHead",
    name = "PlayerHead",
    type = UICommonHead
  },
  {
    path = "RightPart/PlayerName",
    name = "TxtPlayerName",
    type = UIText
  },
  {
    path = "RightPart/Content",
    name = "TxtContent",
    type = UIText
  },
  {
    path = "RightPart/PostTime",
    name = "TxtPostTime",
    type = UIText
  },
  {
    path = "RightPart/Photo/ChatPhoto",
    name = "RawImgChatPhoto",
    type = UIRawImage
  },
  {
    path = "RightPart/Photo/ChatPhoto",
    name = "BtnChatPhoto",
    type = UIButton
  },
  {
    path = "RightPart/Photo/ChatPhoto",
    name = "ChatSendPhotoNode",
    type = UIBaseContainer
  },
  {
    path = "RightPart/Photo",
    name = "RootPhoto",
    type = UIBaseComponent
  },
  {
    path = "RightPart/Photo/ChatPhoto/ImgLoading",
    name = "RootImgLoading",
    type = UIBaseComponent
  },
  {
    path = "RightPart/Photo/ChatPhoto/ImgLoadFail",
    name = "RootImgLoadFail",
    type = UIBaseComponent
  },
  {
    path = "RightPart/LayoutBtns/BtnShowMore",
    name = "BtnClickShowMore",
    type = UIButton,
    onClick = function(self)
      self:OnClickShowMore()
    end
  },
  {
    path = "RightPart/LayoutBtns/BtnShowLess",
    name = "BtnClickShowLess",
    type = UIButton,
    onClick = function(self)
      self:OnClickShowLess()
    end
  },
  {
    path = "RightPart/LayoutBtns/BtnTranslate",
    name = "BtnClickTranslate",
    type = UIButton,
    onClick = function(self)
      self:OnClickTranslate()
    end
  }
}
local limitShowLineCount = 3
local BLANK_FROM_TOP = 30
local PLAY_NAME_HEIGHT = 40.5
local CONTENT_HEIGHT = 40.5
local LAYOUT_BTNS_HEIGHT = 40.5
local PHOTO_HEIGHT = 40.5
local POST_TIME_HEIGHT = 40.5

function MomentContentDetailItem:OnCreate()
  base.OnCreate(self)
  self:DefineCompsByBook(compBook)
  self.playerUid = 0
  self.assetKey = 0
  self.chatData = nil
end

function MomentContentDetailItem:OnDestroy()
  base.OnDestroy(self)
  self:ClearCompsByBook(compBook)
  self.playerUid = 0
  self.assetKey = 0
  self.chatData = nil
end

function MomentContentDetailItem:OnAddListener()
  self:AddUIListener(EventId.PlayerMessageInfo, self.RefreshPlayerInfo)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:AddUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
end

function MomentContentDetailItem:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.RefreshPlayerInfo)
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
end

function MomentContentDetailItem:InitData(chatData)
  self.chatData = {}
  self.chatData.isTextFolding = false
  
  function self.chatData.GetIsTextFolding(...)
    return self.chatData.isTextFolding
  end
  
  function self.chatData.SetIsTextFolding(x, state)
    self.chatData.isTextFolding = state
  end
  
  function self.chatData.getExtra(...)
    return {
      picVer = 379,
      smallHeight = 1279,
      smallWidth = 2273,
      bigHeight = 1279,
      bigWidth = 2273
    }
  end
  
  function self.chatData.getSenderUid(...)
    return LuaEntry.Player.uid
  end
  
  self.playerUid = LuaEntry.Player.uid
  self.assetKey = "??????fffff"
  self.content = "\229\190\183\231\142\155\232\165\191\228\186\154\239\188\140\230\152\175\227\128\138\232\139\177\233\155\132\232\129\148\231\155\159\227\128\139\229\174\135\229\174\153\228\184\173\231\154\132\229\156\176\229\140\186\239\188\140\228\189\141\228\186\142\231\147\166\230\180\155\229\133\176\229\164\167\233\153\134\232\165\191\231\171\175\227\128\1302014\229\185\1809\230\156\1366\230\151\165\227\128\138\232\139\177\233\155\132\232\129\148\231\155\159\227\128\139\228\184\137\229\145\168\229\185\180\229\186\134\229\133\184\228\184\138\239\188\140Demasia is a region of the League of Legends universe located at the western end of the continent of Valoran. "
  self.timeStamp = 123123123
  self.smallPhotoWidth = 100
  self.smallPhotoHeight = 250
end

function MomentContentDetailItem:RefreshView(chatData)
  self:InitData(chatData)
  self:RefreshPlayerInfo(self.playerUid)
  self:RefreshContentAndBtn()
  self:RefreshPhoto()
  self:RefreshTime()
  self:CalculateTotolHeight()
end

function MomentContentDetailItem:RefreshPlayerInfo(uid)
  if self.playerUid ~= uid then
    return
  end
  local userInfo = ChatInterface.getUserData(self.playerUid)
  if self.PlayerHead and userInfo then
    self.PlayerHead:SetData(userInfo.uid, userInfo.headPic, userInfo.headPicVer)
    self.TxtPlayerName:SetText(userInfo:GetFomatName())
  end
end

function MomentContentDetailItem:RefreshContentAndBtn()
  self.TxtContent:SetText(self.content)
  local totalContentHeight = self.TxtContent.unity_tmpro:GetPreferredValues().y
  self.TxtContent.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, totalContentHeight)
  self.TxtContent.unity_tmpro:ForceMeshUpdate()
  local textInfo = self.TxtContent.unity_tmpro.textInfo
  local totalLineCount = textInfo.lineCount
  local showLineCount = totalLineCount
  local isTextFolding = self.chatData:GetIsTextFolding()
  if showLineCount > limitShowLineCount and not isTextFolding then
    showLineCount = limitShowLineCount
  end
  CONTENT_HEIGHT = textInfo.lineInfo[0].lineHeight * showLineCount
  self.TxtContent.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, CONTENT_HEIGHT)
  self.BtnClickShowMore:SetActive(totalLineCount > limitShowLineCount and not isTextFolding)
  self.BtnClickShowLess:SetActive(totalLineCount > limitShowLineCount and isTextFolding)
end

function MomentContentDetailItem:RefreshPhoto()
  if self.chatData:getExtra() == nil or self.chatData:getExtra().picVer == nil then
    PHOTO_HEIGHT = 0
    self.RootPhoto:SetActive(false)
    return
  end
  self.UIChatSendPhoto = self.ChatSendPhotoNode.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
  if self.UIChatSendPhoto == nil then
    Logger.LogError("\230\156\139\229\143\139\229\156\136\226\128\148\226\128\148\226\128\148\226\128\148\229\155\190\231\137\135Item\239\188\140\228\184\141\229\173\152\229\156\168UIChatSendPhoto\232\132\154\230\156\172")
    return
  end
  self.RootPhoto:SetActive(true)
  self.RootImgLoading:SetActive(false)
  self.RootImgLoadFail:SetActive(false)
  self:SetPhotoSizeFromTexture(self.chatData)
  self.assetKey = CS.UploadImageManager.Instance:GenAssetKey(self.chatData:getSenderUid(), self.chatData:getExtra().picVer, false)
  self.UIChatSendPhoto:SetData(PhotoFuncType.MomentPickPhoto, self.chatData:getSenderUid(), self.chatData:getExtra().picVer, self.assetKey, false)
  self:SetUILoadingShow(self.assetKey)
  self.UIChatSendPhoto:StartUpdateSmallPhoto()
end

function MomentContentDetailItem:SetPhotoSizeFromTexture(chatData)
  local originalWidth = chatData:getExtra().smallWidth or ChatSendPhotoShowMaxSize
  local originalHeight = chatData:getExtra().smallHeight or ChatSendPhotoShowMaxSize
  local finalWidth, finalHeight = 0, 0
  if originalWidth >= originalHeight then
    local ratio = ChatSendPhotoShowMaxSize / originalWidth
    finalWidth = ChatSendPhotoShowMaxSize
    finalHeight = math.floor(originalHeight * ratio)
  else
    local ratio = ChatSendPhotoShowMaxSize / originalHeight
    finalHeight = ChatSendPhotoShowMaxSize
    finalWidth = math.floor(originalWidth * ratio)
  end
  self.ChatSendPhotoNode:SetSizeDeltaXY(finalWidth, finalHeight)
  PHOTO_HEIGHT = finalHeight + 30
  self.RootPhoto:SetSizeDeltaY(PHOTO_HEIGHT)
end

function MomentContentDetailItem:SetUILoadingShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self.RawImgChatPhoto:LoadSprite(ChatSendPhotoLoadingBgPath)
  self.BtnChatPhoto:SetOnClick(function()
  end)
  self.RootImgLoading:SetActive(true)
  self.RootImgLoadFail:SetActive(false)
end

function MomentContentDetailItem:SetUIReloadShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self.RawImgChatPhoto:LoadSprite(ChatSendPhotoReloadBgPath)
  self.BtnChatPhoto:SetOnClick(function()
    self:SetUILoadingShow(assetKey)
    self.UIChatSendPhoto:RequestTextureData(assetKey, false)
  end)
  self.RootImgLoading:SetActive(false)
  self.RootImgLoadFail:SetActive(true)
end

function MomentContentDetailItem:SetUILoadedSuccessShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  local cacheItem = self.UIChatSendPhoto:SetUILoadedSuccessShow(assetKey)
  if cacheItem == nil or IsNull(cacheItem) then
    return
  end
  self.RawImgChatPhoto:SetTexture(cacheItem.textureAsset)
  self.BtnChatPhoto:SetOnClick(function()
    local param = {}
    param.chatData = self.chatData
    param.smallAssetKey = self.assetKey
    param.photoFuncType = PhotoFuncType.MomentPickPhoto
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatViewBigPhotoView, {anim = true}, param)
  end)
  self.RootImgLoading:SetActive(false)
  self.RootImgLoadFail:SetActive(false)
end

function MomentContentDetailItem:RefreshTime()
end

function MomentContentDetailItem:CalculateTotolHeight()
  self:SetSizeDeltaY(BLANK_FROM_TOP + PLAY_NAME_HEIGHT + CONTENT_HEIGHT + LAYOUT_BTNS_HEIGHT + PHOTO_HEIGHT + POST_TIME_HEIGHT)
end

function MomentContentDetailItem:OnClickShowMore()
  if self.chatData:GetIsTextFolding() then
    return
  end
  CONTENT_HEIGHT = self.TxtContent.unity_tmpro:GetPreferredValues().y
  self.TxtContent.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, CONTENT_HEIGHT)
  self.BtnClickShowMore:SetActive(false)
  self.BtnClickShowLess:SetActive(true)
  self.chatData:SetIsTextFolding(true)
  self.view:RefreshView()
end

function MomentContentDetailItem:OnClickShowLess()
  if not self.chatData:GetIsTextFolding() then
    return
  end
  local textInfo = self.TxtContent.unity_tmpro.textInfo
  CONTENT_HEIGHT = textInfo.lineInfo[0].lineHeight * limitShowLineCount
  self.TxtContent.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, CONTENT_HEIGHT)
  self.BtnClickShowMore:SetActive(true)
  self.BtnClickShowLess:SetActive(false)
  self.chatData:SetIsTextFolding(false)
  self.view:RefreshView()
end

function MomentContentDetailItem:OnClickTranslate()
end

return MomentContentDetailItem
