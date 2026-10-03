local UIEpidemicBattleSpeedView = BaseClass("UIEpidemicBattleSpeedView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local BattlePopBase = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleBase.BattlePopBase")
local UIEBS_ItemCell = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSpeed.Component.UIEBS_ItemCell")
local panel_path = "panel"
local battle_pop_base_path = "BattlePopBase"
local slider_path = "Root/TopContent/Slider"
local pro_img_path = "Root/TopContent/Slider/Fill Area/Fill"
local left_time_path = "Root/TopContent/LeftTime"
local img_quality_path = "Root/FreeCell/ImgQuality"
local item_icon_path = "Root/FreeCell/ItemIcon"
local own_text_path = "Root/FreeCell/OwnText"
local use_btn_path = "Root/FreeCell/UseBtn"
local vfx_free_path = "Root/FreeCell/UseBtn/VFX_Free"
local cd_text_path = "Root/FreeCell/Di/CDText"
local scrollView_path = "Root/ScrollView"
local content_path = "Root/ScrollView/viewport/Content"
local SliderLength = 550

function UIEpidemicBattleSpeedView:OnCreate()
  base.OnCreate(self)
  local closeCb = BindCallback(self.ctrl, self.ctrl.CloseSelf)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(closeCb)
  self.battle_pop_base = self:AddComponent(BattlePopBase, battle_pop_base_path)
  self.battle_pop_base:ReInit(100159, closeCb)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.pro_img = self:AddComponent(UIImage, pro_img_path)
  self.left_time = self:AddComponent(UITextMeshProUGUIEx, left_time_path)
  self.img_quality = self:AddComponent(UIImage, img_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.own_text = self:AddComponent(UITextMeshProUGUIEx, own_text_path)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn:SetOnClick(BindCallback(self, self.OnClickBtnUse))
  self.vfx_free = self:AddComponent(UIBaseContainer, vfx_free_path)
  self.cd_text = self:AddComponent(UITextMeshProUGUIEx, cd_text_path)
  self.scrollView = self:AddComponent(UIBaseContainer, scrollView_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  DataCenter.ActEpidemicZoneManager:ReqBattleFreeSpeedInfo()
  self:DataReset()
  self:ReInit()
end

function UIEpidemicBattleSpeedView:OnDestroy()
  self:ClearScroll()
  self.content:SetAnchoredPosition(Vector2.New(0, 0))
  self.content:Dispose()
  self.panel = nil
  self.close_btn = nil
  self.title_text = nil
  self.slider = nil
  self.pro_img = nil
  self.left_time = nil
  self.img_quality = nil
  self.item_icon = nil
  self.own_text = nil
  self.use_btn = nil
  self.vfx_free = nil
  self.cd_text = nil
  self.content = nil
  self.scrollView = nil
  self:DataReset()
  base.OnDestroy(self)
end

function UIEpidemicBattleSpeedView:DataReset()
  self.speedType = nil
  self.template = {}
  self.moreItemId = nil
  self.moreIndex = nil
  self.endTime = 0
  self.startTime = 0
  self.ScienceBgActive = nil
  self.items = {}
  self.buyItems = {}
  self.itemNum = nil
  self.laseTime = 0
  self.lastChangeTime = 0
  self.sliderValue = nil
  self.leftText = nil
  self.useItem = {}
  self.moreBtnPosition = nil
  self.moreBtnName = nil
  self.cells = {}
  self.titleText = nil
  self.moreParent = nil
  self.isCreateScroll = false
  self.listGO = {}
  self.addTime = 0
  self.freeCdTime = 0
end

function UIEpidemicBattleSpeedView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UIScrollToSomeWhere, self.GuidAutoScroll)
  self:AddUIListener(EventId.EpidemicBattleSpeedUpdate, self.UpdateFree)
  self:AddUIListener(EventId.UpdateGold, self.RefreshScrollGoldColor)
end

function UIEpidemicBattleSpeedView:OnRemoveListener()
  self:RemoveUIListener(EventId.UIScrollToSomeWhere, self.GuidAutoScroll)
  self:RemoveUIListener(EventId.EpidemicBattleSpeedUpdate, self.UpdateFree)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshScrollGoldColor)
  base.OnRemoveListener(self)
end

function UIEpidemicBattleSpeedView:RefreshScrollGoldColor()
  local gold = LuaEntry.Player.gold
  for _, cell in pairs(self.cells) do
    if cell and cell.RefreshColor then
      cell:RefreshColor(gold)
    end
  end
end

function UIEpidemicBattleSpeedView:ReInit()
  self.speedType = ItemSpdMenu.ItemSpdMenu_Troop
  self.uuid = self:GetUserData()
  self.needUpdate = true
  self.marchData = DataCenter.WorldMarchDataManager:GetMarch(self.uuid)
  if not self.marchData then
    return
  end
  self.endTime = self.marchData.endTime
  self.startTime = self.marchData.startTime
  self:ShowCells()
  self:UpdateFree()
end

function UIEpidemicBattleSpeedView:ShowCells()
  self:GetAllItems()
  local count = #self.items + #self.buyItems
  self.content:SetActive(true)
  if not self.isCreateScroll then
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(function()
    end)
    self.content:Init(bindFunc1, bindFunc2, bindFunc3)
  end
  self.content:SetAnchoredPosition(Vector2.New(0, 0))
  self.content:SetItemCount(count)
  self.content:ForceUpdate()
  self.isCreateScroll = true
end

function UIEpidemicBattleSpeedView:GuidAutoScroll(itemId)
  if self.items then
    local index
    for i = 1, table.count(self.items) do
      if self.items[i].itemId == tostring(itemId) then
        index = i
      end
    end
    if index then
      if 3 < index then
        index = index - 2
      end
      self.content:MoveItemByIndex(index - 1, 0.3)
    end
  end
end

function UIEpidemicBattleSpeedView:ClearScroll()
  self.scrollView:RemoveComponents(UIEBS_ItemCell)
  self.content:DestroyChildNode()
end

function UIEpidemicBattleSpeedView:OnInitScroll(go, index)
  local item = self.scrollView:AddComponent(UIEBS_ItemCell, go)
  item:SetActive(true)
  self.listGO[go] = item
end

function UIEpidemicBattleSpeedView:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  local param = UIEBS_ItemCell.Param.New()
  if index + 1 > self.itemNum then
    param.stateType = UIEBS_ItemCell.StateType.Buy
    param.template = self.buyItems[index + 1 - self.itemNum]
    param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
  else
    param.stateType = UIEBS_ItemCell.StateType.Own
    param.count = self.items[index + 1].count
    param.template = self:GetItemTemplate(self.items[index + 1].itemId)
    param.itemId = self.items[index + 1].itemId
    cellItem.gameObject.name = param.itemId
  end
  
  function param.callBack(idx, template, isBuy)
    self:CellsCallBack(idx, template, isBuy)
  end
  
  param.index = index + 1
  cellItem:ReInit(param)
  self.cells[index + 1] = cellItem
end

function UIEpidemicBattleSpeedView:CellsCallBack(index, template, isBuy)
  if isBuy then
    if LuaEntry.Player.gold >= template.price then
      UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING, string.GetFormattedSeperatorNum(template.price), Localization:GetString(GameDialogDefine.DIAMOND), DataCenter.ItemTemplateManager:GetName(template.id)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:ConfirmBuy(template)
      end)
    else
      GoToUtil.GotoPayTips(template.price)
    end
  else
    self.moreIndex = index
    local item
    if self.items[index].itemId == "GolloesFreeTime" or self.items[index].itemId == "Speedup_Consigliere" or self.items[index].itemId == "Speedup_kongzhitai" or self.items[index].itemId == "Speedup_FederalCop" then
      item = self.items[index]
    else
      for i = 1, #self.items do
        if self.items[i].itemId == template.id then
          item = self.items[i]
          break
        end
      end
    end
    if not item then
      return
    end
    self.moreItemId = item.itemId
    self:ConfirmUse(template, item)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Speed_Button, false)
  end
end

function UIEpidemicBattleSpeedView:ConfirmUse(template, item)
  local id = template.id
  SFSNetwork.SendMessage(MsgDefines.WorldMarchRapid, self.uuid, id, false)
  self:ReduceTimeByTemplate(template)
  DataCenter.ItemData:UseTool(id, 1)
  if item.count == 1 then
    self:GetAllItems()
    local param = {}
    for i = 1, #self.buyItems do
      if item.para3 == self.buyItems[i].para3 then
        param.template = self.buyItems[i]
      end
    end
    if param.template then
      param.stateType = UIEBS_ItemCell.StateType.Buy
      param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
      
      function param.callBack(index, _template, isBuy)
        self:CellsCallBack(index, _template, isBuy)
      end
      
      param.index = self.moreIndex
      self.cells[self.moreIndex]:ReInit(param)
    else
      self.content:SetItemCount(#self.items + #self.buyItems)
      self.content:ForceUpdate()
    end
  end
  if self.cells[self.moreIndex] ~= nil and 1 <= item.count then
    self.cells[self.moreIndex]:RefreshOwnCount(item.count)
  end
  EventManager:GetInstance():Broadcast(EventId.AddSpeedSuccess, NewQueueType.Science)
end

function UIEpidemicBattleSpeedView:ConfirmBuy(template)
  SFSNetwork.SendMessage(MsgDefines.WorldMarchRapid, self.uuid, template.id, true)
  self:ReduceTimeByTemplate(template)
  LuaEntry.Player.gold = LuaEntry.Player.gold - template.price
  EventManager:GetInstance():Broadcast(EventId.UpdateGold)
end

function UIEpidemicBattleSpeedView:Update100MS()
  if self.endTime ~= nil then
    local curTime = 0
    if self.needUpdate then
      curTime = UITimeManager:GetInstance():GetServerTime()
    else
      curTime = self.startTime + self.addTime
    end
    if curTime >= self.endTime then
      self.endTime = 0
      self.ctrl:CloseSelf()
    else
      local changeTime = self.endTime - curTime
      local maxTime = self.endTime - self.startTime
      if 0 < changeTime then
        local tempTimeSec = math.ceil(changeTime / 1000)
        if tempTimeSec ~= self.laseTime then
          self.laseTime = tempTimeSec
          local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
          self:SetLeftText(tempTimeValue)
        end
        if 0 < maxTime then
          local tempValue = 1 - changeTime / maxTime
          if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.lastChangeTime, maxTime, SliderLength) then
            self.lastChangeTime = changeTime
            self:SetSliderValue(tempValue)
          end
        end
      end
    end
  end
  self:UpdateFreeCd()
end

function UIEpidemicBattleSpeedView:SetProBgPath(state)
  if self.lastState ~= state then
    if state then
      self.pro_img:LoadSpriteAuto(string.format(LoadPath.CommonNewPath, "Common_pro_green"))
      self.content:MoveItemByIndex(0, 0.3)
    else
      self.pro_img:LoadSpriteAuto(string.format(LoadPath.CommonNewPath, "Common_pro_yellow"))
    end
    self.lastState = state
  end
end

function UIEpidemicBattleSpeedView:SetSliderValue(value)
  if self.sliderValue ~= value then
    self.sliderValue = value
    self.slider:SetValue(value)
  end
end

function UIEpidemicBattleSpeedView:SetLeftText(value)
  if self.leftText ~= value then
    self.leftText = value
    self.left_time:SetText(value)
  end
end

local function SortItem(a, b)
  local goodsTemplate1 = DataCenter.ItemTemplateManager:GetItemTemplate(a.itemId)
  local goodsTemplate2 = DataCenter.ItemTemplateManager:GetItemTemplate(b.itemId)
  if goodsTemplate1 == nil then
    return false
  elseif goodsTemplate2 == nil then
    return true
  else
    if goodsTemplate1.type2 < goodsTemplate2.type2 then
      return false
    elseif goodsTemplate1.type2 > goodsTemplate2.type2 then
      return true
    end
    if goodsTemplate1.order > goodsTemplate2.order then
      return false
    elseif goodsTemplate1.order < goodsTemplate2.order then
      return true
    else
      local id1 = tonumber(a.itemId)
      local id2 = tonumber(b.itemId)
      if id1 > id2 then
        return true
      elseif id1 < id2 then
        return false
      end
    end
  end
  return false
end

local function SortItemTemplate(a, b)
  if a == nil then
    return false
  elseif b == nil then
    return true
  elseif a.order > b.order then
    return false
  elseif a.order < b.order then
    return true
  else
    local id1 = tonumber(a.id)
    local id2 = tonumber(b.id)
    if id1 > id2 then
      return true
    elseif id1 < id2 then
      return false
    end
  end
  return false
end

function UIEpidemicBattleSpeedView:GetAllItems()
  self.items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_108) or {}
  table.sort(self.items, SortItem)
  self.itemNum = #self.items
  local buyItems = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_108)
  self.buyItems = {}
  if buyItems then
    for _, v in pairs(buyItems) do
      if v.price > 0 then
        table.insert(self.buyItems, v)
      end
    end
  end
  table.sort(self.buyItems, SortItemTemplate)
  for i = #self.buyItems, 1, -1 do
    for k = 1, #self.items do
      if self.items[k].para1 and self.buyItems[i].para3 and self.items[k].para1 == self.buyItems[i].para3 then
        table.remove(self.buyItems, i)
      end
    end
  end
end

function UIEpidemicBattleSpeedView:GetItemTemplate(id)
  local temp = self.template[id]
  if temp == nil then
    self.template[id] = DataCenter.ItemTemplateManager:GetItemTemplate(id)
  end
  return self.template[id]
end

function UIEpidemicBattleSpeedView:ReduceTimeByTemplate(template)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = (self.endTime - curTime) * tonumber(template.para3) * 0.01
  if self.needUpdate then
    self.endTime = self.endTime - time
    self.startTime = self.startTime - time
  else
    self.addTime = self.addTime + time
  end
end

function UIEpidemicBattleSpeedView:UpdateFree()
  local battleInfo = DataCenter.ActEpidemicZoneManager:GetBattleInfo()
  local cur = battleInfo.speedCount or 0
  local max = battleInfo.speedMaxCount or 0
  self.vfx_free:SetActive(0 < cur)
  self.freeCdTime = battleInfo.speedCdTime or 0
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = math.max(self.freeCdTime - curSec, 0)
  self.own_text:SetLocalText("YiBianJinQu_speed_up_tips_3", cur .. "/" .. max)
  if 0 < remainTime then
    self.cd_text:SetActive(true)
    self:UpdateFreeCd()
  else
    if cur < max and self.freeCdTime == 0 then
      self:TryReqFree()
      self.cd_text:SetActive(false)
    elseif cur == max then
      self.cd_text:SetActive(true)
      self.cd_text:SetLocalText("YiBianJinQu_errorcode_13")
    end
    self.freeCdTime = 0
  end
end

function UIEpidemicBattleSpeedView:UpdateFreeCd()
  if self.freeCdTime == 0 then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = math.max(self.freeCdTime - curSec, 0)
  local str = UITimeManager:GetInstance():SecondToFmtString(remainTime)
  self.cd_text:SetLocalText("YiBianJinQu_speed_up_tips_4", str)
  if remainTime == 0 then
    self.freeCdTime = 0
    self:TryReqFree()
  end
end

function UIEpidemicBattleSpeedView:OnClickBtnUse()
  local battleInfo = DataCenter.ActEpidemicZoneManager:GetBattleInfo()
  local cur = battleInfo.speedCount or 0
  if cur == 0 then
    UIUtil.ShowTipsId("jeep_speed_run_out_tips")
    return
  end
  DataCenter.ActEpidemicZoneManager:ReqBattleFreeSpeed(self.uuid)
  local template = self.buyItems[#self.buyItems]
  self:ReduceTimeByTemplate(template)
end

function UIEpidemicBattleSpeedView:TryReqFree()
  local lastTime = self.lastReqTime or 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - lastTime < 3000 then
    return
  end
  self.lastReqTime = curTime
  DataCenter.ActEpidemicZoneManager:ReqBattleFreeSpeedInfo()
end

return UIEpidemicBattleSpeedView
