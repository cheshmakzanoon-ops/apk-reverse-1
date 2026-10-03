local base = UIBaseContainer
local UIAllianceCommonSkillSelectItem = BaseClass("UIAllianceCommonSkillSelectItem", base)
local img_icon_path = "img_kuang/img_icon"
local txt_name_path = "txt_name"
local txt_cost_path = "txt_cost"
local txt_cd_path = "txt_cd"
local btn_CommonButton_path = "CommonButton"

function UIAllianceCommonSkillSelectItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIAllianceCommonSkillSelectItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceCommonSkillSelectItem:ComponentDefine()
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.txt_name = self:AddComponent(UIText, txt_name_path)
  self.txt_cost = self:AddComponent(UIText, txt_cost_path)
  self.txt_cd = self:AddComponent(UIText, txt_cd_path)
  self.btn_CommonButton = self:AddComponent(UIButton, btn_CommonButton_path)
  self.btn_CommonButton:SetOnClick(BindCallback(self, self.ClickUse))
end

function UIAllianceCommonSkillSelectItem:ComponentDestroy()
  self.img_icon = nil
  self.txt_name = nil
  self.txt_cost = nil
  self.txt_cd = nil
  self.btn_CommonButton = nil
end

function UIAllianceCommonSkillSelectItem:ClickUse()
  local data = self.holder.view.data
  local cd = self.data:GetCD()
  if cd <= 0 then
    UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("season_server_camp_tip001"), 1, GameDialogDefine.CONFIRM)
    return
  end
  if data and data.logic then
    data.logic:BindExtra(self.data)
    data:UseSkill()
  end
  self.holder.view.ctrl:CloseSelf()
end

function UIAllianceCommonSkillSelectItem:ReInit(data)
  self.data = data
  local config = data.config
  self.img_icon:LoadSpriteAsync(config.skill_icon)
  self.txt_name:SetLocalText(config.name)
  self.txt_cost:SetLocalText("season_s6_government_skill_desc42", config.consume_energy)
  self:RefreshTime()
end

function UIAllianceCommonSkillSelectItem:RefreshTime()
  if not self.data then
    return
  end
  local cd = self.data:GetCD()
  self.txt_cd:SetActive(0 < cd)
  local cdStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(cd)
  self.txt_cd:SetLocalText("season_s6_government_skill_desc43", cdStr)
end

function UIAllianceCommonSkillSelectItem:Update1000MS()
  self:RefreshTime()
end

return UIAllianceCommonSkillSelectItem
