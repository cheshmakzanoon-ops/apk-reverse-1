local AttackCityTaskContentItem = BaseClass("AttackCityTaskContentItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local receive_bg_path = "ReceiveBg"
local icon_path = "Icon"
local desc_txt_path = "DescIcon/Desc"
local go_btn_path = "GoBtn"
local go_btn_txt_path = "GoBtn/GoBtnText"
local receive_btn_path = "ReceiveBtn"
local receive_btn_txt_path = "ReceiveBtn/ReceiveBtnText"
local reward_content_path = "RewardScroll/Content"
local completedIconPath = "CompletedIcon"
local GO_BUTTON_TXT = "110003"
local RECEIVE_BUTTON_TXT = "170004"
local REWARD_TXT = "130065"

function AttackCityTaskContentItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AttackCityTaskContentItem:OnDestroy()
  self:ClearContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AttackCityTaskContentItem:ComponentDefine()
  self.receiveBg = self:AddComponent(UIBaseContainer, receive_bg_path)
  self.descText = self:AddComponent(UIText, desc_txt_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.completedIcon = self:AddComponent(UIImage, completedIconPath)
end

function AttackCityTaskContentItem:ComponentDestroy()
  self.receiveBg = nil
  self.descText = nil
  self.rewardContent = nil
  self.completedIcon = nil
end

function AttackCityTaskContentItem:DataDefine()
  self.infos = {}
  self.itemReqs = {}
  self.itemList = {}
  self.showRewardId = nil
end

function AttackCityTaskContentItem:DataDestroy()
  self.infos = nil
  self.itemReqs = nil
  self.itemList = nil
  self.onRewardAnimBack = nil
  self.showRewardId = nil
end

function AttackCityTaskContentItem:OnEnable()
  base.OnEnable(self)
end

function AttackCityTaskContentItem:OnDisable()
  base.OnDisable(self)
end

function AttackCityTaskContentItem:OnAddListener()
  base.OnAddListener(self)
end

function AttackCityTaskContentItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AttackCityTaskContentItem:ClearContent()
  if table.count(self.itemList) > 0 then
    self.rewardContent:RemoveComponents(UICommonResItem)
    self.itemList = {}
  end
  if table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      req:Destroy()
    end
    self.itemReqs = {}
  end
end

function AttackCityTaskContentItem:RefreshReward(rewardList)
  self:ClearContent()
  if not table.IsNullOrEmpty(rewardList) then
    for i, data in pairs(rewardList) do
      local req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "reward_item" .. i
        item:SetActive(true)
        item.transform:SetParent(self.rewardContent.transform)
        item.transform:Set_localScale(0.75, 0.8, 1)
        item.transform:Set_sizeDelta(118, 118)
        item.transform:Set_pivot(0.5, 0.5)
        local cell = self.rewardContent:AddComponent(UICommonResItem, item.name)
        local param = {}
        param.rewardType = data.type
        if type(data.value) == "table" then
          param.itemId = data.value.id
          param.count = data.value.num
        else
          param.count = data.value
        end
        cell:ReInit(param)
        table.insert(self.itemList, cell)
      end)
      table.insert(self.itemReqs, req)
    end
  end
end

function AttackCityTaskContentItem:SetData(taskInfo, onRewardAnimBack)
  self.info = taskInfo
  if self.info == nil then
    return
  end
  self.taskTemplate = LocalController:instance():getLine(TableName.CITY_BATTLE_QUEST, self.info.id)
  if self.taskTemplate == nil then
    return
  end
  local taskState = self.info.state
  local completeNum = self.info.num
  local allNum = self.taskTemplate.city_num
  if self.taskTemplate then
    local descStr = ""
    descStr = Localization:GetString(self.taskTemplate.desc)
    descStr = string.format("%s (%d/%d)", descStr, completeNum, allNum)
    self.descText:SetText(descStr)
  end
  self.completedIcon:SetActive(self.info.state == 1)
  self:RefreshReward(self.info.reward)
end

return AttackCityTaskContentItem
