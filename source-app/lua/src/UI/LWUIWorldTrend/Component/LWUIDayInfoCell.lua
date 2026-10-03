local LWUIDayInfoCell = BaseClass("LWUIDayInfoCell", UIBaseContainer)
local ResourceManager = CS.GameEntry.Resource
local greyBgPath = "Assets/Main/Sprites/UI/LWWorldTrend/lrb_tianxiadashi_feidangtian_bannerbg.png"
local normalBgPath = "Assets/Main/Sprites/UI/LWWorldTrend/lrb_tianxiadashi_dangtian_bannerbg.png"
local base = UIBaseContainer
local top_btn_cell_path = "TopBtnCell"
local str = "<color=%s>%s</color>"
local localGrayColor = Color.New(0.12549019607843137, 0.12941176470588237, 0.1607843137254902, 255)
local localGreenColor = Color.New(0.37254901960784315, 0.9372549019607843, 0.5294117647058824, 255)

function LWUIDayInfoCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUIDayInfoCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIDayInfoCell:ComponentDefine()
  self.openImg = self:AddComponent(UIImage, "ImageOpen")
  self.closeImg = self:AddComponent(UIImage, "BG/ImageClose")
  self.titleText = self:AddComponent(UIText, "BG/title")
  self.TimeBgImage = self:AddComponent(UIImage, "BG/ImageTimeBg")
  self.infoText = self:AddComponent(UIText, "BG/info")
  self.timeText = self:AddComponent(UIText, "bottom/timeInfo/TimeBg/Time")
  self.goBtn = self:AddComponent(UIButton, "bottom/goBtn")
  self.bgImg = self:AddComponent(UIRawImage, "BG")
  self.dayCountText = self:AddComponent(UIText, "BG/ImageTimeBg/dayCount")
  self.dayText = self:AddComponent(UIText, "BG/ImageTimeBg/dayCount/text")
  self.timeIcon = self:AddComponent(UIImage, "bottom/timeInfo/TimeIconBg/TimeIcon")
  self.timeInfo = self:AddComponent(UIBaseContainer, "bottom/timeInfo")
  self.heroSpineRoot = self:AddComponent(UIBaseContainer, "BG/heroSpineRoot")
  self.ImageSeason = self:AddComponent(UIImage, "BG/ImageTimeBg/ImageSeason")
  self.BgLoading = self:AddComponent(UIImage, "BG/Loading")
  self.goBtn:SetOnClick(function()
    self:OnGoBtnClick()
  end)
  
  function self.timerAction()
    self:OnTimer()
  end
end

function LWUIDayInfoCell:OnGoBtnClick()
  if not LuaEntry.Player:AtHomeNow() and self.param.cross_server == 1 then
    UIUtil.ShowTipsId("server_tips_002")
  else
    GoToUtil.GoToWindow(self.param.jumpType, self.param.jumpParal, nil, self.param.activityId)
  end
end

function LWUIDayInfoCell:ComponentDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self.titleText = nil
  self.infoText = nil
  self.timeText = nil
  self.goBtn = nil
  self.ImageSeason = nil
  self.bgImg = nil
  self.dayCountText = nil
  self.dayText = nil
  self.timeIcon = nil
  self.timeInfo = nil
  self.heroImg = nil
  self.openImg = nil
  self.closeImg = nil
  self.TimeBgImage = nil
end

function LWUIDayInfoCell:OnTimer()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = self.endTime - curTime
  if 0 < time then
    self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
  else
    self.timer:Stop()
    self.timer = nil
    self:ReshfTime()
  end
end

function LWUIDayInfoCell:DataDestroy()
  self.param = nil
end

function LWUIDayInfoCell:RefreshGoToBtn()
end

function LWUIDayInfoCell:ReInit(param, index)
  self.param = param
  self.titleText:SetText(self.param:GetName())
  self.infoText:SetText(self.param:GetDes())
  local imgPath = self.param:GetPath()
  if not string.endswith(imgPath, ".png") then
    imgPath = imgPath .. ".png"
  end
  local hasAsset = UIUtil.CheckAssetDownloaded(imgPath)
  self.BgLoading:SetActive(not hasAsset)
  if hasAsset then
    self.bgImg:LoadSprite(imgPath)
  else
    self.bgImg:LoadSpriteAsyncWithCallback(self.param:GetPath(), function(texture)
      if self and self.BgLoading then
        self.BgLoading:SetActive(false)
      end
    end)
  end
  local text
  if self.param.startDay < 10 then
    text = "0" .. self.param.startDay
  else
    text = self.param.startDay
  end
  self.dayCountText:SetText(text)
  self:LoadHeroSpine()
  self:ReshfTime()
end

function LWUIDayInfoCell:LoadHeroSpine()
  local spinePath = self.param:GetHeroSpinePath()
  if spinePath and not string.IsNullOrEmpty(spinePath) then
    self.heroSpineRoot:SetActive(true)
    local request = ResourceManager:InstantiateAsync(spinePath)
    self.heroSpineLoadRequest = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.heroSpineLoadRequest = nil
        return
      end
      request.gameObject:SetActive(true)
      local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
      if rectTransform ~= nil then
        rectTransform:SetParent(self.heroSpineRoot.transform)
        rectTransform:Set_localScale(0.4, 0.4, 0.4)
        rectTransform:Set_anchoredPosition(-50, 90, 0)
      end
    end)
  else
    self.heroSpineRoot:SetActive(false)
  end
end

function LWUIDayInfoCell:ReshfTime()
  local startTime = self.param:GetStartTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = startTime - curTime
  self.endTime = self.param:GetEndTime()
  if self.param.event_type == 4 then
    self.ImageSeason:SetActive(true)
    self.ImageSeason:LoadSprite("Assets/Main/Sprites/UI/LWWorldTrend/cfm_tianxiadashi_S" .. self.param.seasonId .. ".png")
    self.ImageSeason:SetNativeSize()
  else
    self.ImageSeason:SetActive(false)
  end
  if self.param.event_type == 4 then
    local curSeasonId = DataCenter.LWWorldTrendDataManager:GetCurSeasonId()
    if curSeasonId ~= self.param.seasonId then
      self.TimeBgImage:LoadSprite("Assets/Main/Sprites/UI/LWWorldTrend/cfm_tianxiadashi_rili_1.png")
      self.dayCountText:SetColor(WhiteColor)
      self.dayText:SetColor(WhiteColor)
      self.closeImg:SetActive(true)
      self.openImg:SetActive(false)
      self.goBtn:SetActive(false)
      if curSeasonId < self.param.seasonId then
        self.timeText:SetLocalText(500412)
      else
        self.timeText:SetLocalText(500411)
      end
      self.timeText:SetColor(WhiteColor)
      self.timeIcon:SetColor(WhiteColor)
      return
    end
  end
  if time <= 0 then
    self.endTime = self.param:GetEndTime()
    if self.endTime == -1 then
      self.TimeBgImage:LoadSprite("Assets/Main/Sprites/UI/LWWorldTrend/cfm_tianxiadashi_rili_2.png")
      self.dayCountText:SetColor(localGrayColor)
      self.dayText:SetColor(localGrayColor)
      self.closeImg:SetActive(false)
      self.openImg:SetActive(true)
      self.timeText:SetLocalText("world_trends_state_open")
      self.timeText:SetColor(localGreenColor)
      self.timeIcon:SetColor(localGreenColor)
      if not (self.param and self.param.jumpType) or 0 >= self.param.jumpType then
        self.goBtn:SetActive(false)
      else
        self.goBtn:SetActive(true)
      end
    elseif curTime > self.endTime then
      self.timeText:SetLocalText(500411)
      self.timeText:SetColor(WhiteColor)
      self.closeImg:SetActive(true)
      self.openImg:SetActive(false)
      self.dayCountText:SetColor(WhiteColor)
      self.dayText:SetColor(WhiteColor)
      self.timeIcon:SetColor(WhiteColor)
      self.TimeBgImage:LoadSprite("Assets/Main/Sprites/UI/LWWorldTrend/cfm_tianxiadashi_rili_1.png")
      self.goBtn:SetActive(false)
    else
      self.closeImg:SetActive(false)
      self.openImg:SetActive(true)
      self.TimeBgImage:LoadSprite("Assets/Main/Sprites/UI/LWWorldTrend/cfm_tianxiadashi_rili_2.png")
      self.dayCountText:SetColor(localGrayColor)
      self.dayText:SetColor(localGrayColor)
      local time = self.endTime - curTime
      if 0 < time then
        self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
      end
      self.timeText:SetColor(localGreenColor)
      self.timeIcon:SetColor(localGreenColor)
      self.timer = TimerManager:GetInstance():GetTimer(1, self.timerAction, self, false, false, false)
      self.timer:Start()
      if not (self.param and self.param.jumpType) or 0 >= self.param.jumpType then
        self.goBtn:SetActive(false)
      else
        self.goBtn:SetActive(true)
      end
    end
  else
    self.closeImg:SetActive(true)
    self.openImg:SetActive(false)
    self.TimeBgImage:LoadSprite("Assets/Main/Sprites/UI/LWWorldTrend/cfm_tianxiadashi_rili_1.png")
    self.dayCountText:SetColor(WhiteColor)
    self.dayText:SetColor(WhiteColor)
    self.timeIcon:SetColor(WhiteColor)
    self.timeText:SetLocalText(500412)
    self.timeText:SetColor(WhiteColor)
    self.goBtn:SetActive(false)
  end
end

return LWUIDayInfoCell
