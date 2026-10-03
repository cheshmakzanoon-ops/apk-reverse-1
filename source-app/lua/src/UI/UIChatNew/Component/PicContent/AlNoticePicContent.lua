local AlNoticePicContent = BaseClass("AlNoticePicContent", UIBaseContainer)
local AlNoticePicItem = require("UI.UIChatNew.Component.PicContent.AlNoticePicItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TriggerChangeRate = 0.8
local select_image1_path = "selectImage1"
local select_image2_path = "selectImage2"
local select_image3_path = "selectImage3"
local select_image4_path = "selectImage4"
local itemNormalTypePos = {
  [1] = {
    {
      px = 0,
      py = 0,
      w = 210,
      h = 210
    }
  },
  [2] = {
    {
      px = -52.5,
      py = 0,
      w = 105,
      h = 210
    },
    {
      px = 52.5,
      py = 0,
      w = 105,
      h = 210
    }
  },
  [3] = {
    {
      px = 0,
      py = 52.5,
      w = 105,
      h = 105
    },
    {
      px = -52.5,
      py = -52.5,
      w = 105,
      h = 105
    },
    {
      px = 52.5,
      py = -52.5,
      w = 105,
      h = 105
    }
  },
  [4] = {
    {
      px = -52.5,
      py = 52.5,
      w = 105,
      h = 105
    },
    {
      px = 52.5,
      py = 52.5,
      w = 105,
      h = 105
    },
    {
      px = -52.5,
      py = -52.5,
      w = 105,
      h = 105
    },
    {
      px = 52.5,
      py = -52.5,
      w = 105,
      h = 105
    }
  }
}
local itemNormalTypeRateData = {
  [1] = {
    {
      px = 0,
      py = 0,
      w = 1,
      h = 1
    }
  },
  [2] = {
    {
      px = -0.25,
      py = 0,
      w = 0.5,
      h = 1
    },
    {
      px = 0.25,
      py = 0,
      w = 0.5,
      h = 1
    }
  },
  [3] = {
    {
      px = 0,
      py = 0.25,
      w = 0.5,
      h = 0.5
    },
    {
      px = -0.25,
      py = -0.25,
      w = 0.5,
      h = 0.5
    },
    {
      px = 0.25,
      py = -0.25,
      w = 0.5,
      h = 0.5
    }
  },
  [4] = {
    {
      px = -0.25,
      py = 0.25,
      w = 0.5,
      h = 0.5
    },
    {
      px = 0.25,
      py = 0.25,
      w = 0.5,
      h = 0.5
    },
    {
      px = -0.25,
      py = -0.25,
      w = 0.5,
      h = 0.5
    },
    {
      px = 0.25,
      py = -0.25,
      w = 0.5,
      h = 0.5
    }
  }
}

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
  self.rootBg = self:AddComponent(UIImage, "")
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
  self.rootBg = nil
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
  self.showType = nil
  self.allianceData = nil
  self.sizeLen = nil
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
  self.showType = nil
  self.allianceData = nil
  self.sizeLen = nil
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

function AlNoticePicContent:SetInputData(inData, showType, allianceData, sizeLen, isHideReportBtn)
  if inData == nil then
    inData = {}
  end
  self.inData = inData
  self.showType = showType
  self.allianceData = allianceData
  self.sizeLen = sizeLen and sizeLen or 210
  self.isHideReportBtn = isHideReportBtn
  for i = 1, self.itemMaxNum do
    local targetItemIndex = self.curDataIndexToItemIndex[i]
    local item = self.selectImgList[targetItemIndex]
    if i <= #self.inData then
      if showType == AlNoticeItemPicShowType.Normal then
        local showNum = math.min(self.itemMaxNum, #self.inData)
        if itemNormalTypeRateData[showNum] then
          local data = itemNormalTypeRateData[showNum][i]
          item:SetAnchoredPositionXY(self.sizeLen * data.px, self.sizeLen * data.py)
          item:SetSizeDeltaXY(self.sizeLen * data.w, self.sizeLen * data.h)
        end
      elseif showType == AlNoticeItemPicShowType.Detail then
        local posX = self.itemPosList[targetItemIndex]
        item:SetAnchoredPositionXY(posX, 0)
        item:SetSizeDeltaXY(180, 180)
      end
      item:SetActive(true)
      item:SetData(self.inData[i], self.allianceData, self.isHideReportBtn)
    else
      item:SetActive(false)
    end
  end
  if self.showType == AlNoticeItemPicShowType.Normal then
    self.rootBg:SetColorRGBA255(222, 214, 210, 255)
  else
    self.rootBg:SetColorRGBA255(0, 0, 0, 0)
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
  self.beSelectDataIndex = dataIndex
  local targetItemIndex = self.curDataIndexToItemIndex[dataIndex]
  local item = self.selectImgList[targetItemIndex]
  item:SetLocalScaleXYZ(1.1, 1.1, 1.1)
end

function AlNoticePicContent:OnItemPointUp(dataIndex)
  if self.viewState ~= AlNoticePicViewState.PicBeSelected then
    return
  end
  if dataIndex ~= self.beSelectDataIndex then
    return
  end
  self.beSelectDataIndex = nil
  self.viewState = AlNoticePicViewState.PicBeSelectedCancel
  self:OnItemToNormalAni()
end

function AlNoticePicContent:OnItemBeginDragFunc(data)
end

function AlNoticePicContent:OnItemDragFunc(data)
end

function AlNoticePicContent:OnItemToNormalAni()
  for i = 1, self.itemMaxNum do
    local item = self.selectImgList[i]
    item:SetLocalScaleXYZ(1, 1, 1)
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

function AlNoticePicContent:OnPicVerGetMsgErr(data)
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

return AlNoticePicContent
