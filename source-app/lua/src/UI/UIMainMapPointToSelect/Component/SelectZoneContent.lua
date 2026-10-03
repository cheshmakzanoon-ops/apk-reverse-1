local SelectZoneContent = BaseClass("SelectZoneContent", UIBaseContainer)
local base = UIBaseContainer
local ZoneItem = require("UI.UIMainMapPointToSelect.Component.ZoneItem")
local ZoneLvItem = require("UI.UIMainMapPointToSelect.Component.ZoneLvItem")
local quickSelectBarTextPath = "QuickSelectBar/BtnText"
local quickSelectBarBtnPath = "QuickSelectBar"
local quickSelectBarIconPath = "QuickSelectBar/MenuBtn/Icon"
local quickSelectMenuPath = "QuickSelectMenu"
local quickSelectMenuBgPanelPath = "QuickSelectMenu/Panel"
local point_x_val_path = "pointShowContent/pointValContent/pointXVal"
local point_y_val_path = "pointShowContent/pointValContent/pointYVal"
local confirm_btn_path = "confirmBtn"
local confirm_btn_txt_path = "confirmBtn/confirmBtnTxt"
local point_val_path = "pointShowContent/pointValContent/pointVal"
local city_select_item_path = "citySelectContent/CitySelectItem"
local city_select_content_path = "citySelectContent/CitySelectScroll/Viewport/CitySelectContent"
local city_select_scroll_path = "citySelectContent/CitySelectScroll"
local select_btn_path = "QuickSelectMenu/itemContent/selectBtn"
local menu_root_path = "QuickSelectMenu/MenuRoot"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.quickSelectBarBtn = self:AddComponent(UIButton, quickSelectBarBtnPath)
  self.quickSelectBarBtn:SetOnClick(function()
    if self.quickSelectMenu.activeSelf then
      self:HideQuickSelectMenu()
    else
      self:ShowQuickSelectMenu()
    end
  end)
  self.quickSelectBarText = self:AddComponent(UIText, quickSelectBarTextPath)
  self.quickSelectBarIcon = self:AddComponent(UIImage, quickSelectBarIconPath)
  self.quickSelectMenu = self:AddComponent(UIBaseContainer, quickSelectMenuPath)
  self.qcuickSelectMenuBgPanelBtn = self:AddComponent(UIButton, quickSelectMenuBgPanelPath)
  self.qcuickSelectMenuBgPanelBtn:SetOnClick(function()
    self:HideQuickSelectMenu()
  end)
  self.point_x_val = self:AddComponent(UITextMeshProUGUIEx, point_x_val_path)
  self.point_y_val = self:AddComponent(UITextMeshProUGUIEx, point_y_val_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn_txt = self:AddComponent(UITextMeshProUGUIEx, confirm_btn_txt_path)
  self.confirm_btn:SetOnClick(function()
    self:OnConfirmBtnClick()
  end)
  self.city_select_item = self:AddComponent(UIButton, city_select_item_path)
  self.city_select_item:SetActive(false)
  self.city_select_content = self:AddComponent(UIBaseContainer, city_select_content_path)
  self.city_select_scroll = self:AddComponent(UIScrollRect, city_select_scroll_path)
  self.select_btn = self:AddComponent(UIButton, select_btn_path)
  self.select_btn:SetActive(false)
  self.menu_root = self:AddComponent(UIBaseContainer, menu_root_path)
  self.city_select_item_list = {}
  self.city_select_item.gameObject:GameObjectCreatePool()
  self.select_btn_list = {}
  self.select_btn.gameObject:GameObjectCreatePool()
  self.point_val = self:AddComponent(UITextMeshProUGUIEx, point_val_path)
end

local function ComponentDestroy(self)
  self:ClearAllItems()
  self.point_x_val = nil
  self.point_y_val = nil
  self.confirm_btn = nil
  self.confirm_btn_txt = nil
  self.city_select_content = nil
  self.city_select_item = nil
  self.city_select_content = nil
  self.city_select_scroll = nil
  self.select_btn = nil
  self.menu_root = nil
  self.point_val = nil
end

local function DataDefine(self)
  self.cityTempData = {}
  self.cityTempLvDict = {}
  self.selectZonePosId = nil
  self.selectZoneId = nil
  self.selectServerId = nil
  self.cityTempLvShowList = {}
  self.selectZoneLv = nil
  self.selectZoneLvChange = true
end

local function DataDestroy(self)
  self.cityTempData = nil
  self.cityTempLvDict = nil
  self.selectZonePosId = nil
  self.selectZoneId = nil
  self.selectServerId = nil
  self.cityTempLvShowList = nil
  self.selectZoneLv = nil
  self.selectZoneLvChange = nil
end

local function SetData(self, cityTempData, cityTempLvDict)
  self.cityTempData = cityTempData
  self.cityTempLvDict = cityTempLvDict
  self.cityTempLvShowList = {}
  for k, v in pairs(self.cityTempLvDict) do
    table.insert(self.cityTempLvShowList, k)
  end
  table.sort(self.cityTempLvShowList)
  self.selectZonePosId, self.selectZoneId, self.selectServerId = self.view:GetSelectZoneData()
  local zoneMeta = self.cityTempData[tostring(self.selectZoneId)]
  if zoneMeta then
    self.selectZoneLv = zoneMeta.level
  else
    self.selectZoneLv = 1
  end
  self.selectZoneLvChange = true
  self:HideQuickSelectMenu()
  self:RefreshView()
end

local function ShowQuickSelectMenu(self)
  self.quickSelectMenu:SetActive(true)
  self.quickSelectBarIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2")
  self.quickSelectMenuActive = true
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  self.parentSizeX = Screen.width / scaleFactor
  self.parentSizeY = Screen.height / scaleFactor
  self.qcuickSelectMenuBgPanelBtn:SetSizeDeltaXY(self.parentSizeX, self.parentSizeY)
  self.qcuickSelectMenuBgPanelBtn:SetPosition(self.view:GetPosition())
  self:RefreshMenuContent()
end

local function HideQuickSelectMenu(self)
  self.quickSelectMenu:SetActive(false)
  self.quickSelectBarIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1")
  self.quickSelectMenuActive = false
end

local function ChangeSelectZone(self)
  self.selectZonePosId, self.selectZoneId, self.selectServerId = self.view:GetSelectZoneData()
  local oldLv = self.selectZoneLv
  local zoneMeta = self.cityTempData[tostring(self.selectZoneId)]
  if zoneMeta then
    self.selectZoneLv = zoneMeta.level
  else
    self.selectZoneLv = 1
  end
  if oldLv ~= self.selectZoneLv then
    self.selectZoneLvChange = true
  end
  self:HideQuickSelectMenu()
  self:RefreshView()
end

local function RefreshView(self)
  self:RefreshMenuContent()
  self:RefreshInfoContent()
end

local function RefreshMenuContent(self)
  if not self.quickSelectMenuActive then
    return
  end
  for i = 1, #self.cityTempLvShowList do
    local lv = self.cityTempLvShowList[i]
    if self.select_btn_list[i] then
      self.select_btn_list[i]:SetActive(true)
    else
      local item = self.select_btn.gameObject:GameObjectSpawn(self.menu_root.transform)
      item.name = i
      local obj = self.menu_root:AddComponent(ZoneLvItem, item.name)
      obj:SetActive(true)
      self.select_btn_list[i] = obj
    end
    self.select_btn_list[i]:SetData(lv, self.selectZoneLv, function(lv)
      self:OnLvSelectChange(lv)
    end)
  end
  for i = #self.cityTempLvShowList + 1, #self.select_btn_list do
    self.select_btn_list[i]:SetActive(false)
  end
end

local function RefreshInfoContent(self)
  if self.selectZoneLvChange then
    self.selectZoneLvChange = false
    self.quickSelectBarText:SetLocalText("alliance_announcement_2", self.selectZoneLv)
    local showZoneList = self.cityTempLvDict[self.selectZoneLv]
    if showZoneList == nil then
      showZoneList = {}
    end
    for i = 1, #showZoneList do
      local metaData = showZoneList[i]
      if self.city_select_item_list[i] then
        self.city_select_item_list[i]:SetActive(true)
      else
        local item = self.city_select_item.gameObject:GameObjectSpawn(self.city_select_content.transform)
        item.name = i
        local obj = self.city_select_content:AddComponent(ZoneItem, item.name)
        obj:SetActive(true)
        self.city_select_item_list[i] = obj
      end
      self.city_select_item_list[i]:SetData(metaData.id, metaData, function(id)
        self:OnZoneSelectChange(id)
      end)
    end
    for i = #showZoneList + 1, #self.city_select_item_list do
      self.city_select_item_list[i]:SetActive(false)
    end
    self.city_select_content:SetAnchoredPositionXY(0, 0)
  end
  local zoneMeta = self.cityTempData[tostring(self.selectZoneId)]
  if zoneMeta then
    self.point_val:SetLocalText("alliance_announcement_1", zoneMeta.pos.x, zoneMeta.pos.y)
  end
end

local function ClearAllItems(self)
  self.menu_root:RemoveComponents(ZoneLvItem)
  self.select_btn.gameObject:GameObjectRecycleAll()
  self.select_btn_list = {}
  self.city_select_content:RemoveComponents(ZoneItem)
  self.city_select_item.gameObject:GameObjectRecycleAll()
  self.city_select_item_list = {}
end

local function OnLvSelectChange(self, lv)
  if self.selectZoneLv == lv then
    return
  end
  self.selectZoneLv = lv
  self.selectZoneLvChange = true
  self:HideQuickSelectMenu()
  self:RefreshView()
end

local function OnZoneSelectChange(self, zoneId)
  if self.selectZoneId == zoneId then
    return
  end
  self.selectZoneId = zoneId
  local zoneMeta = self.cityTempData[tostring(self.selectZoneId)]
  if zoneMeta then
    self.view:ChangeSelectZone(zoneId, zoneMeta:GetPointId(), zoneMeta:GetCurServerId())
  end
end

local function OnConfirmBtnClick(self)
  local share_param
  if self.selectZoneId then
    local zoneMeta = self.cityTempData[tostring(self.selectZoneId)]
    if zoneMeta then
      share_param = {}
      share_param.sid = zoneMeta:GetCurServerId()
      share_param.pos = zoneMeta:GetPointId()
      share_param.oname = tostring(zoneMeta.name)
      share_param.uname = ""
      share_param.olv = zoneMeta.level
    end
  end
  self.view:GetShareDataAndClose(share_param)
end

SelectZoneContent.OnCreate = OnCreate
SelectZoneContent.OnDestroy = OnDestroy
SelectZoneContent.OnAddListener = OnAddListener
SelectZoneContent.OnRemoveListener = OnRemoveListener
SelectZoneContent.ComponentDefine = ComponentDefine
SelectZoneContent.ComponentDestroy = ComponentDestroy
SelectZoneContent.DataDefine = DataDefine
SelectZoneContent.DataDestroy = DataDestroy
SelectZoneContent.SetData = SetData
SelectZoneContent.ShowQuickSelectMenu = ShowQuickSelectMenu
SelectZoneContent.HideQuickSelectMenu = HideQuickSelectMenu
SelectZoneContent.ChangeSelectZone = ChangeSelectZone
SelectZoneContent.RefreshView = RefreshView
SelectZoneContent.RefreshMenuContent = RefreshMenuContent
SelectZoneContent.RefreshInfoContent = RefreshInfoContent
SelectZoneContent.ClearAllItems = ClearAllItems
SelectZoneContent.OnLvSelectChange = OnLvSelectChange
SelectZoneContent.OnZoneSelectChange = OnZoneSelectChange
SelectZoneContent.OnConfirmBtnClick = OnConfirmBtnClick
return SelectZoneContent
