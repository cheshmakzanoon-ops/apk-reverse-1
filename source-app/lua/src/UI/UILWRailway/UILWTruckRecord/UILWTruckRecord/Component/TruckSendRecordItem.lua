local TruckSendRecordItem = BaseClass("TruckSendRecordItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UILWTruckRecordRecaptureReward = "Assets/Main/Prefabs/UI/UITruckRewardInsurance/UILWTruckRecordRecaptureReward.prefab"
local UILWTruckRecordRecaptureRewardComponent = require("UI.UILWRailway.UILWTruckRecord.UILWTruckRecord.Component.UILWTruckRecordRecaptureRewardComponent")
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

function TruckSendRecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TruckSendRecordItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TruckSendRecordItem:ComponentDefine()
  self.bg0 = self:AddComponent(UIImage, "bg0")
  self.bg2 = self:AddComponent(UIImage, "bg2")
  self.bg4 = self:AddComponent(UIImage, "bg4")
  self.qualityImage = self:AddComponent(UIImage, "Quality")
  self.time = self:AddComponent(UIText, "Time")
  self.btn = self:AddComponent(UIButton, "bg")
  self.btn:SetOnClick(function()
    if self.trainRecordData then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTruckRecordDetail, {anim = true}, self.trainRecordData)
    end
  end)
  self.rewardContent = self:AddComponent(UIBaseContainer, "ScrollRect/ViewPort/Content")
end

function TruckSendRecordItem:ComponentDestroy()
  self:ClearReward()
end

function TruckSendRecordItem:DataDefine()
end

function TruckSendRecordItem:DataDestroy()
end

function TruckSendRecordItem:OnEnable()
  base.OnEnable(self)
end

function TruckSendRecordItem:OnDisable()
  base.OnDisable(self)
end

function TruckSendRecordItem:OnAddListener()
  base.OnAddListener(self)
end

function TruckSendRecordItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TruckSendRecordItem:update()
end

function TruckSendRecordItem:SetData(trainData)
  self.trainRecordData = trainData
  self.trainData = trainData.trainData
  self.time:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.trainRecordData.recordTime))
  local quality = self.trainData.quality
  self.bg2:LoadSprite(Quality2Bg2[quality])
  self.bg4:LoadSpriteAsyncWithCallback(self.trainData:GetIcon(), function()
    if self.bg4 then
      self.bg4:SetNativeSize()
    end
  end)
  self.bg0:SetColor(Quality2Bg0[quality])
  self.qualityImage:LoadSprite(self.trainData:GetQualityPath())
  self:RefreshReward()
end

function TruckSendRecordItem:ClearReward()
  self.rewardContent:RemoveComponents(UILWTruckRecordRecaptureRewardComponent)
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardReqs = {}
end

function TruckSendRecordItem:RefreshReward()
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

function TruckSendRecordItem:AddOneReward(i, data, isLost)
  self.rewardReqs[i] = self:GameObjectInstantiateAsync(UILWTruckRecordRecaptureReward, function(req)
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
    local item = self.rewardContent:AddComponent(UILWTruckRecordRecaptureRewardComponent, nameStr)
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
    param.isFindBack = data.isFindBack
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

return TruckSendRecordItem
