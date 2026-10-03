local UICapacityBoxHeroItem = BaseClass("UICapacityBoxHeroItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local UIHeroCellDefaultPos = 8.9

function UICapacityBoxHeroItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICapacityBoxHeroItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICapacityBoxHeroItem:OnEnable()
  base.OnEnable(self)
end

function UICapacityBoxHeroItem:OnDisable()
  base.OnDisable(self)
end

function UICapacityBoxHeroItem:ComponentDefine()
  self.hero = self:AddComponent(UIHeroCell, "UIHeroCellSmall")
  self.select_btn = self:AddComponent(UIButton, "UIHeroCellSmall")
  self.select_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self._num_txt = self:AddComponent(UIText, "Txt_Num")
end

function UICapacityBoxHeroItem:ComponentDestroy()
  self.hero = nil
  self._num_txt = nil
end

function UICapacityBoxHeroItem:DataDefine()
  self.param = {}
end

function UICapacityBoxHeroItem:DataDestroy()
  self.param = nil
end

function UICapacityBoxHeroItem:RefreshData(param)
  self.param = param
  self.hero:InitWithConfigId(self.param.heroId, self.param.quality, param.showLv or "1", 1)
  self._num_txt:SetText(self.param.name .. " x" .. self.param.count)
  if param.iconScale then
    self.hero.transform:Set_localScale(param.iconScale, param.iconScale, param.iconScale)
  else
    self.hero.transform:Set_localScale(1, 1, 1)
  end
  local x = self.hero.rectTransform.anchoredPosition.x
  local y = param.heroIconYPos or UIHeroCellDefaultPos
  self.hero.rectTransform:Set_anchoredPosition(x, y)
end

function UICapacityBoxHeroItem:OnBtnClick()
  if self.param.callback ~= nil then
    self.param.callback(self.transform, tonumber(self.param.heroId))
  end
end

function UICapacityBoxHeroItem:RefreshCount(count)
  if not self.param then
    return
  end
  self.param.count = count
  self._num_txt:SetText(self.param.name .. " x" .. count)
end

return UICapacityBoxHeroItem
