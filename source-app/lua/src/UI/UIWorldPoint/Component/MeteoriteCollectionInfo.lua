local base = UIAsyncContainer
local MeteoriteCollectionInfo = BaseClass("MeteoriteCollectionInfo", base)
local MyRand = math.random
local Emojis = {
  1,
  13,
  25,
  28,
  36,
  38,
  50,
  105,
  138,
  166
}
local UI_EMOJI_BUBBLE_PATH = "Assets/Main/Prefabs/UI/UILWPlot/UILWPlotEmojiBubble.prefab"
local EmojiBubble = require("DataCenter.LWPlotManager.LWPlotEmojiBubble")
local EmojiBubbleTime = 2

function MeteoriteCollectionInfo:OnCreate()
  base.OnCreate(self)
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "info/headNode/UIPlayerHead")
  self.compNoBodyHead = self:AddComponent(UIBaseComponent, "info/headNode/noBodyHead")
  self.compDetail = self:AddComponent(UIBaseComponent, "info/Detail")
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "info/Detail/NameText")
  self.textPercent = self:AddComponent(UITextMeshProUGUIEx, "info/Detail/PercentText")
  self.sliderHp = self:AddComponent(UISlider, "info/Detail/PercentText/HpSlider")
  self.imgHpFill = self:AddComponent(UIImage, "info/Detail/PercentText/HpSlider/Fill Area/HpFill")
  self.textFight = self:AddComponent(UITextMeshProUGUIEx, "info/Detail/fight/FightText")
  self.textEmpty = self:AddComponent(UITextMeshProUGUIEx, "info/EmptyText")
  self.textTime = self:AddComponent(UITextMeshProUGUIEx, "TimeText")
  self.sliderS = self:AddComponent(UISlider, "Slider/SSlider")
  self.imgSFill = self:AddComponent(UIImage, "Slider/SSlider/Fill Area/SFill")
  self.imgFill = self:AddComponent(UIImage, "Slider/SSlider/Fill Area/Fill")
  self.textS = self:AddComponent(UITextMeshProUGUIEx, "Slider/SSlider/SText")
  self.btnTip = self:AddComponent(UIButton, "tip/TipBtn")
  self.btnTip:SetOnClick(function()
    if self.pointData then
      UIUtil.ShowBubbleTips(self.pointData.desc or "", self.btnTip.transform.position, 0, -30, 0)
    end
  end)
  self.textNum1 = self:AddComponent(UITextMeshProUGUIEx, "tip/Icon1/NumText1")
  self.icon2 = self:AddComponent(UIImage, "tip/Icon2")
  self.textNum2 = self:AddComponent(UITextMeshProUGUIEx, "tip/Icon2/NumText2")
  
  function self.timer_action()
    self:RefreshTime()
  end
  
  local ebParams = {}
  ebParams.duration = EmojiBubbleTime
  ebParams.anchor = Vector3.New(30, 3, 0)
  ebParams.rotation = -0.2
  ebParams.mode = "2DFollow"
  ebParams.followTarget = self.transform:Find("info/headNode")
  self.emojiBubbleParams = ebParams
  self.bEnemy = false
end

function MeteoriteCollectionInfo:OnDestroy()
  self:CleanEmojiBubble()
  self:DeleteTimer()
  self.timer_action = nil
  self.compDetail = nil
  self.compUIPlayerHead = nil
  self.compNoBodyHead = nil
  self.textName = nil
  self.textPercent = nil
  self.sliderHp = nil
  self.imgHpFill = nil
  self.textFight = nil
  self.textEmpty = nil
  self.textTime = nil
  self.sliderS = nil
  self.imgSFill = nil
  self.imgFill = nil
  self.textS = nil
  self.btnTip = nil
  self.textNum1 = nil
  self.icon2 = nil
  self.textNum2 = nil
  self.pointData = nil
  self.emojiBubbleParams = nil
  self.lastEmojiTime = nil
  base.OnDestroy(self)
end

function MeteoriteCollectionInfo:OnDisable()
  self:CleanEmojiBubble()
  self:DeleteTimer()
  base.OnDisable(self)
end

function MeteoriteCollectionInfo:CleanEmojiBubble()
  if not IsNull(self.cacheLoadingHandle) then
    self.cacheLoadingHandle:Destroy()
  end
  self.cacheLoadingHandle = nil
  if self.emojiBubble then
    self.emojiBubble:Dispose()
    self.emojiBubble:Delete()
  end
  self.emojiBubble = nil
end

function MeteoriteCollectionInfo:VirtualRemainTimeSec()
  if self.pointData == nil then
    return 0
  end
  if self.textEmpty:GetActive() then
    return self.pointData.remainTime
  end
  local collectEndTime = self.pointData.collectEndTime
  local remainTime = self.pointData.remainTime or 0
  if collectEndTime <= 0 then
    return remainTime
  else
    local virtualStartTime = collectEndTime - remainTime
    local elapsed = UITimeManager:GetInstance():GetServerSeconds() - virtualStartTime
    if 0 <= elapsed then
      local virtualRemain = remainTime - elapsed
      return 0 <= virtualRemain and virtualRemain or 0
    end
    return remainTime
  end
end

function MeteoriteCollectionInfo:VirtualRemainCount()
  if self.pointData == nil then
    return 0
  end
  local time = Mathf.Max(self:VirtualRemainTimeSec(), 0)
  return time * (self.pointData.gatherSpeed or 0) + (self.pointData.lastRes or 0)
end

function MeteoriteCollectionInfo:RefreshTime()
  if self.pointData == nil then
    return
  end
  local remainTime = self:VirtualRemainTimeSec()
  self.textTime:SetText(remainTime .. "s")
  local remainRes = self:VirtualRemainCount()
  self.textS:SetText(string.GetFormattedSeparatorNum(remainRes))
  self.sliderS:SetValue(remainTime / self.pointData.occupyTime)
  if remainTime <= 0 and self.view then
    self.view.ctrl:CloseSelf()
    return
  end
  if self.bEnemy then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if self.lastEmojiTime == nil then
      self.lastEmojiTime = curTime - 1
    end
    local lastTime = self.lastEmojiTime
    if 3 < curTime - lastTime then
      local emojiId = Emojis[MyRand(1, #Emojis)]
      self:PlayEmojiBubble(emojiId)
      self.lastEmojiTime = curTime
    end
  end
  local bubble = self.emojiBubble
  if bubble then
    bubble.timer = bubble.timer - Time.deltaTime
    if 0 >= bubble.timer then
      bubble.gameObject:SetActive(false)
    else
      bubble:OnUpdate()
    end
  end
end

function MeteoriteCollectionInfo:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function MeteoriteCollectionInfo:AddTimer()
  self:DeleteTimer()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  self.timer:Start()
  self:RefreshTime()
end

function MeteoriteCollectionInfo:Refresh(pointData)
  self.pointData = pointData
  if self.pointData == nil then
    return
  end
  self:AddTimer()
  self.bEnemy = false
  local gatherUuid = pointData.gatherUUID or 0
  local ownerUuid = pointData.gatherUid
  local ownerAlId = pointData.gatherAllianceId
  local bEmtpy = true
  local sfPath = "lrb_tongyong_jindutiao_hui"
  local fPath = "lrb_zhouliuhuodong_pop_jindutiao_hui1"
  if 0 < gatherUuid then
    local pointDetail = DataCenter.WorldPointDetailManager:GetDetailByPointId(pointData.pointId)
    local meteorite = pointDetail ~= nil and pointDetail.meteorite or nil
    if meteorite ~= nil then
      bEmtpy = false
      self.textName:SetText(UIUtil.FormatServerAllianceName(pointDetail.srcServer, meteorite.abbr, meteorite.name, ownerUuid))
      local c = meteorite.remainHp or 0
      local m = meteorite.totalHp or 0
      local percent = c / m
      self.textPercent:SetText(string.format("%.1f", percent * 100) .. "%")
      self.sliderHp:SetValue(percent)
      self.textFight:SetText(string.GetFormattedSeparatorNum(meteorite.power))
      if ownerUuid == LuaEntry.Player:GetUid() then
        sfPath = "lyp_zdhf_jindutiao_lv"
        fPath = "mjc_zhouliuhuodong_pop_jindutiao_lv1"
        self.textName:SetColor(WorldGreenColor)
      elseif not string.IsNullOrEmpty(ownerAlId) and ownerAlId == LuaEntry.Player:GetAllianceUid() then
        sfPath = "lyp_zdhf_jindutiao_lan"
        fPath = "mjc_zhouliuhuodong_pop_jindutiao_lan1"
        self.textName:SetColor(WorldBlueColor)
      elseif pointDetail.srcServer == LuaEntry.Player:GetSourceServerId() then
        sfPath = "lyp_zdhf_jindutiao_huang"
        fPath = "mjc_zhouliuhuodong_pop_jindutiao_huang1"
        self.textName:SetColor(WorldYellowColor)
      else
        self.bEnemy = true
        sfPath = "lyp_zdhf_jindutiao_hong"
        fPath = "mjc_zhouliuhuodong_pop_jindutiao_hong1"
        self.textName:SetColor(WorldRedColor)
      end
    end
    if ownerUuid == LuaEntry.Player:GetUid() then
      self.compUIPlayerHead:SetAsMyself()
    else
      local userinfo = ChatInterface.getUserData(ownerUuid, true)
      if userinfo ~= nil then
        bEmtpy = false
        self.compUIPlayerHead:SetData(ownerUuid, userinfo.userPic, userinfo.userPicVer, nil, userinfo:GetHeadBgImg())
      else
        self.compUIPlayerHead:SetHead()
      end
    end
  end
  self.compDetail:SetActive(not bEmtpy)
  self.compUIPlayerHead:SetActive(not bEmtpy)
  self.textEmpty:SetActive(bEmtpy)
  self.compNoBodyHead:SetActive(bEmtpy)
  self.imgSFill:LoadSprite(string.format("Assets/Main/Sprites/UI/LWActMeteorite/%s.png", sfPath))
  self.imgFill:LoadSprite(string.format("Assets/Main/Sprites/UI/LWActMeteorite/%s.png", fPath))
  self.textNum1:SetText("\195\151" .. (self.pointData.lastRes or 0))
  local cfgId = pointData.config.id
  local bShow = cfgId == 101 or cfgId == 102
  self.icon2:SetActive(bShow)
  if bShow then
    local cfg = DataCenter.ActMeteoriteBattleManager:GetEntityConfigById(cfgId)
    local _icon = cfg and cfg.pic or ""
    self.icon2:LoadSprite(_icon)
    self.textNum2:SetText("\195\1511")
  end
end

function MeteoriteCollectionInfo:PlayEmojiBubble(emojiId)
  local emojiData = LocalController:instance():getLine(TableName.LW_EMOJI, emojiId)
  if emojiData == nil then
    Logger.LogError("emojiId not exist ! " .. emojiId)
    return
  end
  local playContext = self.emojiBubbleParams
  local bubble = self.emojiBubble
  if bubble ~= nil then
    bubble:SetEmojiData(emojiData)
    bubble.timer = EmojiBubbleTime
    bubble.gameObject:SetActive(true)
    bubble:Display2DFollow(playContext.followTarget, false)
    return
  end
  if self.cacheLoadingHandle then
    return
  end
  self.cacheLoadingHandle = CS.GameEntry.Resource:InstantiateAsync(UI_EMOJI_BUBBLE_PATH)
  self.cacheLoadingHandle:completed("+", function(handle)
    bubble = EmojiBubble.New({
      handle,
      emojiData,
      playContext.anchor,
      playContext.rotation
    })
    if playContext.mode == "2DFollow" then
      bubble.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Info.Name).transform)
      bubble:Display2DFollow(playContext.followTarget, false)
    end
    bubble.timer = EmojiBubbleTime
    self.emojiBubble = bubble
  end)
end

function MeteoriteCollectionInfo:UpdateInfo(serverData)
end

return MeteoriteCollectionInfo
