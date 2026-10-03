local p_comp_tab_attack_path = "TabRoot/p_comp_tab_attack"
local p_comp_tab_defence_path = "TabRoot/p_comp_tab_defence"
local p_comp_declare_attack_path = "p_comp_declare_attack"
local p_comp_declare_defence_path = "p_comp_declare_defence"
local Season5DeclareInWarTimeCompAttackComp = require("UI/LWSeason5/DeclareCity/Comp/Season5DeclareInWarTimeAttackComp")
local Season5DeclareInWarTimeCompDefenceComp = require("UI/LWSeason5/DeclareCity/Comp/Season5DeclareInWarTimeDefenceComp")
local base = UIBaseContainer
local Season5DeclareInWarTimeComp = BaseClass("Season5DeclareInWarTimeComp", UIBaseContainer)

function Season5DeclareInWarTimeComp:ComponentDefine()
  self.p_comp_tab_attack = self:AddComponent(UIToggle, p_comp_tab_attack_path)
  self.p_comp_tab_defence = self:AddComponent(UIToggle, p_comp_tab_defence_path)
  self.p_comp_declare_attack = self:AddComponent(Season5DeclareInWarTimeCompAttackComp, p_comp_declare_attack_path)
  self.p_comp_declare_defence = self:AddComponent(Season5DeclareInWarTimeCompDefenceComp, p_comp_declare_defence_path)
end

function Season5DeclareInWarTimeComp:ComponentDestroy()
  self.p_comp_tab_attack = nil
  self.p_comp_tab_defence = nil
  self.p_comp_declare_attack = nil
  self.p_comp_declare_defence = nil
end

function Season5DeclareInWarTimeComp:DataDefine()
end

function Season5DeclareInWarTimeComp:DataDestroy()
end

function Season5DeclareInWarTimeComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function Season5DeclareInWarTimeComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Season5DeclareInWarTimeComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonCrossDeclareWarInfo, self.OnCrossDeclareWarInfo)
end

function Season5DeclareInWarTimeComp:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonCrossDeclareWarInfo, self.OnCrossDeclareWarInfo)
  base.OnRemoveListener(self)
end

function Season5DeclareInWarTimeComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function Season5DeclareInWarTimeComp:InitData(data)
  self.Data = data
  self.CurTabIndex = -1
  return true
end

function Season5DeclareInWarTimeComp:InitUi()
  self:InitToggle()
end

function Season5DeclareInWarTimeComp:InitToggle()
  self.p_comp_tab_attack:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggle(1)
    end
  end)
  self.p_comp_tab_defence:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggle(2)
    end
  end)
  self.p_comp_tab_attack:SetIsOn(true)
  self:OnToggle(1)
end

function Season5DeclareInWarTimeComp:OnToggle(index, reInit)
  if index == self.CurTabIndex and not reInit then
    return
  end
  self.CurTabIndex = index
  if self.CurTabIndex == 1 then
    self.p_comp_declare_attack:SetActive(true)
    self.p_comp_declare_defence:SetActive(false)
    self.p_comp_declare_attack:ReInit(nil)
  elseif self.CurTabIndex == 2 then
    self.p_comp_declare_attack:SetActive(false)
    self.p_comp_declare_defence:SetActive(true)
    self.p_comp_declare_defence:ReInit(nil)
  end
end

function Season5DeclareInWarTimeComp:UpdateData()
end

function Season5DeclareInWarTimeComp:UpdateUi()
end

function Season5DeclareInWarTimeComp:OnCrossDeclareWarInfo()
  self:OnToggle(Mathf.Clamp(checknumber(self.CurTabIndex), 1, 2), true)
end

return Season5DeclareInWarTimeComp
