local base = UIBaseView
local UIAllianceCommonSkillUseTipView = BaseClass("UIAllianceCommonSkillUseTipView", base)
local txt_desc_path = "UICommonPopUpPanel_NoToggle/Content/MainRoot/txt_desc"
local go_skill_info_path = "UICommonPopUpPanel_NoToggle/Content/MainRoot/skill_info"
local btn_icon_path = "UICommonPopUpPanel_NoToggle/Content/MainRoot/cost/btn_icon"
local img_energy_path = "UICommonPopUpPanel_NoToggle/Content/MainRoot/cost/btn_icon/img_energy"
local btn_cancel_path = "UICommonPopUpPanel_NoToggle/Content/MainRoot/Buttom/btn_cancel"
local btn_sure_path = "UICommonPopUpPanel_NoToggle/Content/MainRoot/Buttom/btn_sure"
local sli_Slider_Cost_path = "UICommonPopUpPanel_NoToggle/Content/MainRoot/cost/Slider_Cost"
local sli_Slider_Current_path = "UICommonPopUpPanel_NoToggle/Content/MainRoot/cost/Slider_Current"
local btn_Mask_path = "UICommonPopUpPanel_NoToggle/Mask"
local btn_CloseBtn_path = "UICommonPopUpPanel_NoToggle/Content/UICommonPopUpTop/CloseBtn"
local txt_slider_path = "UICommonPopUpPanel_NoToggle/Content/MainRoot/cost/txt_slider"
local txt_cost_path = "UICommonPopUpPanel_NoToggle/Content/MainRoot/cost/txt_cost"
local go_MainRoot_path = "UICommonPopUpPanel_NoToggle/Content/MainRoot"
local go_cost_path = "UICommonPopUpPanel_NoToggle/Content/MainRoot/cost"
local go_Buttom_path = "UICommonPopUpPanel_NoToggle/Content/MainRoot/Buttom"

function UIAllianceCommonSkillUseTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.data = nil
  self.logic = nil
  self.logic, self.data = self:GetUserData()
  self:RefreshView()
end

function UIAllianceCommonSkillUseTipView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceCommonSkillUseTipView:ComponentDefine()
  self.txt_desc = self:AddComponent(UIText, txt_desc_path)
  self.go_skill_info = self:AddComponent(UIBaseContainer, go_skill_info_path)
  self.btn_icon = self:AddComponent(UIButton, btn_icon_path)
  self.img_energy = self:AddComponent(UIImage, img_energy_path)
  self.btn_cancel = self:AddComponent(UIButton, btn_cancel_path)
  self.btn_sure = self:AddComponent(UIButton, btn_sure_path)
  self.sli_Slider_Cost = self:AddComponent(UISlider, sli_Slider_Cost_path)
  self.sli_Slider_Current = self:AddComponent(UISlider, sli_Slider_Current_path)
  self.btn_Mask = self:AddComponent(UIButton, btn_Mask_path)
  self.btn_CloseBtn = self:AddComponent(UIButton, btn_CloseBtn_path)
  self.txt_slider = self:AddComponent(UIText, txt_slider_path)
  self.txt_cost = self:AddComponent(UIText, txt_cost_path)
  self.go_MainRoot = self:AddComponent(UIBaseContainer, go_MainRoot_path)
  self.go_cost = self:AddComponent(UIBaseContainer, go_cost_path)
  self.go_Buttom = self:AddComponent(UIBaseContainer, go_Buttom_path)
  self.btn_Mask:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.btn_CloseBtn:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.btn_cancel:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.btn_sure:SetOnClick(BindCallback(self, self.ClickSure))
end

function UIAllianceCommonSkillUseTipView:ComponentDestroy()
  self.txt_desc = nil
  self.go_skill_info = nil
  self.btn_icon = nil
  self.img_energy = nil
  self.btn_cancel = nil
  self.btn_sure = nil
  self.sli_Slider_Cost = nil
  self.sli_Slider_Current = nil
  self.btn_Mask = nil
  self.btn_CloseBtn = nil
  self.txt_slider = nil
  self.txt_cost = nil
  self.go_MainRoot = nil
  self.go_cost = nil
  self.go_Buttom = nil
end

function UIAllianceCommonSkillUseTipView:ClickSure()
  if self.data.config.skill_flag == AlOfficialSkillType.RefreshBall then
    local extra = self.data.logic.extra
    local cd = extra:GetCD()
    if cd <= 0 then
      UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("season_server_camp_tip001"), 1, GameDialogDefine.CONFIRM)
      return
    end
  end
  if self.logic ~= nil then
    self.logic:SendMessage()
  end
  self.ctrl:CloseSelf()
end

function UIAllianceCommonSkillUseTipView:RefreshView()
  self:RefreshSlider()
  self:RefreshSkill()
end

function UIAllianceCommonSkillUseTipView:RefreshSlider()
  local energy = DataCenter.AllianceGovernmentCommonSkillManager:GetEnergyInfo()
  local maxEnergy = energy:GetMaxEnergy()
  self.sli_Slider_Current:SetValue(energy.currentEnergy / maxEnergy)
  self.sli_Slider_Cost:SetValue((energy.currentEnergy - self.data.config.consume_energy) / maxEnergy)
  self.img_energy:LoadSprite(energy:GetCostIcon())
  self.txt_slider:SetText(energy.currentEnergy .. "/" .. maxEnergy)
  self.txt_cost:SetLocalText("season_s6_government_skill_desc16", energy.currentEnergy, self.data.config.consume_energy)
end

function UIAllianceCommonSkillUseTipView:RefreshSkill()
  local skillExtraInfo = self.logic:GetUseTipInfo()
  self:GameObjectInstantiateAsync(skillExtraInfo.prefab, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.go_skill_info.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_pivot(0.5, 0.5)
    local name = skillExtraInfo.classPath.__cname
    go.name = name
    local logic = self.go_skill_info:AddComponent(skillExtraInfo.classPath, name)
    logic:SetActive(true)
    logic:ReInit(self.data, self.txt_desc)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.go_cost.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.go_skill_info.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.go_MainRoot.rectTransform)
  end)
end

return UIAllianceCommonSkillUseTipView
