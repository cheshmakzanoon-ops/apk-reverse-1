local base = UIBaseView
local UITrainBattleRecordView = BaseClass("UITrainBattleRecordView", base)
local TrainBattleRecordItem = require("UI.UILWRailway.UITrainBattleRecord.Component.TrainBattleRecordItem")

function UITrainBattleRecordView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITrainBattleRecordView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UITrainBattleRecordView:ComponentDefine()
  self.returnBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.closeBtn = self:AddComponent(UIButton, "Root/CloseBtn")
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "Root/ScrollView/Viewport/Content")
  self.loopListView = self:AddComponent(UILoopListView2, "Root/ScrollView")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.emptyTxt = self:AddComponent(UIBaseComponent, "Root/NoRecord")
end

function UITrainBattleRecordView:ComponentDestroy()
  self:RemoveItems()
  self.loopListView = nil
end

function UITrainBattleRecordView:DataDefine()
  self.trainData = self:GetUserData()
  self.kofRecord = false
  RailwayUtil.GetAllianceTrainBattleRecord(self.trainData)
end

function UITrainBattleRecordView:DataDestroy()
end

function UITrainBattleRecordView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceTrainBattleRecordList, self.Refresh)
  self:AddUIListener(EventId.AllianceTrainBattleRecordDetail, self.OpenDetailUI)
  self:AddUIListener(EventId.AllianceTrainKOFBattleRecordList, self.RefreshKOF)
  self:AddUIListener(EventId.AllianceTrainKOFBattleRecordDetail, self.OpenKOFDetailUI)
end

function UITrainBattleRecordView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceTrainBattleRecordList, self.Refresh)
  self:RemoveUIListener(EventId.AllianceTrainBattleRecordDetail, self.OpenDetailUI)
  self:RemoveUIListener(EventId.AllianceTrainKOFBattleRecordList, self.RefreshKOF)
  self:RemoveUIListener(EventId.AllianceTrainKOFBattleRecordDetail, self.OpenKOFDetailUI)
end

function UITrainBattleRecordView:Refresh(msg)
  if self.trainData.uuid ~= msg.trainUuid then
    return
  end
  self.kofRecord = false
  self:RemoveItems()
  self.dataList = msg.list or {}
  local dataCount = #self.dataList
  self.emptyTxt:SetActive(dataCount <= 0)
  self.loopListView:SetListItemCount(dataCount, false, false)
  self.loopListView:RefreshAllShownItem()
end

function UITrainBattleRecordView:RefreshKOF(msg)
  if self.trainData.uuid ~= msg.trainUuid then
    return
  end
  self.kofRecord = true
  self:RemoveItems()
  self.dataList = msg.list or {}
  local dataCount = #self.dataList
  self.emptyTxt:SetActive(dataCount <= 0)
  self.loopListView:SetListItemCount(dataCount, false, false)
  self.loopListView:RefreshAllShownItem()
end

function UITrainBattleRecordView:RemoveItems()
  self.items = {}
  self.content:RemoveComponents(TrainBattleRecordItem)
  self.loopListView:ClearAllItems()
end

function UITrainBattleRecordView:GetScrollItem(listview, index)
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
  self.items[csItem]:Refresh(dataList[index], self.trainData.ownerId, self.trainData.vipInfo)
  return csItem
end

function UITrainBattleRecordView:GetDetail(uuid)
  if self.getting then
    return
  end
  self.getting = true
  if self.kofRecord then
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainKOFBattleDetail, uuid)
  else
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainBattleDetail, uuid)
  end
end

function UITrainBattleRecordView:OpenDetailUI(msg)
  self.getting = false
  for _, v in pairs(self.dataList) do
    if v.uuid == msg.uuid then
      local defender = {}
      local attacker = {}
      attacker.uid = v.uid
      attacker.pic = v.headPic
      attacker.picver = v.headPicVer
      attacker.headSkinId = v.headSkinId
      attacker.headSkinET = v.headSkinET
      attacker.name = v.name
      attacker.abbr = v.abbr
      attacker.serverId = v.serverId
      local trainData = self.trainData
      defender.uid = trainData.ownerId
      defender.pic = trainData.pic
      defender.picver = trainData.picVer
      defender.headSkinId = trainData.headSkinId
      defender.headSkinET = trainData.headSkinET
      defender.name = trainData.name
      defender.abbr = trainData.abbr
      defender.serverId = trainData.serverId
      msg.info.isWin = not msg.info.isWin
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain3V3BattleResult, {anim = false}, msg.info, attacker, defender)
      return
    end
  end
end

function UITrainBattleRecordView:OpenKOFDetailUI(msg)
  self.getting = false
  if msg.info and msg.info.mailUid then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMailMain)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, msg.info.mailUid, "TrainKOFBattleRecord")
  end
end

return UITrainBattleRecordView
