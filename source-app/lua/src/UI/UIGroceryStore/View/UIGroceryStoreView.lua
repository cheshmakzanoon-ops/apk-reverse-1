local UIGroceryStoreView = BaseClass("UIGroceryStoreView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UIGroceryStoreCell = require("UI.UIGroceryStore.Component.UIGroceryStoreCell")
local click_area_path = "Click_Area"
local close_btn_path = "safeArea/CloseBtn"
local title_path = "safeArea/panel/title_main"
local normal_path = "safeArea/panel/Normal_Go"
local scroll_view1_path = "safeArea/panel/Normal_Go/ScrollView1"
local deliver_item_name_text_path = "safeArea/panel/Normal_Go/common_bg/Item_Name_Text"
local deliver_normal_path = "safeArea/panel/Normal_Go/common_bg/Normal_State_Go"
local deliver_normal_item_info_btn_path = "safeArea/panel/Normal_Go/common_bg/Normal_State_Go/Item_Btn"
local deliver_normal_item_icon_path = "safeArea/panel/Normal_Go/common_bg/Normal_State_Go/Item_Btn/Item_Icon"
local deliver_normal_item_complete_icon_path = "safeArea/panel/Normal_Go/common_bg/Normal_State_Go/Item_Btn/Complete_Hint_Icon"
local deliver_normal_item_need_text_path = "safeArea/panel/Normal_Go/common_bg/Normal_State_Go/Num_Go/Need_Num_Text"
local deliver_normal_item_has_text_path = "safeArea/panel/Normal_Go/common_bg/Normal_State_Go/Num_Go/Current_Num_Text"
local deliver_normal_num_path = "safeArea/panel/Normal_Go/common_bg/Normal_State_Go/Num_Go/Kill_Text"
local deliver_normal_btn_path = "safeArea/panel/Normal_Go/common_bg/Normal_State_Go/Send_Btn"
local deliver_normal_btn_text_path = "safeArea/panel/Normal_Go/common_bg/Normal_State_Go/Send_Btn/Send_Btn_Text"
local deliver_normal_get_more_btn_path = "safeArea/panel/Normal_Go/common_bg/Normal_State_Go/Send_Get_More_Btn"
local deliver_normal_get_more_btn_text_path = "safeArea/panel/Normal_Go/common_bg/Normal_State_Go/Send_Get_More_Btn/Send_Get_More_Btn_Text"
local deliver_normal_delete_btn_path = "safeArea/panel/Normal_Go/common_bg/Normal_State_Go/Delete_Btn"
local deliver_complete_path = "safeArea/panel/Normal_Go/common_bg/Complete_Go"
local deliver_complete_text_path = "safeArea/panel/Normal_Go/common_bg/Complete_Go/Complete_Text"
local deliver_complete_time_text_path = "safeArea/panel/Normal_Go/common_bg/Complete_Go/Complete_Time_Go/Complete_Time_text"
local deliver_delete_path = "safeArea/panel/Normal_Go/common_bg/Delete_Go"
local deliver_delete_time_text_path = "safeArea/panel/Normal_Go/common_bg/Delete_Go/Time_Go/Time_text"
local deliver_delete_hint_text_path = "safeArea/panel/Normal_Go/common_bg/Delete_Go/Cool_Down_Text"
local deliver_reward_path = "safeArea/panel/Normal_Go/common_bg/Get_Item_Go"
local deliver_reward_item_1_path = "safeArea/panel/Normal_Go/common_bg/Get_Item_Go/Get_Item_1"
local deliver_reward_item_1_num_text_path = "safeArea/panel/Normal_Go/common_bg/Get_Item_Go/Get_Item_1/Get_Item_1_Num"
local deliver_reward_item_1_icon_path = "safeArea/panel/Normal_Go/common_bg/Get_Item_Go/Get_Item_1/Get_Item_1_Num/Get_Item_1_Icon"
local deliver_reward_item_2_path = "safeArea/panel/Normal_Go/common_bg/Get_Item_Go/Get_Item_2"
local deliver_reward_item_2_num_text_path = "safeArea/panel/Normal_Go/common_bg/Get_Item_Go/Get_Item_2/Get_Item_2_Num"
local deliver_reward_item_2_icon_path = "safeArea/panel/Normal_Go/common_bg/Get_Item_Go/Get_Item_2/Get_Item_2_Num/Get_Item_2_Icon"
local extra_effect_path = "safeArea/UIExtraEffect"

local function OnCreate(self)
  base.OnCreate(self)
  self.isArrow = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self.ctrl:GetDataFromServer()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.click_area = self:AddComponent(UIButton, click_area_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.normal = self:AddComponent(UIBaseContainer, normal_path)
  self.title = self:AddComponent(UIText, title_path)
  self.deliver_item_name_text = self:AddComponent(UIText, deliver_item_name_text_path)
  self.deliver_item_name_text:SetLocalText(100092)
  self.deliver_normal = self:AddComponent(UIBaseContainer, deliver_normal_path)
  self.deliver_normal_item_icon = self:AddComponent(UIImage, deliver_normal_item_icon_path)
  self.deliver_normal_item_complete_icon = self:AddComponent(UIImage, deliver_normal_item_complete_icon_path)
  self.deliver_normal_item_info_btn = self:AddComponent(UIButton, deliver_normal_item_info_btn_path)
  self.deliver_normal_item_need_text = self:AddComponent(UIText, deliver_normal_item_need_text_path)
  self.deliver_normal_item_has_text = self:AddComponent(UIText, deliver_normal_item_has_text_path)
  self.deliver_normal_num = self:AddComponent(UIText, deliver_normal_num_path)
  self.deliver_normal_btn = self:AddComponent(UIButton, deliver_normal_btn_path)
  self.deliver_normal_btn_text = self:AddComponent(UIText, deliver_normal_btn_text_path)
  self.deliver_normal_get_more_btn = self:AddComponent(UIButton, deliver_normal_get_more_btn_path)
  self.deliver_normal_get_more_btn_text = self:AddComponent(UIText, deliver_normal_get_more_btn_text_path)
  self.deliver_normal_delete_btn = self:AddComponent(UIButton, deliver_normal_delete_btn_path)
  self.deliver_normal_btn_text:SetLocalText(100427)
  self.deliver_normal_get_more_btn_text:SetLocalText(100547)
  self.deliver_normal_btn:SetOnClick(function()
    self:CompleteOne()
  end)
  self.deliver_normal_item_info_btn:SetOnClick(function()
    self:OnItemInfoBtnClick()
  end)
  self.deliver_normal_get_more_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:GotoGetItem()
  end)
  self.deliver_normal_delete_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:DeleteOne()
  end)
  self.deliver_normal_delete_btn:SetActive(false)
  self.deliver_normal:SetActive(false)
  self.deliver_complete = self:AddComponent(UIBaseContainer, deliver_complete_path)
  self.deliver_complete_time_text = self:AddComponent(UIText, deliver_complete_time_text_path)
  self.deliver_complete_text = self:AddComponent(UIText, deliver_complete_text_path)
  self.deliver_complete_text:SetLocalText(130421)
  self.deliver_complete:SetActive(false)
  self.deliver_delete = self:AddComponent(UIBaseContainer, deliver_delete_path)
  self.deliver_delete_time_text = self:AddComponent(UIText, deliver_delete_time_text_path)
  self.deliver_delete_hint_text = self:AddComponent(UIText, deliver_delete_hint_text_path)
  self.deliver_delete_hint_text:SetLocalText(130421)
  self.deliver_delete:SetActive(false)
  self.deliver_reward = self:AddComponent(UIBaseContainer, deliver_reward_path)
  self.deliver_reward_item_1 = self:AddComponent(UIBaseContainer, deliver_reward_item_1_path)
  self.deliver_reward_item_1_num_text = self:AddComponent(UIText, deliver_reward_item_1_num_text_path)
  self.deliver_reward_item_1_icon = self:AddComponent(UIImage, deliver_reward_item_1_icon_path)
  self.deliver_reward_item_2 = self:AddComponent(UIBaseContainer, deliver_reward_item_2_path)
  self.deliver_reward_item_2_num_text = self:AddComponent(UIText, deliver_reward_item_2_num_text_path)
  self.deliver_reward_item_2_icon = self:AddComponent(UIImage, deliver_reward_item_2_icon_path)
  self.deliver_reward:SetActive(false)
  self.title:SetText("")
  self.scroll_view1 = self:AddComponent(UIScrollView, scroll_view1_path)
  self.scroll_view1:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view1:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.extra_effect = self:AddComponent(UIExtraEffect, extra_effect_path)
end

local function ComponentDestroy(self)
  self.click_area = nil
  self.close_btn = nil
  self.normal = nil
  self.title = nil
  self.deliver_item_name_text = nil
  self.deliver_normal = nil
  self.deliver_normal_item_icon = nil
  self.deliver_normal_item_need_text = nil
  self.deliver_normal_item_has_text = nil
  self.deliver_normal_btn = nil
  self.deliver_normal_btn_text = nil
  self.deliver_normal_get_more_btn = nil
  self.deliver_normal_get_more_btn_text = nil
  self.deliver_normal_delete_btn = nil
  self.deliver_normal_num = nil
  self.deliver_complete = nil
  self.deliver_complete_time_text = nil
  self.deliver_complete_text = nil
  self.deliver_delete = nil
  self.deliver_delete_time_text = nil
  self.deliver_delete_hint_text = nil
  self.deliver_reward = nil
  self.deliver_reward_item_1 = nil
  self.deliver_reward_item_1_num_text = nil
  self.deliver_reward_item_1_icon = nil
  self.deliver_reward_item_2 = nil
  self.deliver_reward_item_2_num_text = nil
  self.deliver_reward_item_2_icon = nil
  self.scroll_view1 = nil
  self.extra_effect = nil
end

local function DataDefine(self)
  self.currentSelectDataIndex = -1
  self.panelData = nil
  self.isSendCmd = false
  self.cells = {}
end

local function DataDestroy(self)
  self.currentSelectDataIndex = nil
  self.panelData = nil
  self.isSendCmd = false
  self.cells = nil
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local item
  item = self.scroll_view1:AddComponent(UIGroceryStoreCell, itemObj)
  local param = self.panelData.orderList[index]
  item:ReInit(param)
  self.cells[index] = item
end

local function OnDeleteCell(self, itemObj, index)
  if self.deliver == index then
    self.select_go.transform:SetParent(self.transform)
    self.select_go:SetActive(false)
  end
  self.cells[index] = nil
  self.scroll_view1:RemoveComponent(itemObj.name, UIGroceryStoreCell)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshGroceryStoreOrder, self.DoWhenDataBack)
  self:AddUIListener(EventId.GetNewGroceryStoreOrder, self.DoWhenDataBack)
  self:AddUIListener(EventId.EndGroceryStoreOrder, self.DoWhenAllComplete)
  self:AddUIListener(EventId.END_SEARCH, self.OnSearchCallBack)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshGroceryStoreOrder, self.DoWhenDataBack)
  self:RemoveUIListener(EventId.GetNewGroceryStoreOrder, self.DoWhenDataBack)
  self:RemoveUIListener(EventId.EndGroceryStoreOrder, self.DoWhenAllComplete)
  self:RemoveUIListener(EventId.END_SEARCH, self.OnSearchCallBack)
  base.OnRemoveListener(self)
end

local function OnSearchCallBack(self, param)
  if param ~= nil then
    self.ctrl:OnSearchEnd(param.pointId, param.uuid)
  end
end

local function DoWhenDataBack(self)
  self:ReInit()
end

local function DoWhenAllComplete(self)
  self:ReInit()
end

local function ReInit(self)
  self.isSendCmd = false
  self.panelData = self.ctrl:GetPanelData()
  if self.panelData == nil then
  else
    self.currentSelectDataIndex = self.panelData.selectDataIndex
    if self.isArrow then
      for i = 1, #self.panelData.orderList do
        if self.panelData.orderList[i].canSend then
          self.currentSelectDataIndex = self.panelData.orderList[i].dataIndex
          break
        end
      end
    end
    self.normal:SetActive(true)
    self:ShowCells()
    TimerManager:GetInstance():DelayInvoke(function()
      self:OnCellSelect(self.currentSelectDataIndex)
    end, 0.05)
    self.extra_effect:SetData(HeroStationEffectType.GlobalMoney, self)
  end
end

local function ShowCells(self)
  self:ClearScroll()
  local count = table.count(self.panelData.orderList)
  if 0 < count then
    self.scroll_view1:SetTotalCount(count)
    self.scroll_view1:RefillCells()
  end
end

local function ClearScroll(self)
  self.cells = {}
  self.scroll_view1:ClearCells()
  self.scroll_view1:RemoveComponents(UIGroceryStoreCell)
  self:CheckGuide()
end

local function RefreshSelect(self)
  local data = self:GetCurrentSelectData()
  self.isSendCmd = false
  if data == nil then
  else
    local index = self:GetCellIndexByDataIndex(self.currentSelectDataIndex)
    table.walk(self.cells, function(_, v)
      v:SetSelectDataIndex(self.currentSelectDataIndex)
    end)
    self.deliver_normal:SetActive(false)
    self.deliver_complete:SetActive(false)
    self.deliver_delete:SetActive(false)
    self.deliver_reward:SetActive(false)
    if data.isSend == true then
      self:RefreshComplete()
    elseif data.isDelete == true then
      self:RefreshDelete()
    else
      self:RefreshNormal()
      self:RefreshReward()
    end
  end
end

local function RefreshDelete(self)
  local data = self:GetCurrentSelectData()
  if data == nil or data.isDelete ~= true then
    return
  end
  self.deliver_delete:SetActive(true)
end

local function RefreshNormal(self)
  local data = self:GetCurrentSelectData()
  if data == nil or data.isDelete == true or data.isSend == true then
    return
  end
  self.deliver_normal:SetActive(true)
  self.deliver_normal_item_icon:LoadSprite(data.icon)
  self.deliver_normal_item_need_text:SetText("/" .. string.GetFormattedSeperatorNum(data.needNum))
  self.deliver_normal_item_has_text:SetText(string.GetFormattedSeperatorNum(data.hasNum))
  self.deliver_normal_item_complete_icon:SetActive(data.canSend == true)
  if data.productType == OrderItemType.ORDER_ITEM_TYPE_MONSTER or data.productType == OrderItemType.ORDER_ITEM_TYPE_SPECIAL_MONSTER then
    self.deliver_normal_num:SetLocalText(110172)
  else
    self.deliver_normal_num:SetText("")
  end
  if data.canSend == true then
    self.deliver_normal_item_has_text:SetColor(Color.New(0.7176470588235294, 0.4, 0.18823529411764706, 1))
  else
    self.deliver_normal_item_has_text:SetColor(Color.New(0.9176470588235294, 0.25882352941176473, 0.25882352941176473, 1))
  end
  local showDeliverBtn = data.canSend == true or data.canUseDiamond == true
  self.deliver_normal_btn:SetActive(showDeliverBtn)
  self.deliver_normal_get_more_btn:SetActive(not showDeliverBtn)
  if not showDeliverBtn then
    if data.productType == OrderItemType.ORDER_ITEM_TYPE_MONSTER or data.productType == OrderItemType.ORDER_ITEM_TYPE_SPECIAL_MONSTER then
      self.deliver_normal_get_more_btn_text:SetLocalText(110003)
    else
      self.deliver_normal_get_more_btn_text:SetLocalText(100547)
    end
  end
  self.deliver_normal_delete_btn:SetActive(data.canDelete == true)
end

local function RefreshComplete(self)
  local data = self:GetCurrentSelectData()
  if data == nil or data.isDelete == true or data.isSend ~= true then
    return
  end
  self.deliver_complete:SetActive(true)
end

local function RefreshReward(self)
  local data = self:GetCurrentSelectData()
  if data == nil or data.reward == nil then
    return
  end
  self.deliver_reward:SetActive(true)
  self:SetOneReward(self.deliver_reward_item_1, self.deliver_reward_item_1_icon, self.deliver_reward_item_1_num_text, data.reward[1])
  self:SetOneReward(self.deliver_reward_item_2, self.deliver_reward_item_2_icon, self.deliver_reward_item_2_num_text, data.reward[2])
end

local function SetOneReward(self, item, icon, numText, data)
  if data == nil then
    item:SetActive(false)
  else
    item:SetActive(true)
    icon:LoadSprite(data.icon)
    local num = data.num
    if data.rewardType == RewardType.FOOD then
      num = DataCenter.HeroStationManager:CalcEffectedValue(num, HeroStationEffectType.GlobalMoney)
      num = num * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.GROCERY_STORE_COIN_ADD_PERCENT) / 100)
      num = Mathf.Round(num)
    end
    numText:SetText(string.GetFormattedSeperatorNum(num))
  end
end

local function OnCellSelect(self, selectIndex)
  self.currentSelectDataIndex = selectIndex
  DataCenter.GroceryStoreOrderDataManager.currentSelectDataIndex = selectIndex
  self:RefreshSelect()
  if self.isArrow then
    local param = {}
    param.position = self.deliver_normal_get_more_btn.transform.position
    param.arrowType = ArrowType.Capacity
    param.positionType = PositionType.Screen
    DataCenter.ArrowManager:ShowArrow(param)
    self.isArrow = nil
  end
end

local function DoFlyAnimation(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Gulu_Get_Reward, false)
  self:FlyReward()
end

local function CompleteOne(self)
  local data = self:GetCurrentSelectData()
  if self.isSendCmd ~= false then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    return
  end
  if DataCenter.GroceryStoreOrderDataManager:IsReachMax() then
    UIUtil.ShowSingleTip(Localization:GetString("120320"))
    return
  end
  if data and data.canSend == true or data.canUseDiamond == true then
    if data.productType == OrderItemType.ORDER_ITEM_TYPE_RESOURCE_ITEM then
      local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(data.productId)
      if data.canSend == true then
        self.ctrl:CompleteOneOrder(data)
        self.isSendCmd = true
        self:DoFlyAnimation()
      elseif data.canUseDiamond == true then
        self.ctrl:CompleteOneOrder(data, function()
          self:DoFlyAnimation()
          self.ctrl:CompleteOneOrder(data)
          self.isSendCmd = true
        end)
      end
    elseif data.productType == OrderItemType.ORDER_ITEM_TYPE_GOODS then
      local item = DataCenter.ItemData:GetItemById(data.productId)
      if item ~= nil then
        self.ctrl:CompleteOneOrder(data)
        self.isSendCmd = true
        self:DoFlyAnimation()
      end
    elseif data.productType == OrderItemType.ORDER_ITEM_TYPE_MONSTER or data.productType == OrderItemType.ORDER_ITEM_TYPE_SPECIAL_MONSTER then
      self.ctrl:CompleteOneOrder(data)
      self.isSendCmd = true
      self:DoFlyAnimation()
    elseif data.productType == OrderItemType.ORDER_ITEM_TYPE_RESOURCE then
    end
  else
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_FailClick, false)
  end
end

local function GetCurrentSelectData(self)
  if self.panelData == nil then
    return
  end
  if self.panelData.orderList ~= nil then
    for _, v in ipairs(self.panelData.orderList) do
      if v.dataIndex == self.currentSelectDataIndex then
        return v
      end
    end
  end
  return nil
end

local function GetCellIndexByDataIndex(self, dataIndex)
  for k, v in ipairs(self.panelData.orderList) do
    if v.dataIndex == self.currentSelectDataIndex then
      return k
    end
  end
  return -1
end

local function GotoGetItem(self)
  local data = self:GetCurrentSelectData()
  if data then
    self.ctrl:GotoFactory(data.productId, data.productType)
  end
end

local function DeleteOne(self)
  local data = self:GetCurrentSelectData()
  if data ~= nil then
    self.ctrl:DeleteOne(data.uuid)
    self.isSendCmd = true
  end
end

local function ShowFirstKill(self)
end

local function Update(self)
  local data = self:GetCurrentSelectData()
  if data == nil then
    return
  end
  if data.isSend == true or data.isDelete == true then
    local time = data.endTime
    local now = UITimeManager:GetInstance():GetServerTime()
    local leftTime = (time - now) / 1000
    leftTime = math.max(0, leftTime)
    if data.isDelete == true then
      self.deliver_delete_time_text:SetText(UITimeManager:GetInstance():SecondToFmtString(leftTime))
    else
      self.deliver_complete_time_text:SetText(UITimeManager:GetInstance():SecondToFmtString(leftTime))
    end
  end
end

local function FlyReward(self)
  local data = self:GetCurrentSelectData()
  if data == nil then
    return
  end
  if data.reward[1] ~= nil then
    local reward1 = data.reward[1]
    UIUtil.DoFly(tonumber(reward1.rewardType), 5, reward1.icon, self.deliver_reward_item_1_icon.transform.position, Vector3.New(0, 0, 0))
  end
  if data.reward[2] ~= nil then
    local reward2 = data.reward[2]
    UIUtil.DoFly(tonumber(reward2.rewardType), 5, reward2.icon, self.deliver_reward_item_2_icon.transform.position, Vector3.New(0, 0, 0))
  end
end

local function OnItemInfoBtnClick(self)
  local data = self:GetCurrentSelectData()
  if data == nil then
    return
  end
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.deliver_normal_item_info_btn.gameObject.transform.position + Vector3.New(0, 60, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.title = data.name
  param.content = data.desc
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 240
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function GetOrderObjectByUuid(self, uuid)
  for k, v in pairs(self.cells) do
    if v.param.uuid == uuid then
      return v:GetGuideObject()
    end
  end
end

local function CheckGuide(self)
  if DataCenter.GuideManager:InGuide() and DataCenter.GuideManager:GetGuideType() == GuideType.ClickGolloesCanSubmitOrder then
    DataCenter.GuideManager:RefreshObject()
  end
end

UIGroceryStoreView.OnCreate = OnCreate
UIGroceryStoreView.OnDestroy = OnDestroy
UIGroceryStoreView.OnEnable = OnEnable
UIGroceryStoreView.OnDisable = OnDisable
UIGroceryStoreView.ComponentDefine = ComponentDefine
UIGroceryStoreView.ComponentDestroy = ComponentDestroy
UIGroceryStoreView.DataDefine = DataDefine
UIGroceryStoreView.DataDestroy = DataDestroy
UIGroceryStoreView.OnAddListener = OnAddListener
UIGroceryStoreView.OnRemoveListener = OnRemoveListener
UIGroceryStoreView.DoWhenDataBack = DoWhenDataBack
UIGroceryStoreView.DoWhenAllComplete = DoWhenAllComplete
UIGroceryStoreView.ReInit = ReInit
UIGroceryStoreView.Update = Update
UIGroceryStoreView.OnCreateCell = OnCreateCell
UIGroceryStoreView.OnDeleteCell = OnDeleteCell
UIGroceryStoreView.ShowCells = ShowCells
UIGroceryStoreView.RefreshSelect = RefreshSelect
UIGroceryStoreView.ClearScroll = ClearScroll
UIGroceryStoreView.OnCellSelect = OnCellSelect
UIGroceryStoreView.CompleteOne = CompleteOne
UIGroceryStoreView.GetCurrentSelectData = GetCurrentSelectData
UIGroceryStoreView.GotoGetItem = GotoGetItem
UIGroceryStoreView.OnSearchCallBack = OnSearchCallBack
UIGroceryStoreView.DoFlyAnimation = DoFlyAnimation
UIGroceryStoreView.DeleteOne = DeleteOne
UIGroceryStoreView.RefreshDelete = RefreshDelete
UIGroceryStoreView.RefreshNormal = RefreshNormal
UIGroceryStoreView.RefreshComplete = RefreshComplete
UIGroceryStoreView.RefreshReward = RefreshReward
UIGroceryStoreView.SetOneReward = SetOneReward
UIGroceryStoreView.ShowFirstKill = ShowFirstKill
UIGroceryStoreView.FlyReward = FlyReward
UIGroceryStoreView.GetCellIndexByDataIndex = GetCellIndexByDataIndex
UIGroceryStoreView.OnItemInfoBtnClick = OnItemInfoBtnClick
UIGroceryStoreView.GetOrderObjectByUuid = GetOrderObjectByUuid
UIGroceryStoreView.CheckGuide = CheckGuide
return UIGroceryStoreView
