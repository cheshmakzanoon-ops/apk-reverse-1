local UILWComicView = BaseClass("UILWComicView", UIBaseView)
local UILWComicDialogTextItem = require("UI.LWComic.Component.UILWComicDialogTextItem")
local UILWComicSpinePanel = require("UI.LWComic.Component.UILWComicSpinePanel")
local base = UIBaseView

function UILWComicView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:SetData()
end

function UILWComicView:OnDestroy()
  self:ComponentDestroy()
  self:SetAllCellDestroy()
  base.OnDestroy(self)
end

function UILWComicView:ComponentDefine()
  self.panel = self:AddComponent(UIImage, "UICommonMiniPopUpTitle/panel")
  self.bgImage = self:AddComponent(UIRawImage, "UICommonMiniPopUpTitle/BG")
  self.rawImage = self:AddComponent(UIRawImage, "UICommonMiniPopUpTitle/BG/Image")
  self.dialogContent = self:AddComponent(UIBaseContainer, "UICommonMiniPopUpTitle/BG/Image/Content")
  self.narrationText = self:AddComponent(UIText, "UICommonMiniPopUpTitle/NarrationText")
  self.skipBtn = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/SkipBtn")
  self.nextBtn = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/SwapBtn")
  self.skipBtnTxt = self:AddComponent(UIText, "UICommonMiniPopUpTitle/SkipBtn/SkipText")
  self.spinePanel = self:AddComponent(UILWComicSpinePanel, "UICommonMiniPopUpTitle/BG/SpineRoot")
  self.spinePanel:SetActive(false)
  self.skipBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
    self:PlayPlotView()
  end)
  self.nextBtn:SetOnClick(function()
    self:OnClickNextBtn()
  end)
end

function UILWComicView:ComponentDestroy()
end

function UILWComicView:OnClickNextBtn()
  if not string.IsNullOrEmpty(self.curTemplate.spine) and not self.spinePanel:IsComplete() then
    self.spinePanel:Complete()
  else
    self.curNarrationIndex = self.curNarrationIndex + 1
    if self.curNarrationIndex <= self.curNarrationCount then
      self:ShowNextNarration()
    else
      self.curIndex = self.curIndex + 1
      self:ShowNextComicId()
    end
  end
end

function UILWComicView:SetData()
  self.comicGroupId, self.forceShipPlot = self:GetUserData()
  if self.comicGroupId ~= -1 then
    self.isArchive = false
    self.comicTemplateList = DataCenter.ComicTemplateManager:GetComicIdListByGroupId(self.comicGroupId)
    if not table.IsNullOrEmpty(self.comicTemplateList) then
      DataCenter.ComicManager:OnReadOrArchiveSingleComic(self.comicTemplateList, true)
    end
  else
    self.isArchive = true
    local comicMap = DataCenter.ComicManager:GetAllReadOrArchiveSingleComic(true)
    self.comicTemplateList = {}
    table.walk(comicMap, function(k, v)
      table.insert(self.comicTemplateList, k)
    end)
    table.sort(self.comicTemplateList)
    if not table.IsNullOrEmpty(self.comicTemplateList) then
      DataCenter.ComicManager:OnReadOrArchiveSingleComic(self.comicTemplateList, false)
    end
  end
  self.curIndex = 1
  self.panel:SetActive(true)
  self.bgImage:SetActive(true)
  self.skipBtn:SetActive(true)
  self.nextBtn:SetActive(true)
  self.narrationText:SetActive(true)
  self:ShowNextComicId()
  local widthScale = self.rectTransform.rect.width / DefaultScreenWidth
  local heightScale = self.rectTransform.rect.height / DefaultScreenHeight
  local finalScale = math.min(widthScale, heightScale)
  self.bgImage:SetLocalScaleXYZ(finalScale, finalScale, finalScale)
end

function UILWComicView:ShowNextComicId()
  if not table.IsNullOrEmpty(self.comicTemplateList) and table.count(self.comicTemplateList) >= self.curIndex then
    local templateId = self.comicTemplateList[self.curIndex]
    self.curTemplate = DataCenter.ComicTemplateManager:GetTemplate(templateId)
    self.curNarrationIndex = 1
    self.curNarrationCount = table.count(self.curTemplate.asideList)
    self:SetAllCellDestroy()
    self.narrationText:SetActive(false)
    if not string.IsNullOrEmpty(self.curTemplate.video) then
      self.panel:SetActive(false)
      self.bgImage:SetActive(false)
      self.skipBtn:SetActive(false)
      self.nextBtn:SetActive(false)
      self.narrationText:SetActive(false)
      self:PlayVideo()
    elseif string.IsNullOrEmpty(self.curTemplate.spine) then
      self.rawImage:SetActive(true)
      self.spinePanel:SetActive(false)
      self.rawImage:LoadSprite(self.curTemplate.pic)
      self:ShowDialogs()
      self:ShowNextNarration()
    else
      self.rawImage:SetActive(false)
      self.spinePanel:SetData(self.curTemplate)
      if not string.IsNullOrEmpty(self.curTemplate.picPos) then
        self.spinePanel:SetAnchoredPosition(self.curTemplate.picPos)
      end
      self.spinePanel:SetActive(true)
    end
  else
    self.ctrl:CloseSelf()
    self:PlayPlotView()
  end
end

function UILWComicView:ShowNextNarration()
  if self.curTemplate then
    local asideList = self.curTemplate.asideList
    self.curNarrationCount = table.count(asideList)
    if self.curNarrationCount >= self.curNarrationIndex then
      self.narrationText:SetActive(true)
      self.narrationText:SetLocalText(asideList[self.curNarrationIndex])
    end
  end
end

function UILWComicView:SetAllCellDestroy()
  self.dialogContent:RemoveComponents(UILWComicDialogTextItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UILWComicView:ShowDialogs()
  self.model = {}
  if self.curTemplate then
    local posList = self.curTemplate.dialogLocalPos
    local dialogList = self.curTemplate.dialogList
    for k, v in ipairs(posList) do
      self.model[k] = self:GameObjectInstantiateAsync(UIAssets.UIComicsTextItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.dialogContent.transform)
        go.gameObject:SetActive(true)
        go.transform:Set_anchorMin(0, 1)
        go.transform:Set_anchorMax(0, 1)
        if self.curTemplate.id == 1004 then
          go.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform)):Set_sizeDelta(100, 65)
        end
        go.transform:Set_anchoredPosition(posList[k].x * self.rawImage.rectTransform.rect.width / 752.4, -posList[k].y * self.rawImage.rectTransform.rect.height / 1157)
        go.name = tostring(k)
        local cell = self.dialogContent:AddComponent(UILWComicDialogTextItem, go.name)
        cell:SetData(dialogList[k])
      end)
    end
  end
end

function UILWComicView:PlayVideo()
  local isLast = self.curIndex >= table.count(self.comicTemplateList)
  local params = {
    path = self.curTemplate.video,
    subtitles = self.curTemplate.subtitles,
    audioId = self.curTemplate.audio,
    subtitleBgAlpha = 0.78,
    defaultShowSkip = false,
    onVideoCloseCallback = function(isSkip)
      if isSkip or isLast then
        self.ctrl:CloseSelf()
        self:PlayPlotView()
      else
        self.panel:SetActive(true)
        self.bgImage:SetActive(true)
        self.skipBtn:SetActive(true)
        self.nextBtn:SetActive(true)
        self.curIndex = self.curIndex + 1
        self:ShowNextComicId()
      end
    end
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.FullScreenVideoView, {anim = false}, params)
end

function UILWComicView:PlayPlotView()
  if self.forceShipPlot then
    self.forceShipPlot = nil
    return
  end
  if self.comicGroupId ~= -1 then
    local templateGroup = DataCenter.ComicTemplateManager:GetGroupTemplate(self.comicGroupId)
    if templateGroup and templateGroup.plot_id > 0 then
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
        plotGroupId = templateGroup.plot_id,
        hideMainUI = true
      })
    end
  end
end

return UILWComicView
