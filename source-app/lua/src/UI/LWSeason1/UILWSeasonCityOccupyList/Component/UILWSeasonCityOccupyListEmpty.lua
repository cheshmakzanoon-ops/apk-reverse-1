local UILWSeasonCityOccupyListEmpty = BaseClass("UILWSeasonCityOccupyListEmpty", UIBaseContainer)
local base = UIBaseContainer

function UILWSeasonCityOccupyListEmpty:OnCreate()
  base.OnCreate(self)
  self.no_data = self:AddComponent(UITextMeshProUGUIEx, "NoData")
  self.btn_go = self:AddComponent(UIButton, "BtnGo")
  self.btn_go:SetOnClick(function()
    if self.data and self.data.isCity then
      GoToUtil.GotoNearestCity(3, WorldAllianceCityType.City, self.serverId)
    else
      GoToUtil.GotoNearestCity(3, WorldAllianceCityType.Stronghold, self.serverId)
    end
  end)
end

function UILWSeasonCityOccupyListEmpty:OnDestroy()
  self.no_data = nil
  self.btn_go = nil
  base.OnDestroy(self)
end

function UILWSeasonCityOccupyListEmpty:ReInit(index, data, serverId, dataList)
  self.serverId = serverId
  self.data = data
  self.dataList = dataList or {}
  if data == nil then
    self.btn_go:SetActive(false)
    self.no_data:SetLocalText("season_desert_desc001")
  elseif serverId == LuaEntry.Player:GetSourceServerId() then
    self.btn_go:SetActive(true)
    if data.isCity then
      self.no_data:SetLocalText("power_level_tips_1")
    else
      self.no_data:SetLocalText("power_level_tips_2")
    end
  else
    self.btn_go:SetActive(true)
    if data.isCity then
      self.no_data:SetLocalText("power_level_tips_3")
    else
      self.no_data:SetLocalText("power_level_tips_4")
    end
  end
end

return UILWSeasonCityOccupyListEmpty
