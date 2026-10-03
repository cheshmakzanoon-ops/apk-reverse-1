local RobItem = BaseClass("RobItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function RobItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RobItem:OnDestroy()
  BattleReportUtil.Cancel()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RobItem:ComponentDefine()
  self.robItem = self:AddComponent(UIBaseContainer, "robber")
  self.robItemLine = self:AddComponent(UIBaseContainer, "robber/Line")
  self.time = self:AddComponent(UIText, "robber/time")
  self.name = self:AddComponent(UIText, "robber/name")
  self.power = self:AddComponent(UIText, "robber/power")
  self.win = self:AddComponent(UIText, "robber/win")
  self.win:SetLocalText("truck_tips10009")
  self.lose = self:AddComponent(UIText, "robber/lose")
  self.lose:SetLocalText("truck_tips10010")
  self.wantTip = self:AddComponent(UIText, "robber/WantedTip")
  self.wantIcon = self:AddComponent(UIBaseContainer, "robber/Icon")
  self.robIcon = self:AddComponent(UIBaseContainer, "robber/Icon (1)")
  self.replayBtn = self:AddComponent(UIButton, "robber/ReplayBtn")
  self.replayBtn:SetOnClick(function()
    self:OnReplayBtnClick()
  end)
  self.wantedBtn = self:AddComponent(UIButton, "robber/WantedBtn")
  self.wantedBtn:SetOnClick(function()
    self:OnWantedBtnClick()
  end)
  self.head = self:AddComponent(UICommonHead, "robber/UIPlayerHead")
  self.head:SetEnableClickShowInfo(true, true)
  self.goods = self:AddComponent(UIBaseComponent, "goods")
  self.rewardContent = self:AddComponent(UIBaseContainer, "goods/reward/Viewport/Content")
end

function RobItem:ComponentDestroy()
  self.titleTxt = nil
  self.heroCells = nil
end

function RobItem:DataDefine()
end

function RobItem:DataDestroy()
end

function RobItem:OnEnable()
  base.OnEnable(self)
end

function RobItem:OnDisable()
  base.OnDisable(self)
end

function RobItem:OnAddListener()
  base.OnAddListener(self)
end

function RobItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RobItem:OnReplayBtnClick()
  if BattleReportUtil.UseCDNBattleReport() then
    local address = ""
    local addressMode = false
    if self.data and self.data.battleReportAddress then
      address = self.data.battleReportAddress
      addressMode = BattleReportUtil.IsAddressMode(address)
    end
    BattleReportUtil.Create(self.data.battleReportUuid, PVEEnterType.TruckRobRecord, nil, addressMode, address)
  else
    SFSNetwork.SendMessage(MsgDefines.MailGetFightReportDetail, self.data.battleReportUuid)
  end
  PostEventLog.Track(PostEventLog.Defines.click_enter_replay, {
    uuid = tostring(self.data.battleReportUuid)
  })
end

function RobItem:OnWantedBtnClick()
  DataCenter.LWTruckRecordDataManager:SetWantedPlayerByUid(self.data.uid)
  UIUtil.ShowTipsId("city_trade_tips1010")
  EventManager:GetInstance():Broadcast(EventId.TruckRecordWantedUpdate)
end

function RobItem:SetData(data, train)
  self.data = data
  self.trainUuid = train.uuid
  self.trainData = train
  self.time:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(data.time))
  self.name:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.name, data.uid))
  local powerStr = Localization:GetString(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(data.power))
  self.power:SetText(powerStr)
  self.win:SetActive(not data.isWin)
  self.lose:SetActive(data.isWin)
  self.head:SetHead(data.uid, data.headPic, data.headPicVer)
  local isMyTrain = train.ownerId == LuaEntry.Player.uid
  if isMyTrain and not data.isWin then
    local isWanted = DataCenter.LWTruckRecordDataManager:GetIsWantedPlayerByUid(self.data.uid)
    self.wantedBtn:SetActive(not isWanted)
    self.wantIcon:SetActive(isWanted)
    self.robIcon:SetActive(true)
    self.wantTip:SetLocalText("city_trade_tips1010")
    self.wantTip:SetActive(true)
  else
    self.wantedBtn:SetActive(false)
    self.wantIcon:SetActive(false)
    self.robIcon:SetActive(false)
    self.wantTip:SetActive(false)
  end
  self:RefreshReward(isMyTrain)
end

function RobItem:ClearReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardItems = {}
  self.rewardReqs = {}
end

function RobItem:RefreshReward(isMyTrain)
  self:ClearReward()
  local rewardList = {}
  if not table.IsNullOrEmpty(self.data.combinationPlunderReward) then
    for i, data in ipairs(self.data.combinationPlunderReward) do
      table.insert(rewardList, data)
    end
  end
  if not table.IsNullOrEmpty(self.data.retakeReward) then
    for i, data in ipairs(self.data.retakeReward) do
      data.trainRewardState = TrainRewardState.Recapture
      table.insert(rewardList, data)
    end
  end
  local width = self.rectTransform.rect.width
  if rewardList and table.count(rewardList) > 0 then
    self.goods:SetActive(true)
    for i, data in ipairs(rewardList) do
      self:AddOneReward(i, data)
    end
    if isMyTrain then
      self.robItem.rectTransform.sizeDelta = Vector2.New(width, 233)
      self.robItemLine:SetActive(true)
    else
      self.robItem.rectTransform.sizeDelta = Vector2.New(width, 155)
      self.robItemLine:SetActive(false)
    end
  else
    self.goods:SetActive(false)
    self.robItem.rectTransform.sizeDelta = Vector2.New(width, 155)
    self.robItemLine:SetActive(false)
  end
end

function RobItem:AddOneReward(i, data)
  self.rewardReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
    if IsNull(req.gameObject) then
      return
    end
    local go = req.gameObject
    local index = i
    local nameStr = "UICommonResItem" .. index
    go.name = nameStr
    go:SetActive(true)
    go.transform:SetParent(self.rewardContent.transform)
    go.transform:Set_localScale(0.6, 0.6, 0.6)
    go.transform:Set_sizeDelta(150, 150)
    local item = self.rewardContent:AddComponent(UICommonResItem, nameStr)
    item:SetPivotXY(0, 1)
    local param = UICommonResItem.Param.New()
    param.rewardType = data.type
    if type(data.value) == "table" then
      param.itemId = data.value.id
      param.count = data.value.num
    else
      param.itemId = data.type
      param.count = data.value
    end
    param.rewardType = data.type
    param.heroUuid = data.heroUuid
    param.isHeroBox = data.isHeroBox
    if data.trainRewardState then
      param.trainRewardState = data.trainRewardState
      param.isDelete = param.trainRewardState == TrainRewardState.Recapture
    end
    item:ReInit(param)
    if self.trainData then
      local isTruck = self.trainData.type == TrainType.Truck
      if isTruck then
        local curMultiVal = self.trainData.multiple
        if curMultiVal and 1 < curMultiVal then
          item:ShowMultiMark(curMultiVal)
        end
      end
    end
    self.rewardItems[index] = item
  end)
end

return RobItem
