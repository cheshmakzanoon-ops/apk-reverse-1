local UIKonbini = BaseClass("UIKonbini", UIBaseView)
local base = UIBaseView
local UIKonbiniItem = require("UI.UIKonbini.Component.UIKonbiniItem")
local UIKonbiniBoard = require("UI.UIKonbini.Component.UIKonbiniBoard")
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local dark_path = "Dark"
local back_path = "Back"
local list_path = "ItemList"
local time_path = "Time"
local tip_bg_path = "Pic/TipBg"
local tip_path = "Pic/TipBg/Tip"
local Player = LuaEntry.Player
local DropBoxCount = 5

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
  self:InitConfig()
  self:Refresh()
  self:LookAtBuilding()
  local param = {}
  param.uiName = UIWindowNames.UIKonbini
  param.list = {
    ResourceType.Electricity
  }
  param.itemList = {
    FREE_ITEM_ID
  }
  EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
  EventManager:GetInstance():Broadcast(EventId.SetMainEnergyVisible, false)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.dark_btn = self:AddComponent(UIButton, dark_path)
  self.dark_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.back_btn = self:AddComponent(UIButton, back_path)
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.list_go = self:AddComponent(UIBaseContainer, list_path)
  self.time_text = self:AddComponent(UIText, time_path)
  self.tip_bg_anim = self:AddComponent(UIAnimator, tip_bg_path)
  self.tip_text = self:AddComponent(UIText, tip_path)
end

local function ComponentDestroy(self)
  self.dark_btn = nil
  self.back_btn = nil
  self.list_go = nil
  self.time_text = nil
  self.tip_bg_anim = nil
  self.tip_text = nil
  EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIKonbini)
  EventManager:GetInstance():Broadcast(EventId.SetMainEnergyVisible, true)
end

local function DataDefine(self)
  self.diamondList = {}
  self.template = nil
  self.buildData = nil
  self.cellCount = 0
  self.itemList = {}
  self.dataList = {}
  self.curLevel = 0
  self.timer = nil
  self.boardIndex = 0
  self.reqs = {}
end

local function DataDestroy(self)
  self.diamondList = nil
  self.template = nil
  self.buildData = nil
  self.cellCount = nil
  self.itemList = nil
  self.dataList = nil
  self.curLevel = nil
  if self.timer ~= nil then
    self.timer:Stop()
  end
  self.timer = nil
  self.boardIndex = nil
  if self.reqs then
    for _, req in pairs(self.reqs) do
      req:Destroy()
    end
    self.reqs = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateKonbini, self.OnBuyInKonbini)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateKonbini, self.OnBuyInKonbini)
  base.OnRemoveListener(self)
end

local function InitConfig(self)
  local diamondList = {}
  local diamondStrs = string.split(LuaEntry.DataConfig:TryGetStr("shop_diamond_buy", "k1"), ";")
  for i, diamondStr in ipairs(diamondStrs) do
    diamondList[i] = tonumber(diamondStr)
  end
  self.diamondList = diamondList
  local buildUuid = self:GetUserData()
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
  local buildId = buildData.itemId
  self.curLevel = buildData.level
  self.template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, buildData.level)
  self.buildData = buildData
end

local function Refresh(self)
  self:RefreshData()
  self:RefreshTip()
  self:RefreshItems()
end

local function RefreshData(self)
  local freeItemData = DataCenter.ItemData:GetItemById(FREE_ITEM_ID)
  self.freeItemCount = freeItemData and freeItemData.count or 0
  self.freeCount = math.tointeger(tonumber(self.template.para2) + LuaEntry.Effect:GetGameEffect(EffectDefine.KONBINI_EXTRA_FREE_COUNT))
  self.dataList = {}
  local strs = string.split(self.template.para1, "|")
  for i = 1, #strs do
    local data = {}
    local spls = string.split(strs[i], ";")
    if #spls == 3 then
      local t = tonumber(spls[1])
      if t == 1 then
        data.resType = tonumber(spls[2])
      elseif t == 2 then
        data.resItemId = tonumber(spls[2])
      end
      data.count = tonumber(spls[3])
      if self.freeCount > LuaEntry.Player:GetKonbiniFreeBuyCountToday() then
        data.state = UIKonbiniItem.State.Free
        data.cost = 0
      elseif self.freeItemCount > 0 then
        data.state = UIKonbiniItem.State.CostItem
        data.cost = 0
      else
        data.state = UIKonbiniItem.State.Normal
        data.cost = self.diamondList[Player.konbiniInfo.payBuyCount + 1] or self.diamondList[#self.diamondList]
      end
    end
    self.dataList[i] = data
  end
  if self.timer ~= nil then
    self.timer:Stop()
  end
  self.timer = TimerManager:GetInstance():GetTimer(0.5, self.TimerAction, self, false, false, false)
  self.timer:Start()
end

local function RefreshItems(self)
  for i = 1, #self.dataList do
    if self.itemList[i] ~= nil then
      self.itemList[i]:SetData(self.dataList[i])
    else
      if self.reqs[i] then
        self.reqs[i]:Destroy()
      end
      self.reqs[i] = self:GameObjectInstantiateAsync(UIAssets.UIKonbiniItem, function(req)
        if req.isError then
          return
        end
        local go = req.gameObject
        go:SetActive(true)
        go.name = tostring(i)
        go.transform:SetParent(self.list_go.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local item = self.list_go:AddComponent(UIKonbiniItem, go.name)
        item:SetData(self.dataList[i])
        item:SetOnClick(function()
          self:OnClickCell(i)
        end)
        self.itemList[i] = item
      end)
    end
  end
end

local function RefreshTip(self)
  local restFreeCount = self.freeCount - LuaEntry.Player:GetKonbiniFreeBuyCountToday()
  if 0 < restFreeCount then
    if not self.tip_bg_anim:GetActive() then
      self.tip_bg_anim:SetActive(true)
      self.tip_bg_anim:Play("CommonPopup_movein", 0, 0)
    end
    self.tip_text:SetLocalText(140320, restFreeCount)
  elseif not self.showTip then
    local lastTime = tonumber(Setting:GetPrivateString(SettingKeys.KONBINI_TIP_TIME .. LuaEntry.Player.uid, "")) or 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local sameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, lastTime // 1000)
    if sameDay then
      self.tip_bg_anim:SetActive(false)
    else
      if not self.tip_bg_anim:GetActive() then
        self.tip_bg_anim:SetActive(true)
        self.tip_bg_anim:Play("CommonPopup_movein", 0, 0)
      end
      self.tip_text:SetLocalText(140408)
      TimerManager:GetInstance():DelayInvoke(function()
        if self.gameObject == nil then
          return
        end
        self.tip_bg_anim:SetActive(false)
      end, 6)
    end
    self.showTip = true
    Setting:SetPrivateString(SettingKeys.KONBINI_TIP_TIME, tostring(curTime))
  end
end

local function TimerAction(self)
  local restTime = (UITimeManager:GetInstance():GetResSecondsTo24() + 1) * 1000
  if 0 <= restTime then
    local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
    self.time_text:SetText(restTimeStr)
  else
    self:Refresh()
  end
end

local function OnClickCell(self, index)
  local data = self.dataList[index]
  if data.state == UIKonbiniItem.State.Locked then
    return
  end
  if LuaEntry.Player.gold < data.cost then
    GoToUtil.GotoPayTips(data.cost)
    return
  end
  if data.resItemId and DataCenter.ResourceItemDataManager:CheckIsStorageFull(data.count) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityFull)
    return
  end
  if data.cost > 0 and not Setting:GetBool(Player.uid .. SettingKeys.KONBINI_BUY_DONT_SHOW, false) then
    UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("140321", data.cost), 2, "", "", function()
      self:OnConfirm(index)
    end, function()
      Setting:SetBool(Player.uid .. SettingKeys.KONBINI_BUY_DONT_SHOW, true)
    end)
  else
    self:OnConfirm(index)
  end
end

local function OnConfirm(self, index)
  local data = self.dataList[index]
  local icon = ""
  if data.resType then
    local resTemplate = DataCenter.ResourceTemplateManager:GetResourceTemplate(data.resType)
    icon = string.format(LoadPath.LWCommonPath, resTemplate.icon)
    EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, data.resType)
    UIUtil.DoFly(ResTypeToReward[data.resType], 5, icon, self.itemList[index].middle_icon_image.transform.position, VecZero)
  elseif data.resItemId then
    icon = DataCenter.ResourceItemDataManager:GetIconPath(data.resItemId)
    UIUtil.DoFly(RewardType.GOODS, 5, icon, self.itemList[index].middle_icon_image.transform.position, VecZero)
  end
  for i = 1, DropBoxCount do
    self.ctrl:DropOneBox(self.buildData.pointId, FlyBoard)
  end
  TimerManager:GetInstance():DelayInvoke(function()
    if self.gameObject == nil then
      return
    end
    self:GameObjectInstantiateAsync(UIAssets.UIKonbiniBoard, function(req)
      if req.isError then
        return
      end
      if self.gameObject == nil then
        req:Destroy()
        return
      end
      local go = req.gameObject
      go.name = tostring(self.boardIndex)
      self.boardIndex = self.boardIndex + 1
      local tf = go.transform
      local cg = tf:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
      local board = self:AddComponent(UIKonbiniBoard, go)
      board:SetData(data, icon)
      tf:SetParent(self.transform)
      tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      tf:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      TimerManager:GetInstance():DelayInvoke(function()
        if req ~= nil then
          req:Destroy()
        end
      end, 3)
    end)
  end, 3)
  if data.state == UIKonbiniItem.State.Free then
    Player.konbiniInfo.freeBuyCount = Player.konbiniInfo.freeBuyCount + 1
  elseif data.state == UIKonbiniItem.State.Normal then
    Player.konbiniInfo.payBuyCount = Player.konbiniInfo.payBuyCount + 1
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  Player.konbiniInfo.lastBuyTime = curTime
  self:Refresh()
  local param = {
    index = index,
    useFree = data.state == UIKonbiniItem.State.Free
  }
  SFSNetwork.SendMessage(MsgDefines.BuyInKonbini, param)
end

local function OnBuyInKonbini(self)
  self:Refresh()
end

local function LookAtBuilding(self)
  local pos = self.buildData:GetCenterVec() + Vector3.New(0, 0, -2)
  GoToUtil.GotoPos(pos, 20, 0.2)
end

UIKonbini.OnCreate = OnCreate
UIKonbini.OnDestroy = OnDestroy
UIKonbini.OnEnable = OnEnable
UIKonbini.OnDisable = OnDisable
UIKonbini.ComponentDefine = ComponentDefine
UIKonbini.ComponentDestroy = ComponentDestroy
UIKonbini.DataDefine = DataDefine
UIKonbini.DataDestroy = DataDestroy
UIKonbini.OnAddListener = OnAddListener
UIKonbini.OnRemoveListener = OnRemoveListener
UIKonbini.InitConfig = InitConfig
UIKonbini.Refresh = Refresh
UIKonbini.RefreshData = RefreshData
UIKonbini.RefreshItems = RefreshItems
UIKonbini.RefreshTip = RefreshTip
UIKonbini.TimerAction = TimerAction
UIKonbini.OnClickCell = OnClickCell
UIKonbini.OnConfirm = OnConfirm
UIKonbini.OnBuyInKonbini = OnBuyInKonbini
UIKonbini.LookAtBuilding = LookAtBuilding
return UIKonbini
