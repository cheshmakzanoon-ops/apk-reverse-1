local UILWSeasonFactionHistoryView = BaseClass("UILWSeasonFactionHistoryView", UIBaseView)
local base = UIBaseView
local hasDataALL = false
local theHistoryData = {}
local HistoryItem = require("UI.LWSeason2.UILWSeasonFactionHistory.Component.UILWSeasonFactionHistoryItem")
local panel_path = "panel"
local close_btn_path = "Root/Common_img_title/CloseBtn"
local scroll_view_path = "Root/MiddleContent/ScrollView"
local content_path = "Root/MiddleContent/ScrollView/Viewport/Content"
local mark_path = "Root/MiddleContent/mark"

function UILWSeasonFactionHistoryView:OnCreate()
  base.OnCreate(self)
  self.param = self:GetUserData()
  self.items = {}
  self.dataList = {}
  self:ComponentDefine()
  if self.param and SeasonUtil.SeasonHasCampMasterServer(self.param.Season) and self.param.Type == "King" then
    self:OnFactionHistoryKing()
    SFSNetwork.SendMessage(MsgDefines.GetCampMasterServerHistory, 0, 200)
  else
    self:OnFactionHistory(DataCenter.SeasonDataManager.seasonFactionHistory, true)
    SFSNetwork.SendMessage(MsgDefines.GetSeasonFactionHistory, 0, 100)
  end
end

function UILWSeasonFactionHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonFactionHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionHistory, self.OnFactionHistory)
  self:AddUIListener(EventId.LWSeasonFactionHistoryKing, self.OnFactionHistoryKing)
end

function UILWSeasonFactionHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionHistory, self.OnFactionHistory)
  self:RemoveUIListener(EventId.LWSeasonFactionHistoryKing, self.OnFactionHistoryKing)
  base.OnRemoveListener(self)
end

function UILWSeasonFactionHistoryView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.ScrollView = self:AddComponent(UILoopListView2, scroll_view_path)
  self.ScrollView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.mark = self:AddComponent(UIImage, mark_path)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Snow then
    self.mark:SetActive(true)
    self.mark:LoadSprite("Assets/Main/Sprites/UI/UIRadarCenter/mjc_s2_leida_bingshuang.png")
  elseif seasonType == SeasonMapType.Mummy then
    self.mark:SetActive(true)
    self.mark:LoadSprite("Assets/Main/SeasonRes/S3/Sprites/UI/FactionDeclareWar/mjc_s3_leida_shazi.png")
  elseif seasonType == SeasonMapType.Darkness then
    self.mark:SetActive(false)
  else
    self.mark:SetActive(false)
  end
end

function UILWSeasonFactionHistoryView:ComponentDestroy()
  self:RemoveItems()
  self.content = nil
  self.scroll_view = nil
  self.close_btn = nil
  self.mark = nil
end

function UILWSeasonFactionHistoryView:RemoveItems()
  self.items = {}
  self.content:RemoveComponents(HistoryItem)
  self.ScrollView:ClearAllItems()
end

function UILWSeasonFactionHistoryView:OnFactionHistoryKing()
  local mgr = DataCenter.SeasonFactionWarDataManager
  local history = mgr.seasonFactionMasterServerHistory
  if history == nil or table.count(history) == 0 then
    self.ScrollView:SetActive(false)
    return
  end
  local dataList = {}
  for k, v in pairs(history) do
    v.type = "king"
    table.insert(dataList, v)
  end
  local dataCount = #dataList
  if 0 < dataCount then
    table.sort(dataList, function(a, b)
      return a.time > b.time
    end)
    self.dataList = dataList
    self.ScrollView:SetActive(true)
    self.ScrollView:SetListItemCount(#self.dataList, t == nil, false)
    self.ScrollView:RefreshAllShownItem()
  else
    self.ScrollView:SetActive(false)
  end
end

function UILWSeasonFactionHistoryView:OnFactionHistory(data, forceDisplay)
  local hasNewData = false
  if data and data.pageNum and data.pageSize and data.history then
    for k, v in ipairs(data.history) do
      if theHistoryData[v.uuid] == nil then
        hasNewData = true
        theHistoryData[v.uuid] = v
      end
    end
    if hasDataALL and not hasNewData and not forceDisplay then
      return
    end
    if #data.history >= data.pageSize then
      SFSNetwork.SendMessage(MsgDefines.GetSeasonFactionHistory, toInt(data.pageNum) + 1, 100)
    else
      hasDataALL = true
    end
    if not hasNewData and not forceDisplay then
      return
    end
  end
  local dataList = {}
  for k, v in pairs(theHistoryData) do
    table.insert(dataList, v)
  end
  local dataCount = #dataList
  if 0 < dataCount then
    table.sort(dataList, function(a, b)
      return a.time > b.time
    end)
    self.dataList = dataList
    self.ScrollView:SetActive(true)
    self.ScrollView:SetListItemCount(#self.dataList, t == nil, false)
    self.ScrollView:RefreshAllShownItem()
  else
    self.ScrollView:SetActive(false)
  end
end

function UILWSeasonFactionHistoryView:GetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("FactionHistoryItem")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "HistoryItem" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(HistoryItem, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(index, dataList[index])
  end
  return csItem
end

return UILWSeasonFactionHistoryView
