local UIActSlotMachineRewardGetView = BaseClass("UIActSlotMachineRewardGetView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActSlotMachineRewardGetCell = require("UI.UIActSlotMachine.UIActSlotMachineRewardGet.Component.UIActSlotMachineRewardGetCell")
local UIActSlotMachineTipRollRateItem = require("UI.UIActSlotMachine.UIActSlotMachineTip.Component.UIActSlotMachineTipRollRateItem")
local panel_path = "Panel"
local content_path = "infoContent/layout/CellList/Viewport/Content"
local box_item_path = "infoContent/boxItem"
local title_txt_path = "bgContent1/titleBg/titleTxt"
local tip_txt_path = "bgContent1/tipTxt"
local eff_ui_actslotmachinemain_jiangli_path = "Eff_ui_actslotmachinemain_jiangli"
local draw_rate_item_path = "infoContent/drawRateItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param = self:GetUserData()
  self.param = param
  DataCenter.LWSoundManager:PlaySound(202625, false)
  self:ReInit()
end

local function OnDestroy(self)
  self:ClearAllItem()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    local activityId = self.param.activityId
    local activityDetailData = DataCenter.ActSlotMachineDataManager:GetActData(activityId)
    if self.param.eventBox then
      local lastData = activityDetailData.eventBox[#activityDetailData.eventBox]
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSlotMachineSelectCard, {anim = true}, activityId, lastData.uuid, false)
    end
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.box_item = self:AddComponent(UIBaseContainer, box_item_path)
  self.boxItemList = {}
  self.box_item:SetActive(false)
  self.box_item.gameObject:GameObjectCreatePool()
  self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_path)
  self.tip_txt = self:AddComponent(UITextMeshProUGUIEx, tip_txt_path)
  self.tip_txt:SetText("")
  self.mulitEff = self.transform:Find(eff_ui_actslotmachinemain_jiangli_path).gameObject
  self.mulitEff:SetActive(false)
  self.draw_rate_item = self:AddComponent(UIActSlotMachineTipRollRateItem, draw_rate_item_path)
end

local function ComponentDestroy(self)
end

local function ClearAllItem(self)
  self.content:RemoveComponents(UIActSlotMachineRewardGetCell)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.box_item.gameObject:GameObjectRecycleAll()
  self.boxItemList = {}
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self:ClearAllItem()
  local reward = self.param.reward
  local isMultiple = self.param.multiple
  local showReward = DataCenter.RewardManager:ReturnRewardParamForView(reward)
  for i = 1, #showReward do
    local index = i
    local item = self.box_item.gameObject:GameObjectSpawn(self.content.transform)
    item.name = index
    local obj = self.content:AddComponent(UIActSlotMachineRewardGetCell, item.name)
    obj:SetActive(true)
    self.boxItemList[index] = obj
    obj:ReInit(showReward[i], isMultiple)
  end
  local activityId = self.param.activityId
  if not activityId then
    self.tip_txt:SetText("")
    return
  end
  local infoTempId = LocalController:instance():getLine(TableName.Activity, toInt(activityId)).tableInfoType
  local line = LocalController:instance():getLine(TableName.ActivitySlotsInfo, toInt(infoTempId))
  if not line then
    self.tip_txt:SetText("")
    return
  end
  local groupId = line.groupid
  local lineId = self.param.groupId
  local groupTemplate = DataCenter.ActSlotMachineDataManager:GetGroupTemplate(groupId, lineId)
  if groupTemplate and not string.IsNullOrEmpty(groupTemplate.get_reward_text) then
    self.tip_txt:SetLocalText(groupTemplate.get_reward_text)
  else
    self.tip_txt:SetText("")
  end
  self.mulitEff:SetActive(isMultiple)
  local rateType = groupTemplate.type
  local rollRateData = DataCenter.ActSlotMachineDataManager:GetGroupResultDataDict(groupId)
  local showData = rollRateData[rateType]
  self.draw_rate_item:SetData(showData, groupId)
end

UIActSlotMachineRewardGetView.OnCreate = OnCreate
UIActSlotMachineRewardGetView.OnDestroy = OnDestroy
UIActSlotMachineRewardGetView.ComponentDefine = ComponentDefine
UIActSlotMachineRewardGetView.ComponentDestroy = ComponentDestroy
UIActSlotMachineRewardGetView.DataDefine = DataDefine
UIActSlotMachineRewardGetView.DataDestroy = DataDestroy
UIActSlotMachineRewardGetView.OnAddListener = OnAddListener
UIActSlotMachineRewardGetView.OnRemoveListener = OnRemoveListener
UIActSlotMachineRewardGetView.ReInit = ReInit
UIActSlotMachineRewardGetView.ClearAllItem = ClearAllItem
return UIActSlotMachineRewardGetView
