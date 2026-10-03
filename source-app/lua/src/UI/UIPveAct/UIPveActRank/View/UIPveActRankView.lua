local UIPveActRank = BaseClass("UIPveActRank", UIBaseView)
local base = UIBaseView
local UIPveActRankItem = require("UI.UIPveAct.UIPveActRank.Component.UIPveActRankItem")
local Localization = CS.GameEntry.Localization
local panel_path = "UICommonPopUpTitle/panel"
local close_path = "UICommonPopUpTitle/CloseBtn"
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local info_path = "Info"
local scroll_view_path = "ScrollView"
local desc_path = "Left/Desc"
local time_path = "Left/Time"
local my_item_top_path = "MyItemTop"
local my_item_bottom_path = "MyItemBottom"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.panel_btn = self:AddComponent(UIButton, panel_path)
  self.panel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title_text = self:AddComponent(UIText, title_path)
  self.title_text:SetLocalText(390040)
  self.info_btn = self:AddComponent(UIButton, info_path)
  self.info_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.time_text = self:AddComponent(UIText, time_path)
  self.my_item_top = self:AddComponent(UIPveActRankItem, my_item_top_path)
  self.my_item_top:SetMine(true)
  self.my_item_bottom = self:AddComponent(UIPveActRankItem, my_item_bottom_path)
  self.my_item_bottom:SetMine(true)
end

local function ComponentDestroy(self)
  self.panel_btn = nil
  self.close_btn = nil
  self.title_text = nil
  self.info_btn = nil
  self.scroll_view = nil
  self.desc_text = nil
  self.time_text = nil
  self.my_item_top = nil
  self.my_item_bottom = nil
end

local function DataDefine(self)
  self.actId = 0
  self.data = nil
  self.rankData = nil
  self.actData = nil
  self.rankItems = {}
  self.timer = nil
  self.my_item = nil
end

local function DataDestroy(self)
  self.actId = nil
  self.data = nil
  self.rankData = nil
  self.actData = nil
  self.rankItems = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.my_item = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PveActGetRank, self.OnGetRank)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PveActGetRank, self.OnGetRank)
  base.OnRemoveListener(self)
end

local function OnCreateCell(self, itemObj, index)
  local data = self.rankData.rankList[index]
  local rewards = self:GetRewardsByIndex(index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UIPveActRankItem, itemObj)
  item:SetData(data, rewards)
  self.rankItems[index] = item
  if item.data.uid == LuaEntry.Player.uid then
    item:SetMine(true)
    self.my_item = item
  else
    item:SetMine(false)
  end
end

local function OnDeleteCell(self, itemObj, index)
  local item = self.rankItems[index]
  if item and item.data.uid == LuaEntry.Player.uid then
    self.my_item = nil
  end
  self.scroll_view:RemoveComponent(itemObj.name, UIPveActRankItem)
  self.rankItems[index] = nil
end

local function ShowScroll(self)
  self.scroll_view:SetTotalCount(#self.rankData.rankList)
  if #self.rankData.rankList > 0 then
    self.scroll_view:SetActive(true)
    self.scroll_view:RefillCells()
  else
    self.scroll_view:SetActive(false)
  end
end

local function Update(self)
  local showMyItemTop = false
  local showMyItemBottom = false
  if self.my_item ~= nil then
    showMyItemTop = self.my_item.transform.position.y > self.my_item_top.transform.position.y
    showMyItemBottom = self.my_item.transform.position.y < self.my_item_bottom.transform.position.y
  else
    for _, item in pairs(self.rankItems) do
      showMyItemTop = self.my_item_top.data.rank < item.data.rank
      showMyItemBottom = self.my_item_bottom.data.rank > item.data.rank
      break
    end
  end
  if self.my_item_top:GetActive() ~= showMyItemTop then
    self.my_item_top:SetActive(showMyItemTop)
  end
  if self.my_item_bottom:GetActive() ~= showMyItemBottom then
    self.my_item_bottom:SetActive(showMyItemBottom)
  end
end

local function TimerAction(self)
  local _, restTimeStr = DataCenter.PveActManager:GetRestTime(self.actId)
  self.time_text:SetText(restTimeStr)
end

local function ReInit(self)
  self.actId = self:GetUserData()
  self.actData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.actId))
  self.desc_text:SetLocalText(self.actData.desc_info)
  if self.timer then
    self.timer:Stop()
  end
  self:TimerAction()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  self.timer:Start()
  DataCenter.PveActManager:SendGetRank(self.actId)
end

local function Refresh(self)
  self.data = DataCenter.PveActManager:GetData(self.actId)
  self.rankData = DataCenter.PveActManager:GetRankData(self.actId)
  for _, rank in ipairs(self.rankData.rankList) do
    if rank.uid == LuaEntry.Player.uid then
      local reward = self:GetRewardsByIndex(rank.rank)
      self.my_item_top:SetData(rank, reward)
      self.my_item_bottom:SetData(rank, reward)
      break
    end
  end
  self:ShowScroll()
end

local function GetRewardsByIndex(self, index)
  for _, info in ipairs(self.rankData.rankRewardArr) do
    if index >= info.start and index <= info["end"] then
      return info.reward
    end
  end
  return {}
end

local function OnInfoClick(self)
  UIUtil.ShowIntro(Localization:GetString("390040"), "", Localization:GetString("134023") .. "\n" .. Localization:GetString("134024"))
end

local function OnGetRank(self, actId)
  if self.actId ~= actId then
    return
  end
  self:Refresh()
end

UIPveActRank.OnCreate = OnCreate
UIPveActRank.OnDestroy = OnDestroy
UIPveActRank.OnEnable = OnEnable
UIPveActRank.OnDisable = OnDisable
UIPveActRank.ComponentDefine = ComponentDefine
UIPveActRank.ComponentDestroy = ComponentDestroy
UIPveActRank.DataDefine = DataDefine
UIPveActRank.DataDestroy = DataDestroy
UIPveActRank.OnAddListener = OnAddListener
UIPveActRank.OnRemoveListener = OnRemoveListener
UIPveActRank.OnCreateCell = OnCreateCell
UIPveActRank.OnDeleteCell = OnDeleteCell
UIPveActRank.ShowScroll = ShowScroll
UIPveActRank.Update = Update
UIPveActRank.TimerAction = TimerAction
UIPveActRank.ReInit = ReInit
UIPveActRank.Refresh = Refresh
UIPveActRank.GetRewardsByIndex = GetRewardsByIndex
UIPveActRank.OnInfoClick = OnInfoClick
UIPveActRank.OnGetRank = OnGetRank
return UIPveActRank
