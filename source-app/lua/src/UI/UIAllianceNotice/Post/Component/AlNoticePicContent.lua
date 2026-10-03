local AlNoticePicContent = BaseClass("AlNoticePicContent", UIBaseContainer)
local AlNoticePicItem = require("UI.UIAllianceNotice.Post.Component.AlNoticePicItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TriggerChangeRate = 0.7
local select_image1_path = "selectImage1"
local select_image2_path = "selectImage2"
local select_image3_path = "selectImage3"
local select_image4_path = "selectImage4"
local itemMoveSpeed = 1600
local itemMoveMaxTime = 0.3

function AlNoticePicContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

function AlNoticePicContent:OnDestroy()
  self:CloseAniSeq()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AlNoticePicContent:OnEnable()
  base.OnEnable(self)
end

function AlNoticePicContent:OnDisable()
  base.OnDisable(self)
end

function AlNoticePicContent:ComponentDefine()
  self.select_image1 = self:AddComponent(AlNoticePicItem, select_image1_path)
  self.select_image2 = self:AddComponent(AlNoticePicItem, select_image2_path)
  self.select_image3 = self:AddComponent(AlNoticePicItem, select_image3_path)
  self.select_image4 = self:AddComponent(AlNoticePicItem, select_image4_path)
  self.selectImgList = {
    self.select_image1,
    self.select_image2,
    self.select_image3,
    self.select_image4
  }
end

function AlNoticePicContent:ComponentDestroy()
  self.select_image1 = nil
  self.select_image2 = nil
  self.select_image3 = nil
  self.select_image4 = nil
end

function AlNoticePicContent:DataDefine()
  self.contentW = 0
  self.itemMaxNum = 0
  self.itemPosList = {}
  self.curDataIndexToItemIndex = {}
  self.inData = {}
  self.viewState = AlNoticePicViewState.None
  self.viewStateChangeTime = nil
  self.beSelectDataIndex = nil
  self.itemRangeHalf = 0
  self.aniSeq = nil
  self.delPhotoFunc = nil
  self.selectPhotoFunc = nil
  self.beginDragPos = nil
  self.beginDragItemUIPos = nil
  self.selectImgPosChangeFunc = nil
end

function AlNoticePicContent:DataDestroy()
  self.contentW = nil
  self.itemMaxNum = nil
  self.itemPosList = nil
  self.curDataIndexToItemIndex = nil
  self.inData = nil
  self.viewState = nil
  self.viewStateChangeTime = nil
  self.beSelectDataIndex = nil
  self.itemRangeHalf = nil
  self.aniSeq = nil
  self.delPhotoFunc = nil
  self.selectPhotoFunc = nil
  self.beginDragPos = nil
  self.beginDragItemUIPos = nil
  self.selectImgPosChangeFunc = nil
end

function AlNoticePicContent:InitData()
  self.itemMaxNum = 4
  local contentX, contentY = self:GetSizeDeltaXY()
  self.contentW = contentX
  local halfSpace = self.contentW / (self.itemMaxNum * 2)
  self.itemRangeHalf = halfSpace
  self.itemPosList = {}
  self.curDataIndexToItemIndex = {}
  for i = 1, self.itemMaxNum do
    self.itemPosList[i] = -self.contentW / 2 + halfSpace + (i - 1) * 2 * halfSpace
    self.curDataIndexToItemIndex[i] = i
  end
end

function AlNoticePicContent:SetDelPhotoFunc(delPhotoFunc)
  self.delPhotoFunc = delPhotoFunc
end

function AlNoticePicContent:SetSelectPhotoFunc(selectPhotoFunc)
  self.selectPhotoFunc = selectPhotoFunc
end

function AlNoticePicContent:SetPhotoFunc(delPhotoFunc, selectPhotoFunc, selectImgPosChangeFunc)
  self:SetDelPhotoFunc(delPhotoFunc)
  self:SetSelectPhotoFunc(selectPhotoFunc)
  self.selectImgPosChangeFunc = selectImgPosChangeFunc
  self:RegisterItemsFunc()
end

function AlNoticePicContent:SetInputData(inData)
  if inData == nil then
    inData = {}
  end
  self.inData = inData
  local curNum = #self.inData
  for i = 1, self.itemMaxNum do
    local targetItemIndex = self.curDataIndexToItemIndex[i]
    local item = self.selectImgList[targetItemIndex]
    local posX = self.itemPosList[i]
    item:SetAnchoredPositionXY(posX, 0)
    if i <= #self.inData then
      item:SetActive(true)
      item:SetData(i, self.itemMaxNum, self.inData[i], curNum)
    elseif i == #self.inData + 1 then
      item:SetActive(true)
      item:SetData(i, self.itemMaxNum, nil, curNum)
    else
      item:SetActive(false)
    end
  end
end

function AlNoticePicContent:CloseAniSeq()
  if self.aniSeq ~= nil then
    self.aniSeq:Kill()
    self.aniSeq = nil
  end
end

function AlNoticePicContent:CheckPicContentNormal()
  if self.viewState == AlNoticePicViewState.None then
    return true
  else
    return false
  end
end

function AlNoticePicContent:OnItemLongPressFunc(dataIndex)
  if not self:CheckPicContentNormal() then
    return
  end
  if not self:CheckPhotoIsAllSuccess() then
    return
  end
  if dataIndex == nil then
    return
  end
  self.beSelectDataIndex = dataIndex
  local targetItemIndex = self.curDataIndexToItemIndex[dataIndex]
  if targetItemIndex == nil then
    return
  end
  local item = self.selectImgList[targetItemIndex]
  item:SetLocalScaleXYZ(1.1, 1.1, 1.1)
  item:SetAsLastSibling()
  self.viewState = AlNoticePicViewState.PicBeSelected
end

function AlNoticePicContent:CheckPhotoIsAllSuccess()
  local isAllSuccess = true
  if self.inData and #self.inData > 0 then
    for i = 1, #self.inData do
      if self.inData[i][AlNoticePicDataType.SendState] ~= PhotoUploadState.UploadSuccess then
        isAllSuccess = false
        break
      end
    end
  end
  return isAllSuccess
end

function AlNoticePicContent:OnItemPointUp()
  if self.viewState ~= AlNoticePicViewState.PicBeSelected then
    return
  end
  if self.beSelectDataIndex == nil then
    return
  end
  local dataIndex = self.beSelectDataIndex
  self.beSelectDataIndex = nil
  self.viewState = AlNoticePicViewState.PicBeSelectedCancel
  local targetItemIndex = self.curDataIndexToItemIndex[dataIndex]
  local item = self.selectImgList[targetItemIndex]
  item:SetLocalScaleXYZ(1, 1, 1)
  self:OnItemToNormalAni()
end

function AlNoticePicContent:OnItemBeginDragFunc(data)
  if self.viewState ~= AlNoticePicViewState.PicBeSelected then
    return
  end
  if self.beSelectDataIndex == nil then
    return
  end
  local dataIndex = self.beSelectDataIndex
  local targetItemIndex = self.curDataIndexToItemIndex[dataIndex]
  local item = self.selectImgList[targetItemIndex]
  self.beginDragItemUIPos = item:GetAnchoredPosition(true)
  local screenPos = data.position
  self.beginDragPos = PosConverse.ScreenToUIPos(self.rectTransform, screenPos)
end

function AlNoticePicContent:OnItemDragFunc(data)
  if self.viewState ~= AlNoticePicViewState.PicBeSelected then
    return
  end
  local screenPos = data.position
  local curPos = PosConverse.ScreenToUIPos(self.rectTransform, screenPos)
  local diffPos = curPos - self.beginDragPos
  local curItemUIPos = self.beginDragItemUIPos + diffPos
  local dataIndex = self.beSelectDataIndex
  local targetItemIndex = self.curDataIndexToItemIndex[dataIndex]
  local item = self.selectImgList[targetItemIndex]
  item:SetAnchoredPosition(curItemUIPos, true)
  local changePos = -1
  local checkNum = math.min(self.itemMaxNum, #self.inData)
  local isMirror = CommonUtil.IsArabicAutoMirrorOpen()
  local moveAniDir = isMirror and -1 or 1
  for i = 1, checkNum do
    if i ~= dataIndex then
      local targetPosX = self.itemPosList[i] * moveAniDir
      local targetPosY = 0
      local halfSpace = self.contentW / (self.itemMaxNum * 2)
      local checkRang = halfSpace * TriggerChangeRate
      local isInRange = checkRang > math.abs(curItemUIPos.x - targetPosX) and checkRang > math.abs(curItemUIPos.y - targetPosY)
      if isInRange then
        changePos = i
        break
      end
    end
  end
  if 0 < changePos and self.selectImgPosChangeFunc then
    self.selectImgPosChangeFunc(dataIndex, changePos)
    if dataIndex ~= changePos then
      local toItemIndex = self.curDataIndexToItemIndex[dataIndex]
      if dataIndex > changePos then
        for i = dataIndex, changePos + 1, -1 do
          self.curDataIndexToItemIndex[i] = self.curDataIndexToItemIndex[i - 1]
        end
      else
        for i = dataIndex, changePos - 1 do
          self.curDataIndexToItemIndex[i] = self.curDataIndexToItemIndex[i + 1]
        end
      end
      self.curDataIndexToItemIndex[changePos] = toItemIndex
      self.beSelectDataIndex = changePos
      self:OnItemToCurPosAni()
      for i = 1, checkNum do
        local itemIndex = self.curDataIndexToItemIndex[i]
        local item = self.selectImgList[itemIndex]
        item:SetDataIndex(i)
      end
    end
  end
end

function AlNoticePicContent:OnItemToNormalAni()
  for i = 1, self.itemMaxNum do
    local item = self.selectImgList[i]
    item:SetLocalScaleXYZ(1, 1, 1)
  end
  local checkNum = math.min(self.itemMaxNum, #self.inData)
  self:CloseAniSeq()
  local maxTime = 0
  self.aniSeq = DOTween.Sequence()
  local isMirror = CommonUtil.IsArabicAutoMirrorOpen()
  local moveAniDir = isMirror and -1 or 1
  for i = 1, checkNum do
    local itemIndex = self.curDataIndexToItemIndex[i]
    local item = self.selectImgList[itemIndex]
    local posX = moveAniDir * self.itemPosList[i]
    local posY = 0
    local curPos = item:GetAnchoredPosition(true)
    local moveLen = math.sqrt((curPos.x - posX) ^ 2 + (curPos.y - posY) ^ 2)
    local moveTime = moveLen / itemMoveSpeed
    moveTime = math.min(moveTime, itemMoveMaxTime)
    if maxTime < moveTime then
      maxTime = moveTime
    end
    self.aniSeq:Insert(0, item.transform:DOAnchorPos(Vector2.New(posX, posY), moveTime):SetEase(CS.DG.Tweening.Ease.Linear))
  end
  self.aniSeq:AppendInterval(maxTime)
  self.aniSeq:OnComplete(function()
    self.beSelectDataIndex = nil
    self.viewState = AlNoticePicViewState.None
  end)
end

function AlNoticePicContent:OnItemToCurPosAni()
  local checkNum = math.min(self.itemMaxNum, #self.inData)
  self:CloseAniSeq()
  local maxTime = 0
  self.aniSeq = DOTween.Sequence()
  local isMirror = CommonUtil.IsArabicAutoMirrorOpen()
  local moveAniDir = isMirror and -1 or 1
  for i = 1, checkNum do
    if i ~= self.beSelectDataIndex then
      local itemIndex = self.curDataIndexToItemIndex[i]
      local item = self.selectImgList[itemIndex]
      local posX = moveAniDir * self.itemPosList[i]
      local posY = 0
      local curPos = item:GetAnchoredPosition(true)
      local moveLen = math.sqrt((curPos.x - posX) ^ 2 + (curPos.y - posY) ^ 2)
      local moveTime = moveLen / itemMoveSpeed
      moveTime = math.min(moveTime, itemMoveMaxTime)
      if maxTime < moveTime then
        maxTime = moveTime
      end
      self.aniSeq:Insert(0, item.transform:DOAnchorPos(Vector2.New(posX, posY), moveTime):SetEase(CS.DG.Tweening.Ease.Linear))
    end
  end
end

function AlNoticePicContent:RegisterItemsFunc()
  for i = 1, self.itemMaxNum do
    local item = self.selectImgList[i]
    item:SetCheckViewStateFunc(function()
      return self:CheckPicContentNormal()
    end)
    item:SetDeletePhotoFunc(function(dataIndex)
      if self.delPhotoFunc then
        self.delPhotoFunc(dataIndex)
      end
    end)
    item:SetSelectPhotoFunc(function(dataIndex)
      if self.selectPhotoFunc then
        self.selectPhotoFunc(dataIndex)
      end
    end)
    item:SetLongPassFunc(function(dataIndex)
      self:OnItemLongPressFunc(dataIndex)
    end)
    item:SetPointUpFunc(function(dataIndex)
      self:OnItemPointUp(dataIndex)
    end)
    item:SetDragBeginFunc(function(data)
      self:OnItemBeginDragFunc(data)
    end)
    item:SetDragMoveFunc(function(data)
      self:OnItemDragFunc(data)
    end)
  end
end

function AlNoticePicContent:OnPhotoGetPicVerToUploadMsg(sendId)
  local needRefreshNum = math.min(self.itemMaxNum, #self.inData)
  for i = 1, needRefreshNum do
    local itemIndex = self.curDataIndexToItemIndex[i]
    local item = self.selectImgList[itemIndex]
    item:OnPhotoGetPicVerToUploadMsg(sendId)
  end
end

function AlNoticePicContent:OnPicVerGetMsgErr(data)
  local needRefreshNum = math.min(self.itemMaxNum, #self.inData)
  for i = 1, needRefreshNum do
    local itemIndex = self.curDataIndexToItemIndex[i]
    local item = self.selectImgList[itemIndex]
    item:CheckPicStateChange()
  end
end

function AlNoticePicContent:OnPhotoReuploadSet(data)
end

function AlNoticePicContent:SetUILoadedSuccessShow(assetKey)
  local needRefreshNum = math.min(self.itemMaxNum, #self.inData)
  for i = 1, needRefreshNum do
    local itemIndex = self.curDataIndexToItemIndex[i]
    local item = self.selectImgList[itemIndex]
    item:CheckRefreshByAssetKey(assetKey)
  end
end

function AlNoticePicContent:ItemPicStateChange(dataIndex)
  local itemIndex = self.curDataIndexToItemIndex[dataIndex]
  local item = self.selectImgList[itemIndex]
  item:CheckPicStateChange()
end

return AlNoticePicContent
