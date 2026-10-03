local FormationScoutSelectTipV2 = BaseClass("FormationScoutSelectTipV2", UIBaseContainer)
local base = UIBaseContainer
local content_txt_path = "Desc"
local cost_time_path = "share/Time"
local btn_txt_path = "button/InvestigateBtn/InvestigateTxt"
local elec_cost_path = "button/InvestigateBtn/Cost/CostTxt"
local btn_go_path = "button/InvestigateBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.TipTxt = self:AddComponent(UIText, content_txt_path)
  self.CostTimeTxt = self:AddComponent(UIText, cost_time_path)
  self.BtnTxt = self:AddComponent(UIText, btn_txt_path)
  self.BtnTxt:SetLocalText(110003)
  self.ElecCostTxt = self:AddComponent(UIText, elec_cost_path)
  self.InvestigateBtn = self:AddComponent(UIButton, btn_go_path)
  self.InvestigateBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Scout_Btn)
    self:OnClickStartInvestigate()
  end)
end

local function ComponentDestroy(self)
  self.TipTxt = nil
  self.CostTimeTxt = nil
  self.BtnTxt = nil
  self.ElecCostTxt = nil
  self.InvestigateBtn = nil
end

local function DataDefine(self)
  self.targetPointId = nil
  self.curSelectedIndex = nil
end

local function DataDestroy(self)
  self.targetPointId = nil
  self.curSelectedIndex = nil
end

local function InitUI(self, targetPointId, tempIndex)
  self.targetPointId = targetPointId
  self:RefreshUI(tempIndex)
end

local function RefreshUI(self, tempIndex)
  self.curSelectedIndex = tempIndex
  local elecCost = self.view.ctrl:GetElecCost(self.targetPointId, self.curSelectedIndex)
  self.ElecCostTxt:SetText(elecCost)
  local stateTip = self.view:GetInvesFormationStateDes()
  self.TipTxt:SetLocalText(stateTip)
  local timeCost = self.view:GetInvesCostTime(self.targetPointId)
  self.CostTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(timeCost * 1000))
end

local function ResetCosts(self, realCost, timeRealCost)
  self.ElecCostTxt:SetText(realCost)
  self.CostTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(timeRealCost * 1000))
end

local function OnClickStartInvestigate(self)
  self.view:OnClickStartInvestigate(self.targetPointId)
end

local function ResetTipPosition(self, posX, posY)
  local v3 = self.transform.position
  v3.x = posX
  self.transform.position = v3
end

FormationScoutSelectTipV2.OnCreate = OnCreate
FormationScoutSelectTipV2.OnDestroy = OnDestroy
FormationScoutSelectTipV2.OnEnable = OnEnable
FormationScoutSelectTipV2.OnDisable = OnDisable
FormationScoutSelectTipV2.ComponentDefine = ComponentDefine
FormationScoutSelectTipV2.ComponentDestroy = ComponentDestroy
FormationScoutSelectTipV2.DataDefine = DataDefine
FormationScoutSelectTipV2.DataDestroy = DataDestroy
FormationScoutSelectTipV2.OnAddListener = OnAddListener
FormationScoutSelectTipV2.OnRemoveListener = OnRemoveListener
FormationScoutSelectTipV2.InitUI = InitUI
FormationScoutSelectTipV2.RefreshUI = RefreshUI
FormationScoutSelectTipV2.OnClickStartInvestigate = OnClickStartInvestigate
FormationScoutSelectTipV2.ResetCosts = ResetCosts
FormationScoutSelectTipV2.ResetTipPosition = ResetTipPosition
return FormationScoutSelectTipV2
