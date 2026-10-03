local base = require("UI/UILWHero/UIHeroFakePVPFormationPanel/View/UIHeroFakePVPFormationPanelView")
local UIHeroFakePVPFormationView_SeasonTower = BaseClass("UIHeroFakePVPFormationView_SeasonTower", base)
local Localization = CS.GameEntry.Localization
local sweepBtnPath = "Root/BottomBar/Btns/SweepBtn"
local env_buff_btn_path = "Root/EnvBuffBtn"
local icon_path = "Root/EnvBuffBtn/BuffIcon"

function UIHeroFakePVPFormationView_SeasonTower:OnCreate()
  base.OnCreate(self)
  self:RefreshBuff()
end

function UIHeroFakePVPFormationView_SeasonTower:DataDefine()
  base.DataDefine(self)
end

function UIHeroFakePVPFormationView_SeasonTower:DataDestroy()
  base.DataDestroy(self)
end

function UIHeroFakePVPFormationView_SeasonTower:OnDestroy()
  base.OnDestroy(self)
end

function UIHeroFakePVPFormationView_SeasonTower:ComponentDefine()
  base.ComponentDefine(self)
  self.sweepBtn = self:AddComponent(UIButton, sweepBtnPath)
  self.sweepBtn:SetOnClick(function()
    self:OnSweepBtnClick()
  end)
  self.sweepBtn:SetSafeClickMode(true)
  self.env_buff_btn = self:AddComponent(UIButton, env_buff_btn_path)
  self.env_buff_btn:SetOnClick(function()
    self:OnBtnEnvBuffClick()
  end)
  self.env_buff_icon = self:AddComponent(UIImage, icon_path)
  self.sweepBtn:SetActive(DataCenter.LWSeasonTowerManager:IsShowSweepBtn())
end

function UIHeroFakePVPFormationView_SeasonTower:ComponentDestroy()
  base.ComponentDestroy(self)
  self.sweepBtn = nil
  self.env_buff_btn = nil
  self.env_buff_icon = nil
end

function UIHeroFakePVPFormationView_SeasonTower:RefreshBuff()
  local allBuffActive = DataCenter.LWSeasonTowerManager:IsAllBuffActive()
  self.env_buff_btn:SetActive(allBuffActive)
  if allBuffActive then
    self.env_buff_icon:LoadSprite(DataCenter.LWSeasonTowerManager:GetAllBuffIcon())
  end
end

function UIHeroFakePVPFormationView_SeasonTower:RefreshSquadData()
  self.squadData = DataCenter.LWSeasonTowerManager:GetFormation(self.param1.stageId)
  self.slotCount = 5
  self:RefreshHeroInfo()
  self.chooseDominator:SetData(self.source, self.squadIndex, self.param1)
  self.chooseDominator:SetSquadData(self.squadData)
end

function UIHeroFakePVPFormationView_SeasonTower:ClosePanel()
  if not self.squadData then
    return
  end
  local heroesExceptDominator = self.squadData:GetLocalAllHeroes()
  if not table.IsNullOrEmpty(heroesExceptDominator) then
    local curChipSetId = self.squadData:GetLocalTWSkillChipSetId()
    local heroes = self.squadData:GenerateServerHeroArray()
    DataCenter.LWSeasonTowerManager:SaveFormation(self.param1.stageId, curChipSetId, heroes)
  end
  DataCenter.LWBattleManager:Exit()
end

function UIHeroFakePVPFormationView_SeasonTower:OnBattleBtnClick()
  if not (self.squadData and self.param1) or not self.param1.stageId then
    return
  end
  local heroesExceptDominator = self.squadData:GetLocalAllHeroes()
  local dominatorUuid = self.squadData:GetLocalDominatorUuid()
  if table.IsNullOrEmpty(heroesExceptDominator) then
    if dominatorUuid ~= nil and 0 < dominatorUuid then
      UIUtil.ShowTipsId("dominator_squad_empty_warning")
      return
    end
    UIUtil.ShowTipsId("all_squad_empty_warning")
    return
  end
  if self.__waitingForMsg then
    return
  end
  self.__waitingForMsg = true
  local heroes = self.squadData:GenerateServerHeroArray()
  DataCenter.LWSoundManager:PlaySound(10014)
  local curChipSetId = self.squadData:GetLocalTWSkillChipSetId()
  DataCenter.LWSeasonTowerManager:SaveFormation(self.param1.stageId, curChipSetId, heroes)
  DataCenter.LWSeasonTowerManager:Battle(self.param1.stageId, SeasonTowerConfig.BattleType.Battle, heroes)
end

function UIHeroFakePVPFormationView_SeasonTower:OnSweepBtnClick()
  if not self.squadData then
    return
  end
  if self.squadData:GetLocalHeroesCount() == 0 then
    UIUtil.ShowTipsId("all_squad_empty_warning")
    return
  end
  local heroesExceptDominator = self.squadData:GetLocalAllHeroes()
  if not table.IsNullOrEmpty(heroesExceptDominator) then
    local curChipSetId = self.squadData:GetLocalTWSkillChipSetId()
    local heroes = self.squadData:GenerateServerHeroArray()
    DataCenter.LWSeasonTowerManager:SaveFormation(self.param1.stageId, curChipSetId, heroes)
  end
  DataCenter.LWBattleManager:Exit(function()
    return SeasonTowerConfig.EnterType.Sweep
  end)
end

function UIHeroFakePVPFormationView_SeasonTower:OnBtnEnvBuffClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonTowerBuffPanel, {anim = true}, {
    buffType = SeasonTowerConfig.BuffType.All
  })
end

return UIHeroFakePVPFormationView_SeasonTower
