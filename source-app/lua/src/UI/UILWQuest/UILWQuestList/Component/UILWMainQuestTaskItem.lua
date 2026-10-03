local UILWMainQuestTaskItem = BaseClass("UILWMainQuestTaskItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local receive_bg_path = "ReceiveBg"
local icon_path = "Icon"
local desc_txt_path = "Desc"
local go_btn_path = "GoBtn"
local go_btn_txt_path = "GoBtn/GoBtnText"
local receive_btn_path = "ReceiveBtn"
local receive_btn_txt_path = "ReceiveBtn/ReceiveBtnText"
local reward_content_path = "sv/RewardContent"
local GO_BUTTON_TXT = "110003"
local RECEIVE_BUTTON_TXT = "170004"
local REWARD_TXT = "130065"

function UILWMainQuestTaskItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMainQuestTaskItem:OnDestroy()
  self:ClearContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMainQuestTaskItem:ComponentDefine()
  self.receiveBg = self:AddComponent(UIBaseContainer, receive_bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
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
end

function UILWMainQuestTaskItem:ComponentDestroy()
  self.receiveBg = nil
  self.icon = nil
  self.descText = nil
  self.goBtnText = nil
  self.goBtn = nil
  self.receiveBtnText = nil
  self.receiveBtn = nil
  self.rewardContent = nil
  if self.uigouRes then
    self.uigouRes:Destroy()
    self.uigouRes = nil
  end
end

function UILWMainQuestTaskItem:DataDefine()
  self.infos = {}
  self.itemReqs = {}
  self.itemList = {}
end

function UILWMainQuestTaskItem:DataDestroy()
  self.infos = nil
  self.itemReqs = nil
  self.itemList = nil
end

function UILWMainQuestTaskItem:OnEnable()
  base.OnEnable(self)
end

function UILWMainQuestTaskItem:OnDisable()
  base.OnDisable(self)
end

function UILWMainQuestTaskItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWMainQuestTaskItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMainQuestTaskItem:RefreshState(is_finish)
  self.receiveBg:SetActive(is_finish)
  self.goBtn:SetActive(not is_finish)
  self.receiveBtn:SetActive(is_finish)
end

function UILWMainQuestTaskItem:ClearContent()
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

function UILWMainQuestTaskItem:RefreshReward(rewardList, prefabPath)
  self:ClearContent()
  if rewardList == nil then
    return
  end
  for i, data in ipairs(rewardList) do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(prefabPath, function(req)
      if req.isError then
        return
      end
      local item = req.gameObject
      item.name = "reward_item" .. i
      item:SetActive(true)
      item.transform:GetChild(0).gameObject.name = "obj" .. i
      item.transform:GetChild(0).gameObject:SetActive(true)
      item.transform:SetParent(self.rewardContent.transform)
      item.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local cell = self.rewardContent:AddComponent(UICommonResItem, item.name .. "/obj" .. i)
      cell:ReInit(data)
      self.itemList[i] = cell
    end)
  end
end

function UILWMainQuestTaskItem:SetData(params, prefabPath)
  self.infos = params.infos
  if self.infos then
    local isChapter = self.infos.isChapter
    if isChapter then
      self.icon:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/dl_zhujiemian_chuzheng_jiangli.png")
      self:RefreshReward(self.infos.rewardList, prefabPath)
      local taskState = self.infos.state
      local allNum = DataCenter.ChapterTaskManager:GetAllNum()
      local completeNum = DataCenter.ChapterTaskManager:GetCompleteNum()
      local is_finish = allNum <= completeNum and taskState == "0"
      self:RefreshState(is_finish)
      self.descText:SetLocalText(is_finish and 170459 or 170011)
      self.goBtn:SetActive(false)
    else
      local taskinfos = DataCenter.ChapterTaskManager:GetTaskInfos(self.infos)
      if string.IsNullOrEmpty(taskinfos.strIcon) then
        self.icon:SetActive(false)
      else
        self.icon:SetActive(true)
        self.icon:LoadSprite(taskinfos.strIcon)
      end
      self.descText:SetText(taskinfos.strDesc)
      self:RefreshReward(taskinfos.rewardList, prefabPath)
      local is_finish = taskinfos.is_finish
      self:RefreshState(is_finish)
    end
  end
end

function UILWMainQuestTaskItem:OnGoClick()
  DataCenter.ChapterTaskManager:QuestGoto(self.infos)
end

function UILWMainQuestTaskItem:OnReceiveClick()
  local isChapter = self.infos.isChapter
  if isChapter then
    DataCenter.ChapterTaskManager:ChapterGetReward()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
  else
    local rewardPos = self.icon.transform.position
    DataCenter.ChapterTaskManager:QuestGetReward(self.infos, rewardPos)
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
  end
end

return UILWMainQuestTaskItem
