local UILWPlotView = BaseClass("UILWPlotView", UIBaseView)
local base = UIBaseView
local compBook = {
  {
    path = "normal",
    name = "normal.root",
    type = UIBaseContainer
  },
  {
    path = "normal/layout",
    name = "normal.BgAnimator",
    type = UIAnimator
  },
  {
    path = "normal/layout/bg_content/txt_content_n",
    name = "normal.txtContent",
    type = UITextMeshProUGUIEx
  },
  {
    path = "normal/layout/bg_content/obj_next_n",
    name = "normal.objNext",
    type = UIBaseContainer
  },
  {
    path = "normal/layout/bg_content/txt_name_n",
    name = "normal.txtName",
    type = UIText
  },
  {
    path = "normal/iconContent",
    name = "normal.CharacterAnimator",
    type = UIAnimator
  },
  {
    path = "normal/iconContent/mask/img_halfbody",
    name = "normal.imgHalfbody",
    type = UIRawImage
  },
  {
    path = "normal/iconContent/mask/img_halfbody/Loading",
    name = "normal.Loading",
    type = UIImage
  },
  {
    path = "normal/iconContent/mask/img_RT",
    name = "normal.imgRT",
    type = UIRawImage
  },
  {
    path = "normal/iconContent/root_spine",
    name = "normal.rootSpine",
    type = UIBaseContainer
  },
  {
    path = "normal/layout/bg_content",
    name = "normal.bg_content",
    type = UIBaseContainer
  },
  {
    path = "radio",
    name = "radio.root",
    type = UIBaseContainer
  },
  {
    path = "radio/bg_content/txt_content_r",
    name = "radio.txtContent",
    type = UIText
  },
  {
    path = "radio/bg_content/txt_name_r",
    name = "radio.txtName",
    type = UIText
  },
  {
    path = "radio/bg_content/img_icon",
    name = "radio.imgIcon",
    type = UIImage
  },
  {
    path = "btn_next",
    name = "btnNext",
    type = UIButton
  },
  {
    path = "dark",
    name = "dark.root",
    type = UIBaseContainer
  },
  {
    path = "dark",
    name = "dark.img",
    type = UIImage
  },
  {
    path = "dark/txt_content_d",
    name = "dark.txtContent",
    type = UIText
  },
  {
    path = "normal/layout/bg_content/choose",
    name = "chooseContent",
    type = UIBaseContainer
  },
  {
    path = "normal/layout/bg_content/choose/btn_choose",
    name = "btnChoose",
    type = UIBaseContainer
  },
  {
    path = "normal/btn_temp_close",
    name = "btnTempClose",
    type = UIButton
  }
}
local RTEnvResPath = "Assets/Main/Prefabs/UI/UILWPlot/UILWPlotRTEnv.prefab"
local spineOffset = {-145, 145}
local RTOffset = {-200, 200}
local nameOffset = {-344, 344}
local characterInAni = {
  "UILWPlot_NPC_movein_L",
  "UILWPlot_NPC_movein_R"
}
local characterOutAni = {
  "UILWPlot_NPC_moveout_L",
  "UILWPlot_NPC_moveout_R"
}
local appearanceSpecialIds = {
  ["70000"] = {-118, 21},
  ["70001"] = {-118, 21},
  ["40020"] = {-126, 0},
  ["10000"] = {-126, 0}
}
local Style = {
  Halfbody = 1,
  Spine = 2,
  Model3D = 3,
  Icon = 4,
  AutoHalfbody = 5,
  Dark = 6
}

function UILWPlotView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.groupRandomIndex = -1
  self.groupRandom = false
  self:PrepareData()
  self.currPlot = nil
  self.currStep = 0
  self.spineResHandle = nil
  self.dubHandle = nil
  self.nextTipTween = nil
  self.currAnimName = nil
  self.done = false
  self.isFirst = true
  if self.groupRandom and self.groupRandomIndex ~= -1 then
    self.currStep = self.groupRandomIndex - 1
  elseif self.playContext.step then
    self.currStep = self.playContext.step - 1
  end
  EventManager:GetInstance():Broadcast(EventId.PlotGroupStart, self.plotGroup.id)
  if self.normal.BgAnimator then
    self.normal.BgAnimator:Play("UILWPlot_content_movein", 0, 0)
  end
  self.normal.imgHalfbody.gameObject:SetActive(false)
  self.normal.rootSpine.gameObject:SetActive(false)
  self:NextStep()
end

function UILWPlotView:__delete()
  if self.plotGroup == nil then
    local groupId = self:GetUserData()
    if groupId then
      EventManager:GetInstance():Broadcast(EventId.PlotViewClosedAbnormally, groupId)
      Logger.LogInfo("UILWPlotView Delete : " .. (tonumber(groupId) or 0))
    end
  end
end

function UILWPlotView:OnDestroy()
  local done = self.done
  self.done = true
  if not done and self.plotGroup and self.plotGroup.id then
    EventManager:GetInstance():Broadcast(EventId.PlotViewClosedAbnormally, self.plotGroup.id)
  end
  self.change = nil
  self.lastPlot = nil
  self.lastStep = nil
  self.isFirst = nil
  self.plotGroup = nil
  self:KillTween()
  self:ClearSpineRes()
  self:DisposeRTEnv()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPlotView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TimelineInteractionPlotNext, self.OnTimelineInteractionPlotNext)
end

function UILWPlotView:OnRemoveListener()
  self:RemoveUIListener(EventId.TimelineInteractionPlotNext, self.OnTimelineInteractionPlotNext)
  base.OnRemoveListener(self)
end

function UILWPlotView:OnTimelineInteractionPlotNext(plotId)
  if plotId and self.plotGroup and plotId == self.plotGroup.id then
    self:OnClickNext()
  end
end

function UILWPlotView:PrepareData()
  local id, context = self:GetUserData()
  self.plotGroup = {
    id = id,
    plots = {}
  }
  self.playContext = context
  local miss = false
  local plotId = self.plotGroup.id * 100 + 1
  local plot = LocalController.instance():getLine(TableName.LW_Plot, plotId)
  if plot and plot.random_dialogue == "1" then
    self.groupRandom = true
  end
  while not miss do
    local plot = LocalController.instance():getLine(TableName.LW_Plot, plotId)
    if plot == nil then
      miss = true
    else
      table.insert(self.plotGroup.plots, plot)
    end
    plotId = plotId + 1
  end
  if self.groupRandom then
    local key = table.randomKey(self.plotGroup.plots)
    if key ~= nil then
      local index = toInt(key)
      if 0 < index then
        self.groupRandomIndex = index
      end
    end
  end
end

function UILWPlotView:ComponentDestroy()
  if self.delayTimer1 then
    self.delayTimer1:Stop()
    self.delayTimer1 = nil
  end
  if self.delayTimer2 ~= nil then
    self.delayTimer2:Stop()
    self.delayTimer2 = nil
  end
  if self.chooseContent then
    self.chooseContent:RemoveComponents(UIButton)
  end
  if self.chooseDialogItem then
    self.chooseDialogItem:GameObjectRecycleAll()
  end
  self.lastOffSet = nil
  self:ClearCompsByBook(compBook)
end

function UILWPlotView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.btnNext:SetOnClick(function()
    self:OnClickNext()
  end)
  self.btnTempClose:SetOnClick(function()
    self:OnTempCloseClicked()
  end)
  self.chooseDialogItem = self.btnChoose.gameObject
  self.chooseDialogItem:GameObjectCreatePool()
  self.chooseDialogItem:SetActive(false)
end

function UILWPlotView:OnClickNext()
  if self.clickEnabled and not self.done then
    self:NextStep()
  end
end

function UILWPlotView:ClearSpineResCondition()
  if self.currPlot and self.lastStep and self.lastStep ~= 0 and self.currPlot.style == Style.Spine then
    self.lastPlot = self.plotGroup.plots[self.lastStep]
    if self.lastPlot then
      if self.currPlot.style == self.lastPlot.style and self.lastPlot.appearance == self.currPlot.appearance then
        self.change = false
      else
        self:ClearSpineRes()
      end
    else
      self:ClearSpineRes()
    end
  else
    self:ClearSpineRes()
  end
end

function UILWPlotView:NextStepAction()
  if self.currPlot == nil then
    Logger.LogError("can't find plot with id " .. self.plotGroup.plots[self.currStep])
    self:NextStep()
  else
    if self.currPlot.style == Style.Icon then
      self:RenderStyleIcon()
    elseif self.currPlot.style == Style.Halfbody then
      self:RenderStyleHalfbody()
    elseif self.currPlot.style == Style.Spine then
      self:RenderStyleSpine()
    elseif self.currPlot.style == Style.Model3D then
      self:RenderStyleModel3D()
    elseif self.currPlot.style == Style.Dark then
      self:RenderStyleDark()
    else
      self:RenderStyleHalfbody()
    end
    self:HandleChooseDialog()
    self:RefreshTween(self.currPlot.style ~= Style.Icon and string.IsNullOrEmpty(self.currPlot.choose_dialog))
    if not string.IsNullOrEmpty(self.currPlot.dub) then
      self.dubHandle = DataCenter.LWSoundManager:PlayDub(self.currPlot.dub)
    end
    if self.autoNextTimer ~= nil then
      self.autoNextTimer:Stop()
    end
    if self.currPlot.duration > 0 then
      self.autoNextTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:NextStep()
      end, self.currPlot.duration)
    end
    PostEventLog.Track(PostEventLog.Defines.PlotEnter, {
      plotGroupId = tostring(self.plotGroup.id),
      plotId = tostring(self.currPlot.id)
    })
  end
end

function UILWPlotView:NextStep()
  self.change = true
  self.lastStep = self.currStep
  self:KillTween()
  if self.dubHandle ~= nil then
    DataCenter.LWSoundManager:FadeOutAndPlayMusic(self.dubHandle, 0.1)
    self.dubHandle = nil
  end
  if self.currPlot ~= nil then
    PostEventLog.Track(PostEventLog.Defines.PlotExit, {
      plotGroupId = tostring(self.plotGroup.id),
      plotId = tostring(self.currPlot.id)
    })
  end
  self.currStep = self.currStep + 1
  if self.currStep > #self.plotGroup.plots then
    self:Done()
    return
  end
  if self.groupRandom and self.groupRandomIndex ~= self.currStep then
    self:Done()
    return
  end
  self.currPlot = self.plotGroup.plots[self.currStep]
  local delayTime = 0
  if self.lastOffSet then
    delayTime = 6
    self:ClearSpineResCondition()
    if self.change then
      if self.lastOffSet == 1 then
        self.normal.CharacterAnimator:Play(characterOutAni[self.lastOffSet + (CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0)], 0, 0)
      else
        self.normal.CharacterAnimator:Play(characterOutAni[self.lastOffSet - (CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0)], 0, 0)
      end
    end
  end
  self.normal.txtName.gameObject:SetActive(not self.change)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
  end
  self.clickEnabled = false
  if 0 >= self.currPlot.noClick then
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.clickEnabled = true
    end, 0.5)
  end
  if self.delayTimer2 ~= nil then
    self.delayTimer2:Stop()
    self.delayTimer2 = nil
  end
  self.delayTimer2 = TimerManager:GetInstance():DelayFrameInvoke(function()
    self:NextStepAction()
  end, delayTime)
end

function UILWPlotView:RevertNpc(facing, object, num)
  if self.currPlot.left == 0 and facing == 0 then
    object.transform:Set_localScale(-num * CommonUtil.ArabicAutoMirrorFactor(), num, ResetScale.z)
  elseif self.currPlot.left == 1 and facing == 1 then
    object.transform:Set_localScale(-num * CommonUtil.ArabicAutoMirrorFactor(), num, ResetScale.z)
  else
    object.transform:Set_localScale(num * CommonUtil.ArabicAutoMirrorFactor(), num, ResetScale.z)
  end
end

function UILWPlotView:RenderStyleHalfbody()
  self.normal.root:SetActive(true)
  self.radio.root:SetActive(false)
  self.normal.imgRT.gameObject:SetActive(false)
  self.normal.rootSpine.gameObject:SetActive(false)
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(self.currPlot.appearance)
  local iconLocation = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "half_icon_path_location")
  local facing = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "facing")
  self:RevertNpc(facing, self.normal.imgHalfbody.gameObject, 1)
  local imgPath = HeroUtils.GetHeroIconPath(self.currPlot.appearance, HeroIconType.pose_icon_path)
  local hasAsset = UIUtil.CheckAssetDownloaded(imgPath)
  self.normal.Loading:SetActive(not hasAsset)
  self.normal.imgHalfbody:LoadSpriteAuto(imgPath, function(texture)
    if self and self.normal.imgHalfbody then
      self.normal.imgHalfbody:SetNativeSize()
    end
    if not hasAsset and self and self.normal.Loading then
      self.normal.Loading:SetActive(false)
    end
  end)
  if string.IsNullOrEmpty(iconLocation) then
    self.normal.imgHalfbody:SetAnchoredPositionXY(self.normal.imgHalfbody:GetAnchoredPositionX(), 0)
    self:SetOffset(self.currPlot.left + 1)
  else
    local pos = string.split(iconLocation, "|")
    if pos and #pos == 2 then
      self.normal.imgHalfbody:SetAnchoredPositionXY(toInt(pos[1]), toInt(pos[2]))
      self:SetOffset(self.currPlot.left + 1)
    else
      self.normal.imgHalfbody:SetAnchoredPositionXY(self.normal.imgHalfbody:GetAnchoredPositionX(), 0)
      self:SetOffset(self.currPlot.left + 1)
    end
  end
  self.dark.root:SetActive(false)
  self.normal.txtName:SetText(CS.GameEntry.Localization:GetString(self.currPlot.name))
  self.normal.txtContent:SetText(CS.GameEntry.Localization:GetString(self.currPlot.content))
  self.currAnimName = nil
end

function UILWPlotView:RenderStyleSpine()
  self.normal.root:SetActive(true)
  self.radio.root:SetActive(false)
  self.normal.imgRT.gameObject:SetActive(false)
  self.normal.imgHalfbody.gameObject:SetActive(false)
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(self.currPlot.appearance)
  local facing = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "facing")
  self:RevertNpc(facing, self.normal.rootSpine.gameObject, 0.7)
  self.dark.root:SetActive(false)
  self:SetOffset(self.currPlot.left + 1)
  self.normal.txtName:SetText(CS.GameEntry.Localization:GetString(self.currPlot.name))
  self.normal.txtContent:SetText(CS.GameEntry.Localization:GetString(self.currPlot.content))
  if self.change then
    self:LoadSpineByAppearance(self.currPlot.appearance)
  end
  self.currAnimName = nil
end

function UILWPlotView:RenderStyleModel3D()
  self.normal.root:SetActive(true)
  self.radio.root:SetActive(false)
  self.normal.imgHalfbody.gameObject:SetActive(false)
  self.normal.rootSpine.gameObject:SetActive(false)
  self.dark.root:SetActive(false)
  self:SetOffset(self.currPlot.left + 1)
  self.normal.txtName:SetText(CS.GameEntry.Localization:GetString(self.currPlot.name))
  self.normal.txtContent:SetText(CS.GameEntry.Localization:GetString(self.currPlot.content))
  self:SetupRTEnv()
end

function UILWPlotView:RenderStyleIcon()
  self.normal.root:SetActive(false)
  self.radio.root:SetActive(true)
  self.normal.imgRT.gameObject:SetActive(false)
  self.normal.imgHalfbody.gameObject:SetActive(false)
  self.normal.rootSpine.gameObject:SetActive(false)
  self.dark.root:SetActive(false)
  self.radio.txtName:SetText(CS.GameEntry.Localization:GetString(self.currPlot.name))
  self.radio.txtContent:SetText(CS.GameEntry.Localization:GetString(self.currPlot.content))
  self.radio.imgIcon:LoadSpriteAuto(HeroUtils.GetHeroIconPath(self.currPlot.appearance))
  self.currAnimName = nil
end

function UILWPlotView:RenderStyleDark()
  self.normal.root:SetActive(false)
  self.radio.root:SetActive(false)
  self.normal.imgRT.gameObject:SetActive(false)
  self.normal.imgHalfbody.gameObject:SetActive(false)
  self.normal.rootSpine.gameObject:SetActive(false)
  self.dark.root:SetActive(true)
  self.dark.txtContent:SetText(CS.GameEntry.Localization:GetString(self.currPlot.content))
  self.currAnimName = nil
end

function UILWPlotView:HandleChooseDialog()
  self.chooseContent:SetActive(false)
  self.chooseContent:RemoveComponents(UIButton)
  self.chooseDialogItem:GameObjectRecycleAll()
  local transform = self.chooseContent.transform
  if not string.IsNullOrEmpty(self.currPlot.choose_dialog) then
    local options = string.split(self.currPlot.choose_dialog, "|")
    for i, optionKey in ipairs(options) do
      local goItem = self.chooseDialogItem:GameObjectSpawn(transform)
      goItem.name = string.format("ChooseDialogItem_%d", i)
      local item = self.chooseContent:AddComponent(UIButton, goItem.name)
      local itemText = item:AddComponent(UIText, "text")
      itemText:SetLocalText(optionKey)
      item:SetOnClick(function()
        self:OnChooseDialogOptionClicked(i)
      end)
      goItem:SetActive(true)
    end
    self.chooseContent:SetActive(true)
    self.btnTempClose:SetActive(true)
    self.btnNext:SetActive(false)
    self.normal.objNext:SetActive(false)
  else
    self.btnTempClose:SetActive(false)
    self.btnNext:SetActive(true)
    self.normal.objNext:SetActive(true)
  end
end

function UILWPlotView:OnChooseDialogOptionClicked(index)
  self.done = true
  EventManager:GetInstance():Broadcast(EventId.PlotGroupChoose, index)
end

function UILWPlotView:OnTempCloseClicked()
  if self.currPlot and not string.IsNullOrEmpty(self.currPlot.choose_dialog) then
    EventManager:GetInstance():Broadcast(EventId.PlotViewCloseTemp, self.currStep)
  else
    EventManager:GetInstance():Broadcast(EventId.PlotViewCloseTemp, false)
  end
end

function UILWPlotView:Done()
  self.done = true
  self:PlayOutAin()
  EventManager:GetInstance():Broadcast(EventId.PlotGroupDone, self.plotGroup.id)
end

function UILWPlotView:PlayOutAin()
  if self.normal.BgAnimator then
    self.normal.BgAnimator:Play("UILWPlot_content_moveout", 0, 0)
  end
  if self.normal.CharacterAnimator and self.lastOffSet then
    if self.lastOffSet == 1 then
      self.normal.CharacterAnimator:Play(characterOutAni[self.lastOffSet + (CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0)], 0, 0)
    else
      self.normal.CharacterAnimator:Play(characterOutAni[self.lastOffSet - (CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0)], 0, 0)
    end
  end
end

function UILWPlotView:SetOffset(idx)
  if self.delayTimer1 then
    self.delayTimer1:Stop()
    self.delayTimer1 = nil
  end
  local timeDelay = 0
  if self.isFirst then
    timeDelay = 5
  end
  self.lastOffSet = idx
  self.delayTimer1 = TimerManager:GetInstance():DelayFrameInvoke(function()
    local txtContentSize = self.normal.bg_content:GetSizeDelta()
    local txtContentOffsetX = (txtContentSize.x - 870) / 2
    if idx == 1 then
      self.normal.txtName:SetAnchoredPositionXY(nameOffset[idx] - txtContentOffsetX, self.normal.txtName:GetAnchoredPositionY())
      self.normal.txtName:SetPivotXY(CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0, 0.5)
      if self.change then
        self.normal.CharacterAnimator:Play(characterInAni[idx + (CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0)], 0, 0)
      end
    else
      self.normal.txtName:SetAnchoredPositionXY(nameOffset[idx] + txtContentOffsetX, self.normal.txtName:GetAnchoredPositionY())
      self.normal.txtName:SetPivotXY(CommonUtil.IsArabicAutoMirrorOpen() and 0 or 1, 0.5)
      if self.change then
        self.normal.CharacterAnimator:Play(characterInAni[idx - (CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0)], 0, 0)
      end
    end
    self.normal.txtName.gameObject:SetActive(true)
    self.normal.rootSpine.gameObject:SetActive(self.currPlot.style == Style.Spine)
    self.normal.imgHalfbody.gameObject:SetActive(self.currPlot.style == Style.Halfbody or self.currPlot.style == Style.AutoHalfbody)
    self.isFirst = false
  end, timeDelay)
  self.normal.rootSpine:SetAnchoredPositionXY(spineOffset[idx], self.normal.rootSpine:GetAnchoredPositionY())
  self.normal.imgRT:SetAnchoredPositionXY(RTOffset[idx], self.normal.imgRT:GetAnchoredPositionY())
  local halfBodyOffsetX = self.normal.imgHalfbody:GetAnchoredPositionX()
  if idx == 1 then
    self.normal.imgHalfbody:SetAnchoredPositionXY(halfBodyOffsetX, self.normal.imgHalfbody:GetAnchoredPositionY())
  else
    self.normal.imgHalfbody:SetAnchoredPositionXY(-halfBodyOffsetX, self.normal.imgHalfbody:GetAnchoredPositionY())
  end
end

function UILWPlotView:LoadSpineByAppearance(appearance)
  self:ClearSpineRes()
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(appearance)
  if newAppearanceId <= 0 then
    return
  end
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  if string.IsNullOrEmpty(spinePath) then
    return
  end
  local request = CS.GameEntry.Resource:InstantiateAsync(spinePath)
  self.spineResHandle = request
  request:completed("+", function()
    if request.isError or request.gameObject == nil then
      self.spineResHandle = nil
      return
    end
    request.gameObject:SetActive(true)
    local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTransform ~= nil then
      local spineScale = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_scale")
      local spinePos = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_pos")
      rectTransform:SetParent(self.normal.rootSpine.transform, false)
      rectTransform:Set_localScale(spineScale, spineScale, spineScale)
      local specialPos = appearanceSpecialIds[tostring(newAppearanceId)]
      if specialPos then
        rectTransform:Set_anchoredPosition(CommonUtil.IsArabicAutoMirrorOpen() and -(specialPos[1] / spineScale) or specialPos[1] / spineScale, specialPos[2] / spineScale, 0)
      else
        rectTransform:Set_anchoredPosition(CommonUtil.IsArabicAutoMirrorOpen() and -(spinePos[1] / spineScale) or spinePos[1] / spineScale, spinePos[2] / spineScale, 0)
      end
    end
  end)
end

function UILWPlotView:ClearSpineRes()
  if self.spineResHandle ~= nil then
    self.spineResHandle:Destroy()
    self.spineResHandle = nil
  end
end

function UILWPlotView:SetupRTEnv()
  if self.renderTexture == nil then
    self.renderTexture = CS.UnityEngine.RenderTexture.GetTemporary(800, 800, 24, CS.UnityEngine.RenderTextureFormat.ARGB32)
    self.renderTexture.name = "PlotRT"
    self.normal.imgRT:SetTexture(self.renderTexture)
  end
  self.normal.imgRT.gameObject:SetActive(false)
  if IsNull(self.RTEnvResHandle) then
    self.RTEnvResHandle = CS.GameEntry.Resource:InstantiateAsync(RTEnvResPath)
    self.RTEnvResHandle:completed("+", function()
      if self.RTEnvResHandle.isError or self.RTEnvResHandle.gameObject == nil then
        Logger.LogError("UILWPlotView:LoadRTEnv failed -> " .. RTEnvResPath)
        return
      end
      self.RTCamera = self.RTEnvResHandle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
      self.RTCamera.targetTexture = self.renderTexture
      self.npcAnimator = self.RTEnvResHandle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
      self:PlayNpcAnim(self.currPlot.anim)
      self.normal.imgRT.gameObject:SetActive(true)
    end)
  else
    self:PlayNpcAnim(self.currPlot.anim)
    self.normal.imgRT.gameObject:SetActive(true)
  end
end

function UILWPlotView:PlayNpcAnim(animName)
  if self.currAnimName == animName then
    return
  end
  if not IsNull(self.npcAnimator) then
    if string.IsNullOrEmpty(animName) then
      animName = "idle"
    end
    self.npcAnimator:SetTrigger(animName)
    self.currAnimName = animName
  end
end

function UILWPlotView:DisposeRTEnv()
  if self.normal and self.normal.imgRT then
    self.normal.imgRT:SetTexture(nil)
  end
  if not IsNull(self.RTCamera) then
    self.RTCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    CS.UnityEngine.RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
  if not IsNull(self.RTEnvResHandle) then
    self.RTEnvResHandle:Destroy()
    self.RTEnvResHandle = nil
  end
end

function UILWPlotView:KillTween()
  if self.nextTipTween ~= nil and not IsNull(self.nextTipTween) then
    self.nextTipTween:Kill()
    self.nextTipTween = nil
  end
  if self.autoNextTimer ~= nil then
    self.autoNextTimer:Stop()
    self.autoNextTimer = nil
  end
end

function UILWPlotView:RefreshTween(isNormal)
  self:KillTween()
  if isNormal then
    local origY = 45
    local nextTip = self.normal.objNext
    nextTip:SetAnchoredPositionXY(nextTip:GetAnchoredPositionX(), origY)
    nextTip:SetActive(false)
    if self.currPlot.noClick <= 0 then
      self.nextTipTween = nextTip.transform:DOAnchorPosY(origY + 5, 0.5):SetLoops(-1, CS.DG.Tweening.LoopType.Yoyo):SetEase(CS.DG.Tweening.Ease.InOutQuad):SetDelay(0.5):OnStart(function()
        nextTip:SetActive(true)
      end)
    end
  end
end

return UILWPlotView
