local ZombieBusTrainAppearanceNormal = BaseClass("ZombieBusTrainAppearanceNormal")
local BusAppearance = require("Scene.ZombieBusTrain.ZombieBusTrainAppearanceBus")

function ZombieBusTrainAppearanceNormal:__init(zombieBusTrainEntity, transform)
  self.transform = transform
  self.zombieBusTrainEntity = zombieBusTrainEntity
  self.rootNode = self.transform:Find("Model/Root").gameObject
  self.iconSpriteRender = self.transform:Find("Icon/Sprite"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.busItems = {}
  self:RefreshView()
end

function ZombieBusTrainAppearanceNormal:__delete()
  for i, v in ipairs(self.busItems) do
    v:Delete()
  end
  self.rootNode = nil
  self.zombieBusTrainEntity = nil
  self.transform = nil
  self.iconSpriteRender = nil
end

function ZombieBusTrainAppearanceNormal:RefreshView()
  if not self.zombieBusTrainEntity then
    return
  end
  local busList = self.zombieBusTrainEntity.busList
  if busList == nil then
    return
  end
  local busCount = #busList
  if 0 < busCount then
    for i = 1, busCount do
      local busData = busList[i]
      if busData then
        self:RefreshOneBus(busData, i)
      end
    end
  end
  self:RefreshIcon()
end

function ZombieBusTrainAppearanceNormal:RefreshIcon()
  if self.zombieBusTrainEntity and self.zombieBusTrainEntity.marchInfo then
    self.iconSpriteRender.gameObject:SetActive(true)
    local detectInfo = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.zombieBusTrainEntity.marchInfo.eventUuid)
    if detectInfo and detectInfo.template then
      local quality = detectInfo.template.quality
      local iconPath = self:GetIconSpritePath(quality)
      self.iconSpriteRender:LoadSprite(iconPath)
    end
  else
    self.iconSpriteRender.gameObject:SetActive(false)
  end
end

function ZombieBusTrainAppearanceNormal:GetIconSpritePath(quality)
  if quality <= 3 then
    return "Assets/Main/Sprites/LodIcon/zxl_daditu_bashi_01.png"
  elseif quality <= 4 then
    return "Assets/Main/Sprites/LodIcon/zxl_daditu_bashi__02.png"
  elseif quality <= 7 then
    return "Assets/Main/Sprites/LodIcon/zxl_daditu_bashi__03.png"
  else
    return "Assets/Main/Sprites/LodIcon/zxl_daditu_bashi_01.png"
  end
end

function ZombieBusTrainAppearanceNormal:DeleteOneBus(index)
  if self.busItems[index] == nil then
    return
  end
  self.busItems[index]:Delete()
  self.busItems[index] = nil
end

function ZombieBusTrainAppearanceNormal:RefreshOneBus(busData, index)
  local curBusItem = self.busItems[index]
  if curBusItem ~= nil and curBusItem.busCfgId ~= busData.busId then
    self:DeleteOneBus(index)
  end
  local parent = self.transform:Find("Model/Root/Node" .. index) or self.transform
  self.busItems[index] = BusAppearance.New(busData, parent)
end

function ZombieBusTrainAppearanceNormal:PlayAnim(animName)
  for i, v in ipairs(self.busItems) do
    v:PlayAnim(animName)
  end
end

function ZombieBusTrainAppearanceNormal:PlayHeadStyleAnim()
  for i, v in ipairs(self.busItems) do
    if i == 1 then
      v:PlayAnim("style")
    end
  end
end

function ZombieBusTrainAppearanceNormal:DoDelayDead()
  local maxTime = 0
  local deltaDeadTime = 0.6
  local busLength = #self.busItems
  for i = 1, busLength do
    local busItem = self.busItems[i]
    local time = busItem:DoDelayDead(deltaDeadTime)
    maxTime = math.max(maxTime, time)
    deltaDeadTime = deltaDeadTime + 0.2
  end
  return maxTime
end

return ZombieBusTrainAppearanceNormal
