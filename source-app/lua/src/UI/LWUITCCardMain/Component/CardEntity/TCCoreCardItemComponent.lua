local CardBaseItem = require("UI.LWUITCCardMain.Component.CardEntity.TCCardBaseItem")
local StarListItem = require("UI.LWUITCCardMain.Component.TCStarListItemComponent")
local EQUIP_BACK_EFF_PATH = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_fire_back.prefab"
local EQUIP_FRONT_EFF_PATH = "Assets/_Art_LastWar/Effect/Prefab/VX/TCCcard/Eff_ui_TCCcard_fire_front.prefab"
local TCCoreCardItemComponent = BaseClass("TCCoreCardItemComponent", CardBaseItem)
local base = CardBaseItem
local Localization = CS.GameEntry.Localization
local t_c_star_list_item_path = "AniRoot/ScaleRoot/TCStarListItem"
local equip_eff_back_point_path = "AniRoot/ScaleRoot/EquipEffBackPoint"
local equip_eff_front_point_path = "AniRoot/ScaleRoot/CardImg/EquipEffFrontPoint"
TCCoreCardItemComponent.STANDARD_SIZE = {x = 203.123, y = 227.1779}
TCCoreCardItemComponent.VISUAL_SIZE = {x = 203.123, y = 227.1779}

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.starList = self:AddComponent(StarListItem, t_c_star_list_item_path)
  local effectParam = {}
  effectParam.lifeType = UIVfxLifeType.DestroyAfterOnce
  effectParam.duration = 2.5
  local frontVfxParam = {}
  frontVfxParam.lifeType = UIVfxLifeType.Stay
  self.equipBackEff = self:AddComponent(UIVfx, equip_eff_back_point_path, EQUIP_BACK_EFF_PATH, effectParam)
  self.equipFrontEff = self:AddComponent(UIVfx, equip_eff_front_point_path, EQUIP_FRONT_EFF_PATH, frontVfxParam)
end

local function ComponentDestroy(self)
  self:PlayAni("idle")
  base.ComponentDestroy(self)
end

function TCCoreCardItemComponent:RefreshView()
  base.RefreshView(self)
  if not self.cardTemplate then
    return
  end
  self.starList:ReInit(self.cardStar)
end

function TCCoreCardItemComponent:CheckDisplayConfig(displayConfig)
  base.CheckDisplayConfig(self, displayConfig)
  if not displayConfig then
    self.starList:SetActive(true)
    return
  end
  if displayConfig.isShowStar ~= nil then
    self.starList:SetActive(displayConfig.isShowStar)
  end
  if displayConfig.isEquipEffShow then
    self:ShowEquipEff()
    self:PlayAni("idle")
    self:PlayAniQueue("Equip")
  end
end

function TCCoreCardItemComponent:RefreshFrameImg()
  base.RefreshFrameImg(self)
end

function TCCoreCardItemComponent:ShowEquipEff()
  self.equipBackEff:Replay()
  self.equipFrontEff:Replay()
end

function TCCoreCardItemComponent:ShowOpenBoxVfx()
  if self.vfx_openBox and self.cardTemplate then
    local quality = self.cardTemplate.color
    if quality == TacticalCardQualityType.Purple then
      self.vfx_openBox:PlayByStay(VfxAssets.TCCardOpenBoxCoreCardBgVfx_Purple)
    elseif quality == TacticalCardQualityType.Orange then
      self.vfx_openBox:PlayByStay(VfxAssets.TCCardOpenBoxCoreCardBgVfx_Gold)
    end
  end
end

function TCCoreCardItemComponent:ShowOpenBoxSingeVfx()
  if self.vfx_openBox and self.cardTemplate then
    local quality = self.cardTemplate.color
    if quality == TacticalCardQualityType.Purple then
      self.vfx_openBox:PlayByStay(VfxAssets.TCCardOpenBoxCoreCardBgVfx_Purple)
    elseif quality == TacticalCardQualityType.Orange then
      self.vfx_openBox:PlayByStay(VfxAssets.TCCardOpenBoxCoreCardBgVfx_Gold)
    elseif quality == TacticalCardQualityType.Blue then
      self.vfx_openBox:PlayByStay(VfxAssets.TCCardOpenBoxCoreCardBgVfx_Blue)
    elseif quality == TacticalCardQualityType.Green then
      self.vfx_openBox:PlayByStay(VfxAssets.TCCardOpenBoxCoreCardBgVfx_Green)
    end
  end
end

TCCoreCardItemComponent.ComponentDefine = ComponentDefine
TCCoreCardItemComponent.ComponentDestroy = ComponentDestroy
return TCCoreCardItemComponent
