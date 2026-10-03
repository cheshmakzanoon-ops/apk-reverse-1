local TruckRecordDetail = BaseClass("TruckRecordDetail", UIBaseContainer)
local base = UIBaseContainer
local FormationHeroItem = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationHeroItem")
local RobItem = require("UI.UILWRailway.UILWTruckRecord.UILWTruckRecordDetail.Component.RobItem")
local rapidjson = require("rapidjson")
local TrainData = require("DataCenter.LWRailway.Train.TrainData")

function TruckRecordDetail:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TruckRecordDetail:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TruckRecordDetail:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function TruckRecordDetail:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function TruckRecordDetail:OnEnable()
  self:AddUpdateTimer()
  base.OnEnable(self)
end

function TruckRecordDetail:OnDisable()
  self:RemoveUpdateTimer()
  base.OnDisable(self)
end

function TruckRecordDetail:OnAddListener()
  base.OnAddListener(self)
end

function TruckRecordDetail:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TruckRecordDetail:ComponentDefine()
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
  self.heroContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/train/heroList")
  self.rewardContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/train/reward/Viewport/Content")
  self.ownerPlayerHead = self:AddComponent(UICommonHead, "ScrollView/Viewport/Content/Owner/UIPlayerHead")
  self.ownerPlayerHead:SetEnableClickShowInfo(true, true)
  self.ownerName = self:AddComponent(UIText, "ScrollView/Viewport/Content/Owner/Name")
  self.ownerLevel = self:AddComponent(UIText, "ScrollView/Viewport/Content/Owner/Level")
  self.ownerPower = self:AddComponent(UIText, "ScrollView/Viewport/Content/train/power")
  self.robItem = self.transform:Find("ScrollView/Viewport/Content/robList/robItem").gameObject
  self.robItem:GameObjectCreatePool()
  self.robItem:SetActive(false)
  self.robContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/robList")
  self.heroItems = {}
  for i = 1, 5 do
    self.heroItems[i] = self:AddComponent(FormationHeroItem, "ScrollView/Viewport/Content/train/heroList/FormationSelectHeroItem" .. i)
  end
end

function TruckRecordDetail:ComponentDestroy()
  self:RemoveUpdateTimer()
  self:ClearReward()
  self.robContent:RemoveComponents(RobItem)
  self.robItem.gameObject:GameObjectRecycleAll()
  self.heroItems = {}
  self.quality = nil
  self.tip1 = nil
  self.tip2 = nil
  self.heroContent = nil
  self.rewardContent = nil
  self.robItem = nil
  self.robContent = nil
  self.ownerPlayerHead = nil
  self.ownerName = nil
  self.ownerLevel = nil
  self.ownerPower = nil
end

function TruckRecordDetail:RefreshContentByTrainData(trainData)
  self.trainData = trainData
  self:RefreshView()
end

function TruckRecordDetail:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local msg = rapidjson.decode(self.mailData.contents)
  self.trainData = TrainData.New(msg.obj)
  self:RefreshView()
end

function TruckRecordDetail:RefreshView()
  self:AddUpdateTimer()
  self:OnUpdateSec()
  self.quality:LoadSprite(self.trainData:GetQualityPath())
  self.icon:LoadSpriteAsyncWithCallback(self.trainData:GetIcon(), function()
    if self.icon then
      self.icon:SetNativeSize()
    end
  end)
  local name = UIUtil.FormatServerAllianceName(self.trainData.serverId, self.trainData.abbr, self.trainData.name)
  self.ownerName:SetText(name)
  self.ownerPlayerHead:SetHead(self.trainData.ownerId, self.trainData.pic, self.trainData.picVer)
  self.ownerLevel:SetLocalText(300665, self.trainData.ownerLv)
  self.ownerPower:SetText(string.GetFormattedSeparatorNum(self.trainData.marchInfo.power))
  self:RefreshHero()
  self:RefreshReward()
  self:RefreshRobList()
end

function TruckRecordDetail:RefreshHero()
  local heroInfo = self.trainData.heroInfo
  for i = 1, 5 do
    if heroInfo[i] then
      self.heroItems[i]:InitWithConfigId(heroInfo[i].id, nil, heroInfo[i].level, heroInfo[i].rankLv, heroInfo[i].weaponLevel, heroInfo[i].awakenLv, heroInfo[i].heroSkinId)
    else
      self.heroItems[i]:InitWithConfigId(nil)
    end
  end
end

function TruckRecordDetail:ClearReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardReqs = {}
end

function TruckRecordDetail:RefreshReward()
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

function TruckRecordDetail:AddOneReward(i, data, isLost)
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
    if self.trainData then
      local isTruck = self.trainData.type == TrainType.Truck
      if isTruck then
        local curMultiVal = self.trainData.multiple
        if curMultiVal and 1 < curMultiVal then
          item:ShowMultiMark(curMultiVal)
        end
      end
    end
  end)
end

function TruckRecordDetail:RefreshRobList()
  self.robContent:RemoveComponents(RobItem)
  self.robItem.gameObject:GameObjectRecycleAll()
  local trainData = self.trainData
  local itemCount = 0
  if trainData.plunderRecord and 0 < #trainData.plunderRecord then
    self.tip2:SetLocalText("457571")
    for i = 1, #trainData.plunderRecord do
      itemCount = itemCount + 1
      local item = self.robItem:GameObjectSpawn(self.robContent.transform)
      item.name = "RobItem" .. itemCount
      local obj = self.robContent:AddComponent(RobItem, item.name)
      obj:SetData(trainData.plunderRecord[i], trainData)
    end
  else
    self.tip2:SetLocalText("457584")
  end
end

function TruckRecordDetail:OnJumpClick()
  if not LuaEntry.DataConfig:CheckSwitch("train_cross_server") and CrossServerUtil:NeedIntercept(500020, nil, true) then
    return
  end
  RailwayUtil.JumpToTrainByTrainData(self.trainData)
end

function TruckRecordDetail:AddUpdateTimer()
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

function TruckRecordDetail:RemoveUpdateTimer()
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function TruckRecordDetail:OnUpdateSec()
  if self.trainData then
    local now = UITimeManager:GetInstance():GetServerTime()
    local worldPos = self.trainData:CalculateTransform(now)
    local worldTilePos = SceneUtils.WorldToTile(worldPos)
    local locationTxt = string.format("X:%s,Y:%s", worldTilePos.x, worldTilePos.y)
    self.coordinateText:SetText(locationTxt)
  end
end

return TruckRecordDetail
