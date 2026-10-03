local UILWSeasonIntroductionItem = BaseClass("UILWSeasonIntroductionItem", UIBaseContainer)
local base = UIBaseContainer
local UnityLayoutElement = typeof(CS.UnityEngine.UI.LayoutElement)
local Localization = CS.GameEntry.Localization

function UILWSeasonIntroductionItem:OnCreate()
  base.OnCreate(self)
  self.cacheHeight = 80
  self.unity_LayoutElement = self.gameObject:GetComponent(UnityLayoutElement)
  self.bg_title = self:TryAddComponent(UITextMeshProUGUIEx, "bg")
  self.title = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.icon = self:AddComponent(UIRawImage, "icon")
  self.descUrl = self:TryAddComponent(UITextMeshProUGUIEx, "desc_url")
  if self.descUrl ~= nil then
    self.descUrl:OnPointerClick(BindCallback(self, self.ClickUrl))
  end
end

function UILWSeasonIntroductionItem:OnDestroy()
  base.OnDestroy(self)
end

function UILWSeasonIntroductionItem:ReInit(data)
  local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Source)
  self.data = data
  self.cancel_turn = data.cancel_turn
  self.title:SetLocalText(data.name)
  if self.bg_title then
    self.bg_title:SetActive(not string.IsNullOrEmpty(data.name))
  end
  self.desc:SetLocalText(data.desc)
  if seasonType == SeasonMapType.Darkness or seasonType == SeasonMapType.NineNationRainforest then
    if data.icon == "Assets/Main/SeasonRes/Shared/Textures/MummyConvert/ljq_saijis3_jineng_diban02.png" then
      if seasonType == SeasonMapType.NineNationRainforest then
        self.icon:LoadSpriteAsync("Assets/Main/SeasonRes/S6/Textures/MummyS6/ljq_s6_shuoming_02_banner.png")
      else
        self.icon:LoadSpriteAsync("Assets/Main/SeasonRes/S4/Textures/Mummy/ljq_s4_shuoming_02_banner.png")
      end
    else
      self.icon:LoadSpriteAsync(data.icon)
    end
  else
    self.icon:LoadSpriteAsync(data.icon)
  end
  if CommonUtil.IsArabicAutoMirrorOpen() then
    if self.cancel_turn == 1 then
      self.icon:SetLocalScaleXYZ(-1, 1, 1)
    else
      self.icon:SetLocalScaleXYZ(1, 1, 1)
    end
  else
    self.icon:SetLocalScaleXYZ(1, 1, 1)
  end
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
    self.unity_LayoutElement.minHeight = 473 + self.urlHeight
    self.unity_LayoutElement.preferredHeight = 473 + self.urlHeight
    self.desc:SetAnchoredPositionXY(self.desc:GetAnchoredPositionX(), self.hasUrl and 30 or 15)
  else
    self.unity_LayoutElement.minHeight = 137 + self.urlHeight
    self.unity_LayoutElement.preferredHeight = 137 + self.urlHeight
    self:Update100MS()
  end
end

function UILWSeasonIntroductionItem:ClickUrl()
  if not string.IsNullOrEmpty(self.data.video_resource) then
    CS.SDKManager.OpenURL(Localization:GetString(self.data.video_resource))
  end
end

function UILWSeasonIntroductionItem:Update100MS()
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

return UILWSeasonIntroductionItem
