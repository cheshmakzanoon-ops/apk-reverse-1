local base = UIBaseContainer
local UIEBH_Super = BaseClass("UIEBH_Super", base)
local desc_text_path = "DescText"
local cd_text_path = "CdText"
local btn_path = "Btn"
local btn_text_path = "Btn/Text"

function UIEBH_Super:OnCreate()
  base.OnCreate(self)
  self.endTime = 0
  self.cdTime = LuaEntry.DataConfig:TryGetNum("YiBianJinQu_battle", "k8", 0)
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.cd_text = self:AddComponent(UITextMeshProUGUIEx, cd_text_path)
  self.cd_text:SetLocalText("YiBianJinQu_heal_tips_4")
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnClickBtn))
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, btn_text_path)
end

function UIEBH_Super:OnDestroy()
  self.desc_text = nil
  self.cd_text = nil
  self.btn = nil
  self.endTime = 0
  base.OnDestroy(self)
end

function UIEBH_Super:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicBattleCureUpdate, self.UpdateData)
end

function UIEBH_Super:OnRemoveListener()
  self:RemoveUIListener(EventId.EpidemicBattleCureUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIEBH_Super:UpdateData()
  self:CheckCDing()
  local info = BattleFieldUtil.GetSoldiersInfo() or {}
  local num = 0
  if info ~= nil then
    num = (info.heal or 0) + (info.dead or 0)
  end
  self.desc_text:SetLocalText("YiBianJinQu_heal_tips_3", num)
  local bGray = 0 < self.endTime
  self.btn_text:SetLocalText(bGray and "YiBianJinQu_trivial_tips_33" or "YiBianJinQu_skill_detail_button_1")
  CS.UIGray.SetGray(self.btn.transform, bGray, not bGray)
end

function UIEBH_Super:CheckCDing()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  self.endTime = DataCenter.ActEpidemicZoneManager:GeCureCDEndTime()
  if self.endTime > 0 and curTime < self.endTime then
    return true
  end
  return false
end

function UIEBH_Super:OnClickBtn()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self:CheckCDing() then
    UIUtil.ShowTipsId("100381")
    return
  end
  local info = BattleFieldUtil.GetSoldiersInfo()
  if info.heal == 0 and info.dead == 0 then
    UIUtil.ShowTipsId("135230")
    return
  end
  DataCenter.ActEpidemicZoneManager:ReqBattleCureSolider()
end

return UIEBH_Super
