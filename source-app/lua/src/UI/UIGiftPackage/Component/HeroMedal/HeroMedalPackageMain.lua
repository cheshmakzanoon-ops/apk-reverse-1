local HeroMedalPackageMain = BaseClass("HeroMedalPackageMain", UIBaseView)
local base = UIBaseView
local HeroMedalPackagePack = require("UI.UIGiftPackage.Component.HeroMedal.HeroMedalPackagePack")
local svPacks_path = "Scroll"
local emptyTip_path = "WarnGo/WarnText"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self:UpdateCacheHeroMedalPack()
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.svPacksN = self:AddComponent(UIScrollView, svPacks_path)
  self.svPacksN:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.svPacksN:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.emptyTipN = self:AddComponent(UIText, emptyTip_path)
  self.emptyTipN:SetText("")
end

local function ComponentDestroy(self)
  self.svPacksN = nil
end

local function DataDefine(self)
  self.heroPackList = {}
end

local function DataDestroy(self)
  self.heroPackList = nil
end

local function ReInit(self)
  self.heroPackList = GiftPackageData.GetHeroMedalPackageList()
  self:RefreshPacks()
end

local function RefreshPacks(self)
  if #self.heroPackList > 0 then
    self.svPacksN:SetActive(true)
    self.emptyTipN:SetActive(false)
    self.svPacksN:SetTotalCount(#self.heroPackList)
    self.svPacksN:RefillCells()
    self.svPacksN:SetActive(false)
    self.svPacksN:SetActive(true)
  else
    self.svPacksN:SetActive(false)
    self.emptyTipN:SetActive(true)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local packItem = self.svPacksN:AddComponent(HeroMedalPackagePack, itemObj)
  local tempPackage = self.heroPackList[index]
  packItem:SetItem(tempPackage, self.svPacksN)
end

local function OnItemMoveOut(self, itemObj, index)
  self.svPacksN:RemoveComponent(itemObj.name, HeroMedalPackagePack)
end

local function UpdateCacheHeroMedalPack(self)
  local packList = GiftPackageData.GetHeroMedalPackageList()
  local strHeros = ""
  for i, v in ipairs(packList) do
    strHeros = strHeros .. ";" .. v.heroId
  end
  CS.GameEntry.Setting:SetString("CacheHeroMedalPack_" .. LuaEntry.Player.uid, strHeros)
end

HeroMedalPackageMain.OnCreate = OnCreate
HeroMedalPackageMain.OnDestroy = OnDestroy
HeroMedalPackageMain.OnAddListener = OnAddListener
HeroMedalPackageMain.OnRemoveListener = OnRemoveListener
HeroMedalPackageMain.ComponentDefine = ComponentDefine
HeroMedalPackageMain.ComponentDestroy = ComponentDestroy
HeroMedalPackageMain.DataDefine = DataDefine
HeroMedalPackageMain.DataDestroy = DataDestroy
HeroMedalPackageMain.OnEnable = OnEnable
HeroMedalPackageMain.OnDisable = OnDisable
HeroMedalPackageMain.ReInit = ReInit
HeroMedalPackageMain.InitData = InitData
HeroMedalPackageMain.RefreshPacks = RefreshPacks
HeroMedalPackageMain.OnItemMoveIn = OnItemMoveIn
HeroMedalPackageMain.OnItemMoveOut = OnItemMoveOut
HeroMedalPackageMain.UpdateCacheHeroMedalPack = UpdateCacheHeroMedalPack
return HeroMedalPackageMain
