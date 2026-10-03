local UIScratchSelectHeroItem = BaseClass("UIScratchSelectHeroItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")

function UIScratchSelectHeroItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIScratchSelectHeroItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIScratchSelectHeroItem:OnEnable()
  base.OnEnable(self)
end

function UIScratchSelectHeroItem:OnDisable()
  base.OnDisable(self)
end

function UIScratchSelectHeroItem:ComponentDefine()
  self.hero = self:AddComponent(UIHeroCell, "UIHeroCellSmall")
  self.select_btn = self:AddComponent(UIButton, "UIHeroCellSmall")
  self.select_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self._num_txt = self:AddComponent(UIText, "Txt_Num")
end

function UIScratchSelectHeroItem:ComponentDestroy()
  self.hero = nil
  self._num_txt = nil
end

function UIScratchSelectHeroItem:DataDefine()
  self.param = {}
end

function UIScratchSelectHeroItem:DataDestroy()
  self.param = nil
end

function UIScratchSelectHeroItem:RefreshData(param)
  self.param = param
  self.hero:InitWithConfigId(self.param.heroId, self.param.quality, "1")
  self._num_txt:SetText(self.param.name)
end

function UIScratchSelectHeroItem:OnBtnClick()
  if self.param.callback ~= nil then
    self.param.callback(self.transform, tonumber(self.param.index))
  end
end

return UIScratchSelectHeroItem
