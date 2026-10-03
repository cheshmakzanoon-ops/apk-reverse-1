local UIChatViewBigPhotoListView = BaseClass("UIChatViewBigPhotoListView", UIBaseView)
local base = UIBaseView
local logger = require("Framework.Logger.Logger")
local BigPhotoListItem = require("UI.UIChatViewBigPhotoList.Component.BigPhotoListItem")
local RectTransformUtility = CS.UnityEngine.RectTransformUtility
local UICamera = CS.UnityEngine.Camera.main
local photo_default_bg_path = "PhotoDefaultBg"
local photo_show_content_path = "PhotoRootContent/itemContent/PhotoShowContent"
local photo_show_item1_path = "PhotoRootContent/itemContent/PhotoShowContent/PhotoShowItem1"
local photo_show_item2_path = "PhotoRootContent/itemContent/PhotoShowContent/PhotoShowItem2"
local photo_show_item3_path = "PhotoRootContent/itemContent/PhotoShowContent/PhotoShowItem3"
local photo_root_content_path = "PhotoRootContent"
local btn_back_path = "PhotoRootContent/topContent/BtnBack"
local btn_report_path = "PhotoRootContent/topContent/BtnReport"
local like_btn_item_path = "PhotoRootContent/bottomContent/EmojiLikeLayout/likeBtnItem"
local like_btn_bg_path = "PhotoRootContent/bottomContent/EmojiLikeLayout/likeBtnItem/likeBtnBg"
local like_count_text_path = "PhotoRootContent/bottomContent/EmojiLikeLayout/likeBtnItem/likeCountText"
local count_path = "PhotoRootContent/bottomContent/EmojiLikeLayout/comment/count"
local detail_btn_path = "PhotoRootContent/bottomContent/DetailBtn"
local info_txt_path = "PhotoRootContent/bottomTextContent/InfoTxt"
local comment_path = "PhotoRootContent/bottomContent/EmojiLikeLayout/comment"
local revertAniTime = 200
local zoomSpeed = 3
local topContentHeight = 100
local bottomContentHeight = 150

function UIChatViewBigPhotoListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UIChatViewBigPhotoListView:OnDestroy()
  if self.chatPhotoSource == ChatPhotoSource.PlayerDetailFriendsCircle then
    DataCenter.ChatFriendCirclePhotoChatDataSaveManager:ClearSaveData()
  end
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIChatViewBigPhotoListView:ComponentDefine()
  self.photo_default_bg = self:AddComponent(TouchInputController2, photo_default_bg_path)
  self.photo_default_bg:OnInputClick(function(clickPosition, isDoubleClick, isLongTap)
    if self.viewShowType == ChatBigPhotoListViewType.Revert then
      return
    end
    local isClickInBg = false
    local clickRectPos = PosConverse.ScreenToUIPos(self.photo_show_content.rectTransform, Vector2.New(clickPosition.x, clickPosition.y))
    if clickRectPos.x > -self.photoParentSizeX / 2 and clickRectPos.x < self.photoParentSizeX / 2 and clickRectPos.y > -self.photoParentSizeY / 2 and clickRectPos.y < self.photoParentSizeY / 2 then
      isClickInBg = true
    end
    if isClickInBg then
      self:OnChatCloseBigPhotoView()
    end
  end)
  self.photo_default_bg:OnDragStart(function(pos, isLongTap, offset)
    self:OnDragStart(pos, isLongTap, offset)
  end)
  self.photo_default_bg:OnDragUpdate(function(dragPosStart, dragPosCurrent, correctionOffset)
    self:OnDragUpdate(dragPosStart, dragPosCurrent, correctionOffset)
  end)
  self.photo_default_bg:OnDragStop(function(dragStopPos, dragFinalMomentum)
    self:OnDragStop(dragStopPos, dragFinalMomentum)
  end)
  self.photo_default_bg:OnPinchStart(function(pinchCenter, pinchStartDistance)
    if self.viewShowType == ChatBigPhotoListViewType.Revert then
      return
    end
    self.isPinchTrigger = true
    self.editorTargetItem = self:GetCurUseItem()
    if self.editorTargetItem == nil then
      return
    end
    local curSizeX, curSizeY = self.editorTargetItem.u_i_photo:GetSizeDeltaXY()
    local baseSizeX = self.editorTargetItem.baseSizeX
    self.pinchStartScale = curSizeX / baseSizeX
    self.photo_show_content:SetAnchoredPositionXY(0, 0)
  end)
  self.photo_default_bg:OnPinchUpdate(function(pinchCenter, pinchDistance, pinchStartDistance)
    if self.viewShowType == ChatBigPhotoListViewType.Revert then
      return
    end
    if not self.isPinchTrigger then
      return
    end
    if self.editorTargetItem == nil then
      return
    end
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local startScale = self.pinchStartScale
    local minScale = self.editorTargetItem.minScale
    local maxScale = self.editorTargetItem.maxScale
    local changeScale = (pinchDistance - pinchStartDistance) * zoomSpeed
    local curScale = startScale + changeScale
    if minScale > curScale then
      curScale = minScale
    elseif maxScale < curScale then
      curScale = maxScale
    end
    local curSizeX = curScale * self.editorTargetItem.baseSizeX
    local curSizeY = curScale * self.editorTargetItem.baseSizeY
    self.editorTargetItem.u_i_photo:SetSizeDeltaXY(curSizeX, curSizeY)
  end)
  self.photo_default_bg:OnPinchStop(function()
    if self.isPinchTrigger == false then
      return
    end
    self.isPinchTrigger = false
    self:TryRevertView()
  end)
  self.photo_show_content = self:AddComponent(UIBaseContainer, photo_show_content_path)
  self.photo_show_item1 = self:AddComponent(BigPhotoListItem, photo_show_item1_path)
  self.photo_show_item2 = self:AddComponent(BigPhotoListItem, photo_show_item2_path)
  self.photo_show_item3 = self:AddComponent(BigPhotoListItem, photo_show_item3_path)
  self.photoItemList = {
    self.photo_show_item1,
    self.photo_show_item2,
    self.photo_show_item3
  }
  self.photo_root_content = self:AddComponent(UIBaseContainer, photo_root_content_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_report = self:AddComponent(UIButton, btn_report_path)
  self.like_btn_item = self:AddComponent(UIButton, like_btn_item_path)
  self.like_btn_bg = self:AddComponent(UIImage, like_btn_bg_path)
  self.like_count_text = self:AddComponent(UITextMeshProUGUIEx, like_count_text_path)
  self.count = self:AddComponent(UITextMeshProUGUIEx, count_path)
  self.detail_btn = self:AddComponent(UIButton, detail_btn_path)
  self.info_txt = self:AddComponent(UITextMeshProUGUIEx, info_txt_path)
  ChatInterface.SetEmojiTextProperty(self.info_txt)
  self.comment = self:AddComponent(UIButton, comment_path)
  self.btn_back:SetOnClick(function()
    self:OnChatCloseBigPhotoView()
  end)
  self.btn_report:SetOnClick(function()
    self:OnPhotoReport()
  end)
  self.comment:SetOnClick(function()
    self:ShowChatDetailView()
  end)
  self.detail_btn:SetOnClick(function()
    self:ShowChatDetailView()
  end)
  self.like_btn_item:SetOnClick(function()
    self:OnLikeBtnClick()
  end)
end

function UIChatViewBigPhotoListView:ComponentDestroy()
  self.photo_default_bg = nil
  self.photo_show_content = nil
  self.photo_show_item1 = nil
  self.photo_show_item2 = nil
  self.photo_show_item3 = nil
  self.photoItemList = nil
  self.photo_root_content = nil
  self.btn_back = nil
  self.btn_report = nil
  self.like_btn_item = nil
  self.like_btn_bg = nil
  self.like_count_text = nil
  self.count = nil
  self.detail_btn = nil
  self.info_txt = nil
  self.comment = nil
end

function UIChatViewBigPhotoListView:DataDefine()
  self.chatPhotoSource = nil
  self.chatData = nil
  self.roomId = nil
  self.chatPicDataList = {}
  self.picDataIndex = 0
  self.viewShowType = ChatBigPhotoListViewType.Normal
  self.isDragTrigger = false
  self.isPinchTrigger = false
  self.dragStartPos = nil
  self.pinchStartScalePos = nil
  self.pinchStartScale = nil
  self.editorTargetItem = nil
  self.curUseItemIndex = 1
  self.parentSizeX = 0
  self.parentSizeY = 0
  self.photoParentSizeX = 0
  self.photoParentSizeY = 0
  self.revertContentPosTrigger = false
  self.revertContentStartTime = 0
  self.revertContentPosXS = 0
  self.revertContentPosXE = 0
  self.revertTargetItemPosTrigger = false
  self.revertTargetItemPosStartTime = 0
  self.revertTargetItemPosXS = 0
  self.revertTargetItemPosXE = 0
  self.revertTargetItemPosYS = 0
  self.revertTargetItemPosYE = 0
  self.revertTargetItemSizeTrigger = false
  self.revertTargetItemSizeStartTime = 0
  self.revertTargetItemSizeScaleS = 0
end

function UIChatViewBigPhotoListView:DataDestroy()
  self.chatData = nil
  self.chatPhotoSource = nil
  self.roomId = nil
  self.chatPicDataList = nil
  self.picDataIndex = nil
  self.viewShowType = nil
  self.isDragTrigger = nil
  self.isPinchTrigger = nil
  self.dragStartPos = nil
  self.pinchStartScalePos = nil
  self.pinchStartScale = nil
  self.editorTargetItem = nil
  self.curUseItemIndex = nil
  self.parentSizeX = nil
  self.parentSizeY = nil
  self.photoParentSizeX = nil
  self.photoParentSizeY = nil
  self.revertContentPosTrigger = nil
  self.revertContentStartTime = nil
  self.revertContentPosXS = nil
  self.revertContentPosXE = nil
  self.revertTargetItemPosTrigger = nil
  self.revertTargetItemPosStartTime = nil
  self.revertTargetItemPosXS = nil
  self.revertTargetItemPosXE = nil
  self.revertTargetItemPosYS = nil
  self.revertTargetItemPosYE = nil
  self.revertTargetItemSizeTrigger = nil
  self.revertTargetItemSizeStartTime = nil
  self.revertTargetItemSizeScaleS = nil
end

function UIChatViewBigPhotoListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetChatPhotoDataListRefreshMsg, self.OnGetChatPhotoDataListRefreshMsg)
  self:AddUIListener(ChatEventEnum.ChatUpSucceed, self.UpdateItemWithNew)
  self:AddUIListener(ChatEventEnum.UPDATE_USER_MSG, self.UpdateItemWithNew)
end

function UIChatViewBigPhotoListView:OnRemoveListener()
  self:RemoveUIListener(EventId.GetChatPhotoDataListRefreshMsg, self.OnGetChatPhotoDataListRefreshMsg)
  self:RemoveUIListener(ChatEventEnum.ChatUpSucceed, self.UpdateItemWithNew)
  self:RemoveUIListener(ChatEventEnum.UPDATE_USER_MSG, self.UpdateItemWithNew)
  base.OnRemoveListener(self)
end

function UIChatViewBigPhotoListView:SetOnTop()
  self:RefreshView()
end

function UIChatViewBigPhotoListView:Init()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  self.parentSizeX = Screen.width / scaleFactor
  self.parentSizeY = Screen.height / scaleFactor
  self.photoParentSizeX = self.parentSizeX
  self.photoParentSizeY = self.parentSizeY - topContentHeight - bottomContentHeight
  self.photo_default_bg:SetSizeDeltaXY(self.parentSizeX, self.parentSizeY)
  self.photo_root_content:SetSizeDeltaXY(self.parentSizeX, self.parentSizeY)
  self.photo_show_content:SetSizeDeltaXY(self.photoParentSizeX, self.photoParentSizeY)
  for i = 1, #self.photoItemList do
    self.photoItemList[i]:SetSizeDeltaXY(self.photoParentSizeX, self.photoParentSizeY)
  end
  self.chatPhotoSource, self.chatData = self:GetUserData()
  self.roomId = nil
  self.chatPicDataList = {}
  self.picDataIndex = 0
  self:InitDataByChatPhotoSource()
  self:RefreshView()
end

function UIChatViewBigPhotoListView:RefreshView()
  self.photo_show_content:SetAnchoredPositionXY(0, 0)
  if self.chatPicDataList == nil or #self.chatPicDataList == 0 then
    return
  end
  local itemCount = #self.photoItemList
  if self.picDataIndex < 1 then
    self.picDataIndex = 1
  end
  self.curUseItemIndex = (self.picDataIndex - 1) % itemCount + 1
  local preDataIndex = self.picDataIndex - 1
  local nextDataIndex = self.picDataIndex + 1
  local preUseItemIndex = (itemCount + preDataIndex - 1) % itemCount + 1
  local nextUseItemIndex = (nextDataIndex - 1) % itemCount + 1
  if self.chatPicDataList[preDataIndex] == nil then
    self.photoItemList[preUseItemIndex]:SetActive(false)
  else
    self.photoItemList[preUseItemIndex]:SetActive(true)
    self.photoItemList[preUseItemIndex]:SetAnchoredPositionXY(-self.photoParentSizeX, 0)
    self.photoItemList[preUseItemIndex]:RefreshData(self.chatPicDataList[preDataIndex])
  end
  if self.chatPicDataList[self.picDataIndex] == nil then
    self.photoItemList[self.curUseItemIndex]:SetActive(false)
  else
    self.photoItemList[self.curUseItemIndex]:SetActive(true)
    self.photoItemList[self.curUseItemIndex]:SetAnchoredPositionXY(0, 0)
    self.photoItemList[self.curUseItemIndex]:RefreshData(self.chatPicDataList[self.picDataIndex])
  end
  if self.chatPicDataList[nextDataIndex] == nil then
    self.photoItemList[nextUseItemIndex]:SetActive(false)
  else
    self.photoItemList[nextUseItemIndex]:SetActive(true)
    self.photoItemList[nextUseItemIndex]:SetAnchoredPositionXY(self.photoParentSizeX, 0)
    self.photoItemList[nextUseItemIndex]:RefreshData(self.chatPicDataList[nextDataIndex])
  end
  if self.picDataIndex > #self.chatPicDataList - 2 then
    self:TryGetMoreDataByChatPhotoSource()
  end
  self:RefreshCurDataDetail()
end

function UIChatViewBigPhotoListView:RefreshCurDataDetail()
  local curChatData = self.chatPicDataList[self.picDataIndex]
  if curChatData == nil then
    return
  end
  local isShowBtn = false
  local senderUid = curChatData:getSenderUid()
  isShowBtn = senderUid ~= LuaEntry.Player.uid
  self.btn_report:SetActive(isShowBtn)
  local message = curChatData:getSuperParsedResult()
  if message == nil then
    message = curChatData:getMessageWithExtra(false)
    curChatData:setSuperParsedResult(message)
  end
  self.info_txt:SetText_NotNative(message)
  local emojis = curChatData.emojis
  local count = 0
  local selfHaveClick = false
  for i = 1, #emojis do
    if emojis[i].emoji == EmojiCommentsType.Up then
      count = emojis[i].count
      if emojis[i].self == 1 then
        selfHaveClick = true
      end
    end
  end
  self.like_count_text:SetText(count)
  self.count:SetText(curChatData.commentNum)
  local likeBgPath = ""
  if selfHaveClick then
    likeBgPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/wxy_pengyouquan_chenjin_yidianzan"
  else
    likeBgPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/wxy_pengyouquan_chenjin_weidianzan"
  end
  self.like_btn_bg:LoadSprite(likeBgPath)
end

function UIChatViewBigPhotoListView:GetCurChatPicDataIndex()
  return self.picDataIndex
end

function UIChatViewBigPhotoListView:GetCurUseItemIndex()
  return self.curUseItemIndex
end

function UIChatViewBigPhotoListView:GetCurUseItem()
  return self.photoItemList[self.curUseItemIndex]
end

function UIChatViewBigPhotoListView:OnPhotoReport()
  local isLvEnough = ChatManager2:GetInstance():CheckMainLvEnough()
  if not isLvEnough then
    UIUtil.ShowTipsId(208256)
    return
  end
  local curChatDataIndex = self:GetCurChatPicDataIndex()
  local curChatData = self.chatPicDataList[curChatDataIndex]
  if curChatData == nil then
    return
  end
  if ChatManager2:GetInstance():CheckReportTime() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
      type = ReportType.chatPhoto,
      chatData = curChatData
    })
  else
    UIUtil.ShowTipsId(208250)
  end
end

function UIChatViewBigPhotoListView:ShowChatDetailView()
  if self.viewShowType == ChatBigPhotoListViewType.Revert then
    return
  end
  local curChatData = self.chatPicDataList[self.picDataIndex]
  if curChatData == nil then
    return
  end
  local param = {chatData = curChatData}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleMomentDetailView, {anim = true}, param)
end

function UIChatViewBigPhotoListView:OnLikeBtnClick()
  local curChatData = self.chatPicDataList[self.picDataIndex]
  if curChatData == nil then
    return
  end
  ChatManager2:GetInstance():SendEmojiComments(curChatData:getSeqId(), EmojiCommentsType.Up, curChatData.roomId, curChatData.senderUid, false, InteractiveUtil.ThumbsUpType.FriendsCirleUp)
end

function UIChatViewBigPhotoListView:UpdateItemWithNew()
  self:RefreshCurDataDetail()
end

function UIChatViewBigPhotoListView:OnChatCloseBigPhotoView()
  self.ctrl:CloseSelf()
end

function UIChatViewBigPhotoListView:OnDragStart(pos, isLongTap, offset)
  if self.viewShowType == ChatBigPhotoListViewType.Revert then
    return
  end
  self.editorTargetItem = self:GetCurUseItem()
  if self.editorTargetItem == nil then
    return
  end
  self.isDragTrigger = true
  self.dragStartPos = self.editorTargetItem.u_i_photo:GetAnchoredPosition()
end

function UIChatViewBigPhotoListView:OnDragUpdate(dragPosStart, dragPosCurrent, correctionOffset)
  if self.viewShowType == ChatBigPhotoListViewType.Revert then
    return
  end
  if not self.isDragTrigger then
    return
  end
  if self.editorTargetItem == nil then
    return
  end
  local isMirror = CommonUtil.IsArabicAutoMirrorOpen()
  local originalRectPos
  originalRectPos = PosConverse.ScreenToUIPos(self.photo_default_bg.rectTransform, Vector2.New(dragPosStart.x, dragPosStart.y))
  local updateRectPos
  updateRectPos = PosConverse.ScreenToUIPos(self.photo_default_bg.rectTransform, Vector2.New(dragPosCurrent.x, dragPosCurrent.y))
  local offset = updateRectPos - originalRectPos
  local photoSizeX, photoSizeY = self.editorTargetItem.u_i_photo:GetSizeDeltaXY()
  local offsetY = offset.y
  local itemCenterPosY = self.dragStartPos.y + offsetY
  local itemCenterPosYABS = math.abs(itemCenterPosY)
  local itemMaxMoveY = (photoSizeY - self.photoParentSizeY) / 2
  if itemMaxMoveY < 0 then
    itemMaxMoveY = 0
  end
  local itemCurMoveY = 0
  if itemCenterPosYABS > itemMaxMoveY then
    local valueDir = 0 < itemCenterPosY and 1 or -1
    itemCurMoveY = valueDir * itemMaxMoveY
  else
    itemCurMoveY = itemCenterPosY
  end
  local offsetX = offset.x
  if isMirror then
    offsetX = -offsetX
  end
  local itemCenterPosX = self.dragStartPos.x + offsetX
  local itemCenterPosXABS = math.abs(itemCenterPosX)
  local itemMaxMoveX = (photoSizeX - self.photoParentSizeX) / 2
  if itemMaxMoveX < 0 then
    itemMaxMoveX = 0
  end
  if itemCenterPosXABS <= itemMaxMoveX then
    self.editorTargetItem.u_i_photo:SetAnchoredPositionXY(self.dragStartPos.x + offset.x, itemCurMoveY)
    self.photo_show_content:SetAnchoredPositionXY(0, 0)
  else
    local contentMoveOffset = itemCenterPosXABS - itemMaxMoveX
    if contentMoveOffset > self.photoParentSizeX then
      contentMoveOffset = self.photoParentSizeX
    end
    local valueDir = 0 < itemCenterPosX and 1 or -1
    local nextDataIndex = self:GetCurChatPicDataIndex() - valueDir
    if self.chatPicDataList[nextDataIndex] == nil then
      contentMoveOffset = 0
    end
    self.editorTargetItem.u_i_photo:SetAnchoredPositionXY(valueDir * itemMaxMoveX, itemCurMoveY)
    self.photo_show_content:SetAnchoredPositionXY(valueDir * contentMoveOffset, 0)
  end
end

function UIChatViewBigPhotoListView:OnDragStop(dragStopPos, dragFinalMomentum)
  if self.isDragTrigger == false then
    return
  end
  self.isDragTrigger = false
  self.isPinchTrigger = false
  self:TryRevertView()
end

function UIChatViewBigPhotoListView:TryRevertView()
  self.viewShowType = ChatBigPhotoListViewType.Revert
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.revertContentPosTrigger == false then
    local contentPosX = self.photo_show_content:GetAnchoredPositionX()
    if math.abs(contentPosX) > 0.1 then
      self.revertContentPosTrigger = true
      self.revertContentStartTime = curTime
      self.revertContentPosXS = contentPosX
      if math.abs(contentPosX) < self.photoParentSizeX / 4 then
        self.revertContentPosXE = 0
      else
        local curDataIndex = self:GetCurChatPicDataIndex()
        if 0 < contentPosX and self.chatPicDataList[curDataIndex - 1] then
          self.revertContentPosXE = self.photoParentSizeX
        elseif contentPosX < 0 and self.chatPicDataList[curDataIndex + 1] then
          self.revertContentPosXE = -self.photoParentSizeX
        else
          self.revertContentPosXE = 0
        end
      end
    else
      self.photo_show_content:SetAnchoredPositionXY(0, 0)
    end
  end
  if self.revertTargetItemPosTrigger == false then
    local targetItem = self:GetCurUseItem()
    local photoSizeX, photoSizeY = targetItem.u_i_photo:GetSizeDeltaXY()
    local photoPosX = targetItem.u_i_photo:GetAnchoredPositionX()
    local photoPosY = targetItem.u_i_photo:GetAnchoredPositionY()
    self.revertTargetItemPosXS = 0
    self.revertTargetItemPosXE = 0
    self.revertTargetItemPosYS = 0
    self.revertTargetItemPosYE = 0
    local posXMaxMove = (photoSizeX - self.photoParentSizeX) / 2
    if posXMaxMove < 0 then
      posXMaxMove = 0
    end
    local posYMaxMove = (photoSizeY - self.photoParentSizeY) / 2
    if posYMaxMove < 0 then
      posYMaxMove = 0
    end
    if math.abs(photoPosX) > 0.1 and posXMaxMove < math.abs(photoPosX) then
      self.revertTargetItemPosXS = photoPosX
      if 0 < photoPosX then
        self.revertTargetItemPosXE = posXMaxMove
      else
        self.revertTargetItemPosXE = -posXMaxMove
      end
    end
    if math.abs(photoPosY) > 0.1 and posYMaxMove < math.abs(photoPosY) then
      self.revertTargetItemPosYS = photoPosY
      if 0 < photoPosY then
        self.revertTargetItemPosYE = posYMaxMove
      else
        self.revertTargetItemPosYE = -posYMaxMove
      end
    end
    if self.revertTargetItemPosXS ~= 0 or self.revertTargetItemPosXE ~= 0 or self.revertTargetItemPosYS ~= 0 or self.revertTargetItemPosYE ~= 0 then
      self.revertTargetItemPosTrigger = true
      self.revertTargetItemPosStartTime = curTime
    end
  end
  if self.revertTargetItemSizeTrigger == false then
    local targetItem = self:GetCurUseItem()
    local photoSizeX, photoSizeY = targetItem.u_i_photo:GetSizeDeltaXY()
    local photoBaseSizeX = targetItem.baseSizeX
    if photoSizeX < photoBaseSizeX then
      local scale = photoSizeX / photoBaseSizeX
      self.revertTargetItemSizeTrigger = true
      self.revertTargetItemSizeStartTime = curTime
      self.revertTargetItemSizeScaleS = scale
    end
  end
end

function UIChatViewBigPhotoListView:Update()
  if #self.chatPicDataList == 0 then
    return
  end
  if self.viewShowType ~= ChatBigPhotoListViewType.Revert then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.revertContentPosTrigger then
    local runScale = (curTime - self.revertContentStartTime) / revertAniTime
    if 1 < runScale then
      runScale = 1
    end
    local contentPosX = Mathf.Lerp(self.revertContentPosXS, self.revertContentPosXE, runScale)
    self.photo_show_content:SetAnchoredPositionXY(contentPosX, 0)
    if runScale == 1 then
      self.revertContentPosTrigger = false
      if self.revertContentPosXE ~= 0 then
        if 0 < self.revertContentPosXE then
          self.picDataIndex = self.picDataIndex - 1
        else
          self.picDataIndex = self.picDataIndex + 1
        end
        self:RefreshView()
        self.viewShowType = ChatBigPhotoListViewType.Normal
        self.revertContentPosTrigger = false
        self.revertTargetItemPosTrigger = false
        return
      end
    end
  end
  if self.revertTargetItemPosTrigger then
    local runScale = (curTime - self.revertTargetItemPosStartTime) / revertAniTime
    if 1 < runScale then
      runScale = 1
    end
    local targetItem = self:GetCurUseItem()
    local posX = Mathf.Lerp(self.revertTargetItemPosXS, self.revertTargetItemPosXE, runScale)
    local posY = Mathf.Lerp(self.revertTargetItemPosYS, self.revertTargetItemPosYE, runScale)
    targetItem.u_i_photo:SetAnchoredPositionXY(posX, posY)
    if runScale == 1 then
      self.revertTargetItemPosTrigger = false
    end
  end
  if self.revertTargetItemSizeTrigger then
    local runScale = (curTime - self.revertTargetItemSizeStartTime) / revertAniTime
    if 1 < runScale then
      runScale = 1
    end
    local targetItem = self:GetCurUseItem()
    local photoBaseSizeX = targetItem.baseSizeX
    local photoBaseSizeY = targetItem.baseSizeY
    local scale = Mathf.Lerp(self.revertTargetItemSizeScaleS, 1, runScale)
    targetItem.u_i_photo:SetSizeDeltaXY(photoBaseSizeX * scale, photoBaseSizeY * scale)
    if runScale == 1 then
      self.revertTargetItemSizeTrigger = false
    end
  end
  if self.revertContentPosTrigger == false and self.revertTargetItemPosTrigger == false and self.revertTargetItemSizeTrigger == false then
    self.viewShowType = ChatBigPhotoListViewType.Normal
    if self.isDragTrigger then
      self.photo_default_bg:RestartDrag()
    end
  end
end

function UIChatViewBigPhotoListView:InitDataByChatPhotoSource()
  if self.chatPhotoSource == ChatPhotoSource.PlayerDetailFriendsCircle then
    self:InitDataInPlayerDetailFriendsCircle()
  end
end

function UIChatViewBigPhotoListView:TryGetMoreDataByChatPhotoSource()
  if self.chatPhotoSource == ChatPhotoSource.PlayerDetailFriendsCircle then
    self:TryGetMoreDataInPlayerDetailFriendsCircle()
  end
end

function UIChatViewBigPhotoListView:OnGetChatPhotoDataListRefreshMsg(roomId)
  if self.roomId ~= roomId then
    return
  end
  if self.chatPhotoSource == ChatPhotoSource.PlayerDetailFriendsCircle then
    self.chatPicDataList = DataCenter.ChatFriendCirclePhotoChatDataSaveManager:GetPhotoChatDataList()
    self:RefreshView()
  end
end

function UIChatViewBigPhotoListView:InitDataInPlayerDetailFriendsCircle()
  if self.chatData == nil then
    return
  end
  self.roomId = self.chatData.roomId
  DataCenter.ChatFriendCirclePhotoChatDataSaveManager:InitRoomPhotoChatData(self.roomId)
  self.chatPicDataList = DataCenter.ChatFriendCirclePhotoChatDataSaveManager:GetPhotoChatDataList()
  self.picDataIndex = 1
  for i = 1, #self.chatPicDataList do
    local item = self.chatPicDataList[i]
    if item.seqId == self.chatData.seqId then
      self.picDataIndex = i
      break
    end
  end
end

function UIChatViewBigPhotoListView:TryGetMoreDataInPlayerDetailFriendsCircle()
  DataCenter.ChatFriendCirclePhotoChatDataSaveManager:TryGetMoreData()
end

return UIChatViewBigPhotoListView
