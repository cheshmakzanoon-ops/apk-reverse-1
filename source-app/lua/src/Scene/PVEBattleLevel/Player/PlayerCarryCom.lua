local PlayerCarryCom = BaseClass("PlayerCarryCom")
local Const = require("Scene.PVEBattleLevel.Const")

function PlayerCarryCom:__init(spaceman)
  self.m_citySpaceMan = spaceman
  self.m_resStoreId = 0
  self.isOnPveFactory = false
  self.m_popObj = {}
end

function PlayerCarryCom:__delete()
  self:StopSubmitTick()
  for k, _ in pairs(self.m_popObj) do
    k:Destroy()
  end
  self.m_popObj = nil
end

function PlayerCarryCom:CheckSubmitRes()
  local result = false
  local tilePos = self.m_citySpaceMan:GetTilePos()
  local triggerList = self.m_citySpaceMan.battleLevel:GetTriggersByTilePos(tilePos)
  local hitFactory = false
  if triggerList ~= nil then
    for k, v in pairs(triggerList) do
      local triggerPoint = v
      if triggerPoint and not triggerPoint:IsTriggerOK() and triggerPoint:IsPreTriggerOK() and triggerPoint:CanSubmit() and self.m_citySpaceMan.battleLevel:IsPveStaminaEnough(triggerPoint:GetNeedPveStamina()) then
        if triggerPoint:IsNeedPlaceSubmit() then
          self:BeginSubmit(triggerPoint)
          result = true
        elseif triggerPoint:IsTypeMonster() then
          self.m_citySpaceMan.battleLevel:DoTrigger(triggerPoint)
        elseif triggerPoint:IsTypeDiffMonster() then
          self.m_citySpaceMan.battleLevel:ShowSelectDiff(triggerPoint)
        elseif triggerPoint:IsTypeDiffMonsterEasy() then
          PveActorMgr:GetInstance():SetDiffMonsterEasy(triggerPoint)
        elseif triggerPoint:IsTypeLevelLimitMonster() then
          self.m_citySpaceMan.battleLevel:DoTrigger(triggerPoint)
        elseif triggerPoint:IsTypeAdventureSub() then
          self.m_citySpaceMan.battleLevel:ShowAdventureSub(triggerPoint)
        elseif triggerPoint:IsTypeShowModel() then
          self.m_citySpaceMan.battleLevel:DoTrigger(triggerPoint)
        elseif triggerPoint:IsMonsterWithHp() then
          self.m_citySpaceMan.battleLevel:DoTrigger(triggerPoint)
        elseif triggerPoint:ISPVEFactory() then
          if not self.isOnPveFactory then
            self.m_citySpaceMan.battleLevel:DoTrigger(triggerPoint)
            self.isOnPveFactory = true
          end
          hitFactory = true
        elseif triggerPoint:IsTypeGotoOtherPve() then
          self.m_citySpaceMan.battleLevel:DoTrigger(triggerPoint)
        end
      end
    end
  end
  if hitFactory == false then
    self.isOnPveFactory = false
  end
  if not result then
    self:StopSubmit()
  end
  return result
end

function PlayerCarryCom:StopSubmit()
  if self.m_resStoreId ~= 0 then
    self:PlayerLeaveTrigger()
    self:StopSubmitTick()
    self.m_resStoreId = 0
  end
end

function PlayerCarryCom:BeginSubmit(triggerPoint)
  local curStoreId = triggerPoint:GetObjId()
  if self.m_resStoreId ~= curStoreId then
    self:StopSubmit()
    self.m_resStoreId = curStoreId
    self:PlayerEnterTrigger(self.m_resStoreId)
    self:SubmitResTick(triggerPoint)
  end
end

function PlayerCarryCom:PlayerEnterTrigger(id)
  local triggerObj = self.m_citySpaceMan.battleLevel:GetObj(id)
  if not triggerObj then
    return
  end
  triggerObj:PlayScaleUp()
end

function PlayerCarryCom:PlayerLeaveTrigger()
  if self.m_resStoreId ~= 0 then
    local triggerObj = self.m_citySpaceMan.battleLevel:GetObj(self.m_resStoreId)
    if triggerObj then
      triggerObj:PlayScaleDown()
    end
  end
end

function PlayerCarryCom:SubmitResTick(triggerPoint)
  local time = self.m_citySpaceMan.subMitTime
  if self.collectTimer ~= nil and time == self.subMitTime then
    return
  end
  DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PveEnterSubmitResource, tostring(triggerPoint:GetTriggerId()))
  self.subMitTime = time
  self:StopSubmitTick()
  self.collectTimer = TimerManager:GetInstance():GetTimer(time, function()
    self:CollectOneRes(triggerPoint)
  end, nil, false, false, false)
  self.collectTimer:Start()
end

function PlayerCarryCom:StopSubmitTick()
  if self.collectTimer ~= nil then
    self.collectTimer:Stop()
    self.collectTimer = nil
  end
end

function PlayerCarryCom:CollectOneRes(triggerPoint)
  local submitFlag = false
  if triggerPoint:HasType(Const.CityCutResType.Person) or self.m_citySpaceMan:IsFinalState() and triggerPoint:HasType(Const.UnlockToResType[Const.CommitType.Flag]) then
    submitFlag = true
  end
  if self.m_citySpaceMan.battleLevel:IsCheatOk() or submitFlag then
    self:StopSubmitTick()
    self.m_citySpaceMan.battleLevel:DoTrigger(triggerPoint)
    return
  end
  local pos = triggerPoint:GetPosition()
  if triggerPoint:IsTypeCommitRes() or triggerPoint:IsTypeTurret() then
    local subMitCount = self.m_citySpaceMan.subMitCount
    local isGive = false
    if self.m_citySpaceMan:GetCarryCnt() > 0 then
      local isShow = self.m_citySpaceMan.battleLevel:IsShowCarry()
      if isShow then
        for t, need in pairs(triggerPoint:GetAllNeedRes()) do
          local resType = Const.UnlockToResType[t]
          local give = triggerPoint:GetGiveRes(t)
          local remain = need - give
          if 0 < remain then
            local submitCount = self.m_citySpaceMan:SubmitObjectAndGetSubmitCount(resType, SceneUtils.TileToWorld(triggerPoint:GetShowPos()), subMitCount, remain)
            if 0 < submitCount then
              self.m_citySpaceMan:ChangeOneResType(resType, -submitCount)
              triggerPoint:GiveRes(t, submitCount)
              triggerPoint:RefreshText()
              triggerPoint:AniItem(resType)
            end
            DataCenter.LWSoundManager:PlaySound(table.randomArrayValue(EnumPioneerSubmit), false)
            CommonUtil.VibratorLightImpact()
            self.m_citySpaceMan.battleLevel:RefreshCarryResourceText()
            isGive = true
            break
          end
        end
      else
        for t, need in pairs(triggerPoint:GetAllNeedRes()) do
          local resType = Const.UnlockToResType[t]
          local count = DataCenter.BattleLevel:GetResTypeCount(resType)
          if 0 < count then
            local give = triggerPoint:GetGiveRes(t)
            local remain = need - give
            if 0 < remain then
              local submitCount = 0
              if subMitCount > count then
                if count > remain then
                  submitCount = remain
                else
                  submitCount = count
                end
              elseif subMitCount > remain then
                submitCount = remain
              else
                submitCount = subMitCount
              end
              self.m_citySpaceMan.battleLevel:ChangeResTypeCount(resType, -submitCount, pos)
              triggerPoint:GiveRes(t, submitCount)
              DataCenter.LWSoundManager:PlaySound(table.randomArrayValue(EnumPioneerSubmit), false)
              CommonUtil.VibratorLightImpact()
              triggerPoint:RefreshText()
              triggerPoint:AniItem(resType)
              self.m_citySpaceMan.battleLevel:RefreshCarryResourceText()
              isGive = true
              break
            end
          end
        end
      end
    end
    if not isGive then
      for t, need in pairs(triggerPoint:GetAllNeedRes()) do
        local resType = t
        local num = self.m_citySpaceMan.battleLevel:GetResTypeCount(resType)
        if 0 < num then
          local give = triggerPoint:GetGiveRes(t)
          local remain = need - give
          if 0 < remain then
            local submitCount = 0
            if subMitCount > num then
              if num > remain then
                submitCount = remain
              else
                submitCount = num
              end
            elseif subMitCount > remain then
              submitCount = remain
            else
              submitCount = subMitCount
            end
            self.m_citySpaceMan.battleLevel:ChangeResTypeCount(resType, -submitCount, pos)
            triggerPoint:GiveRes(t, submitCount)
            DataCenter.LWSoundManager:PlaySound(table.randomArrayValue(EnumPioneerSubmit), false)
            CommonUtil.VibratorLightImpact()
            triggerPoint:RefreshText()
            triggerPoint:AniItem(resType)
            break
          end
        end
      end
    end
    if isGive then
      local levelType = self.m_citySpaceMan.battleLevel:GetLevelType()
      if levelType == PveLevelType.HeroExpLevel then
        self.m_citySpaceMan:ShowLevelUpEffect()
        self.m_citySpaceMan:ShowExpPopEffect()
      end
    end
  elseif triggerPoint:IsTypeCommitResource() then
    local subMitCount = self.m_citySpaceMan.subMitCount
    for t, need in pairs(triggerPoint:GetAllNeedRes()) do
      local resType = Const.ResourceTypeToResType[t]
      local num = self.m_citySpaceMan.battleLevel:GetResTypeCount(resType)
      if 0 < num then
        local give = triggerPoint:GetGiveRes(t)
        local remain = need - give
        if 0 < remain then
          local submitCount = 0
          if subMitCount > num then
            if num > remain then
              submitCount = remain
            else
              submitCount = num
            end
          elseif subMitCount > remain then
            submitCount = remain
          else
            submitCount = subMitCount
          end
          self.m_citySpaceMan.battleLevel:ChangeSubmitResource(t, submitCount)
          triggerPoint:GiveRes(t, submitCount)
          DataCenter.LWSoundManager:PlaySound(table.randomArrayValue(EnumPioneerSubmit), false)
          CommonUtil.VibratorLightImpact()
          triggerPoint:RefreshText()
          triggerPoint:AniItem(t)
          break
        end
      end
    end
  elseif triggerPoint:IsTypeCommitResourceItem() then
    local subMitCount = self.m_citySpaceMan.subMitCount
    for t, need in pairs(triggerPoint:GetAllNeedRes()) do
      local resType = t
      local num = self.m_citySpaceMan.battleLevel:GetResourceItemCountByResType(resType)
      if 0 < num then
        local give = triggerPoint:GetGiveRes(t)
        local remain = need - give
        if 0 < remain then
          local submitCount = 0
          if subMitCount > num then
            if num > remain then
              submitCount = remain
            else
              submitCount = num
            end
          elseif subMitCount > remain then
            submitCount = remain
          else
            submitCount = subMitCount
          end
          if self.m_citySpaceMan.battleLevel:IsCarryResourceItemType(resType) then
            self.m_citySpaceMan.battleLevel:ChangeCarryObjectNum(resType, -submitCount, pos)
          end
          self.m_citySpaceMan.battleLevel:ChangeSubmitResourceItem(t, submitCount)
          triggerPoint:GiveRes(t, submitCount)
          DataCenter.LWSoundManager:PlaySound(table.randomArrayValue(EnumPioneerSubmit), false)
          CommonUtil.VibratorLightImpact()
          triggerPoint:RefreshText()
          triggerPoint:AniItem(t)
          break
        end
      end
    end
  elseif triggerPoint:IsTypeCommitLvPoint() then
    local haveCount = self.m_citySpaceMan.battleLevel:GetLvPoint()
    local needCount = triggerPoint.config.needLvPoint
    local givenCount = triggerPoint:GetCurLvPoint()
    local restCount = needCount - givenCount
    local submitCount = haveCount
    submitCount = math.min(submitCount, restCount)
    submitCount = math.min(submitCount, needCount // 5)
    if 0 < submitCount then
      self.m_citySpaceMan.battleLevel:SetLvPoint(haveCount - submitCount)
      triggerPoint:SetCurLvPoint(givenCount + submitCount)
      triggerPoint:RefreshText()
      triggerPoint:AniItem(1)
      DataCenter.LWSoundManager:PlaySound(table.randomArrayValue(EnumPioneerSubmit), false)
      CommonUtil.VibratorLightImpact()
    end
  end
  if triggerPoint:IsFull() then
    self:StopSubmitTick()
    self.m_citySpaceMan.battleLevel:DoTrigger(triggerPoint)
  end
end

return PlayerCarryCom
