local LWUIDesertBattleTreatmentSoldierView = BaseClass("LWUIDesertBattleTreatmentSoldierView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIDesertBattleSoldierInfoContainer = require("UI.UIActivityCenterTable.Component.DesertBattle.UILWTreatmentSoldier.Component.LWUIDesertBattleSoldierInfoContainer")
local panel_path = "panel"
local title_text_path = "PopUpTitle/TitleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local soldier_num_text_path = "PopUpTitle/SoldierNumText"
local soldier_info_btn_path = "PopUpTitle/SoldierInfoBtn"
local treatment_speed_tips_text_path = "PopUpTitle/TreatmentSpeedTipsText"
local treatment_speed_num_text_path = "PopUpTitle/TreatmentSpeedNumText"
local des_text_path = "PopUpTitle/DesText"
local receive_btn_path = "PopUpTitle/ReceiveBtn"
local receive_soldier_num_text_path = "PopUpTitle/ReceiveBtn/VerLayout/ReceiveBtnContent/ReceiveSoldierNumText"
local soldier_info_content_path = "PopUpTitle/SoldierInfoContent"
local collect_soldier_content_path = "PopUpTitle/CollectSoldierContent"
local collect_soldier_num_text_path = "PopUpTitle/CollectSoldierContent/CollectSoldierNumText"
local receive_btn_content_path = "PopUpTitle/ReceiveBtn/VerLayout/ReceiveBtnContent"

function LWUIDesertBattleTreatmentSoldierView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function LWUIDesertBattleTreatmentSoldierView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIDesertBattleTreatmentSoldierView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetDesertBattleHospitalViewData, self.RefreshView)
  self:AddUIListener(EventId.GetDesertBattleTreatmentSoldierNum, self.OnGetDesertBattleTreatmentSoldierNum)
end

function LWUIDesertBattleTreatmentSoldierView:OnRemoveListener()
  self:RemoveUIListener(EventId.GetDesertBattleHospitalViewData, self.RefreshView)
  self:RemoveUIListener(EventId.GetDesertBattleTreatmentSoldierNum, self.OnGetDesertBattleTreatmentSoldierNum)
  base.OnRemoveListener(self)
end

function LWUIDesertBattleTreatmentSoldierView:OnGetDesertBattleTreatmentSoldierNum(addNum)
  self:RefreshTreatmentSoldierView()
end

function LWUIDesertBattleTreatmentSoldierView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.title_text:SetLocalText("Desert_strom_tips1005")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.soldier_num_text = self:AddComponent(UIText, soldier_num_text_path)
  self.soldier_info_btn = self:AddComponent(UIButton, soldier_info_btn_path)
  self.soldier_info_btn:SetOnClick(function()
    self:SoldierInfoBtnClick()
  end)
  self.treatment_speed_tips_text = self:AddComponent(UIText, treatment_speed_tips_text_path)
  self.treatment_speed_tips_text:SetLocalText("Desert_strom_tips1006")
  self.treatment_speed_num_text = self:AddComponent(UIText, treatment_speed_num_text_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.receive_btn = self:AddComponent(UIButton, receive_btn_path)
  self.receive_btn:SetSafeClickMode(true)
  self.receive_btn:SetOnClick(function()
    self:ReceiveBtnClick()
  end)
  self.receive_soldier_num_text = self:AddComponent(UIText, receive_soldier_num_text_path)
  self.soldier_info_content = self:AddComponent(LWUIDesertBattleSoldierInfoContainer, soldier_info_content_path)
  self.soldier_info_content:SetActive(false)
  self.collect_soldier_content = self:AddComponent(UICanvasGroup, collect_soldier_content_path)
  self.collect_soldier_num_text = self:AddComponent(UIText, collect_soldier_num_text_path)
  self.collect_soldier_content:SetAlpha(0)
  self.receive_btn_content = self:AddComponent(UIBaseContainer, receive_btn_content_path)
end

function LWUIDesertBattleTreatmentSoldierView:ComponentDestroy()
  self.panel = nil
  self.title_text = nil
  self.close_btn = nil
  self.soldier_num_text = nil
  self.soldier_info_btn = nil
  self.treatment_speed_tips_text = nil
  self.treatment_speed_num_text = nil
  self.des_text = nil
  self.receive_btn = nil
  self.receive_soldier_num_text = nil
  self.soldier_info_content = nil
  self.collect_soldier_content = nil
  self.collect_soldier_num_text = nil
  self.receive_btn_content = nil
  self:StopTweenSequence()
end

function LWUIDesertBattleTreatmentSoldierView:GetMgr()
  return BattleFieldUtil.GetMgrActive()
end

function LWUIDesertBattleTreatmentSoldierView:ReInit()
  self:GetMgr():SendDragonHospitalViewMsg()
  self:RefreshView()
end

function LWUIDesertBattleTreatmentSoldierView:RefreshView()
  self:RefreshTreatmentSoldierView()
  self:RefreshTreatmentSpeed()
  local des = Localization:GetString("Desert_strom_tips1013")
  self.des_text:SetText(des)
end

function LWUIDesertBattleTreatmentSoldierView:RefreshTreatmentSoldierView()
  self.treatmentFinishSoldierNum = self:GetMgr():GetTreatmentFinishSoldierNum()
  self.accumulativeTreatmentSoldierNum = self:GetMgr():GetAccumulativeTreatmentSoldierNum()
  self.soldier_num_text:SetText(Localization:GetString("Desert_strom_tips1020") .. ": " .. self.accumulativeTreatmentSoldierNum)
  self.receive_soldier_num_text:SetText(tostring(self.treatmentFinishSoldierNum))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.receive_btn_content.rectTransform)
end

function LWUIDesertBattleTreatmentSoldierView:RefreshTreatmentSpeed()
  self.treatmentSpeed = self:GetMgr():GetTreatmentSpeed()
  local treatmentSpeedMinute = math.floor(self.treatmentSpeed * 60)
  local speedStr = Localization:GetString("Desert_strom_tips1014", tostring(treatmentSpeedMinute))
  self.treatment_speed_num_text:SetText(speedStr)
end

function LWUIDesertBattleTreatmentSoldierView:SoldierInfoBtnClick()
  self.soldier_info_content:SetActive(true)
  self.soldier_info_content:ReInit()
end

function LWUIDesertBattleTreatmentSoldierView:ReceiveBtnClick()
  if self.treatmentFinishSoldierNum > 0 then
    self:GetMgr():SendDragonHospitalFinishMsg()
    self:StopTweenSequence()
    self.ctrl:CloseSelf()
    SFSNetwork.SendMessage(MsgDefines.DragonHospitalInfo)
  else
    UIUtil.ShowTipsId("Desert_strom_tips1019")
  end
end

function LWUIDesertBattleTreatmentSoldierView:StopTweenSequence()
  if self.tweenSeq ~= nil then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
end

return LWUIDesertBattleTreatmentSoldierView
