local LeadingQuestItemV2 = BaseClass("LeadingQuestItemV2", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local RewardUtil = require("Util.RewardUtil")
local title_path = "Txt_Name"
local content_path = "Rect_Reward"
local claimBtn_path = "Btn_Reward"
local claimBtnTxt_path = "Btn_Reward/Txt_Reward"
local bg_path = ""
local btn_go_path = "Btn_Go"
local txt_go_path = "Btn_Go/Txt_Go"
local node_done_path = "nodeDone"
local txt_title2_path = "nodeDone/txtTitle2"

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

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(372133)
  self.contentN = self:AddComponent(UIBaseContainer, content_path)
  self.claimBtnN = self:AddComponent(UIButton, claimBtn_path)
  self.claimBtnN:SetOnClick(function()
    self:OnClickClaimReward()
  end)
  self.claimBtnImgN = self:AddComponent(UIImage, claimBtn_path)
  self.claimBtnTxtN = self:AddComponent(UIText, claimBtnTxt_path)
  self.claimBtnTxtN:SetLocalText(170004)
  self.bgN = self:AddComponent(UIImage, bg_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.txt_go = self:AddComponent(UITextMeshProUGUIEx, txt_go_path)
  self.node_done = self:AddComponent(UIImage, node_done_path)
  self.txt_title2 = self:AddComponent(UITextMeshProUGUIEx, txt_title2_path)
  self.txt_go:SetText(Localization:GetString("455017"))
  self.btn_go:SetOnClick(function()
    self:OnGotoBtnClick()
  end)
end

local function ComponentDestroy(self)
  self:SetAllCellDestroy()
  self.titleN = nil
  self.contentN = nil
  self.claimBtnN = nil
  self.claimBtnTxtN = nil
  self.bgN = nil
  self.btn_go = nil
  self.txt_go = nil
  self.node_done = nil
  self.txt_title2 = nil
end

local function DataDefine(self)
  self.taskInfo = nil
  self.taskTemplate = nil
  self.showList = nil
  self.listenerInited = nil
end

local function DataDestroy(self)
  self.taskInfo = nil
  self.taskTemplate = nil
  self.showList = nil
  self.listenerInited = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, taskInfo, bgPath, activityId)
  local taskId = tonumber(taskInfo.taskId)
  self.taskInfo = taskInfo
  self.activityId = activityId
  self.taskId = taskId
  self.taskTemplate = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(taskId)
  if self.taskInfo.rewardList == nil then
    self.taskInfo.rewardList = DataCenter.RewardManager:ReturnRewardParamForView(self.taskInfo.reward)
  end
  local desc = self.taskTemplate:GetDesc(true)
  self.titleN:SetText(desc)
  self.txt_title2:SetText(desc)
  local state = self.taskInfo.state
  if state == 2 then
    self.node_done:SetActive(true)
    self.claimBtnN:SetActive(false)
    self.btn_go:SetActive(false)
  elseif state == 1 then
    self.node_done:SetActive(false)
    self.claimBtnN:SetActive(true)
    self.btn_go:SetActive(false)
  else
    self.node_done:SetActive(false)
    self.claimBtnN:SetActive(false)
    self.btn_go:SetActive(true)
  end
  if not string.IsNullOrEmpty(bgPath) then
    self.bgN:LoadSprite(bgPath)
  end
  self:RefreshReward(self.taskInfo.rewardList)
end

local function RefreshReward(self, list)
  self:SetAllCellDestroy()
  if not table.IsNullOrEmpty(list) then
    self.showList = self.view.ctrl:RewardItemList(list)
  else
    self.showList = {}
  end
  self.model = {}
  if self.showList ~= nil then
    for i = 1, table.length(self.showList) do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.contentN.transform)
        go.transform:Set_localScale(0.78, 0.82, 1)
        go.transform:Set_sizeDelta(91, 97)
        go.transform.pivot = Vector2.New(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.contentN:AddComponent(UICommonResItem, go.name)
        cell:ReInit(self.showList[i])
        self.showList[i].iconImg = go.transform:Find("clickBtn/ItemIcon")
      end)
    end
  end
end

local function SetAllCellDestroy(self)
  self.contentN:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function OnClickClaimReward(self)
  if self.taskInfo.state == 1 then
    SFSNetwork.SendMessage(MsgDefines.PowerUpTaskReward, tonumber(self.activityId), tostring(self.taskId))
  end
end

function LeadingQuestItemV2:OnGotoBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILeadingQuestWay, {anim = false})
end

LeadingQuestItemV2.OnCreate = OnCreate
LeadingQuestItemV2.OnDestroy = OnDestroy
LeadingQuestItemV2.ComponentDefine = ComponentDefine
LeadingQuestItemV2.ComponentDestroy = ComponentDestroy
LeadingQuestItemV2.DataDefine = DataDefine
LeadingQuestItemV2.DataDestroy = DataDestroy
LeadingQuestItemV2.OnAddListener = OnAddListener
LeadingQuestItemV2.OnRemoveListener = OnRemoveListener
LeadingQuestItemV2.SetItem = SetItem
LeadingQuestItemV2.RefreshReward = RefreshReward
LeadingQuestItemV2.SetAllCellDestroy = SetAllCellDestroy
LeadingQuestItemV2.OnClickClaimReward = OnClickClaimReward
return LeadingQuestItemV2
