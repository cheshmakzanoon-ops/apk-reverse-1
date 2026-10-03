local base = UIBaseContainer
local ChapterContentComponent = BaseClass("ChapterContentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UILWChapterStageSkyBattleItem = require("UI.UILWStageSkyBattleChapter.Components.UILWChapterStageSkyBattleItem")
local UILWSkyBattleChapterRewardItem = require("UI.UILWStageSkyBattleChapter.Components.UILWSkyBattleChapterRewardItem")
local UILWSkyBattleBoxTip = require("UI.UILWStageSkyBattleChapter.Components.UILWSkyBattleBoxTip")
local UILWSkyBattleGoFightView = require("UI.UILWStageSkyBattleChapter.Components.UILWSkyBattleGoFightView")

function ChapterContentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function ChapterContentComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChapterContentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textChapterTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compStageItem6 = self.viewSkin:AddComponent(self, UILWChapterStageSkyBattleItem, 2)
  self.compStageItem5 = self.viewSkin:AddComponent(self, UILWChapterStageSkyBattleItem, 3)
  self.compStageItem4 = self.viewSkin:AddComponent(self, UILWChapterStageSkyBattleItem, 4)
  self.compStageItem3 = self.viewSkin:AddComponent(self, UILWChapterStageSkyBattleItem, 5)
  self.compStageItem2 = self.viewSkin:AddComponent(self, UILWChapterStageSkyBattleItem, 6)
  self.compStageItem1 = self.viewSkin:AddComponent(self, UILWChapterStageSkyBattleItem, 7)
  self.btnNext = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnNext:SetOnClick(function()
    self:OnBtnNextClick()
  end)
  self.btnPrevious = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnPrevious:SetOnClick(function()
    self:OnBtnPreviousClick()
  end)
  self.compRewardGroup = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.textProgressCurStarTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textProgressMaxStarTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.sliderRewardProgress = self.viewSkin:AddComponent(self, UISlider, 13)
  self.compRewardItem1 = self.viewSkin:AddComponent(self, UILWSkyBattleChapterRewardItem, 14)
  self.compRewardItem2 = self.viewSkin:AddComponent(self, UILWSkyBattleChapterRewardItem, 15)
  self.compRewardItem3 = self.viewSkin:AddComponent(self, UILWSkyBattleChapterRewardItem, 16)
  self.compRewardTip = self.viewSkin:AddComponent(self, UILWSkyBattleBoxTip, 17)
  self.compSkyBattleGoFight = self.viewSkin:AddComponent(self, UILWSkyBattleGoFightView, 18)
  self.imgPrePage = self.viewSkin:AddComponent(self, UIImage, 19)
  self.imgNextPage = self.viewSkin:AddComponent(self, UIImage, 20)
  self.imgCurPage = self.viewSkin:AddComponent(self, UIImage, 21)
  self.btnNext:SetActive(false)
  self.btnPrevious:SetActive(false)
  self.compRewardGroup:SetActive(false)
  self.compRewardTip:SetActive(false)
  self.compSkyBattleGoFight:SetActive(false)
  self.compStageItem6:SetActive(false)
  self.compStageItem5:SetActive(false)
  self.compStageItem4:SetActive(false)
  self.compStageItem3:SetActive(false)
  self.compStageItem2:SetActive(false)
  self.compStageItem1:SetActive(false)
end

function ChapterContentComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textChapterTitle = nil
  self.compStageItem6 = nil
  self.compStageItem5 = nil
  self.compStageItem4 = nil
  self.compStageItem3 = nil
  self.compStageItem2 = nil
  self.compStageItem1 = nil
  self.btnNext = nil
  self.btnPrevious = nil
  self.compRewardGroup = nil
  self.textProgressCurStarTitle = nil
  self.textProgressMaxStarTitle = nil
  self.sliderRewardProgress = nil
  self.compRewardItem1 = nil
  self.compRewardItem2 = nil
  self.compRewardItem3 = nil
  self.compRewardTip = nil
  self.compSkyBattleGoFight = nil
  self.imgPrePage = nil
  self.imgNextPage = nil
  self.imgCurPage = nil
end

function ChapterContentComponent:DataDefine()
  self.curChapterStarNum = 0
end

function ChapterContentComponent:DataDestroy()
  self.curChapterStarNum = 0
  self.chapterCfg = nil
end

function ChapterContentComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkyBattleChapterRewardBoxUpdate, self.OnBoxRewardUpdate)
  self:AddUIListener(EventId.SkyBattleChapterMsgInit, self.RefreshChapterContent)
  self:AddUIListener(EventId.SkyBattleChapterRefresh, self.RefreshTargetChapter)
end

function ChapterContentComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.SkyBattleChapterRewardBoxUpdate, self.OnBoxRewardUpdate)
  self:RemoveUIListener(EventId.SkyBattleChapterMsgInit, self.RefreshChapterContent)
  self:RemoveUIListener(EventId.SkyBattleChapterRefresh, self.RefreshTargetChapter)
  base.OnRemoveListener(self)
end

function ChapterContentComponent:Init()
  self.growthMode = self.view.growthMode
end

function ChapterContentComponent:OnEnable()
  base.OnEnable(self)
end

function ChapterContentComponent:RefreshChapterContent()
  self.growthMode = self.view.growthMode
  local mgr = self.growthMode and DataCenter.LWSkyBattleGrowthChapterManager or DataCenter.LWSkyBattleChapterManager
  if not mgr:ChapterInited() then
    return
  end
  local curShowChapterCfg = self.chapterCfg or mgr.chapterCfg
  local lastPlayChapterId = mgr:GetCurPlayChapterId()
  if lastPlayChapterId then
    local lastPlayChapter = mgr:GetChapterCfgData(lastPlayChapterId)
    if lastPlayChapter then
      curShowChapterCfg = lastPlayChapter
    end
  end
  self:RefreshChapter(curShowChapterCfg)
end

function ChapterContentComponent:RefreshTargetChapter(refreshedChapterId)
  if not refreshedChapterId then
    return
  end
  local mgr = self.growthMode and DataCenter.LWSkyBattleGrowthChapterManager or DataCenter.LWSkyBattleChapterManager
  if not mgr:ChapterInited() then
    return
  end
  local curShowChapterCfg = self.chapterCfg or mgr.chapterCfg
  if refreshedChapterId ~= curShowChapterCfg.id then
    return
  end
  self:RefreshChapter(curShowChapterCfg)
end

function ChapterContentComponent:RefreshChapter(chapterCfg)
  if not chapterCfg then
    return
  end
  self.compSkyBattleGoFight:SetActive(false)
  self.btnNext:SetActive(true)
  self.btnPrevious:SetActive(true)
  self.compRewardGroup:SetActive(true)
  self.chapterCfg = chapterCfg
  local titleAnchorPosY = -159.95
  if self.growthMode then
    titleAnchorPosY = -159.95
  else
    titleAnchorPosY = -119.3
  end
  self.textChapterTitle:SetAnchoredPositionXY(-365, titleAnchorPosY)
  local titleKey = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER, chapterCfg.id, "title")
  self.textChapterTitle:SetText(string.format("<size=48>%s</size>", Localization:GetString("plane_chapter_01", chapterCfg.id)))
  local mgr = self.growthMode and DataCenter.LWSkyBattleGrowthChapterManager or DataCenter.LWSkyBattleChapterManager
  local index = table.indexof(mgr.chapterCfgs, chapterCfg)
  self.btnPrevious.gameObject:SetActive(1 < index)
  self.imgPrePage:SetActive(1 < index)
  self.imgNextPage:SetActive(index < #mgr.chapterCfgs)
  local showGuide = self.showGuide
  self.showGuide = false
  for i = 1, 6 do
    local stageItem = self["compStageItem" .. i]
    local stageId = chapterCfg.stageIds[i]
    if stageId then
      stageItem:SetActive(true)
      stageItem:Refresh(chapterCfg.id, stageId, self.growthMode)
      stageItem:SetOnClick(function()
        self:OnClickStageItem(stageItem, stageId, chapterCfg.nodeTipStyleArr[i])
      end)
      if showGuide and mgr.nextStageId == stageId then
        local param = {}
        param.position = stageItem.transform.position
        param.arrowType = ArrowType.Normal
        param.positionType = PositionType.Screen
        DataCenter.ArrowManager:ShowArrow(param)
      end
    else
      stageItem:SetActive(false)
    end
  end
  local stageExtraInfos = self.chapterCfg.stageExtraInfos
  local starNum = 0
  for i, stageExtraInfo in ipairs(stageExtraInfos) do
    starNum = starNum + stageExtraInfo.star
  end
  self.curChapterStarNum = starNum
  self.textProgressCurStarTitle:SetText(self.curChapterStarNum)
  self.textProgressMaxStarTitle:SetText(string.format("%d", #self.chapterCfg.stageIds * 3))
  self:RefreshRewardBox(chapterCfg)
  self.view:ChangeChapterBg(chapterCfg.chapterBgImg or self:GetChapterBg(tonumber(chapterCfg.id)))
end

function ChapterContentComponent:OnClickStageItem(stageItem, stageId, tipStyle)
  local mgr = self.growthMode and DataCenter.LWSkyBattleGrowthChapterManager or DataCenter.LWSkyBattleChapterManager
  local isNext = mgr.nextStageId == stageId
  if isNext or mgr.doneStageIds[stageId] then
    self.compSkyBattleGoFight:SetActive(true)
    local showReward = self.growthMode
    self.compSkyBattleGoFight:ReInit(stageId, showReward, self.growthMode)
    self.compSkyBattleGoFight:SetOnEnterClick(function(id)
      self:OnClickEnterStage(id)
    end)
  else
    self.compSkyBattleGoFight:SetActive(false)
  end
end

function ChapterContentComponent:OnBtnNextClick()
  self:OnClickNextChapter()
end

function ChapterContentComponent:OnBtnPreviousClick()
  self:OnClickPrevChapter()
end

function ChapterContentComponent:OnClickNextChapter()
  local mgr = self.growthMode and DataCenter.LWSkyBattleGrowthChapterManager or DataCenter.LWSkyBattleChapterManager
  local index = table.indexof(mgr.chapterCfgs, self.chapterCfg)
  if not index then
    return
  end
  index = index + 1
  local nextChapterCfg = mgr.chapterCfgs[index]
  if nextChapterCfg then
    self:RefreshChapter(mgr.chapterCfgs[index])
  else
    UIUtil.ShowTipsId(302109)
  end
  mgr:SetCurPlayChapterId(nil)
end

function ChapterContentComponent:OnClickPrevChapter()
  local mgr = self.growthMode and DataCenter.LWSkyBattleGrowthChapterManager or DataCenter.LWSkyBattleChapterManager
  local index = table.indexof(mgr.chapterCfgs, self.chapterCfg) - 1
  self:RefreshChapter(mgr.chapterCfgs[index])
  mgr:SetCurPlayChapterId(nil)
end

function ChapterContentComponent:RefreshCurChapterStages(refreshedChapterId)
  if not self.chapterCfg or self.chapterCfg.id ~= refreshedChapterId then
    return
  end
  self:RefreshChapter(self.chapterCfg)
end

function ChapterContentComponent:OnClickEnterStage(stageId)
  local mgr = self.growthMode and DataCenter.LWSkyBattleGrowthChapterManager or DataCenter.LWSkyBattleChapterManager
  local matchEnterCondition = mgr:CheckChapterStageMatchEnterCondition(self.chapterCfg.id, stageId, false)
  if not matchEnterCondition then
    return
  end
  self.compSkyBattleGoFight:SetActive(false)
  mgr:EnterChapterStage(self.chapterCfg.id, stageId)
end

function ChapterContentComponent:OnBoxRewardUpdate(chapterId)
  if not self.chapterCfg or self.chapterCfg.id ~= chapterId then
    return
  end
  self:RefreshRewardBox(self.chapterCfg)
end

function ChapterContentComponent:RefreshRewardBox(chapterCfg)
  if chapterCfg ~= nil then
    self.sliderRewardProgress:SetValue(self.curChapterStarNum / (#chapterCfg.stageIds * 3))
    for i = 1, 3 do
      local boxItem = self["compRewardItem" .. i]
      local boxData = chapterCfg.boxDatas[i]
      boxItem:Refresh(boxData, self.curChapterStarNum >= boxData.TargetCompleteNum)
      local boxIndex = i
      boxItem:SetOnClick(function()
        self:OnClickRewardBox(boxIndex)
      end)
    end
  end
end

function ChapterContentComponent:OnClickRewardBox(index)
  if not self.chapterCfg then
    return
  end
  local boxDatas = self.chapterCfg.boxDatas
  local boxData = boxDatas[index]
  if boxData then
    if not boxData.Got and boxData.TargetCompleteNum <= self.curChapterStarNum then
      SFSNetwork.SendMessage(MsgDefines.LwSkyBattleChapterBoxReward, tonumber(self.chapterCfg.id), self.growthMode and 1 or 0)
    elseif not boxData.Got then
      local param = UILWSkyBattleBoxTip.ParamDataClass.New()
      param.index = index or 1
      param.rewardList = DataCenter.RewardTemplateManager:GetList(boxData.RewardId) or {}
      param.growthMode = self.growthMode
      self.compRewardTip:SetData(param)
      self.compRewardTip:Show()
    end
  end
end

function ChapterContentComponent:GetChapterBg(chapter)
  if chapter == 1 then
    return "Assets/Main/TextureEx/LWUIStageSkyBattleChapter/FX_feiji_BG01_banner.png"
  elseif chapter == 2 then
    return "Assets/Main/TextureEx/LWUIStageSkyBattleChapter/FX_feiji_BG02_banner.png"
  elseif chapter == 3 then
    return "Assets/Main/TextureEx/LWUIStageSkyBattleChapter/FX_feiji_BG03_banner.png"
  elseif chapter == 4 then
    return "Assets/Main/TextureEx/LWUIStageSkyBattleChapter/FX_feiji_BG04_banner.png"
  else
    return "Assets/Main/TextureEx/LWUIStageSkyBattleChapter/FX_feiji_BG01_banner.png"
  end
end

return ChapterContentComponent
