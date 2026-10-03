local VotePlayerItem = BaseClass("VotePlayerItem", UIBaseContainer)
local base = UIBaseContainer
local MALE_ICON_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nan.png"
local FEMALE_ICON_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nv.png"
local Localization = CS.GameEntry.Localization

function VotePlayerItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function VotePlayerItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function VotePlayerItem:ComponentDefine()
  self.playerHead = self:AddComponent(UICommonHead, "panel/UIPlayerHead")
  self.levelText = self:AddComponent(UIText, "panel/text_level")
  self.genderIcon = self:AddComponent(UIImage, "panel/GenderIcon")
  self.nameText = self:AddComponent(UIText, "panel/text_name")
  self.powerText = self:AddComponent(UIText, "panel/textPower")
  self.rankIcon = self:AddComponent(UIImage, "panel/jobIcon")
end

function VotePlayerItem:ComponentDestroy()
  self.playerHead = nil
  self.levelText = nil
  self.genderIcon = nil
  self.nameText = nil
  self.powerText = nil
  self.jobIcon = nil
end

function VotePlayerItem:DataDefine()
end

function VotePlayerItem:DataDestroy()
end

function VotePlayerItem:ReInit(param)
  self.param = param
  if param.uid and not param.pic and not param.picVer then
    param = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(param.uid)
    self.levelText:SetText(string.format("LV.%s", param.mainCityLv))
  else
    self.levelText:SetText(string.format("LV.%s", param.level))
  end
  self.playerHead:SetHeadAndFrame(param.uid, param.pic, param.picVer, false, param.headSkinId, param.headSkinET)
  local memberData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(param.uid)
  if memberData and memberData.rank then
    self.rankIcon:SetActive(true)
    self.rankIcon:LoadSprite(LWAlMemberRankParam[memberData.rank].Icon)
  else
    self.rankIcon:SetActive(false)
  end
  self.nameText:SetText(param.name)
  self.powerText:SetText(Localization:GetString(100253) .. param.power)
  self.genderIcon:SetActive(true)
  if self.param.gender == 1 then
    self.genderIcon:LoadSprite(MALE_ICON_PATH)
  elseif self.param.gender == 2 then
    self.genderIcon:LoadSprite(FEMALE_ICON_PATH)
  else
    self.genderIcon:SetActive(false)
  end
end

return VotePlayerItem
