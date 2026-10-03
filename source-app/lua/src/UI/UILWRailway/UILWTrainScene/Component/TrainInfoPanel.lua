local btn_go_quick_path = "content_btns/BtnGoQuick"
local btn_share_quick_path = "content_btns/BtnShareQuick"
local TrainInfoPanel = BaseClass("TrainInfoPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Quality2Bg1 = {
  [1] = "Assets/Main/TextureEx/UILWRailway/train/lrb_chengjimaoyi_listN_bg.png",
  [2] = "Assets/Main/TextureEx/UILWRailway/train/lrb_chengjimaoyi_listR_bg.png",
  [3] = "Assets/Main/TextureEx/UILWRailway/train/lrb_chengjimaoyi_listSR_bg.png",
  [4] = "Assets/Main/TextureEx/UILWRailway/train/lrb_chengjimaoyi_listSSR_bg.png",
  [5] = "Assets/Main/TextureEx/UILWRailway/train/lrb_chengjimaoyi_listUR_bg.png",
  [10] = "Assets/Main/TextureEx/UILWRailway/train/lrb_chengjimaoyi_listUR_bg.png"
}
local Quality2Bg2 = {
  [1] = "Assets/Main/Sprites/UI/UILWRailway/lrb_chengjimaoyi_titleN_bg.png",
  [2] = "Assets/Main/Sprites/UI/UILWRailway/lrb_chengjimaoyi_titleR_bg.png",
  [3] = "Assets/Main/Sprites/UI/UILWRailway/lrb_chengjimaoyi_titleSR_bg.png",
  [4] = "Assets/Main/Sprites/UI/UILWRailway/lrb_chengjimaoyi_titleSSR_bg.png",
  [5] = "Assets/Main/Sprites/UI/UILWRailway/lrb_chengjimaoyi_titleUR_bg.png",
  [10] = "Assets/Main/Sprites/UI/UILWRailway/lrb_chengjimaoyi_titleUR_bg.png"
}
local Quality2Bg0 = {
  [1] = Color.New(0.8, 0.8, 0.85, 0.5),
  [2] = Color.New(1, 0.96, 0.87, 0.5),
  [3] = Color.New(0.53, 0.94, 1, 0.5),
  [4] = Color.New(0.99, 0.79, 0.94, 0.5),
  [5] = Color.New(1, 0.78, 0.6, 0.5),
  [10] = Color.New(1, 0.78, 0.6, 0.5)
}

function TrainInfoPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TrainInfoPanel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TrainInfoPanel:ComponentDefine()
  self.bg0 = self:AddComponent(UIImage, "bg0")
  self.bg1 = self:AddComponent(UIRawImage, "bg1")
  self.bg2 = self:AddComponent(UIImage, "bg2")
  self.bg3 = self:AddComponent(UIRawImage, "bg3")
  self.bg4 = self:AddComponent(UIImage, "bg4")
  self.bgTrain = self:AddComponent(UIRawImage, "bgTrain")
  self.qualityImage = self:AddComponent(UIImage, "Quality")
  self.time = self:AddComponent(UIText, "Time")
  self.name = self:AddComponent(UIText, "Name")
  self.level = self:AddComponent(UIText, "Level")
  self.power = self:AddComponent(UIText, "Power")
  self.head = self:AddComponent(UICommonHead, "Head")
  self.head:SetEnableClickShowInfo(true, true)
  self.goBtn = self:AddComponent(UIButton, "content_btns/BtnGo")
  self.goBtn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.shareBtn = self:AddComponent(UIButton, "content_btns/BtnShare")
  self.shareBtn:SetOnClick(function()
    self:OnShareClick()
  end)
  self.criminalBtn = self:AddComponent(UIButton, "Name/criminalBtn")
  self.criminalBtn:SetOnClick(function()
    self:OnClickCriminal()
  end)
  self.goBtnText = self:AddComponent(UIText, "content_btns/BtnGo/GoBtnText")
  self.goBtnImg = self:AddComponent(UIImage, "content_btns/BtnGo/GoBtnImg")
  self.rewardContent = self:AddComponent(UIBaseContainer, "ScrollRect/ViewPort/Content")
  self.btn_go_quick = self:AddComponent(UIButton, btn_go_quick_path)
  self.btn_go_quick:SetOnClick(function()
    self:OnGoQuickClick()
  end)
  self.btn_share_quick = self:AddComponent(UIButton, btn_share_quick_path)
  self.btn_share_quick:SetOnClick(function()
    self:OnShareClick()
  end)
end

function TrainInfoPanel:ComponentDestroy()
  self:ClearReward()
  self.head = nil
  self.btn_go_quick = nil
  self.btn_share_quick = nil
end

function TrainInfoPanel:DataDefine()
end

function TrainInfoPanel:DataDestroy()
  self.trainData = nil
  self.tabType = nil
end

function TrainInfoPanel:OnEnable()
  base.OnEnable(self)
end

function TrainInfoPanel:OnDisable()
  base.OnDisable(self)
end

function TrainInfoPanel:OnAddListener()
  base.OnAddListener(self)
end

function TrainInfoPanel:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TrainInfoPanel:update()
end

function TrainInfoPanel:Update1000MS()
  if self.trainData == nil or self.trainData.arriveTs == nil then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > self.trainData.arriveTs then
    self.time:SetLocalText(457520)
  else
    self.time:SetText(Localization:GetString(457506) .. " " .. UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.trainData.arriveTs - now))
  end
  if self.tabType == TrainTab.Enemy and self.trainData.type == TrainType.Train then
    local protectTime = self.trainData.marchInfo.protectTime
    if now < protectTime then
      local time = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(protectTime - now)
      self.goBtnText:SetText(time)
      self:SetGoBtnGray(true)
    else
      self.goBtnText:SetLocalText("457514")
      self:SetGoBtnGray(false)
    end
  end
end

function TrainInfoPanel:SetData(trainData, tabType)
  if trainData == nil or trainData.uuid == nil then
    return
  end
  self.trainData = trainData
  self.tabType = tabType
  self:Update1000MS()
  self.head:SetHeadAndFrame(trainData.ownerId, trainData.pic, trainData.picVer, false, trainData.headSkinId, trainData.headSkinET)
  self.name:SetText(trainData:GetAbbrAndName())
  self.level:SetText("Lv." .. (trainData.ownerLv or LuaEntry.Player.level))
  self.power:SetText(string.GetFormattedStr(math.floor(trainData.power)))
  if tabType == TrainTab.Enemy then
    if self.trainData.type == TrainType.Train then
      local protectTime = self.trainData.marchInfo.protectTime
      local now = UITimeManager:GetInstance():GetServerTime()
      if protectTime > now then
        local time = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(protectTime - now)
        self.goBtnText:SetText(time)
        self:SetGoBtnGray(true, true)
      else
        self.goBtnText:SetLocalText("457514")
        self:SetGoBtnGray(false, true)
      end
    else
      self.goBtnText:SetLocalText("457514")
      self:SetGoBtnGray(false, true)
    end
    self.goBtnImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_4.png")
  else
    self.goBtnText:SetLocalText("457518")
    self.goBtnImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_5.png")
    self:SetGoBtnGray(false, true)
  end
  self.criminalBtn:SetActive(trainData.enemy)
  local quality = self.trainData.quality
  local bg0Color = Quality2Bg0[quality]
  if bg0Color == nil then
    local trainUUid = self.trainData.uuid or 0
    local trainQuality = quality or 0
    Logger.LogError("train quality invalid : uuid : " .. trainUUid .. " ; quality : " .. trainQuality)
    return
  end
  self.bg0:SetColor(bg0Color)
  local bg1Path = Quality2Bg1[quality]
  if UIUtil.CheckAssetDownloaded(bg1Path) then
    self.bg1:LoadSprite(bg1Path)
  else
    self.bg1:LoadSpriteAsync(bg1Path)
  end
  self.bg2:LoadSprite(Quality2Bg2[quality])
  local qualityBgPath = QualityTrainBgPath[quality]
  if UIUtil.CheckAssetDownloaded(qualityBgPath) then
    self.bg3:LoadSprite(qualityBgPath)
  else
    self.bg3:LoadSpriteAsync(qualityBgPath)
  end
  if trainData.type == TrainType.Truck then
    self.bg4:LoadSpriteAsyncWithCallback(trainData:GetIcon(LuaEntry.Player:GetSourceServerId()), function()
      if self.bg4 then
        self.bg4:SetNativeSize()
      end
    end)
    self.bg4:SetActive(true)
  else
    self.bg4:SetActive(false)
  end
  self.bgTrain:SetActive(trainData.type == TrainType.Train)
  self.qualityImage:LoadSprite(trainData:GetQualityPath())
  if trainData.type == TrainType.Train then
    self.bgTrain:LoadSprite(trainData:GetTrainIcon())
  end
  self:RefreshReward()
  self.isQuickRobFuncOpen = DataCenter.LWTrainDataManager:IsTrainRobQuickFuncOpen()
  local useQuick = self.isQuickRobFuncOpen and self.tabType == TrainTab.Enemy
  self.btn_go_quick:SetActive(useQuick)
  self.shareBtn:SetActive(not useQuick)
  self.btn_share_quick:SetActive(useQuick)
  if useQuick and not CommonUtil.PlayerPrefsGetBool(SettingKeys.TRAIN_ROB_QUICK_PLOT, false) then
    CommonUtil.PlayerPrefsSetBool(SettingKeys.TRAIN_ROB_QUICK_PLOT, true)
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = 9291, hideMainUI = false})
  end
end

function TrainInfoPanel:TryRefreshMyTrain()
  if not self:GetActive() then
    return
  end
  if not self.trainData then
    return
  end
  if not self.tabType then
    return
  end
  if self.tabType ~= TrainTab.Mine then
    return
  end
  if self.trainData.type == TrainType.Truck then
    self.power:SetText(string.GetFormattedStr(math.floor(self.trainData.power)))
  end
end

function TrainInfoPanel:SetGoBtnGray(gray, force)
  if force then
    CS.UIGray.SetGray(self.goBtn.transform, gray, true)
    self.goBtnGray = gray
    return
  end
  if self.goBtnGray == nil or self.goBtnGray ~= gray then
    CS.UIGray.SetGray(self.goBtn.transform, gray, true)
    self.goBtnGray = gray
  end
end

function TrainInfoPanel:OnGoClick()
  local tmpServerId = 0
  local tmpUuid = 0
  local lastPointOrder, lastPullInTs, lastPullOutTs, wayListLog, worldCityTableName = 0, 0, 0, "", ""
  if self.trainData then
    tmpServerId = self.trainData.serverId
    tmpUuid = self.trainData.marchUid
    lastPointOrder, lastPullInTs, lastPullOutTs, wayListLog, worldCityTableName = self.trainData:GetDebugInfos()
  end
  local targetPos, now = RailwayUtil.JumpToTrainByTrainData(self.trainData)
  if targetPos ~= nil and 0 < tmpServerId and tmpUuid ~= nil then
    local point = SceneUtils.WorldToTile(targetPos)
    local pointId = SceneUtils.TileXYToIndex(point.x, point.y, ForceChangeScene.World)
    local nowTs = now or 0
    SFSNetwork.SendMessage(MsgDefines.TrainMarchGetPos, pointId, tmpServerId, 0, tmpUuid, nowTs, lastPointOrder, lastPullInTs, lastPullOutTs, wayListLog, worldCityTableName)
  end
  local useQuick = self.isQuickRobFuncOpen and self.tabType == TrainTab.Enemy
  if useQuick then
    PostEventLog.Track(PostEventLog.Defines.TRAIN_ROB_QUICK_BTN_CLICK, {isQuick = false})
  end
end

function TrainInfoPanel:OnGoQuickClick()
  if self.trainData ~= nil and self.isQuickRobFuncOpen then
    PostEventLog.Track(PostEventLog.Defines.TRAIN_ROB_QUICK_BTN_CLICK, {isQuick = true})
    RailwayUtil.ClickAttackTrain(self.trainData, true)
  end
end

function TrainInfoPanel:OnClickCriminal()
  local pos = self.criminalBtn:GetPosition()
  local rewardData = self.trainData.enemy.reward
  local textStr = UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(self.trainData.enemy.createTime)
  textStr = Localization:GetString(457597, textStr)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonRewardTip, {anim = true}, pos, textStr, rewardData)
end

function TrainInfoPanel:ClearReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardReqs = {}
end

function TrainInfoPanel:RefreshReward()
  self:ClearReward()
  local curRewardList = self.trainData:GetCurRewardData()
  local lostRewardList = self.trainData:GetLostRewardData()
  local curRewardListLength = #curRewardList
  for i, data in ipairs(curRewardList) do
    self:AddOneReward(i, data)
  end
  for i, data in ipairs(lostRewardList) do
    if data.type ~= RewardType.METAL and data.type ~= RewardType.FOOD and data.type ~= RewardType.WOOD then
      self:AddOneReward(i + curRewardListLength, data, true)
    end
  end
end

function TrainInfoPanel:AddOneReward(i, data, isLost)
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
    transform:Set_localScale(0.7, 0.7, 1)
    transform:Set_pivot(0, 1)
    local item = self.rewardContent:AddComponent(UICommonResItem, nameStr)
    local param = UICommonResItem.Param.New()
    param.rewardType = data.type
    if type(data.value) == "table" then
      param.itemId = data.value.id
      param.count = data.value.num
    else
      param.itemId = data.type
      param.count = data.value
      local effectValue = self.trainData:GetEffectValue(EffectDefine.LW_BASIC_RESOURCE_PRODUCT_PROMOTION)
      param.isShowArrow = 0 < effectValue
    end
    param.rewardType = data.type
    param.heroUuid = data.heroUuid
    param.isHeroBox = data.isHeroBox
    param.isDelete = isLost
    item:ReInit(param)
    local isTruck = self.trainData.type == TrainType.Truck
    if isTruck then
      local curMultiVal = self.trainData.multiple
      if curMultiVal and 1 < curMultiVal then
        item:ShowMultiMark(curMultiVal)
      end
    end
  end)
end

function TrainInfoPanel:OnShareClick()
  RailwayUtil.ShareTrainByTrainData(self.trainData)
end

return TrainInfoPanel
