local CollectRewardItem = BaseClass("CollectRewardItem", UIBaseContainer)
local base = UIBaseContainer
local monsterIcon_path = "UIPlayerHead/HeadIcon"
local monsterLv_path = "monsterLv"
local monsterName_path = "monsterLv/monsterName"
local rewardContainer_path = "ScrollView/Viewport/rewards"
local coodinateBtn_path = "topArena/CoodinateBtn"
local energyTxt_path = "topArena/energyIcon/energyTxt"
local normalIcon_path = "normalIcon"
local pvpImg_path = "pvpImg"
local typeImg_path = "typeImg"
local typePoint_path = "typePoint"
local typePointTxt_path = "typePoint/typePointTxt"
local Localization = CS.GameEntry.Localization
local CollectRewardType = _ENV.CollectRewardType
local limit_tips_btn_path = "limitTipsBtn"
local limit_tips_icon_path = "limitTipsBtn/icon"
local limit_detail_path = "limitTipsBtn/TipBox/LimitDetail"
local limit_tip_box_path = "limitTipsBtn/TipBox"
local energy_icon_path = "topArena/energyIcon"
local content_click_path = "NoReward/contentClick"
local bg_path = "bg"
local img_kuang_path = "img_kuang"
local img_icon_path = "img_kuang/img_icon"
local txt_count_path = "txt_count"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.RewardNodeList = {}
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.monsterIconContent = self:AddComponent(UIImage, "MonsterIcon")
  self.monsterIconN = self:AddComponent(CircleImage, "MonsterIcon/HeadIcon")
  self.monsterForeground = self:AddComponent(UIImage, "MonsterIcon/Foreground")
  self.playerHead = self:AddComponent(UIPlayerHead, monsterIcon_path)
  self.playerHeadFrame = self:AddComponent(UIImage, "UIPlayerHead/Image")
  self.playerHeadRoot = self:AddComponent(UIBaseContainer, "UIPlayerHead")
  self.noReward = self:AddComponent(UITextMeshProUGUIEx, "NoReward")
  self.monsterNameN = self:AddComponent(UIText, monsterName_path)
  self.coordinate = self:AddComponent(UITextMeshProUGUI, "topArena/CoodinateBtn/Coodinate")
  self.ScrollView = self:AddComponent(UIScrollRect, "ScrollView")
  self.img_kuang = self:AddComponent(UIImage, img_kuang_path)
  self.img_kuang:SetActive(false)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.txt_count = self:AddComponent(UITextMeshProUGUIEx, txt_count_path)
  self.txt_count:SetActive(false)
  self.rewardContainerN = self:AddComponent(UIBaseContainer, rewardContainer_path)
  self.noReward:OnPointerClick(function(eventData)
    if self.collectRewardData ~= nil then
      local theData = self.collectRewardData
      if theData.uuid ~= nil and theData.pointId ~= nil then
        local pointId = 0
        local world = CS.SceneManager.World
        if world then
          pointId = SceneUtils.WorldToTileIndex(world.CurTarget)
        end
        Logger.LogInfo(string.format("TryJump to killerId %s , %s from %s", tostring(theData.uuid), tostring(theData.pointId), tostring(pointId)))
      end
      if theData.expiredTime ~= nil and toInt(theData.expiredTime) <= UITimeManager:GetInstance():GetServerTime() then
        UIUtil.ShowTipsId("season_s4_monster_cardbox_tips01")
        TimerManager:GetInstance():DelayInvoke(function()
          EventManager:GetInstance():Broadcast(EventId.RefreshMonsterRewardBag)
        end, 0.1)
        return
      end
    end
    UIUtil.UseJumpLink(self.noReward, eventData, function(worldPointPos, serverId, worldId)
      local uiPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPointPos)
      local param = {}
      param.position = Vector3.New(uiPos.x, uiPos.y, uiPos.z)
      param.arrowType = ArrowType.Building
      param.positionType = PositionType.Screen
      param.isPanel = false
      param.isAutoClose = 2
      DataCenter.ArrowManager:ShowArrow(param)
    end)
  end)
  self.coodinateBtn = self:AddComponent(UIButton, coodinateBtn_path)
  self.coodinateBtn:SetOnClick(function()
    self:OnClickCoodinateBtn()
  end)
  self.energyTxt = self:AddComponent(UIText, energyTxt_path)
  self.normalIcon = self:AddComponent(UIImage, normalIcon_path)
  self.pvpImg = self:AddComponent(UIBaseContainer, pvpImg_path)
  self.typeImg = self:AddComponent(UIImage, typeImg_path)
  self.typePoint = self:AddComponent(UIImage, typePoint_path)
  self.typePointTxt = self:AddComponent(UIText, typePointTxt_path)
  self.energy_icon = self:AddComponent(UIImage, energy_icon_path)
  self.limit_tips_btn = self:AddComponent(UIButton, limit_tips_btn_path)
  self.limit_tips_icon = self:AddComponent(UIImage, limit_tips_icon_path)
  self.limit_detail = self:AddComponent(UIText, limit_detail_path)
  self.limit_tip_box = self:AddComponent(UIImage, limit_tip_box_path)
  self.limit_tips_btn:SetActive(false)
  self.limit_tip_box:SetActive(false)
  self.limit_tips_btn:SetOnClick(function()
    self.limit_tip_box:SetActive(true)
    self:Update1000MS()
    self.view:OnLimitTipsShown()
  end)
  self.content_click = self:AddComponent(UIButton, content_click_path)
  self.content_click:SetOnClick(function()
    if self.clickParam and self.clickParam.uuid then
      local data = {}
      data.uuid = self.clickParam.uuid
      data.serverId = self.clickParam.serverId
      data.objType = self.clickParam.objType
      data.worldId = self.clickParam.worldId
      SFSNetwork.SendMessage(MsgDefines.CheckObjExistsMessage, data)
    end
  end)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.monsterIconContent = nil
  self.monsterIconN = nil
  self.playerHead = nil
  self.monsterNameN = nil
  self.rewardContainerN = nil
  self.collectRewardData = nil
  self.coordinate = nil
  self.coodinateBtn = nil
  self.energyTxt = nil
  self.normalIcon = nil
  self.pvpImg = nil
  self.typeImg = nil
  self.typePoint = nil
  self.typePointTxt = nil
  self.energy_icon = nil
  self.content_click = nil
  self.img_kuang = nil
  self.img_icon = nil
  self.txt_count = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.SetItem)
  self:AddUIListener(EventId.CheckObjExistsEvent, self.OnObjExistsCallback)
  self:AddUIListener(EventId.CloseAllCollectRewardLimitTips, self.HideLimitTips)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.SetItem)
  self:RemoveUIListener(EventId.CheckObjExistsEvent, self.OnObjExistsCallback)
  self:RemoveUIListener(EventId.CloseAllCollectRewardLimitTips, self.HideLimitTips)
  base.OnRemoveListener(self)
end

function CollectRewardItem:CheckLimit(collectRewardData)
  local limitLevel = CollectLimitLevel.None
  local plunder_resource_now = collectRewardData.plunderValue
  local mainLv = DataCenter.BuildManager.MainLv
  local roleTemplate = DataCenter.RoleTemplateManager:GetTemplateByLevel(mainLv)
  if collectRewardData and collectRewardData.plunderValue then
    limitLevel = DataCenter.CollectRewardDataManager:GetCollectLimitLevel(plunder_resource_now)
  end
  if limitLevel == CollectLimitLevel.None then
    self.limit_tips_txt = nil
    self.limit_tips_btn:SetActive(false)
  elseif limitLevel == CollectLimitLevel.Red then
    local limit_tips_txt = "<color=#2A2830>" .. Localization:GetString("popUI_desc_001", string.GetFormattedStr2(plunder_resource_now)) .. "</color>"
    self.limit_tips_btn:SetActive(true)
    local msg = Localization:GetString("popUI_desc_002", toInt(roleTemplate.rate3 * 100))
    limit_tips_txt = limit_tips_txt .. [[

<color=#F53C3D>]] .. msg .. "</color>"
    self.limit_tips_icon:LoadSprite("Assets/Main/Sprites/UI/UIFormationDefence/dl_chuzheng_tanhaohong.png")
    self.limit_tips_txt = limit_tips_txt
  elseif limitLevel == CollectLimitLevel.Yellow then
    local limit_tips_txt = "<color=#2A2830>" .. Localization:GetString("popUI_desc_001", string.GetFormattedStr2(plunder_resource_now)) .. "</color>"
    self.limit_tips_btn:SetActive(true)
    local msg = Localization:GetString("popUI_desc_002", toInt(roleTemplate.rate2 * 100))
    limit_tips_txt = limit_tips_txt .. [[

<color=#EB9E0A>]] .. msg .. "</color>"
    self.limit_tips_icon:LoadSprite("Assets/Main/Sprites/UI/UIFormationDefence/dl_chuzheng_tanhaocheng.png")
    self.limit_tips_txt = limit_tips_txt
  end
end

local function SetItem(self, index, collectRewardData, collectRewardType)
  if collectRewardData then
    self.collectRewardData = collectRewardData
  elseif self.collectRewardData then
    collectRewardData = self.collectRewardData
  end
  if collectRewardType then
    self.collectRewardType = collectRewardType
  else
    collectRewardType = self.collectRewardType
  end
  self.index = index
  self.rewardList = nil
  self:CleanRewardShown()
  local pointId = toInt(collectRewardData.pointId)
  if 0 < pointId then
    local location = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
    location = string.format("<u>X:%s,Y:%s</u>", location.x, location.y)
    self.coordinate:SetText(location)
    self.coodinateBtn:SetActive(true)
  else
    self.coodinateBtn:SetActive(false)
  end
  local greenBgPath = "Assets/Main/Sprites/UI/UIFormationDefence/dl_jiangli_dikuang01.png"
  local redBgPath = "Assets/Main/Sprites/UI/UIFormationDefence/dl_jiangli_dikuang02.png"
  local kuang3Path = "Assets/Main/Sprites/UI/UIHeroCommon/cfm_yingxiong_touxiangkuang_fang_3.png"
  local kuangPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_touxiangkuang.png"
  local skillKuangPath = "Assets/Main/SeasonRes/S6/Sprites/CityAltar/FX_jitanzhengduozhan_jinengkuang.png"
  self.clickParam = nil
  self.content_click:SetActive(false)
  self.typePoint:LoadSprite(string.format(LoadPath.UIFormationDefencePath, "zyf_changzhulibao_biaoqian"))
  if collectRewardType == 1 then
    self.limit_tips_txt = nil
    self.limit_tips_btn:SetActive(false)
  else
    self:CheckLimit(collectRewardData)
  end
  self.normalIcon:SetActive(false)
  self.typeImg:SetActive(false)
  self.noRewardStr = nil
  self.dataExpiredTime = nil
  self.needShowTick = false
  self.monsterIconContent:SetActive(false)
  self.playerHead:SetActive(false)
  self.playerHeadRoot:SetActive(true)
  self.energy_icon:SetActive(true)
  self.monsterIconN:SetActive(true)
  self.monsterForeground:SetActive(true)
  self.rewardContainerN:SetActive(true)
  self.txt_count:SetActive(false)
  self.img_kuang:SetActive(false)
  self.monsterIconContent:LoadSprite("Assets/Main/Sprites/UI/UIDecoration/UIDecoration/cfm_zhujiemian_touxiangkuang_3.png")
  local type = collectRewardData.type
  if collectRewardType == 1 then
    local dailyDropTimes = DataCenter.SeasonDataManager.dailyDropTimes
    local dailyDropMaxTimes = toInt(GetTableData(TableName.WorldTreasure, 33, "daily_max", 5))
    local msgGo = Localization:GetString("208213") .. " " .. UIUtil.MakeJumpLink(toInt(collectRewardData.pointId))
    local noRewardStr = msgGo
    if 0 < dailyDropTimes and dailyDropTimes <= dailyDropMaxTimes then
      local msgTimeStr = Localization:GetString("snow_season_drop_UI1", dailyDropTimes, dailyDropMaxTimes)
      noRewardStr = msgTimeStr .. "\n" .. msgGo
    end
    if collectRewardData and collectRewardData.expiredTime then
      self.dataExpiredTime = toInt(collectRewardData.expiredTime)
    end
    self.noRewardStr = noRewardStr
    self.noReward:SetText(noRewardStr)
    self.monsterIconContent:SetActive(true)
    self.monsterIconN:SetActive(false)
    self.monsterForeground:SetActive(false)
    self.playerHeadRoot:SetActive(false)
    self.content_click:SetActive(false)
    self.rewardContainerN:SetActive(false)
    self.noReward:SetActive(true)
    self.ScrollView:SetEnable(false)
    local name, icon = "season_s4_monster_tips30", string.format(LoadPath.LWBattleFieldWinterDetailPath, "zyf_jianzhuxiangqing_icon9_huang.png")
    local temp = DataCenter.TreasureTemplateManager:GetTemplate(collectRewardData.cfgId)
    if temp and not string.IsNullOrEmpty(temp.name) then
      name = temp.name
    end
    self.name = name
    self.monsterIconContent:LoadSprite(icon)
    self.monsterNameN:SetLocalText(self.name)
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.bg:LoadSprite(greenBgPath)
    self.pvpImg:SetActive(false)
    self.typePoint:SetActive(true)
    self.energy_icon:SetActive(false)
    self.typePointTxt:SetLocalText("458557")
    self.typePoint:LoadSprite(string.format(LoadPath.UIFormationDefencePath, "zyf_changzhulibao_biaoqian"))
    self:Update1000MS()
  elseif collectRewardData.type == CollectRewardType.CARD_BOX_REWARD then
    self.noReward:SetText("")
    self.noReward:SetActive(false)
    self.monsterIconContent:SetActive(true)
    self.monsterIconN:SetActive(false)
    self.monsterForeground:SetActive(false)
    self.playerHeadRoot:SetActive(false)
    self.content_click:SetActive(false)
    local name, icon = "season_s4_monster_tips30", string.format(LoadPath.LWBattleFieldWinterDetailPath, "zyf_jianzhuxiangqing_icon9_huang.png")
    if collectRewardData.cfgId then
      local temp = DataCenter.TreasureTemplateManager:GetTemplate(collectRewardData.cfgId)
      if temp and not string.IsNullOrEmpty(temp.name) then
        name = temp.name
      end
    end
    self.name = name
    self.monsterIconContent:LoadSprite(icon)
    self.monsterNameN:SetLocalText(self.name)
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.bg:LoadSprite(greenBgPath)
    self.pvpImg:SetActive(false)
    self.typePoint:SetActive(true)
    self.energy_icon:SetActive(false)
    self.typePointTxt:SetLocalText("458557")
    self.typePoint:LoadSprite(string.format(LoadPath.UIFormationDefencePath, "zyf_changzhulibao_biaoqian"))
  elseif type == CollectRewardType.MONSTER then
    local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(collectRewardData.contentId)
    local icon = LoadPath.HeroIconsSmallPath .. monsterTemplate.pic
    self.monsterIconContent:SetActive(true)
    self.monsterIconN:LoadSprite(icon)
    local lvString = Localization:GetString("300665", monsterTemplate.level)
    local nameStr = Localization:GetString(monsterTemplate.name)
    self.monsterNameN:SetText(lvString .. " " .. nameStr)
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.bg:LoadSprite(greenBgPath)
    self.playerHeadFrame:LoadSprite(kuang3Path)
    self.pvpImg:SetActive(false)
    self.typePoint:SetActive(false)
  elseif collectRewardData.type == CollectRewardType.PLUNDER then
    self.bg:LoadSprite(redBgPath)
    self.playerHeadFrame:LoadSprite(kuangPath)
    self.playerHead:SetActive(true)
    local isWerewolf = false
    local userUid = collectRewardData.contentId
    if string.find(collectRewardData.contentId, "|", 1, true) then
      local arr = string.split(collectRewardData.contentId, "|")
      userUid = arr[1]
      if #arr == 2 then
        isWerewolf = UITimeManager:GetInstance():GetServerTime() < tonumber(arr[2])
      end
    end
    if isWerewolf then
      self.playerHead:ShowWerewolf()
      self.monsterNameN:SetLocalText(GameDialogDefine.WEREWOLF)
    else
      local user = ChatManager2:GetInstance().User:getChatUserInfo(userUid, true)
      if user then
        local uid2 = user.uid
        local pic2 = user.headPic
        local picVer2 = user.headPicVer
        self.playerHead:SetData(uid2, pic2, picVer2)
        local alAbbr2 = ""
        if not string.IsNullOrEmpty(user.allianceSimpleName) then
          alAbbr2 = "[" .. user.allianceSimpleName .. "]"
        end
        local name2 = alAbbr2 .. user.userName
        self.monsterNameN:SetText(name2)
        self.monsterNameN:SetColor(CollectRewardNameRed)
      end
    end
    self.pvpImg:SetActive(true)
    self.typePoint:SetActive(true)
    self.typePointTxt:SetLocalText(451019)
    self.typePoint:LoadSprite(string.format(LoadPath.UIFormationDefencePath, "zyf_changzhulibao_biaoqian_dark"))
  elseif collectRewardData.type == CollectRewardType.COLLECT or collectRewardData.type == CollectRewardType.ALLIANCE_RESOURCE_COLLECT then
    self.bg:LoadSprite(greenBgPath)
    self.playerHeadFrame:LoadSprite(kuangPath)
    local uid = LuaEntry.Player:GetUid()
    local pic = LuaEntry.Player:GetPic()
    local picVer = LuaEntry.Player.picVer
    self.playerHead:SetActive(true)
    self.playerHead:SetData(uid, pic, picVer)
    self.monsterNameN:SetText(LuaEntry.Player:GetName())
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.pvpImg:SetActive(false)
    self.typePoint:SetActive(true)
    self.typePointTxt:SetLocalText(451019)
    self.typePoint:LoadSprite(string.format(LoadPath.UIFormationDefencePath, "zyf_changzhulibao_biaoqian_dark"))
  elseif collectRewardData.type == CollectRewardType.PLUNDER_LIMIT then
    self.bg:LoadSprite(redBgPath)
    self.playerHeadFrame:LoadSprite(kuangPath)
    self.playerHead:SetActive(true)
    local user = ChatManager2:GetInstance().User:getChatUserInfo(collectRewardData.contentId, true)
    if user then
      local uid2 = user.uid
      local pic2 = user.headPic
      local picVer2 = user.headPicVer
      self.playerHead:SetData(uid2, pic2, picVer2)
      local alAbbr2 = ""
      if not string.IsNullOrEmpty(user.allianceSimpleName) then
        alAbbr2 = "[" .. user.allianceSimpleName .. "]"
      end
      local name2 = alAbbr2 .. user.userName
      self.monsterNameN:SetText(name2)
      self.monsterNameN:SetColor(CollectRewardNameRed)
    end
    self.pvpImg:SetActive(true)
    self.typePoint:SetActive(false)
  elseif collectRewardData.type == CollectRewardType.MONSTER_FIRST_KILL or collectRewardData.type == CollectRewardType.RALLY_LEADER_FIRST or collectRewardData.type == CollectRewardType.MONSTER_FIRST_KILL_BE_ATTACK then
    local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(collectRewardData.contentId)
    local monsterType = monsterTemplate.type
    local icon = LoadPath.HeroIconsSmallPath .. monsterTemplate.pic
    self.monsterIconContent:SetActive(true)
    self.playerHead:SetActive(false)
    self.monsterIconN:LoadSprite(icon)
    local lvString = Localization:GetString("300665", monsterTemplate.level)
    local nameStr = Localization:GetString(monsterTemplate.name)
    self.monsterNameN:SetText(lvString .. " " .. nameStr)
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.bg:LoadSprite(greenBgPath)
    self.playerHeadFrame:LoadSprite(kuang3Path)
    self.pvpImg:SetActive(false)
    self.typePoint:SetActive(true)
    if monsterType == LWWorldMonsterType.S4TankBN or monsterType == LWWorldMonsterType.S4AirplaneBN or monsterType == LWWorldMonsterType.S4MissileBN or monsterType == LWWorldMonsterType.S4BossBN then
      self.typePointTxt:SetLocalText("blood_first_kill")
    else
      self.typePointTxt:SetLocalText(451016)
    end
  elseif collectRewardData.type == CollectRewardType.RALLY_LEADER or collectRewardData.type == CollectRewardType.RALLY_LEADER_BE_ATTACK then
    local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(collectRewardData.contentId)
    local icon = LoadPath.HeroIconsSmallPath .. monsterTemplate.pic
    self.monsterIconContent:SetActive(true)
    self.monsterIconN:LoadSprite(icon)
    local lvString = Localization:GetString("300665", monsterTemplate.level)
    local nameStr = Localization:GetString(monsterTemplate.name)
    self.monsterNameN:SetText(lvString .. " " .. nameStr)
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.bg:LoadSprite(greenBgPath)
    self.playerHeadFrame:LoadSprite(kuang3Path)
    self.pvpImg:SetActive(false)
    self.typePoint:SetActive(true)
    self.typePointTxt:SetLocalText(451018)
    self.typePoint:LoadSprite(string.format(LoadPath.UIFormationDefencePath, "zyf_youjian_jiaobiao1"))
  elseif collectRewardData.type == CollectRewardType.RALLY_JOIN or collectRewardData.type == CollectRewardType.RALLY_JOIN_FIRST then
    local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(collectRewardData.contentId)
    if CollectRewardType.RALLY_JOIN_FIRST == collectRewardData.type and monsterTemplate.type == LWWorldMonsterType.RunningMonster then
      self.typePoint:LoadSprite(string.format(LoadPath.UIFormationDefencePath, "zyf_changzhulibao_biaoqian"))
      self.typePointTxt:SetLocalText(451016)
    else
      self.typePointTxt:SetLocalText(451017)
      self.typePoint:LoadSprite(string.format(LoadPath.UIFormationDefencePath, "zyf_youjian_jiaobiao2"))
    end
    local icon = LoadPath.HeroIconsSmallPath .. monsterTemplate.pic
    self.monsterIconContent:SetActive(true)
    self.monsterIconN:LoadSprite(icon)
    local lvString = Localization:GetString("300665", monsterTemplate.level)
    local nameStr = Localization:GetString(monsterTemplate.name)
    self.monsterNameN:SetText(lvString .. " " .. nameStr)
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.bg:LoadSprite(greenBgPath)
    self.playerHeadFrame:LoadSprite(kuang3Path)
    self.pvpImg:SetActive(false)
    self.typePoint:SetActive(true)
  elseif collectRewardData.type == CollectRewardType.RALLY_JOIN_LIMIT or collectRewardData.type == CollectRewardType.RALLY_JOIN_CROCODILE_LIMIT then
    local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(collectRewardData.contentId)
    local icon = LoadPath.HeroIconsSmallPath .. monsterTemplate.pic
    self.monsterIconContent:SetActive(true)
    self.monsterIconN:LoadSprite(icon)
    local lvString = Localization:GetString("300665", monsterTemplate.level)
    local nameStr = Localization:GetString(monsterTemplate.name)
    self.monsterNameN:SetText(lvString .. " " .. nameStr)
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.bg:LoadSprite(greenBgPath)
    self.playerHeadFrame:LoadSprite(kuang3Path)
    self.pvpImg:SetActive(false)
    self.typePoint:SetActive(true)
    self.typePointTxt:SetLocalText(451017)
    self.typePoint:LoadSprite(string.format(LoadPath.UIFormationDefencePath, "zyf_youjian_jiaobiao2"))
  elseif collectRewardData.type == CollectRewardType.FAKE_PLAYER then
    self.bg:LoadSprite(redBgPath)
    self.monsterIconContent:SetActive(true)
    self.playerHeadFrame:LoadSprite(kuangPath)
    local simplayerId = collectRewardData.contentId
    local playerConfig = LocalController:instance():getLine(TableName.LW_SIMPLAYER, simplayerId)
    if playerConfig then
      local name2 = Localization:GetString(playerConfig.name)
      self.monsterNameN:SetText(name2)
      self.monsterNameN:SetColor(CollectRewardNameRed)
      local icon = string.format(LoadPath.UIPlayerIcon, playerConfig.icon)
      self.monsterIconN:LoadSprite(icon)
    end
    self.pvpImg:SetActive(true)
    self.typePoint:SetActive(true)
    self.typePointTxt:SetLocalText(451019)
    self.typePoint:LoadSprite(string.format(LoadPath.UIFormationDefencePath, "zyf_changzhulibao_biaoqian_dark"))
  elseif collectRewardData.type == CollectRewardType.DESERT or collectRewardData.type == CollectRewardType.DESERT_FIRST then
    local configLine = LocalController:instance():getLine(TableName.Desert, collectRewardData.contentId)
    self.bg:LoadSprite(greenBgPath)
    local lvString = Localization:GetString("300665", configLine.desert_level)
    local nameStr = Localization:GetString(configLine.desert_name)
    self.monsterNameN:SetText(lvString .. " " .. nameStr)
    self.monsterIconContent:SetActive(true)
    self.monsterIconN:LoadSprite(string.format(LoadPath.SeasonDesert, configLine.icon))
    self.playerHeadFrame:LoadSprite(kuangPath)
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.pvpImg:SetActive(false)
    if collectRewardData.type == CollectRewardType.DESERT_FIRST then
      self.typePoint:SetActive(true)
      self.typePointTxt:SetLocalText("season_tiles_popui_info012")
      self.typePoint:LoadSprite(string.format(LoadPath.UIFormationDefencePath, "zyf_youjian_jiaobiao2"))
    else
      self.typePoint:SetActive(false)
    end
  elseif collectRewardData.type == CollectRewardType.ICE_SUPPLIES or collectRewardData.type == CollectRewardType.ALLIANCE_PUSH then
    local viewData = self.view.ctrl:GetItemViewData(collectRewardData)
    if viewData then
      self.bg:LoadSprite(viewData.bg)
      self.monsterIconContent:SetActive(viewData.monsterIconContentFlag)
      if viewData.monsterIconContentFlag then
        self.monsterIconN:LoadSprite(viewData.monsterIconPath)
      end
      self.playerHeadFrame:LoadSprite(viewData.playerHeadFrame)
      self.playerHead:SetActive(viewData.headFlag)
      if viewData.headFlag then
        self.playerHead:SetData(viewData.uid, viewData.pic, viewData.picVer)
      end
      if not string.IsNullOrEmpty(viewData.contentText) then
        self.noReward:SetText(viewData.contentText)
      else
        self.noReward:SetText("")
      end
      self.clickParam = viewData.clickParam
      self.content_click:SetActive(collectRewardData.type == CollectRewardType.ALLIANCE_PUSH)
      self.energy_icon:SetActive(viewData.energyIconShow)
      self.monsterNameN:SetText(viewData.monsterNameN)
      self.monsterNameN:SetColor(viewData.monsterNameNColor)
      self.pvpImg:SetActive(viewData.pvpImgFlag)
      self.typePoint:SetActive(viewData.typePointFlag)
      if viewData.typePointFlag then
        self.typePointTxt:SetLocalText(viewData.typePointTxt)
        self.typePoint:LoadSprite(viewData.typePointSprite)
      end
    end
  elseif type == CollectRewardType.INVASION_BIG_BOSS_CRIT or type == CollectRewardType.INVASION_BIG_BOSS_KILL or type == CollectRewardType.INVASION_BIG_BOSS_ATTACK then
    local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(collectRewardData.contentId)
    local icon = LoadPath.HeroIconsSmallPath .. monsterTemplate.pic
    self.monsterIconContent:SetActive(true)
    self.monsterIconN:LoadSprite(icon)
    local lvString = Localization:GetString("300665", monsterTemplate.level)
    local nameStr = Localization:GetString(monsterTemplate.name)
    self.monsterNameN:SetText(lvString .. " " .. nameStr)
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.bg:LoadSprite(greenBgPath)
    self.playerHeadFrame:LoadSprite(kuang3Path)
    self.pvpImg:SetActive(false)
    if type == CollectRewardType.INVASION_BIG_BOSS_CRIT then
      local context = Localization:GetString("activity_godzilla_battle_hp_double")
      self.typePoint:SetActive(true)
      local rate = collectRewardData.showBaseResRate or 1
      context = context .. "*" .. math.floor(rate)
      self.typePointTxt:SetText(context)
      self.typePoint:LoadSprite(string.format(LoadPath.UIFormationDefencePath, "zyf_changzhulibao_biaoqian"))
    elseif type == CollectRewardType.INVASION_BIG_BOSS_KILL then
      local context = Localization:GetString("activity_godzilla_battle_hp_kill")
      self.typePoint:SetActive(true)
      local rate = collectRewardData.showBaseResRate or 1
      context = context .. "*" .. math.floor(rate)
      self.typePointTxt:SetText(context)
      self.typePoint:LoadSprite(string.format(LoadPath.UIFormationDefencePath, "zyf_youjian_jiaobiao1"))
    else
      self.typePoint:SetActive(false)
    end
  elseif collectRewardData.type == CollectRewardType.DISCOVER_SUPPLIES or collectRewardData.type == CollectRewardType.DISCOVER_MARCH_SUPPLIES then
    local text = collectRewardData.type == CollectRewardType.DISCOVER_SUPPLIES and "season4_supplies_UI_8" or "season4_supplies_UI_7"
    local contentParam = string.split(collectRewardData.contentId, "|")
    local configId = contentParam[1]
    local serverId = contentParam[2] and tonumber(contentParam[2]) or nil
    local mapUid = contentParam[3] and tonumber(contentParam[3]) or nil
    local pointId = toInt(collectRewardData.pointId)
    text = string.format([[
%s
%s]], Localization:GetString(text), UIUtil.MakeJumpLink(pointId, serverId))
    if mapUid then
      self.content_click:SetActive(true)
      self.clickParam = {
        uuid = mapUid,
        serverId = serverId,
        objType = CollectCheckObjType.IceSupplies,
        worldId = collectRewardData.worldId,
        pointId = pointId,
        tips = "season4_supplies_tips_10"
      }
    end
    local configData = configId and LocalController:instance():getLine(TableName.LWIceSupplies, configId)
    local icon = configData and configData.icon or ""
    self.noReward:SetText(text)
    self.monsterIconContent:SetActive(true)
    if not string.IsNullOrEmpty(icon) then
      self.monsterIconN:LoadSprite(icon)
    end
    self.monsterNameN:SetLocalText("season4_supplies_UI_5")
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.bg:LoadSprite(greenBgPath)
    self.playerHeadFrame:LoadSprite(kuang3Path)
    self.pvpImg:SetActive(false)
    self.energy_icon:SetActive(false)
    self.typePoint:SetActive(true)
    self.typePointTxt:SetLocalText("season_s2_ice_supplies_16")
    self.typePoint:LoadSprite(string.format(LoadPath.UIFormationDefencePath, "zyf_changzhulibao_biaoqian"))
  elseif collectRewardData.type == CollectRewardType.BATTLE_CARD_SKILL_REWARD then
    self.bg:LoadSprite(greenBgPath)
    self.monsterIconContent:SetActive(true)
    self.monsterIconN:LoadSprite("Assets/Main/Sprites/UI/UIMastery/FX_zhanshukapai_rukouicon_.png")
    self.monsterNameN:SetLocalText("battle_box_skill_title")
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.playerHeadRoot:SetActive(false)
    self.typePoint:SetActive(false)
    self.energy_icon:SetActive(false)
    self.pvpImg:SetActive(false)
  elseif collectRewardData.type == CollectRewardType.ROB_BANK_STRONGHOLD then
    local contentParam = string.split(collectRewardData.contentId, "|")
    local cityId, serverId = toInt(contentParam[1]), contentParam[2] and tonumber(contentParam[2]) or LuaEntry.Player:GetCurServerId()
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
    self.bg:LoadSprite(redBgPath)
    self.playerHeadRoot:SetActive(false)
    self.monsterIconContent:SetActive(false)
    self.normalIcon:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/Bank/zxl_s5yh_baoxianxiang_kai_x.png")
    self.normalIcon:SetActive(true)
    self.monsterNameN:SetLocalText(meta and meta.name or "")
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.pvpImg:SetActive(false)
    self.typeImg:LoadSpriteAsync("Assets/Main/SeasonRes/S5/Sprites/Bank/zxl_s5yh_touqu.png")
    self.typeImg:SetActive(true)
    self.typePointTxt:SetLocalText("red_pocket_desc8")
    self.typePoint:LoadSpriteAsync(string.format(LoadPath.UIFormationDefencePath, "zyf_changzhulibao_biaoqian_dark"))
    self.typePoint:SetActive(true)
  elseif collectRewardData.type == CollectRewardType.REPAIR_OUTPOST_REWARD then
    self.bg:LoadSprite(greenBgPath)
    self.playerHeadFrame:LoadSprite(kuangPath)
    self.playerHead:SetActive(true)
    self.playerHead:ParseHeadInfo(LuaEntry.Player)
    self.monsterNameN:SetLocalText("war_zone_outpost_20")
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.pvpImg:SetActive(false)
    self.typePoint:SetActive(false)
    self.energy_icon:SetActive(false)
  elseif collectRewardData.type == CollectRewardType.FORTIFY_CHARGE_REWARD then
    self.bg:LoadSprite(greenBgPath)
    self.playerHead:SetActive(false)
    self.playerHeadRoot:SetActive(false)
    self.monsterIconContent:SetActive(false)
    self.img_kuang:SetActive(true)
    self.txt_count:SetActive(true)
    self.img_kuang:LoadSpriteAuto(skillKuangPath)
    self.img_icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllianceSkill/FX_S6_skill_06_icon.png")
    self.txt_count:SetActive(false)
    self.monsterNameN:SetLocalText("season_s6_skill_reward_name01")
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.pvpImg:SetActive(false)
    self.typePoint:SetActive(false)
    self.energy_icon:SetActive(false)
  elseif collectRewardType ~= 1 then
    self.bg:LoadSprite(greenBgPath)
    self.playerHeadFrame:LoadSprite(kuangPath)
    local uid = LuaEntry.Player:GetUid()
    local pic = LuaEntry.Player:GetPic()
    local picVer = LuaEntry.Player.picVer
    self.playerHead:SetActive(true)
    self.playerHead:SetData(uid, pic, picVer)
    self.monsterNameN:SetText(LuaEntry.Player:GetName())
    self.monsterNameN:SetColor(CollectRewardNameGreen)
    self.pvpImg:SetActive(false)
    self.typePoint:SetActive(false)
  end
  local energyNum = 0
  local monsterTemplate
  if type == CollectRewardType.RALLY_JOIN then
    monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(collectRewardData.contentId)
  end
  if type == CollectRewardType.RALLY_JOIN and monsterTemplate and monsterTemplate.special == WorldMonsterSpecialType.SuperRunningBoss then
    energyNum = -tonumber(LuaEntry.DataConfig:TryGetStr("running_boss", "k13", 0))
  elseif CollectRewardCost[type] then
    energyNum = CollectRewardCost[type]
  elseif type == CollectRewardType.INVASION_BIG_BOSS_CRIT or type == CollectRewardType.INVASION_BIG_BOSS_KILL or type == CollectRewardType.INVASION_BIG_BOSS_ATTACK then
    energyNum = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.MONSTER_INVASION_BOSS)
  elseif type == CollectRewardType.ROB_BANK_STRONGHOLD then
    energyNum = -MarchUtil.GetCostStaminaByTargetType(MarchTargetType.CROSS_BANK_ATTACK)
  end
  self.energyTxt:SetText(energyNum)
  if 0 <= energyNum then
    self.energyTxt:SetColor(CollectRewardEnergyGreen)
  else
    self.energyTxt:SetColor(CollectRewardEnergyRed)
  end
  self.needShowTick = false
  self.plunder_resource_max = nil
  if collectRewardType == 1 then
    return
  end
  local list = collectRewardData.rewardList
  local dataCount = table.count(list)
  if 0 < dataCount then
    self.rewardList = list
    self.ScrollView:SetEnable(true)
    self.rewardContainerN:SetActive(true)
    self.noReward:SetText("")
    self.noReward:SetActive(false)
    self:ShowAllReward()
  else
    self.noReward:SetActive(true)
    self.ScrollView:SetEnable(false)
    self.rewardContainerN:SetActive(false)
    if collectRewardData.type == CollectRewardType.MONSTER then
      self.noReward:SetLocalText(GameDialogDefine.LOOT_MONSTER_REACH_LIMIT)
    elseif collectRewardData.type == CollectRewardType.PLUNDER_LIMIT then
      local mainLv = DataCenter.BuildManager.MainLv
      local roleTemplate = DataCenter.RoleTemplateManager:GetTemplateByLevel(mainLv)
      if roleTemplate == nil then
        self.noReward:SetText("")
      else
        local remainTime = UITimeManager:GetInstance():GetResSecondsTo24()
        if 0 < remainTime then
          local timeText = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime * 1000)
          self.noReward:SetLocalText(451021, roleTemplate.plunder_resource_max, timeText)
          self.needShowTick = true
          self.plunder_resource_max = roleTemplate.plunder_resource_max
        else
          self.noReward:SetText("")
        end
      end
    elseif collectRewardData.type == CollectRewardType.RALLY_JOIN_LIMIT then
      self.noReward:SetLocalText(GameDialogDefine.LOOT_MONSTER_REACH_LIMIT)
    elseif collectRewardData.type == CollectRewardType.RALLY_JOIN_CROCODILE_LIMIT then
      self.noReward:SetLocalText("season_s6_eyu_rally_limit_desc")
    elseif collectRewardData.type == CollectRewardType.ALLIANCE_PUSH or collectRewardData.type == CollectRewardType.DISCOVER_SUPPLIES or collectRewardData.type == CollectRewardType.DISCOVER_MARCH_SUPPLIES then
    elseif collectRewardType ~= 1 then
      self.noReward:SetLocalText(GameDialogDefine.LOOT_PLAYER_NO_RESOURCE)
    end
  end
end

function CollectRewardItem:CleanRewardShown()
  for k, v in pairs(self.RewardNodeList) do
    if v then
      v:ReInit(nil)
      v:SetActive(false)
    end
  end
end

function CollectRewardItem:ShowAllReward()
  if self.rewardList then
    local luaPath = "UI.UICollectReward.Component.CollectRewardResItem"
    local prefabPath = "Assets/Main/Prefabs/UI/UICollectReward/CollectRewardResItem.prefab"
    for index, rewardParam in ipairs(self.rewardList) do
      local cell = self.RewardNodeList[index]
      if cell == nil then
        cell = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.rewardContainerN, function(view, go, lua, callback_param)
          if go then
            go.transform:Set_localScale(0.7, 0.7, 0.7)
            go.transform:Set_sizeDelta(150, 150)
            go.transform:Set_pivot(0, 1)
          end
          if lua then
            lua:SetAnchoredPositionXY(0, 0)
          end
        end)
        table.insert(self.RewardNodeList, cell)
      end
      if cell ~= nil and rewardParam ~= nil then
        local isShowArrow = false
        if self.collectRewardData and self.collectRewardData.showBaseResRate then
          if self.collectRewardData.type == CollectRewardType.INVASION_BIG_BOSS_CRIT or self.collectRewardData.type == CollectRewardType.INVASION_BIG_BOSS_KILL then
            isShowArrow = true
          elseif rewardParam.rewardType and (rewardParam.rewardType == RewardType.METAL or rewardParam.rewardType == RewardType.WOOD or rewardParam.rewardType == RewardType.OBSIDIAN or rewardParam.rewardType == RewardType.FLINT or rewardParam.rewardType == RewardType.FOOD) then
            isShowArrow = true
          end
        end
        rewardParam.isShowArrow = isShowArrow
        cell:SetActive(true)
        cell:ReInit(rewardParam)
      end
    end
  end
end

function CollectRewardItem:Update1000MS()
  if self.needShowTick == true and self.plunder_resource_max ~= nil then
    local remainTime = UITimeManager:GetInstance():GetResSecondsTo24()
    if 0 < remainTime then
      local timeText = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime * 1000)
      self.noReward:SetLocalText(451021, self.plunder_resource_max, timeText)
    else
      self.noReward:SetText("")
      self.needShowTick = false
    end
  end
  if self.limit_tips_txt and self.limit_tip_box:GetActive() then
    local remainTime = UITimeManager:GetInstance():GetResSecondsTo24()
    if 0 < remainTime then
      local timeText = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime * 1000)
      local msg = Localization:GetString("popUI_desc_003", timeText)
      local tips_txt = self.limit_tips_txt .. string.format([[


<color=#736863>%s</color>]], msg)
      self.limit_detail:SetText(tips_txt)
    else
      self.limit_detail:SetText(self.limit_tips_txt)
      self.limit_tips_txt = nil
    end
  end
  if self.noRewardStr and self.dataExpiredTime and self.collectRewardType == 1 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local msg = Localization:GetString(self.name or "season_s4_monster_tips30")
    if now < self.dataExpiredTime then
      local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(self.dataExpiredTime - now)
      self.monsterNameN:SetText(string.format("%s (%s)", msg, leftTimeStr))
    else
      self.dataExpiredTime = nil
      self.noRewardStr = nil
      self.monsterNameN:SetText(string.format("%s (%s)", msg, Localization:GetString("390843")))
    end
  end
end

local function OnClickCoodinateBtn(self)
  if self.collectRewardData == nil then
    return
  end
  local pointId = tonumber(self.collectRewardData.pointId)
  local worldPosition = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
  GoToUtil.GotoWorldPos(worldPosition, CS.SceneManager.World.InitZoom)
  self.view.ctrl:CloseSelf()
end

function CollectRewardItem:HideLimitTips()
  self.limit_tip_box:SetActive(false)
end

function CollectRewardItem:OnObjExistsCallback(data)
  local clickParam = self.clickParam
  if clickParam and data and toInt(clickParam.uuid) == data.uuid then
    if data.exists then
      data.action = "Jump"
      data.pointId = toInt(clickParam.pointId)
      GoToUtil.CloseAllWindows()
      GoToUtil.TryJumpToWorld(data)
    elseif clickParam.tips then
      UIUtil.ShowTips(Localization:GetString(clickParam.tips))
    else
      UIUtil.ShowTips(Localization:GetString("season_s3_alliance_res_build_tips_2"))
    end
  end
end

CollectRewardItem.OnCreate = OnCreate
CollectRewardItem.OnDestroy = OnDestroy
CollectRewardItem.ComponentDefine = ComponentDefine
CollectRewardItem.ComponentDestroy = ComponentDestroy
CollectRewardItem.OnAddListener = OnAddListener
CollectRewardItem.OnRemoveListener = OnRemoveListener
CollectRewardItem.SetItem = SetItem
CollectRewardItem.OnClickCoodinateBtn = OnClickCoodinateBtn
return CollectRewardItem
