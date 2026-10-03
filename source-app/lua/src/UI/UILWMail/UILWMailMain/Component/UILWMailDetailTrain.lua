local UILWMailDetailTrain = BaseClass("UILWMailDetailTrain", UIBaseContainer)
local base = UIBaseContainer
local rapidjson = require("rapidjson")
local TrainData = require("DataCenter.LWRailway.Train.TrainData")
local TrainBattleRecordItem = require("UI.UILWRailway.UITrainBattleRecord.Component.TrainBattleRecordItem")
local PassengerItem = require("UI.UILWMail.UILWMailMain.Component.PassengerItem")

function UILWMailDetailTrain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailTrain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailTrain:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailTrain:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailTrain:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailTrain:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailTrain:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailTrain:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailTrain:ComponentDefine()
  self.title1 = self:AddComponent(UIText, "ScrollView/Viewport/Content/Title/title1")
  self.title2 = self:AddComponent(UIText, "ScrollView/Viewport/Content/Title/title2")
  self.quality = self:AddComponent(UIImage, "ScrollView/Viewport/Content/Driver/quality")
  self.trainIcon = self:AddComponent(UIRawImage, "ScrollView/Viewport/Content/Driver/RawImage")
  self.name = self:AddComponent(UIText, "ScrollView/Viewport/Content/Driver/name")
  self.level = self:AddComponent(UIText, "ScrollView/Viewport/Content/Driver/level")
  self.power = self:AddComponent(UIText, "ScrollView/Viewport/Content/Driver/power")
  self.head = self:AddComponent(UICommonHead, "ScrollView/Viewport/Content/Driver/DriverHead")
  self.passengerContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/Passengers")
  self.tip2 = self:AddComponent(UIText, "ScrollView/Viewport/Content/tip2")
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/robList/Viewport/Content")
  self.loopListView = self:AddComponent(UILoopListView2, "ScrollView/Viewport/Content/robList")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.infoBtn = self:AddComponent(UIButton, "infoBtn")
  self.infoBtn:SetOnClick(function()
    self:OnClickInfo()
  end)
end

function UILWMailDetailTrain:ComponentDestroy()
  self:RemovePassenger()
  self:RemoveRecord()
  self.quality = nil
  self.tip1 = nil
  self.tip2 = nil
  self.heroContent = nil
  self.passengerContent = nil
  self.robItem = nil
  self.robContent = nil
end

function UILWMailDetailTrain:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local msg = rapidjson.decode(self.mailData.contents)
  if self.mailData.type == MailType.TRAIN_DEPARTURE then
    self.trainData = TrainData.New(msg.obj)
  elseif self.mailData.type == MailType.TRAIN_ARRIVE then
    self.trainData = TrainData.New(msg.obj.trainObj)
    self.history = msg.obj.history
  end
  self:RefreshView()
end

function UILWMailDetailTrain:RefreshView()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.title1:SetText(_strTitle)
  local _strSubTitle = self.mailData:GetMailMessage()
  self.title2:SetText(_strSubTitle)
  self:RefreshDriver()
  self:RefreshPassenger()
  self:RefreshRecord()
end

function UILWMailDetailTrain:RefreshDriver()
  local data = self.trainData
  self.quality:LoadSprite(data:GetQualityPath())
  self.trainIcon:LoadSprite(data:GetTrainIcon())
  self.head:SetHeadAndFrame(data.ownerId, data.pic, data.picVer, false, data.headSkinId, data.headSkinET)
  self.name:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.name))
  self.level:SetText("Lv." .. data.ownerLv)
  self.power:SetText(string.GetFormattedSeparatorNum(data.power))
end

function UILWMailDetailTrain:RemovePassenger()
  self.passengerContent:RemoveComponents(PassengerItem)
  if self.passengerReqs then
    for _, req in pairs(self.passengerReqs) do
      req:Destroy()
    end
  end
  self.passengerReqs = {}
end

function UILWMailDetailTrain:RefreshPassenger()
  self:RemovePassenger()
  local index = 0
  for _, v in pairs(self.trainData.carriages) do
    for _, passenger in pairs(v.passengerList) do
      if passenger.uid ~= self.trainData.ownerId then
        index = index + 1
        self:AddOnePassenger(index, passenger)
      end
    end
  end
  self.passengerContent:SetActive(0 < index)
end

function UILWMailDetailTrain:AddOnePassenger(i, data)
  self.passengerReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMail/Passenger.prefab", function(req)
    if IsNull(req.gameObject) then
      return
    end
    local go = req.gameObject
    local index = i
    local nameStr = "Passenger" .. index
    go.name = nameStr
    go:SetActive(true)
    go.transform:SetParent(self.passengerContent.transform)
    go.transform:Set_localScale(1, 1, 1)
    local item = self.passengerContent:AddComponent(PassengerItem, nameStr)
    item:Refresh(data)
  end)
end

function UILWMailDetailTrain:RemoveRecord()
  self.items = {}
  self.content:RemoveComponents(TrainBattleRecordItem)
  self.loopListView:ClearAllItems()
end

function UILWMailDetailTrain:RefreshRecord()
  self:RemoveRecord()
  self.dataList = self.history or {}
  local dataCount = #self.dataList
  self.loopListView:SetListItemCount(dataCount, false, false)
  self.loopListView:RefreshAllShownItem()
end

function UILWMailDetailTrain:GetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local data = dataList[index]
  local csItem = listview:NewListViewItem(data.isWin and "TrainRecordItemWin" or "TrainRecordItemLose")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "TrainRecordItem" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(TrainBattleRecordItem, nameStr)
  end
  self.items[csItem]:Refresh(dataList[index])
  return csItem
end

function UILWMailDetailTrain:OnClickInfo()
  RailwayUtil.OpenTrainInfoUI(self.trainData)
end

return UILWMailDetailTrain
