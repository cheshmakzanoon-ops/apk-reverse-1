local base = UIAsyncContainer
local LLRuleBattleRate = BaseClass("LLRuleBattleRate", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr

function LLRuleBattleRate:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRuleBattleRate:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRuleBattleRate:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.btnDef = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnDef:SetOnClick(function()
    self:OnBtnDefClick()
  end)
  self.compDefYou = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compAtkYou = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compDef = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compAtk = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.btnAtk = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnAtk:SetOnClick(function()
    self:OnBtnAtkClick()
  end)
  self.btnDef2 = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnDef2:SetOnClick(function()
    self:OnBtnDef2Click()
  end)
  self.btnAtk2 = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnAtk2:SetOnClick(function()
    self:OnBtnAtk2Click()
  end)
end

function LLRuleBattleRate:ComponentDestroy()
  self.viewSkin = nil
  self.compContent = nil
  self.btnDef = nil
  self.compDefYou = nil
  self.compAtkYou = nil
  self.compDef = nil
  self.compAtk = nil
  self.btnAtk = nil
  self.btnDef2 = nil
  self.btnAtk2 = nil
end

function LLRuleBattleRate:DataDefine()
end

function LLRuleBattleRate:DataDestroy()
end

function LLRuleBattleRate:OnAddListener()
  base.OnAddListener(self)
end

function LLRuleBattleRate:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLRuleBattleRate:OnBtnDefClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLBuff, {anim = true}, LLConst.LandLordGroup.LORD)
end

function LLRuleBattleRate:OnBtnDef2Click()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLReward, {anim = true}, {
    camp = LLConst.LandLordGroup.LORD,
    tab = LLConst.RewardTabType.WL
  })
end

function LLRuleBattleRate:OnBtnAtkClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLBuff, {anim = true}, LLConst.LandLordGroup.FARMER)
end

function LLRuleBattleRate:OnBtnAtk2Click()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLReward, {anim = true}, {
    camp = LLConst.LandLordGroup.FARMER,
    tab = LLConst.RewardTabType.WL
  })
end

function LLRuleBattleRate:OnBtnRewardClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLBuff, {anim = true}, LLConst.LandLordGroup.FARMER)
end

function LLRuleBattleRate:UpdateData()
  local curCamp = math.max(ActMgr:GetMyGroup(), 1)
  local stageFlag = ActMgr:GetActCurStage() >= LLConst.LandlordStage.PREPARE
  self.compDefYou:SetActive(stageFlag and curCamp == LLConst.LandLordGroup.LORD)
  self.compAtkYou:SetActive(stageFlag and curCamp == LLConst.LandLordGroup.FARMER)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compDef.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compAtk.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
end

return LLRuleBattleRate
