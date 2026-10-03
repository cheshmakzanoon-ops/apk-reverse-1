local PowerUpActivityRewardCell = BaseClass("PowerUpActivityRewardCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local RewardUtil = require("Util.RewardUtil")
local title_path = "Txt_Name"
local content_path = "Rect_Reward"
local bg_path = ""

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
  self.contentN = self:AddComponent(UIBaseContainer, content_path)
  self.bgN = self:AddComponent(UIImage, bg_path)
  self.lock = self:AddComponent(UIImage, "lock")
  self.nodeDone = self:AddComponent(UIBaseContainer, "nodeDone")
end

local function ComponentDestroy(self)
  self:SetAllCellDestroy()
  self.titleN = nil
  self.contentN = nil
  self.bgN = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.taskInfo = nil
  self.showList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, taskInfo, activityId, index, rawTaskList)
  local taskId = tonumber(taskInfo.taskId)
  self.taskInfo = taskInfo
  self.activityId = activityId
  self.taskId = taskId
  self.taskTemplate = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(taskId)
  if self.taskInfo.rewardList == nil then
    self.taskInfo.rewardList = DataCenter.RewardManager:ReturnRewardParamForView(self.taskInfo.reward)
  end
  local lastPower = LuaEntry.Player.power
  if lastPower > self.taskTemplate.para2 then
    lastPower = self.taskTemplate.para2
  end
  self.titleN:SetLocalText("newbies_fctarget_main_desc5", string.GetFormattedSeperatorNum(lastPower), string.GetFormattedSeperatorNum(self.taskTemplate.para2))
  local state = self.taskInfo.state
  self.nodeDone.gameObject:SetActive(state == 2)
  self.lock.gameObject:SetActive(state == 0)
  if state == 2 then
    self.bgN:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_yilingqu_kuang.png")
  elseif state == 1 or index == 1 then
    self.lock.gameObject:SetActive(false)
    self.bgN:LoadSprite("Assets/Main/Sprites/UI/UILWQuest/zyf_renwu_tiao_2.png")
  else
    self.bgN:LoadSprite("Assets/Main/Sprites/UI/UILWQuest/cfm_renwu_tiao_2.png")
  end
  self:RefreshReward(self.taskInfo.rewardList)
end

local function RefreshReward(self, list)
  self:SetAllCellDestroy()
  if not table.IsNullOrEmpty(list) then
    self.showList = DataCenter.RewardManager:RewardItemList(list)
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

PowerUpActivityRewardCell.OnCreate = OnCreate
PowerUpActivityRewardCell.OnDestroy = OnDestroy
PowerUpActivityRewardCell.ComponentDefine = ComponentDefine
PowerUpActivityRewardCell.ComponentDestroy = ComponentDestroy
PowerUpActivityRewardCell.DataDefine = DataDefine
PowerUpActivityRewardCell.DataDestroy = DataDestroy
PowerUpActivityRewardCell.OnAddListener = OnAddListener
PowerUpActivityRewardCell.OnRemoveListener = OnRemoveListener
PowerUpActivityRewardCell.SetItem = SetItem
PowerUpActivityRewardCell.RefreshReward = RefreshReward
PowerUpActivityRewardCell.SetAllCellDestroy = SetAllCellDestroy
return PowerUpActivityRewardCell
