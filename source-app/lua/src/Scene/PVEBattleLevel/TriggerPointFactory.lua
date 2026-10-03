local Resource = CS.GameEntry.Resource
local CitySpaceManTrigger = typeof(CS.CitySpaceManTrigger)
local Const = require("Scene.PVEBattleLevel.Const")
local SimpleAnimationType = typeof(CS.SimpleAnimation)
local TypeOfParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local SuperTextMeshType = typeof(CS.SuperTextMesh)
local SpriteRendererType = typeof(CS.UnityEngine.SpriteRenderer)
local trigger_path = "Go/Trigger"
local icon_path = "Go/Bg/Icon"
local icon_go_path = "Go"
local RewardUtil = require("Util.RewardUtil")
local TriggerPointFactory = BaseClass("TriggerPointFactory")
local AnimName = {
  Enter = "EnterBubble",
  Hide = "HideBubble",
  Normal = "NormalBubble",
  ResourceItem = "goodsBubble",
  Default = "Default"
}

function TriggerPointFactory:Create(triggerPoint, gameObject)
  self.triggerPoint = triggerPoint
  self.gameObject = gameObject
  self:RefreshFactoryState()
  self:GetDataWhenInit()
end

function TriggerPointFactory:GetDataWhenInit()
  local battleLevel = DataCenter.BattleLevel
  local data = battleLevel:GetPveTriggerBuildingInfo(self.triggerPoint.triggerId)
  if data == nil then
    local param = {}
    param.trigger = self.triggerPoint.triggerId
    param.level = battleLevel.levelId
    SFSNetwork.SendMessage(MsgDefines.UpgradeTriggerBuilding, param)
  else
    local factoryData = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(data.uuid)
    if factoryData == nil then
      SFSNetwork.SendMessage(MsgDefines.SynFoodFactory, data.uuid)
    end
  end
end

function TriggerPointFactory:__delete()
end

function TriggerPointFactory:Destroy()
  if self.freeEffect ~= nil then
    self.freeEffect:Destroy()
    self.freeEffect = nil
  end
  if self.itemBubble ~= nil then
    self.itemBubble:Destroy()
    self.itemBubble = nil
  end
end

function TriggerPointFactory:RefreshFactoryState()
  local showItemBubble = self:NeedShowItemBubble()
  self:RefreshItemBubbleState(showItemBubble)
  if showItemBubble then
    self:RefreshFreeState(false)
  else
    self:RefreshFreeState(self:NeedShowFree())
  end
end

function TriggerPointFactory:RefreshFreeState(showFlag)
  if showFlag and self.freeEffect == nil then
    self.freeEffect = Resource:InstantiateAsync("Assets/_Art/Effect/prefab/scene/Common/VFX_idle_zzz.prefab")
    self.freeEffect:completed("+", function()
      self.freeEffect.gameObject.transform.parent = self.gameObject.transform
      self.freeEffect.gameObject.transform.localPosition = ResetPosition
      self.freeEffect.gameObject:SetActive(showFlag)
    end)
  end
  if self.freeEffect ~= nil and self.freeEffect.gameObject ~= nil then
    self.freeEffect.gameObject:SetActive(showFlag)
  end
end

function TriggerPointFactory:RefreshItemBubbleState(showFlag)
  if showFlag and self.itemBubble == nil then
    local prefabPath = string.format(UIAssets.PveTriggerPointBubble, 3000)
    self.itemBubble = Resource:InstantiateAsync(prefabPath)
    self.itemBubble:completed("+", function()
      self.itemBubble.gameObject.transform.parent = self.gameObject.transform
      self.itemBubble.gameObject.transform.localPosition = ResetPosition
      self.itemBubble.gameObject:SetActive(showFlag)
      self.icon_sprite = self.itemBubble.gameObject.transform:Find(icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
      self.bg = self.itemBubble.gameObject.transform:Find(trigger_path):GetComponent(typeof(CS.UIEventTrigger))
      self.icon_go = self.itemBubble.gameObject.transform:Find(icon_go_path):GetComponent(typeof(CS.SimpleAnimation))
      
      function self.bg.onPointerClick()
        self:OnClickBubble()
      end
      
      if showFlag then
        self:RefreshItemBubbleIcon()
      end
    end)
  end
  if self.itemBubble ~= nil and self.itemBubble.gameObject ~= nil then
    self.itemBubble.gameObject:SetActive(showFlag)
    if showFlag then
      self:RefreshItemBubbleIcon()
    end
  end
end

function TriggerPointFactory:RefreshItemBubbleIcon()
  if self.icon_sprite == nil then
    return
  end
  local data = DataCenter.BattleLevel:GetPveTriggerBuildingInfo(self.triggerPoint.triggerId)
  if data == nil then
    return
  end
  local factoryData = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(data.uuid)
  if factoryData == nil then
    return
  end
  local itemId, productId = factoryData:CheckCanGetProduct()
  if -1 < itemId and not string.IsNullOrEmpty(productId) then
    local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
    if resourceItemData ~= nil then
      local pic = string.format(LoadPath.ItemPath, resourceItemData.pic)
      self.icon_sprite:LoadSprite(pic)
      self.icon_go:Play(AnimName.Enter)
      self.icon_go:PlayQueued(AnimName.ResourceItem)
    end
  end
end

function TriggerPointFactory:NeedShowFree()
  local data = DataCenter.BattleLevel:GetPveTriggerBuildingInfo(self.triggerPoint.triggerId)
  if data == nil then
    return false
  end
  local state = DataCenter.FactoryDataManager:GetFactoryStateByBuildUuid(data.uuid)
  return state ~= FactoryWorkState.Work
end

function TriggerPointFactory:NeedShowItemBubble()
  local data = DataCenter.BattleLevel:GetPveTriggerBuildingInfo(self.triggerPoint.triggerId)
  if data == nil then
    return
  end
  local factoryData = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(data.uuid)
  if factoryData == nil then
    return
  end
  local itemId, productId = factoryData:CheckCanGetProduct()
  if -1 < itemId and not string.IsNullOrEmpty(productId) then
    return true
  end
  return false
end

function TriggerPointFactory:OnClickBubble()
  local data = DataCenter.BattleLevel:GetPveTriggerBuildingInfo(self.triggerPoint.triggerId)
  if data == nil then
    return
  end
  local factoryData = DataCenter.FactoryDataManager:GetFactoryDataByBUuid(data.uuid)
  if factoryData == nil then
    return
  end
  local battleLevel = DataCenter.BattleLevel
  battleLevel:DisableJoystick()
  battleLevel:EnableJoystick()
  local itemId, productId = factoryData:CheckCanGetProduct()
  if -1 < itemId and not string.IsNullOrEmpty(productId) then
    local factoryTemplate = DataCenter.FactoryDataManager:GetFactoryTemplate(productId)
    local resourceItemNum = factoryTemplate:GetProductResourceItemNum()
    if 0 < resourceItemNum and DataCenter.ResourceItemDataManager:CheckIsStorageFull(resourceItemNum) then
      if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ResourceItemFull, tostring(BuildingTypes.FUN_BUILD_COLD_STORAGE)) then
        DataCenter.GuideManager:SetGuideEndCallBack(function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityFull)
        end)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityFull)
      end
    else
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Product3, false)
      SFSNetwork.SendMessage(MsgDefines.GatherProduct, data.uuid, {0})
      local srcPos = battleLevel:WorldToScreenPoint(SceneUtils.TileToWorld(self.triggerPoint:GetTilePos()))
      local products = factoryTemplate.productList
      table.walk(products, function(_, v)
        local rewardType = DataCenter.FactoryDataManager:FactoryProductTypeToRewardType(v.type, v.itemId)
        local targetPos = battleLevel:GetRewardFlyPos(rewardType)
        local pic = DataCenter.FactoryDataManager:GetProductShowIcon(v)
        local tmp = DataCenter.RewardManager:GetRewardNumsInPveScene(v.num)
        UIUtil.DoJumpFly(pic, tmp, srcPos, targetPos)
      end)
      if 0 < factoryTemplate.exp then
        DataCenter.PlayerLevelManager:FlyExp(ExpSource.Factory, srcPos, factoryTemplate.exp)
      end
    end
  end
end

return TriggerPointFactory
