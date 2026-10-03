local CityGarbageBubbleManager = BaseClass("CityGarbageBubbleManager", Singleton)
local Resource = CS.GameEntry.Resource
local TypeOfSuperTextMesh = typeof(CS.SuperTextMesh)

function CityGarbageBubbleManager:__init()
  function self.updateCityPointHandler(pointId)
    self:OnUpdateCityPoint(pointId)
  end
  
  function self.enterGameHandler()
    self:OnEnterGame()
  end
  
  function self.refreshTextHandler(pointId)
    self:OnRefreshText(pointId)
  end
  
  EventManager:GetInstance():AddListener(EventId.UpdateCityPoint, self.updateCityPointHandler)
  EventManager:GetInstance():AddListener(EventId.LOAD_COMPLETE, self.enterGameHandler)
  EventManager:GetInstance():AddListener(EventId.RefreshCutReward, self.refreshTextHandler)
  self.garbageTexts = {}
end

function CityGarbageBubbleManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.UpdateCityPoint, self.updateCityPointHandler)
  EventManager:GetInstance():RemoveListener(EventId.LOAD_COMPLETE, self.enterGameHandler)
  EventManager:GetInstance():RemoveListener(EventId.RefreshCutReward, self.refreshTextHandler)
end

function CityGarbageBubbleManager:OnUpdateCityPoint(pointId)
end

function CityGarbageBubbleManager:OnEnterGame()
end

function CityGarbageBubbleManager:OnRefreshText(pointId)
end

function CityGarbageBubbleManager:AddGarbageText(pointId)
  local pointData = DataCenter.CityPointDataManager:GetPointDataByPointId(pointId)
  local template = DataCenter.SingleMapJunkTemplateManager:GetTemplate(pointData.itemId)
  local cutReward = pointData.cutReward
  local totalReward = template.rewardNew
  if self.garbageTexts[pointId] ~= nil then
    self.garbageTexts[pointId].inst:Destroy()
  end
  self.garbageTexts[pointId] = {}
  self.garbageTexts[pointId].inst = Resource:InstantiateAsync("Assets/Main/Prefabs/CityScene/CityGarbageText.prefab")
  self.garbageTexts[pointId].inst:completed("+", function(req)
    req.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    req.gameObject.transform.position = SceneUtils.TileIndexToWorld(pointId)
    local stm = req.gameObject.transform:Find("num"):GetComponent(TypeOfSuperTextMesh)
    stm.text = string.format("%d/%d", cutReward, totalReward)
    self.garbageTexts[pointId].stm = stm
  end)
end

function CityGarbageBubbleManager:RemoveGarbageText(pointId)
  if self.garbageTexts[pointId] ~= nil then
    self.garbageTexts[pointId].inst:Destroy()
    self.garbageTexts[pointId] = nil
  end
end

return CityGarbageBubbleManager
