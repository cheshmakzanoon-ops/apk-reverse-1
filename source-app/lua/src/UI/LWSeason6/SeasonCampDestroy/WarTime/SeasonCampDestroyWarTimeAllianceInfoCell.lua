local p_img_other_alliance_flag_path = "p_img_other_alliance_flag"
local p_text_other_alliance_abbr_path = "p_text_other_alliance_abbr"
local p_text_other_alliance_name_path = "p_text_other_alliance_name"
local p_comp_other_alliance_war_time_path = "p_comp_other_alliance_war_time"
local img_bg_path = "img_bg"
local SeasonCampDestroyWarTimeStateIconComp = require("UI/LWSeason6/SeasonCampDestroy/Comps/SeasonCampDestroyWarTimeStateIconComp")
local SeasonCampDestroyWarTimeData = require("UI/LWSeason6/SeasonCampDestroy/Data/SeasonCampDestroyWarTimeData")
local base = UIBaseContainer
local SeasonCampDestroyWarTimeAllianceInfoCell = BaseClass("SeasonCampDestroyWarTimeAllianceInfoCell", UIBaseContainer)

function SeasonCampDestroyWarTimeAllianceInfoCell:ComponentDefine()
  self.p_img_other_alliance_flag = self:AddComponent(UIImage, p_img_other_alliance_flag_path)
  self.p_text_other_alliance_abbr = self:AddComponent(UITextMeshProUGUIEx, p_text_other_alliance_abbr_path)
  self.p_text_other_alliance_name = self:AddComponent(UITextMeshProUGUIEx, p_text_other_alliance_name_path)
  self.p_comp_other_alliance_war_time = self:AddComponent(SeasonCampDestroyWarTimeStateIconComp, p_comp_other_alliance_war_time_path)
  self.img_bg = self:AddComponent(UIImage, img_bg_path)
end

function SeasonCampDestroyWarTimeAllianceInfoCell:ComponentDestroy()
  self.p_img_other_alliance_flag = nil
  self.p_text_other_alliance_abbr = nil
  self.p_text_other_alliance_name = nil
  self.p_comp_other_alliance_war_time = nil
  self.img_bg = nil
end

function SeasonCampDestroyWarTimeAllianceInfoCell:DataDefine()
end

function SeasonCampDestroyWarTimeAllianceInfoCell:DataDestroy()
end

function SeasonCampDestroyWarTimeAllianceInfoCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyWarTimeAllianceInfoCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyWarTimeAllianceInfoCell:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyWarTimeAllianceInfoCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCampDestroyWarTimeAllianceInfoCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonCampDestroyWarTimeAllianceInfoCell:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function SeasonCampDestroyWarTimeAllianceInfoCell:InitUi()
  self.p_img_other_alliance_flag:LoadSpriteAsync(string.format(AL_FLAG_SPRITE_PATH, self.Data.AllianceData.icon))
  self.p_text_other_alliance_abbr:SetTextFormat("#%s [%s]", toInt(self.Data.AllianceData.sid), self.Data.AllianceData.abbr)
  self.p_text_other_alliance_name:SetText(self.Data.AllianceData.alliancename)
  local data = SeasonCampDestroyWarTimeData.New()
  data.AllianceId = self.Data.AllianceData.aid
  data.TimeIndex = self.Data.AllianceData.warTimeIndex
  data.SetTime = UITimeManager:GetInstance():GetServerTime()
  self.p_comp_other_alliance_war_time:ReInit(data)
  self:SetupBgColor()
end

function SeasonCampDestroyWarTimeAllianceInfoCell:SetupBgColor()
  local campId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(self.Data.AllianceData.sid)
  local bgColor = Color.New(0.9411764705882353, 0.9098039215686274, 0.8980392156862745, 1)
  if campId == 1 then
    bgColor = Color.New(0.8196078431372549, 0.9490196078431372, 0.788235294117647, 1)
  elseif campId == 2 then
    bgColor = Color.New(0.7490196078431373, 0.9019607843137255, 0.9764705882352941, 1)
  end
  self.img_bg:SetColor(bgColor)
end

function SeasonCampDestroyWarTimeAllianceInfoCell:UpdateData()
end

function SeasonCampDestroyWarTimeAllianceInfoCell:UpdateUi()
end

return SeasonCampDestroyWarTimeAllianceInfoCell
