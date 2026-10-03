local p_text_city_title_path = "content/p_text_city_title"
local p_img_city_icon_path = "content/content_left/p_img_city_icon"
local p_text_city_name_path = "content/content_left/p_text_city_name"
local p_btn_city_location_path = "content/content_left/p_btn_city_location"
local p_text_city_location_path = "content/content_left/p_btn_city_location/p_text_city_location"
local p_list_other_alliances_path = "content/content_right/p_list_other_alliances"
local content_path = "content/content_right/p_list_other_alliances/Viewport/Content"
local p_text_list_empty_path = "content/content_right/p_text_list_empty"
local Season5DeclareWarTimeAllianceInfoCell = require("UI/LWSeason5/DeclareCity/Season5DeclareCityWarTime/Comp/Season5DeclareWarTimeAllianceInfoCell")
local base = UIBaseContainer
local Season5DeclareWarTimeCityInfoCell = BaseClass("Season5DeclareWarTimeCityInfoCell", UIBaseContainer)

function Season5DeclareWarTimeCityInfoCell:ComponentDefine()
  self.p_text_city_title = self:AddComponent(UITextMeshProUGUIEx, p_text_city_title_path)
  self.p_img_city_icon = self:AddComponent(UIImage, p_img_city_icon_path)
  self.p_text_city_name = self:AddComponent(UITextMeshProUGUIEx, p_text_city_name_path)
  self.p_btn_city_location = self:AddComponent(UIButton, p_btn_city_location_path)
  self.p_btn_city_location:SetOnClick(BindCallback(self, self.OnLocationClicked))
  self.p_text_city_location = self:AddComponent(UITextMeshProUGUIEx, p_text_city_location_path)
  self.p_list_other_alliances = self:AddComponent(UIScrollView, p_list_other_alliances_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.p_text_list_empty = self:AddComponent(UITextMeshProUGUIEx, p_text_list_empty_path)
end

function Season5DeclareWarTimeCityInfoCell:ComponentDestroy()
  self:ClearScroll()
  self.p_text_city_title = nil
  self.p_img_city_icon = nil
  self.p_text_city_name = nil
  self.p_btn_city_location = nil
  self.p_text_city_location = nil
  self.p_list_other_alliances = nil
  self.content = nil
  self.p_text_list_empty = nil
end

function Season5DeclareWarTimeCityInfoCell:DataDefine()
end

function Season5DeclareWarTimeCityInfoCell:DataDestroy()
end

function Season5DeclareWarTimeCityInfoCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function Season5DeclareWarTimeCityInfoCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Season5DeclareWarTimeCityInfoCell:OnAddListener()
  base.OnAddListener(self)
end

function Season5DeclareWarTimeCityInfoCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function Season5DeclareWarTimeCityInfoCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function Season5DeclareWarTimeCityInfoCell:InitData(data)
  if data ~= nil and data.CityData ~= nil then
    self.CityData = data.CityData
    self.CityInfo = DataCenter.AllianceCityTemplateManager:GetTemplate(self.CityData.cityid, self.CityData.sid)
    return true
  end
  return false
end

function Season5DeclareWarTimeCityInfoCell:InitUi()
  self.p_text_city_title:SetLocalText("season_s5_activity_1200059_desc14")
  self.p_img_city_icon:LoadSpriteAsync(self.CityInfo:GetIconPath())
  self.p_text_city_name:SetText(self.CityInfo:GetName())
  local pos = self.CityInfo.pos
  local location = string.format("#%s X:%s Y:%s", self.CityData.sid, pos.x, pos.y)
  self.p_text_city_location:SetText(location)
  self.p_text_list_empty:SetLocalText("season_s5_activity_1200059_desc15")
  self:InitList()
  self.AllianceList = self:GetAllianceList()
  local dataCount = table.count(self.AllianceList)
  self.p_list_other_alliances:SetActive(0 < dataCount)
  self.p_text_list_empty:SetActive(dataCount <= 0)
  if 0 < dataCount then
    self.p_list_other_alliances:SetTotalCount(dataCount)
    self.p_list_other_alliances:RefillCells()
  end
end

function Season5DeclareWarTimeCityInfoCell:GetAllianceList()
  local ret = {}
  if self.CityData ~= nil and not table.IsNullOrEmpty(self.CityData.nearbyAlliances) then
    for _, alliance in pairs(self.CityData.nearbyAlliances) do
      if alliance.aid ~= LuaEntry.Player.allianceId then
        table.insert(ret, alliance)
      end
    end
  end
  return ret
end

function Season5DeclareWarTimeCityInfoCell:OnLocationClicked()
  if self.CityInfo ~= nil then
    self.CityInfo:JumpTo()
  end
end

function Season5DeclareWarTimeCityInfoCell:InitList()
  self.p_list_other_alliances:SetFixedItemSize(400, 70)
  self.p_list_other_alliances:SetOnItemMoveIn(function(itemObj, index)
    self:OnCityCellMoveIn(itemObj, index)
  end)
  self.p_list_other_alliances:SetOnItemMoveOut(function(itemObj, index)
    self:OnCityCellMoveOut(itemObj, index)
  end)
end

function Season5DeclareWarTimeCityInfoCell:OnCityCellMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.p_list_other_alliances:AddComponent(Season5DeclareWarTimeAllianceInfoCell, itemObj)
  if cellItem ~= nil then
    local data = {}
    data.AllianceData = self.AllianceList[index]
    cellItem:ReInit(data)
  end
end

function Season5DeclareWarTimeCityInfoCell:OnCityCellMoveOut(itemObj, index)
  self.p_list_other_alliances:RemoveComponent(itemObj.name, Season5DeclareWarTimeAllianceInfoCell)
end

function Season5DeclareWarTimeCityInfoCell:ClearScroll()
  self.p_list_other_alliances:ClearCells()
  self.p_list_other_alliances:RemoveComponents(Season5DeclareWarTimeAllianceInfoCell)
end

return Season5DeclareWarTimeCityInfoCell
