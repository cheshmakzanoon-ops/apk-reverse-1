local UIResidentOrderCell = require("UI.UIResidentOrder.Component.UIResidentOrderCell")
local UIResidentOrderView = BaseClass("UIResidentOrderView", UIBaseView)
local base = UIBaseView
local return_btn_path = "Panel"
local npc_image_path = "main/roleBg"
local txt_des_path = "main/imgBg/desTxt"
local need_item_list_path = "main/imgBg/needItemList"
local enter_btn_path = "main/imgBg/enterBtn"
local enter_btn_name_path = "main/imgBg/enterBtn/enterTxt"
local close_btn_path = "main/imgBg/cancelBtn"
local close_btn_name_path = "main/imgBg/cancelBtn/cancelTxt"
local end_time_value_path = "main/imgBg/timeObj/endTimeTxt"
local end_time_text_path = "main/imgBg/timeObj/timeDesTxt"
local money_value_path = "main/imgBg/awardObj/awardNum"
local reward_text_path = "main/imgBg/awardObj/awardDesTxt"
local bg_path = "main/imgBg"
local this_path = ""
local main_path = "main"
local BgSize = {
  {
    x = 1145,
    PaddingLeft = 56,
    mainBgX = 167.5
  },
  {
    x = 1370,
    PaddingLeft = 0,
    mainBgX = 48
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  local ret, time = self.this_anim:GetAnimationReturnTime("UIResidentOrder_movein")
  if ret then
    self.closeTimer = TimerManager:GetInstance():GetTimer(time, function()
      if self.closeTimer ~= nil then
        self.closeTimer:Stop()
        self.closeTimer = nil
      end
      self:SetBtnAnimEnable(true)
    end, self, true, false, false)
    self.closeTimer:Start()
  else
    self:SetBtnAnimEnable(true)
  end
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  if self.closeTimer ~= nil then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.this_anim = self:AddComponent(UIAnimator, this_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.npc_image = self:AddComponent(UIImage, npc_image_path)
  self.txt_des = self:AddComponent(UIText, txt_des_path)
  self.need_item_list = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, need_item_list_path)
  self.submit_btn = self:AddComponent(UIButton, enter_btn_path)
  self.submit_btn_anim = self:AddComponent(UIAnimator, enter_btn_path)
  self.submit_btn_name = self:AddComponent(UIText, enter_btn_name_path)
  self.submit_btn_name_shadow = self:AddComponent(UIShadow, enter_btn_name_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn_anim = self:AddComponent(UIAnimator, close_btn_path)
  self.close_btn_name = self:AddComponent(UIText, close_btn_name_path)
  self.end_time_value = self:AddComponent(UIText, end_time_value_path)
  self.end_time_text = self:AddComponent(UIText, end_time_text_path)
  self.money_value = self:AddComponent(UIText, money_value_path)
  self.reward_text = self:AddComponent(UIText, reward_text_path)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.main = self:AddComponent(UIBaseContainer, main_path)
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:Close()
  end)
  self.return_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:Close()
  end)
  self.submit_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSubmitBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.return_btn = nil
  self.npc_image = nil
  self.txt_des = nil
  self.need_item_list = nil
  self.submit_btn = nil
  self.submit_btn_name = nil
  self.submit_btn_name_shadow = nil
  self.close_btn = nil
  self.close_btn_name = nil
  self.end_time_value = nil
  self.end_time_text = nil
  self.money_value = nil
  self.reward_text = nil
  self.bg = nil
  self.submit_btn_anim = nil
  self.close_btn_anim = nil
  self.main = nil
end

local function DataDefine(self)
  self.orderUuid = nil
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.endTime = 0
  self.template = nil
  self.needResourceItemCells = {}
  self.freeNeedResourceItemCells = {}
  self.loadingCell = {}
  self.isRed = false
  self.bgSize = self.bg.rectTransform.sizeDelta
  self.mainPosition = Vector3.New(0, 0, 0)
end

local function DataDestroy(self)
  self.orderUuid = nil
  self.timer_action = nil
  self:DeleteTimer()
  self.endTime = nil
  self.template = nil
  self.needResourceItemCells = nil
  self.freeNeedResourceItemCells = nil
  self.loadingCell = nil
  self.isRed = nil
  self.bgSize = nil
  self.mainPosition = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.orderUuid = self:GetUserData()
  local info = DataCenter.ResidentOrderDataManager:GetResidentOrderByUuid(self.orderUuid)
  if info ~= nil then
    self.endTime = info.expTime
    self.template = DataCenter.OrderTemplateManager:GetOrderTemplate(info.orderId)
    if self.template ~= nil then
      self.npc_image:LoadSprite(string.format(LoadPath.UINPCPath, self.template.npc))
      self.npc_image:SetNativeSize()
      self.txt_des:SetLocalText(self.template.des)
      self.submit_btn_name:SetLocalText(GameDialogDefine.SUBMIT_ORDER)
      self.close_btn_name:SetLocalText(GameDialogDefine.CANCEL)
      self.end_time_text:SetLocalText(390314)
      self.reward_text:SetLocalText(130065)
      self.money_value:SetText("+ " .. self.template:GetResidentOrderMoney())
      self:RefreshTime()
      self:AddTimer()
      self:ShowNeedResourceItems()
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnSubmitBtnClick(self)
  local state = DataCenter.ResidentOrderDataManager:GetOrderStateByOrderUuid(self.orderUuid)
  if state == ResidentOrderState.Yes then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now < self.endTime then
      local pos = self.money_value.gameObject.transform.position
      DataCenter.FlyResourceEffectManager:ShowGetResourceEffect(pos, ResourceType.Food, 3)
      DataCenter.ResidentOrderDataManager:SendOrderFinish(self.orderUuid)
      self:Close()
    end
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.endTime - now
  if leftTime <= 0 then
    self.end_time_value:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
  else
    self.end_time_value:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  end
end

local function ShowNeedResourceItems(self)
  for k, v in pairs(self.needResourceItemCells) do
    v:SetActive(false)
    table.insert(self.freeNeedResourceItemCells, v)
  end
  self.isRed = false
  local items = self.template:GetNeedResourceItem()
  if items ~= nil then
    local count = table.count(items)
    self:RefreshBgWidth(count)
    for i = 1, count do
      local param = UIResidentOrderCell.Param.New()
      param.itemId = items[i].needId
      param.count = items[i].count
      local own = 0
      local data = DataCenter.ResourceItemDataManager:GetItemDataByItemId(param.itemId, LuaEntry.Player.uid)
      if data ~= nil then
        own = data.number
      end
      if own < param.count then
        param.isRed = true
        self.isRed = true
      else
        param.isRed = false
      end
      self:AddOneNeedResourceCells(param)
    end
  end
  self:RefreshBtn()
end

local function AddOneNeedResourceCells(self, param)
  if #self.freeNeedResourceItemCells > 0 then
    local temp = table.remove(self.freeNeedResourceItemCells)
    if temp ~= nil then
      temp:SetActive(true)
      temp:ReInit(param)
      temp.transform:SetParent(self.need_item_list.transform)
      temp.transform:SetAsLastSibling()
      self.needResourceItemCells[param.itemId] = temp
    end
  elseif self.loadingCell[param.itemId] == nil then
    self.loadingCell[param.itemId] = true
    self:GameObjectInstantiateAsync(UIAssets.UIResidentOrderCell, function(request)
      self.loadingCell[param.itemId] = nil
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.need_item_list.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:SetAsLastSibling()
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      self.needResourceItemCells[param.itemId] = self.need_item_list:AddComponent(UIResidentOrderCell, nameStr)
      self.needResourceItemCells[param.itemId]:ReInit(param)
    end)
  end
end

local function RefreshState(self)
  self.isRed = false
  for k, v in pairs(self.needResourceItemCells) do
    local own = 0
    local data = DataCenter.ResourceItemDataManager:GetItemDataByItemId(v.param.itemId, LuaEntry.Player.uid)
    if data ~= nil then
      own = data.number
    end
    if own < v.param.count then
      v:RefreshIsRed(true)
      self.isRed = true
    else
      v:RefreshIsRed(false)
    end
  end
  self:RefreshBtn()
end

local function RefreshBtn(self)
  if self.isRed then
    self.submit_btn:SetInteractable(false)
    self.submit_btn_name_shadow:SetAllColor(YellowBtnShadowGrayColor)
  else
    self.submit_btn:SetInteractable(true)
    self.submit_btn_name_shadow:SetAllColor(YellowBtnShadowLightColor)
  end
end

local function RefreshBgWidth(self, count)
  self.bgSize.x = BgSize[count].x
  self.bg.rectTransform.sizeDelta = self.bgSize
  self.need_item_list:SetPaddingLeft(BgSize[count].PaddingLeft)
  self.mainPosition.x = BgSize[count].mainBgX
  self.main.transform.localPosition = self.mainPosition
end

local function SetBtnAnimEnable(self, isEnable)
  self.submit_btn_anim:Enable(isEnable)
  self.close_btn_anim:Enable(isEnable)
end

local function Close(self)
  self:SetBtnAnimEnable(false)
  for k, v in pairs(self.needResourceItemCells) do
    v:PlayExitAnim()
  end
  self.ctrl:CloseSelf()
end

UIResidentOrderView.OnCreate = OnCreate
UIResidentOrderView.OnDestroy = OnDestroy
UIResidentOrderView.OnEnable = OnEnable
UIResidentOrderView.OnDisable = OnDisable
UIResidentOrderView.OnAddListener = OnAddListener
UIResidentOrderView.OnRemoveListener = OnRemoveListener
UIResidentOrderView.ComponentDefine = ComponentDefine
UIResidentOrderView.ComponentDestroy = ComponentDestroy
UIResidentOrderView.DataDefine = DataDefine
UIResidentOrderView.DataDestroy = DataDestroy
UIResidentOrderView.ReInit = ReInit
UIResidentOrderView.OnSubmitBtnClick = OnSubmitBtnClick
UIResidentOrderView.DeleteTimer = DeleteTimer
UIResidentOrderView.AddTimer = AddTimer
UIResidentOrderView.OnSubmitBtnClick = OnSubmitBtnClick
UIResidentOrderView.RefreshTime = RefreshTime
UIResidentOrderView.RefreshBtn = RefreshBtn
UIResidentOrderView.RefreshState = RefreshState
UIResidentOrderView.ShowNeedResourceItems = ShowNeedResourceItems
UIResidentOrderView.AddOneNeedResourceCells = AddOneNeedResourceCells
UIResidentOrderView.RefreshBgWidth = RefreshBgWidth
UIResidentOrderView.SetBtnAnimEnable = SetBtnAnimEnable
UIResidentOrderView.Close = Close
return UIResidentOrderView
