local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local WorldDesertDes = BaseClass("WorldDesertDes", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local icon_path = "img/Image"
local power_txt_path = "TextPower"
local player_des_path = "img/layout1/playerDes"
local player_name_path = "img/layout1/playerName"
local player_info_path = "img/layout1/btn_desertPlay"
local res_root_path = "img/layout2"
local res_name_path = "img/layout2/resNum"
local layout_3_path = "img/layout3"
local power_des_path = "img/layout3/powerDes"
local power_name_path = "img/layout3/powerNum"
local layout_4_path = "img/layout4"
local force_des_path = "img/layout4/forceDes"
local force_name_path = "img/layout4/forceNum"
local layout_5_path = "img/layout5"
local score_des_path = "img/layout5/scoreDes"
local score_name_path = "img/layout5/scoreNum"
local layout_6_path = "img/layout6"
local level_des_path = "img/layout6/levelDes"
local level_name_path = "img/layout6/levelNum"
local hurt_name_path = "layout/warnObj/hurtNum"
local battle_state_btn_path = "layout/warnObj/battle_state_btn"
local battle_state_img_path = "layout/warnObj/battle_state_btn/battle_img"
local this_obj_path = ""
local tip_path = "layout/staminaObj"
local warn_path = "layout/warnObj"
local time_path = "layout/timeObj"
local time_txt_path = "layout/timeObj/time_txt"
local tip_1_path = "layout/staminaObj/simple_tip/ele_icon/simple_tip_1"
local command_path = "Command"
local command_icon_path = "Command/CommandIcon"
local command_share_path = "CommandShare"
local ruin_path = "layout/ruinObj"
local ruin_text_path = "layout/ruinObj/ruinText"
local ruin_text1_path = "layout/ruinObj/ruinText1"
local desc_root_path = "DescRoot"
local des_txt_path = "DescRoot/ScrollView/Viewport/Content/desTxt"
local possi_text_path = "possi_text"
local scroll_view2_path = "ScrollView2"
local content2_path = "ScrollView2/Viewport/Content2"
local line_up_text_path = "lineUp_text"
local scroll_view3_path = "ScrollView3"
local content3_path = "ScrollView3/Viewport/Content3"
local power_recommend_path = "powerRecommend"
local recommend_power_path = "powerRecommend/Recommend_Power"
local res_item_path = "ScrollView2/ResItem"
local xy_path = "layout/xy"
local viral_path = "layout/viral"
local viral_btn_path = "layout/viral/viral_btn"
local viral_txt_path = "layout/viral/viral_txt"
local viral_img_path = "layout/viral/viral_btn/viral_img"
local viral_img_ok_path = "layout/viral/viral_btn/viral_img_ok"
local viral_bg_path = "layout/viral/viral_bg"
local layout_res1_path = "img/layoutRes1"
local res_num1_path = "img/layoutRes1/resNum1"
local res_des1_path = "img/layoutRes1/resDes1"
local layout_res2_path = "img/layoutRes2"
local res_num2_path = "img/layoutRes2/resNum2"
local res_des2_path = "img/layoutRes2/resDes2"
local build_btn_path = "img/BuildBtn"
local CommandType = {
  None = 0,
  GiveUp = 1,
  CancelGiveUp = 2,
  Protect = 3
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self:DeleteTimer()
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.TryShowAllianceInfo)
  self:AddUIListener(EventId.SearchAllianceError, self.TryShowAllianceInfo)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.TryShowAllianceInfo)
  self:RemoveUIListener(EventId.SearchAllianceError, self.TryShowAllianceInfo)
end

local function ComponentDefine(self)
  self.desc_root = self:AddComponent(UIImage, desc_root_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.desc_root:SetActive(false)
  self.xy = self:AddComponent(UIText, xy_path)
  self.xy:SetText("")
  self.viral = self:AddComponent(UIBaseContainer, viral_path)
  self.viral_btn = self:AddComponent(UIButton, viral_btn_path)
  self.viral_txt = self:AddComponent(UIText, viral_txt_path)
  self.viral_img = self:AddComponent(UIImage, viral_img_path)
  self.viral_img_ok = self:AddComponent(UIImage, viral_img_ok_path)
  self.viral_bg = self:AddComponent(UIImage, viral_bg_path)
  self.viral_btn:SetOnClick(function()
    if self.data.selfPercent >= 0 then
      UIUtil.ShowTipsId("season_tiles_popui_info007")
      return
    end
    UIUtil.ShowResistanceDetail(self.data.selfPercent, self.data.otherPercent)
  end)
  self.possi_text = self:AddComponent(UIText, possi_text_path)
  self.scroll_view2 = self:AddComponent(UIImage, scroll_view2_path)
  self.content2 = self:AddComponent(UIBaseContainer, content2_path)
  self.line_up_text = self:AddComponent(UIText, line_up_text_path)
  self.scroll_view3 = self:AddComponent(UIImage, scroll_view3_path)
  self.content3 = self:AddComponent(UIBaseContainer, content3_path)
  self.res_item = self:AddComponent(UICanvasGroup, res_item_path)
  self.res_item.gameObject:GameObjectCreatePool()
  self.power_recommend = self:AddComponent(UIBaseContainer, power_recommend_path)
  self.recommend_power = self:AddComponent(UIText, recommend_power_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.player_name = self:AddComponent(UIText, player_name_path)
  self.player_des = self:AddComponent(UIText, player_des_path)
  self.player_info = self:AddComponent(UIButton, player_info_path)
  self.player_info:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickPlayerInfo()
  end)
  self.res_root = self:AddComponent(UIBaseComponent, res_root_path)
  self.res_name = self:AddComponent(UIText, res_name_path)
  self.hurt_name = self:AddComponent(UIText, hurt_name_path)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.power_txt = self:AddComponent(UIText, power_name_path)
  self.layout4 = self:AddComponent(UIText, layout_4_path)
  self.force_des = self:AddComponent(UIText, force_des_path)
  self.force_txt = self:AddComponent(UIText, force_name_path)
  self.layout5 = self:AddComponent(UIText, layout_5_path)
  self.score_des = self:AddComponent(UIText, score_des_path)
  self.score_name = self:AddComponent(UIText, score_name_path)
  self.layout6 = self:AddComponent(UIText, layout_6_path)
  self.level_des = self:AddComponent(UIText, level_des_path)
  self.level_name = self:AddComponent(UIText, level_name_path)
  self.warn = self:AddComponent(UIBaseContainer, warn_path)
  self.time_obj = self:AddComponent(UIBaseContainer, time_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self.battle_state_btn = self:AddComponent(UIButton, battle_state_btn_path)
  self.battle_state_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBattleStateClick()
  end)
  self.battle_state_img = self:AddComponent(UIImage, battle_state_img_path)
  self.tip = self:AddComponent(UIBaseContainer, tip_path)
  self.tip_1 = self:AddComponent(UIText, tip_1_path)
  self.this_obj = self:AddComponent(UIBaseContainer, this_obj_path)
  self.command_btn = self:AddComponent(UIButton, command_path)
  self.command_btn:SetOnClick(function()
    self:OnCommandClick()
  end)
  self.command_image = self:AddComponent(UIImage, command_icon_path)
  self.command_share = self:AddComponent(UIButton, command_share_path)
  self.command_share:SetOnClick(function()
    self:OnShareClick()
  end)
  self.ruin = self:AddComponent(UIBaseContainer, ruin_path)
  self.ruin_text = self:AddComponent(UIText, ruin_text_path)
  self.ruin_text1 = self:AddComponent(UIText, ruin_text1_path)
  self.ruin_text1:SetText("")
  self.layout_res1 = self:AddComponent(UIBaseContainer, layout_res1_path)
  self.res_num1 = self:AddComponent(UIText, res_num1_path)
  self.res_des1 = self:AddComponent(UIText, res_des1_path)
  self.layout_res2 = self:AddComponent(UIBaseContainer, layout_res2_path)
  self.res_num2 = self:AddComponent(UIText, res_num2_path)
  self.res_des2 = self:AddComponent(UIText, res_des2_path)
  self.build_btn = self:AddComponent(UIButton, build_btn_path)
  self.build_btn:SetActive(false)
  self.build_btn:SetOnClick(function()
    self:OnBuildClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.player_name = nil
  self.player_des = nil
  self.res_name = nil
  self.hurt_name = nil
  self.power_txt = nil
end

local function DataDefine(self)
  self.param = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.endTime = 0
  self.isUpdate = false
end

local function DataDestroy(self)
  self.param = nil
end

local function RefreshData(self, param)
  self.isUpdate = false
  self.data = param
  self.player_des:SetText(Localization:GetString("110236"))
  self.player_name:SetText("")
  self.player_info:SetActive(false)
  self.icon:LoadSprite(self.data.pic)
  self.res_root:SetActive(false)
  self.power_des:SetText(Localization:GetString("2010208"))
  self.power_txt:SetText(string.GetFormattedSeperatorNum(self.data.recommend_power))
  self.recommend_power:SetText(Localization:GetString("2010208") .. string.GetFormattedSeperatorNum(self.data.recommend_power))
  if self.data.force ~= nil and self.data.force ~= "" and self.data.force ~= 0 then
    self.layout4:SetActive(true)
    self.force_des:SetLocalText("season_influence")
    self.force_txt:SetText(string.GetFormattedSeperatorNum(self.data.force))
  else
    self.layout4:SetActive(false)
  end
  if self.data.level == 0 then
    local ownerUid = self.view.ctrl.ownerUid
    if ownerUid == nil or ownerUid == "" or ownerUid == 0 then
      local canShowBuildList = DataCenter.AllianceMineManager:CanShowPlayerBuildList()
      self.build_btn:SetActive(canShowBuildList)
    end
    self.layout_res1:SetActive(false)
    self.layout_res2:SetActive(false)
    if self.data.season_mastery ~= nil and self.data.season_mastery ~= "" and self.data.season_mastery ~= 0 then
      self.layout5:SetActive(true)
      self.score_des:SetLocalText("season_mastery_exp")
      self.score_name:SetText(string.GetFormattedSeperatorNum(self.data.season_mastery))
    else
      self.layout5:SetActive(false)
    end
    self.command_share:SetActive(false)
  else
    self.command_share:SetActive(self.view.ctrl.ownerUid == LuaEntry.Player.uid and LuaEntry.Player:IsInAlliance() and self.data.canShare == true)
    self.layout5:SetActive(false)
    self.layout_res1:SetActive(false)
    self.layout_res2:SetActive(false)
    if self.data.resSpeed then
      local index = 1
      for resType, speed in pairs(self.data.resSpeed) do
        if index == 1 then
          self.layout_res1:SetActive(true)
          self.res_des1:SetText(DataCenter.ResourceManager:GetResourceNameByType(resType))
          self.res_num1:SetText(string.GetFormattedSeperatorNum(speed) .. "/h")
          index = 2
        else
          self.layout_res2:SetActive(true)
          self.res_des2:SetText(DataCenter.ResourceManager:GetResourceNameByType(resType))
          self.res_num2:SetText(string.GetFormattedSeperatorNum(speed) .. "/h")
          break
        end
      end
    end
  end
  self.layout6:SetActive(false)
  local stamina = false
  local timeObj = false
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.commandType = CommandType.None
  if self.view.ctrl.ownerUid == LuaEntry.Player.uid then
    if curTime < self.data.giveUpEndTime then
      self.commandType = CommandType.CancelGiveUp
      self.isUpdate = true
      self.endTime = self.data.giveUpEndTime
      self.time_obj:SetActive(true)
      self.command_share:SetActive(false)
      timeObj = true
      self:AddTimer()
      self:RefreshTime()
    elseif curTime < self.data.protectEndTime then
      self.commandType = CommandType.Protect
      self.isUpdate = true
      self.endTime = self.data.protectEndTime
      self.time_obj:SetActive(true)
      self.command_share:SetActive(false)
      timeObj = true
      self:AddTimer()
      self:RefreshTime()
    else
      self.time_obj:SetActive(false)
      self.commandType = CommandType.GiveUp
    end
  else
    self.time_obj:SetActive(false)
  end
  self:RefreshCommandBtn()
  local isEmptyDesert = false
  if self.data.level ~= nil and 0 >= self.data.level then
    isEmptyDesert = true
  end
  if self.data.resistance and 0 < self.data.resistance then
    self.viral:SetActive(true)
    local str1 = string.format("%s/%s", string.GetFormattedSeparatorNum(toInt(self.data.selfValue)), string.GetFormattedSeparatorNum(toInt(self.data.resistance)))
    local str2 = Localization:GetString("season_tiles_popui_info004", str1)
    local str3 = ""
    if 0 > self.data.selfPercent then
      self.viral_img:SetActive(true)
      self.viral_img_ok:SetActive(false)
      str3 = Localization:GetString("season_tiles_popui_info005", string.GetFormattedPercentStr(self.data.selfPercent))
      self.viral_txt:SetText(str2 .. " " .. str3)
      self.viral_bg:SetColorRGBA(1, 0.8901960784313725, 0.8745098039215686, 1)
    else
      self.viral_img:SetActive(false)
      self.viral_img_ok:SetActive(true)
      self.viral_txt:SetText("<color=#0e9500>" .. str2 .. "</color>")
      self.viral_bg:SetColorRGBA(0.8745098039215686, 1, 0.9647058823529412, 1)
    end
  else
    self.viral:SetActive(false)
  end
  if self.view.ctrl.ownerUid == LuaEntry.Player.uid then
    stamina = false
    self.viral:SetActive(false)
    self.tip:SetActive(false)
    self.power_recommend:SetActive(false)
  elseif self.view.ctrl.ownerUid ~= LuaEntry.Player.uid and self.view.ctrl.isAlliance == false then
    stamina = true
    self.power_recommend:SetActive(true)
    self.tip:SetActive(true)
    local attackCost = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.ATTACK_DESERT, nil, nil, nil, isEmptyDesert)
    self.tip_1:SetText(math.floor(attackCost))
  else
    self.viral:SetActive(false)
    self.tip:SetActive(false)
    self.power_recommend:SetActive(false)
  end
  if self.data.isRuin == true then
    self.isUpdate = true
    self.endTime = self.data.endTime
    self:AddTimer()
    self:RefreshTime()
  end
  self:SetAllCellDestroy()
  if self.data.level ~= nil and self.data.level > DataCenter.SeasonDataManager:GetDesertMaxLevel() then
    if self:ParseRewardsStr(self.data.firstRewardStr, self.content2, self.res_item.gameObject) then
      self.possi_text:SetLocalText(300702)
      self.possi_text:SetActive(true)
      self.scroll_view2:SetActive(true)
    else
      self.possi_text:SetActive(false)
      self.scroll_view2:SetActive(false)
    end
  else
    self.possi_text:SetActive(false)
    self.scroll_view2:SetActive(false)
  end
  if self:ParseRewardsStr(self.data.showRewardStr, self.content3, self.res_item.gameObject) then
    self.line_up_text:SetLocalText("season_desert_desc004")
    self.line_up_text:SetActive(true)
    self.scroll_view3:SetActive(true)
  else
    self.line_up_text:SetActive(false)
    self.scroll_view3:SetActive(false)
  end
end

function WorldDesertDes:ParseRewardsStr(RewardStr, content, theItemTemplate)
  if string.IsNullOrEmpty(RewardStr) or type(RewardStr) ~= "string" then
    return false
  end
  local extraRewards = DataCenter.RewardManager:ParseRewardsStr(RewardStr)
  if extraRewards ~= nil then
    local goItem, theItem
    for i, item in ipairs(extraRewards) do
      goItem = theItemTemplate:GameObjectSpawn(content.transform)
      goItem.name = "item_" .. i
      goItem:SetActive(true)
      theItem = content:AddComponent(UICommonResItem, goItem.name)
      theItem:ReInit(item)
    end
    return true
  end
  return false
end

local function SetAllCellDestroy(self)
  self.content2:RemoveComponents(UICommonResItem)
  self.content3:RemoveComponents(UICommonResItem)
  self.res_item.gameObject:GameObjectRecycleAll()
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function WorldDesertDes:TryShowAllianceInfo()
  if self.serverData ~= nil and self.data.hasOwner and string.IsNullOrEmpty(self.theOwnerName) and not string.IsNullOrEmpty(self.serverData.allianceId) then
    local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.serverData.allianceId)
    if data ~= nil then
      self.serverData.alAbbr = data.abbr
      self.serverData.allianceName = data.allianceName
    end
    self:UpdateOwnerName()
  end
end

function WorldDesertDes:UpdateOwnerName()
  if self.serverData ~= nil and self.data.hasOwner then
    local srcServer = self.serverData.srcServer
    local otherServerPlayer = srcServer ~= nil and srcServer ~= 0 and srcServer ~= LuaEntry.Player:GetSourceServerId()
    local name = self.serverData.name or ""
    if otherServerPlayer then
      name = UIUtil.FormatServerAllianceName(srcServer, self.serverData.alAbbr, name)
    else
      name = UIUtil.FormatAllianceAndName(self.serverData.alAbbr, name)
    end
    self.theOwnerName = name
    if self.view.ctrl.ownerUid == LuaEntry.Player.uid then
      self.player_name:SetText("<color=#0e9500>" .. name .. "</color>")
    elseif self.view.ctrl.isAlliance then
      self.player_name:SetText("<color=#0091e8>" .. name .. "</color>")
    elseif otherServerPlayer then
      self.player_name:SetText("<color=#e64141>" .. name .. "</color>")
    else
      self.player_name:SetText("<color=#2A2830>" .. name .. "</color>")
    end
    self.player_info:SetActive(self.view.ctrl.ownerUid ~= LuaEntry.Player.uid)
  else
    self.player_des:SetText("<b>" .. Localization:GetString("458224") .. "</b>")
    self.player_name:SetText("")
    self.player_info:SetActive(false)
  end
end

local function UpdateInfo(self, pointId, data)
  self.serverData = data.playerData
  self.pointId = pointId
  local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  self.xy:SetText(string.format("( X:%s Y:%s )", pos.x, pos.y))
  self:UpdateOwnerName()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  if self.isUpdate == true then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.endTime - curTime
    if self.data.isRuin == true then
      if 0 < deltaTime then
        self.ruin_text:SetLocalText(309012, UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
      else
        self.ruin_text:SetText("")
      end
    elseif 0 < deltaTime then
      local str = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      if self.commandType == CommandType.Protect then
        self.time_txt:SetText(Localization:GetString("season_tiles_popui_info001") .. " " .. str)
      elseif self.commandType == CommandType.CancelGiveUp then
        self.time_txt:SetText(Localization:GetString("season_tiles_popui_info002") .. " " .. str)
      else
        self.time_txt:SetText(Localization:GetString("100238") .. " " .. str)
      end
    else
      self.time_txt:SetText("")
    end
  end
end

local function OnBattleStateClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.battle_state_btn.gameObject.transform.position + Vector3.New(20, 0, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  if 0 <= self.data.selfPercent then
    param.content = self.battleStateTitle
  else
    param.title = self.battleStateTitle
    if self.battleStateStr ~= nil and self.battleStateStr ~= "" then
      param.content = self.battleStateStr
    end
  end
  param.dir = UIHeroTipView.Direction.LEFT
  param.defWidth = 340
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function RefreshCommandBtn(self)
  local uuid = self.view.ctrl.uuid
  if uuid == nil or uuid == 0 then
    self.command_btn:SetActive(false)
    return
  end
  local data = DataCenter.DesertDataManager:GetSelfDesertDataByUuid(uuid)
  if data == nil and self.data.level ~= 0 then
    self.command_btn:SetActive(false)
  elseif self.commandType == CommandType.None then
    self.command_btn:SetActive(false)
  elseif self.commandType == CommandType.GiveUp or self.commandType == CommandType.Protect then
    self.command_btn:SetActive(true)
    self.command_image:LoadSpriteAuto(string.format(LoadPath.UIBuildBtns, "uibuild_btn_chaichu"))
  elseif self.commandType == CommandType.CancelGiveUp then
    self.command_btn:SetActive(true)
    self.command_image:LoadSpriteAuto(string.format(LoadPath.UIBuildBtns, "uibuild_btn_canceldismantle"))
  end
end

local function OnShareClick(self)
  if self.data and self.data.canShare then
    SeasonUtil.ShareDesert(self.data.serverId, self.view.ctrl.uuid, self.data.desertId, self.data.oriDesertId, self.data.pointId)
  end
end

local function OnCommandClick(self)
  local uuid = self.view.ctrl.uuid
  if uuid == nil or uuid == 0 then
    return
  end
  if self.commandType == CommandType.GiveUp or self.commandType == CommandType.Protect then
    DataCenter.DesertDataManager:GiveUp(uuid, self.data.desertId, self.data, function()
      self.view.ctrl:CloseSelf()
    end)
  elseif self.commandType == CommandType.CancelGiveUp then
    DataCenter.DesertDataManager:CancelGiveUp(uuid, self.data.desertId, self.data, function()
      self.view.ctrl:CloseSelf()
    end)
  end
end

local function OnClickPlayerInfo(self)
  if self.serverData ~= nil and self.serverData.desertInfo ~= nil and self.serverData.desertInfo.ownerUid ~= nil and self.serverData.desertInfo.ownerUid ~= "" then
    local uid = self.serverData.desertInfo.ownerUid
    if uid == LuaEntry.Player.uid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = true}, uid)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, uid)
    end
  elseif not string.IsNullOrEmpty(self.serverData.allianceId) then
    local allianceId = self.serverData.allianceId
    local serverId = LuaEntry.Player:GetCurServerId()
    UIUtil.TryShowAllianceInfo(serverId, allianceId, self.serverData.allianceName)
  end
end

function WorldDesertDes:OnReturnClick()
  self.desc_root:SetActive(false)
end

function WorldDesertDes:OnBuildClick()
  local canShowBuildList = DataCenter.AllianceMineManager:CanShowPlayerBuildList()
  if canShowBuildList then
    GoToUtil.CloseAllWindows()
    Setting:SetPrivateInt("UIBuildListSeasonBuild", self.pointId or 0)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildList, UIBuildListTabType.SeasonBuild)
  else
    UIUtil.ShowTipsId("803078")
  end
end

local function OnInfoClick(self)
  if self.data ~= nil and self.data.desert_desc then
    self.desc_root:SetActive(true)
    self.des_txt:SetLocalText(self.data.desert_desc)
  end
end

WorldDesertDes.OnCreate = OnCreate
WorldDesertDes.OnDestroy = OnDestroy
WorldDesertDes.OnEnable = OnEnable
WorldDesertDes.OnDisable = OnDisable
WorldDesertDes.OnAddListener = OnAddListener
WorldDesertDes.OnRemoveListener = OnRemoveListener
WorldDesertDes.ComponentDefine = ComponentDefine
WorldDesertDes.ComponentDestroy = ComponentDestroy
WorldDesertDes.DataDefine = DataDefine
WorldDesertDes.DataDestroy = DataDestroy
WorldDesertDes.RefreshData = RefreshData
WorldDesertDes.UpdateInfo = UpdateInfo
WorldDesertDes.RefreshTime = RefreshTime
WorldDesertDes.AddTimer = AddTimer
WorldDesertDes.DeleteTimer = DeleteTimer
WorldDesertDes.OnBattleStateClick = OnBattleStateClick
WorldDesertDes.RefreshCommandBtn = RefreshCommandBtn
WorldDesertDes.OnCommandClick = OnCommandClick
WorldDesertDes.OnShareClick = OnShareClick
WorldDesertDes.SetAllCellDestroy = SetAllCellDestroy
WorldDesertDes.OnClickPlayerInfo = OnClickPlayerInfo
WorldDesertDes.OnInfoClick = OnInfoClick
return WorldDesertDes
