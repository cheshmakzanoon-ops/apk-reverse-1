local RewardItem = require("UI.UIActivityRewardTip.Component.RewardItem")
local UIActivityRewardTipView = BaseClass("UIActivityRewardTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen
local RewardSciencePanel = require("UI.UIActivityRewardTip.Component.ActivityRewardSciencePanel")
local tip_path = "Tips"
local anim_path = "Tips/Anim"
local tips_txt_path = "Tips/Anim/TipsTitle"
local tips_task_txt_path = "Tips/Anim/TipsTitleTask"
local right_path = "Tips/Anim/Img_Right"
local left_path = "Tips/Anim/Img_Left"
local down_path = "Tips/Anim/Img_Down"
local scroll_path = "Tips/Anim/ScrollView"
local content_path = "Tips/Anim/ScrollView/Viewport/Content"
local return_btn_path = "Panel"
local cost_path = "Tips/Anim/TipsTitle/cost"
local rewardScience_path = "Tips/Anim/rewardScience"
local diamondDouble_path = "Tips/Anim/TipsTitle/cost/diamondDouble"
local rewardDouble_path = "Tips/Anim/DoubleBg"

local function OnCreate(self)
  base.OnCreate(self)
  local des, activityType, posX, posY, isLeft, accumulate, cellW, offset, activityId, rewardScience = self:GetUserData()
  self.des = des
  self.posX = posX
  self.posY = posY
  self.activityType = activityType
  self.isLeft = isLeft
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.isLeft = not self.isLeft
  end
  self.index = accumulate
  self.cellW = cellW or 0
  self.offset = offset or 0
  self.activityId = activityId or 0
  self.tip_obj = self:AddComponent(UIBaseContainer, tip_path)
  self.anim = self:AddComponent(UIAnimator, anim_path)
  self.tips_txt = self:AddComponent(UIText, tips_txt_path)
  self.tips_task_txt = self:AddComponent(UIText, tips_task_txt_path)
  self.rewardScienceInfo = rewardScience
  self.scroll_path = self:AddComponent(UIScrollRect, scroll_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._right_img = self:AddComponent(UIImage, right_path)
  self._left_img = self:AddComponent(UIImage, left_path)
  self._down_img = self:AddComponent(UIImage, down_path)
  self.cost = self:AddComponent(UIImage, cost_path)
  self.rewardScienceN = self:AddComponent(RewardSciencePanel, rewardScience_path)
  self.diamondDoubleN = self:AddComponent(UIText, diamondDouble_path)
  self.diamondDoubleN:SetActive(false)
  self.rewardDoubleN = self:AddComponent(UIBaseContainer, rewardDouble_path)
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self.tip_obj = nil
  self.anim = nil
  self.content = nil
  self.animator = nil
  self.return_btn = nil
  self.tips_txt = nil
  self.tips_task_txt = nil
  self.des = nil
  self.isShowBtn = nil
  self.posX = nil
  self.posY = nil
  self.activityType = nil
  self._right_img = nil
  self._left_img = nil
  self.cost = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self)
  local sf = UIManager:GetInstance():GetScaleFactor()
  local v3 = self.tip_obj.transform.position
  v3.x = self.posX
  v3.y = self.posY
  self.tip_obj.transform.position = v3
  local rectPos = self.tip_obj.rectTransform.anchoredPosition
  local rect = self.tip_obj.rectTransform.rect
  local halfScreenWidth = Screen.width / sf / 2 - 30
  local halfScreenHeight = Screen.height / sf / 2 - 30
  local halfHeight = rect.height / 2
  local halfWidth = rect.width / 2
  local x = rectPos.x
  local y = rectPos.y
  if self.offset == 0 then
    if self.isLeft then
      x = x + halfWidth + self.cellW / 2
    else
      x = x - halfWidth - self.cellW / 2
    end
    y = Mathf.Clamp(y, halfHeight - halfScreenHeight, halfScreenHeight - halfHeight) + self.offset
  else
  end
  y = Mathf.Clamp(y, halfHeight - halfScreenHeight, halfScreenHeight - halfHeight) + self.offset
  x = Mathf.Clamp(x, halfWidth - halfScreenWidth, halfScreenWidth - halfWidth)
  local tempAnchoredPosition = Vector2.New(x, y)
  self.tip_obj.rectTransform.anchoredPosition = tempAnchoredPosition
  if self.offset == 0 then
    self.anim.transform.pivot = Vector2.New(self.isLeft and 0 or 1, 0.5)
  else
    self.anim.transform.pivot = Vector2.New(0.5, 0.5)
  end
  self.anim:Play("CommonPopup_movein", 0, 0)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self._right_img:SetActive(self.isLeft and self.offset == 0)
    self._left_img:SetActive(not self.isLeft and self.offset == 0)
  else
    self._right_img:SetActive(not self.isLeft and self.offset == 0)
    self._left_img:SetActive(self.isLeft and self.offset == 0)
  end
  self._down_img:SetActive(false)
  self.rewardDoubleN:SetActive(false)
  self.diamondDoubleN:SetActive(false)
  self.tips_task_txt:SetSizeDelta({x = 290, y = 40})
  if self.activityType == nil then
    self.tips_task_txt:SetText(self.des)
    self.tips_txt:SetActive(false)
    self.tips_task_txt:SetActive(true)
    if self.isLeft then
      local tempV = self._left_img.rectTransform.anchoredPosition
      tempV.y = rectPos.y - 160
      self._left_img.rectTransform.anchoredPosition = tempV
    else
      local tempV = self._right_img.rectTransform.anchoredPosition
      tempV.y = rectPos.y - 160
      self._right_img.rectTransform.anchoredPosition = tempV
    end
  elseif self.activityType == -1 then
    self.tips_task_txt:SetText(self.des)
    self.tips_txt:SetActive(false)
    self.tips_task_txt:SetActive(true)
    if self.isLeft then
      local tempV = self._left_img.rectTransform.anchoredPosition
      tempV.y = rectPos.y + 100
      self._left_img.rectTransform.anchoredPosition = tempV
    else
      local tempV = self._right_img.rectTransform.anchoredPosition
      tempV.y = rectPos.y + 100
      self._right_img.rectTransform.anchoredPosition = tempV
    end
  elseif self.activityType == -2 then
    self.tips_task_txt:SetText(self.des)
    self.tips_txt:SetActive(false)
    self.tips_task_txt:SetActive(true)
    local tempV = self._right_img.rectTransform.anchoredPosition
    tempV.y = rectPos.y + 100
    self._right_img.rectTransform.anchoredPosition = tempV
  elseif self.activityType == -3 then
    self.tips_task_txt:SetText(self.des)
    self.tips_txt:SetActive(false)
    self.tips_task_txt:SetActive(true)
  elseif self.activityType == -4 then
    self.tips_task_txt:SetText(self.des)
    self.tips_txt:SetActive(false)
    self.tips_task_txt:SetActive(true)
  elseif self.activityType == EnumActivity.TurntableActivity.Type then
    self.tips_txt:SetActive(false)
    self.tips_task_txt:SetActive(true)
    self.tips_task_txt:SetText(self.des)
    self.cost:SetActive(false)
  elseif self.activityType == EnumActivity.JungleTrial.Type then
    self.tips_txt:SetActive(false)
    self.tips_task_txt:SetActive(false)
    self.cost:SetActive(false)
    self._down_img:SetActive(true)
  elseif self.activityType == EnumActivity.SeasonPreview.Type then
    self.tips_txt:SetText(self.des)
    self.cost:SetActive(false)
    self.tips_task_txt:SetActive(false)
    self.tips_txt:SetActive(true)
    local isLeft = self.isLeft
    if CommonUtil.IsArabicAutoMirrorOpen() then
      isLeft = not isLeft
    end
    if isLeft then
      local tempV = self._left_img.rectTransform.anchoredPosition
      tempV.y = -110
      self._left_img.rectTransform.anchoredPosition = tempV
    else
      local tempV = self._right_img.rectTransform.anchoredPosition
      tempV.y = -110
      self._right_img.rectTransform.anchoredPosition = tempV
    end
  elseif self.activityType == EnumActivity.BattlePass.Type then
    self.tips_txt:SetActive(false)
    self.tips_task_txt:SetActive(true)
    self.tips_task_txt:SetText(self.des)
    self.cost:SetActive(false)
    self.scroll_path:SetSizeDelta({x = 276, y = 384})
    self.tips_task_txt:SetSizeDelta({x = 290, y = 40})
  elseif self.activityType == EnumActivity.AllianceCompete.EventType then
    local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.EFFECT_ONE_MORE_TIMES)
    self.rewardDoubleN:SetActive(effectNum and 0 < effectNum)
    self.tips_txt:SetActive(true)
    self.tips_txt:SetText(self.des)
    self.cost:SetActive(true)
    self.tips_task_txt:SetActive(false)
  else
    self.tips_txt:SetText(self.des)
    self.cost:SetActive(true)
    self.tips_task_txt:SetActive(false)
    self.tips_txt:SetActive(true)
  end
  self:SetAllCellDestroy()
  self.modelwelfare = {}
  local newList = self.ctrl:GetRewardListByType(self.activityType, self.index, self.activityId)
  if newList ~= nil then
    for i = 1, table.length(newList) do
      self.modelwelfare[newList[i]] = self:GameObjectInstantiateAsync(UIAssets.ActivityRewardTipCell, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "item" .. i
        local cell = self.content:AddComponent(RewardItem, go.name)
        cell:RefreshData(newList[i])
      end)
    end
  end
  self.scroll_path:SetVerticalNormalizedPosition(1)
  self:RefreshRewardScience()
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(RewardItem)
  if self.modelwelfare ~= nil then
    for k, v in pairs(self.modelwelfare) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function RefreshRewardScience(self)
  if not self.rewardScienceInfo then
    self.rewardScienceN:SetActive(false)
  else
    self.rewardScienceN:SetActive(true)
    self.rewardScienceN:ShowPanel(self.rewardScienceInfo)
  end
end

local function OnGetClick(self)
  self.ctrl:GetRewardByType(self.activityType)
end

UIActivityRewardTipView.OnCreate = OnCreate
UIActivityRewardTipView.OnDestroy = OnDestroy
UIActivityRewardTipView.RefreshData = RefreshData
UIActivityRewardTipView.OnEnable = OnEnable
UIActivityRewardTipView.OnDisable = OnDisable
UIActivityRewardTipView.OnGetClick = OnGetClick
UIActivityRewardTipView.RefreshRewardScience = RefreshRewardScience
UIActivityRewardTipView.SetAllCellDestroy = SetAllCellDestroy
return UIActivityRewardTipView
