local base = UIBaseContainer
local UIRevivalPlanCurrentItemComponent = BaseClass("UIRevivalPlanCurrentItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local finish_flag_path = "TargetItem/Bg/FinishFlag"
local content_path = "TargetItem/Bg/Rect_Reward/Viewport/Content"
local arrowEffect = "Assets/Main/Prefabs/Guide/UIArrowFinger.prefab"

function UIRevivalPlanCurrentItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIRevivalPlanCurrentItemComponent:OnDestroy()
  self:ClearContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRevivalPlanCurrentItemComponent:ComponentDefine()
  self.compRectReward = self:AddComponent(UIScrollRect, "TargetItem/Bg/Rect_Reward")
  self.btnReward = self:AddComponent(UIButton, "TargetItem/Bg/Btn_Reward")
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textTxtReward = self:AddComponent(UIText, "TargetItem/Bg/Btn_Reward/Txt_Reward")
  self.imgBtnReward = self:AddComponent(UIImage, "TargetItem/Bg/Btn_Reward")
  self.textTargetScore = self:AddComponent(UIText, "TargetItem/ScoreIcon/TargetScoreText")
  self.finish_flag = self:AddComponent(UIBaseContainer, finish_flag_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.redPoint = self:AddComponent(UIBaseContainer, "TargetItem/Bg/Btn_Reward/RedPoint")
  self.redPoint:SetActive(false)
end

function UIRevivalPlanCurrentItemComponent:ComponentDestroy()
  self.compRectReward = nil
  self.btnReward = nil
  self.textTxtReward = nil
  self.imgBtnReward = nil
  self.textTargetScore = nil
  self.finish_flag = nil
  self.content = nil
  self.redPoint = nil
end

function UIRevivalPlanCurrentItemComponent:DataDefine()
  self.itemReqs = {}
  self.itemList = {}
  self.itemGoList = {}
end

function UIRevivalPlanCurrentItemComponent:DataDestroy()
  self:ClearArrowEffect()
  self.itemReqs = nil
  self.itemList = nil
  self.itemGoList = nil
  self.rewardList = nil
end

function UIRevivalPlanCurrentItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIRevivalPlanCurrentItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIRevivalPlanCurrentItemComponent:SetData(data, index, activityData, stageId, stageIndex, isCurStage, showGuide)
  self.data = data
  self.index = index
  self.activityId = activityData.activityId
  self.activityData = activityData
  self.stageId = stageId
  self.stageIndex = stageIndex
  self.isCurStage = isCurStage
  local stageInfo = DataCenter.RevivalPlanManager:GetStageInfo(self.activityId, self.stageIndex)
  local replaceKeyMap = stageInfo.replaceKey
  self.replace = replaceKeyMap and not replaceKeyMap[index]
  self.key, self.replaceKey = DataCenter.RevivalPlanManager:GetActivityKeyId(activityData)
  self:RefreshReward(stageInfo)
  self:RefreshBtn(stageInfo)
  self.compRectReward:SetHorizontalNormalizedPosition(0)
  self:ShowGuide(showGuide)
end

function UIRevivalPlanCurrentItemComponent:RefreshBtn(stageInfo)
  local score = stageInfo.score or 0
  local indexList = stageInfo.indexList or {}
  self.state = 0
  local btnGray = false
  if table.indexof(indexList, self.index) then
    self.btnReward:SetActive(false)
    self.finish_flag:SetActive(true)
    self.state = 2
    self.textTargetScore:SetText(string.format("<color=#5FEF87>%d</color>", self.data))
    self.redPoint:SetActive(false)
  else
    self.btnReward:SetActive(true)
    self.finish_flag:SetActive(false)
    if score >= self.data then
      self.imgBtnReward:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
      self.state = 1
      self.textTxtReward:SetText(Localization:GetString("revival_plan_027"))
      self.textTargetScore:SetText(string.format("<color=#5FEF87>%d</color>", self.data))
      self.redPoint:SetActive(true)
    else
      self.imgBtnReward:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
      if self.isCurStage then
        self.textTxtReward:SetText(Localization:GetString("revival_plan_028"))
      else
        self.textTxtReward:SetText(Localization:GetString("revival_plan_036"))
        btnGray = true
      end
      self.textTargetScore:SetText(self.data)
      self.redPoint:SetActive(false)
    end
    CS.UIGray.SetGray(self.btnReward.transform, btnGray, true)
  end
end

function UIRevivalPlanCurrentItemComponent:RefreshReward()
  local cfg = DataCenter.ActivityRevivalConfigTemplateManager:GetTemplate(self.stageId)
  if cfg == nil then
    return
  end
  local parsed_base_reward_show = cfg:GetParsedBaseRewardShow()
  local showRewardList = parsed_base_reward_show[self.index]
  if showRewardList == nil then
    return
  end
  if self.replace then
    local has = false
    for _, reward in ipairs(showRewardList) do
      if reward and reward.itemId == self.key then
        has = true
        break
      end
    end
    if has then
      showRewardList = cfg:GetReplaceRewardShow(self.index, self.key)
    end
  end
  self:ShowRewardImp(showRewardList)
end

function UIRevivalPlanCurrentItemComponent:ShowRewardImp(rewardList)
  self.rewardList = rewardList
  local rewardCount = #rewardList
  local itemCount = #self.itemList
  local itemReqCount = #self.itemReqs
  local count = Mathf.Min(rewardCount, itemCount)
  for i = 1, count do
    local item = self.itemList[i]
    local data = rewardList[i]
    item:ReInit(data)
    local go = self.itemGoList[i]
    if go then
      go:SetActive(true)
    end
  end
  for i = count + 1, itemCount do
    local go = self.itemGoList[i]
    if go then
      go:SetActive(false)
    end
  end
  for i = itemReqCount + 1, rewardCount do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if req.isError then
        return
      end
      local scale = 0.9
      local item = req.gameObject
      item.name = "reward_item" .. i
      item.transform:SetParent(self.content.transform)
      item.transform:Set_localScale(scale, scale, 1)
      local cell = self.content:AddComponent(UICommonResItem, item.name)
      self.itemList[i] = cell
      self.itemGoList[i] = item
      local data = self.rewardList[i]
      if data == nil then
        item:SetActive(false)
        return
      end
      item:SetActive(true)
      cell:ReInit(data)
    end)
  end
end

function UIRevivalPlanCurrentItemComponent:ClearContent()
  if table.count(self.itemList) > 0 then
    self.content:RemoveComponents(UICommonResItem)
    self.itemList = nil
  end
  self.itemGoList = nil
  if 0 < table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      if req ~= nil then
        self:GameObjectDestroy(req)
      end
    end
    self.itemReqs = nil
  end
end

function UIRevivalPlanCurrentItemComponent:OnBtnRewardClick()
  if self.state == 0 then
    if self.isCurStage then
      EventManager:GetInstance():Broadcast(EventId.RevivalPlanShowPlanTaskFromDayItem, {
        stageId = self.stageId,
        hideBtn = not self.isCurStage
      })
    else
      UIUtil.ShowTips(Localization:GetString("revival_plan_040"))
    end
  elseif self.state == 1 then
    EventManager:GetInstance():Broadcast(EventId.RevivalPlanTryClaimReward, {
      index = self.index,
      stageId = self.stageId
    })
  end
end

function UIRevivalPlanCurrentItemComponent:ShowGuide(showGuide)
  if showGuide then
    self.vfxHandle = DataCenter.LWGuideVFXManager:InstantiateAsync(arrowEffect, self.OnVfxLoaded, self, 2, GuideVFXPriority.High)
  end
end

function UIRevivalPlanCurrentItemComponent:OnVfxLoaded(handle)
  if handle.isError then
    self:LogError("UIRevivalPlanCurrentItemComponent.OnVfxLoaded load res failed")
    return
  end
  handle.gameObject.transform:SetParent(self.btnReward.transform)
  handle.gameObject.transform:Set_localPosition(-30, -30, 0)
  handle.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  if self.holder and self.holder.transform then
    handle.gameObject.transform:SetParent(self.holder.transform)
  end
end

function UIRevivalPlanCurrentItemComponent:ClearArrowEffect()
  if self.vfxHandle then
    DataCenter.LWGuideVFXManager:StopCurrent(self.vfxHandle)
    self.vfxHandle = nil
  end
end

return UIRevivalPlanCurrentItemComponent
