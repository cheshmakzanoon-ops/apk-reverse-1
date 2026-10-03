local AllyDrillBase = BaseClass("AllyDrillBase")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource

function AllyDrillBase:__init(marchInfo, transform, isMoveObj)
  self.marchInfo = marchInfo
  self.uuid = self.marchInfo.uuid
  self.bossInfo = self.marchInfo.allianceBoss
  self.isMoveObj = isMoveObj
  self.WorldMonsterSpecialType = self:GetAllyDrillBaseSpecialType()
  self:InitBossAppearance(transform)
end

function AllyDrillBase:__delete()
  self:Destroy()
end

function AllyDrillBase:Destroy()
  if self.bossAppearance then
    self.bossAppearance:Delete()
    self.bossAppearance = nil
  end
  self.marchInfo = nil
  self.uuid = nil
  self.bossInfo = nil
  self.WorldMonsterSpecialType = nil
end

function AllyDrillBase:InitBossAppearance(transform)
  if self.bossAppearance then
    self.bossAppearance:Delete()
  end
  if not self.WorldMonsterSpecialType then
    return
  end
  local allyDrillAppearanceLogic
  if self.WorldMonsterSpecialType == WorldMonsterSpecialType.AllyDrill then
    allyDrillAppearanceLogic = require("Scene.AllyDrillBase.AllyDrillBaseTank")
  elseif self.WorldMonsterSpecialType == WorldMonsterSpecialType.AllyDrillHugeSandWorm then
    allyDrillAppearanceLogic = require("Scene.AllyDrillBase.AllyDrillBaseHugeSandWorm")
  elseif self.WorldMonsterSpecialType == WorldMonsterSpecialType.AllyDrillRoadHog then
    allyDrillAppearanceLogic = require("Scene.AllyDrillBase.AllyDrillBaseRoadHog")
  end
  if allyDrillAppearanceLogic then
    self.bossAppearance = allyDrillAppearanceLogic.New(self, transform)
    self.bossAppearance:Init()
  end
end

function AllyDrillBase:GetAllyDrillBaseSpecialType()
  if not self.bossInfo then
    return nil
  end
  if self.bossInfo.dataS3 then
    return WorldMonsterSpecialType.AllyDrillHugeSandWorm
  elseif self.bossInfo.bossType == AllyDrillBoss.RoadHog then
    return WorldMonsterSpecialType.AllyDrillRoadHog
  else
    return WorldMonsterSpecialType.AllyDrill
  end
end

function AllyDrillBase:Refresh(marchInfo, transform)
  self.marchInfo = marchInfo
  self.transform = transform
  self.uuid = self.marchInfo.uuid
  self.bossInfo = self.marchInfo.allianceBoss
  if self.bossAppearance then
    self.bossAppearance:RefreshView()
  end
end

function AllyDrillBase:RefreshByActInfo(stage)
  local actInfo = DataCenter.AllyDrillDataManager:GetActInfo()
  local bossData = actInfo.data
  if not bossData then
    return
  end
  self.bossInfo.readyTime = bossData.readyTime
  self.bossInfo.battleStartTime = bossData.battleStartTime
  self.bossInfo.battleEndTime = bossData.battleEndTime
  if self.bossAppearance then
    self.bossAppearance:RefreshView()
  end
end

function AllyDrillBase:RefreshBossInfo(bossInfo)
  self.bossInfo = bossInfo
  if self.bossAppearance then
    self.bossAppearance:RefreshView()
  end
end

function AllyDrillBase:OnUpdateSec()
  if self.bossAppearance then
    self.bossAppearance:OnUpdateSec()
  end
end

function AllyDrillBase:IsOccupied(x, y)
  local v2 = CS.SceneManager.World:IndexToTilePos(self.marchInfo.startPos, ForceChangeScene.World)
  return x >= v2.x - 1 and x <= v2.x + 1 and y >= v2.y - 1 and y <= v2.y + 1
end

function AllyDrillBase:IsMine()
  return self.marchInfo.allianceUid == LuaEntry.Player.allianceId
end

function AllyDrillBase:IsRoadHog()
  return self.bossInfo and self.bossInfo.bossType == AllyDrillBoss.RoadHog
end

function AllyDrillBase:ShowCreateEffect()
  if self.bossAppearance then
    self.bossAppearance:ShowCreateEffect()
  end
end

function AllyDrillBase:ShowSkillEffect(type)
  if self.bossAppearance then
    self.bossAppearance:ShowSkillEffect(type)
  end
end

function AllyDrillBase:ShowCritTipEffect(arr)
  if self.bossAppearance then
    self.bossAppearance:ShowCritTipEffect(arr)
  end
end

function AllyDrillBase:CheckDoAttack(marchInfo)
  if self.bossAppearance then
    self.bossAppearance:CheckDoAttack(marchInfo)
  end
end

function AllyDrillBase:DoReactionWhenSingleMarchChange(marchInfo)
  if self.bossAppearance then
    self.bossAppearance:DoReactionWhenSingleMarchChange(marchInfo)
  end
end

function AllyDrillBase:SetMoveState(isHide)
  local troop = CS.SceneManager.World:GetTroop(self.uuid)
  if troop then
    troop:SetVisible(isHide == false)
  end
  if not isHide then
    DataCenter.AllyDrillBaseManager:RemoveMoveDrillBase()
  end
  if self.bossAppearance then
    self.bossAppearance:SetMoveState(isHide)
  end
end

function AllyDrillBase:OnDonateSuccess(msg)
  if self.bossAppearance then
    self.bossAppearance:OnDonateSuccess()
  end
end

function AllyDrillBase:RefreshRoadHogDamage(msg)
  if self.bossAppearance and self.bossAppearance.RefreshRoadHogDamage then
    self.bossAppearance:RefreshRoadHogDamage(msg)
  end
end

function AllyDrillBase:OnAllyDrillInfoRefresh(msg)
  if self.bossAppearance and self.bossAppearance.OnAllyDrillInfoRefresh then
    self.bossAppearance:OnAllyDrillInfoRefresh(msg)
  end
end

function AllyDrillBase:PlayRoadHogBornAnim()
  if self.bossAppearance and self.bossAppearance.ShowBornAnim then
    self.bossAppearance:ShowBornAnim()
  end
end

return AllyDrillBase
