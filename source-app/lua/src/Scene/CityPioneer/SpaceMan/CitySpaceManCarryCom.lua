local CitySpaceManCarryCom = BaseClass("CitySpaceManCarryCom")
local Const = require("Scene.CityPioneer.Const")

function CitySpaceManCarryCom:__init(spaceman)
  self.m_citySpaceMan = spaceman
  self.m_resStoreId = -1
end

function CitySpaceManCarryCom:CheckSubmitRes()
  local tilePos = self.m_citySpaceMan:GetTilePos()
  local posIndex = SceneUtils.TilePosToIndex(tilePos)
  local pointData = DataCenter.CityTriggerPointDataManager:GetTriggerPointData(posIndex)
  if pointData == nil then
    self:StopSubmit()
    return
  end
  self:BeginSubmit(pointData)
end

function CitySpaceManCarryCom:StopSubmit()
  if self.m_resStoreId ~= nil then
    self:PlayerLeaveTrigger(self.m_resStoreId)
  end
  self:StopSubmitTick()
  self.m_resStoreId = -1
end

function CitySpaceManCarryCom:BeginSubmit(pointData)
  local curStoreId = pointData:GetTemplateId()
  if self.m_resStoreId ~= curStoreId then
    self:StopSubmit()
  end
  self.m_resStoreId = curStoreId
  self:PlayerEnterTrigger(self.m_resStoreId)
  self:SubmitResTick(pointData)
end

function CitySpaceManCarryCom:PlayerEnterTrigger(id)
  local tpMgr = CityTriggerPointManager:GetInstance()
  local triggerObj = tpMgr:GetTriggerObject(id)
  if not triggerObj then
    return
  end
  triggerObj:PlayScaleUp()
end

function CitySpaceManCarryCom:PlayerLeaveTrigger(storeId)
  if storeId < 0 then
    return
  end
  local tpMgr = CityTriggerPointManager:GetInstance()
  local triggerObj = tpMgr:GetTriggerObject(storeId)
  if not triggerObj then
    return
  end
  triggerObj:PlayScaleDown()
end

function CitySpaceManCarryCom:SubmitResTick(pointData)
  if self.collectTimer ~= nil then
    return
  end
  self.collectTimer = TimerManager:GetInstance():GetTimer(0.1, function()
    self:CollectOneRes(pointData)
  end, nil, false, false, false)
  self.collectTimer:Start()
end

function CitySpaceManCarryCom:StopSubmitTick()
  if self.collectTimer ~= nil then
    self.collectTimer:Stop()
    self.collectTimer = nil
  end
end

function CitySpaceManCarryCom:CollectOneRes(pointData)
  if DataCenter.GuideManager:InGuide() then
    return
  end
  local tpMgr = CityTriggerPointManager:GetInstance()
  local submitFlag = false
  if self.m_citySpaceMan:IsFinalState() and (pointData:HasType(Const.UnlockToResType[Const.CommitType.Flag]) or pointData:HasType(Const.UnlockToResType[Const.CommitType.Man])) then
    submitFlag = true
  end
  if CityTriggerPointManager:GetInstance():IsCityCheatOk() or submitFlag then
    self:StopSubmitTick()
    tpMgr:DoTriggerAndSave(pointData:GetTemplateId())
    return
  end
  if self.m_citySpaceMan:GetCarryCnt() > 0 then
    local type = self.m_citySpaceMan:GetTopObjectType()
    if not pointData:HasType(type) then
      local p = SceneUtils.TileToWorld(pointData:GetShowPos())
      local obj = self:PopOneObject(p)
      if not obj then
        return
      end
      obj:FlyOut(self.m_citySpaceMan:GetTransform().position, p, nil, function()
        obj:Destroy()
      end)
      return
    end
    local triggerObj = tpMgr:GetTriggerObject(pointData:GetTemplateId())
    if not triggerObj then
      return
    end
    local modelDic = {}
    local p = self:GetCollectDataPos(type, pointData, modelDic)
    local obj = self:PopOneObject(p, modelDic)
    if not obj then
      return
    end
    obj:FlyOut(self.m_citySpaceMan:GetTransform().position, p, nil, function()
      obj:Destroy()
      if modelDic.shachong ~= nil then
        modelDic.shachong:PlayHit()
        modelDic.shachong = nil
      end
    end)
    local type = obj:GetType()
    for t, need in pairs(pointData:GetAllNeedRes()) do
      local resType = Const.UnlockToResType[t]
      if resType == type then
        local give = pointData:GetGiveRes(t)
        local remain = need - give
        if 0 < remain then
          pointData:GiveRes(t, 1)
          DataCenter.LWSoundManager:PlaySound(table.randomArrayValue(EnumPioneerSubmit), false)
          CommonUtil.VibratorLightImpact()
          triggerObj:RefreshText()
          triggerObj:AniItem(resType)
          if toInt(pointData:GetTag()) == 2 then
            local totalResCnt = pointData:GetTotalCnt()
            local monsterHp = WastelandModelMgr:GetInstance():GetTotalMonsterHP()
            local damage = monsterHp / totalResCnt
            WastelandModelMgr:GetInstance():ShowBullet(damage)
          end
          break
        end
      end
    end
  end
  if pointData:IsFull() then
    self:StopSubmitTick()
    tpMgr:DoTriggerAndSave(pointData:GetTemplateId())
  end
end

function CitySpaceManCarryCom:GetCollectDataPos(type, pointData, modelDic)
  if toInt(pointData:GetTag()) == 1 then
    local spl1 = string.split(pointData:GetTagPara(), ",")
    if 1 < table.count(spl1) then
      local vec = {}
      vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl1[1])
      vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl1[2])
      local pointId = SceneUtils.TilePosToIndex(vec)
      local build = DataCenter.CityPrologueBuildManager:GetBuild(pointId)
      if build and build.inst then
        modelDic.shachong = build.model
        local flyPoint = build.inst.gameObject.transform:Find("NormalModel/A_animal_shachong_gpuskin/RecoverPoint")
        if flyPoint ~= nil then
          return flyPoint.position
        else
          return build.inst.gameObject.transform.position
        end
      end
    end
  end
  local tpMgr = CityTriggerPointManager:GetInstance()
  local triggerObj = tpMgr:GetTriggerObject(pointData:GetTemplateId())
  if not triggerObj then
    return
  end
  local p = triggerObj:GetTypePosition(type)
  return p
end

function CitySpaceManCarryCom:PopOneObject(targetPos, modelDic)
  local _carryObj = self.m_citySpaceMan.carryObj
  if #_carryObj <= 0 then
    return nil
  end
  local obj = _carryObj[#_carryObj]
  _carryObj[#_carryObj] = nil
  return obj
end

return CitySpaceManCarryCom
