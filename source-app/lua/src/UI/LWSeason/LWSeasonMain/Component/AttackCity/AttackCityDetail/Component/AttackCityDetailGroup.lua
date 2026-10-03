local SeasonAttackCityDetailGroup = BaseClass("SeasonAttackCityDetailGroup", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local DetailItem = require("UI.LWSeason.LWSeasonMain.Component.AttackCity.AttackCityDetail.Component.AttackCityDetailItem")
local title_path = "Title"
local open_path = "Title/open"
local list_path = "List"

function SeasonAttackCityDetailGroup:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, title_path)
  self.open = self:AddComponent(UIText, open_path)
  self.content = self:AddComponent(UIBaseContainer, list_path)
end

function SeasonAttackCityDetailGroup:OnDestroy()
  self:Clean()
  base.OnDestroy(self)
end

function SeasonAttackCityDetailGroup:Clean()
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

function SeasonAttackCityDetailGroup:ReInit(level, dataList, itemTemplate, cityWarInfo, DeclareWarList)
  self.cityWarInfo = cityWarInfo
  self.openTime = nil
  self.theItem = itemTemplate
  self.level = level
  self.title:SetText("Level." .. level)
  self.open:SetText("")
  if cityWarInfo ~= nil and cityWarInfo.noOpenList ~= nil then
    local mgr = DataCenter.AllianceCityTemplateManager
    for k, v in pairs(cityWarInfo.noOpenList) do
      local info = mgr:GetTemplate(v.cityId)
      if info and info.level == level and info:IsCity() then
        self.openTime = v.openTime
        self:Update1000MS()
        break
      end
    end
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
  if 0 < #DeclareWarList then
    local theDataList = {}
    for i, v in ipairs(dataList) do
      if DeclareWarList[tostring(v.id)] ~= nil then
        table.insert(theDataList, 1, v)
      else
        table.insert(theDataList, v)
      end
    end
    dataList = theDataList
  end
  self.instCursor = 0
  self.activeDataList = dataList
  self:Update100MS()
end

function SeasonAttackCityDetailGroup:SetLinkTitle(node)
  self.linkOpenTitle = node
end

function SeasonAttackCityDetailGroup:Update1000MS()
  if self.openTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.openTime - curTime
    if 0 < remainTime then
      self.open:SetLocalText("110129", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.open:SetText("")
      self.openTime = nil
    end
    if self.linkOpenTitle then
      self.linkOpenTitle:SetText(self.open:GetText())
    end
  end
end

function SeasonAttackCityDetailGroup:Update100MS()
  local dataList = self.activeDataList
  if dataList == nil or self.instCursor == nil or self.instCursor >= #dataList then
    return
  end
  local cityWarInfo = self.cityWarInfo
  local cityInfoList, goItem, theItem
  local theItemList = self.theItemList or {}
  if cityWarInfo ~= nil then
    cityInfoList = cityWarInfo.cityInfoList
  else
    cityInfoList = {}
  end
  for i, v in ipairs(dataList) do
    if v ~= nil and v.IsCity ~= nil and v:IsCity() and i > self.instCursor and i < self.instCursor + 4 then
      local NodeName = "item_" .. i
      theItem = theItemList[NodeName]
      if theItem == nil then
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = NodeName
        goItem:SetActive(true)
        theItem = self.content:AddComponent(DetailItem, NodeName)
        theItemList[NodeName] = theItem
      end
      theItem:ReInit(i, v, cityInfoList[v.id], self.openTime)
      theItem:SetActive(true)
    end
  end
  self.instCursor = self.instCursor + 3
  self.theItemList = theItemList
end

return SeasonAttackCityDetailGroup
