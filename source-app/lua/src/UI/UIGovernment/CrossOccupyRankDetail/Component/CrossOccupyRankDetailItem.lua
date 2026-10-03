local CrossOccupyRankDetailItem = BaseClass("CrossOccupyRankDetailItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "bg"
local flag_path = "flag"
local first_img_path = "firstImg"
local second_img_path = "secondImg"
local third_img_path = "thirdImg"
local num_txt_path = "numTxt"
local name_txt_path = "nameTxt"
local slider_path = "Slider"
local slider_txt_path = "Slider/SliderTxt"
local fill_path = "Slider/FillArea/Fill"

function CrossOccupyRankDetailItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.flag = self:AddComponent(UIImage, flag_path)
  self.first_img = self:AddComponent(UIImage, first_img_path)
  self.second_img = self:AddComponent(UIImage, second_img_path)
  self.third_img = self:AddComponent(UIImage, third_img_path)
  self.num_txt = self:AddComponent(UIText, num_txt_path)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_text = self:AddComponent(UIText, slider_txt_path)
  self.fill = self:AddComponent(UIImage, fill_path)
  self.bg:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
end

function CrossOccupyRankDetailItem:OnDestroy()
  base.OnDestroy(self)
end

function CrossOccupyRankDetailItem:OnInfoBtnClick()
  if self.data ~= nil then
    self.view:OnAllianceDetailClick(self.data.allianceId, self.data.allianceName)
  end
end

function CrossOccupyRankDetailItem:ReInit(rank, data, ownerServerId, maxOccupy, maxOther, ownerAllianceId)
  local mySeverId = LuaEntry.Player:GetSourceServerId()
  local info = SeasonUtil.GetSeasonInfo(data.serverId)
  if SeasonUtil.IsAlly(data.serverId, mySeverId, data.allianceId) then
    self.fill:SetColorRGBA(0.15294117647058825, 0.7490196078431373, 0.9921568627450981, 1)
  else
    self.fill:SetColorRGBA(0.8117647058823529, 0.16470588235294117, 0.16470588235294117, 1)
  end
  if info and info:GetServerSubdivisionType() == SeasonMapType.NineNationRainforest then
    local campId = info:GetCampIdByServerId(data.serverId)
    if campId == SeasonFactionType.Rebels then
      self.bg:SetColorHex("#D1F2C9")
    elseif campId == SeasonFactionType.Gendarmerie then
      self.bg:SetColorHex("#BFE6F9")
    end
  end
  if SeasonUtil.IsAlly(ownerServerId, data.serverId, ownerAllianceId, data.allianceId) then
    self.first_img:SetActive(rank == 1)
    self.second_img:SetActive(rank == 2)
    self.third_img:SetActive(rank == 3)
    self.num_txt:SetText(rank)
    self.num_txt:SetActive(true)
    if maxOccupy == nil or maxOccupy == 0 or data.contributePoint == 0 then
      self.slider:SetValue(0)
      self.slider_text:SetText("0")
    else
      local rate = data.contributePoint / maxOccupy
      self.slider:SetValue(rate * 100)
      self.slider_text:SetText(string.GetFormattedSeparatorNum(data.contributePoint))
    end
  else
    self.first_img:SetActive(false)
    self.second_img:SetActive(false)
    self.third_img:SetActive(false)
    self.num_txt:SetActive(false)
    if maxOther == nil or maxOther == 0 or data.contributePoint == 0 then
      self.slider:SetValue(0)
      self.slider_text:SetText("0")
    else
      local rate = data.contributePoint / maxOther
      self.slider:SetValue(rate * 100)
      self.slider_text:SetText(string.GetFormattedSeparatorNum(data.contributePoint))
    end
  end
  if string.IsNullOrEmpty(data.allianceAbbr) then
    self.name_txt:SetText("<color=#2a2830>#" .. data.serverId .. " " .. data.allianceName .. "</color>")
  else
    self.name_txt:SetText("<color=#2a2830>#" .. data.serverId .. " [" .. data.allianceAbbr .. "] " .. data.allianceName .. "</color>")
  end
  self.flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(data.allianceIcon)))
  self.data = data
end

return CrossOccupyRankDetailItem
