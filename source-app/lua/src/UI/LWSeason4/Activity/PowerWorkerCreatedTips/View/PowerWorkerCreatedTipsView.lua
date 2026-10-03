local PowerWorkerCreatedTipsView = BaseClass("PowerWorkerCreatedTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local close_path = "Close"
local name_path = "rewardPage/GameObject/name"
local desc_path = "rewardPage/GameObject/desc"
local claim_btn_path = "rewardPage/GameObject/ClaimBtn"

function PowerWorkerCreatedTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
end

function PowerWorkerCreatedTipsView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PowerWorkerCreatedTipsView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.claim_btn = self:AddComponent(UIButton, claim_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.claim_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function PowerWorkerCreatedTipsView:ComponentDestroy()
  self.close = nil
  self.desc = nil
  self.claim_btn = nil
end

function PowerWorkerCreatedTipsView:UpdateData()
  self.name:SetText(Localization:GetString("season_s4_building_ui_info33") .. " \195\151 1")
  self.desc:SetLocalText("season_s4_building_ui_info34")
end

return PowerWorkerCreatedTipsView
