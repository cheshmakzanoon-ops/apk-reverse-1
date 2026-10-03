local base = UIAsyncContainer
local SeasonCampDestroyBattleDetail = BaseClass("SeasonCampDestroyBattleDetail", base)
local SeasonCampDestroyBattleDetailAtk = require("UI.LWSeason6.SeasonCampDestroy.Comps.SeasonCampDestroyBattleDetailAtk")
local SeasonCampDestroyBattleDefComp = require("UI.LWSeason6.SeasonCampDestroy.Comps.SeasonCampDestroyBattleDefComp")
local Localization = CS.GameEntry.Localization

function SeasonCampDestroyBattleDetail:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function SeasonCampDestroyBattleDetail:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyBattleDetail:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.togglePCompTabAttack = self.viewSkin:AddComponent(self, UIToggle, 1)
  self.togglePCompTabDefence = self.viewSkin:AddComponent(self, UIToggle, 2)
  self.compPContentAttack = self.viewSkin:AddComponent(self, SeasonCampDestroyBattleDetailAtk, 3)
  self.compPDeclareDefence = self.viewSkin:AddComponent(self, SeasonCampDestroyBattleDefComp, 4)
  self.CurTabIndex = -1
  self:SetOffsetMinXY(0, 0)
  self:SetOffsetMaxXY(0, 0)
  self:InitUi()
end

function SeasonCampDestroyBattleDetail:ComponentDestroy()
  self.viewSkin = nil
  self.togglePCompTabAttack = nil
  self.togglePCompTabDefence = nil
  self.compPContentAttack = nil
  self.compPDeclareDefence = nil
end

function SeasonCampDestroyBattleDetail:DataDefine()
  self.mgr = DataCenter.SeasonCampDestroyManager
end

function SeasonCampDestroyBattleDetail:DataDestroy()
  self.mgr = nil
end

function SeasonCampDestroyBattleDetail:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonCampDestroyActRefresh, self.OnSeasonCampDestroyActRefresh)
end

function SeasonCampDestroyBattleDetail:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonCampDestroyActRefresh, self.OnSeasonCampDestroyActRefresh)
  base.OnRemoveListener(self)
end

function SeasonCampDestroyBattleDetail:OnSeasonCampDestroyActRefresh()
  self:Refresh()
end

function SeasonCampDestroyBattleDetail:Refresh()
  self:OnToggle(Mathf.Clamp(checknumber(self.CurTabIndex), 1, 2), true)
end

function SeasonCampDestroyBattleDetail:InitUi()
  self:InitToggle()
end

function SeasonCampDestroyBattleDetail:InitToggle()
  self.togglePCompTabAttack:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggle(1)
    end
  end)
  self.togglePCompTabDefence:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggle(2)
    end
  end)
  UIUtil.SetTextLit(self.togglePCompTabAttack.transform, "ConditionSelect/Condition", "season_s5_activity_1200059_desc17")
  UIUtil.SetTextLit(self.togglePCompTabAttack.transform, "ConditionDark", "season_s5_activity_1200059_desc17")
  UIUtil.SetTextLit(self.togglePCompTabDefence.transform, "ConditionSelect/Condition", "season_s5_activity_1200059_desc18")
  UIUtil.SetTextLit(self.togglePCompTabDefence.transform, "ConditionDark", "season_s5_activity_1200059_desc18")
  self.togglePCompTabAttack:SetIsOn(true)
  self:OnToggle(1)
end

function SeasonCampDestroyBattleDetail:OnToggle(index, reInit)
  if index == self.CurTabIndex and not reInit then
    return
  end
  self.CurTabIndex = index
  if self.CurTabIndex == 1 then
    self.compPContentAttack:SetActive(true)
    self.compPDeclareDefence:SetActive(false)
    self.compPContentAttack:ReInit(self.mgr:GetDeclareList())
  elseif self.CurTabIndex == 2 then
    self.compPContentAttack:SetActive(false)
    self.compPDeclareDefence:SetActive(true)
    self.compPDeclareDefence:ReInit(self.mgr:GetBeDeclareList())
  end
end

function SeasonCampDestroyBattleDetail:UpdateData()
end

function SeasonCampDestroyBattleDetail:UpdateUi()
end

function SeasonCampDestroyBattleDetail:OnCrossDeclareWarInfo()
  self:OnToggle(Mathf.Clamp(checknumber(self.CurTabIndex), 1, 2), true)
end

return SeasonCampDestroyBattleDetail
