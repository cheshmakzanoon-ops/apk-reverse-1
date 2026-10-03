local UITacticalChipFactoryView = BaseClass("UITacticalChipFactoryView", UIBaseView)
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UITacticalChipFactoryView:OnCreate()
  base.OnCreate(self)
  self.buildingUuid, self.defaultTab, self.defaultTabParam = self:GetUserData()
  if not self.buildingUuid then
    Logger.LogError("buildingUuid is nil!")
    self:OnBtnCloseClick()
    return
  end
  self:ComponentDefine()
  self:DataDefine()
  self:InitTab()
end

function UITacticalChipFactoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITacticalChipFactoryView:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "SubPageNode/Top/title")
  self.textTitle:SetLocalText("battlesystem_factory_title1")
  self.compSubPageNode = self:AddComponent(UIBaseContainer, "SubPageNode")
  self.compTacticalChipFactoryTab1 = self:AddComponent(UICommonTab, "SubPageNode/Bottom/tabRoot/TacticalChipFactoryTab1")
  self.compTacticalChipFactoryTab2 = self:AddComponent(UICommonTab, "SubPageNode/Bottom/tabRoot/TacticalChipFactoryTab2")
  self.compTacticalChipFactoryTab3 = self:AddComponent(UICommonTab, "SubPageNode/Bottom/tabRoot/TacticalChipFactoryTab3")
  self.compCreatePageNode = self:AddComponent(UIBaseContainer, "SubPageNode/createPageNode")
  self.compDecomposePageNode = self:AddComponent(UIBaseContainer, "SubPageNode/decomposePageNode")
  self.compBagPageNode = self:AddComponent(UIBaseContainer, "SubPageNode/bagPageNode")
  self.btnClose = self:AddComponent(UIButton, "SubPageNode/Bottom/closeBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.subPageReqMap = {}
  self.subPageReqMap[TacticalChipFactoryPage.Create] = {
    node = self.compCreatePageNode
  }
  self.subPageReqMap[TacticalChipFactoryPage.Decompose] = {
    node = self.compDecomposePageNode
  }
  self.subPageReqMap[TacticalChipFactoryPage.Bag] = {
    node = self.compBagPageNode
  }
end

function UITacticalChipFactoryView:ComponentDestroy()
  self.textTitle = nil
  self.compSubPageNode = nil
  self.compTacticalChipFactoryTab1 = nil
  self.compTacticalChipFactoryTab2 = nil
  self.compTacticalChipFactoryTab3 = nil
  self.btnClose = nil
  self.compCreatePageNode = nil
  self.compDecomposePageNode = nil
  self.compBagPageNode = nil
end

function UITacticalChipFactoryView:DataDefine()
end

function UITacticalChipFactoryView:DataDestroy()
  self.curTab = nil
  for i, v in pairs(self.subPageReqMap) do
    v.req = nil
    v.node = nil
    v.script = nil
  end
  self.subPageReqMap = nil
end

function UITacticalChipFactoryView:InitTab()
  local createPageParam = {}
  createPageParam.tabId = TacticalChipFactoryPage.Create
  createPageParam.title = Localization:GetString("battlesystem_factory_title2")
  createPageParam.clickHandler = self.OnTabClick
  createPageParam.containPanel = self.compCreatePageNode
  self.compTacticalChipFactoryTab1:ReInit(createPageParam)
  self.compTacticalChipFactoryTab1:SetSelect(false)
  local decomposePageParam = {}
  decomposePageParam.tabId = TacticalChipFactoryPage.Decompose
  decomposePageParam.title = Localization:GetString("battlesystem_factory_title3")
  decomposePageParam.clickHandler = self.OnTabClick
  decomposePageParam.containPanel = self.compDecomposePageNode
  self.compTacticalChipFactoryTab2:ReInit(decomposePageParam)
  self.compTacticalChipFactoryTab2:SetSelect(false)
  local bagPageParam = {}
  bagPageParam.tabId = TacticalChipFactoryPage.Bag
  bagPageParam.title = Localization:GetString("battlesystem_factory_title4")
  bagPageParam.clickHandler = self.OnTabClick
  bagPageParam.containPanel = self.compBagPageNode
  self.compTacticalChipFactoryTab3:ReInit(bagPageParam)
  self.compTacticalChipFactoryTab3:SetSelect(false)
  local tabMap = {
    [TacticalChipFactoryPage.Create] = self.compTacticalChipFactoryTab1,
    [TacticalChipFactoryPage.Decompose] = self.compTacticalChipFactoryTab2,
    [TacticalChipFactoryPage.Bag] = self.compTacticalChipFactoryTab3
  }
  if self.defaultTab == nil then
    self.defaultTab = TacticalChipFactoryPage.Create
  end
  self:OnTabClick(tabMap[self.defaultTab])
end

function UITacticalChipFactoryView:OnTabClick(tabItem)
  if self.curTab ~= nil then
    if self.curTab.tabId == tabItem.tabId then
      return
    else
      self.curTab:SetSelect(false)
      local req = self.subPageReqMap[self.curTab.tabId].req
      if req and req.isDone then
        self.subPageReqMap[self.curTab.tabId].script:SetActive(false)
      else
        self.subPageReqMap[self.curTab.tabId].node:SetActive(false)
      end
    end
  end
  self.curTab = tabItem
  self.curTab:SetSelect(true)
  local req = self.subPageReqMap[self.curTab.tabId].req
  local node = self.subPageReqMap[self.curTab.tabId].node
  node:SetActive(true)
  if req == nil then
    self.subPageReqMap[self.curTab.tabId].req = self:CreatePageRes(self.curTab.tabId)
  elseif req.isDone then
    self.subPageReqMap[self.curTab.tabId].script:ReInit(self.buildingUuid)
    self.subPageReqMap[self.curTab.tabId].script:SetActive(true)
  end
end

function UITacticalChipFactoryView:CreatePageRes(pageId)
  if pageId == nil then
    return nil
  end
  return self:GameObjectInstantiateAsync(self:GetPageResPath(pageId), function(request)
    local pageObj = request.gameObject
    if pageObj == nil then
      return
    end
    pageObj.transform:SetParent(self.subPageReqMap[pageId].node.transform)
    pageObj.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    pageObj.transform:Set_localEulerAngles(ResetEulerAngles.x, ResetEulerAngles.y, ResetEulerAngles.z)
    pageObj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    pageObj:SetActive(true)
    local script = self.subPageReqMap[pageId].node:AddComponent(self:GetPageScript(pageId), pageObj.name)
    self.subPageReqMap[pageId].script = script
    script:SetOffsetMinXY(0, 0)
    script:SetOffsetMaxXY(0, 0)
    if self.curTab.tabId == pageId then
      script:ReInit(self.buildingUuid)
      script:SetActive(true)
      if self.curTab.tabId == self.defaultTab then
        self.subPageReqMap[self.curTab.tabId].script:SetCustomParam(self.defaultTabParam)
      end
    end
  end)
end

function UITacticalChipFactoryView:GetPageResPath(pageId)
  local path
  if pageId == TacticalChipFactoryPage.Create then
    path = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipFactory/TacticalChipFactoryCreatePage.prefab"
  elseif pageId == TacticalChipFactoryPage.Decompose then
    path = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipFactory/TacticalChipFactoryDecomposePage.prefab"
  elseif pageId == TacticalChipFactoryPage.Bag then
    path = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipFactory/TacticalChipFactoryBagPage.prefab"
  end
  if path == nil then
    Logger.LogError("not path!  pageId:" .. pageId)
  end
  return path
end

function UITacticalChipFactoryView:GetPageScript(pageId)
  local scriptPath
  if pageId == TacticalChipFactoryPage.Create then
    scriptPath = "UI.UITacticalChipFactory.Component.Create.TacticalChipFactoryCreatePage"
  elseif pageId == TacticalChipFactoryPage.Decompose then
    scriptPath = "UI.UITacticalChipFactory.Component.Decompose.TacticalChipFactoryDecomposePage"
  elseif pageId == TacticalChipFactoryPage.Bag then
    scriptPath = "UI.UITacticalChipFactory.Component.Bag.TacticalChipFactoryBagPage"
  end
  if scriptPath == nil then
    Logger.LogError("not path!  pageId:" .. pageId)
  end
  return require(scriptPath)
end

function UITacticalChipFactoryView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UITacticalChipFactoryView:CheckFirstEnterSystemGuide()
  if DataCenter.LWGuideFlowManager.Runner:IsRun() then
    return
  end
  if not DataCenter.LWGuideFlowManager:ReadDone(4003) then
    DataCenter.LWGuideFlowManager.Runner:Run(4003)
  end
end

return UITacticalChipFactoryView
