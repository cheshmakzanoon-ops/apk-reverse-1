local UIBattlePassNormalNewTaskCell = BaseClass("UIBattlePassNormalNewTaskCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local UIGray = CS.UIGray
local Txt_Name = "Layout/Txt_Name"
local Txt_Score = "Txt_Score"
local Img_Icon = "Img_Icon"
local Txt_TaskTarget = "Layout/Txt_TaskTarget"
local Btn_Reward = "Btn_Reward"
local Txt_Reward = "Btn_Reward/Txt_Reward"
local Btn_Go = "Btn_Go"
local Txt_Go = "Btn_Go/Txt_Go"
local Btn_Locked = "Btn_Locked"
local Txt_Locked = "Btn_Locked/Txt_Locked"
local CompletedContent = "CompletedContent"
local Img_integral = "Txt_Score/Img_integral"
local Rect_Reward = "Rect_Reward"

function UIBattlePassNormalNewTaskCell:OnCreate()
  base.OnCreate(self)
  self._name_txt = self:AddComponent(UIText, Txt_Name)
  self._icon_img = self:AddComponent(UIImage, Img_Icon)
  self._taskTarget_txt = self:AddComponent(UIText, Txt_TaskTarget)
  self._reward_btn = self:AddComponent(UIButton, Btn_Reward)
  self._reward_bnt_bg = self:AddComponent(UIImage, Btn_Reward)
  self._reward_txt = self:AddComponent(UIText, Txt_Reward)
  self._reward_txt:SetLocalText(170004)
  self._reward_btn:SetOnClick(function()
    self:OnClickReward()
  end)
  self._go_btn = self:AddComponent(UIButton, Btn_Go)
  self._go_txt = self:AddComponent(UIText, Txt_Go)
  self._go_txt:SetLocalText(110003)
  self._go_btn:SetOnClick(function()
    self:OnClickGo()
  end)
  self._locked_btn = self:AddComponent(UIButton, Btn_Locked)
  self._locked_txt = self:AddComponent(UIText, Txt_Locked)
  self._locked_txt:SetLocalText(120050)
  self._completed_content = self:AddComponent(UIText, CompletedContent)
  self.rewardRect = self:AddComponent(UIImage, Img_integral)
  self.content = self:AddComponent(UIBaseContainer, Rect_Reward)
  self.showItemList = {}
end

function UIBattlePassNormalNewTaskCell:OnDestroy()
  self:SetAllCellDestroy()
  self._name_txt = nil
  self.showItemList = nil
  base.OnDestroy(self)
end

function UIBattlePassNormalNewTaskCell:OnEnable()
  base.OnEnable(self)
end

function UIBattlePassNormalNewTaskCell:OnDisable()
  base.OnDisable(self)
end

function UIBattlePassNormalNewTaskCell:RefreshData(param, view)
  self.param = param
  self.taskId = param.info.taskId
  self.taskValue = DataCenter.TaskManager:FindTaskInfo(self.taskId)
  self._completed_content:SetActive(true)
  self._taskTarget_txt:SetActive(true)
  if self.param.type == EnumActivity.BattlePass_new.Type then
    self.template = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(self.taskId)
  else
    self.template = DataCenter.QuestTemplateManager:GetQuestTemplate(self.taskId)
  end
  if not string.IsNullOrEmpty(self.template.icon) then
    self._icon_img:LoadSprite(string.format(LoadPath.UIMainQuest, self.template.icon))
  end
  if param.info.startTime > UITimeManager:GetInstance():GetServerTime() then
    self._locked_btn:SetActive(true)
    UIGray.SetGray(self._locked_btn.transform, true)
  else
    self._locked_btn:SetActive(false)
  end
  local state = self.param.info.state
  if state == 0 then
    self._reward_btn:SetActive(false)
    self._go_btn:SetActive(true)
    self._completed_content:SetActive(false)
  elseif state == 1 then
    self._reward_btn:SetActive(true)
    self._reward_txt:SetLocalText(170004)
    self._reward_bnt_bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
    self._go_btn:SetActive(false)
    self._completed_content:SetActive(false)
  elseif state == 2 then
    self._go_btn:SetActive(false)
    self._reward_txt:SetLocalText(320440)
    self._reward_bnt_bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_4.png")
    if param.unlock == 0 then
      if self.param.info.reward or self.param.info.payExp ~= 0 then
        self._reward_btn:SetActive(true)
      else
        self._reward_btn:SetActive(false)
      end
      self._completed_content:SetActive(false)
    elseif param.info.payExp == 0 then
      self._reward_btn:SetActive(false)
      self._completed_content:SetActive(true)
    else
      self._reward_btn:SetActive(true)
      self._completed_content:SetActive(false)
    end
  elseif state == 3 or self.param.type == EnumActivity.BattlePass_new.Type and state == 4 then
    self._reward_btn:SetActive(false)
    self._go_btn:SetActive(false)
    self._taskTarget_txt:SetActive(false)
    self._completed_content:SetActive(true)
  end
  local process = ""
  local feizi = self.param.info.num
  local feimu = self.template.para2
  if 0 <= feizi - feimu then
    feizi = feimu
  end
  feizi = string.GetFormattedSeperatorNum(feizi)
  feimu = string.GetFormattedSeperatorNum(feimu)
  process = "(" .. feizi .. "/" .. feimu .. ")"
  self._name_txt:SetText(self.template:GetDesc())
  self._taskTarget_txt:SetText(process)
  self:RefreshReward(self.param)
end

function UIBattlePassNormalNewTaskCell:SetAllCellDestroy()
  self.content:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UIBattlePassNormalNewTaskCell:AddBattlePassScore(list, info)
  local count, itemId
  if self.param.type == EnumActivity.BattlePass_new.Type then
    itemId = info.scoreId
  end
  if info.state < 2 then
    count = info.exp
  else
    count = info.payExp
  end
  local hasBattleScore = false
  if list == nil then
    return
  end
  for _, v in pairs(list) do
    if v.rewardType == RewardType.BATTLE_PASS then
      hasBattleScore = true
      v.count = v.count + count
    end
  end
  if not hasBattleScore then
    local battlePassScore = {}
    if self.param.type == EnumActivity.BattlePass_new.Type then
      battlePassScore.rewardType = RewardType.GOODS
      battlePassScore.itemId = itemId
      battlePassScore.count = count
    else
      battlePassScore.rewardType = RewardType.BATTLE_PASS
      battlePassScore.count = count
    end
    table.insert(list, battlePassScore)
  end
end

function UIBattlePassNormalNewTaskCell:RefreshReward(list)
  self.showList = list.info.reward
  if list.info.state < 2 then
    if list.info.reward ~= nil then
      self.showList = DeepCopy(list.info.reward)
      if self.param.info.exp > 0 then
        self:AddBattlePassScore(self.showList, self.param.info)
      end
    elseif self.param.info.exp > 0 then
      self.showList = {}
      self:AddBattlePassScore(self.showList, self.param.info)
    else
      self.content:SetActive(false)
      return
    end
  elseif list.info.state >= 2 then
    if list.info.extraReward ~= nil then
      self.showList = DeepCopy(list.info.extraReward)
      if 0 < self.param.info.payExp then
        self:AddBattlePassScore(self.showList, self.param.info)
      end
    elseif 0 < self.param.info.payExp then
      self.showList = {}
      self:AddBattlePassScore(self.showList, self.param.info)
    else
      self.content:SetActive(false)
      return
    end
  end
  self:SetAllCellDestroy()
  self.content:SetActive(true)
  self.model = {}
  if self.showList ~= nil then
    for i = 1, table.length(self.showList) do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(0.77, 0.8, 0.8)
        local rectTransform = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
        rectTransform:Set_sizeDelta(93, 92)
        rectTransform.pivot = Vector2.New(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.content:AddComponent(UICommonResItem, go.name)
        cell:ReInit(self.showList[i])
        self.showItemList[i] = go.transform:Find("IconImg")
      end)
    end
  end
end

function UIBattlePassNormalNewTaskCell:GetForward()
  local tempType = {}
  if self.showList ~= nil then
    EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, tempType)
    for i, v in ipairs(self.showList) do
      local rewardType = v.rewardType
      local itemId = v.itemId
      local pic = RewardUtil.GetPic(v.rewardType, itemId)
      local img = self.showItemList[i]
      if pic ~= "" and not IsNull(img) then
        UIUtil.DoFly(tonumber(rewardType), 3, pic, img.transform.position, Vector3.New(0, 0, 0))
      end
    end
  end
end

function UIBattlePassNormalNewTaskCell:OnClickReward()
  if self.param.info.state == 2 and self.param.unlock == 0 then
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(self.param.actId))
    if activityData and activityData.subViewType == BattlePassType.Christmas then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassGiftPackagePopUpChristmas, tonumber(self.param.actId))
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassGiftPackagePopUp, self.param.actId)
    end
    return
  end
  self:GetForward()
  local rewardTyp = RewardType.BATTLE_PASS
  local flyPos = self.param.flyPos
  local pic = string.format(LoadPath.ItemPath, "Common_icon_battlecourage")
  UIUtil.DoFly(tonumber(rewardTyp), 3, pic, self.rewardRect.transform.position, flyPos, 40, 40, nil, nil, 1)
  if self.param.type == EnumActivity.BattlePass_new.Type then
    SFSNetwork.SendMessage(MsgDefines.NewBPTaskReward, self.param.actId, self.taskId)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ReceiveBattlePassTaskReward, self.param.actId, self.taskId)
end

function UIBattlePassNormalNewTaskCell:OnClickGo()
  if self.template == nil then
    return
  end
  GoToUtil.GoToByQuestId(self.template)
end

return UIBattlePassNormalNewTaskCell
