local LWActivityPopView = BaseClass("LWActivityPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local HeroMonthCardPanel = require("UI.UIGiftPackage.Component.HeroMonthCard.HeroMonthCardMain")
local tagTypeTable = {}
tagTypeTable[EnumActivity.HeroMonthCard.Type] = {
  assetPath = UIAssets.UILWHeroMonthCardPop,
  cls = HeroMonthCardPanel
}

function LWActivityPopView:OnCreate()
  base.OnCreate(self)
  self.activityId = self:GetUserData()
  self:DataDefine()
  self:ComponentDefine()
  self:RefreshTabsData()
  if not table.IsNullOrEmpty(self.tabs) then
    self:SwitchPage(1)
  else
    self.ctrl:CloseSelf()
  end
end

function LWActivityPopView:OnDestroy()
  self:ClearAllContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWActivityPopView:DataDefine()
  self.packPrefabList = {}
  self.packCompList = {}
end

function LWActivityPopView:DataDestroy()
  self.packPrefabList = nil
  self.packCompList = nil
end

function LWActivityPopView:ComponentDefine()
  self.closeBg = self:AddComponent(UIButton, "closeBtn")
  self.closeBg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn2 = self:AddComponent(UIButton, "Root/TopBar/closeBtn2")
  self.closeBtn2:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.contentContainer = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/ContentContainer")
end

function LWActivityPopView:ComponentDestroy()
  self.closeBg = nil
  self.closeBtn2 = nil
  self.contentContainer = nil
end

function LWActivityPopView:RefreshTabsData()
  self.tabs = {}
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo then
    table.insert(self.tabs, {
      activityId = self.activityId,
      activityInfo = self.activityInfo
    })
  end
end

function LWActivityPopView:OnBackBtnClick()
  self.ctrl:CloseSelf()
end

function LWActivityPopView:SwitchPage(index)
  local hasData = false
  hasData = self.tabs[index] ~= nil
  if not hasData then
    return
  end
  self:OnSwitchTab(index)
end

function LWActivityPopView:OnSwitchTab(index)
  local activityId = self.tabs[index].activityId
  local activityInfo = self.tabs[index].activityInfo
  local activityType = activityInfo.type
  local handlerData
  handlerData = tagTypeTable[activityType]
  if not self.packPrefabList[activityType] and handlerData and handlerData.assetPath and handlerData.cls then
    self.packPrefabList[activityType] = self:GameObjectInstantiateAsync(handlerData.assetPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.contentContainer.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.name = tostring(activityType)
      go:SetActive(true)
      local pageComp = self.contentContainer:AddComponent(handlerData.cls, go.name)
      pageComp:SetOffsetMinXY(0, 0)
      pageComp:SetOffsetMaxXY(0, 0)
      self.packCompList[activityType] = pageComp
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(pageComp.rectTransform)
      self:RefreshCompData(index)
    end)
  else
    self:RefreshCompData(index)
  end
end

function LWActivityPopView:RefreshCompData(index)
  local activityId = self.tabs[index].activityId
  local activityInfo = self.tabs[index].activityInfo
  local activityType = activityInfo.type
  if self.packCompList[activityType] == nil then
    return
  end
  self.packCompList[activityType]:SetActive(true)
  local comp = self.packCompList[activityType]
  if comp and activityType == EnumActivity.HeroMonthCard.Type then
    comp:SetData(activityId)
    comp:SetBuyDiamondViewType(BuyDiamondViewType.PopUp)
  end
end

function LWActivityPopView:ClearAllContent()
  if self.packCompList ~= nil then
    for k, v in pairs(self.packCompList) do
      if v ~= nil then
        self:GameObjectDestroy(v.gameObject)
      end
    end
  end
  self.packCompList = {}
  if self.packPrefabList ~= nil then
    for k, v in pairs(self.packPrefabList) do
      if v ~= nil then
        self:GameObjectDestroy(v.gameObject)
      end
    end
  end
  self.packPrefabList = {}
end

return LWActivityPopView
