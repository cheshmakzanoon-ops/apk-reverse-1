local p_img_other_alliance_flag_path = "p_img_other_alliance_flag"
local p_text_other_alliance_abbr_path = "p_text_other_alliance_abbr"
local p_text_other_alliance_name_path = "p_text_other_alliance_name"
local p_comp_other_alliance_war_time_path = "p_comp_other_alliance_war_time"
local SeasonAllianceWarTimeStateIconComp = require("UI/LWSeason5/UILWSeasonAllianceWarTime/Common/SeasonAllianceWarTimeStateIconComp")
local base = UIBaseContainer
local Season5DeclareWarTimeAllianceInfoCell = BaseClass("Season5DeclareWarTimeAllianceInfoCell", UIBaseContainer)

function Season5DeclareWarTimeAllianceInfoCell:ComponentDefine()
  self.p_img_other_alliance_flag = self:AddComponent(UIImage, p_img_other_alliance_flag_path)
  self.p_text_other_alliance_abbr = self:AddComponent(UITextMeshProUGUIEx, p_text_other_alliance_abbr_path)
  self.p_text_other_alliance_name = self:AddComponent(UITextMeshProUGUIEx, p_text_other_alliance_name_path)
  self.p_comp_other_alliance_war_time = self:AddComponent(SeasonAllianceWarTimeStateIconComp, p_comp_other_alliance_war_time_path)
end

function Season5DeclareWarTimeAllianceInfoCell:ComponentDestroy()
  self.p_img_other_alliance_flag = nil
  self.p_text_other_alliance_abbr = nil
  self.p_text_other_alliance_name = nil
  self.p_comp_other_alliance_war_time = nil
end

function Season5DeclareWarTimeAllianceInfoCell:DataDefine()
end

function Season5DeclareWarTimeAllianceInfoCell:DataDestroy()
end

function Season5DeclareWarTimeAllianceInfoCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function Season5DeclareWarTimeAllianceInfoCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Season5DeclareWarTimeAllianceInfoCell:OnAddListener()
  base.OnAddListener(self)
end

function Season5DeclareWarTimeAllianceInfoCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function Season5DeclareWarTimeAllianceInfoCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function Season5DeclareWarTimeAllianceInfoCell:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function Season5DeclareWarTimeAllianceInfoCell:InitUi()
  self.p_img_other_alliance_flag:LoadSpriteAsync(string.format(AL_FLAG_SPRITE_PATH, self.Data.AllianceData.icon))
  self.p_text_other_alliance_abbr:SetTextFormat("#%s [%s]", toInt(self.Data.AllianceData.sid), self.Data.AllianceData.abbr)
  self.p_text_other_alliance_name:SetText(self.Data.AllianceData.alliancename)
  local data = {}
  data.AllianceId = self.Data.AllianceData.aid
  data.TimeIndex = self.Data.AllianceData.warTimeIndex
  data.SetTime = UITimeManager:GetInstance():GetServerTime()
  self.p_comp_other_alliance_war_time:ReInit(data)
end

function Season5DeclareWarTimeAllianceInfoCell:UpdateData()
end

function Season5DeclareWarTimeAllianceInfoCell:UpdateUi()
end

return Season5DeclareWarTimeAllianceInfoCell
