local AlScienceDetails = BaseClass("AlScienceDetails", UIBaseContainer)
local UIDetailsCell = require("UI.UIScienceInfo.Component.UIDetailsCell")
local Localization = CS.GameEntry.Localization
local base = UIBaseContainer
local detail_title_path = "DetailTitleCell"
local scroll_view_path = "Scroll View"
local back_btn_path = "BackBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self.detail_title = self:AddComponent(UIDetailsCell, detail_title_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self.view:BackBtnClick()
  end)
end

local function OnDestroy(self)
  self.detail_title = nil
  self.scroll_view = nil
  self.back_btn = nil
  self.maxLevel = nil
  self.scienceData = nil
  base.OnDestroy(self)
end

local function RefreshData(self, scienceData)
  self.scienceData = scienceData
  self.maxLevel = scienceData.maxLevel
  local info_vec = string.split_ss_array(scienceData.info, "|")
  if self.maxLevel > #info_vec then
    return
  end
  local titleData = {}
  titleData.name1 = Localization:GetString(GameDialogDefine.LEVEL)
  titleData.name2 = Localization:GetString(scienceData.description_tip)
  self.detail_title:ReInit(titleData)
  self:ShowCells()
end

local function ShowCells(self)
  self:ClearScroll()
  self.scroll_view:SetTotalCount(self.maxLevel)
  self.scroll_view:RefillCells()
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIDetailsCell)
end

local function OnCreateCell(self, itemObj, index)
  local info_vec = string.split_ss_array(self.scienceData.info, "|")
  if self.maxLevel <= #info_vec then
    local oneData = info_vec[index]
    local oneData_vec = string.split_ss_array(oneData, ";")
    if 2 <= #oneData_vec then
      itemObj.name = self.scienceData.scienceId + index
      local cellItem = self.scroll_view:AddComponent(UIDetailsCell, itemObj)
      local param = UIDetailsCell.Param.New()
      param.name1 = oneData_vec[1]
      param.name2 = oneData_vec[2]
      cellItem:ReInit(param)
    end
  end
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIDetailsCell)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

AlScienceDetails.OnCreate = OnCreate
AlScienceDetails.OnDestroy = OnDestroy
AlScienceDetails.OnEnable = OnEnable
AlScienceDetails.OnDisable = OnDisable
AlScienceDetails.RefreshData = RefreshData
AlScienceDetails.ShowCells = ShowCells
AlScienceDetails.ClearScroll = ClearScroll
AlScienceDetails.OnCreateCell = OnCreateCell
AlScienceDetails.OnDeleteCell = OnDeleteCell
return AlScienceDetails
