local UILWTrainPrepareReplacePanelView = BaseClass("UILWTrainPrepareReplacePanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWTrainReplaceCarriageComponent = require("UI.UILWRailway.UITrainPrepareReplace.Component.UILWTrainReplaceCarriageComponent")
local PanelAnim = {
  NormalMoveIn = "UlTrainPrepareReplacePanel_in",
  Constrat = "UlTrainPrepareReplacePanel_constrat",
  FirstSaveMoveIn = "UlTrainPrepareReplacePanel_save_in",
  FirstSave = "UlTrainPrepareReplacePanel_save",
  Save = "UlTrainPrepareReplacePanel_replace_right",
  SaveConfirm = "UlTrainPrepareReplacePanel_confirm_right",
  Replace = "UlTrainPrepareReplacePanel_replace_left",
  ReplaceConfirm = "UlTrainPrepareReplacePanel_confirm_left",
  NormalMoveOut = "UlTrainPrepareReplacePanel_out"
}

function UILWTrainPrepareReplacePanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWTrainPrepareReplacePanelView:OnDestroy()
  self:ClearInAnimTimer()
  self:ClearOutAnimTimer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTrainPrepareReplacePanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.compLeftNoGoodsGroup = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compContrastGroup = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.btnReplace = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnReplace:SetOnClick(function()
    self:OnBtnReplaceClick()
  end)
  self.btnSave = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnSave:SetOnClick(function()
    self:OnBtnSaveClick()
  end)
  self.compSameGroup = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.btnSure = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnSure:SetOnClick(function()
    self:OnBtnSureClick()
  end)
  self.compConfirmGroup = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.btnCancel = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnCancel:SetOnClick(function()
    self:OnBtnCancelClick()
  end)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.compLeftGoodsGroup = self.viewSkin:AddComponent(self, UILWTrainReplaceCarriageComponent, 11)
  self.compRightGoodsGroup = self.viewSkin:AddComponent(self, UILWTrainReplaceCarriageComponent, 12)
  self.animatorUITrainPrepareReplacePanel = self.viewSkin:AddComponent(self, UIAnimator, 13)
  self.textTap = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textConfirmTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.compConfirmGroupBG = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.compConfirmButtonGroup = self.viewSkin:AddComponent(self, UIBaseContainer, 17)
end

function UILWTrainPrepareReplacePanelView:ComponentDestroy()
  self.viewSkin = nil
  self.btnMask = nil
  self.compLeftNoGoodsGroup = nil
  self.compContrastGroup = nil
  self.btnReplace = nil
  self.btnSave = nil
  self.compSameGroup = nil
  self.btnSure = nil
  self.compConfirmGroup = nil
  self.btnCancel = nil
  self.btnConfirm = nil
  self.compLeftGoodsGroup = nil
  self.compRightGoodsGroup = nil
  self.animatorUITrainPrepareReplacePanel = nil
  self.textTap = nil
  self.textConfirmTip = nil
  self.compConfirmGroupBG = nil
  self.compConfirmButtonGroup = nil
end

function UILWTrainPrepareReplacePanelView:DataDefine()
  self.isReplace = false
  self.playingOutAnim = false
end

function UILWTrainPrepareReplacePanelView:DataDestroy()
  self.trainData = nil
  self.hasSaveHighGoods = nil
  self.isReplace = nil
  self.playingOutAnim = nil
end

function UILWTrainPrepareReplacePanelView:OnAddListener()
  base.OnAddListener(self)
end

function UILWTrainPrepareReplacePanelView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWTrainPrepareReplacePanelView:ReInit()
  self.trainData = self:GetUserData()
  if self.trainData == nil then
    Logger.LogInfo("UILWTrainPrepareReplacePanelView trainData is nil")
    self.ctrl:CloseSelf()
    return
  end
  self.hasSaveHighGoods = self.trainData:GetTrainHasSaveHighGoods()
  self.compLeftNoGoodsGroup:SetActive(not self.hasSaveHighGoods)
  self.compLeftGoodsGroup:SetActive(self.hasSaveHighGoods)
  self.compSameGroup:SetActive(self.trainData.saveMark)
  self.compContrastGroup:SetActive(not self.trainData.saveMark)
  self.compConfirmGroup:SetActive(false)
  if self.hasSaveHighGoods then
    self:PlayPanelInAnim(PanelAnim.NormalMoveIn)
    self.compLeftGoodsGroup:ShowView(true)
  else
    self.animatorUITrainPrepareReplacePanel:Play(PanelAnim.FirstSaveMoveIn)
  end
  self.compRightGoodsGroup:ShowView(false)
  if not self.trainData.saveMark then
    CS.UIGray.SetGray(self.btnReplace.transform, not self.hasSaveHighGoods, true)
  end
end

function UILWTrainPrepareReplacePanelView:ShowSecondConfirmView(playAniName, confirmLanguageKey)
  self.compConfirmGroup:SetActive(true)
  self.compContrastGroup:SetActive(false)
  self.textTap:SetActive(false)
  self.animatorUITrainPrepareReplacePanel:Play(playAniName)
  self.textConfirmTip:SetLocalText(confirmLanguageKey)
  if self.isReplace then
    self.compConfirmGroupBG:SetAnchoredPositionXY(-200, -7, true)
    self.compConfirmButtonGroup:SetAnchoredPositionXY(-200, -134, true)
  else
    self.compConfirmGroupBG:SetAnchoredPositionXY(200, -7, true)
    self.compConfirmButtonGroup:SetAnchoredPositionXY(200, -134, true)
  end
end

function UILWTrainPrepareReplacePanelView:OnBtnMaskClick()
  if self.playingOutAnim then
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
  else
    self:PlayPanelOutAnim(PanelAnim.NormalMoveOut)
  end
end

function UILWTrainPrepareReplacePanelView:OnBtnReplaceClick()
  if not self.hasSaveHighGoods then
    UIUtil.ShowTipsId("alliance_train_golden_record_tips_limit_15")
    return
  end
  self.isReplace = true
  self:ShowSecondConfirmView(PanelAnim.ReplaceConfirm, "alliance_train_golden_change_check_limit")
end

function UILWTrainPrepareReplacePanelView:OnBtnSaveClick()
  if self.playingOutAnim then
    return
  end
  self.isReplace = false
  if not self.hasSaveHighGoods then
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainRewardSave, 1)
    self:PlayPanelOutAnim(PanelAnim.FirstSave)
  else
    self:ShowSecondConfirmView(PanelAnim.SaveConfirm, "alliance_train_golden_save_check_limit")
  end
end

function UILWTrainPrepareReplacePanelView:OnBtnSureClick()
  self:PlayPanelOutAnim(PanelAnim.NormalMoveOut)
end

function UILWTrainPrepareReplacePanelView:OnBtnCancelClick()
  if self.playingOutAnim then
    return
  end
  self.compContrastGroup:SetActive(true)
  self.compConfirmGroup:SetActive(false)
  self.textTap:SetActive(true)
  self.animatorUITrainPrepareReplacePanel:Play(PanelAnim.Constrat)
end

function UILWTrainPrepareReplacePanelView:OnBtnConfirmClick()
  if self.playingOutAnim then
    return
  end
  if self.isReplace then
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainRewardReplace, 1)
    self:PlayPanelOutAnim(PanelAnim.Replace)
  else
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainRewardSave, 1)
    self:PlayPanelOutAnim(PanelAnim.Save)
  end
end

function UILWTrainPrepareReplacePanelView:PlayPanelOutAnim(aniName)
  if self.playingOutAnim then
    return
  end
  self.playingOutAnim = true
  local result, outTime = self.animatorUITrainPrepareReplacePanel:PlayAnimationReturnTime(aniName)
  if result then
    self.outAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.outAnimTimer = nil
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
    end, outTime)
  elseif self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UILWTrainPrepareReplacePanelView:ClearOutAnimTimer()
  if self.outAnimTimer then
    self.outAnimTimer:Stop()
    self.outAnimTimer = nil
  end
end

function UILWTrainPrepareReplacePanelView:PlayPanelInAnim(aniName)
  local result, outTime = self.animatorUITrainPrepareReplacePanel:PlayAnimationReturnTime(aniName)
  if result then
    self.inAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.inAnimTimer = nil
      if not self.trainData.saveMark then
        self.animatorUITrainPrepareReplacePanel:Play(PanelAnim.Constrat)
      end
    end, outTime)
  end
end

function UILWTrainPrepareReplacePanelView:ClearInAnimTimer()
  if self.inAnimTimer then
    self.inAnimTimer:Stop()
    self.inAnimTimer = nil
  end
end

return UILWTrainPrepareReplacePanelView
