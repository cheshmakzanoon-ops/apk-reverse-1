local PrepareSceneCarriage = BaseClass("PrepareSceneCarriage", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RectTransformCSType = typeof(CS.UnityEngine.RectTransform)
local ResourceManager = CS.GameEntry.Resource
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

function PrepareSceneCarriage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.rewardReqs = {}
  self.rewardItems = {}
end

function PrepareSceneCarriage:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PrepareSceneCarriage:ComponentDefine()
  self.headContent = self:AddComponent(UIBaseContainer, "HeadContent")
  self.head = self:AddComponent(UICommonHead, "HeadContent/Head")
  self.head:SetEnableClickShowInfo(true, true)
  self.rewardContent = self:AddComponent(UIBaseContainer, "Goods")
  self.rewardBg = self:AddComponent(UIImage, "Goods")
  self.add = self:AddComponent(UIButton, "Add")
  self.add:SetOnClick(function()
    self:OnClickAdd()
  end)
  self.countBtn = self:AddComponent(UIButton, "countIcon")
  self.count = self:AddComponent(UITextMeshProUGUIEx, "countIcon/count")
  self.countBtn:SetOnClick(function()
    self:OnCountBtnClick()
  end)
  self.glow = self:AddComponent(UIImage, "Glow")
  self.glow:SetActive(false)
  self.checkMark = self:AddComponent(UIBaseComponent, "Toggle/Background/Checkmark")
  self.toggle = self:AddComponent(UIButton, "Toggle")
  self.toggle:SetOnClick(function()
    self:toggleOnClick()
  end)
  self.glowSwitch = false
  self.isVipSelfRewardOpen = LuaEntry.DataConfig:CheckSwitch("train_vip_reward")
end

function PrepareSceneCarriage:ComponentDestroy()
  self:ClearEffect()
  self:ClearReward()
  self:ClearGlow()
  self.headContent = nil
  self.head = nil
  self.rewardContent = nil
  self.rewardBg = nil
  self.add = nil
  self.countBtn = nil
  self.count = nil
  self.glow = nil
  self.trainData = nil
  self.glowSwitch = false
end

function PrepareSceneCarriage:SetHideState(value)
  self.countBtn:SetActive(value)
  self.add:SetActive(value)
end

function PrepareSceneCarriage:toggleOnClick()
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  self.platformState = platformData.state
  if self.platformState == TrainPlatformState.TrainWithPassenger then
    UIUtil.ShowTips(Localization:GetString("alliance_train_vip030"))
    return
  end
  if self.IAmVip and (not self.isVipSelfRewardOpen or not self.vipSelectReward) then
    self.view:OnIAmVipToggleSelect()
    return
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceTrainVipRewardSelectHide)
  if self.checkMark:GetActive() then
  else
    self.view:OnVipToggleSelect(self.index - 1)
  end
end

function PrepareSceneCarriage:ThisIsMyTrain(showSelect, isVip, vipSelectReward)
  self.toggle:SetActive(showSelect)
  self.IAmVip = isVip
  self.vipSelectReward = vipSelectReward
end

function PrepareSceneCarriage:RefreshSelect(nums)
  local findIt = false
  for i, v in ipairs(nums) do
    if v == self.index - 1 then
      findIt = true
      if not self.checkMark:GetActive() then
        self.checkMark:SetActive(true)
      end
    end
  end
  self.checkMark:SetActive(findIt)
end

function PrepareSceneCarriage:Refresh(index, trainData)
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
  self.platformState = platformState
  self.platformData = platformData
  self.trainData = trainData
  local carriageData = trainData.carriages[index]
  self.carriageData = carriageData
  self.rewardBg:LoadSprite(Quality2Bg1[carriageData.quality])
  self:RefreshReward(trainData)
  self:RefreshPage(TrainPreparePage.Passenger)
  self:RefreshGlow()
end

function PrepareSceneCarriage:RefreshPage(curPage)
  local platformState = self.platformState
  local platformData = self.platformData
  local carriageData = self.carriageData
  local curCount = 0
  local myUid = LuaEntry.Player.uid
  local headShow = false
  local addShow = false
  local addGray = false
  self.headContent:SetActive(false)
  self.add:SetActive(false)
  if platformState == TrainPlatformState.TrainNoDriver then
    addShow = true
  elseif platformState == TrainPlatformState.TrainWithDriver then
    addShow = curPage == TrainPreparePage.Passenger
    addGray = self.trainData and self.trainData:IsMyTrain()
    local queueData = platformData.lineUp[self.index] or {}
    self.meInQueue = false
    self.queueLength = #queueData
    curCount = #queueData
    if #queueData == 0 then
    else
      for j = 1, #queueData do
        local data = queueData[j]
        if myUid == data.uid then
          self.meInQueue = true
          headShow = true
          self.head:SetHeadAndFrame(data.uid, data.headPic, data.headPicVer, false, data.headSkinId, data.headSkinET)
        end
      end
    end
  elseif platformState == TrainPlatformState.TrainWithPassenger then
    local passengerList = carriageData.passengerList
    curCount = #passengerList
    for i = 1, curCount do
      local data = passengerList[i]
      if myUid == data.uid then
        headShow = true
        self.head:SetHeadAndFrame(data.uid, data.headPic, data.headPicVer, false, data.headSkinId, data.headSkinET)
      end
    end
  end
  local show = addShow and not headShow and not self.glowSwitch
  self.add:SetActive(show)
  self.headContent:SetActive(headShow)
  self.count:SetText(curCount .. "/" .. DataCenter.LWAllyStationDataManager.MAX_PASSENGER)
end

function PrepareSceneCarriage:ClearReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewardItems = nil
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardReqs = nil
end

function PrepareSceneCarriage:ClearEffect()
  if self.effectReqs then
    for _, req in pairs(self.effectReqs) do
      req:Destroy()
    end
  end
  self.effectReqs = nil
end

function PrepareSceneCarriage:RefreshReward(trainData)
  self.rewardList = {}
  self.rewardIsLostList = {}
  local curRewardList = trainData:GetCurRewardByCarriageId(self.index)
  local lostRewardList = trainData:GetLostRewardByCarriageId(self.index)
  for _, data in ipairs(curRewardList) do
    table.insert(self.rewardList, data)
    table.insert(self.rewardIsLostList, false)
  end
  for _, data in ipairs(lostRewardList) do
    table.insert(self.rewardList, data)
    table.insert(self.rewardIsLostList, true)
  end
  for i, v in ipairs(self.rewardList) do
    self:AddOrRefreshOneReward(i, v, self.rewardIsLostList[i])
  end
  local ur = trainData:IsUR()
  if ur then
    self.effectIndexes = DataCenter.LWAllyStationDataManager:GetURTrainRewardHighlight()
    local count = self.effectIndexes ~= nil and #self.effectIndexes or 0
    if count <= 0 then
      self:ClearEffect()
      return
    end
    if self.effectReqs ~= nil then
      return
    end
    self.effectReqs = {}
    for i = 1, count do
      local req = ResourceManager:InstantiateAsync(EffectAssets.ItemCanGetEffect)
      table.insert(self.effectReqs, req)
      req:completed("+", function(request)
        if self.effectReqs == nil then
          request:Destroy()
          return
        end
        if self.effectIndexes == nil then
          request:Destroy()
          return
        end
        local index = self.effectIndexes[i]
        if index == nil then
          request:Destroy()
          return
        end
        local go = request.gameObject
        local transform = go.transform
        local item = self.rewardItems[index]
        if item == nil then
          go:SetActive(false)
          return
        end
        go:SetActive(true)
        local rectTransform = go:GetComponent(RectTransformCSType)
        transform:SetParent(item.transform)
        rectTransform:Set_anchoredPosition(ResetPosition.x, ResetPosition.y)
        transform:Set_localScale(1.43, 1.43, 1)
      end)
    end
  else
    self:ClearEffect()
  end
end

function PrepareSceneCarriage:RefreshGlow(switch)
  if switch ~= nil then
    self.glowSwitch = switch
  end
  if not self.glowSwitch then
    local isUR = self.trainData and self.carriageData.quality > 4
    if isUR then
      if self.glowTween == nil then
        self.glowTween = self.glow.unity_image:DOFade(0, 2):SetEase(CS.DG.Tweening.Ease.InCirc):SetLoops(-1, CS.DG.Tweening.LoopType.Yoyo)
        self.glow:SetActive(true)
      end
    else
      self:ClearGlow()
    end
  end
end

function PrepareSceneCarriage:ClearGlow(switch)
  if switch ~= nil then
    self.glowSwitch = switch
  end
  if self.glowTween then
    self.glowTween:Kill()
    self.glowTween = nil
    self.glow.unity_image.color = Color(1, 1, 1, 1)
    self.glow:SetActive(false)
  end
end

function PrepareSceneCarriage:SetEffectState(value)
  if #self.rewardItems > 0 then
    local effObject = self.rewardItems[1].transform:Find("Eff_ui_duobao_jiangli_faguang(Clone)")
    if effObject then
      effObject.gameObject:SetActive(value)
    end
  end
end

function PrepareSceneCarriage:AddOrRefreshOneReward(i, data, isLost)
  local rewardItem = self.rewardItems[i]
  if rewardItem then
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
    rewardItem:ReInit(param)
    return
  end
  local req = self.rewardReqs[i]
  if req then
    return
  end
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
    transform:Set_pivot(0, 1)
    local item = self.rewardContent:AddComponent(UICommonResItem, nameStr)
    self.rewardItems[i] = item
    local rewardData = self.rewardList[i]
    local rewardIsLost = self.rewardIsLostList[i]
    local param = UICommonResItem.Param.New()
    param.rewardType = rewardData.type
    if type(rewardData.value) == "table" then
      param.itemId = rewardData.value.id
      param.count = rewardData.value.num
    else
      param.itemId = rewardData.type
      param.count = rewardData.value
    end
    param.rewardType = rewardData.type
    param.heroUuid = rewardData.heroUuid
    param.isHeroBox = rewardData.isHeroBox
    param.isDelete = rewardIsLost
    item:ReInit(param)
    local effectIndex = DataCenter.LWAllyStationDataManager:GetURTrainRewardHighlightIndex(i)
    if 0 < effectIndex and self.effectReqs ~= nil then
      local effectReq = self.effectReqs[effectIndex]
      if effectReq ~= nil and not IsNull(effectReq.gameObject) then
        local effectGo = effectReq.gameObject
        local effectTransform = effectGo.transform
        effectGo:SetActive(true)
        local rectTransform = effectGo:GetComponent(RectTransformCSType)
        effectTransform:SetParent(item.transform)
        rectTransform:Set_anchoredPosition(ResetPosition.x, ResetPosition.y)
        effectTransform:Set_localScale(1.43, 1.43, 1)
      end
    end
  end)
end

function PrepareSceneCarriage:OnClickAdd()
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  local platformState = platformData.state
  if platformState < TrainPlatformState.TrainWithDriver then
    UIUtil.ShowTips(Localization:GetString("alliance_train_028"))
    return
  end
  local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  local now = UITimeManager:GetInstance():GetServerTime()
  local timeLimit = DataCenter.LWAllyStationDataManager.JOIN_ALLIANCE_TIME_LIMIT
  local skipLimit = DataCenter.LWAllyStationDataManager.skipJoinAllianceCD
  if baseData and baseData.joinTime and timeLimit > now - baseData.joinTime and not skipLimit then
    UIUtil.ShowTipsId(458642)
    return
  end
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if trainData and trainData.vipInfo and trainData.vipInfo.vipId == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("alliance_train_vip035")
    return
  end
  if platformData:MeInQueue() then
    if self.meInQueue then
      return
    end
    UIUtil.ShowMessage(Localization:GetString(458548), 2, nil, nil, function()
      SFSNetwork.SendMessage(MsgDefines.AllianceTrainLineUp, self.index - 1)
      if not DataCenter.LWAllyStationDataManager:AlreadyThumbsUp() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainPrepareThanksPopup, {anim = true})
      end
    end)
  else
    local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
    if trainData:IsMyTrain() then
      UIUtil.ShowTipsId(458611)
    else
      SFSNetwork.SendMessage(MsgDefines.AllianceTrainLineUp, self.index - 1)
      if not DataCenter.LWAllyStationDataManager:AlreadyThumbsUp() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainPrepareThanksPopup, {anim = true})
      end
    end
  end
end

function PrepareSceneCarriage:OnCountBtnClick()
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

return PrepareSceneCarriage
