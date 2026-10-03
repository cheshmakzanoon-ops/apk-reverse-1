local base = UIBaseContainer
local UICRefreshBallSkillTipItem = BaseClass("UICRefreshBallSkillTipItem", base)
local txt_title_path = "title/txt_title"
local txt_cd_path = "ItemSkill/txt_cd"
local img_icon_path = "ItemSkill/img_kuang/img_icon"
local txt_name_path = "ItemSkill/txt_name"

function UICRefreshBallSkillTipItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICRefreshBallSkillTipItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICRefreshBallSkillTipItem:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_cd = self:AddComponent(UIText, txt_cd_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.txt_name = self:AddComponent(UIText, txt_name_path)
end

function UICRefreshBallSkillTipItem:ComponentDestroy()
  self.txt_title = nil
  self.txt_cd = nil
  self.img_icon = nil
  self.txt_name = nil
end

function UICRefreshBallSkillTipItem:ReInit(data, txtDesc)
  self.data = data
  local skillName = CS.GameEntry.Localization:GetString(self.data.scoreConfig.skill_name)
  txtDesc:SetLocalText("season_s6_government_skill_desc17", skillName)
  self.txt_title:SetLocalText("season_s6_government_skill_desc18")
  local extra = data.logic.extra
  self.img_icon:LoadSpriteAsync(extra.config.skill_icon)
  self.txt_name:SetLocalText(extra.config.name)
  self:RefreshTime()
end

function UICRefreshBallSkillTipItem:Update1000MS()
  self:RefreshTime()
end

function UICRefreshBallSkillTipItem:RefreshTime()
  if not self.data then
    return
  end
  local extra = self.data.logic.extra
  local cd = extra:GetCD()
  self.txt_cd:SetActive(0 < cd)
  local cdStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(cd)
  self.txt_cd:SetLocalText("season_s6_government_skill_desc43", cdStr)
end

return UICRefreshBallSkillTipItem
