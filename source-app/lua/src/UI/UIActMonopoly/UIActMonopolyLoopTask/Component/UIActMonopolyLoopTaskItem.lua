local UIActMonopolyLoopTaskItem = BaseClass("UIActMonopolyLoopTaskItem", UIBaseContainer)
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
local progress_content_path = "Ani/progressContent"
local task_progressbg_path = "Ani/progressContent/taskProgressbg"
local task_progress_img_path = "Ani/progressContent/taskProgressbg/taskProgressImg"
local task_progress_num_path = "Ani/progressContent/taskProgressbg/taskProgressNum"
local icon_path = "Ani/progressContent/icon"

function UIActMonopolyLoopTaskItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActMonopolyLoopTaskItem:OnDestroy()
  self:ClearContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActMonopolyLoopTaskItem:ComponentDefine()
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
  self.progress_content = self:AddComponent(UIBaseContainer, progress_content_path)
  self.task_progressbg = self:AddComponent(UIImage, task_progressbg_path)
  self.task_progress_img = self:AddComponent(UIImage, task_progress_img_path)
  self.task_progress_num = self:AddComponent(UITextMeshProUGUIEx, task_progress_num_path)
  self.icon = self:AddComponent(UIImage, icon_path)
end

function UIActMonopolyLoopTaskItem:ComponentDestroy()
  self.descText = nil
  self.goBtn = nil
  self.receiveBtn = nil
  self.rewardContent = nil
  self.completedIcon = nil
  self.icon = nil
end

function UIActMonopolyLoopTaskItem:DataDefine()
  self.infos = {}
  self.itemReqs = {}
  self.itemList = {}
  self.showRewardId = nil
  self.index = nil
  self.curIndex = nil
end

function UIActMonopolyLoopTaskItem:DataDestroy()
  self.infos = nil
  self.itemReqs = nil
  self.itemList = nil
  self.onRewardAnimBack = nil
  self.showRewardId = nil
  self.index = nil
  self.curIndex = nil
end

function UIActMonopolyLoopTaskItem:ClearContent()
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

function UIActMonopolyLoopTaskItem:RefreshReward(rewardList)
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

function UIActMonopolyLoopTaskItem:SetData(activityId, taskData, index, curIndex, finNum, actMonopolyInfo)
  self.activityId = activityId
  self.taskData = taskData
  self.taskInfo = self.taskData.temp
  self.index = index
  self.curIndex = curIndex
  self.actMonopolyInfo = actMonopolyInfo
  local state = self.taskData.data.state
  local showList = DataCenter.RewardManager:ReturnRewardParamForView(self.taskData.data.reward)
  self:RefreshReward(showList)
  self.index_txt:SetText(self.index + finNum)
  if curIndex < self.index then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/ActSlotMachine/Mjc_huodong_laba_xianshimubiao_list02.png")
    self.index_bg:LoadSprite("Assets/Main/Sprites/UI/ActSlotMachine/Mjc_huodong_laba_xianshimubiao_icon02.png")
    self.goBtn:SetActive(false)
    self.receiveBtn:SetActive(false)
    self.completedIcon:SetActive(false)
    self.descText:SetLocalText("activity_slots_tips030")
    self.num_txt:SetText("")
    self.progress_content:SetActive(false)
    return
  else
    local bgImgPath = "Assets/Main/Sprites/UI/ActSlotMachine/Mjc_huodong_laba_xianshimubiao_list01.png"
    local indexBgImgPath = "Assets/Main/Sprites/UI/ActSlotMachine/Mjc_huodong_laba_xianshimubiao_icon01.png"
    local paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(self.actMonopolyInfo.richman_para)
    if paraTemp and not string.IsNullOrEmpty(paraTemp.task_progress_para) then
      local imgName = string.split(paraTemp.task_progress_para, "|")
      if imgName and #imgName == 3 then
        indexBgImgPath = string.format(UIAssets.UIActMonopolySpritePath, imgName[1])
        bgImgPath = string.format(UIAssets.UIActMonopolySpritePath, imgName[3])
      end
    end
    self.bg:LoadSpriteAuto(bgImgPath)
    self.index_bg:LoadSpriteAuto(indexBgImgPath)
  end
  local taskDesc = self.taskInfo:GetDesc(true)
  local process = ""
  local curNum = self.taskData.data.num and self.taskData.data.num or 0
  local targetNum = self.taskInfo:GetTargetNum()
  local progressRate = 0
  if 0 < targetNum then
    progressRate = curNum / targetNum
    progressRate = math.min(progressRate, 1)
  end
  if state == TaskState.Received and index < curIndex and curNum > targetNum then
    curNum = targetNum
  end
  process = curNum .. "/" .. targetNum
  self.descText:SetText("")
  self.num_txt:SetText("")
  self.progress_content:SetActive(true)
  self.task_progress_num:SetText(process)
  local bgSizeDelta = self.task_progressbg:GetSizeDelta()
  self.task_progress_img:SetSizeDeltaXY(progressRate * bgSizeDelta.x, bgSizeDelta.y)
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
  local imgPath = string.format(LoadPath.ItemPath, self.taskInfo.slots_icon)
  self.icon:LoadSprite(imgPath)
end

function UIActMonopolyLoopTaskItem:OnGoClick()
  if self.taskInfo then
    GoToUtil.GoToByQuestId(self.taskInfo)
  end
end

function UIActMonopolyLoopTaskItem:OnReceiveClick()
  SFSNetwork.SendMessage(MsgDefines.ActivityTaskReward, tonumber(self.activityId), tostring(self.taskData.data.taskId))
end

return UIActMonopolyLoopTaskItem
