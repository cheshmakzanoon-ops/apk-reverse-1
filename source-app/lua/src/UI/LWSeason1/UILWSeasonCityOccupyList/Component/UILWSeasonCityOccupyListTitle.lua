local UILWSeasonCityOccupyListTitle = BaseClass("UILWSeasonCityOccupyListTitle", UIBaseContainer)
local base = UIBaseContainer

function UILWSeasonCityOccupyListTitle:OnCreate()
  base.OnCreate(self)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, "TitleText")
  self.power_text = self:AddComponent(UITextMeshProUGUIEx, "PowerText")
  self.info_btn1 = self:AddComponent(UIButton, "TitleText/InfoBtn")
  self.info_btn2 = self:AddComponent(UIButton, "TitleText")
  self.info_btn1:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.info_btn2:SetOnClick(function()
    self:OnInfoClick()
  end)
end

function UILWSeasonCityOccupyListTitle:OnDestroy()
  self.title_text = nil
  self.power_text = nil
  self.info_btn1 = nil
  self.info_btn2 = nil
  base.OnDestroy(self)
end

function UILWSeasonCityOccupyListTitle:OnInfoClick()
  if self.data and self.data.isCity then
    UIUtil.ShowButtonTips(self.info_btn1, nil, "power_level_tips_8", false)
  else
    UIUtil.ShowButtonTips(self.info_btn1, nil, "power_level_tips_9", false)
  end
end

function UILWSeasonCityOccupyListTitle:ReInit(index, data, serverId)
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  self.serverId = serverId
  self.data = data
  if data and data.txt then
    self.title_text:SetText(data.txt)
  else
    self.title_text:SetText("")
  end
  if data and data.force ~= nil and data.force ~= 0 then
    self.power_text:SetLocalText("power_level_tips_5", string.GetFormattedSeparatorNum(data.force))
  else
    self.power_text:SetText("")
  end
  self.info_btn1:SetActive(not data.isCity or serverId ~= sourceServerId)
  self.info_btn2:SetInteractable(not data.isCity or serverId ~= sourceServerId)
end

return UILWSeasonCityOccupyListTitle
