local base = require("DataCenter.LWBattle.Logic.LastStand.LastStandBuilding.LastStandBuildingUnit")
local LastStandGate = BaseClass("LastStandGate", base)
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade

function LastStandGate:Init(logic, config, pos, doorInfo)
  base.Init(self, logic, config, pos)
  self.doorInfo = doorInfo
  self.searchType = BattleSearchType.Member
  self.isSearchPoint = true
  self.lastStandBuildingType = LastStandBuildType.Gate
  local scale = ResetScale.x
  local path = "Assets/Main/Prefabs/LastStand/LastStandGate.prefab"
  self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, path, nil, scale, pos.x, 0.01, pos.z, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Member"))
  if self.viewLoaded then
    self:OnViewLoaded(true)
  end
end

function LastStandGate:ExecuteIntervalLogic()
end

function LastStandGate:OnViewLoaded(force)
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.gameObject = UnitViewFacade.GetGameObject(self.viewHandle)
  self.gameObject.name = "\229\164\167\233\151\168"
  self.transform = UnitViewFacade.GetTransform(self.viewHandle)
  self.modelObj = self.gameObject.transform:Find("Model").gameObject
  self.modelObj:SetActive(self.isBuildingDone)
  self.createInfoObj = self.gameObject.transform:Find("CreateInfo").gameObject
  self.textProgress = self.createInfoObj.transform:Find("textNeedNum"):GetComponent(typeof(CS.TextMeshProEx))
  self.textProgress.text = self.buildNeedCoin - self.curCoin
  self.imageProgress = self.createInfoObj.transform:Find("imageProgress"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.imageProgress.size = Vector2.New(4, 0)
  self.imageBuildingIcon = self.createInfoObj.transform:Find("imageBuilding"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.imageBuildingIcon:LoadSprite(string.format(LoadPath.LastStandSpritesPath, self.buildingConfig.icon))
  self.createInfoObj:SetActive(not self.isBuildingDone)
  self.anim = self.transform:Find("Model/A_build_xswf_damen_zheng/A_build_xswf_damen_skin"):GetComponent(typeof(CS.SimpleAnimation))
  self.levelInfoTrans = self.transform:Find("Model/levelInfo")
  self.levelInfoObj = self.levelInfoTrans.gameObject
  self.levelInfoObj:SetActive(true)
  self.textLevel = self.levelInfoTrans:Find("textLevel"):GetComponent(typeof(CS.TextMeshProEx))
  self.textLevel.text = self.buildingLevel
  self.updateProgressTrans = self.transform:Find("Model/levelInfo/updateProgress")
  self.updateProgressTrans.gameObject:SetActive(true)
  self.textUpgradeCost = self.updateProgressTrans:Find("textUpgradeCost"):GetComponent(typeof(CS.TextMeshProEx))
  self.imageUpgradeProgress = self.updateProgressTrans:Find("bgProgress"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.imageUpgradeProgress.size = Vector2.New(1, 0)
  self:OnLoadComplete()
  self:OnBuildCoinFull()
end

function LastStandGate:OnLoadComplete()
  self:SetDoorRotation()
  self:InitGateUI()
end

function LastStandGate:OnBuildProgressRefresh()
  self.textProgress.text = self.buildNeedCoin - self.curCoin
end

function LastStandGate:OnBuildCoinFull()
  base.OnBuildCoinFull(self)
  self.modelObj:SetActive(true)
  self.createInfoObj:SetActive(false)
end

function LastStandGate:GetRawProperty(type)
  return 0
end

function LastStandGate:OpenDoor(direction)
  if direction == LastStandDoorContactDirection.FromInside then
    if self.anim then
      self.anim:Play("open_out")
    end
  elseif self.anim then
    self.anim:Play("open_in")
  end
end

function LastStandGate:CloseDoor()
  if self.anim then
    if self.anim:IsPlaying("open_out") then
      self.anim:Play("close_out")
    elseif self.anim:IsPlaying("open_in") then
      self.anim:Play("close_in")
    end
  end
end

function LastStandGate:SetDoorRotation()
  local rotationY = 0
  if self.doorInfo then
    if self.doorInfo.type == LastStandDoorType.Left then
      rotationY = 90
    elseif self.doorInfo.type == LastStandDoorType.Right then
      rotationY = -90
    elseif self.doorInfo.type == LastStandDoorType.Top then
      rotationY = 180
    elseif self.doorInfo.type == LastStandDoorType.Bottom then
      rotationY = 0
    end
  end
  self.transform.rotation = Quaternion.Euler(0, rotationY, 0)
end

function LastStandGate:GetDoorType()
  if self.doorInfo then
    return self.doorInfo.type
  end
  return LastStandDoorType.Bottom
end

function LastStandGate:OnBuildingDeath()
  base.OnBuildingDeath(self)
  self.modelObj:SetActive(false)
  if string.IsNullOrEmpty(self.buildingConfig.para1) then
    self.rebornTime = 60
  else
    self.rebornTime = tonumber(self.buildingConfig.para1)
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self:OnReborn()
  end, self.rebornTime)
end

function LastStandGate:OnReborn()
  self.modelObj:SetActive(true)
  self.curBlood = self.maxBlood
end

function LastStandGate:InitGateUI()
  local type = self:GetDoorType()
  if type == LastStandDoorType.Left then
    self.levelInfoTrans:Set_localPosition(-2.6, 0.86, -0.51)
    self.levelInfoTrans:Set_localEulerAngles(0, -90, 0)
    self.hpBarOffset = 0
    self.hpBarHeight = 6.8
  elseif type == LastStandDoorType.Right then
    self.levelInfoTrans:Set_localPosition(2.6, 0.86, 0.51)
    self.levelInfoTrans:Set_localEulerAngles(0, 90, 0)
    self.hpBarOffset = -10
    self.hpBarHeight = 6.8
  elseif type == LastStandDoorType.Top then
    self.levelInfoTrans:Set_localPosition(-5.26, -1.13, -0.82)
    self.levelInfoTrans:Set_localEulerAngles(0, 180, 0)
    self.hpBarOffset = 0
    self.hpBarHeight = 5.4
  else
    self.levelInfoTrans:Set_localPosition(5.26, -1.13, 1.74)
    self.levelInfoTrans:Set_localEulerAngles(0, 0, 0)
    self.hpBarOffset = 0
    self.hpBarHeight = 5.4
  end
end

function LastStandGate:OnDestroy()
  base.OnDestroy(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

return LastStandGate
