local UIWorldOutpostCityFixItem = BaseClass("UIWorldOutpostCityFixItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "bg"
local alliance_flag_path = "allianceFlag"
local desc_path = "Desc"
local icon_path = "icon"
local num_txt_path = "icon/numTxt"
local point_text_path = "pointText"
local name_path = "Name"

function UIWorldOutpostCityFixItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.alliance_flag = self:AddComponent(UIImage, alliance_flag_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.num_txt = self:AddComponent(UITextMeshProUGUIEx, num_txt_path)
  self.point_text = self:AddComponent(UITextMeshProUGUIEx, point_text_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.bg:SetOnClick(function()
    if self.data then
      local serverId = self.data.serverId
      local allianceId = self.data.allianceId
      local allianceName = self.data.name
      if serverId and allianceId then
        UIUtil.TryShowAllianceInfo(serverId, allianceId, allianceName)
      end
    end
  end)
end

function UIWorldOutpostCityFixItem:OnDestroy()
  self.bg = nil
  self.alliance_flag = nil
  self.desc = nil
  self.icon = nil
  self.num_txt = nil
  self.point_text = nil
  self.name = nil
  base.OnDestroy(self)
end

function UIWorldOutpostCityFixItem:ReInit(index, data)
  if data ~= nil and data.icon ~= nil then
    self:SetActive(true)
    self.data = data
    self.alliance_flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(data.icon)))
    self.name:SetText(data.name)
    self.desc:SetText(UIUtil.FormatServerAllianceName(data.serverId, data.abbr, ""))
    self.point_text:SetText("+" .. data.score)
    local power_color = "#2a2830"
    local first_color = "#2a2830"
    local second_color = "#6d82ad"
    if data.rank == 1 then
      power_color = "#d07b0c"
      first_color = "#d07b0c"
      second_color = "#b78026"
    elseif data.rank == 2 then
      power_color = "#6674ba"
      first_color = "#6674ba"
      second_color = "#5065cb"
    elseif data.rank == 3 then
      power_color = "#b77758"
      first_color = "#b77758"
      second_color = "#ba6744"
    end
    self.icon:SetEnable(false)
    self.num_txt:SetText(tostring(data.rank))
    return 1
  end
  self:SetActive(false)
  return 0
end

return UIWorldOutpostCityFixItem
