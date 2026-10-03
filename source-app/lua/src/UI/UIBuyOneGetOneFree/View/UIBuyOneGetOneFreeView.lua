local UIBuyOneGetOneFreeView = BaseClass("UIBuyOneGetOneFreeView", UIBaseView)
local base = UIBaseView
local LWUIMasterySkillCell = require("UI.LWUIMastery.Component.LWUIMasterySkillCell")
local title_path = "UICommonRewardPopUp/Panel/Title"
local desc_path = "UICommonRewardPopUp/Panel/Desc"
local small_skill_path = "UICommonRewardPopUp/Panel/Title/SmallSkill"
local big_skill_path = "UICommonRewardPopUp/Panel/BigSkill"

function UIBuyOneGetOneFreeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Init()
end

function UIBuyOneGetOneFreeView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBuyOneGetOneFreeView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, "UICommonRewardPopUp/Panel")
  self.closeBtn:SetOnClick(function()
    self.anim:Play("V_ui_jiesuan_title_fade_anim", 0, 0)
    TimerManager:GetInstance():DelayInvoke(function()
      self.ctrl:CloseSelf()
    end, 0.2)
  end)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.title:SetLocalText("season_mastery_s3_name_2_11")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.small_skill = self:AddComponent(LWUIMasterySkillCell, small_skill_path)
  self.big_skill = self:AddComponent(LWUIMasterySkillCell, big_skill_path)
  self.anim = self:AddComponent(UIAnimator, "UICommonRewardPopUp")
end

function UIBuyOneGetOneFreeView:ComponentDestroy()
  self.title = nil
  self.desc = nil
  self.small_skill = nil
  self.big_skill = nil
  self.anim = nil
end

function UIBuyOneGetOneFreeView:Init()
  local skillId = self:GetUserData()
  if not skillId then
    return
  end
  local smallSkillTemplate = DataCenter.MasteryManager:GetSkillTemplateByType(MasterySkill.BuyOneGetOneFree)
  if not smallSkillTemplate then
    return
  end
  local bigSkillTemplate = DataCenter.MasteryManager:GetSkillTemplate(skillId)
  local bigSkillName = string.format("<b><size=44><color=#ffb644>%s</color></size></b>", CS.GameEntry.Localization:GetString(bigSkillTemplate.name))
  self.desc:SetLocalText("season_mastery_s3_tips_10", bigSkillName)
  self.small_skill:SetData(nil, smallSkillTemplate.id)
  self.big_skill:SetData(nil, skillId)
  self.anim:Play("V_ui_UICommonRewardPopUp_in", 0, 0)
end

return UIBuyOneGetOneFreeView
