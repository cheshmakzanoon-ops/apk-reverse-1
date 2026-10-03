local p_icon_alliance_flag_path = "p_icon_alliance_flag"
local p_btn_me_info_path = "p_btn_me_info"
local p_text_me_alliance_abbr_path = "p_text_me_alliance_abbr"
local p_text_me_alliance_name_path = "p_text_me_alliance_name"
local p_img_me_city_icon_path = "p_img_me_city_icon"
local p_comp_slider_me_path = "p_comp_slider_me/Slider"
local p_text_me_city_name_path = "p_text_me_city_name"
local p_text_me_location_path = "p_text_me_location"
local p_btn_me_goto_path = "p_btn_me_goto"
local p_text_declare_goto_path = "p_btn_me_goto/img_btn/p_text_declare_goto"
local base = UIBaseContainer
local Season5DeclareInWarTimeDefenceCell = BaseClass("Season5DeclareInWarTimeDefenceCell", UIBaseContainer)

function Season5DeclareInWarTimeDefenceCell:ComponentDefine()
  self.p_icon_alliance_flag = self:AddComponent(UIImage, p_icon_alliance_flag_path)
  self.p_btn_me_info = self:AddComponent(UIButton, p_btn_me_info_path)
  self.p_text_me_alliance_abbr = self:AddComponent(UITextMeshProUGUIEx, p_text_me_alliance_abbr_path)
  self.p_text_me_alliance_name = self:AddComponent(UITextMeshProUGUIEx, p_text_me_alliance_name_path)
  self.p_img_me_city_icon = self:AddComponent(UIImage, p_img_me_city_icon_path)
  self.p_comp_slider_me = self:AddComponent(UISlider, p_comp_slider_me_path)
  self.p_text_me_city_name = self:AddComponent(UITextMeshProUGUIEx, p_text_me_city_name_path)
  self.p_text_me_location = self:AddComponent(UITextMeshProUGUIEx, p_text_me_location_path)
  self.p_btn_me_goto = self:AddComponent(UIButton, p_btn_me_goto_path)
  self.p_btn_me_goto:SetOnClick(BindCallback(self, self.OnGotoClicked))
  self.p_text_declare_goto = self:AddComponent(UITextMeshProUGUIEx, p_text_declare_goto_path)
end

function Season5DeclareInWarTimeDefenceCell:ComponentDestroy()
  self.p_icon_alliance_flag = nil
  self.p_btn_me_info = nil
  self.p_text_me_alliance_abbr = nil
  self.p_text_me_alliance_name = nil
  self.p_img_me_city_icon = nil
  self.p_comp_slider_me = nil
  self.p_text_me_city_name = nil
  self.p_text_me_location = nil
  self.p_btn_me_goto = nil
  self.p_text_declare_goto = nil
end

function Season5DeclareInWarTimeDefenceCell:DataDefine()
end

function Season5DeclareInWarTimeDefenceCell:DataDestroy()
end

function Season5DeclareInWarTimeDefenceCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function Season5DeclareInWarTimeDefenceCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Season5DeclareInWarTimeDefenceCell:OnAddListener()
  base.OnAddListener(self)
end

function Season5DeclareInWarTimeDefenceCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function Season5DeclareInWarTimeDefenceCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function Season5DeclareInWarTimeDefenceCell:InitData(data)
  if data ~= nil and not table.IsNullOrEmpty(data.DeclareInfo) then
    self.DeclareInfo = data.DeclareInfo
    self.CityInfo = DataCenter.AllianceCityTemplateManager:GetTemplate(self.DeclareInfo.cityId)
    self.CityId = self.DeclareInfo.cityId
    self.ServerId = self.DeclareInfo.serverId
    self.EndTime = self.DeclareInfo.endTime
    if self.CityInfo ~= nil then
      self.PointId = self.CityInfo:GetPointId()
    end
    return true
  end
  return false
end

function Season5DeclareInWarTimeDefenceCell:InitUi()
  local atk = self.DeclareInfo.atk
  local allianceAbbr = string.format("#%s [%s]", atk.serverId, atk.abbr)
  self.p_text_me_alliance_abbr:SetText(allianceAbbr)
  self.p_text_me_alliance_name:SetText(atk.name)
  self.p_img_me_city_icon:LoadSpriteAsync(self.CityInfo:GetIconPath(false))
  self.p_text_me_location:SetText(string.format("#%s (X:%s Y:%s)", self.DeclareInfo.serverId, self.CityInfo.pos.x, self.CityInfo.pos.y))
  self.p_text_declare_goto:SetLocalText("season_s5_activity_1200059_desc25")
end

function Season5DeclareInWarTimeDefenceCell:UpdateData()
  if self.CityInfo ~= nil then
    self.MaxDurability = checknumber(self.CityInfo.wall)
    self.RecoverSpeed = checknumber(self.CityInfo.wall_recover)
    return true
  end
  return false
end

function Season5DeclareInWarTimeDefenceCell:UpdateUi()
  self:Update1000MS()
end

function Season5DeclareInWarTimeDefenceCell:UpdateDurability()
  if self.DeclareInfo ~= nil then
    if self.DeclareInfo.durability ~= nil then
      local maxDurability = self.MaxDurability
      local durability = checknumber(self.DeclareInfo.durability)
      local lastDurabilityTime = checknumber(self.DeclareInfo.lastDurabilityTime)
      local cityRecoverSpeed = self.RecoverSpeed
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      local addNum = (curTime - lastDurabilityTime) * cityRecoverSpeed
      local realDurabilityNum = durability + math.max(addNum, 0)
      local curDurability = math.min(realDurabilityNum, maxDurability)
      local percent = Mathf.Clamp(curDurability / maxDurability, 0, 1)
      self.p_comp_slider_me:SetActive(true)
      self.p_comp_slider_me:SetValue(percent)
    else
      self.p_comp_slider_me:SetActive(false)
    end
  end
end

function Season5DeclareInWarTimeDefenceCell:Update1000MS()
  self:UpdateDurability()
end

function Season5DeclareInWarTimeDefenceCell:OnGotoClicked()
  if self.CityInfo ~= nil then
    self.CityInfo:JumpTo()
  end
end

return Season5DeclareInWarTimeDefenceCell
