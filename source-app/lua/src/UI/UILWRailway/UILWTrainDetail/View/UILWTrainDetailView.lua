local UILWTrainDetailView = BaseClass("UILWTrainDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local MailDetailTruck = require("UI.UILWMail.UILWMailMain.Component.UILWMailDetailTruck")

function UILWTrainDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UILWTrainDetailView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTrainDetailView:ComponentDefine()
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
  self.middle = self:AddComponent(MailDetailTruck, "Root/Middle/MailDetailTruck")
end

function UILWTrainDetailView:ComponentDestroy()
end

function UILWTrainDetailView:DataDefine()
  self.trainData = self:GetUserData()
  if self.trainData.uuid == nil then
    Logger.LogError("\232\191\153\230\152\175\228\184\170\230\143\144\231\164\186\230\128\167\230\138\165\233\148\153\239\188\154\231\129\171\232\189\166\230\149\176\230\141\174\228\184\186\231\169\186")
  else
    SFSNetwork.SendMessage(MsgDefines.TrainRecordDetail, self.trainData.uuid, self.trainData.serverId)
  end
end

function UILWTrainDetailView:DataDestroy()
end

function UILWTrainDetailView:OnEnable()
  base.OnEnable(self)
end

function UILWTrainDetailView:OnDisable()
  base.OnDisable(self)
end

function UILWTrainDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshOneMyTruck, self.RefreshBottom)
  self:AddUIListener(EventId.TruckRecordFavoriteAdd, self.OnTruckRecordFavoriteAdd)
  self:AddUIListener(EventId.TruckRecordFavoriteRemove, self.OnTruckRecordFavoriteRemove)
  self:AddUIListener(EventId.TruckRecordDetailDataArrive, self.OnDetailDataArrive)
  self:AddUIListener(EventId.TruckRecordWantedUpdate, self.RefreshMiddle)
end

function UILWTrainDetailView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshOneMyTruck, self.RefreshBottom)
  self:RemoveUIListener(EventId.TruckRecordFavoriteAdd, self.OnTruckRecordFavoriteAdd)
  self:RemoveUIListener(EventId.TruckRecordFavoriteRemove, self.OnTruckRecordFavoriteRemove)
  self:RemoveUIListener(EventId.TruckRecordDetailDataArrive, self.OnDetailDataArrive)
  self:RemoveUIListener(EventId.TruckRecordWantedUpdate, self.RefreshMiddle)
end

function UILWTrainDetailView:RefreshView()
  self:RefreshTop()
  self:RefreshBottom()
  self:RefreshMiddle()
end

function UILWTrainDetailView:RefreshTop()
end

function UILWTrainDetailView:RefreshBottom()
  local isCollect = false
  if self.trainRecordData then
    isCollect = self.trainRecordData.isFavorite == 1
  end
  self.collectBtn:SetActive(not isCollect)
  self.deleteBtn:SetActive(isCollect)
  self.shareBtn:SetActive(self.trainRecordData)
end

function UILWTrainDetailView:RefreshMiddle()
  self.middle:RefreshContentByTrainData(self.trainData)
end

function UILWTrainDetailView:OnReceiveClick()
end

function UILWTrainDetailView:OnTruckRecordFavoriteAdd(message)
  if message.train_uuid == self.trainData.uuid and self.trainRecordData then
    self.trainRecordData.isFavorite = 1
  end
  self:RefreshBottom()
end

function UILWTrainDetailView:OnTruckRecordFavoriteRemove(message)
  if message.train_uuid == self.trainData.uuid and self.trainRecordData then
    self.trainRecordData.isFavorite = 0
  end
  self:RefreshBottom()
end

local function CheckNeedRefresh(trainData1, trainData2)
  local plunderRecord1 = trainData1.plunderRecord
  local plunderRecord2 = trainData2.plunderRecord
  if plunderRecord1 == nil or plunderRecord2 == nil then
    return true
  end
  if table.count(plunderRecord1) ~= table.count(plunderRecord2) then
    return true
  end
  for k, v in pairs(plunderRecord1) do
    if plunderRecord2[k] == nil or plunderRecord2[k].battleReportUuid ~= v.battleReportUuid then
      return true
    end
  end
  return false
end

function UILWTrainDetailView:OnDetailDataArrive(trainRecordData)
  if trainRecordData and trainRecordData.trainData and self.trainData and self.trainData.uuid == trainRecordData.trainData.uuid then
    self.trainRecordData = trainRecordData
    if CheckNeedRefresh(self.trainData, trainRecordData.trainData) then
      self.trainData = trainRecordData.trainData
      self:RefreshView()
    else
      self:RefreshBottom()
    end
  end
end

function UILWTrainDetailView:OnClickCollectBtn()
  SFSNetwork.SendMessage(MsgDefines.TrainRecordFavoriteAdd, self.trainData.uuid, self.trainData.serverId)
end

function UILWTrainDetailView:OnClickDeleteBtn()
  SFSNetwork.SendMessage(MsgDefines.TrainRecordFavoriteRem, self.trainData.uuid)
end

function UILWTrainDetailView:OnClickShareBtn()
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

return UILWTrainDetailView
