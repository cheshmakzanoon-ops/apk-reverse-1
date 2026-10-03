local base = UIBaseContainer
local UIAllianceCommonSkillRecordItem = BaseClass("UIAllianceCommonSkillRecordItem", base)
local btn_UIPlayerHead_path = "UIPlayerHead"
local txt_name_path = "txt_name"
local txt_desc_path = "txt_desc"
local txt_time_path = "txt_time"
local img_level_path = "img_level"
local txt_level_path = "txt_level"

function UIAllianceCommonSkillRecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIAllianceCommonSkillRecordItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceCommonSkillRecordItem:ComponentDefine()
  self.txt_name = self:AddComponent(UIText, txt_name_path)
  self.txt_desc = self:AddComponent(UIText, txt_desc_path)
  self.txt_time = self:AddComponent(UIText, txt_time_path)
  self.img_level = self:AddComponent(UIImage, img_level_path)
  self.txt_level = self:AddComponent(UIText, txt_level_path)
  self.btn_UIPlayerHead = self:AddComponent(UICommonHead, btn_UIPlayerHead_path)
end

function UIAllianceCommonSkillRecordItem:ComponentDestroy()
  self.btn_UIPlayerHead = nil
  self.txt_name = nil
  self.txt_desc = nil
  self.txt_time = nil
  self.img_level = nil
  self.txt_level = nil
end

function UIAllianceCommonSkillRecordItem:ReInit(data)
  self.txt_name:SetText(data.user.name)
  self.txt_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServerMDHM(data.eventTime or 0))
  local user = data.user
  if user then
    local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(user.headSkinId, user.headSkinET, false)
    self.btn_UIPlayerHead:SetActive(true)
    self.btn_UIPlayerHead:SetHead(user.uid, user.headPic, user.headPicVer, nil, headFrame)
  end
  local sillLogic = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillBySkillFlag(data.skillType)
  local skillScoreDesc = sillLogic.scoreConfig.get_score_desc
  if skillScoreDesc then
    if data.skillType == AlOfficialSkillType.RefreshBall then
      self.txt_desc:SetLocalText(skillScoreDesc, CS.GameEntry.Localization:GetString(sillLogic.scoreConfig.skill_name), data.merit, data.effectValue .. "s")
    else
      self.txt_desc:SetLocalText(skillScoreDesc, data.effectValue, data.merit)
    end
  end
  self.txt_level:SetText(data.rating)
end

return UIAllianceCommonSkillRecordItem
