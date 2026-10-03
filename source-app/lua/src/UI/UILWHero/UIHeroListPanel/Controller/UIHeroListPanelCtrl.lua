local UIHeroListPanelCtrl = BaseClass("UIHeroListPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  if self.isArrow ~= nil and self.isArrow == CurScene.PVEScene then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroListPanel, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  else
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroListPanel, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllShow
    })
  end
  DataCenter.HeroDataManager:StopMainUIRedPoint()
  if self.callback then
    self.callback()
  end
end

local function InitData(self, isArrow, callback)
  self.isArrow = isArrow or nil
  self.callback = callback
end

local function GenerateHeroDataList(self, condition)
  return HeroUtils.GenerateHeroDataList(condition)
end

UIHeroListPanelCtrl.CloseSelf = CloseSelf
UIHeroListPanelCtrl.InitData = InitData
UIHeroListPanelCtrl.GenerateHeroDataList = GenerateHeroDataList
return UIHeroListPanelCtrl
