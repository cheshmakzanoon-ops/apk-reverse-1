local UILWDailyTaskItem = BaseClass("UILWDailyTaskItem", UIBaseContainer)
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
local reward_content_path = "RewardScroll/Viewport/Content"
local completedIconPath = "CompletedIcon"
local GO_BUTTON_TXT = "110003"
local RECEIVE_BUTTON_TXT = "170004"
local REWARD_TXT = "130065"

function UILWDailyTaskItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDailyTaskItem:OnDestroy()
  self:ClearContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDailyTaskItem:ComponentDefine()
  self.receiveBg = self:AddComponent(UIBaseContainer, receive_bg_path)
  self.descText = self:AddComponent(UIText, desc_txt_path)
  self.goBtnText = self:AddComponent(UIText, go_btn_txt_path)
  self.goBtn = self:AddComponent(UIButton, go_btn_path)
  self.goBtn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.receiveBtnText = self:AddComponent(UIText, receive_btn_txt_path)
  self.receiveBtn = self:AddComponent(UIButton, receive_btn_path)
  self.receiveBtn:SetOnClick(function()
    self:OnReceiveClick()
  end)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.goBtnText:SetLocalText(GO_BUTTON_TXT)
  self.receiveBtnText:SetLocalText(RECEIVE_BUTTON_TXT)
  self.completedIcon = self:AddComponent(UIImage, completedIconPath)
end

function UILWDailyTaskItem:ComponentDestroy()
  self.receiveBg = nil
  self.descText = nil
  self.goBtnText = nil
  self.goBtn = nil
  self.receiveBtnText = nil
  self.receiveBtn = nil
  self.rewardContent = nil
  self.completedIcon = nil
end

function UILWDailyTaskItem:DataDefine()
  self.infos = {}
  self.itemReqs = {}
  self.itemList = {}
  self.showRewardId = nil
end

function UILWDailyTaskItem:DataDestroy()
  self.infos = nil
  self.itemReqs = nil
  self.itemList = nil
  self.onRewardAnimBack = nil
  self.showRewardId = nil
end

function UILWDailyTaskItem:OnEnable()
  base.OnEnable(self)
end

function UILWDailyTaskItem:OnDisable()
  base.OnDisable(self)
end

function UILWDailyTaskItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWDailyTaskItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDailyTaskItem:ClearContent()
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

function UILWDailyTaskItem:RefreshReward(point, rewardList)
  self:ClearContent()
  if point then
    local req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if req == nil or IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "reward_item" .. "point"
      item:SetActive(true)
      item.transform:SetParent(self.rewardContent.transform)
      item.transform:Set_localScale(0.75, 0.8, 1)
      item.transform:Set_sizeDelta(118, 118)
      item.transform:Set_pivot(0.5, 0.5)
      local cell = self.rewardContent:AddComponent(UICommonResItem, item.name)
      local rewardPointData = {}
      rewardPointData.rewardType = RewardType.DailyTaskPoint
      rewardPointData.count = point
      cell:ReInit(rewardPointData)
      table.insert(self.itemList, cell)
    end)
    table.insert(self.itemReqs, req)
  end
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
        cell:ReInit(data)
        table.insert(self.itemList, cell)
      end)
      table.insert(self.itemReqs, req)
    end
  end
end

function UILWDailyTaskItem:SetData(dailyTaskInfo, onRewardAnimBack)
  self.info = dailyTaskInfo
  self.onRewardAnimBack = onRewardAnimBack
  if self.info then
    self.dailyTaskTemplate = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(self.info.id)
    local taskState = self.info.state
    local completeNum = self.info.num
    local allNum = self.info.totalNum
    if self.dailyTaskTemplate then
      local descStr = ""
      descStr = self.dailyTaskTemplate:GetDesc()
      if self.dailyTaskTemplate.progressShow == 1 then
        descStr = string.format("%s (%d/%d)", descStr, completeNum, allNum)
      end
      self.descText:SetText(descStr)
    end
    if taskState == TaskState.NoComplete then
      if completeNum >= allNum then
        self.completedIcon:SetActive(false)
        self.goBtn:SetActive(false)
        self.receiveBtn:SetActive(true)
        self.receiveBg:SetActive(true)
      else
        self.completedIcon:SetActive(false)
        self.goBtn:SetActive(true)
        self.receiveBtn:SetActive(false)
        self.receiveBg:SetActive(false)
      end
    elseif taskState == TaskState.CanReceive then
      self.completedIcon:SetActive(false)
      self.goBtn:SetActive(false)
      self.receiveBtn:SetActive(true)
      self.receiveBg:SetActive(true)
    elseif taskState == TaskState.Received then
      self.completedIcon:SetActive(true)
      self.goBtn:SetActive(false)
      self.receiveBtn:SetActive(false)
      self.receiveBg:SetActive(false)
    end
    if not self.showRewardId or self.showRewardId ~= self.info.id then
      if self.dailyTaskTemplate then
        self:RefreshReward(self.dailyTaskTemplate.point, self.info.reward)
      else
        self:RefreshReward(nil, self.info.reward)
      end
      self.showRewardId = self.info.id
    end
  end
end

function UILWDailyTaskItem:OnGoClick()
  if self.dailyTaskTemplate then
    GoToUtil.CloseAllWindows()
    GoToUtil.GoToByQuestId(self.dailyTaskTemplate)
  end
end

function UILWDailyTaskItem:OnReceiveClick()
  if self.info then
    if self.info.reward ~= nil then
      local rewardPos = self.receiveBtn.transform.position
      for i, v in ipairs(self.info.reward) do
        local rewardType = v.rewardType
        local itemId = v.itemId
        local pic = DataCenter.RewardManager:GetPicByType(rewardType, itemId)
        if not string.IsNullOrEmpty(pic) then
          UIUtil.DoFly(tonumber(rewardType), 3, pic, rewardPos, Vector3.New(0, 0, 0), nil, nil, nil, nil, 1)
        end
      end
    end
    if self.dailyTaskTemplate then
      local rewardPos = self.receiveBtn.transform.position
      local rewardType = RewardType.DailyTaskPoint
      local pic = DataCenter.RewardManager:GetPicByType(rewardType, nil)
      if not string.IsNullOrEmpty(pic) then
        local dstPos = self.view:GetDailyQuestPointIconPos()
        UIUtil.DoFly(tonumber(rewardType), 3, pic, rewardPos, dstPos, nil, nil, self.onRewardAnimBack, nil, 1)
      end
    end
    SFSNetwork.SendMessage(MsgDefines.DailyTaskReward, self.info.id)
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
  end
end

return UILWDailyTaskItem
