local SeasonDeclareCityListGroup = BaseClass("SeasonDeclareCityListGroup", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local DetailItem = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareCityList.Component.SeasonDeclareCityListItem")

function SeasonDeclareCityListGroup:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, "Title")
  self.content = self:AddComponent(UIBaseContainer, "List")
end

function SeasonDeclareCityListGroup:OnDestroy()
  self:Clean()
  base.OnDestroy(self)
end

function SeasonDeclareCityListGroup:Clean()
  self.content:RemoveComponents(DetailItem)
  if self.theItemList ~= nil then
    for k, v in pairs(self.theItemList) do
      if v ~= nil and not IsNull(v.gameObject) then
        v.gameObject:GameObjectRecycle()
      end
    end
  end
  self.theItemList = nil
end

function SeasonDeclareCityListGroup:ReInit(curServerId, level, dataList, itemTemplate)
  self.theItem = itemTemplate
  self.curServerId = curServerId
  self.level = level
  if level < 8 then
    self.title:SetText("Level." .. level)
  else
    self.title:SetLocalText("season_sever_declare_war_006")
  end
  local cityCount = #dataList
  local full_height = 435
  if 3 < cityCount then
    local rowCount = math.ceil(cityCount / 3)
    full_height = 435 + 363 * (rowCount - 1)
  end
  self.full_height = full_height
  self:SetSizeDeltaXY(770, full_height)
  if self.theItemList ~= nil then
    for k, v in pairs(self.theItemList) do
      if v ~= nil then
        v:SetActive(false)
      end
    end
  end
  self.instCursor = 0
  self.activeDataList = dataList
end

function SeasonDeclareCityListGroup:Update100MS()
  local dataList = self.activeDataList
  if dataList == nil or self.instCursor == nil or self.instCursor >= #dataList then
    return
  end
  local cityInfoList, goItem, theItem
  local theItemList = self.theItemList or {}
  for i, v in ipairs(dataList) do
    if i > self.instCursor and i < self.instCursor + 4 then
      local NodeName = "item_" .. i
      theItem = theItemList[NodeName]
      if theItem == nil then
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = NodeName
        goItem:SetActive(true)
        theItem = self.content:AddComponent(DetailItem, NodeName)
        theItemList[NodeName] = theItem
      end
      theItem:ReInit(i, v, self.curServerId)
      theItem:SetActive(true)
    end
  end
  self.instCursor = self.instCursor + 3
  self.theItemList = theItemList
end

return SeasonDeclareCityListGroup
