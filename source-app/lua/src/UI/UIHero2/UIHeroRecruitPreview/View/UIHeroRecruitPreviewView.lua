local UIHeroRecruitPreviewView = BaseClass("UIHeroRecruitPreviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local UIHeroRecruitPreviewTabComponent = require("UI/UIHero2/UIHeroRecruitPreview/Component/UIHeroRecruitPreviewTabComponent")
local PreviewComponent = require("UI/UIHero2/UIHeroRecruit/Component/Preview/UIHeroRecruitPreviewComponent")
local MyModf = math.modf
local MyFloor = math.floor
local MyStrFormat = string.format
local MyDate = os.date
local ResourceManager = CS.GameEntry.Resource
UIHeroRecruitPreviewView.SkillShowType = {Max = 1, Init = 2}

function UIHeroRecruitPreviewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
  self.isClosing = false
end

function UIHeroRecruitPreviewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroRecruitPreviewView:ComponentDefine()
  self.anim = self:AddComponent(UIAnimator, "")
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compSpineRoot = self:AddComponent(UIBaseContainer, "MainContent/SpineRoot")
  self.textTitle = self:AddComponent(UIText, "MainContent/TitleText")
  self.textTitle:SetLocalText("herorecruit_preview_title1")
  self.btnClose = self:AddComponent(UIButton, "MainContent/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.imgQualityIcon = self:AddComponent(UIImage, "MainContent/InfoContent/QualityIcon")
  self.textName = self:AddComponent(UIText, "MainContent/InfoContent/NameText")
  self.imgHeroTypeIcon = self:AddComponent(UIImage, "MainContent/InfoContent/HeroTypeIcon")
  self.btnHeroTypeIcon = self:AddComponent(UIButton, "MainContent/InfoContent/HeroTypeIcon")
  self.btnHeroTypeIcon:SetOnClick(function()
    self:OnBtnHeroTypeIconClick()
  end)
  self.imgHeroJobIcon = self:AddComponent(UIImage, "MainContent/InfoContent/HeroJobIcon")
  self.btnHeroJobIcon = self:AddComponent(UIButton, "MainContent/InfoContent/HeroJobIcon")
  self.btnHeroJobIcon:SetOnClick(function()
    self:OnBtnHeroJobIconClick()
  end)
  self.textDes = self:AddComponent(UIText, "MainContent/DesText")
  self.compUIHeroSkillItem1 = self:AddComponent(UIHeroSkillItem, "MainContent/SkillContent/Content/UIHeroSkillItem1")
  self.compUIHeroSkillItem2 = self:AddComponent(UIHeroSkillItem, "MainContent/SkillContent/Content/UIHeroSkillItem2")
  self.compUIHeroSkillItem3 = self:AddComponent(UIHeroSkillItem, "MainContent/SkillContent/Content/UIHeroSkillItem3")
  self.compUIHeroSkillItem4 = self:AddComponent(UIHeroSkillItem, "MainContent/SkillContent/Content/UIHeroSkillItem4")
  self.compSkills = {
    self.compUIHeroSkillItem1,
    self.compUIHeroSkillItem2,
    self.compUIHeroSkillItem3,
    self.compUIHeroSkillItem4
  }
  self.textTips = self:AddComponent(UIText, "MainContent/TipsText")
  self.compPreviewWindowItem = self:AddComponent(UIHeroRecruitPreviewTabComponent, "previewWindowItem")
  self.compTime = self:AddComponent(UIBaseContainer, "TimeGroup")
  self.textDay = self:AddComponent(UIText, "TimeGroup/DiDay/DayText")
  self.textHour = self:AddComponent(UIText, "TimeGroup/DiHour/HourText")
  self.textMin = self:AddComponent(UIText, "TimeGroup/DiMin/MinText")
  self.textSec = self:AddComponent(UIText, "TimeGroup/DiSec/SecText")
  self.scrollRectToggleScroll = self:AddComponent(UILoopListView2, "ToggleScroll")
  self.scrollRectToggleScroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.compToggleContent = self:AddComponent(UIBaseContainer, "ToggleScroll/ToggleViewport/ToggleContent")
  self.compExtraClose = self:AddComponent(UIBaseContainer, "ExtraClose")
  self.btnExtraClose1 = self:AddComponent(UIButton, "ExtraClose/ExtraClose1")
  self.btnExtraClose1:SetOnClick(function()
    self:OnBtnExtraCloseClick()
  end)
  self.btnExtraClose2 = self:AddComponent(UIButton, "ExtraClose/ExtraClose2")
  self.btnExtraClose2:SetOnClick(function()
    self:OnBtnExtraCloseClick()
  end)
  self.textSkill = self:AddComponent(UIText, "MainContent/SkillContent/SkillText")
  self.btnSkill = self:AddComponent(UIButton, "MainContent/SkillContent/SkillBtn")
  self.btnSkill:SetOnClick(function()
    self:OnBtnSkillClick()
  end)
end

function UIHeroRecruitPreviewView:ComponentDestroy()
  self:ClearTabs()
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self.anim = nil
  self.btnPanel = nil
  self.compSpineRoot = nil
  self.textTitle = nil
  self.btnClose = nil
  self.imgQualityIcon = nil
  self.textName = nil
  self.imgHeroTypeIcon = nil
  self.btnHeroTypeIcon = nil
  self.imgHeroJobIcon = nil
  self.btnHeroJobIcon = nil
  self.textDes = nil
  self.compUIHeroSkillItem1 = nil
  self.compUIHeroSkillItem2 = nil
  self.compUIHeroSkillItem3 = nil
  self.compUIHeroSkillItem4 = nil
  self.textTips = nil
  self.compPreviewWindowItem = nil
  self.compTime = nil
  self.textDay = nil
  self.textHour = nil
  self.textMin = nil
  self.textSec = nil
  self.scrollRectToggleScroll = nil
  self.compToggleContent = nil
  self.compExtraClose = nil
  self.btnExtraClose1 = nil
  self.btnExtraClose2 = nil
  self.textSkill = nil
  self.btnSkill = nil
end

function UIHeroRecruitPreviewView:DataDefine()
  self.clickSkillCallBack = BindCallback(self, self.OnClickSkillItem)
  self.itemIndex = 0
  self.skillShowType = self.SkillShowType.Max
end

function UIHeroRecruitPreviewView:DataDestroy()
  self.clickSkillCallBack = nil
  if self.closeTimer ~= nil then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UIHeroRecruitPreviewView:OnAddListener()
  base.OnAddListener(self)
end

function UIHeroRecruitPreviewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIHeroRecruitPreviewView:OnOpen()
  self.param = self:GetUserData()
  local curIndex = 1
  if self.param.index ~= nil then
    curIndex = self.param.index
  end
  self.ctrl:SetCurIndex(curIndex)
  self:ClearTabs()
  self.scrollRectToggleScroll:SetListItemCount(#self.param.infoList, false, false)
  self.scrollRectToggleScroll:RefreshAllShownItem()
  self.compExtraClose:SetActive(#self.param.infoList == 1)
  self:UpdateTabFocus()
  self:UpdateContent()
  local curShowHeroInfo = self:GetCurShowHeroInfo()
  if curShowHeroInfo then
    if curShowHeroInfo.type == PreviewComponent.Type.CurNew then
      if curShowHeroInfo.lotteryId then
        PostEventLog.Track(PostEventLog.Defines.HeroRecruitPreviewOpenNew, {
          lotteryId = curShowHeroInfo.lotteryId,
          heroId = curShowHeroInfo.heroId
        })
      end
    elseif curShowHeroInfo.type == PreviewComponent.Type.NextPreview and curShowHeroInfo.lotteryId then
      PostEventLog.Track(PostEventLog.Defines.HeroRecruitPreviewOpenPreview, {
        lotteryId = curShowHeroInfo.lotteryId,
        heroId = curShowHeroInfo.heroId
      })
    end
  end
  local ret, time = self.anim:PlayAnimationReturnTime("Eff_UIHeroRecruitPreview_in")
  if ret then
    self.delayTimer = TimerManager:GetInstance():GetTimer(time, function()
      if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
      end
      if self.anim then
        self.anim:Play("Eff_UIHeroRecruitPreview_Loop")
      end
    end, self, true, false, false)
    self.delayTimer:Start()
  else
    self.anim:Play("Eff_UIHeroRecruitPreview_Loop")
  end
end

function UIHeroRecruitPreviewView:GetMaxSkillHeroData(heroId)
  if self.heroDataDictMax == nil then
    self.heroDataDictMax = {}
  end
  if self.heroDataDictMax[heroId] == nil then
    local heroData = HeroInfo.New()
    heroData:UpdateFromTemplate(tonumber(heroId), IntMaxValue, IntMaxValue, IntMaxValue)
    self.heroDataDictMax[heroId] = heroData
  end
  return self.heroDataDictMax[heroId]
end

function UIHeroRecruitPreviewView:GetInitSkillHeroData(heroId)
  if self.heroDataDictInit == nil then
    self.heroDataDictInit = {}
  end
  if self.heroDataDictInit[heroId] == nil then
    local heroData = HeroInfo.New()
    heroData:UpdateFromTemplate(tonumber(heroId), 1)
    self.heroDataDictInit[heroId] = heroData
  end
  return self.heroDataDictInit[heroId]
end

function UIHeroRecruitPreviewView:UpdateSkill()
  local info = self:GetCurShowHeroInfo()
  if not info then
    return
  end
  local heroId = info.heroId
  if not heroId then
    return
  end
  if self.skillShowType == self.SkillShowType.Max then
    self.textSkill:SetLocalText("herorecruit_preview_desc4")
    local heroData = self:GetMaxSkillHeroData(heroId)
    for i = 1, 4 do
      local skillData = heroData:GetHeroSkillBySlotIndex(i)
      local unlockLevel = 0
      if skillData then
        self.compSkills[i]:SetData(skillData, {
          showSkillName = false,
          showSkillLevel = true,
          showLock = false,
          showRedPoint = false,
          showStar = true,
          unlockLevel = unlockLevel
        }, self.clickSkillCallBack)
      end
    end
  else
    self.textSkill:SetLocalText("herorecruit_preview_desc3")
    local heroData = self:GetInitSkillHeroData(heroId)
    for i = 1, 4 do
      local skillData = heroData:GetHeroSkillBySlotIndex(i)
      local unlockLevel = 0
      if skillData then
        self.compSkills[i]:SetData(skillData, {
          showSkillName = false,
          showSkillLevel = true,
          showLock = true,
          showRedPoint = false,
          showStar = true,
          unlockLevel = unlockLevel
        }, self.clickSkillCallBack)
      end
    end
  end
end

function UIHeroRecruitPreviewView:UpdateContent()
  local info = self:GetCurShowHeroInfo()
  if not info then
    return
  end
  self:UpdateTimeShow()
  local heroId = info.heroId
  if not heroId then
    return
  end
  if info.type == PreviewComponent.Type.CurNew then
    self.textTips:SetLocalText("herorecruit_preview_desc2")
    self.textTitle:SetLocalText("herorecruit_preview_title1")
    if info.lotteryId then
      DataCenter.LotteryDataManager:SetHasShownNewHeroNewTag(info.lotteryId, heroId)
      EventManager:GetInstance():Broadcast(EventId.HeroLotteryPreviewEntranceUpdate)
    end
    DataCenter.LotteryDataManager:SetHasShownCurLotteryNewHeroIdList(heroId)
  elseif info.type == PreviewComponent.Type.NextPreview then
    self.textTips:SetLocalText("herorecruit_preview_desc1")
    self.textTitle:SetLocalText("herorecruit_preview_title2")
  end
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if heroTemplate then
    local quality = heroTemplate.quality
    self.imgQualityIcon:LoadSprite(HeroUtils.GetHeroQualityTagImg(quality))
    self.imgQualityIcon:SetNativeSize()
    local heroName = Localization:GetString(heroTemplate.name)
    self.textName:SetText(heroName)
    self.textDes:SetText(heroTemplate:GetDescription())
    self.imgHeroTypeIcon:LoadSprite(HeroUtils.GetHeroTypeIcon(heroTemplate.type))
    self.imgHeroTypeIcon:SetNativeSize()
    self.imgHeroJobIcon:LoadSprite(HeroUtils.GetHeroJobIcon(heroTemplate.job, 2))
    local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(heroTemplate.appearance)
    local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
    local request = ResourceManager:InstantiateAsync(spinePath)
    self.heroSpineLoadRequest = request
    request:completed("+", function()
      if request.isError or IsNull(request.gameObject) then
        request:Destroy()
        self.heroSpineLoadRequest = nil
        return
      end
      local obj = request.gameObject
      obj:SetActive(true)
      obj.transform:SetParent(self.compSpineRoot.transform)
      obj.transform.localPosition = Vector3.New(0, 0, 0)
      obj.transform.localScale = Vector3.New(1, 1, 1)
    end)
    self:UpdateSkill()
  end
end

function UIHeroRecruitPreviewView:GetCurShowHeroInfo()
  if self.param and self.param.infoList then
    local index = self.ctrl:GetCurIndex()
    if index then
      return self.param.infoList[index]
    end
  end
end

function UIHeroRecruitPreviewView:GetCurShowHeroId()
  local info = self:GetCurShowHeroInfo()
  if info then
    return info.heroId
  end
end

function UIHeroRecruitPreviewView:Update1000MS()
  self:UpdateTimeShow()
end

function UIHeroRecruitPreviewView:UpdateTimeShow()
  local info = self:GetCurShowHeroInfo()
  if info == nil or info.startTime == nil then
    self.compTime:SetActive(false)
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = info.startTime / 1000 - curSec
  if remainTime <= 0 then
    self.compTime:SetActive(false)
    return
  end
  self.compTime:SetActive(true)
  local day = MyModf(remainTime / OneDayTime)
  self.textDay:SetText(MyStrFormat("%dd", day))
  local hour = MyModf(remainTime / 3600) % 24
  self.textHour:SetText(MyStrFormat("%02d", hour))
  local minute = MyModf(remainTime / 60) % 60
  self.textMin:SetText(MyStrFormat("%02d", minute))
  local second = MyFloor(remainTime % 60)
  self.textSec:SetText(MyStrFormat("%02d", second))
end

function UIHeroRecruitPreviewView:UpdateTabFocus()
  local curIndex = self.ctrl:GetCurIndex()
  if curIndex then
    local index = curIndex - 1
    local offset = 0
    offset = offset + 270 * index
    self.scrollRectToggleScroll:ResetListView()
    self.scrollRectToggleScroll:MovePanelToItemIndex(index, -offset)
  end
end

function UIHeroRecruitPreviewView:ClearTabs()
  self.compToggleContent:RemoveComponents(UIHeroRecruitPreviewTabComponent)
  self.scrollRectToggleScroll:ClearAllItems()
end

function UIHeroRecruitPreviewView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.param.infoList then
    return nil
  end
  local info = self.param.infoList[index]
  local item = loopScroll:NewListViewItem("previewWindowItem")
  local script = self.compToggleContent:GetComponent(item.gameObject.name, UIHeroRecruitPreviewTabComponent)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.compToggleContent:AddComponent(UIHeroRecruitPreviewTabComponent, objectName)
  end
  script:SetActive(true)
  script:ReInit(info, index, function()
    self.ctrl:SetCurIndex(index)
    self:UpdateContent()
    self.scrollRectToggleScroll:RefreshAllShownItem()
  end)
  return item
end

function UIHeroRecruitPreviewView:Close()
  if self.isClosing then
    return
  end
  self.isClosing = true
  local ret, time = self.anim:PlayAnimationReturnTime("UIHeroRecruitPreview_out")
  if ret then
    self.closeTimer = TimerManager:GetInstance():GetTimer(time, function()
      if self.closeTimer ~= nil then
        self.closeTimer:Stop()
        self.closeTimer = nil
      end
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
    end, self, true, false, false)
    self.closeTimer:Start()
  elseif self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UIHeroRecruitPreviewView:OnBtnPanelClick()
  self:Close()
end

function UIHeroRecruitPreviewView:OnBtnCloseClick()
  self:Close()
end

function UIHeroRecruitPreviewView:OnBtnHeroTypeIconClick()
  local heroId = self:GetCurShowHeroId()
  if not heroId then
    return
  end
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if heroTemplate then
    local pos = self.imgHeroTypeIcon.transform.position
    local tip = HeroUtils.GetHeroTipInfoTextByType(heroTemplate.type)
    local text = Localization:GetString("129213", Localization:GetString(tip))
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroArmyJobTip, {anim = true}, pos, text)
  end
end

function UIHeroRecruitPreviewView:OnBtnHeroJobIconClick()
  local heroId = self:GetCurShowHeroId()
  if not heroId then
    return
  end
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if heroTemplate then
    local pos = self.imgHeroJobIcon.transform.position
    local tip = HeroUtils.GetHeroTipInfoTextByJob(heroTemplate.job)
    local text = Localization:GetString(tip)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroArmyJobTip, {anim = true}, pos, text)
  end
end

function UIHeroRecruitPreviewView:OnClickSkillItem(skillData, skillItem)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillDetailPanel, {anim = true}, skillData, skillItem)
end

function UIHeroRecruitPreviewView:OnBtnExtraCloseClick()
  self:Close()
end

function UIHeroRecruitPreviewView:OnBtnSkillClick()
  if self.skillShowType == self.SkillShowType.Max then
    self.skillShowType = self.SkillShowType.Init
  else
    self.skillShowType = self.SkillShowType.Max
  end
  self:UpdateSkill()
end

return UIHeroRecruitPreviewView
