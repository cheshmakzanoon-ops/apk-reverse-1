local UISurfingBattleGuideView = BaseClass("UISurfingBattleGuideView", UIBaseView)
local base = UIBaseView
local startEffectPath = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_ui_S4OffSeason_XSYD_guangquan_qidian.prefab"
local endEffectPath = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_ui_S4OffSeason_XSYD_guangquan_zhongdian.prefab"
local startClickEffectPath = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_ui_S4OffSeason_XSYD_guangquan_jihuo.prefab"
local endClickEffectPath = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_ui_S4OffSeason_XSYD_guangquan_jihuo_zd.prefab"
local ResourceManager = CS.GameEntry.Resource
local CSUtils = CS.CSUtils
local Localization = CS.GameEntry.Localization
local DelayTime = 0.3
local GuideAnim = {
  up = "V_ui_S4OffSeason_XSYD_up1",
  down = "V_ui_S4OffSeason_XSYD_down",
  left = "V_ui_S4OffSeason_XSYD_left",
  right = "V_ui_S4OffSeason_XSYD_right",
  double_click = "V_ui_S4OffSeason_XSYD_doubleclick",
  double_click_arabic = "V_ui_S4OffSeason_XSYD_doubleclick_flip"
}
local double_btn_path = "SafeArea/btns/doubleBtn"
local click_btn_path = "SafeArea/clickRoot/clickBtn"

function UISurfingBattleGuideView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UISurfingBattleGuideView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISurfingBattleGuideView:ComponentDefine()
  self.skipBtn = self:AddComponent(UIButton, "SafeArea/SkipBtn")
  self.skipBtn:SetOnClick(function()
    self:OnSkipBtnClick()
  end)
  self.guideAnim = self:AddComponent(UIAnimator, "SafeArea/btns/guideEffect")
  self.guideAnim:SetActive(false)
  self.downBtn = self:AddComponent(UIImage, "SafeArea/btns/downBtn")
  self.upBtn = self:AddComponent(UIImage, "SafeArea/btns/upBtn")
  self.leftBtn = self:AddComponent(UIImage, "SafeArea/btns/leftBtn")
  self.rightBtn = self:AddComponent(UIImage, "SafeArea/btns/rightBtn")
  self.double_btn = self:AddComponent(UIImage, double_btn_path)
  self.click_btn = self:AddComponent(UIImage, click_btn_path)
  self.arrow = self:AddComponent(UIBaseComponent, "SafeArea/btns/arrow")
  self.arrow:SetActive(false)
  self.bubble = self:AddComponent(UIBaseComponent, "SafeArea/btns/bubble")
  self.bubbleTip = self:AddComponent(UIText, "SafeArea/btns/bubble/bubbleTip")
end

function UISurfingBattleGuideView:ComponentDestroy()
  self.double_btn = nil
  self.click_btn = nil
end

function UISurfingBattleGuideView:DataDefine()
end

function UISurfingBattleGuideView:DataDestroy()
  if self.startEff then
    self.startEff:Destroy()
    self.startEff = nil
  end
  self.startEffAnim = nil
  if self.endEff then
    self.endEff:Destroy()
    self.endEff = nil
  end
  if self.startClickEffect then
    self.startClickEffect:Destroy()
    self.startClickEffect = nil
  end
  self.showStartClick = nil
  if self.endClickEffect then
    self.endClickEffect:Destroy()
    self.endClickEffect = nil
  end
end

function UISurfingBattleGuideView:OnAddListener()
  base.OnAddListener(self)
end

function UISurfingBattleGuideView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISurfingBattleGuideView:InitView()
  self.guidingType = self:GetUserData()
  if self.guidingType == nil then
    self.ctrl:CloseSelf()
    return
  end
  local baseWidth = 810
  local baseHeight = 1440
  local containerRect = UIManager:GetInstance():GetUIContainerRect()
  if IsNotNull(containerRect) then
    baseWidth = containerRect.sizeDelta.x
    baseHeight = containerRect.sizeDelta.y
    if baseWidth <= 0 then
      baseWidth = 810
    end
    if baseHeight <= 0 then
      baseHeight = 1440
    end
  end
  self.heightScale = Screen.height / baseHeight
  if 0 > self.heightScale then
    self.heightScale = 1
  end
  self.widthScale = Screen.width / baseWidth
  if 0 > self.widthScale then
    self.widthScale = 1
  end
  self.showStartClick = false
  self.guideAnim:SetActive(true)
  self.starParent = nil
  self.endParent = nil
  self.waitFinishTimer = nil
  if self.guidingType == 1 then
    self.starParent = self.downBtn
    self.endParent = self.upBtn
    self.guideAnim:Play(GuideAnim.up, 0, 0)
    local x, y, z = self.starParent.transform:Get_localPosition()
    local trans = self.arrow.transform
    trans:Set_localPosition(x, y, z)
    trans:Set_localEulerAngles(0, 0, 90)
    self.bubble.rectTransform:Set_anchoredPosition(0, 540, 0)
    self.bubbleTip:SetText(Localization:GetString("parkour_guide_desc_1"))
  elseif self.guidingType == 2 then
    self.starParent = self.upBtn
    self.endParent = self.downBtn
    self.guideAnim:Play(GuideAnim.down, 0, 0)
    local x, y, z = self.starParent.transform:Get_localPosition()
    local trans = self.arrow.transform
    trans:Set_localPosition(x, y, z)
    trans:Set_localEulerAngles(0, 0, -90)
    self.bubble.rectTransform:Set_anchoredPosition(0, 540, 0)
    self.bubbleTip:SetText(Localization:GetString("parkour_guide_desc_2"))
  elseif self.guidingType == 3 then
    self.starParent = self.rightBtn
    self.endParent = self.leftBtn
    self.guideAnim:Play(GuideAnim.left, 0, 0)
    local x, y, z = self.starParent.transform:Get_localPosition()
    local trans = self.arrow.transform
    trans:Set_localPosition(x, y, z)
    trans:Set_localEulerAngles(0, 0, 180)
    self.bubble.rectTransform:Set_anchoredPosition(0, 244, 0)
    self.bubbleTip:SetText(Localization:GetString("parkour_guide_desc_3"))
  elseif self.guidingType == 4 then
    self.starParent = self.leftBtn
    self.endParent = self.rightBtn
    self.guideAnim:Play(GuideAnim.right, 0, 0)
    local x, y, z = self.starParent.transform:Get_localPosition()
    local trans = self.arrow.transform
    trans:Set_localPosition(x, y, z)
    trans:Set_localEulerAngles(0, 0, 0)
    self.bubble.rectTransform:Set_anchoredPosition(0, 244, 0)
    self.bubbleTip:SetText(Localization:GetString("parkour_guide_desc_4"))
  elseif self.guidingType == 6 then
    self.starParent = self.double_btn
    self.endParent = nil
    if CommonUtil.IsArabicAutoMirrorOpen() then
      self.guideAnim:Play(GuideAnim.double_click_arabic, 0, 0)
    else
      self.guideAnim:Play(GuideAnim.double_click, 0, 0)
    end
    self.bubble.rectTransform:Set_anchoredPosition(0, 244, 0)
    self.bubbleTip:SetText(Localization:GetString("parkour_guide_desc_6"))
  elseif self.guidingType == 7 then
    self.starParent = self.click_btn
    self.endParent = nil
    self.bubble.rectTransform:Set_anchoredPosition(0, 244, 0)
    self.bubbleTip:SetText(Localization:GetString("parkour_guide_desc_7"))
  elseif self.guidingType == 8 then
    self.starParent = self.rightBtn
    self.endParent = self.leftBtn
    self.guideAnim:Play(GuideAnim.left, 0, 0)
    local x, y, z = self.starParent.transform:Get_localPosition()
    local trans = self.arrow.transform
    trans:Set_localPosition(x, y, z)
    trans:Set_localEulerAngles(0, 0, 180)
    self.bubble.rectTransform:Set_anchoredPosition(0, 244, 0)
    self.bubbleTip:SetText(Localization:GetString("parkour_guide_desc_8"))
  elseif self.guidingType == 9 then
    self.starParent = self.leftBtn
    self.endParent = self.rightBtn
    self.guideAnim:Play(GuideAnim.right, 0, 0)
    local x, y, z = self.starParent.transform:Get_localPosition()
    local trans = self.arrow.transform
    trans:Set_localPosition(x, y, z)
    trans:Set_localEulerAngles(0, 0, 0)
    self.bubble.rectTransform:Set_anchoredPosition(0, 244, 0)
    self.bubbleTip:SetText(Localization:GetString("parkour_guide_desc_9"))
  end
  if self.starParent then
    self.startEff = ResourceManager:InstantiateAsync(startEffectPath)
    self.startEff:completed("+", function()
      if self.startEff.isError then
        return
      end
      self.startEff.gameObject:SetActive(true)
      local trans = self.startEff.gameObject.transform
      trans:SetParent(self.starParent.transform)
      trans:Set_localPosition(0, 0, 0)
      trans:Set_localScale(1, 1, 1)
      self.startEffAnim = self.startEff.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
      if IsNotNull(self.startEffAnim) then
        self.startEffAnim.enabled = false
      end
    end)
  end
  if self.endParent then
    self.endEff = ResourceManager:InstantiateAsync(endEffectPath)
    self.endEff:completed("+", function()
      if self.endEff.isError then
        return
      end
      self.endEff.gameObject:SetActive(true)
      local trans = self.endEff.gameObject.transform
      trans:SetParent(self.endParent.transform)
      trans:Set_localPosition(0, 0, 0)
      trans:Set_localScale(1, 1, 1)
    end)
  end
end

function UISurfingBattleGuideView:ShowStartClickEffect()
  if not self.starParent then
    return
  end
  if IsNotNull(self.startEffAnim) and self.showStartClick then
    self.startEffAnim.enabled = false
    self.startEffAnim.enabled = true
    self.startEffAnim:Play("V_ui_S4OffSeason_XSYD_guangquan_click", 0, 0)
  end
  if self.startClickEffect == nil then
    self.startClickEffect = ResourceManager:InstantiateAsync(startClickEffectPath)
    self.startClickEffect:completed("+", function()
      if self.startClickEffect.isError then
        return
      end
      self.startClickEffect.gameObject:SetActive(self.showStartClick)
      local trans = self.startClickEffect.gameObject.transform
      trans:SetParent(self.starParent.transform)
      trans:Set_localPosition(0, 0, 0)
      trans:Set_localScale(1, 1, 1)
    end)
    return
  end
  if IsNull(self.startClickEffect.gameObject) then
    return
  end
  self.startClickEffect.gameObject:SetActive(self.showStartClick)
end

function UISurfingBattleGuideView:ShowEndClickEffect()
  if not self.endParent then
    return
  end
  if not self.endClickEffect then
    self.endClickEffect = ResourceManager:InstantiateAsync(endClickEffectPath)
    self.endClickEffect:completed("+", function()
      if self.endClickEffect.isError then
        return
      end
      self.endClickEffect.gameObject:SetActive(true)
      local trans = self.endClickEffect.gameObject.transform
      trans:SetParent(self.endParent.transform)
      trans:Set_localPosition(0, 0, 0)
      trans:Set_localScale(1, 1, 1)
    end)
  end
end

function UISurfingBattleGuideView:CheckGuideView(guideOpType, startPos, endPos)
  if self.arrow == nil then
    return false, false
  end
  if self.waitFinishTimer and self.waitFinishTimer > 0 then
    self.waitFinishTimer = self.waitFinishTimer - Time.deltaTime
    if self.waitFinishTimer <= 0 then
      self.waitFinishTimer = nil
      return true, true
    end
    return false, true
  end
  if endPos == nil or startPos == nil then
    self.arrow:SetActive(false)
    if self.showStartClick then
      self.showStartClick = false
      self:ShowStartClickEffect()
    end
    return false, false
  end
  if guideOpType == 1 then
    local startValid = CSUtils.ClickInUIRect(self.starParent.rectTransform, startPos.x, startPos.y)
    if startValid then
      local ver = endPos.y - startPos.y
      ver = ver / self.heightScale
      if 20 < ver then
        self.arrow:SetActive(true)
        self.arrow.rectTransform:Set_sizeDelta(ver, 64)
      else
        self.arrow:SetActive(false)
      end
      if not self.showStartClick then
        self.showStartClick = true
        self:ShowStartClickEffect()
      end
      local endValid = 270 < ver
      if endValid then
        self:ShowEndClickEffect()
        self.waitFinishTimer = DelayTime
      end
      return false, endValid
    end
  elseif guideOpType == 2 then
    local startValid = CSUtils.ClickInUIRect(self.starParent.rectTransform, startPos.x, startPos.y)
    if startValid then
      local ver = endPos.y - startPos.y
      ver = ver / self.heightScale
      if ver < -20 then
        self.arrow:SetActive(true)
        self.arrow.rectTransform:Set_sizeDelta(Mathf.Abs(ver), 64)
      else
        self.arrow:SetActive(false)
      end
      if not self.showStartClick then
        self.showStartClick = true
        self:ShowStartClickEffect()
      end
      local endValid = ver < -270
      if endValid then
        self:ShowEndClickEffect()
        self.waitFinishTimer = DelayTime
      end
      return false, endValid
    end
  elseif guideOpType == 3 then
    local startValid = CSUtils.ClickInUIRect(self.starParent.rectTransform, startPos.x, startPos.y)
    if startValid then
      local hor = endPos.x - startPos.x
      hor = hor / self.widthScale
      if hor < -20 then
        self.arrow:SetActive(true)
        self.arrow.rectTransform:Set_sizeDelta(Mathf.Abs(hor), 64)
      else
        self.arrow:SetActive(false)
      end
      if not self.showStartClick then
        self.showStartClick = true
        self:ShowStartClickEffect()
      end
      local endValid = hor < -385
      if endValid then
        self:ShowEndClickEffect()
        self.waitFinishTimer = DelayTime
      end
      return false, endValid
    end
  elseif guideOpType == 4 then
    local startValid = CSUtils.ClickInUIRect(self.starParent.rectTransform, startPos.x, startPos.y)
    if startValid then
      local hor = endPos.x - startPos.x
      hor = hor / self.widthScale
      if 20 < hor then
        self.arrow:SetActive(true)
        self.arrow.rectTransform:Set_sizeDelta(Mathf.Abs(hor), 64)
      else
        self.arrow:SetActive(false)
      end
      if not self.showStartClick then
        self.showStartClick = true
        self:ShowStartClickEffect()
      end
      local endValid = 385 < hor
      if endValid then
        self:ShowEndClickEffect()
        self.waitFinishTimer = DelayTime
      end
      return false, endValid
    end
  elseif guideOpType == 8 then
    local startValid = CSUtils.ClickInUIRect(self.starParent.rectTransform, startPos.x, startPos.y)
    if startValid then
      local hor = endPos.x - startPos.x
      hor = hor / self.widthScale
      if hor < -20 then
        self.arrow:SetActive(true)
        self.arrow.rectTransform:Set_sizeDelta(Mathf.Abs(hor), 64)
      else
        self.arrow:SetActive(false)
      end
      if not self.showStartClick then
        self.showStartClick = true
        self:ShowStartClickEffect()
      end
      local endValid = hor < -385
      if endValid then
        self:ShowEndClickEffect()
        self.waitFinishTimer = DelayTime
      end
      return false, endValid
    end
  elseif guideOpType == 9 then
    local startValid = CSUtils.ClickInUIRect(self.starParent.rectTransform, startPos.x, startPos.y)
    if startValid then
      local hor = endPos.x - startPos.x
      hor = hor / self.widthScale
      if 20 < hor then
        self.arrow:SetActive(true)
        self.arrow.rectTransform:Set_sizeDelta(Mathf.Abs(hor), 64)
      else
        self.arrow:SetActive(false)
      end
      if not self.showStartClick then
        self.showStartClick = true
        self:ShowStartClickEffect()
      end
      local endValid = 385 < hor
      if endValid then
        self:ShowEndClickEffect()
        self.waitFinishTimer = DelayTime
      end
      return false, endValid
    end
  end
  return false, false
end

function UISurfingBattleGuideView:CheckClickGuideView(guideOpType, curPos, lastPos)
  if self.waitFinishTimer and self.waitFinishTimer > 0 then
    self.waitFinishTimer = self.waitFinishTimer - Time.deltaTime
    if self.waitFinishTimer <= 0 then
      self.waitFinishTimer = nil
      return true, true
    end
    return false, true
  end
  self.arrow:SetActive(false)
  if self.showStartClick then
    self.showStartClick = false
    self:ShowStartClickEffect()
  end
  if curPos == nil then
    return false, false
  end
  if guideOpType == 6 then
    if lastPos == nil then
      return false, false
    end
    local clickValid = CSUtils.ClickInUIRect(self.starParent.rectTransform, lastPos.x, lastPos.y)
    clickValid = clickValid and CSUtils.ClickInUIRect(self.starParent.rectTransform, curPos.x, curPos.y)
    if clickValid then
      return true, true
    end
  elseif guideOpType == 7 then
    local clickValid = CSUtils.ClickInUIRect(self.starParent.rectTransform, curPos.x, curPos.y)
    if clickValid then
      return true, true
    end
  end
  return false, false
end

function UISurfingBattleGuideView:OnSkipBtnClick()
  UIUtil.ShowConfirmNew({
    contentText = Localization:GetString("parkour_guide_check"),
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        DataCenter.LWBattleManager:SetGameOver(true)
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
        local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
        if logic and logic.param and logic.param.type == PVEType.GhostParkour then
          local rewarded = DataCenter.LWGhostParkourDataManager:IsGuideReward()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UISurfingBattleGuideFinish, {anim = true}, {
            skip = true,
            rewarded = rewarded,
            type = 2
          })
          DataCenter.LWGhostParkourDataManager:ReqGuideReward()
          return
        end
        local rewarded = DataCenter.LWSurfingDataManager:IsGuideReward()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISurfingBattleGuideFinish, {anim = true}, {skip = true, rewarded = rewarded})
        DataCenter.LWSurfingDataManager:ReqGuideReward()
      end
    }
  })
end

return UISurfingBattleGuideView
