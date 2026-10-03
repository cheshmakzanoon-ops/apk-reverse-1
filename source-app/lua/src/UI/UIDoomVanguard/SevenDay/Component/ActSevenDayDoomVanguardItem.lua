local ActSevenDayDoomVanguardItem = BaseClass("ActSevenDayDoomVanguardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local UIGray = CS.UIGray
local Txt_Name = "Txt_Name"
local Txt_Score = "Txt_Score"
local Txt_TaskTarget = "Txt_TaskTarget"
local Btn_Reward = "Btn_Reward"
local Txt_Reward = "Btn_Reward/Txt_Reward"
local Txt_Gray = "Btn_Reward/Txt_Gray"
local Btn_Go = "Btn_Go"
local Txt_Go = "Btn_Go/Txt_Go"
local Btn_Locked = "Btn_Locked"
local Txt_Locked = "Btn_Locked/Txt_Locked"
local Img_Completed = "Img_Completed"
local Img_integral = "Txt_Score/Img_integral"
local Rect_Reward = "Rect_Reward"

function ActSevenDayDoomVanguardItem:OnCreate()
  base.OnCreate(self)
  self._name_txt = self:AddComponent(UIText, Txt_Name)
  self._score_txt = self:AddComponent(UIText, Txt_Score)
  self._taskTarget_txt = self:AddComponent(UIText, Txt_TaskTarget)
  self._reward_btn = self:AddComponent(UIButton, Btn_Reward)
  self._reward_txt = self:AddComponent(UIText, Txt_Reward)
  self._gray_txt = self:AddComponent(UIText, Txt_Gray)
  self._gray_txt:SetLocalText(170004)
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
  UIGray.SetGray(self._locked_btn.transform, true)
  self._locked_txt = self:AddComponent(UIText, Txt_Locked)
  self._locked_txt:SetLocalText(120050)
  self._completed_img = self:AddComponent(UIImage, Img_Completed)
  self.rewardRect = self:AddComponent(UIImage, Img_integral)
  self.content = self:AddComponent(UIBaseContainer, Rect_Reward)
end

function ActSevenDayDoomVanguardItem:OnDestroy()
  self:SetAllCellDestroy()
  self._name_txt = nil
  self._score_txt = nil
  base.OnDestroy(self)
end

function ActSevenDayDoomVanguardItem:OnEnable()
  base.OnEnable(self)
end

function ActSevenDayDoomVanguardItem:OnDisable()
  base.OnDisable(self)
end

function ActSevenDayDoomVanguardItem:RefreshData(param, days, scoreIcon, goodsId, targetPos)
  self.param = param
  self.taskId = param.id
  self.taskValue = DataCenter.TaskManager:FindTaskInfo(self.taskId)
  self.template = DataCenter.QuestTemplateManager:GetQuestTemplate(self.taskId)
  self._taskTarget_txt:SetActive(true)
  if days < param.day then
    self._reward_btn:SetActive(false)
    self._go_btn:SetActive(false)
    self._locked_btn:SetActive(true)
    self._completed_img:SetActive(false)
  else
    local state = self.taskValue.state
    if state == 2 then
      self._reward_btn:SetActive(false)
      self._go_btn:SetActive(false)
      self._locked_btn:SetActive(false)
      self._completed_img:SetActive(true)
      self._taskTarget_txt:SetActive(false)
    elseif state == 1 then
      self._reward_btn:SetActive(true)
      self._go_btn:SetActive(false)
      self._locked_btn:SetActive(false)
      self._completed_img:SetActive(false)
      self._reward_txt:SetActive(true)
      self._gray_txt:SetActive(false)
      UIGray.SetGray(self._reward_btn.transform, false, true)
    else
      self._locked_btn:SetActive(false)
      self._completed_img:SetActive(false)
      if self.template.gotype2 > 0 then
        self._go_btn:SetActive(true)
        self._reward_btn:SetActive(false)
      else
        self._reward_btn:SetActive(true)
        self._go_btn:SetActive(false)
        self._reward_txt:SetActive(false)
        self._gray_txt:SetActive(true)
        UIGray.SetGray(self._reward_btn.transform, true, false)
      end
    end
  end
  local process = ""
  local feizi = self.taskValue.num
  local feimu = self.template.para2
  if 0 <= feizi - feimu then
    feizi = feimu
  end
  feizi = string.GetFormattedSeperatorNum(feizi)
  feimu = string.GetFormattedSeperatorNum(feimu)
  process = "(" .. feizi .. "/" .. feimu .. ")"
  local desc = self.template:GetDesc()
  self._name_txt:SetText(desc)
  self._taskTarget_txt:SetText(process)
  self.scoreIconPath = scoreIcon
  self.RewardEx = {}
  self.RewardEx.count = param.point
  self.RewardEx.itemId = tostring(goodsId)
  self.RewardEx.rewardType = RewardType.GOODS
  self:RefreshReward(self.taskValue.rewardList)
  self.targetPos = targetPos
end

function ActSevenDayDoomVanguardItem:SetAllCellDestroy()
  self.content:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  if self.modelEx ~= nil then
    self:GameObjectDestroy(self.modelEx)
    self.modelEx = nil
  end
end

function ActSevenDayDoomVanguardItem:RefreshReward(list)
  self:SetAllCellDestroy()
  self.showList = self.view.ctrl:RewardItemList(list)
  self.model = {}
  if self.showList ~= nil then
    for i = 1, table.length(self.showList) do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(0.78, 0.8, 1)
        go.transform.pivot = Vector2.New(0.5, 0.5)
        go.transform:Set_sizeDelta(91, 96)
        go.name = "item" .. i
        local cell = self.content:AddComponent(UICommonResItem, go.name)
        cell:ReInit(self.showList[i])
        self.showList[i].iconImg = go.transform:Find("clickBtn/ItemIcon")
      end)
    end
  end
  if self.RewardEx then
    self.modelEx = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(0.78, 0.8, 1)
      go.transform.pivot = Vector2.New(0.5, 0.5)
      go.transform:Set_sizeDelta(91, 96)
      go.name = "itemEx"
      local cell = self.content:AddComponent(UICommonResItem, go.name)
      cell:ReInit(self.RewardEx)
      self.RewardEx.iconImg = go.transform:Find("clickBtn/ItemIcon")
    end)
  end
end

function ActSevenDayDoomVanguardItem:GetForward()
  local tempType = {}
  for i, v in ipairs(self.taskValue.rewardList) do
    if v.rewardType == RewardType.METAL or v.rewardType == RewardType.WATER or v.rewardType == RewardType.ELECTRICITY then
      tempType = {
        ResourceType.Metal,
        ResourceType.Electricity,
        ResourceType.Water
      }
      break
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, tempType)
end

function ActSevenDayDoomVanguardItem:OnClickReward()
  self:GetForward()
  local rewardTyp = RewardType.SEVENDAY_SCORE
  local flyPos = self.param.flyPos
  local pic = self.scoreIconPath
  local pos = self.transform.position
  if self.RewardEx.iconImg then
    pos = self.RewardEx.iconImg.transform.position
  end
  UIUtil.DoFly(tonumber(rewardTyp), 5, pic, pos, flyPos, 80, 80)
  self.view.ctrl:GetSevenDayTaskReward(self.taskId)
end

function ActSevenDayDoomVanguardItem:OnClickGo()
  GoToUtil.CloseAllWindows()
  GoToUtil.GoToByQuestId(self.template)
end

return ActSevenDayDoomVanguardItem
