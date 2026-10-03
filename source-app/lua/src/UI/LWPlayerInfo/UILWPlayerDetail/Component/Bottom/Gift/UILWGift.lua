local UILWGift = BaseClass("UILWGift", UIBaseContainer)
local perfabPatch = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/LWUIGiftShowItemNew.prefab"
local GiftShowItem = require("UI/LWPlayerInfo/UILWGiftSystem/Common/LWUIGiftShowItemNew")
local hLayout = typeof(CS.UnityEngine.UI.HorizontalLayoutGroup)
local base = UIBaseContainer
local giftCountPerScreen = 4
local Show_Gift_History = false
local item_content_path = "ScrollView/maskRect/Viewport/ItemContent"
local left_btn_path = "leftBtn"
local right_btn_path = "rightBtn"
local scroll_view_path = "ScrollView"
local left_btn_red_path = "leftBtn/Image/leftBtnRed"
local right_btn_red_path = "rightBtn/Image/rightBtnRed"
local itemWidth = 138
local itemSpace = 34
local showContentWidth = 654
local nextAniSpeed = 1000
local nextAniWaitTime = 1000
local targetAniSpeed = 2000
local showAniSpeed = 50
local noAniWaitTime = 3000

function UILWGift:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.item_content:SetAnchoredPositionXY(0, 0)
end

function UILWGift:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GiftSystemShowChanged, self.OnGiftSystemShowChanged)
  self:AddUIListener(EventId.OnSetGiftDetailMsgBack, self.OnSetGiftDetailMsgBack)
  self:AddUIListener(EventId.TypeGiftShowAutoAniGuidServerRecord, self.GetAutoAniSetChangeMsg)
  self:AddUIListener(EventId.OnOtherPlayerGiftShowDataChange, self.OnGiftShowDataChanged)
end

function UILWGift:OnRemoveListener()
  self:RemoveUIListener(EventId.GiftSystemShowChanged, self.OnGiftSystemShowChanged)
  self:RemoveUIListener(EventId.OnSetGiftDetailMsgBack, self.OnSetGiftDetailMsgBack)
  self:RemoveUIListener(EventId.TypeGiftShowAutoAniGuidServerRecord, self.GetAutoAniSetChangeMsg)
  self:RemoveUIListener(EventId.OnOtherPlayerGiftShowDataChange, self.OnGiftShowDataChanged)
  base.OnRemoveListener(self)
end

function UILWGift:ComponentDefine()
  self.giftEditBtn = self:AddComponent(UIButton, "giftEditBtn")
  self.giftEditBtn:SetOnClick(function()
    self:OnEditClick()
  end)
  self.item_content = self:AddComponent(UIBaseContainer, item_content_path)
  self.left_btn = self:AddComponent(UIButton, left_btn_path)
  self.right_btn = self:AddComponent(UIButton, right_btn_path)
  self.left_btn:SetOnClick(function()
    self:OnMoveBtnClick(-1)
  end)
  self.right_btn:SetOnClick(function()
    self:OnMoveBtnClick(1)
  end)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.scroll_view:AddValueChangeListener(function()
    self:OnScrollDrag()
  end)
  self.left_btn_red = self:AddComponent(UIImage, left_btn_red_path)
  self.right_btn_red = self:AddComponent(UIImage, right_btn_red_path)
  self.scroll_view_trigger = self:AddComponent(UIEventTrigger, scroll_view_path)
  self.scroll_view_trigger:OnBeginDrag(function(eventData)
    self:OnStartDrag(eventData)
  end)
  self.scroll_view_trigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
end

function UILWGift:ComponentDestroy()
  self.item_content = nil
  self.left_btn_red = nil
  self.right_btn_red = nil
end

function UILWGift:ReInit(dataList, showType, uid)
  self.dataList = dataList
  self.targetUid = uid
  self.showType = showType or GiftShowType.Basics
  local showGiftEffect = false
  if self.selectIndex then
    showGiftEffect = true
  end
  self.selectIndex = self.selectIndex or 1
  self.extraShowNum = 0
  local isSelf = self.targetUid == LuaEntry.Player.uid
  self.unLockShowNum = 0
  self.needShwNum = 0
  if isSelf then
    self.unLockShowNum = DataCenter.GiftSystemManager:GetGiftShowUnlockCurNum()
    self.needShwNum = DataCenter.GiftSystemManager:GetGiftShowCurNum()
  else
    local playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.targetUid, true)
    if playerInfo and playerInfo.extraGiftShowNum then
      self.unLockShowNum = playerInfo.extraGiftShowNum
      self.needShwNum = playerInfo.extraGiftShowNum
    end
  end
  local itemNum = GiftSystemConst:GetDefaultGiftShowNum() + self.needShwNum
  local itemUnlockNum = GiftSystemConst:GetDefaultGiftShowNum() + self.unLockShowNum
  local itemBaseNum = GiftSystemConst:GetDefaultGiftShowNum()
  local giftDataList = dataList or {}
  local list = {}
  self.maxPos = 0
  for _, v in pairs(giftDataList) do
    if isSelf then
      v.count = DataCenter.GiftSystemManager:GetGiftNum(v.itemId)
    end
    if itemNum >= tonumber(v.pos) then
      list[tonumber(v.pos)] = v
      if v.pos > self.maxPos then
        self.maxPos = v.pos
      end
    end
  end
  for i = 1, itemNum do
    list[i] = list[i] or {
      pos = tostring(i)
    }
    if i > itemUnlockNum and i <= itemNum then
      list[i].giftShowItemType = GiftShowItemType.Lock
      list[i].unlockTempId = i - GiftSystemConst:GetDefaultGiftShowNum()
    end
    if isSelf and i > itemBaseNum then
      local rIndex = i - itemBaseNum
      local tipStateType = DataCenter.GiftSystemManager:GetGiftShowTipStateType(rIndex)
      if tipStateType ~= GiftShowIndexTipStateType.UnlockTip then
        if list[i].giftShowItemType and list[i].giftShowItemType == GiftShowItemType.Lock then
          if tipStateType == GiftShowIndexTipStateType.None then
            list[i].isNeedTip = true
          end
        else
          list[i].isNeedTip = true
        end
      end
    end
  end
  local allContentLen = itemNum * itemWidth + (itemNum - 1) * itemSpace
  self.item_content:SetSizeDeltaX(allContentLen)
  self.isPlayShowAni = false
  self.curAniState = GiftShowContentAniState.NoAni
  self.curAniStateTime = nil
  if self.showType == GiftShowType.Basics then
    if isSelf then
      self.isPlayShowAni = DataCenter.GiftSystemManager:GetSelfIsGiftShowAutoAni()
    else
      local playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.targetUid, true)
      if playerInfo then
        self.isPlayShowAni = DataCenter.GiftSystemManager:GetIsGiftShowAutoAni(playerInfo.isPlayGiftShowAni)
      end
    end
  end
  if self.isPlayShowAni then
    self.curAniState = GiftShowContentAniState.NoAniWait
    local curTime = UITimeManager:GetInstance():GetServerTime() + 300
    self.curAniStateTime = curTime
  end
  self:UpdateGifts(list, showGiftEffect)
  self:UpdateLayout()
  self:OnScrollDrag()
end

function UILWGift:SetItemContentPosX(posX)
  self.item_content:SetAnchoredPositionXY(posX, 0)
end

function UILWGift:OnGiftSystemShowChanged(info)
  if info == nil then
    return
  end
  if self.targetUid ~= info.uid then
    return
  end
  self:ReInit(info.giftDataList, self.showType, self.targetUid)
end

function UILWGift:OnGiftShowDataChanged(info)
  if info == nil then
    return
  end
  if self.targetUid ~= info.uid then
    return
  end
  self:ReInit(info.giftDataList, self.showType, self.targetUid)
end

function UILWGift:OnSetGiftDetailMsgBack()
  self:ReInit(self.dataList, self.showType, self.targetUid)
end

function UILWGift:GetAutoAniSetChangeMsg()
  local isSelf = self.targetUid == LuaEntry.Player.uid
  if self.showType == GiftShowType.Basics and isSelf then
    self:ReInit(self.dataList, self.showType, self.targetUid)
  end
end

function UILWGift:UpdateGifts(dataList, showGiftEffect)
  if not dataList then
    return
  end
  self.showDataList = dataList
  if self.reqList and #self.reqList ~= #self.showDataList then
    self:ClearReq()
    self.gifts = nil
  end
  if self.reqList == nil then
    self.reqList = {}
  end
  if self.gifts == nil then
    self.gifts = {}
  end
  for i = 1, #self.showDataList do
    local isSelect = self.showType == GiftShowType.Edit and self.selectIndex == i
    if self.reqList[i] then
      if self.gifts[i] then
        self.gifts[i]:SetShowData(self.showDataList[i], self.showType)
        self.gifts[i]:ReInit()
        self.gifts[i]:SetSelect(isSelect)
        self.gifts[i]:ShowEffect(isSelect and showGiftEffect)
      end
    else
      self.reqList[i] = self:GameObjectInstantiateAsync(perfabPatch, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.item_content.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.name = "giftBox" .. i
        local cell = self.item_content:AddComponent(GiftShowItem, go.name)
        cell:SetShowData(self.showDataList[i], self.showType)
        cell:ReInit()
        cell:SetOnSelect(function(data)
          self:OnItemSelect(data)
        end)
        cell:SetSelect(isSelect)
        cell:ShowEffect(isSelect and showGiftEffect)
        self.gifts[i] = cell
        self:TryRefreshAllTipState()
      end)
    end
  end
end

function UILWGift:OnItemSelect(data)
  if data.giftShowItemType and data.giftShowItemType == GiftShowItemType.Lock then
    if data.unlockTempId then
      local tipStr = DataCenter.GiftSystemManager:GetGiftShowIndexTipStr(data.unlockTempId)
      if not string.IsNullOrEmpty(tipStr) then
        UIUtil.ShowTips(tipStr)
      end
    end
    return
  end
  if self.showType == GiftShowType.Edit then
    if self.gifts[self.selectIndex] then
      self.gifts[self.selectIndex]:SetSelect(false)
    end
    self.selectIndex = tonumber(data.pos)
    if self.gifts[self.selectIndex] then
      self.gifts[self.selectIndex]:SetSelect(true)
    end
  elseif self.showType == GiftShowType.Basics then
    if UIUtil.CheckGiftShowDetailInfoViewIsOpen() then
      local isSelf = self.targetUid == LuaEntry.Player.uid
      local playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.targetUid, true)
      if playerInfo == nil then
        return
      end
      local originIdList = {}
      local originIdIndex = -1
      local sortData = {}
      for _, v in pairs(self.dataList) do
        table.insert(sortData, {
          id = v.itemId,
          pos = v.pos
        })
      end
      table.sort(sortData, function(a, b)
        return a.pos < b.pos
      end)
      for i, v in ipairs(sortData) do
        local originId = DataCenter.GiftSystemManager:GetOriginId(v.id)
        if originId ~= nil then
          table.insert(originIdList, originId)
          if v.pos == tonumber(data.pos) then
            originIdIndex = #originIdList
          end
        end
      end
      if 0 < originIdIndex then
        UIUtil.OpenGiftShowDetailInfoView(self.targetUid, playerInfo.serverId, originIdList, originIdIndex)
      elseif isSelf then
        DataCenter.GiftSystemManager:OpenOperationView({
          windowType = GiftSystemConst.WindowType.Show,
          targetUid = LuaEntry.Player.uid,
          targetServerId = LuaEntry.Player.serverId,
          showTypeJumpPosIndex = tonumber(data.pos),
          showTypeItemContentPosX = self.item_content:GetAnchoredPositionX()
        })
      end
      return
    end
    if not Show_Gift_History then
      return
    end
    if data.itemId == nil then
      return
    end
    local originId = DataCenter.GiftSystemManager:GetOriginId(data.itemId)
    if originId == nil then
      Logger.LogError("\230\137\190\228\184\141\229\136\176\231\164\188\231\137\169\229\142\159\229\167\139id " .. tostring(data.itemId))
      return
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIGiftHistory) then
      EventManager:GetInstance():Broadcast(EventId.GiftSystemHistoryRefresh, {
        targetUid = self.targetUid,
        itemId = originId
      })
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftHistory, {anim = true}, {
        targetUid = self.targetUid,
        itemId = originId
      })
    end
  end
end

function UILWGift:UpdateLayout()
  if self.view and self.view.data then
    self.giftEditBtn:SetActive(self.view.data.isSelf)
  end
end

function UILWGift:OnEditClick()
  DataCenter.GiftSystemManager:OpenOperationView({
    windowType = GiftSystemConst.WindowType.Show,
    targetUid = LuaEntry.Player.uid,
    targetServerId = LuaEntry.Player.serverId
  })
end

function UILWGift:OnMoveBtnClick(direction)
  if self.curAniState == GiftShowContentAniState.NextAni then
    return
  end
  local itemNum = #self.showDataList
  local aPosX = self.item_content:GetAnchoredPositionX()
  local maxPos = itemNum * itemWidth + (itemNum - 1) * itemSpace - showContentWidth
  local jumpPos = 0
  if 0 < direction then
    local rightItemNum = (-1 * aPosX + showContentWidth) / (itemWidth + itemSpace)
    rightItemNum = math.floor(rightItemNum + 0.5)
    rightItemNum = rightItemNum + 1
    jumpPos = rightItemNum * (itemWidth + itemSpace) - itemSpace - showContentWidth
    if maxPos < jumpPos then
      jumpPos = maxPos
    end
  else
    local leftItemNum = -1 * aPosX / (itemWidth + itemSpace)
    leftItemNum = math.floor(leftItemNum + 0.5)
    leftItemNum = leftItemNum - 1
    jumpPos = leftItemNum * (itemWidth + itemSpace)
    if jumpPos < 0 then
      jumpPos = 0
    end
    if maxPos < jumpPos then
      jumpPos = maxPos
    end
  end
  local jumpAnchorPos = -1 * jumpPos
  if math.abs(jumpAnchorPos - aPosX) > 5 then
    self:KillContentAni()
    local moveTime = math.abs(jumpAnchorPos - aPosX) / nextAniSpeed
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.curAniState = GiftShowContentAniState.NextAni
    self.curAniStateTime = curTime + moveTime * 1000
    self.tweenSeq = DOTween.Sequence()
    local isMirror = CommonUtil.IsArabicAutoMirrorOpen()
    local moveAniDir = isMirror and -1 or 1
    self.tweenSeq:Append(self.item_content.transform:DOAnchorPosX(moveAniDir * jumpAnchorPos, moveTime))
    self.tweenSeq:OnComplete(function()
      self:OnScrollDrag()
      self:KillContentAni()
    end)
  end
end

function UILWGift:OnScrollDrag()
  local itemNum = #self.showDataList
  local aPosX = self.item_content:GetAnchoredPositionX()
  local maxPos = itemNum * itemWidth + (itemNum - 1) * itemSpace - showContentWidth
  local leftBtnShow = false
  local rightBtnShow = false
  local space = 10
  if aPosX < -1 * space then
    leftBtnShow = true
  end
  if aPosX > -1 * (maxPos - space) then
    rightBtnShow = true
  end
  self.left_btn:SetActive(leftBtnShow)
  self.right_btn:SetActive(rightBtnShow)
  self:TryRefreshAllTipState()
end

function UILWGift:TryRefreshAllTipState()
  local leftTipNum = 0
  local rightTipNum = 0
  local itemNum = #self.showDataList
  local maxPos = itemNum * itemWidth + (itemNum - 1) * itemSpace - showContentWidth
  local aPosX = self.item_content:GetAnchoredPositionX()
  local haveMoveLen = -1 * aPosX
  for i = 1, itemNum do
    local data = self.showDataList[i]
    if data.isNeedTip then
      local showLeftPos = (i - 1) * (itemWidth + itemSpace)
      local showRightPos = (i - 1) * (itemWidth + itemSpace) + itemWidth - showContentWidth
      showLeftPos = math.max(showLeftPos, 0)
      showLeftPos = math.min(showLeftPos, maxPos)
      showRightPos = math.max(showRightPos, 0)
      showRightPos = math.min(showRightPos, maxPos)
      if haveMoveLen < showRightPos then
        rightTipNum = rightTipNum + 1
      elseif self.gifts[i] then
        self.gifts[i]:SetTipRecord()
        data.isNeedTip = false
      end
    end
  end
  self.left_btn_red:SetActive(0 < leftTipNum)
  self.right_btn_red:SetActive(0 < rightTipNum)
end

function UILWGift:ClearItems()
  if self.item_content ~= nil then
    self.item_content:RemoveComponents(GiftShowItem)
  end
  if self.gifts ~= nil then
    for k, v in pairs(self.gifts) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UILWGift:ClearReq()
  self.item_content:RemoveComponents(GiftShowItem)
  if self.reqList then
    for _, v in pairs(self.reqList) do
      v:Destroy()
    end
    self.reqList = nil
  end
end

function UILWGift:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWGift:DataDestroy()
  self.maxPos = nil
  self:KillContentAni()
  self:ClearItems()
  self:ClearReq()
end

function UILWGift:KillContentAni()
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
end

function UILWGift:Update100MS()
  if self.curAniStateTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.curAniStateTime then
    self:OnStateTimeFinChange()
  end
end

function UILWGift:OnStartDrag(eventData)
  self:KillContentAni()
  self.curAniState = GiftShowContentAniState.NoAni
  self.curAniStateTime = nil
end

function UILWGift:OnEndDrag(eventData)
  self:KillContentAni()
  if self.isPlayShowAni then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.curAniState = GiftShowContentAniState.NoAniWait
    self.curAniStateTime = curTime + noAniWaitTime
  else
    self.curAniState = GiftShowContentAniState.NoAni
    self.curAniStateTime = nil
  end
end

function UILWGift:TrySetCurSelectPlayTargetAni()
  if self.selectIndex == nil or self.selectIndex <= 0 then
    return
  end
  if self.curAniState == GiftShowContentAniState.TargetSetAni then
    return
  end
  local itemNum = #self.showDataList
  local aPosX = self.item_content:GetAnchoredPositionX()
  local maxPos = itemNum * itemWidth + (itemNum - 1) * itemSpace - showContentWidth
  local showLeftPos = (self.selectIndex - 1) * (itemWidth + itemSpace)
  local showRightPos = (self.selectIndex - 1) * (itemWidth + itemSpace) + itemWidth - showContentWidth
  showLeftPos = math.max(showLeftPos, 0)
  showLeftPos = math.min(showLeftPos, maxPos)
  showRightPos = math.max(showRightPos, 0)
  showRightPos = math.min(showRightPos, maxPos)
  local curMoveLen = -1 * aPosX
  local needMovePos
  if showRightPos <= curMoveLen and showLeftPos >= curMoveLen then
  elseif showLeftPos < curMoveLen then
    needMovePos = -1 * showLeftPos
  elseif showRightPos > curMoveLen then
    needMovePos = -1 * showRightPos
  end
  if needMovePos ~= nil then
    self:KillContentAni()
    local moveTime = math.abs(needMovePos - aPosX) / targetAniSpeed
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.curAniState = GiftShowContentAniState.TargetSetAni
    self.curAniStateTime = curTime + moveTime * 1000
    self.tweenSeq = DOTween.Sequence()
    local isMirror = CommonUtil.IsArabicAutoMirrorOpen()
    local moveAniDir = isMirror and -1 or 1
    self.tweenSeq:Append(self.item_content.transform:DOAnchorPosX(moveAniDir * needMovePos, moveTime))
    self.tweenSeq:OnComplete(function()
      self:OnScrollDrag()
      self:KillContentAni()
    end)
  end
end

function UILWGift:OnStateTimeFinChange()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.curAniState == GiftShowContentAniState.NextAni then
    self.curAniState = GiftShowContentAniState.NextAniWait
    self.curAniStateTime = curTime + nextAniWaitTime
  elseif self.curAniState == GiftShowContentAniState.NextAniWait then
    self:TryToAutoState()
  elseif self.curAniState == GiftShowContentAniState.TargetSetAni then
    self.curAniState = GiftShowContentAniState.TargetSetAniWait
    self.curAniStateTime = curTime + nextAniWaitTime
  elseif self.curAniState == GiftShowContentAniState.TargetSetAniWait then
    self:TryToAutoState()
  elseif self.curAniState == GiftShowContentAniState.ShowAni then
    self.curAniState = GiftShowContentAniState.ShowAniWait
    self.curAniStateTime = curTime + nextAniWaitTime
  elseif self.curAniState == GiftShowContentAniState.ShowAniWait then
    self.item_content:SetAnchoredPositionXY(0, 0)
    self:TryToAutoState()
  elseif self.curAniState == GiftShowContentAniState.NoAniWait then
    self:TryToAutoState()
  end
end

function UILWGift:TryToAutoState()
  if self.isPlayShowAni and self.maxPos and self.maxPos > giftCountPerScreen then
    local itemNum = self.maxPos
    local aPosX = self.item_content:GetAnchoredPositionX()
    local maxPos = itemNum * itemWidth + (itemNum - 1) * itemSpace - showContentWidth
    local curMoveLen = -1 * aPosX
    local needMovePos = -1 * maxPos
    self:KillContentAni()
    local moveTime = math.abs(needMovePos - aPosX) / showAniSpeed
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.curAniState = GiftShowContentAniState.ShowAni
    self.curAniStateTime = curTime + moveTime * 1000
    self.tweenSeq = DOTween.Sequence()
    local isMirror = CommonUtil.IsArabicAutoMirrorOpen()
    local moveAniDir = isMirror and -1 or 1
    self.tweenSeq:Append(self.item_content.transform:DOAnchorPosX(moveAniDir * needMovePos, moveTime))
    self.tweenSeq:OnComplete(function()
      self:OnScrollDrag()
      self:KillContentAni()
    end)
  else
    self.curAniState = GiftShowContentAniState.NoAni
    self.curAniStateTime = nil
  end
end

return UILWGift
