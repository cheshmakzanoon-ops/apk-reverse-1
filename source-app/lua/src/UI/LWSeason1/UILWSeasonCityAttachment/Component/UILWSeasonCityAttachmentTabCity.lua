local UILWSeasonCityAttachmentTabCity = BaseClass("UILWSeasonCityAttachmentTabCity", UIAsyncContainer)
local base = UIAsyncContainer
local CityAttachmentItem = require("UI.LWSeason1.UILWSeasonCityAttachment.Component.UILWSeasonCityAttachmentItem")

function UILWSeasonCityAttachmentTabCity:OnCreate()
  base.OnCreate(self)
  local offsetMin = self.rectTransform.offsetMin
  local offsetMax = self.rectTransform.offsetMax
  self.rectTransform:Set_offsetMin(offsetMin.x, 0)
  self.rectTransform:Set_offsetMax(offsetMax.x, 0)
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "Viewport/Content")
  self.ScrollView = self:AddComponent(UILoopListView2, "")
  self.ScrollView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
end

function UILWSeasonCityAttachmentTabCity:OnDestroy()
  self.items = {}
  self.content:RemoveComponents(CityAttachmentItem)
  self.ScrollView:ClearAllItems()
  self.dataList = nil
  base.OnDestroy(self)
end

function UILWSeasonCityAttachmentTabCity:ReInit(isFarmer, allianceBuildInfo)
  self.isFarmer = isFarmer
  self.allianceBuildInfo = allianceBuildInfo
  self:UpdateData()
end

function UILWSeasonCityAttachmentTabCity:UpdateData()
  local allianceBuildInfo = self.allianceBuildInfo
  local isFarmer = self.isFarmer
  if IsNull(self.gameObject) or allianceBuildInfo == nil then
    return
  end
  local dataList = {}
  local buildList = DataCenter.SeasonFarmerTemplateManager:GetALLBuildTemplate()
  if buildList then
    for k, v in pairs(buildList) do
      if v and v.buildType == 1 then
        table.insert(dataList, v)
      end
    end
    table.sort(dataList, function(a, b)
      if a.order == b.order then
        return a.cfgId < b.cfgId
      end
      return a.order < b.order
    end)
  end
  self.dataList = dataList
  self.ScrollView:SetListItemCount(#self.dataList, false, false)
  self.ScrollView:RefreshAllShownItem()
end

function UILWSeasonCityAttachmentTabCity:TryGetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("BuildCell")
  local data = dataList[index]
  if self.items[csItem] == nil then
    local nameStr = "Cell" .. NameCount
    csItem.gameObject.name = nameStr
    NameCount = NameCount + 1
    self.items[csItem] = self.content:AddComponent(CityAttachmentItem, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(index, data)
  end
  return csItem
end

return UILWSeasonCityAttachmentTabCity
