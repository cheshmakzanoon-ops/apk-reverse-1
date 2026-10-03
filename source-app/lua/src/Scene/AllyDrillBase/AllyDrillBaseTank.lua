local AllyDrillBaseTank = BaseClass("AllyDrillBaseTank")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource

function AllyDrillBaseTank:__init(allyDrillBase, transform)
  self.transform = transform
  self.allyDrillBase = allyDrillBase
end

function AllyDrillBaseTank:__delete()
  self:Destroy()
end

function AllyDrillBaseTank:Destroy()
  self:ClearBornEffect()
  self.allyDrillBase = nil
  self.sliderNode = nil
  self.sliderBar = nil
  self.sliderSprite = nil
  self.sliderText = nil
  self.timeNode = nil
  self.timeText = nil
  self.transform = nil
  self.buildAnimator = nil
  self.showTankTime = nil
  self.isMoveObj = nil
  self.showTankEffectTime = nil
end

function AllyDrillBaseTank:Init()
  self.desNameText = self.transform:Find("Icon/IconSprite/Des/DesNameText"):GetComponent(typeof(CS.SuperTextMesh))
  self.modelLabel = self.transform:Find("ModelLabel").gameObject
  self.modelLabel:SetActive(true)
  self.sliderNode = self.transform:Find("ModelLabel/Slider").gameObject
  self.sliderBar = self.transform:Find("ModelLabel/Slider/SliderBar")
  self.sliderSprite = self.sliderBar:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.sliderText = self.transform:Find("ModelLabel/Slider/SliderText"):GetComponent(typeof(CS.SuperTextMesh))
  self.timeNode = self.transform:Find("ModelLabel/Time").gameObject
  self.timeText = self.transform:Find("ModelLabel/Time/TimeText"):GetComponent(typeof(CS.TextMeshProEx))
  self.nameText = self.transform:Find("ModelLabel/Name/NameText"):GetComponent(typeof(CS.TextMeshProEx))
  self.tankNode = self.transform:Find("Model/WorldModel/hero").gameObject
  self.buildNode = self.transform:Find("Model/WorldModel/A_build_tongmengjunyan").gameObject
  self.buildAnimator = self.buildNode:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
  self.worldModel = self.transform:Find("Model/WorldModel")
  self.appearEff = self.transform:Find("Model/WorldModel/Eff_A_build_tongmengjunyan_born_smoke").gameObject
  self.appearEff:SetActive(false)
  self.disappearEff = self.transform:Find("Model/WorldModel/Eff_daditu_lianmengboss_tuichu").gameObject
  self.disappearEff:SetActive(false)
  self:InitName()
  self:RefreshView()
  if not self.isMoveObj and DataCenter.AllyDrillBaseManager:CheckDrillBaseIsMove(self.allyDrillBase.uuid) then
    local troop = CS.SceneManager.World:GetTroop(self.allyDrillBase.uuid)
    if troop then
      troop:SetVisible(false)
    end
  end
end

function AllyDrillBaseTank:InitName()
  local meta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(self.allyDrillBase.marchInfo.monsterId)
  local bossName = Localization:GetString(meta.name)
  local bossLv = meta.level
  local bossNameAndLevel = Localization:GetString("140205", bossLv, bossName)
  local nameStr = Localization:GetString("311026", self.allyDrillBase.marchInfo.allianceAbbr, bossNameAndLevel)
  self.desNameText.text = self.allyDrillBase.marchInfo.allianceAbbr
  self.nameText.text = nameStr
end

function AllyDrillBaseTank:RefreshView()
  local bossInfo = self.allyDrillBase.bossInfo
  if not bossInfo or not bossInfo.readyTime then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local oldStage = self.stage
  Logger.Log(oldStage)
  if now < bossInfo.readyTime then
    self.stage = AllyDrillStage.PrepareStage
    self.nextTime = bossInfo.readyTime
    self.sliderNode:SetActive(false)
    self.tankNode:SetActive(false)
    self.buildNode:SetActive(true)
    if DataCenter.AllyDrillBaseManager:CheckNeedShowCreateEffect(self.allyDrillBase.uuid) then
      self:ShowCreateEffect()
      DataCenter.AllyDrillBaseManager:ClearNeedShowCreateEffect()
    else
      self.buildAnimator:SetTrigger("idle")
    end
  elseif bossInfo.battleStartTime <= 0 then
    if bossInfo.actEndTime then
      if now < bossInfo.actEndTime then
        self.stage = AllyDrillStage.ReadyStage
        self.sliderNode:SetActive(false)
        self.tankNode:SetActive(false)
        self.buildNode:SetActive(true)
        self.buildAnimator:SetTrigger("idle")
        self.nextTime = bossInfo.actEndTime
      else
        self.stage = AllyDrillStage.End
        self.sliderNode:SetActive(false)
        self.tankNode:SetActive(false)
        self.buildNode:SetActive(true)
        self.buildAnimator:SetTrigger("idle")
        self.nextTime = nil
      end
    else
      self.stage = AllyDrillStage.ReadyStage
      self.sliderNode:SetActive(false)
      self.tankNode:SetActive(false)
      self.buildNode:SetActive(true)
      self.buildAnimator:SetTrigger("idle")
      self.nextTime = nil
    end
  elseif now < bossInfo.battleEndTime then
    self.stage = AllyDrillStage.AttackStage
    if oldStage ~= nil and oldStage ~= self.stage then
      self.tankNode:SetActive(false)
      self.buildNode:SetActive(true)
      self:ShowBornAnim()
    elseif self.showTankTime == nil then
      self.tankNode:SetActive(true)
      self.buildNode:SetActive(false)
    end
    self.sliderNode:SetActive(true)
    self.nextTime = bossInfo.battleEndTime
    local sliderValue = 1
    if 0 < bossInfo.maxDamage then
      sliderValue = bossInfo.damage / bossInfo.maxDamage
    end
    self.sliderBar.localPosition = Vector3.New(sliderValue * 2.5 - 2.5, -0.22, 0)
    self.sliderSprite.size = Vector2.New(sliderValue * 5, 0.5)
    self.sliderText.text = Localization:GetString(2010380, bossInfo.lv)
  else
    self.stage = AllyDrillStage.SettleStage
    self.tankNode:SetActive(false)
    self.buildNode:SetActive(true)
    if oldStage ~= nil and oldStage ~= self.stage then
      self:ShowDieAnim()
    else
      self.buildAnimator:SetTrigger("idle")
    end
    self.sliderNode:SetActive(false)
    self.nextTime = nil
  end
end

function AllyDrillBaseTank:OnUpdateSec()
  if self.stage == nil then
    self:RefreshView()
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.nextTime and now > self.nextTime then
    self:RefreshView()
  end
  if self.stage == AllyDrillStage.PrepareStage then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.nextTime - now)
    self.timeText.text = Localization:GetString("2010331", timeStr)
  elseif self.stage == AllyDrillStage.ReadyStage then
    self.timeText.text = Localization:GetString("2010349")
  elseif self.stage == AllyDrillStage.AttackStage then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.nextTime - now)
    self.timeText.text = Localization:GetString("2010329", timeStr)
  else
    self.timeText.text = Localization:GetString("2010333")
  end
  if self.showTankTime and now > self.showTankTime then
    self.tankNode:SetActive(true)
    self.buildNode:SetActive(false)
    self.showTankTime = nil
  end
  if self.showTankEffectTime and now > self.showTankEffectTime then
    self.showTankEffectTime = nil
    self:ShowBornEffect()
  end
end

function AllyDrillBaseTank:ShowCreateEffect()
  self.appearEff:SetActive(true)
  self.buildAnimator:ResetTrigger("idle")
  self.buildAnimator:SetTrigger("born")
end

function AllyDrillBaseTank:SetMoveState(isHide)
  if isHide then
    self.appearEff:SetActive(false)
  elseif self.showTankTime then
    self:ShowBornAnim()
  end
end

function AllyDrillBaseTank:OnDonateSuccess(msg)
  self.buildAnimator:ResetTrigger("idle")
  self.buildAnimator:SetTrigger("action")
end

function AllyDrillBaseTank:ShowBornAnim()
  self.buildAnimator:ResetTrigger("idle")
  self.buildAnimator:SetTrigger("die")
  local cur = UITimeManager:GetInstance():GetServerTime()
  self.showTankTime = cur + 4000
  self.showTankEffectTime = cur + 3000
end

function AllyDrillBaseTank:ShowDieAnim()
  self.disappearEff:SetActive(true)
  self.buildAnimator:ResetTrigger("idle")
  self.buildAnimator:SetTrigger("born")
end

function AllyDrillBaseTank:ShowBornEffect()
  local prefabName = "Assets/_Art_LastWar/Effect/Prefab/daditu/Eff_tongmengjunyan_monster_born.prefab"
  self:ClearBornEffect()
  self.effectReq = ResourceManager:InstantiateAsync(prefabName)
  self.effectReq:completed("+", function()
    if self.effectReq.isError then
      return
    end
    local go = self.effectReq.gameObject
    go.transform:SetParent(self.transform)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go:SetActive(true)
  end)
  self.effectDelay = TimerManager:GetInstance():DelayInvoke(function()
    self:ClearBornEffect()
  end, 3)
end

function AllyDrillBaseTank:ClearBornEffect()
  if self.effectReq then
    self.effectReq:Destroy()
    self.effectReq = nil
  end
  if self.effectDelay then
    self.effectDelay:Stop()
    self.effectDelay = nil
  end
end

function AllyDrillBaseTank:ShowSkillEffect(type)
end

function AllyDrillBaseTank:CheckDoAttack(marchInfo)
end

function AllyDrillBaseTank:DoReactionWhenSingleMarchChange(marchInfo)
end

function AllyDrillBaseTank:ShowCritTipEffect(arr)
end

return AllyDrillBaseTank
