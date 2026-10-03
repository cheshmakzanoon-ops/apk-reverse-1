local base = require("DataCenter.LWBattle.Logic.LastStand.LastStandBuilding.LastStandBuildingUnit")
local LastStandHospital = BaseClass("LastStandHospital", base)
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade

function LastStandHospital:Init(logic, config, pos)
  base.Init(self, logic, config, pos)
  self.needHealCount = 0
  self.updateInterval = 1
  self.lastStandBuildingType = LastStandBuildType.Hospital
  if not string.IsNullOrEmpty(self.buildingConfig.para2) then
    self.maxCount = tonumber(self.buildingConfig.para2)
  else
    self.maxCount = 99
  end
  local scale = ResetScale.x
  local path = "Assets/Main/Prefabs/LastStand/LastStandHospital.prefab"
  self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, path, nil, scale, pos.x, 0.01, pos.z, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Member"))
  if self.viewLoaded then
    self:OnViewLoaded(true)
  end
end

function LastStandHospital:AddSoliderToHospital()
  if self.needHealCount >= self.maxCount then
    return
  end
  self.needHealCount = self.needHealCount + 1
  self:OnHealedFinish()
end

function LastStandHospital:ExecuteIntervalLogic()
  if self.needHealCount > 0 and self.logic.buildingMgr:ArmyYardIsNotFull() then
    self.needHealCount = self.needHealCount - 1
    self:OnHealedFinish()
    self.logic:AddSoliderToArmyYard(self.guid)
  end
end

function LastStandHospital:OnHealedFinish()
  self.textTrainDes.text = self.needHealCount or 0
end

function LastStandHospital:OnViewLoaded(force)
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.gameObject = UnitViewFacade.GetGameObject(self.viewHandle)
  self.gameObject.name = "\229\140\187\233\153\162"
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
  self.trainInfoObj = self.gameObject.transform:Find("Model/trainInfo").gameObject
  self.imageTrainProgress = self.trainInfoObj.transform:Find("imgProgress"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.imageTrainProgress.size = Vector2.New(0.45, 0)
  self.textTrainDes = self.trainInfoObj.transform:Find("textDes"):GetComponent(typeof(CS.TextMeshProEx))
  self.textTrainDes.text = self.needHealCount
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
  self.modelBuildingObj = self.transform:Find("Model/A_build_xswf_yiyuan")
  self:OnLoadComplete()
end

function LastStandHospital:OnBuildProgressRefresh()
  self.textProgress.text = self.buildNeedCoin - self.curCoin
end

function LastStandHospital:OnBuildCoinFull()
  base.OnBuildCoinFull(self)
  self.modelObj:SetActive(true)
  self.createInfoObj:SetActive(false)
end

function LastStandHospital:OnBuildingUpgrade()
  base.OnBuildingUpgrade(self)
  self.updateInterval = tonumber(self.buildingConfig.para1)
  self.curInterval = self.updateInterval
  if not string.IsNullOrEmpty(self.buildingConfig.para2) then
    self.maxCount = tonumber(self.buildingConfig.para2)
  else
    self.maxCount = 99
  end
end

function LastStandHospital:UpdateInterval()
  if self.needHealCount > 0 and self.logic.buildingMgr:ArmyYardIsNotFull() then
    local progress = (self.updateInterval - self.curInterval) / self.updateInterval
    self.imageTrainProgress.size = Vector2.New(0.45, 3 * progress)
  else
    self.imageTrainProgress.size = Vector2.New(0.45, 3)
  end
end

return LastStandHospital
