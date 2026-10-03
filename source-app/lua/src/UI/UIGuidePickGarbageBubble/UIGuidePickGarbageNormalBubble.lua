local UIGuidePickGarbageNormalBubble = BaseClass("UIGuidePickGarbageNormalBubble")
local ResourceManager = CS.GameEntry.Resource
local icon_path = "Go/Bg/Icon"
local bg_path = "Go/Bg"

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  if not self.defend then
    self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
    self.bg_sprite = self.transform:Find(bg_path):GetComponent(typeof(CS.SpriteMeshRenderer))
    self.bg = self.transform:Find(bg_path):GetComponent(typeof(CS.UIEventTrigger))
    
    function self.bg.onPointerClick()
      self:OnClick()
    end
    
    self.defend = true
  end
end

local function ComponentDestroy(self)
  self.bg.onPointerClick = nil
  self.icon_sprite = nil
  self.bg_sprite = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.defend = nil
end

local function ReInit(self, icon, bg, index, rewardType, rewardId)
  self.icon_sprite:LoadSprite(icon)
  self.bg_sprite:LoadSprite(bg)
  self.rewardType = rewardType
  self.rewardId = rewardId
  self:UpdatePosition(index)
end

local function UpdatePosition(self, index)
  if self.index ~= index then
    local worldPos = SceneUtils.TileIndexToWorld(index)
    self.transform.position = worldPos
    self.index = index
  end
end

local function OnClick(self)
  local pointData = DataCenter.CityPointDataManager:GetPointDataByPointId(self.index)
  if pointData ~= nil and pointData.type == CityPointType.GarbageReward then
    local soundId = 0
    if self.rewardType == RewardType.WATER then
      soundId = SoundAssetId.Music_Effect_Water
    elseif self.rewardId == tostring(SpeedUpItemId) then
      soundId = SoundAssetId.Music_Effect_Collect_Crystal
    elseif self.rewardType == RewardType.METAL then
      soundId = SoundAssetId.Music_Effect_Collect_Crystal
    elseif self.rewardType == RewardType.RESOURCE_ITEM then
      soundId = SoundAssetId.Music_Effect_Product1
    end
    if 0 < soundId then
      DataCenter.LWSoundManager:PlaySound(soundId, false)
    end
    UIUtil.OnClickCity(self.index, pointData.type)
  end
end

local function GetGuideObject(self)
  return self.icon_sprite.gameObject
end

UIGuidePickGarbageNormalBubble.OnCreate = OnCreate
UIGuidePickGarbageNormalBubble.OnDestroy = OnDestroy
UIGuidePickGarbageNormalBubble.ComponentDefine = ComponentDefine
UIGuidePickGarbageNormalBubble.ComponentDestroy = ComponentDestroy
UIGuidePickGarbageNormalBubble.DataDefine = DataDefine
UIGuidePickGarbageNormalBubble.DataDestroy = DataDestroy
UIGuidePickGarbageNormalBubble.ReInit = ReInit
UIGuidePickGarbageNormalBubble.UpdatePosition = UpdatePosition
UIGuidePickGarbageNormalBubble.OnClick = OnClick
UIGuidePickGarbageNormalBubble.GetGuideObject = GetGuideObject
return UIGuidePickGarbageNormalBubble
