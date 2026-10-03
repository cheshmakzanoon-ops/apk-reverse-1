local LimitedTimeFeastNoticeNewItem = BaseClass("LimitedTimeFeastNoticeNewItem", UIBaseContainer)
local base = UIBaseContainer
local LimitedTimeFeastNoticeCell = require("UI.LimitedTimeFeastNotice.Component.LimitedTimeFeastNoticeCell")
local Localization = CS.GameEntry.Localization
local name_path = "Name"
local content_path = "Content"
local bg = "bg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.content = self:AddComponent(UILayoutElement, content_path)
  self.Bg = self:TryAddComponent(UIImage, bg)
  self.itemReqs = {}
  self.itemList = {}
end

local function ComponentDestroy(self)
  self:ClearContent()
  self.name = nil
  self.content = nil
  self.Bg = nil
  self.itemReqs = nil
  self.itemList = nil
end

local function ClearContent(self)
  if table.count(self.itemList) > 0 then
    self.content:RemoveComponents(LimitedTimeFeastNoticeCell)
    self.itemList = {}
  end
  if table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      self:GameObjectDestroy(req)
    end
    self.itemReqs = {}
  end
end

local function SetData(self, inData, scroll_view, index, activityId)
  self.inData = inData
  self.scroll_view = scroll_view
  self.index = index
  self.param = self.inData.data
  self.name:SetLocalText(self.param.name)
  self.showData = {}
  local dropInfoId = self.param.drop_info_para
  local dropInfoDetail = GetTableData(TableName.DropInfoDetail, dropInfoId, "dropInfoDetail")
  local dropList = string.split(dropInfoDetail, "|")
  for index, v in ipairs(dropList) do
    local dropItem = string.split(v, ";")
    if #dropItem == 4 then
      local type = tonumber(dropItem[1])
      local id = tonumber(dropItem[2])
      local num = tonumber(dropItem[3])
      local rate = tonumber(dropItem[4])
      rate = rate * 100
      table.insert(self.showData, {
        type = type,
        id = id,
        num = num,
        rate = rate,
        sortIndex = index
      })
    end
  end
  self:ClearContent()
  if not table.IsNullOrEmpty(self.showData) then
    for i, data in pairs(self.showData) do
      local req = self:GameObjectInstantiateAsync(UIAssets.LimitedTimeFeastNoticeCell, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = i
        item:SetActive(true)
        item.transform:SetParent(self.content.transform)
        item.transform:Set_localScale(1, 1, 1)
        local cell = self.content:AddComponent(LimitedTimeFeastNoticeCell, item.name)
        table.insert(self.itemList, cell)
        cell:SetData(data)
      end)
      table.insert(self.itemReqs, req)
    end
  end
  local oneLineNum = 5
  local line = math.ceil(#self.showData / oneLineNum)
  local height = 160 * line + 18
  self.content:SetMinHeight(height)
  self.content:SetPreferredHeight(height)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
  self.scroll_view:OnItemSizeChanged(self.index)
  self:RefreshBg(activityId)
end

local function RefreshBg(self, activityId)
  if activityId then
    local isUse = DataCenter.ActFestivalPopUpManager:CheckActFestivalUseNewSkin(activityId, UIWindowNames.UIActLimitedTimeFeastNoticeCommon)
    if isUse then
      local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
      local festivalInterfaceCfgId = activityInfo:GetFestivalInterfaceCfgId()
      local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalInterfaceCfgId)
      if lineData == nil then
        Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalInterfaceCfgId)
        return
      end
      local boardBg = lineData.board_list_di
      local imageList = string.split(boardBg, "|")
      local imagePath = imageList[1]
      local colorArr = imageList[2]
      local colorList = string.split(colorArr, ",")
      if self.Bg then
        self.Bg:LoadSprite(imagePath)
        self.Bg:SetColorRGBA255(colorList[1], colorList[2], colorList[3], colorList[4])
      end
    end
  end
end

LimitedTimeFeastNoticeNewItem.OnCreate = OnCreate
LimitedTimeFeastNoticeNewItem.OnDestroy = OnDestroy
LimitedTimeFeastNoticeNewItem.ComponentDefine = ComponentDefine
LimitedTimeFeastNoticeNewItem.ComponentDestroy = ComponentDestroy
LimitedTimeFeastNoticeNewItem.SetData = SetData
LimitedTimeFeastNoticeNewItem.ClearContent = ClearContent
LimitedTimeFeastNoticeNewItem.RefreshBg = RefreshBg
return LimitedTimeFeastNoticeNewItem
