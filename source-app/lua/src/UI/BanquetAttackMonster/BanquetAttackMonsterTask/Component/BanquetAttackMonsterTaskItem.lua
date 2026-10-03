local BanquetAttackMonsterTaskItem = BaseClass("BanquetAttackMonsterTaskItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local desc_txt_path = "Ani/Desc"
local num_txt_path = "Ani/Num"
local go_btn_path = "Ani/GoBtn"
local receive_btn_path = "Ani/ReceiveBtn"
local reward_content_path = "Ani/RewardScroll/Content"
local completedIconPath = "Ani/CompletedContent"
local bg_path = "Ani/bg"
local index_bg_path = "Ani/indexBg"
local index_txt_path = "Ani/indexBg/indexTxt"

function BanquetAttackMonsterTaskItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BanquetAttackMonsterTaskItem:OnDestroy()
  self:ClearContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BanquetAttackMonsterTaskItem:ComponentDefine()
  self.descText = self:AddComponent(UIText, desc_txt_path)
  self.num_txt = self:AddComponent(UIText, num_txt_path)
  self.goBtn = self:AddComponent(UIButton, go_btn_path)
  self.goBtn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.receiveBtn = self:AddComponent(UIButton, receive_btn_path)
  self.receiveBtn:SetOnClick(function()
    self:OnReceiveClick()
  end)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.completedIcon = self:AddComponent(UIImage, completedIconPath)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.index_bg = self:AddComponent(UIImage, index_bg_path)
  self.index_txt = self:AddComponent(UITextMeshProUGUIEx, index_txt_path)
end

function BanquetAttackMonsterTaskItem:ComponentDestroy()
  self.descText = nil
  self.goBtn = nil
  self.receiveBtn = nil
  self.rewardContent = nil
  self.completedIcon = nil
end

function BanquetAttackMonsterTaskItem:DataDefine()
  self.infos = {}
  self.itemReqs = {}
  self.itemList = {}
  self.showRewardId = nil
  self.index = nil
  self.curIndex = nil
end

function BanquetAttackMonsterTaskItem:DataDestroy()
  self.infos = nil
  self.itemReqs = nil
  self.itemList = nil
  self.onRewardAnimBack = nil
  self.showRewardId = nil
  self.index = nil
  self.curIndex = nil
end

function BanquetAttackMonsterTaskItem:ClearContent()
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

function BanquetAttackMonsterTaskItem:RefreshReward(rewardList)
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
        item.transform:Set_localScale(0.65, 0.65, 1)
        item.transform:Set_sizeDelta(118, 118)
        item.transform:Set_pivot(0.5, 0.5)
        local cell = self.rewardContent:AddComponent(UICommonResItem, item.name)
        cell:ReInit(data)
        table.insert(self.itemList, cell)
      end)
      table.insert(self.itemReqs, req)
    end
  end
end

function BanquetAttackMonsterTaskItem:SetData(activityId, taskData, index, curIndex)
  self.activityId = activityId
  self.taskData = taskData
  self.taskInfo = self.taskData.temp
  self.index = index
  self.curIndex = curIndex
  local showList = DataCenter.RewardManager:ReturnRewardParamForView(self.taskData.data.reward)
  self:RefreshReward(showList)
  self.index_txt:SetText(self.index)
  if curIndex < self.index then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/ActSlotMachine/Mjc_huodong_laba_xianshimubiao_list02.png")
    self.index_bg:LoadSprite("Assets/Main/Sprites/UI/ActSlotMachine/Mjc_huodong_laba_xianshimubiao_icon02.png")
    self.goBtn:SetActive(false)
    self.receiveBtn:SetActive(false)
    self.completedIcon:SetActive(false)
    self.descText:SetLocalText("activity_slots_tips030")
    self.num_txt:SetText("")
    return
  else
    self.bg:LoadSprite("Assets/Main/Sprites/UI/ActSlotMachine/Mjc_huodong_laba_xianshimubiao_list01.png")
    self.index_bg:LoadSprite("Assets/Main/Sprites/UI/ActSlotMachine/Mjc_huodong_laba_xianshimubiao_icon01.png")
  end
  local taskDesc = self.taskInfo:GetDesc(true)
  local process = ""
  local curNum = self.taskData.data.num and self.taskData.data.num or 0
  local targetNum = self.taskInfo.para2
  if 0 <= curNum - targetNum then
    curNum = targetNum
  end
  curNum = string.GetFormattedSeperatorNum(curNum)
  targetNum = string.GetFormattedSeperatorNum(targetNum)
  process = curNum .. "/" .. targetNum
  self.descText:SetText(taskDesc)
  self.num_txt:SetText(process)
  local state = self.taskData.data.state
  if state == TaskState.Received then
    self.completedIcon:SetActive(true)
    self.receiveBtn:SetActive(false)
    self.goBtn:SetActive(false)
  elseif state == TaskState.CanReceive then
    self.completedIcon:SetActive(false)
    self.receiveBtn:SetActive(true)
    self.goBtn:SetActive(false)
  else
    self.completedIcon:SetActive(false)
    self.receiveBtn:SetActive(false)
    self.goBtn:SetActive(true)
  end
end

function BanquetAttackMonsterTaskItem:OnGoClick()
  if self.taskInfo then
    GoToUtil.GoToByQuestId(self.taskInfo)
  end
end

function BanquetAttackMonsterTaskItem:OnReceiveClick()
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2TaskReward, tonumber(self.activityId), tostring(self.taskData.data.taskId))
end

return BanquetAttackMonsterTaskItem
