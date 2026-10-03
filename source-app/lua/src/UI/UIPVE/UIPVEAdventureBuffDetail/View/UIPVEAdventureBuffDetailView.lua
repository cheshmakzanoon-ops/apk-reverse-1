local UIPVEAdventureBuffDetail = BaseClass("UIPVEAdventureBuffDetail", UIBaseView)
local base = UIBaseView
local UIPVEAdventureBuffDetailLine = require("UI.UIPVE.UIPVEAdventureBuffDetail.Component.UIPVEAdventureBuffDetailLine")
local Localization = CS.GameEntry.Localization
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_path = "UICommonPopUpTitle/CloseBtn"
local return_path = "UICommonPopUpTitle/panel"
local scroll_view_path = "ScrollView"
local head_left_path = "HeadBg/HeadLeft"
local head_right_path = "HeadBg/HeadRight"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.title_text:SetLocalText(302251)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self:OnCloseClick()
  end)
  self.return_btn = self:AddComponent(UIButton, return_path)
  self.return_btn:SetOnClick(function()
    self:OnCloseClick()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.head_left_text = self:AddComponent(UIText, head_left_path)
  self.head_left_text:SetLocalText(302275)
  self.head_right_text = self:AddComponent(UIText, head_right_path)
  self.head_right_text:SetLocalText(302276)
end

local function ClearScroll(self)
  self.itemList = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIPVEAdventureBuffDetailLine)
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.reset_desc_text = nil
  self.state_desc_text = nil
  self.back_btn = nil
  self.restart_btn = nil
  self.restart_text = nil
  self.history_btn = nil
  self.history_text = nil
  self.raid_btn = nil
  self.raid_text = nil
  self.buff_text = nil
  self.buff_info_btn = nil
  self.scroll_view = nil
  self.head_left_text = nil
  self.head_right_text = nil
end

local function DataDefine(self)
  self.dataList = {}
  self.itemList = {}
end

local function DataDestroy(self)
  self.dataList = nil
  self.itemList = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  local buffList = DataCenter.AdventureManager:GetBuffList()
  local buffDict = {}
  local buffType = {}
  for _, id in ipairs(buffList) do
    local line = LocalController:instance():getLine(TableName.BattleBuff, id)
    if line ~= nil then
      local strs = string.split(line:getValue("buffId"), "|")
      local localType = tonumber(line:getValue("LocalType")) or 0
      for _, str in ipairs(strs) do
        local spls = string.split(str, ";")
        if #spls == 2 then
          local buff = tonumber(spls[1])
          local val = tonumber(spls[2])
          buffDict[buff] = (buffDict[buff] or 0) + val
          buffType[buff] = localType
        end
      end
    end
  end
  self.dataList = {}
  for buff, val in pairs(buffDict) do
    local data = {}
    data.buff = buff
    data.val = val
    data.localType = buffType[buff]
    table.insert(self.dataList, data)
  end
  table.sort(self.dataList, function(a, b)
    return a.buff < b.buff
  end)
  if not table.IsNullOrEmpty(self.itemList) then
    self:ClearScroll()
  end
  local count = math.max(#self.dataList, 11)
  self.scroll_view:SetTotalCount(count)
  if 0 < count then
    self.scroll_view:RefillCells()
    self.scroll_view:ScrollToCell(1, 500)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  local data = self.dataList[index]
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UIPVEAdventureBuffDetailLine, itemObj)
  item:SetData(data, index)
  self.itemList[index] = item
end

local function OnItemMoveOut(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIPVEAdventureBuffDetailLine)
  self.itemList[index] = nil
end

local function OnCloseClick(self)
  self.ctrl:CloseSelf()
end

UIPVEAdventureBuffDetail.OnCreate = OnCreate
UIPVEAdventureBuffDetail.OnDestroy = OnDestroy
UIPVEAdventureBuffDetail.OnEnable = OnEnable
UIPVEAdventureBuffDetail.OnDisable = OnDisable
UIPVEAdventureBuffDetail.ComponentDefine = ComponentDefine
UIPVEAdventureBuffDetail.ComponentDestroy = ComponentDestroy
UIPVEAdventureBuffDetail.DataDefine = DataDefine
UIPVEAdventureBuffDetail.DataDestroy = DataDestroy
UIPVEAdventureBuffDetail.OnAddListener = OnAddListener
UIPVEAdventureBuffDetail.OnRemoveListener = OnRemoveListener
UIPVEAdventureBuffDetail.ReInit = ReInit
UIPVEAdventureBuffDetail.RefreshBuff = RefreshBuff
UIPVEAdventureBuffDetail.OnItemMoveIn = OnItemMoveIn
UIPVEAdventureBuffDetail.OnItemMoveOut = OnItemMoveOut
UIPVEAdventureBuffDetail.ClearScroll = ClearScroll
UIPVEAdventureBuffDetail.OnCloseClick = OnCloseClick
return UIPVEAdventureBuffDetail
