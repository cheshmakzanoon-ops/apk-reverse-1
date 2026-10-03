local FactoryGatherResItem = BaseClass("FactoryGatherResItem", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local img_path = "Image"
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.img = self:AddComponent(UIImage, img_path)
  self.animator = self:AddComponent(UIAnimator, this_path)
  self.event_trigger = self:AddComponent(UIEventTrigger, this_path)
  self.event_trigger:OnPointerDown(function(eventData)
    self:OnPointerEnter(eventData)
  end)
  self.event_trigger:OnPointerUp(function(eventData)
    self:OnPointerExit(eventData)
  end)
  self.isGather = false
  self.isPointIn = false
end

local function OnDestroy(self)
  self.event_trigger = nil
  self.img = nil
  base.OnDestroy(self)
end

local function OnPointerEnter(self, eventData)
  self.isPointIn = true
  if self.data ~= nil and self.isGather == false then
    if self.data.needCheckStorageNum > 0 and DataCenter.ResourceItemDataManager:CheckIsStorageFull(self.data.needCheckStorageNum) then
      if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ResourceItemFull, tostring(BuildingTypes.FUN_BUILD_COLD_STORAGE)) then
        DataCenter.GuideManager:SetGuideEndCallBack(function()
          GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
        end)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityFull)
      end
    else
      self.view:OnFingerIn(self.prefabName, self.order)
      local products = self.data.productList
      if CS.SceneManager.IsInPVE() then
        local battleLevel = DataCenter.BattleLevel
        local srcPos = self.transform.position
        table.walk(products, function(_, v)
          local rewardType = DataCenter.FactoryDataManager:FactoryProductTypeToRewardType(v.type, v.itemId)
          local targetPos = battleLevel:GetRewardFlyPos(rewardType)
          local pic = DataCenter.FactoryDataManager:GetProductShowIcon(v)
          local tmp = DataCenter.RewardManager:GetRewardNumsInPveScene(v.num)
          UIUtil.DoJumpFly(pic, tmp, srcPos, targetPos)
        end)
      else
        table.walk(products, function(_, v)
          local rewardType = DataCenter.FactoryDataManager:FactoryProductTypeToRewardType(v.type, v.itemId)
          local pic = DataCenter.FactoryDataManager:GetProductShowIcon(v)
          local str = tostring(self.order) .. ";" .. tostring(v.itemId)
          UIUtil.DoFly(tonumber(rewardType), v.num, pic, self.transform.position, Vector3.New(0, 0, 0), nil, nil, nil, true)
          EventManager:GetInstance():Broadcast(EventId.ShowCapacity, str)
        end)
      end
      self.img.gameObject:SetActive(false)
      DataCenter.PlayerLevelManager:FlyExp(ExpSource.Factory, self.transform.position, self.data.exp)
    end
    self.isGather = true
  end
end

local function OnPointerExit(self, eventData)
  self.isPointIn = false
  self.isGather = false
  self.view:OnGatherItems()
end

local function OnEnable(self)
  base.OnEnable(self)
  self.animator:Play("CellChangeDefault", 0, 0)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data)
  self.data = data
  if self.data ~= nil then
    self.img:LoadSprite(self.data.icon)
    self.img.gameObject:SetActive(true)
  end
end

local function SetOrder(self, num)
  Logger.Log("set Num")
  self.order = num
end

local function GetIsPointIn(self)
  return self.isPointIn
end

local function SetPrefabName(self, name)
  Logger.Log("set Name")
  self.prefabName = name
end

local function DoEnterAnim(self)
  self.animator:Play("CellChangeForFactory", 0, 0)
end

FactoryGatherResItem.OnDestroy = OnDestroy
FactoryGatherResItem.OnCreate = OnCreate
FactoryGatherResItem.OnEnable = OnEnable
FactoryGatherResItem.OnDisable = OnDisable
FactoryGatherResItem.OnPointerEnter = OnPointerEnter
FactoryGatherResItem.OnPointerExit = OnPointerExit
FactoryGatherResItem.RefreshData = RefreshData
FactoryGatherResItem.SetPrefabName = SetPrefabName
FactoryGatherResItem.SetOrder = SetOrder
FactoryGatherResItem.GetIsPointIn = GetIsPointIn
FactoryGatherResItem.DoEnterAnim = DoEnterAnim
return FactoryGatherResItem
