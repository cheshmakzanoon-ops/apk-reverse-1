local UIBuildZero = BaseClass("UIBuildZero", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIBuildZeroItem = require("UI.UIBuildZero.Component.UIBuildZeroItem")
local panel_path = "Root/Panel"
local close_path = "Root/Close"
local icon_path = "Root/Left/Icon"
local title_path = "Root/Left/TitleBg/Title"
local desc_path = "Root/Left/Desc"
local scroll_view_path = "Root/ScrollView"
local repair_btn_path = "Root/Left/RepairBtn"
local repair_text_path = "Root/Left/RepairBtn/RepairText"
local UIGray = CS.UIGray

function UIBuildZero:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UIBuildZero:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIBuildZero:OnEnable()
  base.OnEnable(self)
end

function UIBuildZero:OnDisable()
  base.OnDisable(self)
end

function UIBuildZero:ComponentDefine()
  self.panel_btn = self:AddComponent(UIButton, panel_path)
  self.panel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.icon_image = self:AddComponent(UIImage, icon_path)
  self.title_text = self:AddComponent(UIText, title_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.repair_btn = self:AddComponent(UIButton, repair_btn_path)
  self.repair_btn:SetOnClick(function()
    self:OnRepairClick()
  end)
  self.repair_text = self:AddComponent(UIText, repair_text_path)
end

function UIBuildZero:ComponentDestroy()
  self.panel_btn = nil
  self.close_btn = nil
  self.icon_image = nil
  self.title_text = nil
  self.desc_text = nil
  self.scroll_view = nil
  self.repair_btn = nil
  self.repair_text = nil
end

function UIBuildZero:DataDefine()
  self.buildData = nil
  self.needList = {}
  self.ret = nil
  self.buildUuid = nil
  self.cell = {}
end

function UIBuildZero:DataDestroy()
  self.buildData = nil
  self.needList = {}
  self.ret = nil
  self.buildUuid = nil
  self.cell = {}
end

function UIBuildZero:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshSignal)
  self:AddUIListener(EventId.RefreshResourceItem, self.RefreshSignal)
  self:AddUIListener(EventId.UpdateGold, self.RefreshSignal)
  self:AddUIListener(EventId.ResourceUpdated, self.RefreshSignal)
end

function UIBuildZero:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshSignal)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.RefreshSignal)
  self:RemoveUIListener(EventId.ResourceUpdated, self.RefreshSignal)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshSignal)
end

function UIBuildZero:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UIBuildZeroItem, itemObj)
  item:ReInit(self.needList[index])
  self.cell[index] = item
end

function UIBuildZero:OnDeleteCell(itemObj, index)
  self.cell[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, UIBuildZeroItem)
end

function UIBuildZero:ShowScroll()
  self:ClearScroll()
  local count = #self.needList
  self.scroll_view:SetTotalCount(count)
  if 0 < count then
    self.scroll_view:RefillCells()
  end
end

function UIBuildZero:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIBuildZeroItem)
end

function UIBuildZero:ReInit()
  self.buildUuid = self:GetUserData()
  self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
  if self.buildData == nil then
    return
  end
  self.desc_text:SetLocalText(GameDialogDefine.BUILD_ZERO_REPAIR_DES)
  self.repair_text:SetLocalText(GameDialogDefine.REPAIR_FIX)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildData.itemId)
  self.title_text:SetLocalText(buildTemplate.name)
  self.icon_image:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.buildData.itemId, 0))
  self:Refresh()
end

function UIBuildZero:OnRepairClick()
  if self.ret.enough then
    DataCenter.BuildManager:UpgradeBuilding(self.buildUuid)
    self.ctrl:CloseSelf()
  end
end

function UIBuildZero:RefreshSignal()
  self:Refresh()
end

function UIBuildZero:Refresh()
  self.needList = {}
  local stockInfo = DataCenter.BuildUpgradeStockManager:GetUpgradeStockById(self.buildUuid)
  self.ret = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(self.buildUuid)
  if self.ret.needPeopleNum > 0 then
    local param = {}
    param.needType = CommonCostNeedType.Resource
    param.resourceType = ResourceType.People
    param.hasSubmitCount = 0
    param.count = self.ret.needPeopleNum
    param.isRed = self.ret.lackResourceDict[param.resourceType] ~= nil
    param.goName = param.resourceType
    param.icon = DataCenter.ResourceManager:GetResourceIconByType(param.resourceType)
    param.name = DataCenter.ResourceManager:GetResourceNameByType(param.resourceType)
    param.has = LuaEntry.Resource:GetCntByResType(param.resourceType)
    param.uuid = self.buildUuid
    table.insert(self.needList, param)
  end
  for _, v in ipairs(self.ret.needResource) do
    local param = {}
    param.needType = CommonCostNeedType.Resource
    param.resourceType = v.resourceType
    if stockInfo == nil then
      param.hasSubmitCount = 0
    else
      param.hasSubmitCount = stockInfo:GetSubmitCountByResource(v.resourceType)
    end
    param.count = v.count - param.hasSubmitCount
    param.isRed = self.ret.lackResourceDict[v.resourceType] ~= nil
    param.goName = param.resourceType
    param.icon = DataCenter.ResourceManager:GetResourceIconByType(param.resourceType)
    param.name = DataCenter.ResourceManager:GetResourceNameByType(param.resourceType)
    param.has = LuaEntry.Resource:GetCntByResType(v.resourceType)
    if param.has < param.count then
      param.diamond = CommonUtil.GetResGoldByType(v.resourceType, param.count - param.has)
    end
    param.uuid = self.buildUuid
    table.insert(self.needList, param)
  end
  for _, v in ipairs(self.ret.needResItem) do
    local param = {}
    param.needType = CommonCostNeedType.ResourceItem
    param.resItemId = v.itemId
    if stockInfo == nil then
      param.hasSubmitCount = 0
    else
      param.hasSubmitCount = stockInfo:GetSubmitCountByResourceItem(v.itemId)
    end
    param.count = v.count - param.hasSubmitCount
    param.isRed = self.ret.lackResItemDict[v.itemId] ~= nil
    param.goName = param.resItemId
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(v.itemId)
    if template ~= nil then
      param.name = Localization:GetString(template.name)
      param.icon = string.format(LoadPath.ItemPath, template.pic)
    end
    param.has = DataCenter.ResourceItemDataManager:GetCountByItemId(v.itemId)
    if param.has < param.count then
      local _, diamondNum = DataCenter.ResourceItemDataManager:GetResourceItemBuyPriceTotal(v.itemId, param.count - param.has)
      param.diamond = diamondNum
    end
    param.uuid = self.buildUuid
    table.insert(self.needList, param)
  end
  for _, v in ipairs(self.ret.needItem) do
    local param = {}
    param.needType = CommonCostNeedType.Goods
    param.itemId = v.itemId
    if stockInfo == nil then
      param.hasSubmitCount = 0
    else
      param.hasSubmitCount = stockInfo:GetSubmitCountByItem(v.itemId)
    end
    param.count = v.num - param.hasSubmitCount
    param.isRed = self.ret.lackItemDict[v.itemId] ~= nil
    param.goName = param.itemId
    param.icon = DataCenter.ItemTemplateManager:GetIconPath(v.itemId)
    param.name = DataCenter.ItemTemplateManager:GetName(v.itemId)
    param.has = DataCenter.ItemData:GetItemCount(v.itemId)
    if param.has < param.count then
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
      if itemTemplate ~= nil then
        param.diamond = (param.count - param.has) * itemTemplate.price
      end
    end
    param.uuid = self.buildUuid
    table.insert(self.needList, param)
  end
  UIGray.SetGray(self.repair_btn.transform, not self.ret.enough, self.ret.enough)
  self:ShowScroll()
end

return UIBuildZero
