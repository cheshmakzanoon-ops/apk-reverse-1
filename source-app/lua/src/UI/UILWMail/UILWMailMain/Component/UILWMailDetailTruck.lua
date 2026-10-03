local UILWMailDetailTruck = BaseClass("UILWMailDetailTruck", UIBaseContainer)
local base = UIBaseContainer
local FormationHeroItem = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationHeroItem")
local MailRobItem = require("UI.UILWRailway.UILWTruckRecord.UILWTruckRecordDetail.Component.RobItem")
local rapidjson = require("rapidjson")
local TrainData = require("DataCenter.LWRailway.Train.TrainData")

function UILWMailDetailTruck:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailTruck:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailTruck:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailTruck:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailTruck:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailTruck:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailTruck:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailTruck:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailTruck:ComponentDefine()
  self.title1 = self:AddComponent(UIText, "ScrollView/Viewport/Content/Title/title1")
  self.title2 = self:AddComponent(UIText, "ScrollView/Viewport/Content/Title/title2")
  self.coordinateText = self:AddComponent(UIText, "ScrollView/Viewport/Content/train/CoordinateText")
  local coordinateBtn = self:AddComponent(UIButton, "ScrollView/Viewport/Content/train/CoordinateText")
  coordinateBtn:SetOnClick(function()
    self:OnJumpClick()
  end)
  self.quality = self:AddComponent(UIImage, "ScrollView/Viewport/Content/train/quality")
  self.icon = self:AddComponent(UIImage, "ScrollView/Viewport/Content/train/Icon")
  self.tip1 = self:AddComponent(UIText, "ScrollView/Viewport/Content/train/tip1")
  self.tip1:SetLocalText("457570")
  self.tip2 = self:AddComponent(UIText, "ScrollView/Viewport/Content/tip2")
  self.heroContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/train/ScrollRect/Viewport/heroList")
  self.rewardContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/reward/content")
  self.robItem = self.transform:Find("ScrollView/Viewport/Content/robList/robItem").gameObject
  self.robItem:GameObjectCreatePool()
  self.robItem:SetActive(false)
  self.robContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/robList")
  self.heroItems = {}
  for i = 1, ArmyFormationSlot.Dominator do
    self.heroItems[i] = self:AddComponent(FormationHeroItem, "ScrollView/Viewport/Content/train/ScrollRect/Viewport/heroList/FormationSelectHeroItem" .. i)
  end
end

function UILWMailDetailTruck:ComponentDestroy()
  self:ClearReward()
  self.robContent:RemoveComponents(MailRobItem)
  self.robItem.gameObject:GameObjectRecycleAll()
  self.heroItems = {}
  self.quality = nil
  self.tip1 = nil
  self.tip2 = nil
  self.heroContent = nil
  self.rewardContent = nil
  self.robItem = nil
  self.robContent = nil
end

function UILWMailDetailTruck:RefreshContentByTrainData(trainData)
  self.trainData = trainData
  self:RefreshView()
end

function UILWMailDetailTruck:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local msg = rapidjson.decode(self.mailData.contents)
  self.trainData = TrainData.New(msg.obj)
  self:RefreshView()
end

function UILWMailDetailTruck:RefreshView()
  self:Update1000MS()
  self.quality:LoadSprite(self.trainData:GetQualityPath())
  self.icon:LoadSpriteAsyncWithCallback(self.trainData:GetIcon(), function()
    if self.icon then
      self.icon:SetNativeSize()
    end
  end)
  self:RefreshHero()
  self:RefreshReward()
  self:RefreshRobList()
end

function UILWMailDetailTruck:RefreshHero()
  local heroInfo = self.trainData.heroInfo
  local dominatorInfo = heroInfo[ArmyFormationSlot.Dominator]
  if dominatorInfo then
    self.heroItems[ArmyFormationSlot.Dominator]:SetActive(true)
    self.heroItems[ArmyFormationSlot.Dominator]:InitWithConfigId(dominatorInfo.id, nil, dominatorInfo.level, dominatorInfo.rankLv, dominatorInfo.weaponLevel)
  else
    self.heroItems[ArmyFormationSlot.Dominator]:SetActive(false)
  end
  for i = 1, 5 do
    if heroInfo[i] then
      self.heroItems[i]:InitWithConfigId(heroInfo[i].id, nil, heroInfo[i].level, heroInfo[i].rankLv, heroInfo[i].weaponLevel, heroInfo[i].awakenLv, heroInfo[i].heroSkinId)
    else
      self.heroItems[i]:InitWithConfigId(nil)
    end
  end
end

function UILWMailDetailTruck:ClearReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardReqs = {}
end

function UILWMailDetailTruck:RefreshReward()
  self:ClearReward()
  local curRewardList = self.trainData:GetCurRewardData()
  local lostRewardList = self.trainData:GetLostRewardData()
  local curRewardListLength = #curRewardList
  for i, data in ipairs(curRewardList) do
    self:AddOneReward(i, data)
  end
  local showExtraPlunderRewardArr
  for i, data in ipairs(lostRewardList) do
    if data.type ~= RewardType.METAL and data.type ~= RewardType.FOOD and data.type ~= RewardType.WOOD then
      self:AddOneReward(i + curRewardListLength, data, true)
      if data.trainRewardState and data.trainRewardState == TrainRewardState.Extra then
        local rewardIdStr = self:GetRewardIdStr(data)
        if not string.IsNullOrEmpty(rewardIdStr) then
          if showExtraPlunderRewardArr == nil then
            showExtraPlunderRewardArr = {}
          end
          table.insert(showExtraPlunderRewardArr, rewardIdStr)
        end
      end
    end
  end
  if showExtraPlunderRewardArr and 0 < #showExtraPlunderRewardArr then
    Logger.LogInfo(string.format("train uid: %s show extraPlunderReward\239\188\154%s", self.trainData.uuid, table.concat(showExtraPlunderRewardArr, ";")))
  end
  self:TryShowExtraPlunderRewardLog()
end

function UILWMailDetailTruck:AddOneReward(i, data, isLost)
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
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
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
    local isTruck = self.trainData.type == TrainType.Truck
    if isTruck then
      local curMultiVal = self.trainData.multiple
      if curMultiVal and 1 < curMultiVal then
        item:ShowMultiMark(curMultiVal)
      end
    end
  end)
end

function UILWMailDetailTruck:RefreshRobList()
  self.robContent:RemoveComponents(MailRobItem)
  self.robItem.gameObject:GameObjectRecycleAll()
  local trainData = self.trainData
  local itemCount = 0
  if trainData.plunderRecord and 0 < #trainData.plunderRecord then
    self.tip2:SetLocalText("457571")
    for i = 1, #trainData.plunderRecord do
      itemCount = itemCount + 1
      local item = self.robItem:GameObjectSpawn(self.robContent.transform)
      item.name = "RobItem" .. itemCount
      local obj = self.robContent:AddComponent(MailRobItem, item.name)
      obj:SetData(trainData.plunderRecord[i], trainData)
    end
  else
    self.tip2:SetLocalText("457584")
  end
end

function UILWMailDetailTruck:OnJumpClick()
  if not LuaEntry.DataConfig:CheckSwitch("train_cross_server") and CrossServerUtil:NeedIntercept(500020, nil, true) then
    return
  end
  RailwayUtil.JumpToTrainByTrainData(self.trainData)
end

function UILWMailDetailTruck:Update1000MS()
  if not self.trainData or not self.trainData.uuid then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.trainData.marchInfo.isEnd or self.trainData.arriveTs and now > self.trainData.arriveTs then
    self.title1:SetLocalText(457501)
    self.title2:SetLocalText(457502)
  elseif self.trainData.arriveTs then
    self.title1:SetLocalText(457587, UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.trainData.arriveTs - now) .. " ")
    self.title2:SetLocalText(457588)
  end
  if self.trainData:GetTrainState() == TrainState.Travelling then
    local worldPos = self.trainData:CalculateTransform(now)
    local worldTilePos = SceneUtils.WorldToTile(worldPos)
    local locationTxt = string.format("X:%s,Y:%s", worldTilePos.x, worldTilePos.y)
    self.coordinateText:SetText(locationTxt)
  else
    self.coordinateText:SetText("")
  end
end

function UILWMailDetailTruck:TryShowExtraPlunderRewardLog()
  if self.trainData and self.trainData.plunderRecord then
    local logArr
    for _, v in pairs(self.trainData.plunderRecord) do
      if v.extraPlunderReward then
        local extraPlunderRewardCount = #v.extraPlunderReward
        for i = 1, extraPlunderRewardCount do
          local extraReward = v.extraPlunderReward[i]
          local rewardIdStr = self:GetRewardIdStr(extraReward)
          if not string.IsNullOrEmpty(rewardIdStr) then
            if logArr == nil then
              logArr = {}
            end
            table.insert(logArr, rewardIdStr)
          end
        end
      end
    end
    if logArr and 0 < #logArr then
      Logger.LogInfo(string.format("train uid: %s get extraPlunderReward\239\188\154%s", self.trainData.uuid, table.concat(logArr, ";")))
    end
  end
end

function UILWMailDetailTruck:GetRewardIdStr(rewardData)
  local rewardIdStr = ""
  if type(rewardData.value) == "table" then
    if rewardData.value.id then
      rewardIdStr = tostring(rewardData.value.id)
    end
  elseif rewardData.type then
    rewardIdStr = tostring(rewardData.type)
  end
  return rewardIdStr
end

return UILWMailDetailTruck
