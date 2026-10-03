local UIAccuRechargeTargetItem_Common = BaseClass("UIAccuRechargeTargetItem_Common", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local UIGray = CS.UIGray
local UICommonResItem = require("UI/UIActivityCenterTable/Component/UIAccuRecharge/UIAccuRechargeResItem")
local rewardListPath = "Rect_Reward/Viewport/Content"
local rewardBtnPath = "Btn_Reward"
local rewardBtnTextPath = "Btn_Reward/Txt_Reward"
local targetTextPath = "TargetScoreText"
local scoreIconPath = "ScoreIcon"
local specialBgPath = "SpecialBg"
local complete_content_path = "CompleteContent"

function UIAccuRechargeTargetItem_Common:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIAccuRechargeTargetItem_Common:ComponentDefine()
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardListPath)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtnPath)
  self.rewardBtn:SetOnClick(function()
    self:OnClickReward()
  end)
  self.rewardBtnText = self:AddComponent(UIText, rewardBtnTextPath)
  self.targetText = self:AddComponent(UIText, targetTextPath)
  self.scoreIcon = self:AddComponent(UIImage, scoreIconPath)
  if not IsNull(self.transform:Find(specialBgPath)) then
    self.specialBg = self:AddComponent(UIImage, specialBgPath)
  end
  self.bg = self:AddComponent(UIImage, "Bg")
  self.complete_content = self:AddComponent(UIImage, complete_content_path)
end

function UIAccuRechargeTargetItem_Common:ComponentDestroy()
  self.rewardContent = nil
  self.rewardBtn = nil
  self.rewardBtnText = nil
  self.targetText = nil
  self.scoreIcon = nil
  self.specialBg = nil
  self.bg = nil
  self.complete_content = nil
end

function UIAccuRechargeTargetItem_Common:OnDestroy()
  base.OnDestroy(self)
end

function UIAccuRechargeTargetItem_Common:OnEnable()
  base.OnEnable(self)
end

function UIAccuRechargeTargetItem_Common:OnDisable()
  base.OnDisable(self)
end

function UIAccuRechargeTargetItem_Common:RefreshData(stageInfo, curScore, actId, pointIcon, curIndex, maxIndex)
  if not stageInfo then
    return
  end
  self.curScore = curScore
  self.actId = actId
  self.stageInfo = stageInfo
  self.targetText:SetText(self.stageInfo.needScore)
  self.state = self.stageInfo.state
  self.rewardList = DeepCopy(self.stageInfo.reward)
  self.curIndex = curIndex
  self.maxIndex = maxIndex
  if self.state == 0 then
    if curScore >= self.stageInfo.needScore then
      UIGray.SetGray(self.rewardBtn.transform, false, true)
      self.rewardBtn:SetActive(true)
      self.complete_content:SetActive(false)
      self.rewardBtnText:SetLocalText(2000410)
    else
      UIGray.SetGray(self.rewardBtn.transform, true, false)
      self.rewardBtn:SetActive(true)
      self.complete_content:SetActive(false)
      self.rewardBtnText:SetLocalText(2000410)
    end
  else
    UIGray.SetGray(self.rewardBtn.transform, true, false)
    self.rewardBtn:SetActive(false)
    self.complete_content:SetActive(true)
    self.rewardBtnText:SetLocalText(2000411)
  end
  self:RefreshReward(self.rewardList)
  if not string.IsNullOrEmpty(pointIcon) then
    self.scoreIcon:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.ItemPath, pointIcon))
    self.scoreIcon:SetNativeSize()
  else
    self.scoreIcon:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.ItemPath, DefaultRechargePointIconPath))
    self.scoreIcon:SetNativeSize()
  end
  if self.specialBg then
    self.specialBg:SetActive(self.curIndex == self.maxIndex)
  end
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if activityData then
    self:RefreshCommonNode(activityData:GetShowConfigTemp(), activityData.subViewType)
  end
  if CommonUtil.IsArabic() and CommonUtil.ArabicAutoMirrorFactor() == -1 then
    self.bg:SetLocalScaleXYZ(-1, 1, 1)
    if self.specialBg then
      self.specialBg:SetLocalScaleXYZ(-1, 1, 1)
    end
  else
    self.bg:SetLocalScaleXYZ(1, 1, 1)
    if self.specialBg then
      self.specialBg:SetLocalScaleXYZ(1, 1, 1)
    end
  end
end

function UIAccuRechargeTargetItem_Common:SetAllCellDestroy()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if not table.IsNullOrEmpty(self.model) then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function UIAccuRechargeTargetItem_Common:RefreshReward(list)
  self.showList = list
  if not self.model then
    self.model = {}
  end
  local currentRewardCount = 0
  if self.model then
    currentRewardCount = #self.model
  end
  local newRewardCount = #self.showList or 0
  
  local function GetItemName(index)
    return string.format("item%s", index)
  end
  
  if currentRewardCount < newRewardCount then
    for i = currentRewardCount + 1, newRewardCount do
      local assetsPath = "Assets/Main/Prefabs/UI/ActivityCenter/AccuRecharge/UICommonResItemAccuRecharge.prefab"
      self.model[i] = self:GameObjectInstantiateAsync(assetsPath, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.rewardContent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform.pivot = Vector2.New(0.5, 0.5)
        go.transform:Set_sizeDelta(83, 88)
        go.name = GetItemName(i)
        local cell = self.rewardContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(self.showList[i])
        self.showList[i].iconImg = go.transform:Find("clickBtn/ItemIcon")
        cell:SetActive(true)
      end)
    end
  elseif currentRewardCount > newRewardCount then
    for i = newRewardCount + 1, currentRewardCount do
      if self.model[i] ~= nil then
        self.rewardContent:RemoveComponent(GetItemName(i), UICommonResItem)
        self:GameObjectDestroy(self.model[i])
        self.model[i] = nil
      end
    end
  end
  for i = 1, newRewardCount do
    if self.model[i] ~= nil then
      local cell = self.rewardContent:GetComponent(GetItemName(i), UICommonResItem)
      if cell ~= nil then
        cell:ReInit(self.showList[i])
        self.showList[i].iconImg = self.model[i].gameObject.transform:Find("clickBtn/ItemIcon")
      end
    end
  end
end

function UIAccuRechargeTargetItem_Common:OnClickReward()
  if not self.actId or not self.stageInfo then
    return
  end
  if self.stageInfo.state ~= 0 then
    return
  end
  if self.curScore < self.stageInfo.needScore then
    return
  end
  DataCenter.CumulativeRechargeManager:SendReward(self.actId, self.stageInfo.stageId)
end

function UIAccuRechargeTargetItem_Common:RefreshCommonNode(showTemp, subViewType)
  if showTemp and not string.IsNullOrEmpty(showTemp.pic_spec2) then
    local picNameList = string.split(showTemp.pic_spec2, "|")
    local name1 = picNameList[1]
    if name1 and not string.IsNullOrEmpty(name1) then
      local path = LoadPath.UIAccuRecharge
      if subViewType == AccuRechargeType.FestivalOverlap then
        path = LoadPath.UIAccuRechargeFestival
      end
      self.bg:LoadSpriteAsync(DataCenter.ActivityListDataManager:GetActivityModLoadPath(path, name1))
    end
  end
end

function UIAccuRechargeTargetItem_Common:SetCustomBg(normalPath, specialPath)
  if not string.IsNullOrEmpty(normalPath) and self.bg then
    self.bg:LoadSpriteAsync(normalPath)
  end
  if not string.IsNullOrEmpty(specialPath) and self.specialBg then
    self.specialBg:LoadSpriteAsync(specialPath)
  end
end

function UIAccuRechargeTargetItem_Common:TriggerRewardChangeEffect(stageUpdateData, stageNewData)
  local updateItemDic = {}
  if stageUpdateData then
    for _, v in pairs(stageUpdateData) do
      local itemId = v.newRewardData.itemId
      updateItemDic[itemId] = true
    end
  end
  local cells = self.rewardContent:GetComponents(UICommonResItem)
  if cells then
    for _, cell in pairs(cells) do
      local itemId = cell:GetItemId()
      if itemId and updateItemDic[tonumber(itemId)] then
        cell:PlayUpdateEffect()
      end
    end
  end
end

return UIAccuRechargeTargetItem_Common
