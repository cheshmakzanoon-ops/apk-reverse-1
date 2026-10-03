local UIEarthOrderBoxSelect = BaseClass("UIEarthOrderBoxSelect", UIBaseContainer)
local base = UIBaseContainer
local UIEarthOrderRewardCell = require("UI.UIEarthOrder.UIEarthOrder.Component.UIEarthOrderRewardCell")
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local panel_bg_path = "tips/Common_supple"
local info_title_path = "tips/Common_supple/title_bg/InfoTitle"
local reward_text_path = "tips/Common_supple/RewardText"
local submit_btn_path = "tips/Common_supple/btnList/Common_btn_green"
local submit_btn_name_path = "tips/Common_supple/btnList/Common_btn_green/Common_btn_green_name"
local submit_btn_name_1_path = "tips/Common_supple/btnList/Common_btn_green/btnTxt_green_mid_new_with_pic"
local submit_btn_name_1_name_path = "tips/Common_supple/btnList/Common_btn_green/btnTxt_green_mid_new_with_pic/Txt1"
local submit_btn_name_1_diamond_path = "tips/Common_supple/btnList/Common_btn_green/btnTxt_green_mid_new_with_pic/txt2"
local reward_container_path = "tips/Common_supple/Common_bg_need_resource/"
local this_path = ""
local get_item_method_1_path = "tips/Common_supple/goto_1"
local get_item_method_1_title_path = "tips/Common_supple/goto_1/goto_title_1"
local get_item_method_1_name_path = "tips/Common_supple/goto_1/goto_name_1"
local get_item_method_1_goto_path = "tips/Common_supple/goto_1/goto_btn_1"
local get_item_method_2_path = "tips/Common_supple/goto_2"
local get_item_method_2_name_path = "tips/Common_supple/goto_2/goto_name_2"
local get_item_method_2_goto_path = "tips/Common_supple/goto_2/goto_btn_2"
local BG_W = 440
local HEIGHT_2 = 420
local HEIGHT_1 = 355
local HEIGHT_0 = 285
local AnimName = {
  Enter = "CommonPopup_movein",
  Exit = "CommonPopup_moveout"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
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
  if not self.define then
    self.define = true
    self.panel_bg = self:AddComponent(UIImage, panel_bg_path)
    self.info_title = self:AddComponent(UIText, info_title_path)
    self.reward_text = self:AddComponent(UIText, reward_text_path)
    self.submit_btn = self:AddComponent(UIButton, submit_btn_path)
    self.submit_btn_name = self:AddComponent(UIText, submit_btn_name_path)
    self.reward_container = self:AddComponent(UIBaseContainer, reward_container_path)
    self.anim = self:AddComponent(UIAnimator, this_path)
    self.submit_btn:SetOnClick(function()
      self:OnSubmitClick()
    end)
    self.get_item_method_1 = self:AddComponent(UIBaseContainer, get_item_method_1_path)
    self.get_item_method_1_title = self:AddComponent(UIText, get_item_method_1_title_path)
    self.get_item_method_1_title:SetLocalText(100214)
    self.get_item_method_1_name = self:AddComponent(UIText, get_item_method_1_name_path)
    self.get_item_method_1_goto = self:AddComponent(UIButton, get_item_method_1_goto_path)
    self.get_item_method_2 = self:AddComponent(UIBaseContainer, get_item_method_2_path)
    self.get_item_method_2_name = self:AddComponent(UIText, get_item_method_2_name_path)
    self.get_item_method_2_name:SetLocalText(130129)
    self.get_item_method_2_goto = self:AddComponent(UIButton, get_item_method_2_goto_path)
    self.submit_btn_name_1 = self:AddComponent(UIBaseContainer, submit_btn_name_1_path)
    self.submit_btn_name_1_name = self:AddComponent(UIText, submit_btn_name_1_name_path)
    self.submit_btn_name_1_diamond = self:AddComponent(UIText, submit_btn_name_1_diamond_path)
    self.get_item_method_1_goto:SetOnClick(function()
      self.view.ctrl:Goto(self.param.resourceItemId)
    end)
    self.get_item_method_2_goto:SetOnClick(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopMain, nil, 3)
    end)
  end
end

local function ComponentDestroy(self)
  self:RemoveAllRewardCell()
  self.info_title = nil
  self.reward_text = nil
  self.submit_btn = nil
  self.submit_btn_name = nil
  self.reward_container = nil
  self.anim = nil
end

local function DataDefine(self)
  self.param = {}
  self.itemInfoCells = {}
  self.freeItemInfoCells = {}
  self.define = nil
end

local function DataDestroy(self)
  self.param = nil
  self.itemInfoCells = nil
  self.freeItemInfoCells = nil
  self.define = nil
end

local function ReInit(self, param)
  self.transform.position = param.pos
  self:SetActive(true)
  self:ComponentDefine()
  self.anim:Play(AnimName.Enter, 0, 0)
  self.param = param
  self:RemoveAllRewardCell()
  if param ~= nil then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(param.resourceItemId)
    if template ~= nil then
      self.info_title:SetLocalText(template.name)
    end
    self:RefreshCount()
    self.reward_text:SetLocalText(GameDialogDefine.REWARD)
    self.submit_btn_name:SetLocalText(GameDialogDefine.SUBMIT_ORDER)
    self.submit_btn_name_1_name:SetLocalText(GameDialogDefine.SUBMIT_ORDER)
    table.walk(self.param.rewardList, function(_, v)
      self:AddOneReward(v.count, v.rewardType, v.itemId)
    end)
    self:RefreshGetComponent()
    local _, diamondNum = DataCenter.ResourceItemDataManager:GetResourceItemBuyPriceTotal(self.param.resourceItemId, self.param.needResourceItemCount)
    self.submit_btn_name:SetActive(diamondNum == 0)
    self.submit_btn_name_1:SetActive(0 < diamondNum)
    self.submit_btn_name_1_diamond:SetText(string.GetFormattedSeperatorNum(diamondNum))
    local resourceItemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.param.resourceItemId)
    local nameStr = ""
    if resourceItemTemplate ~= nil then
      if not string.IsNullOrEmpty(resourceItemTemplate.building) then
        local buildType = toInt(resourceItemTemplate.building)
        if buildType ~= nil then
          local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildType)
          nameStr = Localization:GetString(buildTemplate.name)
        end
      elseif not string.IsNullOrEmpty(resourceItemTemplate.monster) then
        nameStr = Localization:GetString("104193")
      end
    end
    self.get_item_method_1_name:SetText(nameStr)
  end
end

local function AddOneReward(self, num, rewardType, itemId)
  if #self.freeItemInfoCells > 0 then
    local temp = table.remove(self.freeItemInfoCells)
    if temp ~= nil then
      temp:SetActive(true)
      temp.transform:SetParent(self.reward_container.transform)
      local param = {}
      param.num = num
      param.rewardType = rewardType
      param.icon = DataCenter.RewardManager:GetPicByType(rewardType, itemId)
      self.itemInfoCells[rewardType] = temp
      self.itemInfoCells[rewardType]:ReInit(param)
      temp.transform:SetAsLastSibling()
    end
  else
    self:GameObjectInstantiateAsync(UIAssets.EarthOrderRewardCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.reward_container.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(rewardType)
      go.name = nameStr
      self.itemInfoCells[rewardType] = self.reward_container:AddComponent(UIEarthOrderRewardCell, nameStr)
      local param = {}
      param.num = num
      param.rewardType = rewardType
      param.icon = DataCenter.RewardManager:GetPicByType(rewardType, itemId)
      self.itemInfoCells[rewardType]:ReInit(param)
      go.transform:SetAsLastSibling()
    end)
  end
end

local function RefreshCount(self)
end

local function PlayExitAnim(self)
  local ret, time = self.anim:PlayAnimationReturnTime(AnimName.Exit)
  if ret then
    self.closeTimer = TimerManager:GetInstance():GetTimer(time, function()
      if self.closeTimer ~= nil then
        self.closeTimer:Stop()
        self.closeTimer = nil
      end
      if self ~= nil then
        self:SetActive(false)
      end
    end, self, true, false, false)
    self.closeTimer:Start()
  else
    self:SetActive(false)
  end
end

local function DoSubmit(self)
  self.view:ShowMoney()
  local endPos = self.view:GetMoneyPosition()
  table.walk(self.itemInfoCells, function(_, v)
    v:ShowGetRewardEffect(endPos)
  end)
  local itemUUid = 0
  local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self.param.resourceItemId)
  if item ~= nil then
    itemUUid = item.uuid
  end
  DataCenter.EarthOrderDataManager:SendEarthOrderFillOne(self.param.orderUuid, itemUUid, self.param.index - 1)
  if self.param.callBack ~= nil then
    self.param.callBack()
  end
  self:PlayExitAnim()
end

local function OnSubmitClick(self)
  if DataCenter.EarthOrderDataManager:IsPreviewStatus() then
    return
  end
  local result, diamondNum = DataCenter.ResourceItemDataManager:GetResourceItemBuyPriceTotal(self.param.resourceItemId, self.param.needResourceItemCount)
  if result == true then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Earth_Order_Box, false)
    self:DoSubmit()
  else
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_FailClick, false)
    UIUtil.ShowTipsId(GameDialogDefine.RESOURCE_ITEM_NOT_ENOUGH)
    self:PlayExitAnim()
  end
end

local function RemoveAllRewardCell(self)
  table.walk(self.itemInfoCells, function(k, v)
    v:SetActive(false)
    table.insert(self.freeItemInfoCells, v)
  end)
  self.itemInfoCells = {}
end

local function RefreshGetComponent(self)
  local result, diamondNum = DataCenter.ResourceItemDataManager:GetResourceItemBuyPriceTotal(self.param.resourceItemId, self.param.needResourceItemCount)
  local h = HEIGHT_0
  if diamondNum == 0 then
    self.get_item_method_1:SetActive(false)
    self.get_item_method_2:SetActive(false)
    self.panel_bg.rectTransform:Set_sizeDelta(BG_W, HEIGHT_0)
  else
    self.get_item_method_1:SetActive(true)
    local own = 0
    local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self.param.resourceItemId)
    if item ~= nil then
      own = item.number
    end
    local needLv = LuaEntry.DataConfig:TryGetNum("tradingbank_para", "k17") or 0
    local showShop = own < self.param.needResourceItemCount and needLv <= DataCenter.BuildManager.MainLv
    self.get_item_method_2:SetActive(showShop)
    if showShop then
      self.panel_bg.rectTransform:Set_sizeDelta(BG_W, HEIGHT_2)
      h = HEIGHT_2
    else
      self.panel_bg.rectTransform:Set_sizeDelta(BG_W, HEIGHT_1)
      h = HEIGHT_1
    end
  end
  if self.param.index > 6 then
    self.panel_bg.transform:Set_localPosition(BG_W / 2 + 16, h / 2 - 50, 0)
  else
    self.panel_bg.transform:Set_localPosition(BG_W / 2 + 16, 0, 0)
  end
end

UIEarthOrderBoxSelect.OnCreate = OnCreate
UIEarthOrderBoxSelect.OnDestroy = OnDestroy
UIEarthOrderBoxSelect.Param = Param
UIEarthOrderBoxSelect.OnEnable = OnEnable
UIEarthOrderBoxSelect.OnDisable = OnDisable
UIEarthOrderBoxSelect.ComponentDefine = ComponentDefine
UIEarthOrderBoxSelect.ComponentDestroy = ComponentDestroy
UIEarthOrderBoxSelect.DataDefine = DataDefine
UIEarthOrderBoxSelect.DataDestroy = DataDestroy
UIEarthOrderBoxSelect.ReInit = ReInit
UIEarthOrderBoxSelect.RefreshCount = RefreshCount
UIEarthOrderBoxSelect.PlayExitAnim = PlayExitAnim
UIEarthOrderBoxSelect.OnSubmitClick = OnSubmitClick
UIEarthOrderBoxSelect.DoSubmit = DoSubmit
UIEarthOrderBoxSelect.AddOneReward = AddOneReward
UIEarthOrderBoxSelect.RemoveAllRewardCell = RemoveAllRewardCell
UIEarthOrderBoxSelect.RefreshGetComponent = RefreshGetComponent
return UIEarthOrderBoxSelect
