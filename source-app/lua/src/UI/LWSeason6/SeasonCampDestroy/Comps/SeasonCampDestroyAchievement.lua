local base = UIAsyncContainer
local SeasonCampDestroyAchievement = BaseClass("SeasonCampDestroyAchievement", base)
local Localization = CS.GameEntry.Localization
local LWSeasonPersonalRewardItem = require("UI.LWSeason.LWSeasonReward.Component.LWSeasonPersonalRewardItem")
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function SeasonCampDestroyAchievement:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyAchievement:OnEnable()
  base.OnEnable(self)
  self.first = true
end

function SeasonCampDestroyAchievement:OnDisable()
  base.OnDisable(self)
  self.first = false
  self:ClearScroll()
  self.listGOReward = nil
end

function SeasonCampDestroyAchievement:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyAchievement:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.gridInfinityScrollViewContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 1)
  self.compScrollView = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.sliderProgressBar = self.viewSkin:AddComponent(self, UISlider, 3)
  self.textOccupyNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnOneGet = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnOneGet:SetOnClick(function()
    self:OnBtnOneGetClick()
  end)
  self.imgScoreIcon = self.viewSkin:AddComponent(self, UIImage, 6)
  self.imgRectOnGetRed = self.viewSkin:AddComponent(self, UIImage, 7)
  self.compTopArea = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.textJoinAliHit = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textOccupyland = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textOccupyDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnGoto = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnGoto:SetOnClick(function()
    self:OnBtnGotoClick()
  end)
  self.textGotoDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.btnIntro = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnIntro:SetOnClick(function()
    self:OnBtnIntroClick()
  end)
  self:SetOffsetMinXY(0, 0)
  self:SetOffsetMaxXY(0, 0)
  self.itemList = {}
  self.listGOReward = nil
  self.curScore = nil
  self.progressSliderInstanceId = self.sliderProgressBar.transform:GetInstanceID()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compScrollView.transform)
end

function SeasonCampDestroyAchievement:ComponentDestroy()
  self.viewSkin = nil
  self.gridInfinityScrollViewContent = nil
  self.compScrollView = nil
  self.sliderProgressBar = nil
  self.textOccupyNum = nil
  self.btnOneGet = nil
  self.imgScoreIcon = nil
  self.imgRectOnGetRed = nil
  self.compTopArea = nil
  self.textJoinAliHit = nil
  self.textOccupyland = nil
  self.textOccupyDes = nil
  self.btnGoto = nil
  self.textGotoDes = nil
  self.btnIntro = nil
  self.itemList = nil
  self.listGOReward = nil
end

function SeasonCampDestroyAchievement:DataDefine()
end

function SeasonCampDestroyAchievement:DataDestroy()
end

function SeasonCampDestroyAchievement:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonPersonalRewardInfo, self.RefreshAll)
  self:AddUIListener(EventId.LWSeasonPersonalRewardGetSuccess, self.RefreshAll)
  self:AddUIListener(EventId.LWSeasonScoreRewardInfo, self.RefreshAll)
end

function SeasonCampDestroyAchievement:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardInfo, self.RefreshAll)
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardGetSuccess, self.RefreshAll)
  self:RemoveUIListener(EventId.LWSeasonScoreRewardInfo, self.RefreshAll)
  base.OnRemoveListener(self)
end

function SeasonCampDestroyAchievement:Refresh(achievementTemplate)
  self.curPanelData = {
    type = achievementTemplate.id,
    key = achievementTemplate.tab_title,
    title = achievementTemplate.title,
    icon = achievementTemplate.icon,
    value = achievementTemplate.value,
    description = achievementTemplate.description,
    flag = achievementTemplate.flag,
    banner = achievementTemplate.bg
  }
  self.panelType = achievementTemplate.id
  if self.curPanelData.icon then
    self.imgScoreIcon:LoadSprite(self.curPanelData.icon)
  end
  self:RefreshText()
  self:SetScore()
  self:ShowCells(true)
  self:GetAllBtnState()
  self:GetGotoBtnDes()
end

function SeasonCampDestroyAchievement:ShowCells(flag)
  if self.listGOReward then
    return
  end
  if self.first then
    self.first = false
    self.personalReward = nil
  end
  self.personalReward = DataCenter.SeasonRewardDataManager:GetSeasonAchievementRewardData(flag, self.panelType)
  if self.personalReward then
    self.listGOReward = {}
    local bindFunc1 = BindCallback(self, self.OnInitRewardScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateRewardScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyRewardScrollItem)
    self.gridInfinityScrollViewContent:Init(bindFunc1, bindFunc2, bindFunc3)
    local count = #self.personalReward
    if count == 0 then
      self.compScrollView:SetActive(false)
    else
      self.compScrollView:SetActive(true)
      self.gridInfinityScrollViewContent:SetItemCount(count)
      self.gridInfinityScrollViewContent:ForceUpdate()
      local focus = DataCenter.SeasonRewardDataManager:GetPersonalRewardClaimIndex(self.panelType)
      if focus then
        self.gridInfinityScrollViewContent:MoveItemByIndex(focus - 1, 0)
      end
    end
    local renderItemSizeY = self.gridInfinityScrollViewContent:GetRenderItemSizeY()
    if count < 1 then
      self.sliderProgressBar.rectTransform:Set_sizeDelta(37, 0)
    else
      self.sliderProgressBar.rectTransform:Set_sizeDelta(37, (count - 1) * renderItemSizeY)
    end
    self:RefreshProgressBar()
  else
    self.compScrollView:SetActive(false)
  end
end

function SeasonCampDestroyAchievement:RefreshProgressBar()
  if self.curScore == nil then
    self.curScore = DataCenter.SeasonRewardDataManager:GetPersonalOccupyLandCount(self.panelType)
  end
  local count = self.personalReward ~= nil and #self.personalReward or 0
  local progress = 0
  local step = 1 / (count - 1)
  local exp = self.curScore
  progress = 0
  local lastNeedExp = 0
  if 0 < count then
    local needExp = DataCenter.SeasonRewardDataManager:GetPersonalRewardScore(self.panelType, 1)
    lastNeedExp = needExp
    if exp >= needExp then
    else
      exp = 0
    end
    if 0 < exp then
      for i = 2, count do
        needExp = DataCenter.SeasonRewardDataManager:GetPersonalRewardScore(self.panelType, i)
        if exp >= needExp then
          progress = progress + step
          lastNeedExp = needExp
        else
          needExp = needExp - lastNeedExp
          exp = exp - lastNeedExp
          progress = exp / needExp * step + progress
          break
        end
      end
    end
  end
  progress = math.max(progress, 0)
  self.sliderProgressBar:SetValue(progress)
end

function SeasonCampDestroyAchievement:SetScore()
  self.curScore = DataCenter.SeasonRewardDataManager:GetPersonalOccupyLandCount(self.panelType)
  if string.IsNullOrEmpty(self.curPanelData.value) then
    self.textOccupyNum:SetText(self.curScore)
  else
    self.textOccupyNum:SetText(Localization:GetString(self.curPanelData.value, self.curScore))
  end
end

function SeasonCampDestroyAchievement:RefreshText()
  local title, des
  title = Localization:GetString(self.curPanelData.title)
  des = Localization:GetString(self.curPanelData.description)
  self.textOccupyland:SetText(title)
  self.textOccupyDes:SetText(des)
end

function SeasonCampDestroyAchievement:RefreshAll()
  local count = self.personalReward ~= nil and #self.personalReward or 0
  if count == 0 and self.listGOReward then
    self.personalReward = DataCenter.SeasonRewardDataManager:GetSeasonAchievementRewardData(false, self.panelType)
    count = self.personalReward ~= nil and #self.personalReward or 0
    if 0 < count then
      local focus = DataCenter.SeasonRewardDataManager:GetPersonalRewardClaimIndex(self.panelType)
      if focus then
        self.gridInfinityScrollViewContent:MoveItemByIndex(focus - 1, 0)
      else
        self.gridInfinityScrollViewContent:MoveItemByIndex(0)
      end
      self.gridInfinityScrollViewContent:SetItemCount(count)
      self.gridInfinityScrollViewContent:ForceUpdate()
      local renderItemSizeY = self.gridInfinityScrollViewContent:GetRenderItemSizeY()
      if count < 1 then
        self.sliderProgressBar.rectTransform:Set_sizeDelta(37, 0)
      else
        self.sliderProgressBar.rectTransform:Set_sizeDelta(37, (count - 1) * renderItemSizeY)
      end
    end
  elseif self.listGOReward then
    self.gridInfinityScrollViewContent:ForceUpdate()
  else
    self:SetScore()
    self:ShowCells(false)
  end
  self:SetScore()
  self:RefreshProgressBar()
end

function SeasonCampDestroyAchievement:OnInitRewardScroll(go, index)
  local item = self.compScrollView:AddComponent(LWSeasonPersonalRewardItem, go)
  self.listGOReward[go] = item
end

function SeasonCampDestroyAchievement:OnUpdateRewardScroll(go, index)
  index = index + 1
  local iconPath = self.curPanelData.icon
  if self.personalReward then
    if index <= #self.personalReward then
      local item = self.listGOReward[go]
      local data = self.personalReward[index]
      item:SetData(data, self, iconPath, true, false)
      go:SetActive(true)
      self.itemList[index] = item
    end
  else
    go:SetActive(false)
  end
end

function SeasonCampDestroyAchievement:OnDestroyRewardScrollItem(go, index)
end

function SeasonCampDestroyAchievement:ClearScroll()
  self.compScrollView:RemoveComponents(LWSeasonPersonalRewardItem)
  self.gridInfinityScrollViewContent:DestroyChildNodeExceptIndex(self.progressSliderInstanceId)
end

function SeasonCampDestroyAchievement:OnBtnOneGetClick()
end

function SeasonCampDestroyAchievement:GetAllBtnState()
  self.btnOneGet:SetActive(false)
end

function SeasonCampDestroyAchievement:OnBtnIntroClick()
  local mainCfg = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
  if not string.IsNullOrEmpty(mainCfg.achievements_help) then
    local param = {}
    param.activityRulesStr = Localization:GetString(mainCfg.achievements_help)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function SeasonCampDestroyAchievement:OnBtnGotoClick()
  if self.curPanelData.flag == SeasonAchivementFlag.Personal then
  elseif self.curPanelData.flag == SeasonAchivementFlag.Alliance and LuaEntry.Player:IsInAlliance() == false then
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      return
    end
    local params = {guide = false}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
  end
end

function SeasonCampDestroyAchievement:GetGotoBtnDes()
  self.btnGoto:SetActive(false)
  self.textGotoDes:SetText("")
  self.compTopArea:SetActive(true)
  self.textJoinAliHit:SetActive(false)
end

return SeasonCampDestroyAchievement
