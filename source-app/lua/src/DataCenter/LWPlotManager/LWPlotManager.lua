local LWPlotManager = BaseClass("LWPlotManager")
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local Bubble = require("DataCenter.LWPlotManager.LWPlotBubble")
local EmojiBubble = require("DataCenter.LWPlotManager.LWPlotEmojiBubble")
local UI_BUBBLE_PATH = "Assets/Main/Prefabs/UI/UILWPlot/UILWPlotBubble.prefab"
local UI_EMOJI_BUBBLE_PATH = "Assets/Main/Prefabs/UI/UILWPlot/UILWPlotEmojiBubble.prefab"

function LWPlotManager:__init()
  self.currPlotGroupId = nil
  self.currPlotContext = nil
  self.waitingQueue = {}
  self.activedBubbleList = {}
  self.activedEmojiBubbleList = {}
  self.activedBubbleOnlyIdMap = {}
  self.cacheLoadingOnlyBubbleId = {}
  self.cacheLoadingHandleMap = {}
  self.tempSaveDic = {}
  EventManager:GetInstance():AddListener(EventId.PlayPlotGroup, self.OnPlayPlotGroup)
  EventManager:GetInstance():AddListener(EventId.PlayPlotBubble, self.OnPlayPlotBubble)
  EventManager:GetInstance():AddListener(EventId.PlayPlotBubbleRandomly, self.OnPlayPlotBubbleRandomly)
  EventManager:GetInstance():AddListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  EventManager:GetInstance():AddListener(EventId.PlotViewClosedAbnormally, self.OnPlotViewClosedAbnormally)
  EventManager:GetInstance():AddListener(EventId.PlotViewCloseTemp, self.OnPlotViewCloseTemp)
  EventManager:GetInstance():AddListener(EventId.PlotGroupChoose, self.OnPlotGroupChoose)
  EventManager:GetInstance():AddListener(EventId.GF_enter_city, self.ClearAllBubbles)
  EventManager:GetInstance():AddListener(EventId.GF_enter_world, self.ClearAllBubbles)
  EventManager:GetInstance():AddListener(EventId.GF_goto_pve_battle, self.ClearAllBubbles)
  EventManager:GetInstance():AddListener(EventId.PlayEmojiBubble, self.OnPlayPlotEmojiBubble)
  EventManager:GetInstance():AddListener(EventId.PlayPlotBubbleOnlyId, self.OnPlayPlotBubbleOnlyId)
  EventManager:GetInstance():AddListener(EventId.RemovePlotBubbleById, self.OnRemovePlotBubbleById)
end

function LWPlotManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.PlayPlotGroup, self.OnPlayPlotGroup)
  EventManager:GetInstance():RemoveListener(EventId.PlayPlotBubble, self.OnPlayPlotBubble)
  EventManager:GetInstance():RemoveListener(EventId.PlayPlotBubbleRandomly, self.OnPlayPlotBubbleRandomly)
  EventManager:GetInstance():RemoveListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  EventManager:GetInstance():RemoveListener(EventId.PlotViewClosedAbnormally, self.OnPlotViewClosedAbnormally)
  EventManager:GetInstance():RemoveListener(EventId.PlotViewCloseTemp, self.OnPlotViewCloseTemp)
  EventManager:GetInstance():RemoveListener(EventId.PlotGroupChoose, self.OnPlotGroupChoose)
  EventManager:GetInstance():RemoveListener(EventId.GF_enter_city, self.ClearAllBubbles)
  EventManager:GetInstance():RemoveListener(EventId.GF_enter_world, self.ClearAllBubbles)
  EventManager:GetInstance():RemoveListener(EventId.GF_goto_pve_battle, self.ClearAllBubbles)
  EventManager:GetInstance():RemoveListener(EventId.PlayEmojiBubble, self.OnPlayPlotEmojiBubble)
  EventManager:GetInstance():RemoveListener(EventId.PlayPlotBubbleOnlyId, self.OnPlayPlotBubbleOnlyId)
  EventManager:GetInstance():RemoveListener(EventId.RemovePlotBubbleById, self.OnRemovePlotBubbleById)
  self.ClearAllBubbles()
  self.curPlotCallback = nil
  self.currPlotGroupId = nil
  self.currPlotContext = nil
  self.waitingQueue = nil
  self.activedBubbleList = nil
  self.activedEmojiBubbleList = nil
  self.activedBubbleOnlyIdMap = nil
  self.cacheLoadingOnlyBubbleId = nil
  self.cacheLoadingHandleMap = nil
end

function LWPlotManager:Startup()
end

function LWPlotManager:__PlayDialog(playContext)
  self.currPlotGroupId = tonumber(playContext.plotGroupId)
  self.currPlotUid = playContext.uid or playContext.plotGroupId
  self.curPlotCallback = playContext.callback
  self.currPlotContext = playContext
  playContext.step = self.tempSaveDic[self.currPlotUid]
  PostEventLog.Track(PostEventLog.Defines.PlotGroupStart, {
    plotGroupId = tostring(playContext.plotGroupId)
  })
  local openParam = playContext.hideMainUI and {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  } or {anim = false}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlot, openParam, playContext.plotGroupId, playContext)
end

function LWPlotManager.OnPlayPlotGroup(playContext)
  if CS.CommonUtils.IsDebug() and (GMUtils.GetBool("DEBUG_JUMP_ALL_PLOT", false) or Setting:GetBool("DEBUG_JUMP_ALL_PLOT", false)) then
    return
  end
  local self = DataCenter.LWPlotManager
  if self.currPlotGroupId ~= nil then
    table.insert(self.waitingQueue, playContext)
  else
    self:__PlayDialog(playContext)
  end
end

function LWPlotManager.OnPlotGroupDone(plotGroupId)
  local self = DataCenter.LWPlotManager
  if self.currPlotGroupId and tonumber(plotGroupId) ~= self.currPlotGroupId then
    Logger.LogError("PlayDialogDone Error: plotGroupId not match -> " .. tostring(plotGroupId) .. " vs " .. tostring(self.currPlotGroupId))
    return
  end
  local UIMainAnim
  if self.currPlotContext and self.currPlotContext.UIMainAnim then
    UIMainAnim = self.currPlotContext.UIMainAnim
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlot, {anim = true, UIMainAnim = UIMainAnim})
  self.currPlotGroupId = nil
  self.currPlotContext = nil
  self.SaveStep(self.currPlotUid, nil)
  self.currPlotUid = nil
  PostEventLog.Track(PostEventLog.Defines.PlotGroupDone, {
    plotGroupId = tostring(plotGroupId)
  })
  EventManager:GetInstance():Broadcast(EventId.GF_plot_group_done, plotGroupId)
  if self.curPlotCallback then
    self.curPlotCallback()
    self.curPlotCallback = nil
  end
  if #self.waitingQueue > 0 then
    local playContext = self.waitingQueue[1]
    table.remove(self.waitingQueue, 1)
    self:__PlayDialog(playContext)
  end
end

function LWPlotManager.OnPlotViewClosedAbnormally(plotGroupId)
  local self = DataCenter.LWPlotManager
  if self.currPlotGroupId then
    local cur = self.currPlotGroupId
    self.currPlotGroupId = nil
    self.currPlotContext = nil
    self.currPlotUid = nil
    if cur ~= plotGroupId then
      Logger.LogError("LWPlotManager.OnPlotViewClosedAbnormally cur : " .. tonumber(cur) .. " close : " .. tonumber(plotGroupId))
    end
  end
end

function LWPlotManager.SaveStep(uid, currStep)
  local self = DataCenter.LWPlotManager
  if currStep then
    self.tempSaveDic[uid] = currStep
  elseif self.tempSaveDic[uid] then
    self.tempSaveDic[uid] = nil
  end
end

function LWPlotManager.OnPlotViewCloseTemp(currStep)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlot, {
    anim = true,
    UIMainAnim = UIMainAnim
  })
  local self = DataCenter.LWPlotManager
  if not self.currPlotGroupId then
    return
  end
  self.SaveStep(self.currPlotUid, currStep)
  self.OnPlotViewClosedAbnormally(self.currPlotGroupId)
end

function LWPlotManager.OnPlotGroupChoose(index)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlot, {
    anim = true,
    UIMainAnim = UIMainAnim
  })
  local self = DataCenter.LWPlotManager
  if self.currPlotUid and self.currPlotContext and self.currPlotContext.choose then
    local info = self.currPlotContext.choose[index]
    if info and info.chooseId then
      SFSNetwork.SendMessage(MsgDefines.VisitorSeasonChoose, self.currPlotUid, info.chooseId)
    end
  end
  self.OnPlotViewClosedAbnormally(self.currPlotGroupId)
end

function LWPlotManager.TryCheckIsWorldBubble(playContext)
  if not playContext then
    return
  end
  if playContext.mode == "3D" and playContext.pointIndex and playContext.pointIndex > 0 and playContext.playerInfo then
    return true
  end
  return false
end

function LWPlotManager.OnPlayPlotBubble(playContext, onlyId)
  local self = DataCenter.LWPlotManager
  local plotData = playContext.fakePlotMeta
  if plotData == nil then
    plotData = LocalController:instance():getLine("lw_plot", playContext.plotId)
    if plotData == nil then
      Logger.LogError("\229\137\167\230\131\133\229\175\185\232\175\157\230\149\176\230\141\174\228\184\141\229\173\152\229\156\168\239\188\140plotId = " .. tostring(playContext.plotId))
      return
    end
  end
  if playContext.anchor == nil then
    playContext.anchor = Vector3.zero
  end
  if playContext.mode == nil then
    playContext.mode = "2D"
  end
  if playContext.mode ~= "2D" and playContext.mode ~= "2DFollow" and playContext.mode ~= "2DFollowWorld" and playContext.mode ~= "3D" and playContext.mode ~= "3DFollow" then
    Logger.LogError("\229\137\167\230\131\133\229\175\185\232\175\157\230\168\161\229\188\143\233\148\153\232\175\175\239\188\140mode = " .. tostring(playContext.mode))
    return
  end
  if LWPlotManager.TryCheckIsWorldBubble(playContext) and DisplaySettings and not DisplaySettings.ShowWorldPlotBubble() then
    return
  end
  if onlyId then
    local plotId = playContext.plotId
    if self.activedBubbleOnlyIdMap[plotId] then
      self.activedBubbleOnlyIdMap[plotId].timer = plotData.duration
      return
    end
    if self.cacheLoadingOnlyBubbleId[plotId] then
      return
    end
    self.cacheLoadingOnlyBubbleId[plotId] = true
  end
  local bubbleHandle = CS.GameEntry.Resource:InstantiateAsync(UI_BUBBLE_PATH)
  self.cacheLoadingHandleMap[bubbleHandle] = true
  bubbleHandle:completed("+", function(handle)
    self.cacheLoadingHandleMap[handle] = nil
    CommonUtil.CallAutoArabicMirrorManually(handle)
    if onlyId then
      local plotId = playContext.plotId
      if not self.cacheLoadingOnlyBubbleId[plotId] then
        handle:Destroy()
        return
      end
      self.cacheLoadingOnlyBubbleId[plotId] = nil
    end
    local bubble
    local ok, msg = xpcall(function()
      bubble = Bubble.New({
        handle,
        plotData,
        playContext.anchor,
        playContext.playerInfo,
        playContext.pointUuid,
        playContext.headType
      })
      if playContext.mode == "2D" then
        bubble.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Info.Name).transform)
        bubble:Display2D(playContext.screenRatioFix)
      elseif playContext.mode == "2DFollow" then
        local layerName = UILayer.Info.Name
        if not string.IsNullOrEmpty(playContext.uiLayer) then
          layerName = playContext.uiLayer
        end
        bubble.transform:SetParent(UIManager:GetInstance():GetLayer(layerName).transform)
        bubble:Display2DFollow(playContext.followTarget, false)
      elseif playContext.mode == "2DFollowWorld" then
        bubble.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Info.Name).transform)
        bubble:Display2DFollow(playContext.followTarget, true)
      elseif playContext.mode == "3D" then
        bubble.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.World.Name).transform)
        bubble:Display3D()
      elseif playContext.mode == "3DFollow" then
        bubble.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.World.Name).transform)
        bubble:Display3DFollow(playContext.followTarget)
      end
    end, debug.traceback)
    if ok and bubble ~= nil then
      bubble.timer = plotData.duration
      table.insert(self.activedBubbleList, bubble)
      if #self.activedBubbleList == 1 then
        UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
      end
    else
      Logger.LogError(msg)
      ok, msg = xpcall(function()
        if bubble ~= nil then
          bubble:Dispose()
        end
      end, debug.traceback)
      if not ok and handle and not IsNull(handle.gameObject) then
        handle.gameObject:SetActive(false)
      end
    end
    if onlyId then
      bubble.onlyId = true
      self.activedBubbleOnlyIdMap[playContext.plotId] = bubble
    end
  end)
end

function LWPlotManager.OnPlayPlotBubbleOnlyId(playContext)
  local self = DataCenter.LWPlotManager
  self.OnPlayPlotBubble(playContext, true)
end

function LWPlotManager.OnRemovePlotBubbleById(plotId)
  local self = DataCenter.LWPlotManager
  self.cacheLoadingOnlyBubbleId[plotId] = nil
  local bubble = self.activedBubbleOnlyIdMap[plotId]
  if bubble then
    bubble.timer = 0
  end
end

local _plotGroupDatasCache = {}

function LWPlotManager.OnPlayPlotBubbleRandomly(playContext)
  local self = DataCenter.LWPlotManager
  local plotGroupId = playContext.plotGroupId
  if _plotGroupDatasCache[plotGroupId] == nil then
    local cache = {}
    for i = 1, 99 do
      local plotData = LocalController:instance():getLine("lw_plot", plotGroupId * 100 + i)
      if plotData == nil then
        break
      end
      table.insert(cache, plotData)
    end
    _plotGroupDatasCache[plotGroupId] = cache
  end
  if _plotGroupDatasCache[plotGroupId] == 0 or #_plotGroupDatasCache[plotGroupId] == 0 then
    Logger.LogError("\229\137\167\230\131\133\231\187\132\230\178\161\230\156\137\229\175\185\232\175\157\230\149\176\230\141\174\239\188\140plotGroupId = " .. tostring(plotGroupId))
    return
  end
  local plotData = _plotGroupDatasCache[plotGroupId][math.random(1, #_plotGroupDatasCache[plotGroupId])]
  playContext.plotId = plotData.id
  self.OnPlayPlotBubble(playContext)
end

function LWPlotManager.OnUpdate()
  local self = DataCenter.LWPlotManager
  for i = #self.activedBubbleList, 1, -1 do
    local bubble = self.activedBubbleList[i]
    bubble.timer = bubble.timer - Time.deltaTime
    if bubble.timer <= 0 then
      if bubble.onlyId then
        self.activedBubbleOnlyIdMap[bubble.plotId] = nil
      end
      table.remove(self.activedBubbleList, i)
      bubble:Dispose()
    else
      bubble:OnUpdate()
    end
  end
  if #self.activedBubbleList == 0 then
    UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  end
end

function LWPlotManager:OnEmojiUpdate()
  local self = DataCenter.LWPlotManager
  for i = #self.activedEmojiBubbleList, 1, -1 do
    local bubble = self.activedEmojiBubbleList[i]
    bubble.timer = bubble.timer - Time.deltaTime
    if bubble.timer <= 0 then
      table.remove(self.activedEmojiBubbleList, i)
      bubble:Dispose()
    else
      bubble:OnUpdate()
    end
  end
  if #self.activedEmojiBubbleList == 0 then
    UpdateManager:GetInstance():RemoveUpdate(self.OnEmojiUpdate)
  end
end

function LWPlotManager.ClearAllBubbles()
  local self = DataCenter.LWPlotManager
  if #self.activedBubbleList > 0 then
    for i = 1, #self.activedBubbleList do
      self.activedBubbleList[i]:Delete()
    end
    self.activedBubbleList = {}
    UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  end
  if 0 < #self.activedEmojiBubbleList then
    for i = 1, #self.activedEmojiBubbleList do
      self.activedEmojiBubbleList[i]:Delete()
    end
    self.activedEmojiBubbleList = {}
    UpdateManager:GetInstance():RemoveUpdate(self.OnEmojiUpdate)
  end
  for handle, _ in pairs(self.cacheLoadingHandleMap) do
    if not IsNull(handle) then
      handle:Destroy()
    end
    self.cacheLoadingHandleMap = {}
  end
  pcall(function()
    local transform = UIManager:GetInstance():GetLayer(UILayer.World.Name).transform
    local childCount = transform.childCount
    for i = 0, childCount - 1 do
      transform:GetChild(i):SetActive(false)
    end
  end)
end

function LWPlotManager.OnPlayPlotEmojiBubble(playContext)
  local self = DataCenter.LWPlotManager
  local emojiData = LocalController:instance():getLine(TableName.LW_EMOJI, playContext.emojiId)
  if emojiData == nil then
    Logger.LogError("emojiId not exist ! " .. playContext.emojiId)
    return
  end
  if playContext.anchor == nil then
    playContext.anchor = Vector3.zero
  end
  if playContext.mode == nil then
    playContext.mode = "2D"
  end
  if playContext.mode ~= "2D" and playContext.mode ~= "2DFollow" and playContext.mode ~= "2DFollowWorld" and playContext.mode ~= "3D" and playContext.mode ~= "3DFollow" then
    Logger.LogError("emoji bubble mode error ! = " .. tostring(playContext.mode))
    return
  end
  local bubbleHandle = CS.GameEntry.Resource:InstantiateAsync(UI_EMOJI_BUBBLE_PATH)
  self.cacheLoadingHandleMap[bubbleHandle] = true
  bubbleHandle:completed("+", function(handle)
    self.cacheLoadingHandleMap[handle] = nil
    local bubble = EmojiBubble.New({
      handle,
      emojiData,
      playContext.anchor,
      playContext.rotation
    })
    if playContext.mode == "2D" then
      bubble.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Info.Name).transform)
      bubble:Display2D(playContext.screenRatioFix)
    elseif playContext.mode == "2DFollow" then
      bubble.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Info.Name).transform)
      bubble:Display2DFollow(playContext.followTarget, false)
    elseif playContext.mode == "2DFollowWorld" then
      bubble.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Info.Name).transform)
      bubble:Display2DFollow(playContext.followTarget, true)
    elseif playContext.mode == "3D" then
      bubble.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.World.Name).transform)
      bubble:Display3D()
    elseif playContext.mode == "3DFollow" then
      bubble.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.World.Name).transform)
      bubble:Display3DFollow(playContext.followTarget)
    end
    bubble.timer = playContext.duration or 3
    table.insert(self.activedEmojiBubbleList, bubble)
    if #self.activedEmojiBubbleList == 1 then
      UpdateManager:GetInstance():AddUpdate(self.OnEmojiUpdate)
    end
  end)
end

function LWPlotManager:CheckPlotValidity()
  local uiPlotView = UIManager:GetInstance():GetWindow(UIWindowNames.UILWPlot)
  if uiPlotView == nil and self.currPlotGroupId ~= nil then
    self.currPlotUid = nil
    self.currPlotGroupId = nil
    self.waitingQueue = {}
  end
end

function LWPlotManager:IsPlotPlaying(plotId)
  if plotId then
    local uiPlotView = UIManager:GetInstance():GetWindow(UIWindowNames.UILWPlot)
    return uiPlotView ~= nil and self.currPlotGroupId == plotId
  end
  return self.currPlotGroupId ~= nil
end

return LWPlotManager
