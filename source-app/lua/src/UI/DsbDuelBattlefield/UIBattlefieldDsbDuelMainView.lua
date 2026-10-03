local base = require("UI.BattleFieldBase.BattleFieldBaseView")
local UIBattlefieldDsbDuelMainView = BaseClass("UIBattlefieldDsbDuelMainView", base)
local UIBattlefieldDsbDuelRoleScore = require("UI.DsbDuelBattlefield.UIBattlefieldDsbDuelRoleScore")
local UIBattlefieldDsbNoticeItem = require("UI.DsbDuelBattlefield.Misc.UIBattlefieldDsbNoticeItem")
local Localization = CS.GameEntry.Localization

function UIBattlefieldDsbDuelMainView:OnCreate()
  base.OnCreate(self)
end

function UIBattlefieldDsbDuelMainView:OnDestroy()
  self.compRoles = nil
  self.battleEnd = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattlefieldDsbDuelMainView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compFlatLayout = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.compScore1 = self.viewSkin:AddComponent(self, UIBattlefieldDsbDuelRoleScore, 2)
  self.compScore2 = self.viewSkin:AddComponent(self, UIBattlefieldDsbDuelRoleScore, 3)
  self.compScore3 = self.viewSkin:AddComponent(self, UIBattlefieldDsbDuelRoleScore, 4)
  self.compScore4 = self.viewSkin:AddComponent(self, UIBattlefieldDsbDuelRoleScore, 5)
  self.field_hospital = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.field_hospital_btn = self.viewSkin:AddComponent(self, UIButton, 7)
  self.field_hospital_btn:SetOnClick(function()
    self:OnField_hospital_btnClick()
  end)
  self.field_hospital_effect_obj = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.treatment_soldier_content = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.soldier_image = self.viewSkin:AddComponent(self, UIImage, 10)
  self.treatment_soldier_num_text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.compTips = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.textPreparation = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.compNoticeItem = self.viewSkin:AddComponent(self, UIBattlefieldDsbNoticeItem, 14)
  self.textTimeName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.compRoles = {
    self.compScore1,
    self.compScore2,
    self.compScore3,
    self.compScore4
  }
  self.textTimeName:SetLocalText("dsb_duel_tips_1030")
  self:RefreshRoles()
  self.field_hospital:SetSiblingIndex(2)
  self.field_hospital_effect_particleSystem = self.field_hospital_effect_obj.gameObject:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self.treatment_soldier_content:SetActive(false)
  self:RefreshTreatmentSoldierGreenEffect()
  self.compTips:SetActive(true)
  self:RefreshTime()
  self.compNoticeItem:CleanSeq()
end

function UIBattlefieldDsbDuelMainView:ComponentDestroy()
  self:StopTreatmentSoldierSequence()
  self.viewSkin = nil
  self.compFlatLayout = nil
  self.compScore1 = nil
  self.compScore2 = nil
  self.compScore3 = nil
  self.compScore4 = nil
  self.field_hospital = nil
  self.field_hospital_btn = nil
  self.field_hospital_effect_obj = nil
  self.treatment_soldier_content = nil
  self.soldier_image = nil
  self.treatment_soldier_num_text = nil
  self.compTips = nil
  self.textPreparation = nil
  self.compNoticeItem = nil
  self.textTimeName = nil
end

function UIBattlefieldDsbDuelMainView:DataDestroy()
end

function UIBattlefieldDsbDuelMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelBattlefieldScoreUpdate, self.OnDsbDuelBattlefieldScoreUpdate)
  self:AddUIListener(EventId.GetDesertBattleTreatmentSoldierNum, self.RefreshTreatmentSoldierCountShow)
end

function UIBattlefieldDsbDuelMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelBattlefieldScoreUpdate, self.OnDsbDuelBattlefieldScoreUpdate)
  self:RemoveUIListener(EventId.GetDesertBattleTreatmentSoldierNum, self.RefreshTreatmentSoldierCountShow)
  base.OnRemoveListener(self)
end

function UIBattlefieldDsbDuelMainView:OnField_hospital_btnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDesertBattleTreatmentSoldier)
end

function UIBattlefieldDsbDuelMainView:RefreshRoles()
  if not self.compRoles then
    return
  end
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if not battleInfo then
    for k, v in ipairs(self.compRoles) do
      v:SetActive(false)
    end
    return
  end
  for idx = BattlefieldDsbConst.RoleType.MIN, BattlefieldDsbConst.RoleType.MAX do
    local comp = self.compRoles[idx]
    local roleInfo = battleInfo:GetRoleByRank(idx)
    if not roleInfo then
      comp:SetActive(false)
    else
      comp:SetActive(true)
      comp:Setup(idx, roleInfo)
    end
  end
end

function UIBattlefieldDsbDuelMainView:OnDsbDuelBattlefieldScoreUpdate()
  self:RefreshRoles()
end

function UIBattlefieldDsbDuelMainView:RefreshTreatmentSoldierGreenEffect()
  local showGlowGreenCondition = DataCenter.DragonBuildTemplateManager:GetItemValue("k16")
  local treatmentFinishSoldierCount = DataCenter.BattlefieldDsbDuelManager:GetTreatmentFinishSoldierNum()
  if showGlowGreenCondition <= treatmentFinishSoldierCount then
    self.field_hospital_effect_particleSystem:Play()
    self.field_hospital_effect_obj:SetActive(true)
  else
    self.field_hospital_effect_particleSystem:Stop()
    self.field_hospital_effect_obj:SetActive(false)
  end
end

function UIBattlefieldDsbDuelMainView:RefreshTreatmentSoldierCountShow(addNum)
  self:StopTreatmentSoldierSequence()
  self:RefreshTreatmentSoldierGreenEffect()
  if 0 < addNum then
    self.treatment_soldier_content:SetActive(true)
    self.treatment_soldier_num_text:SetText("+" .. tostring(addNum))
    self.treatment_soldier_num_text:SetAlpha(1)
    self.treatment_soldier_num_text:SetLocalPositionXYZ(0, 15, 0)
    self.treatment_soldier_num_text:SetLocalScaleXYZ(1, 1, 1)
    self.soldier_image:SetAlpha(1)
    self.treatmentSoldierSequence = DOTween.Sequence()
    self.treatmentSoldierSequence:Append(self.treatment_soldier_num_text:DOFade(0, 1))
    self.treatmentSoldierSequence:Join(self.treatment_soldier_num_text.transform:DOLocalMoveY(50, 1))
    self.treatmentSoldierSequence:Join(self.treatment_soldier_num_text.transform:DOScale(Vector3.New(1.1, 1.1, 1.1), 1))
    self.treatmentSoldierSequence:Join(self.soldier_image:DOFade(0, 1.2))
    self.treatmentSoldierSequence:OnComplete(function()
      self.treatment_soldier_content:SetActive(false)
    end)
    self:OnHospitalUpdate()
  elseif addNum < 0 then
    self:OnHospitalUpdate()
  elseif self.treatment_soldier_content:GetActive() then
    self.treatment_soldier_content:SetActive(false)
  end
end

function UIBattlefieldDsbDuelMainView:StopTreatmentSoldierSequence()
  if self.treatmentSoldierSequence ~= nil then
    self.treatmentSoldierSequence:Kill()
    self.treatmentSoldierSequence = nil
  end
end

function UIBattlefieldDsbDuelMainView:RefreshTime()
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if not battleInfo or not self.compTips then
    return
  end
  if self.battleEnd then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local timeStart = battleInfo.timeStart or 0
  local timeEnd = battleInfo.timeEnd or 0
  local gap
  local showLabelName = false
  if curTime < timeStart then
    gap = timeStart - curTime
    showLabelName = true
  elseif curTime < timeEnd then
    gap = timeEnd - curTime
  else
    self.battleEnd = true
    self.compTips:SetActive(false)
    return
  end
  local timeFormated = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(gap * 1000)
  self.textTimeName:SetActive(showLabelName)
  self.textPreparation:SetText(timeFormated)
end

function UIBattlefieldDsbDuelMainView:Update1000MS()
  base.Update1000MS(self)
  self:RefreshTime()
end

function UIBattlefieldDsbDuelMainView:GetBfType()
  return BattleFieldType.DsbDuel
end

function UIBattlefieldDsbDuelMainView:DoBtnGo()
  if BattlefieldDsbDuelUtils.GetEnterBattleState() == BattlefieldDsbConst.EnterBattleState.LeaveBattle then
    UIUtil.ShowTipsId("458143")
    return
  end
  if not self:IsCurWatchIdx() then
    return
  end
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if battleInfo and battleInfo:IsObserver() then
    DataCenter.BattlefieldDsbDuelManager:TryEnterBattlefield(0)
  end
end

function UIBattlefieldDsbDuelMainView:IsCurWatchIdx()
  local myInfo = BattlefieldDsbDuelUtils.MyInfo
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if not myInfo or not battleInfo then
    return false
  end
  return myInfo.selfPlayerState ~= BattlefieldDsbConst.BF_DSB_PLAYER_STATE.None and myInfo.selfTeamId == battleInfo:GetTeam() and BattlefieldDsbDuelUtils.GetEnterBattleState() ~= BattlefieldDsbConst.EnterBattleState.LeaveBattle
end

function UIBattlefieldDsbDuelMainView:CheckEnterShow()
end

function UIBattlefieldDsbDuelMainView:OnObserveChange()
end

function UIBattlefieldDsbDuelMainView:OnHospitalUpdateEx()
end

function UIBattlefieldDsbDuelMainView:RefreshCameraPointEx()
end

function UIBattlefieldDsbDuelMainView:GetEndSec()
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  local timeEnd = battleInfo ~= nil and battleInfo.timeEnd or 0
  return timeEnd
end

return UIBattlefieldDsbDuelMainView
