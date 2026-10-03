local UIHeroInfoLeft = BaseClass("UIHeroInfoLeft", UIBaseContainer)
local base = UIBaseContainer
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.imgRarity = self:AddComponent(UIImage, "ImgRarity")
  self.imgCamp = self:AddComponent(UIImage, "ImgCamp")
  self.btnCamp = self:AddComponent(UIButton, "ImgCamp")
  self.textCamp = self:AddComponent(UIText, "ImgCamp/TextCampName")
  self.textName = self:AddComponent(UIText, "TextHeroName")
  self.textNickName = self:AddComponent(UIText, "TextNickName")
  self.imgTags = {}
  for i = 1, 3 do
    local btnTag = self:AddComponent(UIButton, "NodeTag/BtnTag" .. i)
    local imgTag = self:AddComponent(UIImage, "NodeTag/BtnTag" .. i .. "/ImgTag" .. i)
    local textTag = self:AddComponent(UIText, string.format("NodeTag/BtnTag%s/TextTag%s", i, i))
    btnTag:SetOnClick(function()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:OnTagClick(i)
    end)
    table.insert(self.imgTags, {
      icon = imgTag,
      text = textTag,
      btnTag = btnTag
    })
  end
  self.btnCamp:SetOnClick(BindCallback(self, self.OnBtnCampClick))
  self.nodeTag = self:AddComponent(UIBaseContainer, "NodeTag")
end

local function ComponentDestroy(self)
end

local function InitData(self, heroId, heroUuid, quality, camp)
  self.heroId = heroId
  self.quality = quality
  self.camp = camp
  local campName = HeroUtils.GetCampNameAndDesc(camp)
  local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
  self.imgRarity:LoadSprite(HeroUtils.GetRarityIconName(heroConfig.rarity, true))
  self.imgCamp:LoadSprite(HeroUtils.GetCampIconPath(camp))
  self.textCamp:SetText(campName)
  self.textNickName:SetLocalText(heroConfig.desc)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  local isWakenUp = false
  if heroData ~= nil then
    isWakenUp = heroData:IsWakeUp()
    self.textName:SetText(heroData:GetName())
  else
    self.textName:SetLocalText(heroConfig.name)
  end
  self.textNickName:SetColor(HeroUtils.GetHeroNameColorByRarity(heroConfig.rarity, isWakenUp))
  self.tagDescList = {}
  local tags = HeroUtils.GetTagsByHeroId(heroId)
  for k, tagTable in pairs(self.imgTags) do
    local imgTag = tagTable.icon
    local textTag = tagTable.text
    if tags[k] == nil then
      imgTag:SetActive(false)
      textTag:SetActive(false)
    else
      local iconPath, tagName, desc = HeroUtils.GetTagIconAndName(tags[k])
      imgTag:LoadSprite(iconPath)
      textTag:SetText(tagName)
      imgTag:SetActive(true)
      textTag:SetActive(true)
      table.insert(self.tagDescList, desc)
    end
  end
end

local function OnBtnCampClick(self)
  local camp = self.camp
  local restraintCamp = HeroUtils.GetHeroRestraintType(camp)
  if 0 <= restraintCamp then
    local x = self.btnCamp.transform.position.x + 40
    local y = self.btnCamp.transform.position.y
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroCampRestraint, camp, x, y)
  else
    local name, desc = HeroUtils.GetCampNameAndDesc(camp)
    local content = string.format([[
<size=24>%s</size>

<size=16>%s</size>]], name, desc)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.btnCamp.transform.position + Vector3.New(0, -40, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = content
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 210
    param.pivot = 0.15
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

local function OnTagClick(self, index)
  if not self.imgTags[index].icon:GetActive() then
    return
  end
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.imgTags[index].icon.transform.position + Vector3.New(0, -30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = self.tagDescList[index]
  param.dir = UIHeroTipView.Direction.BELOW
  param.defWidth = 210
  param.pivot = 0.15
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

UIHeroInfoLeft.OnCreate = OnCreate
UIHeroInfoLeft.OnDestroy = OnDestroy
UIHeroInfoLeft.ComponentDefine = ComponentDefine
UIHeroInfoLeft.ComponentDestroy = ComponentDestroy
UIHeroInfoLeft.OnTagClick = OnTagClick
UIHeroInfoLeft.OnBtnCampClick = OnBtnCampClick
UIHeroInfoLeft.InitData = InitData
return UIHeroInfoLeft
