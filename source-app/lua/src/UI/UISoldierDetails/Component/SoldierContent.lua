local SoldierContent = BaseClass("SoldierContent", UIBaseContainer)
local UISoldierItem = require("UI/UIBuildDispatching/Component/UISoldierItem")
local base = UIBaseContainer
local DataCenter = _ENV.DataCenter
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local bg_path = "bg"

function SoldierContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SoldierContent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function SoldierContent:ComponentDefine()
  self.nameText = self:AddComponent(UIText, "name")
  self.text = self:AddComponent(UIText, "text")
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.scrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function SoldierContent:DataDefine()
  self.param = nil
  self.callBack = nil
end

function SoldierContent:ComponentDestroy()
  self:ClearScroll()
  self.nameText = nil
  self.text = nil
  self.soldierCellList = nil
  self.scrollView = nil
  self.content = nil
end

function SoldierContent:DataDestroy()
  self.param = nil
  self.callBack = nil
end

function SoldierContent:ReInit(param, callBack)
  self.nameText:SetLocalText(param.name)
  self.param = param
  self.callBack = callBack
  if param and param.soldiers and #param.soldiers > 0 then
    self.text:SetActive(false)
    self.scrollView:SetActive(true)
    self.bg:SetActive(true)
    self.showDatalist = param.soldiers
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  else
    self.text:SetActive(true)
    self.scrollView:SetActive(false)
    self.bg:SetActive(false)
    self.text:SetLocalText(param.content)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UISoldierItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local solider = self.showDatalist[index]
  local elevenData = T11Util.GetSelfCurSoldierData()
  item:SetDataWithCallBack(solider, elevenData, self.callBack)
  if not self.param.outside then
    local visible = false
    local maxLevelSoldier = DataCenter.SoldierDataManager:GetCanTrainHighestLevelSoldier()
    if maxLevelSoldier then
      local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(solider.id)
      if soldierTemplate then
        visible = soldierTemplate.lv < maxLevelSoldier.lv
      end
    end
    item:SetPromotionBtnVisible(visible)
    item:SetPromotionBtnClickCallBack(function(soldierData)
      GoToUtil.GoToMilitaryCampPromotion(soldierData.id)
    end)
  end
end

local function OnItemMoveOut(self, itemObj, index)
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UISoldierItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

SoldierContent.OnItemMoveIn = OnItemMoveIn
SoldierContent.OnItemMoveOut = OnItemMoveOut
SoldierContent.ClearScroll = ClearScroll
return SoldierContent
