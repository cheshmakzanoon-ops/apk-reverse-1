local UILWSeasonIntroductionItemSmall = BaseClass("UILWSeasonIntroductionItemSmall", UIBaseContainer)
local base = UIBaseContainer
local UnityLayoutElement = typeof(CS.UnityEngine.UI.LayoutElement)
local Localization = CS.GameEntry.Localization

function UILWSeasonIntroductionItemSmall:OnCreate()
  base.OnCreate(self)
  self.cacheHeight = 80
  self.unity_LayoutElement = self.gameObject:GetComponent(UnityLayoutElement)
  self.title = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.icon = self:AddComponent(UIImage, "icon")
  self.descUrl = self:TryAddComponent(UITextMeshProUGUIEx, "desc/desc_url")
  if self.descUrl ~= nil then
    self.descUrl:OnPointerClick(BindCallback(self, self.ClickUrl))
  end
end

function UILWSeasonIntroductionItemSmall:OnDestroy()
  base.OnDestroy(self)
end

function UILWSeasonIntroductionItemSmall:ReInit(data)
  self.data = data
  self.title:SetLocalText(data.name)
  self.icon:LoadSpriteAsync(data.icon)
  self.desc:SetLocalText(data.desc)
  self.urlHeight = 0
  if self.descUrl ~= nil then
    self.hasUrl = not string.IsNullOrEmpty(data.video_resource)
    self.descUrl:SetActive(self.hasUrl)
    if self.hasUrl then
      self.descUrl:SetText(string.format("<link=\"%s\"><u>%s</u></link>", Localization:GetString(data.video_resource), Localization:GetString("season_ppt_s1_13")))
      self.urlHeight = 40
    end
  end
  if data.big then
    self.unity_LayoutElement.minHeight = 350 + self.urlHeight
    self.unity_LayoutElement.preferredHeight = 350 + self.urlHeight
    self.desc:SetAnchoredPositionXY(self.desc:GetAnchoredPositionX(), self.hasUrl and 30 or 15)
  else
    self.unity_LayoutElement.minHeight = 137 + self.urlHeight
    self.unity_LayoutElement.preferredHeight = 137 + self.urlHeight
    self:Update100MS()
  end
end

function UILWSeasonIntroductionItemSmall:ClickUrl()
  if not string.IsNullOrEmpty(self.data.video_resource) then
    CS.SDKManager.OpenURL(Localization:GetString(self.data.video_resource))
  end
end

function UILWSeasonIntroductionItemSmall:Update100MS()
  if not self.data.big then
    local targetSizeDelta = self.desc:GetSizeDelta()
    if targetSizeDelta and targetSizeDelta.y ~= self.cacheHeight then
      local height = 137
      self.cacheHeight = targetSizeDelta.y
      if self.cacheHeight > 80 then
        height = 137 + (self.cacheHeight - 80)
      end
      self.unity_LayoutElement.minHeight = height + self.urlHeight
      self.unity_LayoutElement.preferredHeight = height + self.urlHeight
    end
  end
end

return UILWSeasonIntroductionItemSmall
