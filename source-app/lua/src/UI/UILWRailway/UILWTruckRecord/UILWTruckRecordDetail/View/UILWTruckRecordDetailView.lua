local UILWTruckRecordDetailView = BaseClass("UILWTruckRecordDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TruckRecordDetail = require("UI.UILWRailway.UILWTruckRecord.UILWTruckRecordDetail.Component.TruckRecordDetail")

function UILWTruckRecordDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTruckRecordDetailView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTruckRecordDetailView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.collectBtn = self:AddComponent(UIButton, "Root/BottomBar/MailDetailBtns/CollectBtn")
  self.collectBtn:SetOnClick(function()
    self:OnClickCollectBtn()
  end)
  self.deleteBtn = self:AddComponent(UIButton, "Root/BottomBar/MailDetailBtns/DeleteBtn")
  self.deleteBtn:SetOnClick(function()
    self:OnClickDeleteBtn()
  end)
  self.shareBtn = self:AddComponent(UIButton, "Root/BottomBar/MailDetailBtns/ShareBtn")
  self.shareBtn:SetOnClick(function()
    self:OnClickShareBtn()
  end)
  self.titleTxt = self:AddComponent(UIText, "Root/TopBar/TextTitle")
  self.titleTxt:SetLocalText(457524)
  self.middle = self:AddComponent(TruckRecordDetail, "Root/Middle/MailDetailTruck")
end

function UILWTruckRecordDetailView:ComponentDestroy()
end

function UILWTruckRecordDetailView:DataDefine()
  local userData, trainServerId = self:GetUserData()
  if type(userData) == "number" then
    local trainUuid = userData
    SFSNetwork.SendMessage(MsgDefines.TrainRecordDetail, trainUuid, trainServerId)
  else
    self.trainRecordData = userData
    if self.trainRecordData then
      self.trainData = self.trainRecordData.trainData
      self:RefreshView()
    end
  end
end

function UILWTruckRecordDetailView:DataDestroy()
end

function UILWTruckRecordDetailView:OnEnable()
  base.OnEnable(self)
end

function UILWTruckRecordDetailView:OnDisable()
  base.OnDisable(self)
end

function UILWTruckRecordDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TruckRecordWantedUpdate, self.RefreshMiddle)
  self:AddUIListener(EventId.TruckRecordFavoriteAdd, self.OnTruckRecordFavoriteAdd)
  self:AddUIListener(EventId.TruckRecordFavoriteRemove, self.OnTruckRecordFavoriteRemove)
  self:AddUIListener(EventId.TruckRecordDetailDataArrive, self.OnDetailDataArrive)
end

function UILWTruckRecordDetailView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.TruckRecordWantedUpdate, self.RefreshMiddle)
  self:RemoveUIListener(EventId.TruckRecordFavoriteAdd, self.OnTruckRecordFavoriteAdd)
  self:RemoveUIListener(EventId.TruckRecordFavoriteRemove, self.OnTruckRecordFavoriteRemove)
  self:RemoveUIListener(EventId.TruckRecordDetailDataArrive, self.OnDetailDataArrive)
end

function UILWTruckRecordDetailView:RefreshView()
  self:RefreshTop()
  self:RefreshBottom()
  self:RefreshMiddle()
end

function UILWTruckRecordDetailView:RefreshTop()
end

function UILWTruckRecordDetailView:RefreshBottom()
  local isCollect = false
  if self.trainRecordData then
    isCollect = self.trainRecordData.isFavorite == 1
  end
  self.collectBtn:SetActive(not isCollect)
  self.deleteBtn:SetActive(isCollect)
  self.shareBtn:SetActive(self.trainRecordData)
end

function UILWTruckRecordDetailView:OnTruckRecordFavoriteAdd(message)
  if message.train_uuid == self.trainData.uuid then
    self.trainRecordData.isFavorite = 1
  end
  self:RefreshBottom()
end

function UILWTruckRecordDetailView:OnTruckRecordFavoriteRemove(message)
  if message.train_uuid == self.trainData.uuid then
    self.trainRecordData.isFavorite = 0
  end
  self:RefreshBottom()
end

function UILWTruckRecordDetailView:RefreshMiddle()
  self.middle:RefreshContentByTrainData(self.trainData)
end

function UILWTruckRecordDetailView:OnDetailDataArrive(trainData)
  self.trainRecordData = trainData
  self.trainData = self.trainRecordData.trainData
  self:RefreshView()
end

function UILWTruckRecordDetailView:OnClickCollectBtn()
  SFSNetwork.SendMessage(MsgDefines.TrainRecordFavoriteAdd, self.trainData.uuid, self.trainData.serverId)
end

function UILWTruckRecordDetailView:OnClickDeleteBtn()
  SFSNetwork.SendMessage(MsgDefines.TrainRecordFavoriteRem, self.trainData.uuid)
end

function UILWTruckRecordDetailView:OnClickShareBtn()
  if self.trainRecordData == nil then
    return
  end
  local shareParam = {}
  shareParam.post = PostType.Truck_Send_Record
  shareParam.param = {}
  shareParam.param.trainUuid = self.trainData.uuid
  shareParam.param.quality = self.trainData.quality
  shareParam.param.trainServerId = self.trainData.serverId
  local lastPlunderRecord
  if not table.IsNullOrEmpty(self.trainData.plunderRecord) then
    lastPlunderRecord = self.trainData.plunderRecord[#self.trainData.plunderRecord]
  end
  if lastPlunderRecord then
    shareParam.param.truckState = lastPlunderRecord.isWin and TruckStateType.DefendSuccess or TruckStateType.Robed
    shareParam.param.otherName = lastPlunderRecord.name
    shareParam.param.otherAbbr = lastPlunderRecord.abbr
  else
    shareParam.param.truckState = TruckStateType.Safe
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
end

return UILWTruckRecordDetailView
