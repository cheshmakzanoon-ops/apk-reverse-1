local FishingStateTip = BaseClass("FishingStateTip")
local ResourceManager = CS.GameEntry.Resource

function FishingStateTip:__init(transform)
  self.parentTabs = transform
  self.lodCache = 1
  self:Instantiate()
end

function FishingStateTip:Init(cityId, serverId)
  self.cityId = cityId
  self.serverId = serverId
end

function FishingStateTip:__delete()
  if self.bubbleTrigger then
    self.bubbleTrigger.onPointerClick = nil
    self.bubbleTrigger = nil
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  self.gameObject = nil
  self.parentTabs = nil
  self.lodCache = 1
end

function FishingStateTip:SetLod(lod)
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    self.gameObject:SetActive(self.lodCache ~= 0 and self.lodCache < 4)
  end
end

function FishingStateTip:CheckLod(lod)
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    self.gameObject:SetActive(self.lodCache ~= 0 and self.lodCache < 4)
  end
end

function FishingStateTip:Instantiate()
  local request = ResourceManager:InstantiateAsync("Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/FishingStateTip.prefab")
  request:completed("+", function()
    local theWorld = CS.SceneManager.World
    if request.isError or theWorld == nil or IsNull(self.parentTabs) then
      return
    end
    self.gameObject = request.gameObject
    local transform = self.gameObject.transform
    transform:SetParent(self.parentTabs)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    transform:Set_localPosition(0, 0, 0)
    transform:Set_localRotation(0, 0, 0, 1)
    transform:Find("Go/Bg/Icon"):GetComponent(typeof(CS.SpriteMeshRenderer)):LoadSprite(string.format(LoadPath.UIBuildBtns, WorldPointBtnTypeImage[WorldPointBtnType.Fishing]))
    self.bubbleTrigger = transform:Find("Go/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
    if self.bubbleTrigger then
      self.bubbleTrigger.previewType = WorldPreviewType.HighThanMultiObjects
      
      function self.bubbleTrigger.onPointerClick()
        local now = UITimeManager:GetInstance():GetServerTime()
        if self.clickTime and now - self.clickTime < 1000 then
          UIUtil.ShowTipsId(120289)
          return
        end
        DataCenter.FishingDataManager:TryEnterFishPond(self.serverId, self.cityId)
        self.clickTime = now
      end
    end
    self:SetLod(theWorld:GetLodLevel())
  end)
  self.request = request
end

return FishingStateTip
