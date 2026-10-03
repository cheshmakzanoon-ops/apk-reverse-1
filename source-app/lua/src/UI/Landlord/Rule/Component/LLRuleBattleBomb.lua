local base = UIAsyncContainer
local LLRuleBattleBomb = BaseClass("LLRuleBattleBomb", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr

function LLRuleBattleBomb:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRuleBattleBomb:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRuleBattleBomb:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.textUp = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDefRate = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textDefDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textAtkRate = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textAtkDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compAtkYou = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compDef = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compAtk = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.btnUp = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnUp:SetOnClick(function()
    self:OnBtnUpClick()
  end)
  self.compDefYou = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.btnDef = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnDef:SetOnClick(function()
    self:OnBtnDefClick()
  end)
  self.btnAtk = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnAtk:SetOnClick(function()
    self:OnBtnAtkClick()
  end)
end

function LLRuleBattleBomb:ComponentDestroy()
  self.viewSkin = nil
  self.compContent = nil
  self.textUp = nil
  self.textDefRate = nil
  self.textDefDesc = nil
  self.textAtkRate = nil
  self.textAtkDesc = nil
  self.compAtkYou = nil
  self.compDef = nil
  self.compAtk = nil
  self.btnUp = nil
  self.compDefYou = nil
  self.btnDef = nil
  self.btnAtk = nil
end

function LLRuleBattleBomb:DataDefine()
end

function LLRuleBattleBomb:DataDestroy()
end

function LLRuleBattleBomb:OnAddListener()
  base.OnAddListener(self)
end

function LLRuleBattleBomb:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLRuleBattleBomb:OnBtnUpClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLBuff, {anim = true}, LLConst.LandLordGroup.FARMER)
end

function LLRuleBattleBomb:OnBtnDefClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:ShowSpeedDetail(self.btnDef)
end

function LLRuleBattleBomb:OnBtnAtkClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:ShowSpeedDetail(self.btnAtk)
end

function LLRuleBattleBomb:ShowSpeedDetail(btn)
  local x, y, z = btn:GetLocalPositionXYZ(true)
  local worldPos = btn.transform.parent:TransformPoint(x, y, z)
  EventManager:GetInstance():Broadcast(EventId.LandlordShowCityDetailSpeed, {
    x = worldPos.x,
    y = worldPos.y,
    z = worldPos.z
  })
end

function LLRuleBattleBomb:UpdateData()
  local curCamp = math.max(ActMgr:GetMyGroup(), 1)
  local stageFlag = ActMgr:GetActCurStage() >= LLConst.LandlordStage.PREPARE
  self.compDefYou:SetActive(stageFlag and curCamp == LLConst.LandLordGroup.LORD)
  self.compAtkYou:SetActive(stageFlag and curCamp == LLConst.LandLordGroup.FARMER)
  local list = ActMgr:GetSpeedCalculateList() or {}
  local info = list[1]
  local speed = info ~= nil and info[2] or 0
  self.textDefDesc:SetLocalText("zonewar_landlord_limit_1009")
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.textDefDesc.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compDef.transform)
  self.textDefRate:SetText(string.format("%s: +%s/s", Localization:GetString("zonewar_landlord_limit_1053"), speed))
  self.textAtkDesc:SetLocalText("zonewar_landlord_limit_1008")
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.textAtkDesc.transform)
  self.textAtkRate:SetText(string.format("%s: +%s/s", Localization:GetString("zonewar_landlord_limit_1054"), speed))
  self.textUp:SetLocalText("zonewar_landlord_limit_1011")
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.textUp.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compAtk.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
end

return LLRuleBattleBomb
