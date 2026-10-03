local base = UIBaseContainer
local AllianceVSComponent = BaseClass("AllianceVSComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function AllianceVSComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllianceVSComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceVSComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgImgVsBg = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.imgFlagBlue = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textBlueAllianceNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgFlagRed = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textRedAllianceNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgRedFlag = self.viewSkin:AddComponent(self, UIImage, 6)
  self.imgBlueFlag = self.viewSkin:AddComponent(self, UIImage, 7)
  self.rawImgImgVS = self.viewSkin:AddComponent(self, UIRawImage, 8)
  self.imgCityIcon = self:AddComponent(UIImage, "cityIcon")
end

function AllianceVSComponent:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgImgVsBg = nil
  self.imgFlagBlue = nil
  self.textBlueAllianceNameTxt = nil
  self.imgFlagRed = nil
  self.textRedAllianceNameTxt = nil
  self.imgRedFlag = nil
  self.imgBlueFlag = nil
  self.rawImgImgVS = nil
  self.imgCityIcon = nil
end

function AllianceVSComponent:DataDefine()
  self.rawImgImgVsBg:LoadSpriteAsync("Assets/Main/TextureEx/BF_Epidemic/part0/mjc_yibianjinqu_jifenban_youjian.png")
end

function AllianceVSComponent:DataDestroy()
end

function AllianceVSComponent:OnAddListener()
  base.OnAddListener(self)
end

function AllianceVSComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllianceVSComponent:Refresh(cityId, selfAlliance, targetAlliance, result)
  if result then
    self.imgRedFlag:LoadSprite("Assets/Main/Sprites/UI/UIAttackCityS0/UIAttackCityS0Main/zyf_youjian_victory.png")
    self.imgBlueFlag:LoadSprite("Assets/Main/Sprites/UI/UIAttackCityS0/UIAttackCityS0Main/zyf_youjian_defeat.png")
  else
    self.imgBlueFlag:LoadSprite("Assets/Main/Sprites/UI/UIAttackCityS0/UIAttackCityS0Main/zyf_youjian_victory.png")
    self.imgRedFlag:LoadSprite("Assets/Main/Sprites/UI/UIAttackCityS0/UIAttackCityS0Main/zyf_youjian_defeat.png")
  end
  self.imgRedFlag:SetNativeSize()
  self.imgBlueFlag:SetNativeSize()
  if selfAlliance then
    self.imgFlagRed:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, selfAlliance.icon))
    self.textRedAllianceNameTxt:SetLocalText(311026, selfAlliance.abbr, selfAlliance.alliancename)
  end
  if targetAlliance then
    self.imgCityIcon.gameObject:SetActive(false)
    self.imgFlagBlue.gameObject:SetActive(true)
    self.imgFlagBlue:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, targetAlliance.icon))
    self.textBlueAllianceNameTxt:SetLocalText(311026, targetAlliance.abbr, targetAlliance.alliancename)
  else
    self.imgCityIcon.gameObject:SetActive(true)
    self.imgFlagBlue.gameObject:SetActive(false)
    local dataConfig = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
    local iconStr = string.format("Assets/Main/Sprites/UI/LWAllianceZone/Textures/%s.png", dataConfig.city_rally_icon_npc)
    self.imgCityIcon:LoadSprite(iconStr)
    self.textBlueAllianceNameTxt:SetLocalText("city_war_battle_rank_03")
  end
end

return AllianceVSComponent
