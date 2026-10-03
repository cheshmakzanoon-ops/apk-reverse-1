local UILWSaveGirlView = BaseClass("UILWSaveGirlView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local Setting = CS.GameEntry.Setting
local IgnoreGuideIds = {1026}
local compBook = {
  {
    path = "ImgBg",
    name = "imgBg",
    type = UIRawImage
  },
  {
    path = "Root/BottomBar/Time",
    name = "time",
    type = UIBaseContainer
  },
  {
    path = "Root/BottomBar/Time/HourBg/HourText",
    name = "time.hourText",
    type = UIText
  },
  {
    path = "Root/BottomBar/Time/MinuteBg/MinuteText",
    name = "time.minuteText",
    type = UIText
  },
  {
    path = "Root/BottomBar/Time/SecondBg/SecondText",
    name = "time.secondText",
    type = UIText
  },
  {
    path = "Root/MiddleContentContainer",
    name = "middle",
    type = UIBaseContainer
  },
  {
    path = "Root/MiddleContentContainer/Bubble/BubbleTip",
    name = "middle.bubbleTips",
    type = UIText
  },
  {
    path = "Root/MiddleContentContainer/Warning",
    name = "middle.warningImg",
    type = UIImage
  },
  {
    path = "Root/BottomBar",
    name = "bottom",
    type = UIBaseContainer
  },
  {
    path = "Root/BottomBar/layout/ItemContent",
    name = "bottom.itemContent",
    type = nil
  },
  {
    path = "Root/BottomBar/layout/ItemContent/ItemIcon",
    name = "bottom.itemIcon",
    type = UIImage
  },
  {
    path = "Root/BottomBar/layout/ItemContent/ItemCount",
    name = "bottom.itemCountText",
    type = UIText
  },
  {
    path = "Root/BottomBar/layout/ItemTip",
    name = "bottom.itemTip",
    type = UIText
  },
  {
    path = "Root/BottomBar/UseBtn",
    name = "bottom.btnUse",
    type = UIButton
  },
  {
    path = "Root/BottomBar/UseBtn/UseText",
    name = "bottom.btnUseText",
    type = UIText
  },
  {
    path = "Root/BottomBar/BtnBack",
    name = "bottom.btnBack",
    type = UIButton
  },
  {
    path = "spineNode",
    name = "spineNode",
    type = UIBaseContainer
  }
}
local skeleton_path_normal = "Assets/Main/Prefabs/UI/LWSaveGirl/SaveGirlSpineNormal.prefab"
local skeleton_path_jp = "Assets/Main/Prefabs/UI/LWSaveGirl/SaveGirlSpineJp.prefab"
local bg_normal = "Assets/Main/TextureEx/LWSaveGirl/lrb_chaidan_bg.png"
local bg_jp = "Assets/Main/TextureEx/LWSaveGirl/lrb_xinshouchaidan_bg.png"
local layout_path = "Root/BottomBar/layout"
local newbies_path = "Root/BottomBar/Newbies"
local item_tip_newbies_path = "Root/BottomBar/Newbies/ItemTipNewbies"
local use_btn_newbies_path = "Root/BottomBar/Newbies/UseBtnNewbies"
local use_text_newbies_path = "Root/BottomBar/Newbies/UseBtnNewbies/UseTextNewbies"
local item_icon_newbies_path = "Root/BottomBar/Newbies/UseBtnNewbies/ItemContentNewbies/ItemIconNewbies"
local item_count_newbies_path = "Root/BottomBar/Newbies/UseBtnNewbies/ItemContentNewbies/ItemCountNewbies"
local pg_node_path = "pgNode"
local fg5_path = "pgNode/pgBg/pg5/fg5"
local fg4_path = "pgNode/pgBg/pg4/fg4"
local fg3_path = "pgNode/pgBg/pg3/fg3"
local fg2_path = "pgNode/pgBg/pg2/fg2"
local fg1_path = "pgNode/pgBg/pg1/fg1"
local pg_text_path = "pgNode/pgText"
local girl_icon_path = "pgNode/girlIcon"
local use_btn_red_dot_newbies_path = "Root/BottomBar/Newbies/UseBtnNewbies/UseBtnRedDotNewbies"
local line_effect1_path = "pgNode/lineEffectNode/lineEffect1"
local line_effect2_path = "pgNode/lineEffectNode/lineEffect2"
local line_effect3_path = "pgNode/lineEffectNode/lineEffect3"
local line_effect4_path = "pgNode/lineEffectNode/lineEffect4"
local line_effect5_path = "pgNode/lineEffectNode/lineEffect5"
local fgEffectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/Xinshou_newbies/Eff_ui_monika_jindutiao_dianliang_01.prefab"
local guideFlow = 1114
local SaveGirlPanelTipShow = "SaveGirlPanelTipShow"

function UILWSaveGirlView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWSaveGirlView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWSaveGirlView:OnDisable()
  self:ClearDubHandle()
  base.OnDisable(self)
end

function UILWSaveGirlView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SaveGirlSucceed, self.OnSaveGirlSucceed)
  self:AddUIListener(EventId.GF_window_closed, self.OnWindowClosed)
end

function UILWSaveGirlView:OnRemoveListener()
  self:RemoveUIListener(EventId.SaveGirlSucceed, self.OnSaveGirlSucceed)
  self:RemoveUIListener(EventId.GF_window_closed, self.OnWindowClosed)
end

function UILWSaveGirlView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  local bg = bg_normal
  local path = skeleton_path_normal
  if LuaEntry.Player.JPUser and DataCenter.LWSaveGirlManager:IsJPGirlOpen() then
    path = skeleton_path_jp
    bg = bg_jp
  end
  self.imgBg:LoadSprite(bg)
  self.cacheAnim = nil
  self.cacheLoop = nil
  if self.req == nil then
    self.req = ResourceManager:InstantiateAsync(path)
    self.req:completed("+", function(handle)
      if handle.isError then
        return
      end
      local go = handle.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.spineNode.transform)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local sp = go.transform:Find("ImgSpine")
      if not IsNull(sp) then
        self.spine = sp:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
      end
      if self.cacheAnim ~= nil then
        self:PlaySpine(self.cacheAnim, self.cacheLoop)
      end
    end)
  end
  self.bottom.btnBack:SetOnClick(function()
    if self.waitSpine then
      return
    end
    self.ctrl:CloseSelf()
  end)
  self.bottom.btnUse:SetOnClick(function()
    self.ctrl:OnUseBtnClick(self.costItemId)
  end)
  self.time:SetAnchoredPositionXY(0, 388)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.newbies = self:AddComponent(UIBaseContainer, newbies_path)
  self.item_tip_newbies = self:AddComponent(UITextMeshProUGUIEx, item_tip_newbies_path)
  self.use_btn_newbies = self:AddComponent(UIButton, use_btn_newbies_path)
  self.use_text_newbies = self:AddComponent(UITextMeshProUGUIEx, use_text_newbies_path)
  self.item_icon_newbies = self:AddComponent(UIImage, item_icon_newbies_path)
  self.item_count_newbies = self:AddComponent(UITextMeshProUGUIEx, item_count_newbies_path)
  self.pg_node = self:AddComponent(UIBaseContainer, pg_node_path)
  self.pg_node:SetActive(false)
  self.fg5 = self:AddComponent(UIImage, fg5_path)
  self.fg4 = self:AddComponent(UIImage, fg4_path)
  self.fg3 = self:AddComponent(UIImage, fg3_path)
  self.fg2 = self:AddComponent(UIImage, fg2_path)
  self.fg1 = self:AddComponent(UIImage, fg1_path)
  self.pg_text = self:AddComponent(UITextMeshProUGUIEx, pg_text_path)
  self.girl_icon_btn = self:AddComponent(UIButton, girl_icon_path)
  self.girl_icon_img = self:AddComponent(UIImage, girl_icon_path)
  self.use_btn_red_dot_newbies = self:AddComponent(UIBaseContainer, use_btn_red_dot_newbies_path)
  self.fgList = {
    self.fg1,
    self.fg2,
    self.fg3,
    self.fg4,
    self.fg5
  }
  self.layout:SetActive(true)
  self.newbies:SetActive(false)
  self.pg_node:SetActive(false)
  self.use_btn_newbies:SetOnClick(function()
    self.use_btn_newbies:SetActive(false)
    if self.delayShowButtonTimer then
      self.delayShowButtonTimer:Stop()
      self.delayShowButtonTimer = nil
    end
    self.ctrl:OnUseBtnClick(self.costItemId)
  end)
  self.girl_icon_btn:SetOnClick(function()
    self:OnGirlIconBtnClick()
  end)
  self.line_effect1 = self:AddComponent(UIBaseContainer, line_effect1_path)
  self.line_effect2 = self:AddComponent(UIBaseContainer, line_effect2_path)
  self.line_effect3 = self:AddComponent(UIBaseContainer, line_effect3_path)
  self.line_effect4 = self:AddComponent(UIBaseContainer, line_effect4_path)
  self.line_effect5 = self:AddComponent(UIBaseContainer, line_effect5_path)
  self.lineEffectList = {
    self.line_effect1,
    self.line_effect2,
    self.line_effect3,
    self.line_effect4,
    self.line_effect5
  }
end

function UILWSaveGirlView:DataDefine()
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.costItemId = DataCenter.LWSaveGirlManager:GetCostItemId()
  self.maxSaveTimes = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k2")
  self.soundNameList = nil
  local soundCfg = LuaEntry.DataConfig:TryGetStr("guide_save_girl", "k26")
  if not string.IsNullOrEmpty(soundCfg) then
    self.soundNameList = string.split(soundCfg, ";")
  end
end

function UILWSaveGirlView:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function UILWSaveGirlView:RefreshTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local lastTime = self.endTime - curTime
  if lastTime <= 0 then
    self.time.gameObject:SetActive(false)
    self:DeleteTimer()
    return
  end
  local secs, delta = math.modf(lastTime / 1000)
  if 0 < delta then
    secs = secs + 1
  end
  local hour = math.modf(secs / 3600) % 24
  local minute = math.modf(secs / 60) % 60
  local second = math.floor(secs % 60)
  self.time.hourText:SetText(string.format("%02d", hour))
  self.time.minuteText:SetText(string.format("%02d", minute))
  self.time.secondText:SetText(string.format("%02d", second))
end

function UILWSaveGirlView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UILWSaveGirlView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
  self.delayShowArrow = nil
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.spine = nil
  self.layout = nil
  self.newbies = nil
  self.item_tip_newbies = nil
  self.use_btn_newbies = nil
  self.use_text_newbies = nil
  self.item_icon_newbies = nil
  self.item_count_newbies = nil
  self.pg_node = nil
  self.fg5 = nil
  self.fg4 = nil
  self.fg3 = nil
  self.fg2 = nil
  self.fg1 = nil
  self.pg_text = nil
  self.girl_icon_btn = nil
  self.girl_icon_img = nil
  self.fgList = nil
  self.use_btn_red_dot_newbies = nil
  self.lineEffectList = nil
  self.fgEffectGo = nil
  if self.fgEffectReq then
    self.fgEffectReq:Destroy()
    self.fgEffectReq = nil
  end
  if self.blockHandler then
    UIManager:GetInstance():DisableInteractionBlocker(self.blockHandler)
    self.blockHandler = nil
  end
  self.hided = nil
  if self.delayShowButtonTimer then
    self.delayShowButtonTimer:Stop()
    self.delayShowButtonTimer = nil
  end
end

function UILWSaveGirlView:DataDestroy()
  self:DeleteTimer()
  self:ClearShowTipDelay()
  self.timer_action = nil
  if self.delay ~= nil then
    self.delay:Stop()
  end
  self.delay = nil
  self.waitSpine = false
  if self.lineEffectDelay ~= nil then
    self.lineEffectDelay:Stop()
    self.lineEffectDelay = nil
  end
  if self.animTimer then
    self.animTimer:Stop()
    self.animTimer = nil
  end
end

function UILWSaveGirlView:HideSomething(value)
end

function UILWSaveGirlView:ReInit()
  self.ctrl:Reset()
  self.delayTriggerFlow = false
  local endTime, first = DataCenter.LWSaveGirlManager:GetWarningEndTime(true)
  self.endTime = endTime
  if first then
    self.ctrl:SetFirst()
  else
    self:HideSomething(false)
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local lastTime = self.endTime - curTime
  if lastTime <= 0 then
    self.time.gameObject:SetActive(false)
  else
    self:AddTimer()
    self:RefreshTime()
    self.time.gameObject:SetActive(true)
  end
  self:RefreshSpineState()
  self:RefreshBottom()
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.costItemId)
  if goods ~= nil then
    local spritePath = string.format(LoadPath.ItemPath, goods.icon)
    self.bottom.itemIcon:LoadSprite(spritePath)
    self.item_icon_newbies:LoadSprite(spritePath)
  end
end

function UILWSaveGirlView:ClearShowTipDelay()
  if self.showTipDelay then
    self.showTipDelay:Stop()
    self.showTipDelay = nil
  end
end

function UILWSaveGirlView:AddArrow()
  DataCenter.ArrowManager:RemoveFingerArrow()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGiftPackageRewardGet) then
    self.delayShowArrow = true
    return
  end
  local param = {}
  param.position = self.use_btn_newbies.transform.position
  param.arrowType = ArrowType.Normal
  param.positionType = PositionType.Screen
  DataCenter.ArrowManager:ShowArrow(param)
end

function UILWSaveGirlView:OnWindowClosed(uiName)
  if uiName == UIWindowNames.UIHeroExhibitPanel then
    local lastTimes = DataCenter.LWSaveGirlManager:GetLastTimes()
    if lastTimes <= 0 then
      self.ctrl:CloseSelf()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroListPanel)
    end
  end
  local lastTimes = DataCenter.LWSaveGirlManager:GetLastTimes()
  if lastTimes <= 0 and uiName == UIWindowNames.UIGiftPackageRewardGet and self.delayTriggerFlow then
    local flowId = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k12")
    if not DataCenter.LWGuideFlowManager:ReadDone(flowId) then
      DataCenter.LWGuideFlowManager.Runner:Run(flowId)
    end
  elseif uiName == UIWindowNames.UIGiftPackageRewardGet and self.delayShowArrow then
    self:AddArrow()
    self.delayShowArrow = nil
  end
end

function UILWSaveGirlView:OnSaveGirlSucceed(delayTriggerFlow)
  self.delayTriggerFlow = delayTriggerFlow
  local lastTimes = DataCenter.LWSaveGirlManager:GetLastTimes()
  local spineIndex = self.maxSaveTimes - lastTimes
  local p = self.use_btn_newbies.transform.parent
  self.use_btn_newbies.transform:SetParent(self.spine.transform, true)
  local pos = self.use_btn_newbies:GetAnchoredPosition()
  self.use_btn_newbies.transform:SetParent(p, true)
  local x = pos.x + 10
  local y = pos.y + 189
  if y < -7 then
    y = -7
  end
  self:PlaySpine("Chaixian" .. spineIndex, false)
  DataCenter.LWSoundManager:PlaySound(62289, false)
  self.waitSpine = true
  if self.delay ~= nil then
    self.delay:Stop()
  end
  local delayTime = 2.5
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self:RefreshSpineState()
    self.waitSpine = false
    self.blockHandler = nil
    self:RefreshBottom()
  end, delayTime)
  if self.animTimer then
    self.animTimer:Stop()
  end
  self.animTimer = TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.LWSoundManager:PlaySound(62290, false)
  end, 1.4)
  if self.lineEffectDelay ~= nil then
    self.lineEffectDelay:Stop()
    self.lineEffectDelay = nil
  end
end

function UILWSaveGirlView:OnLineEffectEnd(index)
  if self.lineEffectList == nil then
    return
  end
  local lineEffect = self.lineEffectList[index]
  if lineEffect then
    lineEffect:SetActive(false)
  end
  local fg = self.fgList[index]
  if fg then
    fg:SetActive(true)
  end
  if self.fgEffectReq ~= nil then
    if not IsNull(self.fgEffectGo) then
      self.fgEffectGo.transform:SetParent(fg.transform)
      self.fgEffectGo.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      self.fgEffectGo:SetActive(false)
      self.fgEffectGo:SetActive(true)
    end
    return
  end
  self.fgEffectReq = self:GameObjectInstantiateAsync(fgEffectPath, function(req)
    if req.isError then
      return
    end
    self.fgEffectGo = req.gameObject
    local lastTimes = DataCenter.LWSaveGirlManager:GetLastTimes()
    local spineIndex = self.maxSaveTimes - lastTimes
    local fgComponent = self.fgList[spineIndex]
    if fgComponent then
      self.fgEffectGo.transform:SetParent(fgComponent.transform)
      self.fgEffectGo.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end
  end)
end

function UILWSaveGirlView:RefreshSpineState()
  local lastTimes = DataCenter.LWSaveGirlManager:GetLastTimes()
  if lastTimes == self.maxSaveTimes then
    self:PlaySpine("Chaixian_Idle", true)
  else
    local spineIndex = self.maxSaveTimes - lastTimes
    self:PlaySpine("Chaixian" .. spineIndex .. "_Idle", true)
  end
end

function UILWSaveGirlView:PlaySpine(anim, loop)
  self.cacheAnim = anim
  self.cacheLoop = loop
  if not IsNull(self.spine) then
    self.spine.AnimationState:SetAnimation(0, anim, loop)
  end
end

function UILWSaveGirlView:RefreshBottom()
  local lastTimes = DataCenter.LWSaveGirlManager:GetLastTimes()
  self.item_tip_newbies:SetText("")
  local dialogueIndex = 8 - lastTimes
  local dialogueKey = LuaEntry.DataConfig:TryGetStr("guide_save_girl", "k" .. dialogueIndex)
  self.middle.bubbleTips:SetText(Localization:GetString(dialogueKey))
  if self.dubHandle == nil and self.soundNameList and self.soundNameList[dialogueIndex - 2] then
    local guideFinish = true
    for i, v in ipairs(IgnoreGuideIds) do
      if not DataCenter.LWGuideFlowManager:ReadDone(v) then
        guideFinish = false
        break
      end
    end
    if guideFinish then
      self.dubHandle = DataCenter.LWSoundManager:PlayDub(self.soundNameList[dialogueIndex - 2])
    end
  end
  if lastTimes <= 0 then
    self.bottom.itemContent.gameObject:SetActive(false)
    self.bottom.btnUse.gameObject:SetActive(false)
    local txt = Localization:GetString("240504")
    self.bottom.itemTip:SetText(txt)
    self.bottom.itemTip.gameObject:SetActive(true)
    self.item_tip_newbies:SetText(txt)
    self.item_tip_newbies:SetActive(true)
    self.use_btn_newbies:SetActive(false)
    self.use_btn_red_dot_newbies:SetActive(false)
    if not self.delayTriggerFlow then
      local flowId = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k12")
      if not DataCenter.LWGuideFlowManager:ReadDone(flowId) then
        DataCenter.LWGuideFlowManager.Runner:Run(flowId)
      end
    else
      DataCenter.LWSaveGirlManager:PlayReward()
    end
  else
    local itemCount = DataCenter.ItemData:GetItemCount(self.costItemId)
    if 0 < itemCount then
      self.bottom.itemContent.gameObject:SetActive(true)
      self.bottom.itemCountText:SetText(itemCount .. "/1")
      self.bottom.btnUse.gameObject:SetActive(true)
      local txt = Localization:GetString("240503")
      self.bottom.btnUseText:SetText(txt)
      self.bottom.itemTip.gameObject:SetActive(false)
      self.item_tip_newbies:SetActive(false)
      self.use_btn_newbies:SetActive(true)
      self.use_text_newbies:SetText(txt)
      self.item_count_newbies:SetText(itemCount)
      self.use_btn_red_dot_newbies:SetActive(true)
    else
      self.bottom.itemContent.gameObject:SetActive(true)
      self.bottom.itemCountText:SetText("<color=#FF0000>" .. itemCount .. "</color>/1")
      local txt = Localization:GetString("240501")
      self.bottom.itemTip:SetText(txt)
      self.bottom.itemTip.gameObject:SetActive(true)
      self.bottom.btnUse.gameObject:SetActive(true)
      local txtUse = Localization:GetString("240502")
      self.bottom.btnUseText:SetText(txtUse)
      self.item_tip_newbies:SetText(txt)
      self.item_tip_newbies:SetActive(true)
      self.use_btn_newbies:SetActive(true)
      self.use_text_newbies:SetText(txtUse)
      self.item_count_newbies:SetText(itemCount)
      self.use_btn_red_dot_newbies:SetActive(false)
    end
    DataCenter.LWSaveGirlManager:PlayReward()
  end
end

function UILWSaveGirlView:OnGirlIconBtnClick()
end

function UILWSaveGirlView:ClearDubHandle()
  if self.dubHandle ~= nil then
    DataCenter.LWSoundManager:FadeOutAndPlayMusic(self.dubHandle, 0.1)
    self.dubHandle = nil
  end
end

return UILWSaveGirlView
