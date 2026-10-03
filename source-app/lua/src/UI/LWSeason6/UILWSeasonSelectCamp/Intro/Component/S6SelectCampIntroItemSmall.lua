local S6SelectCampIntroItemSmall = BaseClass("S6SelectCampIntroItemSmall", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function S6SelectCampIntroItemSmall:OnCreate()
  base.OnCreate(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.title = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.icon = self:AddComponent(UIImage, "icon")
  self.descUrl = self:TryAddComponent(UITextMeshProUGUIEx, "desc_url")
  if self.descUrl ~= nil then
    self.descUrl:OnPointerClick(BindCallback(self, self.ClickUrl))
  end
end

function S6SelectCampIntroItemSmall:OnDestroy()
  base.OnDestroy(self)
end

function S6SelectCampIntroItemSmall:ReInit(data)
  self.data = data
  self.title:SetLocalText(data.name)
  self.icon:LoadSpriteAsync(data.icon)
  self.desc:SetLocalText(data.desc)
  if self.descUrl ~= nil then
    self.hasUrl = not string.IsNullOrEmpty(data.video_resource)
    self.descUrl:SetActive(self.hasUrl)
    if self.hasUrl then
      self.descUrl:SetText(string.format("<link=\"%s\"><u>%s</u></link>", Localization:GetString(data.video_resource), Localization:GetString("season_ppt_s1_13")))
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
end

function S6SelectCampIntroItemSmall:ClickUrl()
  if not string.IsNullOrEmpty(self.data.video_resource) then
    CS.SDKManager.OpenURL(Localization:GetString(self.data.video_resource))
  end
end

return S6SelectCampIntroItemSmall
