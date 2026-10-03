local DispatchTaskItem = BaseClass("DispatchTaskItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local go_bg_path = "GoBg"
local got_bg_path = "GotBg"
local icon_bg_path = "IconBg"
local icon_path = "IconBg/Icon"
local task_level_path = "IconBg/taskLevel"
local star_path = "star"
local desc_path = "DescRoot/Desc"
local reward_content_path = "RewardScrollView/Viewport/RewardContent"
local go_btn_path = "Btns/GoBtn"
local go_btn_text_path = "Btns/GoBtn/GoBtnText"
local receive_btn_path = "Btns/ReceiveBtn"
local cd_text_path = "Btns/time/cdText"
local duigou_img_path = "duigouImg"
local perpect_text_path = "perpectText"
local time_path = "Btns/time"
local steal_img_path = "stealImg"
local ui_player_head_path = "UIPlayerHead"
local star_list_path = "Btns/Title/starList"
local color_bg_path = "Btns/Title/ColorBg"
local title_path = "Btns/Title"
local follow_img_path = "followImg"
local follow_txt_path = "followImg/followTxt"
local quality_icon_path = "DescRoot/QualityIcon"
local ui_eff_sweep_point_path = "EffectPoint"
local ui_eff_sweep_point_normal_path = "EffectPoint_Normal"

function DispatchTaskItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DispatchTaskItem:OnDestroy()
  self:DeleteTimer()
  self:ClearContent()
  self:ClearEffect()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DispatchTaskItem:ComponentDefine()
  self.go_bg = self:AddComponent(UIButton, go_bg_path)
  self.go_bg:SetOnClick(function()
    self:OnBgClick()
  end)
  self.got_bg = self:AddComponent(UIImage, got_bg_path)
  self.icon_bg = self:AddComponent(UIImage, icon_bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.star = self:AddComponent(UIImage, star_path)
  self.descText = self:AddComponent(UIText, desc_path)
  self.task_level = self:AddComponent(UIText, task_level_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.go_btn_text = self:AddComponent(UIText, go_btn_text_path)
  self.receive_btn = self:AddComponent(UIButton, receive_btn_path)
  self.receive_btn:SetOnClick(function()
    self:OnReceiveClick()
  end)
  self.cd_text_root = self:AddComponent(UIBaseContainer, time_path)
  self.cd_text = self:AddComponent(UIText, cd_text_path)
  self.duigou_img = self:AddComponent(UIImage, duigou_img_path)
  self.perpect_text = self:AddComponent(UIText, perpect_text_path)
  self.steal_img = self:AddComponent(UIButton, steal_img_path)
  self.steal_img:SetOnClick(function()
    self:OnStealImgClick()
  end)
  self.player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.star_list = self:AddComponent(UIBaseContainer, star_list_path)
  self.starImgList = {}
  for i = 1, 5 do
    local starImg = self:AddComponent(UIImage, "Btns/Title/starList/star" .. i)
    table.insert(self.starImgList, starImg)
  end
  self.player_head:SetEnableClickShowInfo(true, true)
  self.starRoot = self:AddComponent(UIBaseContainer, title_path)
  self.color_bg = self:AddComponent(UIImage, color_bg_path)
  self.follow_img = self:AddComponent(UIButton, follow_img_path)
  self.follow_img:SetOnClick(function()
    self:OnFollowImgClick()
  end)
  self.follow_txt = self:AddComponent(UITextMeshProUGUIEx, follow_txt_path)
  self.effectSweepOrange = self:AddComponent(UIVfx, ui_eff_sweep_point_path, VfxAssets.DispatchTaskSweepLight, {
    lifeType = UIVfxLifeType.DestroyAfterOnce
  })
  self.effectSweepNormal = self:AddComponent(UIVfx, ui_eff_sweep_point_normal_path, VfxAssets.DispatchTaskSweepLightNormal, {
    lifeType = UIVfxLifeType.DestroyAfterOnce
  })
  self.quality_icon = self:AddComponent(UIImage, quality_icon_path)
end

function DispatchTaskItem:ComponentDestroy()
  self.starImgList = nil
  self.go_bg = nil
  self.got_bg = nil
  self.icon_bg = nil
  self.icon = nil
  self.star = nil
  self.descText = nil
  self.reward_content = nil
  self.go_btn = nil
  self.receive_btn = nil
  self.cd_text = nil
  self.duigou_img = nil
  self.perpect_text = nil
  self.go_btn_text = nil
  self.steal_img = nil
  self.follow_img = nil
  self.follow_txt = nil
  self.quality_icon = nil
end

function DispatchTaskItem:DataDefine()
  self.infos = {}
  self.itemReqs = {}
  self.itemList = {}
  self.itemGoList = {}
end

function DispatchTaskItem:DataDestroy()
  self.infos = nil
  self.itemReqs = nil
  self.itemList = nil
  self.itemGoList = nil
end

function DispatchTaskItem:OnEnable()
  base.OnEnable(self)
end

function DispatchTaskItem:OnDisable()
  base.OnDisable(self)
end

function DispatchTaskItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DispatchTaskUpdateFollowCount, self.OnDispatchTaskUpdateFollowCount)
  self:AddUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
end

function DispatchTaskItem:OnRemoveListener()
  self:RemoveUIListener(EventId.DispatchTaskUpdateFollowCount, self.OnDispatchTaskUpdateFollowCount)
  self:RemoveUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  base.OnRemoveListener(self)
end

function DispatchTaskItem:RefreshState(is_finish)
  self.goBtn:SetActive(not is_finish)
  self.receiveBtn:SetActive(is_finish)
end

function DispatchTaskItem:ClearContent()
  if table.count(self.itemList) > 0 then
    self.reward_content:RemoveComponents(UICommonResItem)
    self.itemList = nil
  end
  self.itemGoList = nil
  if 0 < table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      if req ~= nil then
        self:GameObjectDestroy(req)
      end
    end
    self.itemReqs = nil
  end
end

function DispatchTaskItem:RefreshReward(rewardList)
  self.rewardList = rewardList
  local prefabPath = "Assets/Main/Prefabs/UI/LWQuest/ChapterTaskRewardItem.prefab"
  local rewardCount = #rewardList
  local itemCount = #self.itemList
  local itemReqCount = #self.itemReqs
  local count = Mathf.Min(rewardCount, itemCount)
  for i = 1, count do
    local item = self.itemList[i]
    local data = rewardList[i]
    local buildAddNum, itemId = DataCenter.ActDispatchTaskDataManager:GetBuildAddRewardInfo()
    local cellData = data
    if self.tab == 1 and 0 < buildAddNum and cellData.itemId == itemId then
      cellData = DeepCopy(data)
      cellData.count = cellData.count + buildAddNum
      cellData.isShowArrow = true
    end
    item:ReInit(cellData)
    local go = self.itemGoList[i]
    if go then
      go:SetActive(true)
    end
  end
  for i = count + 1, itemCount do
    local go = self.itemGoList[i]
    if go then
      go:SetActive(false)
    end
  end
  for i = itemReqCount + 1, rewardCount do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(prefabPath, function(req)
      if req.isError then
        return
      end
      local scale = 1.1
      local item = req.gameObject
      item.name = "reward_item" .. i
      item.transform:GetChild(0).gameObject.name = "obj" .. i
      item.transform:GetChild(0).gameObject:SetActive(true)
      item.transform:SetParent(self.reward_content.transform)
      item.transform:Set_localScale(scale, scale, 1)
      local cell = self.reward_content:AddComponent(UICommonResItem, item.name .. "/obj" .. i)
      self.itemList[i] = cell
      self.itemGoList[i] = item
      local data = self.rewardList[i]
      if data == nil then
        item:SetActive(false)
        return
      end
      item:SetActive(true)
      local buildAddNum, itemId = DataCenter.ActDispatchTaskDataManager:GetBuildAddRewardInfo()
      local cellData = data
      if self.tab == 1 and 0 < buildAddNum and cellData.itemId == itemId then
        cellData = DeepCopy(data)
        cellData.count = cellData.count + buildAddNum
        cellData.isShowArrow = true
      end
      cell:ReInit(cellData)
    end)
  end
end

function DispatchTaskItem:SetData(params, tab)
  self.infos = params
  self.tab = tab
  self.go_btn_text:SetLocalText(tab == 1 and 110003 or 456208)
  self.quality_icon:SetActive(tab == 1)
  self:RefreshShow()
end

function DispatchTaskItem:RefreshShow()
  if self.infos and self.infos.cfg then
    if not string.IsNullOrEmpty(self.infos.cfg.icon) then
      self.icon:LoadSprite(self.infos.cfg.icon)
    end
    local quality_icon = QualityImagePath[self.infos.cfg.color]
    self.quality_icon:LoadSprite(quality_icon)
    self.quality_icon:SetNativeSize()
    self.color_bg:LoadSprite(quality_icon)
    self.color_bg:SetNativeSize()
    self.icon_bg:LoadSprite(UIUtil.GetItemQualityBg(self.infos.cfg.color))
    local special = self.infos.cfg.is_special == 1
    self.star:SetActive(special)
    self.task_level:SetLocalText(2010379, self.infos.cfg.level or 1)
    if self.tab == 1 then
      self.descText:SetLocalText(self.infos.cfg.name)
      if not self.infos.cfg.parsed_reward then
        self.infos.cfg.parsed_reward = DataCenter.RewardManager:ParseRewardsStr(self.infos.cfg.base_reward_show)
      end
      local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.DispatchTreasure.Type)
      if DataCenter.ExplorerTreasureManager:IsOpen() and not self.infos.cfg.explorerTreasureRewardBox then
        local quality = self.infos.cfg.color
        if self.infos.cfg.is_special == 1 then
          quality = 6
        end
        local rewardBox = DataCenter.ExplorerTreasureManager:GetRewardBoxInfoByDispatchTask(quality)
        if rewardBox then
          rewardBox = DataCenter.RewardManager:ParseRewardsStr(rewardBox)
          table.insert(self.infos.cfg.parsed_reward, 1, rewardBox[1])
          self.infos.cfg.explorerTreasureRewardBox = rewardBox
        end
      end
      if actList and 0 < #actList and not self.infos.cfg.parsed_mapReward then
        self.infos.cfg.parsed_mapReward = DataCenter.RewardManager:ParseRewardsStr(self.infos.cfg.map_fragments_show)
        if self.infos.cfg.parsed_mapReward then
          for index, value in ipairs(self.infos.cfg.parsed_mapReward) do
            table.insert(self.infos.cfg.parsed_reward, 1, value)
          end
        end
      end
      if not string.IsNullOrEmpty(self.infos.conditionIndex) and not string.IsNullOrEmpty(self.infos.cfg.condition_reward_show) and not self.infos.cfg.parsed_actExtraReward then
        local conditionIndexStrList = string.split(self.infos.conditionIndex, ";")
        local actExtraRewardList = {}
        for _, v in ipairs(conditionIndexStrList) do
          local conditionIndex = toInt(v)
          local rewardInfoList = string.split(self.infos.cfg.condition_reward_show, "|")
          for i, v in ipairs(rewardInfoList) do
            if i - 1 == conditionIndex then
              local rewardStrInfo = v
              if not string.IsNullOrEmpty(rewardStrInfo) then
                local actExtraReward = DataCenter.RewardManager:ParseRewardsStr(rewardStrInfo)
                if actExtraReward then
                  for index, value in ipairs(actExtraReward) do
                    table.insert(actExtraRewardList, 1, value)
                  end
                end
              end
            end
          end
        end
        self.infos.cfg.parsed_actExtraReward = actExtraRewardList
        for _, v in ipairs(self.infos.cfg.parsed_actExtraReward) do
          table.insert(self.infos.cfg.parsed_reward, 1, v)
        end
      end
      self:RefreshReward(self.infos.cfg.parsed_reward)
      self.effectSweepOrange:Stop()
      self.effectSweepNormal:Stop()
      if self.infos.isNeedPlayOrangeEffect then
        self.infos.isNeedPlayOrangeEffect = false
        self.effectSweepOrange:Replay()
      elseif self.infos.isNeedPlayNormalEffect then
        self.infos.isNeedPlayNormalEffect = false
        self.effectSweepNormal:Replay()
      end
    else
      self.descText:SetLocalText(456254)
      if not self.infos.cfg.parsed_aid_extra_reward then
        self.infos.cfg.parsed_aid_extra_reward = DataCenter.RewardManager:ParseRewardsStr(self.infos.cfg.aid_extra_reward_show)
      end
      self:RefreshReward(self.infos.cfg.parsed_aid_extra_reward)
    end
    self.go_btn:SetActive(true)
    self.receive_btn:SetActive(false)
    self.go_bg:SetActive(true)
    self.got_bg:SetActive(false)
    self.duigou_img:SetActive(false)
    self.perpect_text:SetActive(false)
    self.cd_text_root:SetActive(false)
    self.steal_img:SetActive(false)
    local completionTime = self.infos.completionTime
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.tab == 1 then
      if completionTime == 0 then
        self:DeleteTimer()
      elseif completionTime <= now then
        if self.infos.rewarded == 1 then
          self.go_btn:SetActive(false)
          self.go_bg:SetActive(false)
          self.got_bg:SetActive(true)
          if #self.infos.stealInfoList == 0 then
            self.duigou_img:SetActive(true)
          else
            self.steal_img:SetActive(true)
          end
        else
          self.go_btn:SetActive(false)
          self.receive_btn:SetActive(true)
        end
      else
        self.cd_text_root:SetActive(true)
        self.go_btn:SetActive(false)
        self:AddTimer()
        self:RefreshTime()
      end
    elseif completionTime == 0 then
    elseif completionTime <= now then
      if self.infos.rewarded == 1 then
      else
        self.go_btn:SetActive(true)
      end
    else
      self.cd_text_root:SetActive(true)
      self.go_btn:SetActive(false)
      self:AddTimer()
      self:RefreshTime()
    end
    self:RefreshFollowCount()
    if self.tab == 1 and special then
      self:ShowEffect()
    else
      self:ClearEffect()
    end
    if self.tab == 1 or self.infos.avatar == nil or self.infos.cfg == nil then
      self.player_head:SetActive(false)
      self.starRoot:SetActive(false)
      self.icon_bg:SetActive(true)
    else
      local sprites = DataCenter.ActDispatchTaskDataManager:GetStarSprites(self.infos.cfg.task_star)
      for i, starImg in ipairs(self.starImgList) do
        local sprite = sprites[i]
        if sprite == nil then
          starImg:SetActive(false)
        else
          starImg:LoadSprite(string.format(LoadPath.LWCommonPath, sprite))
          starImg:SetActive(true)
        end
      end
      self.player_head:SetActive(true)
      self.starRoot:SetActive(true)
      self.icon_bg:SetActive(false)
      self.player_head:ParseHeadInfo(self.infos.avatar)
      self.descText:SetText(self.infos.avatar.name or Localization:GetString(self.infos.cfg.name))
      self.follow_img:SetActive(false)
    end
  end
end

function DispatchTaskItem:RefreshFollowCount()
  if self.infos then
    local followCount = self.infos.followCount or 0
    if 0 < followCount then
      self.follow_img:SetActive(true)
      if 99 < followCount then
        self.follow_txt:SetText("(99+)")
      else
        self.follow_txt:SetText("(" .. followCount .. ")")
      end
    else
      self.follow_img:SetActive(false)
    end
  end
end

function DispatchTaskItem:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function DispatchTaskItem:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.RefreshTime, self, false, false, false)
  end
  self.timer:Start()
end

function DispatchTaskItem:RefreshTime()
  if self.infos == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.infos.completionTime - curTime
  if 0 < remainTime then
    self.cd_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.cd_text_root:SetActive(false)
    self:DeleteTimer()
    self:RefreshShow()
  end
end

function DispatchTaskItem:OnBgClick()
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  if LuaEntry.Player:IsInBlackRange() then
    return
  end
  self:TaskGotoWorld()
end

function DispatchTaskItem:OnGoClick()
  if self.tab == 1 then
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    if not LuaEntry.Player:AtHomeNow() then
      local isCrossServerSwitchOpen = DataCenter.ActDispatchTaskDataManager:IsCrossServerSwitchOpen()
      if not isCrossServerSwitchOpen then
        UIUtil.ShowTips(Localization:GetString("500021"))
        return
      end
    end
    if LuaEntry.Player:IsInBlackRange() then
      UIUtil.ShowMessage(Localization:GetString(457082))
    else
      self:TaskGotoWorld()
    end
  else
    local mgr = DataCenter.ActDispatchTaskDataManager
    local todayAssistNum = mgr:GetTodayAssistNum()
    local assistMax = toInt(mgr:GetDispatchSetting("aid_count"))
    if todayAssistNum < assistMax then
      SFSNetwork.SendMessage(MsgDefines.DispatchAssist, self.infos.uuid, self.infos.targetServer)
    else
      UIUtil.ShowTipsId(456225)
    end
  end
end

function DispatchTaskItem:TaskGotoWorld()
  local completionTime = self.infos.completionTime
  local allianceTaskTargetServer = self.infos.targetServer
  local isCrossServerSwitchOpen = DataCenter.ActDispatchTaskDataManager:IsCrossServerSwitchOpen()
  if completionTime == 0 and not isCrossServerSwitchOpen and not LuaEntry.Player:AtHomeNow() then
    UIUtil.ShowTips(Localization:GetString("500021"))
    return
  end
  local pointId = self.infos.pointId
  if pointId and 0 < pointId then
    GoToUtil.CloseAllWindows()
    local targetServer
    if isCrossServerSwitchOpen then
      if self.tab == 1 then
        targetServer = LuaEntry.Player:GetSelfServerId()
      else
        targetServer = allianceTaskTargetServer
      end
    elseif LuaEntry.Player.crossFightSrcServerId ~= -1 then
      targetServer = LuaEntry.Player.crossFightSrcServerId
    end
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), nil, nil, function()
      CS.SceneManager.World:UpdateViewRequest(true)
      GoToUtil.MoveToWorldPointAndOpen(pointId, nil, nil, targetServer)
    end, targetServer)
    if self.tab and self.tab == 2 then
      Logger.LogInfo("DispatchTask alliance click item : " .. tostring(pointId))
    end
  else
    self.view.targetJumpUuid = self.infos.uuid
    SFSNetwork.SendMessage(MsgDefines.DispatchPutPointInWorld, self.infos.uuid)
  end
end

function DispatchTaskItem:OnReceiveClick()
  DataCenter.ActDispatchTaskDataManager:TryRewardAll()
end

function DispatchTaskItem:OnStealImgClick()
  local list = self.infos.stealInfoList
  for _, v in ipairs(list) do
    if v.type == nil then
      v.type = 1
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskRecord, {anim = true}, list)
end

function DispatchTaskItem:ShowEffect()
  if not self.effectObj then
    self.effectObj = self:GameObjectInstantiateAsync(UIAssets.BattlePassEffect, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      local effectTransform = go.transform
      effectTransform:SetParent(self.icon_bg.transform)
      effectTransform:Set_localPosition(0, 0, 0)
      effectTransform:Set_localScale(1.42, 1.42, 1.42)
    end)
  end
end

function DispatchTaskItem:ClearEffect()
  if self.effectObj then
    self:GameObjectDestroy(self.effectObj)
    self.effectObj = nil
  end
end

function DispatchTaskItem:OnFollowImgClick()
  local tip = DataCenter.ActDispatchTaskDataManager:GetRandomFollowTip()
  if not string.IsNullOrEmpty(tip) then
    UIUtil.ShowTips(Localization:GetString(tip))
  end
end

function DispatchTaskItem:OnDispatchTaskUpdateFollowCount(uuid)
  if self.tab and self.tab == 1 and self.infos and self.infos.uuid == uuid then
    self:RefreshFollowCount()
  end
end

function DispatchTaskItem:OnPlotGroupDone(plotGroupId)
  if DataCenter.ActDispatchTaskDataManager.plotGroupId and plotGroupId == DataCenter.ActDispatchTaskDataManager.plotGroupId and DataCenter.ActDispatchTaskDataManager.guideTaskId == self.infos.cfgId and self.tab == 1 and self.go_btn:GetActive() then
    DataCenter.ActDispatchTaskDataManager:FinishPlot()
    local param = {}
    param.positionType = PositionType.Screen
    param.position = self.go_btn.transform.position + Vector3.New(50, -50, 0)
    param.isAutoClose = 1
    DataCenter.ArrowManager:ShowFingerArrow(param)
  end
end

return DispatchTaskItem
