local base = UIBaseContainer
local SeasonCampDestroyZoneRankItem = BaseClass("SeasonCampDestroyZoneRankItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function SeasonCampDestroyZoneRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyZoneRankItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyZoneRankItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTmpRankNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTmpName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTmpServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgAlliance = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textTmpPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.imgRank = self.viewSkin:AddComponent(self, UIImage, 7)
  self.btnTips = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnTips:SetOnClick(function()
    self:OnBtnTipsClick()
  end)
  self.btnAlliance = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnAlliance:SetOnClick(function()
    self:OnBtnAllianceClick()
  end)
end

function SeasonCampDestroyZoneRankItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.textTmpRankNum = nil
  self.textTmpName = nil
  self.textTmpServer = nil
  self.imgAlliance = nil
  self.textTmpPower = nil
  self.imgRank = nil
  self.btnTips = nil
  self.btnAlliance = nil
end

function SeasonCampDestroyZoneRankItem:DataDefine()
end

function SeasonCampDestroyZoneRankItem:DataDestroy()
  self.data = nil
end

function SeasonCampDestroyZoneRankItem:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyZoneRankItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCampDestroyZoneRankItem:Setup(host)
  self.host = host
end

local rankBg = {}
rankBg[1] = "Assets/Main/SeasonRes/S6/Sprites/CampDestroy/mjc_tongyong_paiming_s_bg1.png"
rankBg[2] = "Assets/Main/SeasonRes/S6/Sprites/CampDestroy/mjc_tongyong_paiming_s_bg2.png"
rankBg[3] = "Assets/Main/SeasonRes/S6/Sprites/CampDestroy/mjc_tongyong_paiming_s_bg3.png"
rankBg[0] = "Assets/Main/SeasonRes/S6/Sprites/CampDestroy/mjc_tongyong_paiming_s_bg3.png"
local rankIcon = {}
rankIcon[1] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang01.png"
rankIcon[2] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang02.png"
rankIcon[3] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang03.png"

function SeasonCampDestroyZoneRankItem:ReInit(idx, data)
  if not data then
    return
  end
  self.data = data
  self.textTmpRankNum:SetText(data.rank)
  self.textTmpServer:SetText(UIUtil.FormatServerName(data.serverId))
  self.textTmpName:SetText(UIUtil.FormatAllianceAndName(data.allianceAbbr, data.allianceName))
  self.textTmpPower:SetText(string.GetFormattedStr(data.damage))
  self.imgAlliance:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(data.allianceIcon)))
  self.imgBg:LoadSpriteAuto(rankBg[data.rank] or rankBg[0])
  local iconPath = rankIcon[data.rank]
  if iconPath then
    self.imgRank:LoadSpriteAuto(iconPath)
    self.imgRank:SetActive(true)
  else
    self.imgRank:SetActive(false)
  end
end

function SeasonCampDestroyZoneRankItem:OnBtnTipsClick()
  if not self.data then
    return
  end
  UIUtil.OpenAuto(UIWindowNames.SeasonCampDestroyInfluenceDetail, self.data)
end

function SeasonCampDestroyZoneRankItem:OnBtnAllianceClick()
  if not self.data then
    return
  end
  UIUtil.TryShowAllianceInfo(self.data.serverId, self.data.allianceId, self.data.allianceName)
end

return SeasonCampDestroyZoneRankItem
