local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIDecorationDazzleTipsView = BaseClass("UIDecorationDazzleTipsView", base)
local UIDecorationDazzleItem = require("UI.UIDecoration.UIDecorationDazzle.Component.UIDecorationDazzleItem")
local tipsText_path = "Root/ImgBg/Content/TipsText"
local scrollView_path = "Root/ImgBg/Content/ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearRewardScroll()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.tipsText = self:AddComponent(UIText, tipsText_path)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.tipsText = nil
  self.scrollView = nil
  base.ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshShow(self)
  base.RefreshShow(self)
  self:ClearRewardScroll()
  self.tipsText:SetText(self.param.tipsText or "")
  self.wearData = DataCenter.DecorationDataManager:GetSkinDataById(self.param.decorationId)
  self.buildingInfo = CS.SceneManager.World:GetPointInfo(LuaEntry.Player:GetMainWorldPos())
  local count = table.count(self.param.showList)
  if 0 < count then
    CS.UnityEngine.Canvas.ForceUpdateCanvases()
    self.scrollView:SetTotalCount(count + 1)
    self.scrollView:RefillCells()
  end
end

local function OnRewardItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scrollView:AddComponent(UIDecorationDazzleItem, itemObj)
  if item then
    local config = self.param.showList[index - 1]
    if config then
      item:InitData(index, self.param.decorationId, self.wearData, config)
    else
      item:InitOrigin(index, self.param.decorationId, self.wearData)
    end
  end
end

local function OnRewardItemMoveOut(self, itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UIDecorationDazzleItem)
end

local function ClearRewardScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIDecorationDazzleItem)
end

UIDecorationDazzleTipsView.OnCreate = OnCreate
UIDecorationDazzleTipsView.OnDestroy = OnDestroy
UIDecorationDazzleTipsView.OnEnable = OnEnable
UIDecorationDazzleTipsView.OnDisable = OnDisable
UIDecorationDazzleTipsView.ComponentDefine = ComponentDefine
UIDecorationDazzleTipsView.ComponentDestroy = ComponentDestroy
UIDecorationDazzleTipsView.DataDefine = DataDefine
UIDecorationDazzleTipsView.DataDestroy = DataDestroy
UIDecorationDazzleTipsView.RefreshShow = RefreshShow
UIDecorationDazzleTipsView.OnRewardItemMoveIn = OnRewardItemMoveIn
UIDecorationDazzleTipsView.OnRewardItemMoveOut = OnRewardItemMoveOut
UIDecorationDazzleTipsView.ClearRewardScroll = ClearRewardScroll
return UIDecorationDazzleTipsView
