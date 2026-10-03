local UILWSeasonServerDetailItemAllianceBuild = BaseClass("UILWSeasonServerDetailItemAllianceBuild", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function UILWSeasonServerDetailItemAllianceBuild:OnCreate()
  base.OnCreate(self)
  self.build_icon = self:AddComponent(UIImage, "icon")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "name")
  self.server = self:AddComponent(UITextMeshProUGUIEx, "server")
  self.protected = self:AddComponent(UIImage, "protected")
end

function UILWSeasonServerDetailItemAllianceBuild:OnDestroy()
  self.build_icon = nil
  self.name = nil
  self.server = nil
  self.protected = nil
  base.OnDestroy(self)
end

function UILWSeasonServerDetailItemAllianceBuild:ReInit(buildingId, data)
  local buildData
  local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildingId)
  for k, v in ipairs(data) do
    if v and v.buildId == buildingId then
      buildData = v
      break
    end
  end
  if buildData == nil then
    self.name:SetColorHex("#CCC8C6")
    if meta == nil or string.IsNullOrEmpty(meta.name) then
      self.name:SetLocalText("803031")
    else
      self.name:SetLocalText(meta.name)
    end
    self.server:SetLocalText("s1_zone_info_ui11")
    self.protected:SetActive(false)
  else
    self.name:SetColorHex("#FFFFFF")
    if meta == nil or string.IsNullOrEmpty(meta.name) then
      self.name:SetLocalText("803031")
    else
      self.name:SetLocalText(meta.name)
    end
    self.server:SetText(buildData.server)
    self.protected:SetActive(buildData.status == AllianceMineStatus.Build)
  end
end

return UILWSeasonServerDetailItemAllianceBuild
