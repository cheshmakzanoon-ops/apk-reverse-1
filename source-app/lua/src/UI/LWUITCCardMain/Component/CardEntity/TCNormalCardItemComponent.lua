local CardBaseItem = require("UI.LWUITCCardMain.Component.CardEntity.TCCardBaseItem")
local TCNormalCardItemComponent = BaseClass("TCNormalCardItemComponent", CardBaseItem)
local base = CardBaseItem
local Localization = CS.GameEntry.Localization
TCNormalCardItemComponent.STANDARD_SIZE = {x = 130.9235, y = 195.1564}
TCNormalCardItemComponent.VISUAL_SIZE = {x = 130.9235, y = 195.1564}

local function ComponentDefine(self)
  base.ComponentDefine(self)
end

local function ComponentDestroy(self)
  self:PlayAni("idle")
  base.ComponentDestroy(self)
end

function TCNormalCardItemComponent:RefreshView(cardData)
  base.RefreshView(self)
  if not self.cardTemplate then
    return
  end
end

function TCNormalCardItemComponent:CheckDisplayConfig(displayConfig)
  base.CheckDisplayConfig(self, displayConfig)
  if not displayConfig then
    return
  end
  if displayConfig.isEquipEffShow then
    self:PlayAni("idle")
    self:PlayAniQueue("Equip")
  end
  if self.selectObjChildIcon then
    if displayConfig.isShowSelectStatusChildIcon ~= nil then
      self.selectObjChildIcon:SetActive(displayConfig.isShowSelectStatusChildIcon)
    else
      self.selectObjChildIcon:SetActive(true)
    end
  end
  if self.selectObjBorder then
    if displayConfig.selectBorderResPath ~= nil then
      self.selectObjBorder:LoadSprite(displayConfig.selectBorderResPath)
      self.selectObjBorder:SetSizeDeltaXY(179, 226)
      self.selectObjBorder:SetAnchoredPositionXY(0, 3)
      self.selectObjBorder:SetAlpha(1)
    else
      self.selectObjBorder:LoadSprite("Assets/Main/TextureEx/UILWTCTex/FX_zhanshukapai_putong_xuanzhongzhezhao.png")
      self.selectObjBorder:SetSizeDeltaXY(130, 187.5)
      self.selectObjBorder:SetAnchoredPositionXY(0, 0)
      self.selectObjBorder:SetAlpha(0.6)
    end
  end
end

function TCNormalCardItemComponent:RefreshFrameImg()
  base.RefreshFrameImg(self)
end

function TCNormalCardItemComponent:ShowOpenBoxVfx()
  if self.vfx_openBox and self.cardTemplate then
    local quality = self.cardTemplate.color
    if quality == TacticalCardQualityType.Purple then
      self.vfx_openBox:PlayByStay(VfxAssets.TCCardOpenBoxNormalCardBgVfx_Purple)
    end
  end
end

function TCNormalCardItemComponent:ShowOpenBoxSingeVfx()
  if self.vfx_openBox and self.cardTemplate then
    local quality = self.cardTemplate.color
    if quality == TacticalCardQualityType.Purple then
      self.vfx_openBox:PlayByStay(VfxAssets.TCCardOpenBoxNormalCardBgVfx_Purple)
    elseif quality == TacticalCardQualityType.Orange then
      self.vfx_openBox:PlayByStay(VfxAssets.TCCardOpenBoxNormalCardBgVfx_Gold)
    elseif quality == TacticalCardQualityType.Blue then
      self.vfx_openBox:PlayByStay(VfxAssets.TCCardOpenBoxNormalCardBgVfx_Blue)
    elseif quality == TacticalCardQualityType.Green then
      self.vfx_openBox:PlayByStay(VfxAssets.TCCardOpenBoxNormalCardBgVfx_Green)
    end
  end
end

TCNormalCardItemComponent.ComponentDefine = ComponentDefine
TCNormalCardItemComponent.ComponentDestroy = ComponentDestroy
return TCNormalCardItemComponent
