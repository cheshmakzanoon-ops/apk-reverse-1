local UILWSeasonCityAttachmentTabBuild = BaseClass("UILWSeasonCityAttachmentTabBuild", UIAsyncContainer)
local base = UIAsyncContainer
local BuildCell = require("UI.LWSeason1.UILWSeasonCityAttachment.Component.UILWSeasonCityAttachmentBuildCell")

function UILWSeasonCityAttachmentTabBuild:OnCreate()
  base.OnCreate(self)
  local offsetMin = self.rectTransform.offsetMin
  local offsetMax = self.rectTransform.offsetMax
  self.rectTransform:Set_offsetMin(offsetMin.x, 0)
  self.rectTransform:Set_offsetMax(offsetMax.x, 0)
  self.items = {}
  self.no_data = self:AddComponent(UITextMeshProUGUIEx, "NoData")
  self.content = self:AddComponent(UIBaseContainer, "Viewport/Content")
  self.ScrollView = self:AddComponent(UILoopGridView, "")
  self.ScrollView:InitGridView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
end

function UILWSeasonCityAttachmentTabBuild:OnDestroy()
  self.items = {}
  self.content:RemoveComponents(BuildCell)
  self.ScrollView:ClearAllItems()
  self.dataList = nil
  self.no_data = nil
  base.OnDestroy(self)
end

function UILWSeasonCityAttachmentTabBuild:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CityAttachmentALLRewardFinish, self.OnBatchCollectResourceSuccess)
end

function UILWSeasonCityAttachmentTabBuild:OnRemoveListener()
  self:RemoveUIListener(EventId.CityAttachmentALLRewardFinish, self.OnBatchCollectResourceSuccess)
  base.OnRemoveListener(self)
end

function UILWSeasonCityAttachmentTabBuild:OnBatchCollectResourceSuccess()
  if self.dataList then
    for k, v in pairs(self.dataList) do
      if v then
        v.leftNum = 0
      end
    end
  end
end

function UILWSeasonCityAttachmentTabBuild:ReInit(isFarmer, allianceBuildInfo)
  self.isFarmer = isFarmer
  self.allianceBuildInfo = allianceBuildInfo
  self:UpdateData()
end

function UILWSeasonCityAttachmentTabBuild:UpdateData()
  local allianceBuildInfo = self.allianceBuildInfo
  local isFarmer = self.isFarmer
  if IsNull(self.gameObject) or allianceBuildInfo == nil then
    return
  end
  local ownerList = allianceBuildInfo.ownerList or {}
  local rewardList = allianceBuildInfo.rewardList or {}
  local buildCount = #ownerList
  if buildCount == 0 and rewardList ~= nil then
    for k, v in pairs(rewardList) do
      if v and 0 < toInt(v.leftNum) then
        buildCount = buildCount + 1
      end
    end
  end
  self.no_data:SetActive(buildCount == 0)
  if buildCount == 0 then
    if isFarmer then
      self.no_data:SetLocalText("season_builders_alliance_UI_45")
    else
      self.no_data:SetLocalText("season_builders_alliance_UI_67")
    end
    self.content:RemoveComponents(BuildCell)
    self.ScrollView:ClearAllItems()
  else
    local dataList = {}
    for k, v in pairs(ownerList) do
      if v.state == nil then
        v.state = 0
      end
      v.leftNum = 0
      dataList[v.pointId] = v
    end
    for k, v in pairs(rewardList) do
      if v and 0 < toInt(v.leftNum) then
        v.original = dataList[v.pointId]
        dataList[v.pointId] = v
      end
    end
    dataList = table.values(dataList)
    table.sort(dataList, function(a, b)
      if a.original == nil and b.original ~= nil then
        return true
      end
      if b.original == nil and a.original ~= nil then
        return false
      end
      if a.original == nil and b.original == nil then
        if a.leftNum == b.leftNum then
          return a.pointId > b.pointId
        end
        return a.leftNum > b.leftNum
      end
      if a.state == b.state then
        if a.buildId == b.buildId then
          return a.pointId > b.pointId
        end
        return a.buildId > b.buildId
      end
      return a.state > b.state
    end)
    self.dataList = dataList
    self.ScrollView:SetListItemCount(#self.dataList, false, false)
    self.ScrollView:RefreshAllShownItem()
  end
end

function UILWSeasonCityAttachmentTabBuild:TryGetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("BuildItem")
  local data = dataList[index]
  if self.items[csItem] == nil then
    local nameStr = "Cell" .. NameCount
    csItem.gameObject.name = nameStr
    NameCount = NameCount + 1
    self.items[csItem] = self.content:AddComponent(BuildCell, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(index, data)
  end
  return csItem
end

return UILWSeasonCityAttachmentTabBuild
