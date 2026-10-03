local UIBattlePassBuyView = BaseClass("UIBattlePassBuyView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIBattlePassItemCell = require("UI.UIActivityCenterTable.Component.UIBattlePass.UIBattlePassItemCell")
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local maskBtn_path = "UICommonPopUpTitle/panel"
local tips_txt_path = "Tip"
local progress_txt_path = "Rect_Bottom/Txt_Progress"
local minus_btn_path = "Rect_Bottom/Btn_Minus"
local add_btn_path = "Rect_Bottom/Btn_Add"
local lv_slider_path = "Rect_Bottom/Slider_Lv"
local content_path = "ScrollView/Viewport/Content"
local buy_btn_path = "Btn_Buy"
local buy_txt_path = "Btn_Buy/ImmediatelyBtn/Txt_Buy"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtnN = self:AddComponent(UIButton, maskBtn_path)
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleTxtN = self:AddComponent(UIText, title_path)
  self.titleTxtN:SetLocalText(320435)
  self._minus_btn = self:AddComponent(UIButton, minus_btn_path)
  self._add_btn = self:AddComponent(UIButton, add_btn_path)
  self._minus_btn:SetOnClick(function()
    self:OnMinusClick()
  end)
  self._add_btn:SetOnClick(function()
    self:OnAddClick()
  end)
  self._progress_txt = self:AddComponent(UIText, progress_txt_path)
  self._lv_slider = self:AddComponent(UISlider, lv_slider_path)
  self._lv_slider:SetOnValueChanged(function(value)
    self:ValueChanged(value)
  end)
  self._tips_txt = self:AddComponent(UIText, tips_txt_path)
  self._buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self._buy_txt = self:AddComponent(UIText, buy_txt_path)
  self._buy_btn:SetOnClick(function()
    self:OnBuyClick()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
  self.goalN = nil
  self.tip1N = nil
  self.tip2N = nil
  self.tip3N = nil
  self.tip4N = nil
  self.joinBtnN = nil
  self.joinBtnTxtN = nil
  self.createBtnN = nil
  self.createBtnTxtN = nil
  self.closeBtnN = nil
end

local function DataDefine(self)
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBattlePassRefresh, self.RefreshBattlePass)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBattlePassRefresh, self.RefreshBattlePass)
end

local function DataDestroy(self)
  self:SetAllNeedCellDestroy()
  self._lv_slider:SetValue(0)
  self.endTime = nil
  self.selfInfo = nil
  self.timer_action = nil
end

local function ReInit(self)
  self.actId = self:GetUserData()
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(self.actId)
  if self.actData == nil then
    return
  end
  self.maxNum = #self.actData.stateInfo
  self.minValue = self.actData.battlePass.level + 1
  self._lv_slider:SetValue(0)
  self._progress_txt:SetLocalText(320438, 1, self.minValue)
  self._tips_txt:SetLocalText(320436, self.minValue)
  self.rewardModels = {}
  self.rewardModelCount = 0
  self:RefreshFreeItem(self.minValue)
end

local function RefreshBattlePass(self)
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(self.actId)
  local value = self._lv_slider:GetValue()
  local cnt = math.floor(value * (self.maxNum - self.minValue) + self.minValue + 0.5)
  self:RefreshFreeItem(cnt)
end

local function OnAddClick(self)
  local value = self._lv_slider:GetValue()
  local cnt = math.floor(value * (self.maxNum - self.minValue) + self.minValue + 0.5)
  if cnt == self.maxNum then
    return
  end
  local percent = (cnt + 1 - self.minValue) / math.max(self.maxNum - self.minValue, 1)
  self._lv_slider:SetValue(percent)
end

local function OnMinusClick(self)
  local value = self._lv_slider:GetValue()
  local cnt = math.floor(value * (self.maxNum - self.minValue) + self.minValue + 0.5)
  local percent = (cnt - 1 - self.minValue) / math.max(self.maxNum - self.minValue, 1)
  self._lv_slider:SetValue(percent)
end

local function ValueChanged(self, value)
  local cnt = math.floor(value * (self.maxNum - self.minValue) + self.minValue + 0.5)
  self._progress_txt:SetLocalText(320438, cnt - self.actData.battlePass.level, cnt)
  self._tips_txt:SetLocalText(320436, cnt)
  self:RefreshFreeItem(cnt)
end

local function RefreshFreeItem(self, lv)
  local freeList = self.actData:CheckLvGetReward(self.minValue, lv)
  self:SetAllNeedCellDestroy()
  self:RefreshValuableItem(freeList)
  if lv <= self.actData.battlePass.level then
    self._buy_btn:SetActive(false)
  else
    self._buy_btn:SetActive(true)
    self.curPrice = self.actData.costValue * (lv - self.actData.battlePass.level)
    self._buy_txt:SetText(string.GetFormattedSeperatorNum(self.actData.costValue * (lv - self.actData.battlePass.level)))
  end
end

local function RefreshValuableItem(self, list)
  for i = 1, table.length(list) do
    self.rewardModels[i] = self:GameObjectInstantiateAsync(UIAssets.UIBattlePassRewardCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform.localScale = Vector3.New(1, 1, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.content:AddComponent(UIBattlePassItemCell, nameStr)
      cell:SetBuyData(list[i])
    end)
  end
end

local function SetAllNeedCellDestroy(self)
  self.content:RemoveComponents(UIBattlePassItemCell)
  if self.rewardModels ~= nil then
    for k, v in pairs(self.rewardModels) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardModels = {}
end

local function OnBuyClick(self)
  if LuaEntry.Player.gold < tonumber(self.curPrice) then
    GoToUtil.GotoPayTips(tonumber(self.curPrice))
    return
  end
  local value = self._lv_slider:GetValue()
  local cnt = math.floor(value * (self.maxNum - self.minValue) + self.minValue + 0.5)
  SFSNetwork.SendMessage(MsgDefines.BuyBattlePassLevel, toInt(self.actId), cnt - self.actData.battlePass.level)
end

UIBattlePassBuyView.OnCreate = OnCreate
UIBattlePassBuyView.OnDestroy = OnDestroy
UIBattlePassBuyView.ComponentDefine = ComponentDefine
UIBattlePassBuyView.DataDefine = DataDefine
UIBattlePassBuyView.DataDestroy = DataDestroy
UIBattlePassBuyView.ReInit = ReInit
UIBattlePassBuyView.ValueChanged = ValueChanged
UIBattlePassBuyView.OnAddClick = OnAddClick
UIBattlePassBuyView.OnMinusClick = OnMinusClick
UIBattlePassBuyView.OnBuyClick = OnBuyClick
UIBattlePassBuyView.OnEnable = OnEnable
UIBattlePassBuyView.OnDisable = OnDisable
UIBattlePassBuyView.ComponentDestroy = ComponentDestroy
UIBattlePassBuyView.RefreshFreeItem = RefreshFreeItem
UIBattlePassBuyView.RefreshValuableItem = RefreshValuableItem
UIBattlePassBuyView.SetAllNeedCellDestroy = SetAllNeedCellDestroy
UIBattlePassBuyView.OnAddListener = OnAddListener
UIBattlePassBuyView.OnRemoveListener = OnRemoveListener
UIBattlePassBuyView.RefreshBattlePass = RefreshBattlePass
return UIBattlePassBuyView
