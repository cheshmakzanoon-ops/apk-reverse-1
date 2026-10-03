local UITrainPrepareThanksRecordView = BaseClass("UITrainPrepareThanksRecordView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UITrainPrepareThanksRecordItem = require("UI.UILWRailway.UITrainPrepareThanksRecord.Component.UITrainPrepareThanksRecordItem")
local closeBtn_path = "top/btnClose"
local title_path = "top/txtTitle"
local svTask_path = "bg2/MiddleContentContainer/ScrollView"
local black_path = "black"
local total_txt_path = "bg2/MiddleContentContainer/totalTxt"
local cost_txt_path = "bg2/MiddleContentContainer/costTxt"
local small_icon_path = "bg2/MiddleContentContainer/costTxt/smallIcon"

function UITrainPrepareThanksRecordView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UITrainPrepareThanksRecordView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UITrainPrepareThanksRecordView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceTrainThumbsUpListReceived, self.OnAllianceTrainThumbsUpListReceived)
end

function UITrainPrepareThanksRecordView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceTrainThumbsUpListReceived, self.OnAllianceTrainThumbsUpListReceived)
  base.OnRemoveListener(self)
end

function UITrainPrepareThanksRecordView:ComponentDefine()
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
  self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.titleN:SetLocalText("")
  self.svTaskN = self:AddComponent(UIScrollView, svTask_path)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.svTaskN:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.svTaskN:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.black = self:AddComponent(UIButton, black_path)
  self.black:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
  self.total_txt = self:AddComponent(UITextMeshProUGUIEx, total_txt_path)
  self.cost_txt = self:AddComponent(UITextMeshProUGUIEx, cost_txt_path)
  self.small_icon = self:AddComponent(UIImage, small_icon_path)
  self.titleN:SetText(Localization:GetString("alliance_train_003"))
  self.total_txt:SetText(Localization:GetString("alliance_train_010"))
  local itemId = DataCenter.LWAllyStationDataManager.CHANGE_TRAIN_COST_ITEM
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if goods ~= nil then
    self.small_icon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
  end
end

function UITrainPrepareThanksRecordView:DataDefine()
end

function UITrainPrepareThanksRecordView:ComponentDestroy()
  self:ClearScroll()
  self.scrollCellPool = nil
  self.closeBtnN = nil
  self.titleN = nil
  self.svTaskN = nil
  self.black = nil
  self.total_txt = nil
  self.cost_txt = nil
  self.small_icon = nil
end

function UITrainPrepareThanksRecordView:DataDestroy()
end

function UITrainPrepareThanksRecordView:ReInit()
  DataCenter.LWAllyStationDataManager:GetAllianceTrainThumbsUpList(1, false)
  self:RefreshData()
end

function UITrainPrepareThanksRecordView:OnAllianceTrainThumbsUpListReceived()
  self:RefreshData()
end

function UITrainPrepareThanksRecordView:RefreshData()
  self.list = DataCenter.LWAllyStationDataManager:GetThumbsUpList()
  local recordCount = #self.list
  self.svTaskN:SetTotalCount(recordCount)
  if 0 < recordCount then
    self.svTaskN:RefillCells()
  end
  local totalCount = 0
  for _, v in ipairs(self.list) do
    totalCount = totalCount + v.num
  end
  self.cost_txt:SetText("\195\151" .. totalCount)
end

function UITrainPrepareThanksRecordView:OnCreateCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.svTaskN:AddComponent(UITrainPrepareThanksRecordItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local logInfo = self.list[index]
  item:SetItem(logInfo)
end

function UITrainPrepareThanksRecordView:OnDeleteCell(itemObj, index)
end

function UITrainPrepareThanksRecordView:ClearScroll()
  self.svTaskN:ClearCells()
  self.svTaskN:RemoveComponents(UITrainPrepareThanksRecordItem)
end

function UITrainPrepareThanksRecordView:OnCloseBtnClick()
  self.ctrl:CloseSelf()
end

return UITrainPrepareThanksRecordView
