local BuildBloodManager = BaseClass("BuildBloodManager", Singleton)
local BuildBloodTip = require("Scene.BuildBloodTip.BuildBloodTip")
local BuildBloodTipNew = require("Scene.BuildBloodTip.BuildBloodTipNew")
local AllianceCitySoldierTips = require("Scene.BuildBloodTip.AllianceCitySoldierTips")
local ResourceManager = CS.GameEntry.Resource

local function __init(self)
  self.allBloodSlider = {}
  self.allianceCitySoldierSlider = {}
  self.tempInstance = {}
  self:AddListener()
end

local function __delete(self)
  self:ClearAllEffects()
  self.allianceCitySoldierSlider = nil
  self.tempInstance = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function ShowCityBlood(self, message)
  local theWorld = CS.SceneManager.World
  if theWorld == nil then
    return
  end
  if message and message.mainBuildUuid ~= nil then
    local bUuid = message.mainBuildUuid
    local info = theWorld:GetPointInfoByUuid(bUuid)
    if info ~= nil then
      cast(info, typeof(CS.BuildPointInfo))
      if info ~= nil then
        local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(info.itemId, info.level)
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(info.itemId)
        if buildTemplate ~= nil and buildLevelTemplate ~= nil then
          local serverId = info.serverId
          local pointId = info.mainIndex
          local MAX_CITY_DEFENCE = 10000
          local startBlood = message.oldDurability
          local targetBlood = message.nowDurability
          local maxBlood = message.maxDurability or MAX_CITY_DEFENCE
          local colorType = 1
          if message.curShield ~= message.oldShield then
            startBlood = message.oldShield
            targetBlood = message.curShield
            maxBlood = message.maxShield or MAX_CITY_DEFENCE
            colorType = 2
          end
          self:ShowOneBloodEffect(serverId, bUuid, pointId, startBlood, targetBlood, maxBlood, buildTemplate.tileX, buildTemplate.tileY, info.itemId, true, colorType)
          if message.destroyType ~= nil and startBlood and targetBlood and targetBlood ~= 0 then
            if message.destroyType == DestroyType.MissileForThrone then
              self:ShowBuildBloodTip(serverId, pointId, startBlood, targetBlood)
            elseif message.destroyType == DestroyType.AllianceBuildShieldSkill then
              do
                local effectPath = "Assets/Main/SeasonRes/Shared/Prefabs/Effect/VX/Eff_guanjia_HIt.prefab"
                theWorld:CreateBattleVFX(effectPath, 3, function(go)
                  local _world = CS.SceneManager.World
                  if _world ~= nil and go ~= nil and pointId then
                    go.transform.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, serverId)
                  end
                end)
              end
            end
          end
        end
      end
    end
  end
end

function BuildBloodManager:ShowBuildBloodTip(serverId, pointId, startBlood, targetBlood)
  if CS.SceneManager.World == nil or startBlood == nil or targetBlood == nil or startBlood <= targetBlood then
    return
  end
  local diff = startBlood - targetBlood
  if diff <= 0 then
    return
  end
  local seasonType = SeasonUtil.GetSeasonType()
  local effectPath = "Assets/Main/SeasonRes/S3/Prefabs/AllianceBuilding/allianceBuilding_S3_zhanshenfeidan_eff.prefab"
  local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, serverId)
  if seasonType == SeasonMapType.Darkness then
    effectPath = "Assets/Main/SeasonRes/S4/Prefabs/AllianceBuilding/allianceBuilding_s4_zhanshenfeidan_eff.prefab"
  end
  CS.SceneManager.World:CreateBattleVFX(effectPath, 1.5, function(go)
    local theWorld = CS.SceneManager.World
    if IsNotNull(theWorld) and IsNotNull(go) then
      local txt_army_count = go.transform:GetComponent(typeof(CS.SuperTextMesh))
      if txt_army_count ~= nil then
        go:SetActive(true)
        go.transform.position = worldPos
        txt_army_count.text = "- " .. diff
        local sequence = DOTween.Sequence()
        sequence:Append(go.transform:DOMove(worldPos + Vector3.New(0, 0, 3), 0.5))
        sequence:Join(CS.DG.Tweening.DOTween.To(function()
          return 1
        end, function(alpha)
          txt_army_count:SetColorAlpha(alpha)
        end, 0, 1.0):SetEase(CS.DG.Tweening.Ease.InExpo))
      else
        go:SetActive(false)
      end
    end
  end)
end

local function ShowBuildBlood(self, message)
  if message.uuid ~= nil then
    local bUuid = message.uuid
    local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
    if info ~= nil then
      cast(info, typeof(CS.BuildPointInfo))
      if info ~= nil then
        local serverId = info.serverId
        local pointId = info.mainIndex
        local startBlood = message.oldDurability
        local targetBlood = message.nowDurability
        local maxBlood = message.maxDurability
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(info.itemId)
        if buildTemplate ~= nil then
          self:ShowOneBloodEffect(serverId, bUuid, pointId, startBlood, targetBlood, maxBlood, buildTemplate.tileX, buildTemplate.tileY, info.itemId)
        end
      end
    end
  end
end

local function ShowRoadBlood(self, message)
  if message.uuid ~= nil then
    local bUuid = message.uuid
    local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
    if info ~= nil then
      cast(info, typeof(CS.BoardPointInfo))
      if info ~= nil then
        local serverId = info.serverId
        local pointId = info.mainIndex
        local startBlood = message.oldDurability
        local targetBlood = message.nowDurability
        local maxBlood = message.maxDurability
        self:ShowOneBloodEffect(serverId, bUuid, pointId, startBlood, targetBlood, maxBlood, 1, 1)
      end
    end
  end
end

local function ShowOneBloodEffect(self, serverId, bUuid, pointId, startBlood, targetBlood, maxBlood, tileX, tileY, buildId, foreNew, colorType)
  if self.allBloodSlider[bUuid] ~= nil then
    return
  end
  local uuid = bUuid
  if uuid == nil or uuid <= 0 then
    return
  end
  local bNew = foreNew
  local prefab = bNew and UIAssets.SceneBuildBloodTipNew or UIAssets.SceneBuildBloodTip
  local request = ResourceManager:InstantiateAsync(prefab)
  self.allBloodSlider[uuid] = {request = request, lua = nil}
  request:completed("+", function()
    if request.isError or CS.SceneManager.World == nil then
      self:RemoveOneEffect(uuid)
      return
    end
    local _ = self.allBloodSlider[uuid]
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(CS.SceneManager.World.BuildBubbleNode)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local buildBloodTip = bNew and BuildBloodTipNew.New() or BuildBloodTip.New()
    if _ then
      _.lua = buildBloodTip
    end
    buildBloodTip:OnCreate(request)
    local param = {}
    param.serverId = serverId
    param.pointId = pointId
    param.startValue = startBlood
    param.targetValue = targetBlood
    param.maxValue = maxBlood
    param.bUuid = uuid
    param.tileX = tileX
    param.tileY = tileY
    param.buildId = buildId
    param.request = request
    param.colorType = colorType
    buildBloodTip:StartShowBlood(param)
  end)
end

function BuildBloodManager:ClearAllEffects()
  if not self.allBloodSlider then
    return
  end
  for _, eff in pairs(self.allBloodSlider) do
    if eff.request then
      eff.request:Destroy()
    end
    if eff.lua then
      eff.lua:Delete()
    end
  end
  self.allBloodSlider = {}
end

local function RemoveOneEffect(self, bUuid)
  local eff = self.allBloodSlider and self.allBloodSlider[bUuid]
  if not eff then
    return
  end
  if eff.request then
    eff.request:Destroy()
  end
  if eff.lua then
    eff.lua:Delete()
  end
  self.allBloodSlider[bUuid] = nil
end

local function ShowAllianceBloodEffect(self, message)
  if message.cityUuid ~= nil then
    local bUuid = message.cityUuid
    local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
    if info ~= nil and info ~= nil then
      local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
      if allianceCityPointInfo ~= nil then
        local serverId = info.serverId
        local pointId = info.mainIndex
        local startBlood = message.oldDurability
        local targetBlood = message.nowDurability
        if targetBlood ~= startBlood then
          local cityId = allianceCityPointInfo.cityId
          local cityTemplate = LocalController:instance():getLine(TableName.WorldCity, cityId)
          if cityTemplate ~= nil then
            local maxBlood = cityTemplate:getValue("wall")
            self:ShowOneBloodEffect(serverId, bUuid, pointId, startBlood, targetBlood, maxBlood, cityTemplate.size, cityTemplate.size)
          end
        end
      end
    end
  end
end

local function ShowAllianceCitySoldierBloodEffect(data)
  if data ~= nil then
    local dataStr = string.split(data, ";")
    if 2 < #dataStr then
      local bUuid = tonumber(dataStr[1])
      local curBlood = tonumber(dataStr[2])
      local maxBlood = tonumber(dataStr[3])
      BuildBloodManager:GetInstance():ShowCitySoldierBlood(bUuid, curBlood, maxBlood)
    end
  end
end

local function HideAllianceCitySoliderBloodEffect(data)
  if data ~= nil then
    BuildBloodManager:GetInstance():RemoveCitySoldierEffect(tonumber(data))
  end
end

local function ShowCitySoldierBlood(self, bUuid, curBlood, maxBlood)
  if self.allianceCitySoldierSlider[bUuid] == nil and self.tempInstance[bUuid] == nil then
    local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
    if info ~= nil and info ~= nil then
      local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
      if allianceCityPointInfo ~= nil then
        local pointId = info.mainIndex
        local cityId = allianceCityPointInfo.cityId
        local cityTemplate = LocalController:instance():getLine(TableName.WorldCity, cityId)
        if cityTemplate ~= nil then
          do
            local maxSoldierNum = cityTemplate:getValue("monster_num")
            local tileX = cityTemplate.size
            local tileY = cityTemplate.size
            local request = ResourceManager:InstantiateAsync(UIAssets.SceneBuildBloodTip)
            self.tempInstance[bUuid] = request
            request:completed("+", function()
              self.tempInstance[bUuid] = nil
              if request.isError then
                return
              end
              request.gameObject:SetActive(true)
              request.gameObject.transform:SetParent(CS.SceneManager.World.BuildBubbleNode)
              request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
              local buildBloodTip = AllianceCitySoldierTips.New()
              buildBloodTip:OnCreate(request)
              local param = {}
              param.pointId = pointId
              param.startValue = curBlood
              param.targetNum = maxSoldierNum
              param.maxValue = maxBlood
              param.bUuid = bUuid
              param.tileX = tileX
              param.tileY = tileY
              param.request = request
              buildBloodTip:StartShowBlood(param)
              self.allianceCitySoldierSlider[bUuid] = buildBloodTip
            end)
          end
        end
      end
    end
  elseif self.allianceCitySoldierSlider[bUuid] ~= nil then
    self.allianceCitySoldierSlider[bUuid]:RefreshData(curBlood, maxBlood)
  end
end

local function RemoveCitySoldierEffect(self, bUuid)
  if self.allianceCitySoldierSlider[bUuid] ~= nil then
    local request = self.allianceCitySoldierSlider[bUuid].request
    self.allianceCitySoldierSlider[bUuid]:OnDestroy()
    request:Destroy()
  end
  self.allianceCitySoldierSlider[bUuid] = nil
end

BuildBloodManager.__init = __init
BuildBloodManager.__delete = __delete
BuildBloodManager.RemoveOneEffect = RemoveOneEffect
BuildBloodManager.ShowOneBloodEffect = ShowOneBloodEffect
BuildBloodManager.ShowCityBlood = ShowCityBlood
BuildBloodManager.ShowBuildBlood = ShowBuildBlood
BuildBloodManager.ShowRoadBlood = ShowRoadBlood
BuildBloodManager.ShowAllianceBloodEffect = ShowAllianceBloodEffect
BuildBloodManager.ShowCitySoldierBlood = ShowCitySoldierBlood
BuildBloodManager.RemoveCitySoldierEffect = RemoveCitySoldierEffect
BuildBloodManager.ShowAllianceCitySoldierBloodEffect = ShowAllianceCitySoldierBloodEffect
BuildBloodManager.HideAllianceCitySoliderBloodEffect = HideAllianceCitySoliderBloodEffect
BuildBloodManager.AddListener = AddListener
BuildBloodManager.RemoveListener = RemoveListener
return BuildBloodManager
