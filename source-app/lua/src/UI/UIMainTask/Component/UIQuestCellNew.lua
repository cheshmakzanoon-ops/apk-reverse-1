local UIQuestCellNew = BaseClass("UIQuestCellNew", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIQuestRewardCell = require("UI.UIMainTask.Component.UIQuestRewardCell")
local RewardUtil = require("Util.RewardUtil")
local Param = DataClass("Param", ParamData)
local ParamData = {
  id,
  index
}
local animator_obj_path = "animatorObj"
local quest_complete_text_path = "animatorObj/QuestCompleteText"
local quest_process_text_path = "animatorObj/QuestProcessText"
local quest_des_text_path = "animatorObj/QuestDesText"
local quest_reward_content_path = "animatorObj/QuestRewardContent"
local quest_btn_path = "animatorObj/Btn_click"
local jump_txt_path = "animatorObj/Btn_click/jumpTxt"
local get_txt_path = "animatorObj/Btn_click/getTxt"
local bg_img_path = "animatorObj/taskBg"
local icon_img_path = "animatorObj/item_bg/item_icon"
local StateIcon = {
  Goto = "Common_btn_yellow101",
  Reward = "Common_btn_green101"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:AddUIListener(EventId.PlayGetReward, self.GetForward)
end

local function OnDisable(self)
  base.OnDisable(self)
  self:RemoveUIListener(EventId.PlayGetReward, self.GetForward)
end

local function ComponentDefine(self)
  self.animatorObj = self:AddComponent(UIBaseContainer, animator_obj_path)
  self.quest_complete_text = self:AddComponent(UIText, quest_complete_text_path)
  self.quest_process_text = self:AddComponent(UIText, quest_process_text_path)
  self.jump_txt = self:AddComponent(UIText, jump_txt_path)
  self.quest_des_text = self:AddComponent(UIText, quest_des_text_path)
  self.get_txt = self:AddComponent(UIText, get_txt_path)
  self.quest_btn = self:AddComponent(UIButton, quest_btn_path)
  self.quest_btn_img = self:AddComponent(UIImage, quest_btn_path)
  self.bg = self:AddComponent(UIImage, bg_img_path)
  self.reward_bg = self:AddComponent(UIImage, quest_reward_content_path)
  self.quest_reward_content = self:AddComponent(UIBaseContainer, quest_reward_content_path)
  self.icon_img = self:AddComponent(UIImage, icon_img_path)
  self.quest_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.model = {}
  self:ResetDoTween()
end

local function ResetDoTween(self)
  DOTween.Rewind(self.animatorObj.gameObject)
end

local function ResetTween(self)
  DOTween.Restart(self.animatorObj.gameObject, "show_idle")
end

local function ComponentDestroy(self)
  self:RemoveList()
  self.quest_complete_text = nil
  self.quest_process_text = nil
  self.quest_title_text = nil
  self.quest_des_text = nil
  self.quest_btn = nil
  self.quest_btn_img = nil
  self.jump_txt = nil
  self.get_txt = nil
  self.quest_reward_content = nil
  self.bg = nil
  self.reward_bg = nil
  self.icon_img = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function GetTaskId(self)
  return self.param.id
end

local function ReInit(self, param)
  self.param = param
  self.template = DataCenter.QuestTemplateManager:GetQuestTemplate(param.id)
  self.quest_des_text:SetText(self.template:GetDesc(true))
  self.icon_img:LoadSprite(string.format(LoadPath.UITask, self.template.icon))
  self:RefreshState()
  self:ShowRewardCell()
end

local function PlayShowAnimation(self, state)
  if state == 1 then
    DOTween.Play(self.animatorObj.gameObject, "Dissolve")
  elseif state == 2 then
    DOTween.Play(self.animatorObj.gameObject, "Move")
  elseif state == 3 then
    DOTween.Play(self.animatorObj.gameObject, "Hide")
  end
end

local function RefreshState(self)
  local questData = self:GetQuestData()
  if questData ~= nil then
    local template = DataCenter.QuestTemplateManager:GetQuestTemplate(questData.id)
    if tonumber(template.progressshow) == 1 then
      local cur, all = self:ShowProcess()
      if all ~= nil then
        self.quest_process_text:SetLocalText(GameDialogDefine.SPLIT, cur, all)
        self.quest_process_text:SetActive(true)
        self.quest_process_text:SetColor(Color.New(0.3960784, 0.1960784, 0.07843138, 1))
      else
        self.quest_process_text:SetActive(false)
      end
    else
      self.quest_process_text:SetActive(false)
    end
    if questData.state == TaskState.CanReceive then
      self.quest_btn:SetActive(true)
      self.reward_bg:SetColor(Color.New(0.9725490196078431, 0.7490196078431373, 0.48627450980392156, 1))
      self.quest_btn_img:LoadSprite(string.format(LoadPath.CommonNewPath, StateIcon.Reward))
      self.quest_complete_text:SetLocalText(GameDialogDefine.COMPLETE)
      self.quest_complete_text:SetActive(true)
      self.get_txt:SetLocalText(GameDialogDefine.GET)
      self.jump_txt:SetText("")
    elseif questData.state == TaskState.NoComplete then
      self.reward_bg:SetColor(Color.New(0.9490196078431372, 0.8862745098039215, 0.807843137254902, 1))
      self.quest_btn:SetActive(true)
      self.quest_btn_img:LoadSprite(string.format(LoadPath.CommonNewPath, StateIcon.Goto))
      self.quest_complete_text:SetActive(false)
      self.get_txt:SetText("")
      self.jump_txt:SetLocalText(GameDialogDefine.GOTO)
    else
      self.reward_bg:SetColor(Color.New(0.9725490196078431, 0.7490196078431373, 0.48627450980392156, 1))
      self.quest_btn:SetActive(false)
      self.quest_complete_text:SetLocalText(GameDialogDefine.COMPLETE)
      self.quest_complete_text:SetActive(true)
      self.get_txt:SetText("")
      self.jump_txt:SetText("")
    end
  end
end

local function GetForward(self, id)
  if id ~= self.param.id then
    return
  end
  local questData = self:GetQuestData()
  local tempType = {}
  for i, v in ipairs(questData.rewardList) do
    if v.rewardType == RewardType.METAL or v.rewardType == RewardType.WATER or v.rewardType == RewardType.ELECTRICITY or v.rewardType == RewardType.FLINT or v.rewardType == RewardType.OBSIDIAN then
      table.insert(tempType, RewardToResType[v.rewardType])
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, tempType)
  for i, v in ipairs(questData.rewardList) do
    local rewardType = v.rewardType
    local itemId = v.itemId
    local count = v.count
    local pic = RewardUtil.GetPic(rewardType, itemId)
    local img = v.iconImg
    if pic ~= "" then
      UIUtil.DoFly(tonumber(rewardType), 5, pic, img.transform.position, Vector3.New(0, 0, 0))
    end
  end
end

local function OnBtnClick(self)
  local questData = self:GetQuestData()
  if questData ~= nil then
    if questData.state == TaskState.CanReceive then
      if self.view:IsNodeTween() then
        return
      end
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
      self:GetForward(self.param.id)
      self:PlayShowAnimation(1)
      self.param.callBack(self.param.index)
      SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, {
        id = self.param.id
      })
    elseif questData.state == TaskState.NoComplete then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(self.param.id)
      local triggerId = tostring(self.param.id)
      if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.QuestGoto, triggerId) then
      else
        GoToUtil.GoToByQuestId(questTemplate)
      end
    end
  end
end

local function ShowProcess(self)
  local cur = 0
  local all = self.template.para2
  local questData = self:GetQuestData()
  if questData ~= nil then
    cur = questData.num
  end
  if all < cur then
    cur = all
  end
  return cur, all
end

local function ShowRewardCell(self)
  self:RemoveList()
  local questData = self:GetQuestData()
  if questData ~= nil and questData.rewardList ~= nil then
    for k1, v1 in pairs(questData.rewardList) do
      self:AddOneRewardCells(k1, v1)
    end
  end
end

local function RemoveList(self)
  self.quest_reward_content:RemoveComponents(UIQuestRewardCell)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
  self.cells = {}
end

local function AddOneRewardCells(self, index, rewardParam)
  local param = {}
  param.rewardType = rewardParam.rewardType
  param.itemId = rewardParam.itemId
  param.count = rewardParam.count
  self.model[index] = self:GameObjectInstantiateAsync(UIAssets.UIQuestRewardCell, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.quest_reward_content.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:SetAsLastSibling()
    local nameStr = tostring(NameCount)
    go.name = nameStr
    NameCount = NameCount + 1
    self.cells[index] = self.quest_reward_content:AddComponent(UIQuestRewardCell, nameStr)
    self.cells[index]:ReInit(param)
    rewardParam.iconImg = go.transform:Find("IconImg")
  end)
end

local function GetQuestData(self)
  if self.template.type == QuestType.Main then
    return DataCenter.TaskManager:FindTaskInfo(self.param.id)
  end
end

local function GetIndex(self)
  if self.param ~= nil and self.param.index ~= nil then
    return self.param.index
  end
  return 0
end

local function GetGuideBtn(self)
  return self.quest_btn
end

UIQuestCellNew.OnCreate = OnCreate
UIQuestCellNew.OnDestroy = OnDestroy
UIQuestCellNew.Param = Param
UIQuestCellNew.OnEnable = OnEnable
UIQuestCellNew.OnDisable = OnDisable
UIQuestCellNew.ComponentDefine = ComponentDefine
UIQuestCellNew.ComponentDestroy = ComponentDestroy
UIQuestCellNew.DataDefine = DataDefine
UIQuestCellNew.DataDestroy = DataDestroy
UIQuestCellNew.ReInit = ReInit
UIQuestCellNew.OnBtnClick = OnBtnClick
UIQuestCellNew.ShowProcess = ShowProcess
UIQuestCellNew.RefreshState = RefreshState
UIQuestCellNew.ShowRewardCell = ShowRewardCell
UIQuestCellNew.AddOneRewardCells = AddOneRewardCells
UIQuestCellNew.GetQuestData = GetQuestData
UIQuestCellNew.GetForward = GetForward
UIQuestCellNew.PlayShowAnimation = PlayShowAnimation
UIQuestCellNew.GetTaskId = GetTaskId
UIQuestCellNew.GetIndex = GetIndex
UIQuestCellNew.RemoveList = RemoveList
UIQuestCellNew.ResetDoTween = ResetDoTween
UIQuestCellNew.GetGuideBtn = GetGuideBtn
UIQuestCellNew.ResetTween = ResetTween
return UIQuestCellNew
