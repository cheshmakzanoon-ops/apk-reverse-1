local BuildZoneManager = BaseClass("BuildZoneManager")
local ResourceManager = CS.GameEntry.Resource
local BuildZoneMainEffect = require("Scene.BuildZoneEffect.BuildZoneMainEffect")
local BuildZoneSubEffect = require("Scene.BuildZoneEffect.BuildZoneSubEffect")
local LodHideLevel = 1

local function __init(self)
  self.zone = nil
  self.movePer = nil
  self.zoneType = nil
  self.unlock = nil
  self:AddListener()
end

local function __delete(self)
  self.movePer = nil
  self.zoneType = nil
  self.unlock = nil
  self:RemoveAll()
  self:RemoveListener()
end

local function Startup()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.OpenUI, self.OnOpenUISignal)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.OpenUI, self.OnOpenUISignal)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
end

local function RemoveAll(self)
  if self.zone ~= nil then
    for k, v in pairs(self.zone) do
      if v.model ~= nil then
        v.model:OnDestroy()
      end
      if v.request ~= nil then
        v.request:Destroy()
      end
    end
    self.zone = nil
  end
  if self.movePer ~= nil then
    self.movePer = nil
  end
end

local function ShowZoneEffect(self, uuid, buildId, pointId)
  do return end
  if buildId == BuildingTypes.APS_BUILD_FARM_FIELD then
    return
  end
  if self.movePer ~= nil then
    if self.movePer.buildId == buildId then
      return
    else
      self:RemoveAll()
    end
  end
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if template ~= nil and template.zoneType ~= BuildZoneType.No and template.zoneType ~= BuildZoneType.Tower then
    local zoneType = template.zoneType
    self.zoneType = zoneType
    if self:IsZoneTypeCanShow(zoneType) then
      self.zone = {}
      if uuid == FakeBuildUuid then
        local per = {}
        self.zone[FakeBuildUuid] = per
        per.uuid = FakeBuildUuid
        per.buildId = buildId
        per.pointId = pointId
        per.points = BuildingUtils.GetBuildTileIndex(per.buildId, per.pointId)
        per.mainType = template.zoneMainType
        per.tileX = template.tileX
        per.tileY = template.tileY
        per.radius = template.zone_radius
        if per.mainType == BuildZoneMainType.Main then
          per.isShow = true
          per.request = ResourceManager:InstantiateAsync(string.format(UIAssets.BuildCoverageMainEffect, zoneType))
          per.request:completed("+", function()
            if per.request.isError then
              return
            end
            per.request.gameObject:SetActive(true)
            local temp = CS.SceneManager.World.SelectBuild
            if temp == nil then
              temp = CS.SceneManager.World.BuildBubbleNode
            end
            per.request.gameObject.transform:SetParent(temp.transform)
            per.request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local modelVec = BuildingUtils.GetBuildModelCenterVec(per.pointId, per.tileX, per.tileY)
            per.request.gameObject.transform:Set_position(modelVec.x, modelVec.y, modelVec.z)
            local effect = BuildZoneMainEffect.New()
            effect:OnCreate(per.request)
            per.model = effect
          end)
        end
        self.movePer = per
      end
      local zone = DataCenter.BuildTemplateManager:GetZoneByZoneType(zoneType)
      if zone ~= nil and zone[BuildZoneMainType.Main] ~= nil then
        for k, v in ipairs(zone[BuildZoneMainType.Main]) do
          local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v.id)
          if list ~= nil then
            for k1, v1 in ipairs(list) do
              local per = {}
              self.zone[v1.uuid] = per
              per.uuid = v1.uuid
              per.buildId = v1.itemId
              per.pointId = v1.pointId
              per.points = BuildingUtils.GetBuildTileIndex(per.buildId, per.pointId)
              per.mainType = BuildZoneMainType.Main
              local perTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(per.buildId)
              per.tileX = perTemplate.tileX
              per.tileY = perTemplate.tileY
              per.radius = perTemplate.zone_radius
              per.isShow = true
              per.request = ResourceManager:InstantiateAsync(string.format(UIAssets.BuildCoverageMainEffect, zoneType))
              per.request:completed("+", function()
                if per.request.isError then
                  return
                end
                per.request.gameObject:SetActive(true)
                local temp = CS.SceneManager.World:GetBuildingByPoint(per.pointId)
                if temp == nil then
                  temp = CS.SceneManager.World.BuildBubbleNode
                end
                per.request.gameObject.transform:SetParent(temp.transform)
                per.request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local modelVec = BuildingUtils.GetBuildModelCenterVec(per.pointId, per.tileX, per.tileY)
                per.request.gameObject.transform:Set_position(modelVec.x, modelVec.y, modelVec.z)
                local effect = BuildZoneMainEffect.New()
                effect:OnCreate(per.request)
                per.model = effect
              end)
              if uuid == per.uuid then
                self.movePer = per
              end
            end
          end
        end
        if table.count(self.zone) > 0 and zone[BuildZoneMainType.Sub] then
          for k, v in ipairs(zone[BuildZoneMainType.Sub]) do
            if v.id ~= BuildingTypes.APS_BUILD_FARM_FIELD then
              local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v.id)
              if list ~= nil then
                for k1, v1 in ipairs(list) do
                  local per = {}
                  self.zone[v1.uuid] = per
                  per.uuid = v1.uuid
                  per.buildId = v1.itemId
                  per.pointId = v1.pointId
                  per.points = BuildingUtils.GetBuildTileIndex(per.buildId, per.pointId)
                  per.mainType = BuildZoneMainType.Sub
                  local perTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(per.buildId)
                  per.tileX = perTemplate.tileX
                  per.tileY = perTemplate.tileY
                  per.isShow = self:IsShowSubEffect(per)
                  if per.isShow or per.uuid == uuid then
                    self:LoadSubEffect(per)
                  end
                  if uuid == per.uuid then
                    self.movePer = per
                  end
                end
              end
            end
          end
        end
      end
      if self.movePer ~= nil and self.movePer.uuid == FakeBuildUuid and self.movePer.mainType == BuildZoneMainType.Sub then
        self.movePer.isShow = self:IsShowSubEffect(self.movePer)
        if self.movePer.isShow then
          self:LoadSubEffect(self.movePer)
        end
      end
    end
  end
end

local function ChangePos(self, posIndex)
  if self.movePer ~= nil then
    self.movePer.pointId = posIndex
    self.movePer.points = BuildingUtils.GetBuildTileIndex(self.movePer.buildId, self.movePer.pointId)
    if self.movePer.mainType == BuildZoneMainType.Main then
      if self.zone ~= nil then
        for k, v in pairs(self.zone) do
          if v.mainType == BuildZoneMainType.Sub then
            self:CheckIsShow(v)
          end
        end
      end
    elseif self.movePer.mainType == BuildZoneMainType.Sub then
      self:CheckIsShow(self.movePer)
    end
  end
end

local function IsShowSubEffect(self, per)
  if per ~= nil and self.zone ~= nil then
    for k, v in pairs(self.zone) do
      if v.mainType == BuildZoneMainType.Main then
        for k1, v1 in ipairs(per.points) do
          if BuildingUtils.IsInRangeBySquare(v.pointId, v1, v.radius, v.radius, v.tileX, v.tileY) then
            return true
          end
        end
      end
    end
  end
  return false
end

local function LoadSubEffect(self, per)
  if per ~= nil then
    per.request = ResourceManager:InstantiateAsync(string.format(UIAssets.BuildCoverageSubEffect, self.zoneType, per.tileX))
    per.request:completed("+", function()
      if per.request.isError then
        return
      end
      per.request.gameObject:SetActive(per.isShow)
      local temp
      if per.uuid == FakeBuildUuid then
        temp = CS.SceneManager.World.SelectBuild
      else
        temp = CS.SceneManager.World:GetBuildingByPoint(per.pointId)
      end
      if temp == nil then
        temp = CS.SceneManager.World.BuildBubbleNode
      end
      per.request.gameObject.transform:SetParent(temp.transform)
      per.request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local modelVec = BuildingUtils.GetBuildModelCenterVec(per.pointId, per.tileX, per.tileY)
      per.request.gameObject.transform:Set_position(modelVec.x, modelVec.y, modelVec.z)
      local effect = BuildZoneSubEffect.New()
      effect:OnCreate(per.request)
      per.model = effect
    end)
  end
end

local function CheckIsShow(self, per)
  local isShow = self:IsShowSubEffect(per)
  if per.isShow ~= isShow then
    per.isShow = isShow
    if isShow then
      if per.request == nil then
        self:LoadSubEffect(per)
      elseif per.model ~= nil then
        per.model.gameObject:SetActive(true)
      end
    elseif per.model ~= nil then
      per.model.gameObject:SetActive(false)
    end
  end
end

local function IsZoneTypeCanShow(self, zoneType)
  if self.unlock == nil then
    self.unlock = {}
    local unlock = LuaEntry.DataConfig:TryGetStr("center_building_unlock", "k1")
    if unlock ~= nil and unlock ~= "" then
      local spl = string.split_ss_array(unlock, "|")
      for k, v in ipairs(spl) do
        local spl1 = string.split_ss_array(v, ";")
        if table.count(spl1) > 0 then
          local needList = {}
          self.unlock[tonumber(spl1[1])] = needList
          local perSpl = string.split_ii_array(spl1[2], ",")
          for k3, v3 in ipairs(perSpl) do
            local need = {}
            need.buildId = CommonUtil.GetBuildBaseType(v3)
            need.level = CommonUtil.GetBuildLv(v3)
            table.insert(needList, need)
          end
        end
      end
    end
  end
  if self.unlock ~= nil and self.unlock[zoneType] ~= nil then
    for k, v in ipairs(self.unlock[zoneType]) do
      if not DataCenter.BuildManager:IsExistBuildByTypeLv(v.buildId, v.level) then
        return false
      end
    end
  end
  return true
end

local function OnOpenUISignal(uiName)
  if uiName ~= UIWindowNames.UIWorldTileUI and uiName ~= UIWindowNames.UIPlaceBuild and uiName ~= UIWindowNames.UICommonMessageTip then
    DataCenter.BuildZoneManager:RemoveAll()
  end
end

local function ChangeCameraLodSignal(lod)
  if tonumber(lod) > LodHideLevel then
    DataCenter.BuildZoneManager:RemoveAll()
  end
end

BuildZoneManager.__init = __init
BuildZoneManager.__delete = __delete
BuildZoneManager.Startup = Startup
BuildZoneManager.ShowZoneEffect = ShowZoneEffect
BuildZoneManager.RemoveAll = RemoveAll
BuildZoneManager.IsShowSubEffect = IsShowSubEffect
BuildZoneManager.LoadSubEffect = LoadSubEffect
BuildZoneManager.CheckIsShow = CheckIsShow
BuildZoneManager.ChangePos = ChangePos
BuildZoneManager.IsZoneTypeCanShow = IsZoneTypeCanShow
BuildZoneManager.AddListener = AddListener
BuildZoneManager.RemoveListener = RemoveListener
BuildZoneManager.OnOpenUISignal = OnOpenUISignal
BuildZoneManager.ChangeCameraLodSignal = ChangeCameraLodSignal
return BuildZoneManager
