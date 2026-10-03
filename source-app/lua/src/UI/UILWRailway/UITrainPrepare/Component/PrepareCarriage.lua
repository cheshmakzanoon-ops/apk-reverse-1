local PrepareCarriage = BaseClass("PrepareCarriage", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local GameObject = CS.UnityEngine.GameObject
local AnimSlowness = 0.5
local LANG_KEY = {
  [1] = 458549,
  [2] = 458552,
  [3] = 458553
}
local Quality2Bg1 = {
  [1] = "Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_tongmenglieche_jianglibg_bai.png",
  [2] = "Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_tongmenglieche_jianglibg_lv.png",
  [3] = "Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_tongmenglieche_jianglibg_lan.png",
  [4] = "Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_tongmenglieche_jianglibg_zi.png",
  [5] = "Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_tongmenglieche_jianglibg_cheng.png"
}
local Quality2Bg2 = {
  [1] = "Assets/Main/TextureEx/UILWRailway/train/lrb_tongmenghuoche_huoche_bai.png",
  [2] = "Assets/Main/TextureEx/UILWRailway/train/lrb_tongmenghuoche_huoche_lv.png",
  [3] = "Assets/Main/TextureEx/UILWRailway/train/lrb_tongmenghuoche_huoche_lan.png",
  [4] = "Assets/Main/TextureEx/UILWRailway/train/lrb_tongmenghuoche_huoche_zi.png",
  [5] = "Assets/Main/TextureEx/UILWRailway/train/lrb_tongmenghuoche_huoche_cheng.png"
}

function PrepareCarriage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function PrepareCarriage:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PrepareCarriage:ComponentDefine()
  self.halo = self:AddComponent(UIRawImage, "halo")
  self.head = self:AddComponent(UICommonHead, "Head")
  self.head:SetEnableClickShowInfo(true, true)
  self.rewardContent = self:AddComponent(UIBaseContainer, "Goods")
  self.rewardBg = self:AddComponent(UIImage, "Goods")
  self.add = self:AddComponent(UIButton, "Add")
  self.add:SetOnClick(function()
    self:OnClickAdd()
  end)
  self.bubble = self:AddComponent(UIBaseComponent, "Bubble")
  self.level = self:AddComponent(UIText, "Bubble/Level")
  self.name = self:AddComponent(UIText, "Bubble/Name")
  self.none = self:AddComponent(UIBaseComponent, "Bubble/None")
  self.queue = self:AddComponent(UIBaseContainer, "Queue")
  self.queueLayout = self:AddComponent(UIBaseContainer, "Queue/Layout")
  self.queueTip = self:AddComponent(UIText, "Queue/Tip")
  self.countBtn = self:AddComponent(UIButton, "countIcon")
  self.count = self:AddComponent(UITextMeshProUGUIEx, "countIcon/count")
  self.countBtn:SetOnClick(function()
    self:OnCountBtnClick()
  end)
  self.countBtn:SetActive(false)
end

function PrepareCarriage:ComponentDestroy()
  self:ClearBlocker()
  self:ClearTween()
  self:ClearReward()
  self:ClearQueue()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
    return
  end
  if self.timer2 then
    self.timer2:Stop()
    self.timer2 = nil
    return
  end
  self.countBtn = nil
  self.count = nil
  self.trainData = nil
  self.platformData = nil
  self.platformState = nil
end

function PrepareCarriage:ClearBlocker()
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
end

function PrepareCarriage:ClearTween()
  if self.sequence ~= nil then
    self.sequence:Pause()
    self.sequence:Kill()
    self.sequence = nil
  end
end

function PrepareCarriage:DataDefine()
  self.uid2item = {}
  self.queueReqs = {}
end

function PrepareCarriage:DataDestroy()
end

function PrepareCarriage:OnEnable()
  base.OnEnable(self)
end

function PrepareCarriage:OnDisable()
  base.OnDisable(self)
end

function PrepareCarriage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PassengerAnim, self.EnterQueue)
end

function PrepareCarriage:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PassengerAnim, self.EnterQueue)
end

function PrepareCarriage:EnterQueue()
  if self.index == 4 then
    self:EnterQueueAnim()
  end
end

function PrepareCarriage:Refresh(index, trainData)
  self.index = index
  local platformState, platformData
  if trainData then
    self.openType = TrainUIOpenType.Departure
    platformState = TrainPlatformState.TrainWithPassenger
  else
    self.openType = TrainUIOpenType.Prepare
    trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
    platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
    platformState = platformData.state
  end
  self.trainData = trainData
  self.platformState = platformState
  self.platformData = platformData
  local carriageData = trainData.carriages[index]
  self.rewardBg:LoadSprite(Quality2Bg1[carriageData.quality])
  local haloSpritePath = Quality2Bg2[carriageData.quality]
  if UIUtil.CheckAssetDownloaded(haloSpritePath) then
    self.halo:LoadSprite(haloSpritePath)
  else
    self.halo:LoadSpriteAsync(haloSpritePath)
  end
  self:RefreshReward(trainData)
  self.none:SetActive(false)
  self.head:SetActive(false)
  self.add:SetActive(false)
  self.queue:SetActive(false)
  self.bubble:SetActive(false)
  self.level:SetText("")
  self.name:SetText("")
  self.countBtn:SetActive(false)
  if platformState == TrainPlatformState.TrainNoDriver then
  elseif platformState == TrainPlatformState.TrainWithDriver then
    self.add:SetActive(true)
    self.queue:SetActive(true)
    local queueData = platformData.lineUp[index] or {}
    self.meInQueue = false
    self.queueLength = #queueData
    if #queueData == 0 then
      self.queueTip:SetLocalText(458530)
    else
      self.queueTip:SetLocalText(458529)
      for j = 1, #queueData do
        if LuaEntry.Player.uid == queueData[j].uid then
          self.queueTip:SetLocalText(458609)
          self.meInQueue = true
        end
      end
    end
    if self.meInQueue and self.needPlayEnterQueueAnim then
      self:EnterQueueAnim()
    else
      self:RefreshQueue(queueData)
    end
  elseif platformState == TrainPlatformState.TrainWithPassenger then
    self.bubble:SetActive(self.openType == TrainUIOpenType.Prepare)
    local passengerList = carriageData.passengerList
    if self.openType == TrainUIOpenType.Departure then
      local isNewTrainOn = DataCenter.LWAllyStationDataManager:IsNewTrainFunctionOn()
      if isNewTrainOn then
        self.countBtn:SetActive(true)
        local curCount = #passengerList
        self.count:SetText(curCount .. "/" .. DataCenter.LWAllyStationDataManager.MAX_PASSENGER)
        return
      end
    end
    local passenger = passengerList[1]
    if passenger then
      self.head:SetActive(true)
      self.name:SetText(UIUtil.FormatAllianceAndName(passenger.abbr, passenger.name))
      self.level:SetText("Lv." .. passenger.level)
      self.head:SetHeadAndFrame(passenger.uid, passenger.headPic, passenger.headPicVer, false, passenger.headSkinId, passenger.headSkinET)
    else
      self.none:SetActive(true)
    end
  end
end

function PrepareCarriage:OnClickAdd()
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  if platformData:MeInQueue() then
    if self.meInQueue then
      return
    end
    UIUtil.ShowMessage(Localization:GetString(458548), 2, nil, nil, function()
      self.needPlayEnterQueueAnim = true
      SFSNetwork.SendMessage(MsgDefines.AllianceTrainLineUp, self.index - 1)
    end)
  else
    local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
    if trainData:IsMyTrain() then
      UIUtil.ShowTipsId(458611)
    else
      self.needPlayEnterQueueAnim = true
      SFSNetwork.SendMessage(MsgDefines.AllianceTrainLineUp, self.index - 1)
    end
  end
end

function PrepareCarriage:ClearReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardReqs = {}
end

function PrepareCarriage:RefreshReward(trainData)
  self:ClearReward()
  local curRewardList = trainData:GetCurRewardByCarriageId(self.index)
  local lostRewardList = trainData:GetLostRewardByCarriageId(self.index)
  local curRewardListLength = #curRewardList
  for i, data in ipairs(curRewardList) do
    self:AddOneReward(i, data)
  end
  for i, data in ipairs(lostRewardList) do
    self:AddOneReward(i + curRewardListLength, data, true)
  end
end

function PrepareCarriage:AddOneReward(i, data, isLost)
  self.rewardReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
    if IsNull(req.gameObject) then
      return
    end
    local go = req.gameObject
    local index = i
    local nameStr = "UICommonResItem" .. index
    go.name = nameStr
    go:SetActive(true)
    local transform = go.transform
    transform:SetParent(self.rewardContent.transform)
    transform:Set_sizeDelta(150, 150)
    local scale = self.openType == TrainUIOpenType.Prepare and 0.7 or 0.55
    transform:Set_localScale(scale, scale, 1)
    transform:Set_pivot(CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0, 1)
    local item = self.rewardContent:AddComponent(UICommonResItem, nameStr)
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
    param.isDelete = isLost
    item:ReInit(param)
  end)
end

function PrepareCarriage:GetPosXByIndex(index, total)
  if total == 1 then
    return 0
  elseif total == 2 then
    return index == 1 and -50 or 50
  else
    local step = 160 / (total - 1)
    return -80 + step * (index - 1)
  end
end

function PrepareCarriage:GetContractPosXByIndex(index, total)
  if total == 1 then
    return 80
  elseif total == 2 then
    return index == 1 and -80 or 80
  else
    local step = 80 / (total - 1)
    if index <= total // 2 then
      return -80 + step * (index - 1)
    else
      return 80 - step * (total - index)
    end
  end
end

function PrepareCarriage:RefreshQueue(lineUp)
  self:ClearQueue()
  local total = #lineUp
  for i, data in ipairs(lineUp) do
    self.queueReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UIPlayerHead, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local index = i
      local nameStr = "UIPassengerHead" .. index
      go.name = nameStr
      go:SetActive(true)
      local transform = go.transform
      transform:SetParent(self.queueLayout.transform)
      local item = self.queueLayout:AddComponent(UICommonHead, nameStr)
      item:SetAnchorMinXY(0.5, 0.5)
      item:SetAnchorMaxXY(0.5, 0.5)
      transform:Set_localPosition(self:GetPosXByIndex(index, total), 0, 0)
      transform:Set_sizeDelta(110, 110)
      transform:Set_localScale(1, 1, 1)
      transform:Set_pivot(0.5, 0.5)
      local player = data
      item:SetHeadAndFrame(player.uid, player.headPic, player.headPicVer, false, player.headSkinId, player.headSkinET)
      self.uid2item[player.uid] = item
    end)
  end
end

function PrepareCarriage:ClearQueue()
  self.queueLayout:RemoveComponents(UICommonHead)
  self.queue:RemoveComponents(UICommonHead)
  if self.queueReqs then
    for _, req in pairs(self.queueReqs) do
      req:Destroy()
    end
  end
  self.uid2item = {}
  self.queueReqs = {}
end

function PrepareCarriage:EnterQueueAnim()
  self.needPlayEnterQueueAnim = false
  if self.__blockerHandleID then
    return
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 1 + 4 * AnimSlowness)
  local total = #self.queueReqs
  for index, req in pairs(self.queueReqs) do
    local posX = self:GetContractPosXByIndex(index, total)
    if req.gameObject then
      req.gameObject.transform:DOAnchorPosX(posX, AnimSlowness):SetEase(CS.DG.Tweening.Ease.InQuad)
    end
  end
  local newReq = self:GameObjectInstantiateAsync(UIAssets.UIPassengerHead, function(req)
    if IsNull(req.gameObject) then
      return
    end
    local go = req.gameObject
    NameCount = NameCount + 1
    local nameStr = "MyHead" .. NameCount
    go.name = nameStr
    go:SetActive(true)
    local transform = go.transform
    transform:SetParent(self.queueLayout.transform)
    local item = self.queueLayout:AddComponent(UICommonHead, nameStr)
    transform:Set_sizeDelta(110, 110)
    transform:Set_localScale(1, 1, 1)
    item:SetAnchorMinXY(0.5, 0.5)
    item:SetAnchorMaxXY(0.5, 0.5)
    transform:Set_anchoredPosition(0, 100)
    transform:Set_pivot(0.5, 0.5)
    local player = LuaEntry.Player
    self.uid2item[player.uid] = item
    item:SetHeadAndFrame(player.uid, player.pic, player.picVer, false, player.headSkinId, player.headSkinET)
    local anim = item.transform:GetComponent(typeof(CS.SimpleAnimation))
    anim:Play("Default")
    self:ClearTween()
    self.sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence:AppendInterval(AnimSlowness)
    self.sequence:Append(transform:DOAnchorPosY(0, AnimSlowness):SetEase(CS.DG.Tweening.Ease.InQuad))
    self.sequence:AppendCallback(function()
      anim:Play("Enter")
    end)
    self.sequence:AppendInterval(AnimSlowness)
    self.sequence:AppendCallback(function()
      total = #self.queueReqs
      for index, v in pairs(self.queueReqs) do
        local posX = self:GetPosXByIndex(index, total)
        v.gameObject.transform:DOAnchorPosX(posX, AnimSlowness):SetEase(CS.DG.Tweening.Ease.InQuad)
      end
      local childCount = self.queueLayout.transform.childCount
      transform:SetSiblingIndex(childCount // 2)
    end)
    self.sequence:AppendInterval(AnimSlowness)
    self.sequence:AppendCallback(function()
      self:ClearBlocker()
      local param = {
        pos = transform.position,
        player = LuaEntry.Player,
        word = Localization:GetString(LANG_KEY[math.random(#LANG_KEY)])
      }
      EventManager:GetInstance():Broadcast(EventId.PassengerBubble, param)
    end)
  end)
  table.insert(self.queueReqs, #self.queueReqs // 2 + 1, newReq)
end

function PrepareCarriage:GetPlayerHeadByUid(uid)
  return self.uid2item[uid]
end

function PrepareCarriage:OnCountBtnClick()
  if not self.trainData then
    return
  end
  local platformState = self.platformState
  local platformData = self.platformData
  local showList
  if platformState == TrainPlatformState.TrainNoDriver then
  elseif platformState == TrainPlatformState.TrainWithDriver then
    showList = platformData.lineUp[self.index] or {}
  elseif platformState == TrainPlatformState.TrainWithPassenger then
    local carriageData = self.trainData.carriages[self.index]
    showList = carriageData.passengerList
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainPrepareMemberList, {anim = true}, showList)
end

return PrepareCarriage
