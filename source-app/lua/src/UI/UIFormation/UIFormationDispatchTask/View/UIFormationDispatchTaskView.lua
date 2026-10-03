local UIFormationDispatchTaskView = BaseClass("UIFormationDispatchTaskView", UIBaseView)
local base = UIBaseView
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local RewardItem = require("UI.UIWorldPoint.Component.WorldPointRewardItem")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local close_bg_path = "closeBg"
local quick_btn_path = "Area/quickBtn"
local enter_btn_path = "Area/enterBtn"
local cd_text_path = "Area/cdText"
local title_text_path = "Area/TitleRoot/titleText"
local reward_content_path = "Area/Scroll View/Viewport/RewardContent"
local u_i_hero_cell_small1_path = "Area/dispatchHero1/UIHeroCellSmall1"
local u_i_hero_cell_small2_path = "Area/dispatchHero2/UIHeroCellSmall2"
local u_i_hero_cell_small3_path = "Area/dispatchHero3/UIHeroCellSmall3"
local type_icon1_path = "Area/conditions/require1/typeIcon1"
local num_text1_path = "Area/conditions/require1/NumText1"
local type_icon2_path = "Area/conditions/require2/typeIcon2"
local num_text2_path = "Area/conditions/require2/NumText2"
local num_text3_path = "Area/conditions/require3/NumText3"
local req4lv_text_path = "Area/conditions/require4/req4lvText"
local num_text4_path = "Area/conditions/require4/NumText4"
local scroll_view_path = "Area/ScrollView"
local empty_go_path = "Area/EmptyGo"
local require_path = "Area/conditions/require"
local star_path = "Area/conditions/require3/star"
local quality_bg_path = "Area/TitleRoot/QualityBg"
local quality_icon_path = "Area/TitleRoot/QualityBg/QualityIcon"
local QUALITY_BG_PATH = {
  [1] = "Assets/Main/Sprites/UI/FormationDispatchTask/wxy_paiqian_pinji_lvbase.png",
  [2] = "Assets/Main/Sprites/UI/FormationDispatchTask/wxy_paiqian_pinji_lvbase.png",
  [3] = "Assets/Main/Sprites/UI/FormationDispatchTask/wxy_paiqian_pinji_lanbase.png",
  [4] = "Assets/Main/Sprites/UI/FormationDispatchTask/wxy_paiqian_pinji_zibase.png",
  [5] = "Assets/Main/Sprites/UI/FormationDispatchTask/wxy_paiqian_pinji_chengbase.png",
  [10] = "Assets/Main/Sprites/UI/FormationDispatchTask/wxy_paiqian_pinji_chengbase.png"
}

function UIFormationDispatchTaskView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIFormationDispatchTaskView:OnDestroy()
  self:ClearScroll()
  self:ClearContent()
  self:HideTroopLine()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFormationDispatchTaskView:ComponentDefine()
  self.close_bg = self:AddComponent(UIButton, close_bg_path)
  self.close_bg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.quick_btn = self:AddComponent(UIButton, quick_btn_path)
  self.quick_btn:SetOnClick(function()
    self:OnFastJoinClick()
  end)
  self.enter_btn = self:AddComponent(UIButton, enter_btn_path)
  self.enter_btn:SetOnClick(function()
    self:OnStartClick()
  end)
  self.cd_text = self:AddComponent(UIText, cd_text_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.u_i_hero_cell_small1 = self:AddComponent(UIHeroCellSmall, u_i_hero_cell_small1_path)
  self.u_i_hero_cell_small2 = self:AddComponent(UIHeroCellSmall, u_i_hero_cell_small2_path)
  self.u_i_hero_cell_small3 = self:AddComponent(UIHeroCellSmall, u_i_hero_cell_small3_path)
  self.type_icon1 = self:AddComponent(UIImage, type_icon1_path)
  self.num_text1 = self:AddComponent(UIText, num_text1_path)
  self.type_icon2 = self:AddComponent(UIImage, type_icon2_path)
  self.num_text2 = self:AddComponent(UIText, num_text2_path)
  self.num_text3 = self:AddComponent(UIText, num_text3_path)
  self.req4lv_text = self:AddComponent(UIText, req4lv_text_path)
  self.num_text4 = self:AddComponent(UIText, num_text4_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.empty_go = self:AddComponent(UIBaseContainer, empty_go_path)
  self.stars = {}
  for i = 1, 5 do
    table.insert(self.stars, self:AddComponent(UIBaseContainer, star_path .. i))
  end
  self.conditionNodes = {}
  for i = 1, 4 do
    self.conditionNodes[i] = self:AddComponent(UIImage, require_path .. i)
  end
  self.quality_bg = self:AddComponent(UIImage, quality_bg_path)
  self.quality_icon = self:AddComponent(UIImage, quality_icon_path)
end

function UIFormationDispatchTaskView:ComponentDestroy()
  self.close_bg = nil
  self.quick_btn = nil
  self.enter_btn = nil
  self.cd_text = nil
  self.title_text = nil
  self.reward_content = nil
  self.u_i_hero_cell_small1 = nil
  self.u_i_hero_cell_small2 = nil
  self.u_i_hero_cell_small3 = nil
  self.type_icon1 = nil
  self.num_text1 = nil
  self.type_icon2 = nil
  self.num_text2 = nil
  self.num_text3 = nil
  self.req4lv_text = nil
  self.num_text4 = nil
  self.scroll_view = nil
  self.empty_go = nil
  self.stars = nil
  self.conditionNodes = nil
  self.quality_bg = nil
  self.quality_icon = nil
end

function UIFormationDispatchTaskView:DataDefine()
  self.uuid = self:GetUserData()
  self.clickHeroCellCallBack = BindCallback(self, self.OnClickHeroCell)
  self.selectedUUID = {}
  self.itemReqs = {}
  self.itemList = {}
  self.troopLine = nil
  self.meetAllCondition = false
end

function UIFormationDispatchTaskView:DataDestroy()
  self.heroList = nil
  self.itemReqs = nil
  self.itemList = nil
  self.selectedUUID = nil
  self.meetAllCondition = nil
end

function UIFormationDispatchTaskView:OnEnable()
  base.OnEnable(self)
  self:RefreshContent()
end

function UIFormationDispatchTaskView:OnDisable()
  base.OnDisable(self)
end

function UIFormationDispatchTaskView:OnAddListener()
  base.OnAddListener(self)
end

function UIFormationDispatchTaskView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFormationDispatchTaskView:ClearScroll()
  if self.scroll_view then
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIHeroCellSmall)
  end
end

function UIFormationDispatchTaskView:RefreshContent()
  local taskInfo = DataCenter.ActDispatchTaskDataManager:GetSingleTaskByUuid(self.uuid)
  if taskInfo == nil then
    self.ctrl:CloseSelf()
    return
  end
  local isOpen = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_DISPATCH_TASK_FASTJOIN_FUNCTION_OPEN)
  CS.UIGray.SetGray(self.quick_btn.transform, isOpen < 1, true)
  self.cd_text:SetText(UITimeManager:GetInstance():SecondToFmtString(taskInfo.cfg.times))
  self.title_text:SetLocalText(taskInfo.cfg.name)
  local color = taskInfo.cfg.color or 1
  self.quality_icon:LoadSprite(QualityImagePath[color])
  self.quality_icon:SetNativeSize()
  self.quality_bg:LoadSprite(QUALITY_BG_PATH[color])
  if not taskInfo.cfg.parsed_reward then
    taskInfo.cfg.parsed_reward = DataCenter.RewardManager:ParseRewardsStr(taskInfo.cfg.base_reward_show)
  end
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.DispatchTreasure.Type)
  if actList and 0 < #actList and not taskInfo.cfg.parsed_mapReward then
    taskInfo.cfg.parsed_mapReward = DataCenter.RewardManager:ParseRewardsStr(taskInfo.cfg.map_fragments_show)
    if taskInfo.cfg.parsed_mapReward then
      for index, value in ipairs(taskInfo.cfg.parsed_mapReward) do
        table.insert(taskInfo.cfg.parsed_reward, 1, value)
      end
    end
  end
  self:RefreshReward(taskInfo.cfg.parsed_reward)
  self:RefreshSelectHero(taskInfo)
  DataCenter.ActDispatchTaskDataManager:ParseTaskCondition(taskInfo)
  local parsed_conditions = taskInfo.cfg.parsed_conditions
  for _, v in pairs(self.conditionNodes) do
    v:SetActive(false)
  end
  for k, v in pairs(parsed_conditions) do
    self.conditionNodes[k]:SetActive(true)
    if k == 1 then
      self.type_icon1:LoadSprite(HeroUtils.GetHeroTypeIcon(v[1]))
    elseif k == 2 then
      self.type_icon2:LoadSprite(HeroUtils.GetHeroQualityTagImg(v[1]))
      self.type_icon2:SetNativeSize()
    elseif k == 3 then
      local starCon = toInt((v[1] - 1) / 5)
      for i = 1, 5 do
        self.stars[i]:SetActive(i <= starCon)
      end
    elseif k == 4 then
      self.req4lv_text:SetText(tostring(v[1]))
    end
  end
  self.heroList = self.ctrl:GetHeroList(taskInfo)
  self:ClearScroll()
  local count = table.count(self.heroList)
  if 0 < count then
    self.empty_go:SetActive(false)
    self.scroll_view:SetActive(true)
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  else
    self.empty_go:SetActive(true)
    self.scroll_view:SetActive(false)
  end
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  self:ShowTroopLine(MarchUtil.GetFormationStartPos(), taskInfo.pointId, loginServerId, taskInfo.serverId or loginServerId)
end

function UIFormationDispatchTaskView:RefreshSelectHero(taskInfo)
  self.u_i_hero_cell_small1:SetActive(false)
  self.u_i_hero_cell_small2:SetActive(false)
  self.u_i_hero_cell_small3:SetActive(false)
  taskInfo = taskInfo or DataCenter.ActDispatchTaskDataManager:GetSingleTaskByUuid(self.uuid)
  if taskInfo == nil then
    UIUtil.ShowTips(Localization:GetString("dispatch_des041"))
    self.ctrl:CloseSelf()
    return
  end
  local condNumTable = {
    0,
    0,
    0,
    0
  }
  DataCenter.ActDispatchTaskDataManager:ParseTaskCondition(taskInfo)
  local parsed_conditions = taskInfo.cfg.parsed_conditions
  local cond1Param, cond2Param, cond3Param, cond4Param
  for k, v in pairs(parsed_conditions) do
    if k == 1 then
      cond1Param = v[1]
    elseif k == 2 then
      cond2Param = v[1]
    elseif k == 3 then
      cond3Param = v[1]
    elseif k == 4 then
      cond4Param = v[1]
    end
  end
  for i, v in pairs(self.selectedUUID) do
    if v ~= nil then
      local heroCell = self["u_i_hero_cell_small" .. i]
      heroCell:SetActive(true)
      heroCell:SetData(v, self.clickHeroCellCallBack)
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v)
      if heroData then
        if cond1Param and heroData.heroType == cond1Param then
          condNumTable[1] = condNumTable[1] + 1
        end
        if cond2Param and cond2Param <= heroData.quality then
          condNumTable[2] = condNumTable[2] + 1
        end
        if cond3Param and cond3Param <= heroData:GetRank() then
          condNumTable[3] = condNumTable[3] + 1
        end
        if cond4Param and cond4Param <= heroData.level then
          condNumTable[4] = condNumTable[4] + 1
        end
      end
    end
  end
  self.meetAllCondition = true
  for k, v in pairs(parsed_conditions) do
    if condNumTable[k] >= v[2] then
      self["num_text" .. k]:SetLocalText(135225, condNumTable[k], v[2])
      self.conditionNodes[k]:SetColor(Color.New(0.8509803921568627, 0.9411764705882353, 0.7843137254901961, 1))
    else
      self.meetAllCondition = false
      self["num_text" .. k]:SetLocalText(456222, condNumTable[k], v[2])
      self.conditionNodes[k]:SetColor(Color.New(0.9215686274509803, 0.8941176470588236, 0.8862745098039215, 1))
    end
  end
  CS.UIGray.SetGray(self.enter_btn.transform, not self.meetAllCondition, true)
end

function UIFormationDispatchTaskView:ClearContent()
  if self.itemList ~= nil and table.count(self.itemList) > 0 then
    self.reward_content:RemoveComponents(RewardItem)
    self.itemList = {}
  end
  if self.itemReqs ~= nil and 0 < table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      req:Destroy()
    end
    self.itemReqs = {}
  end
end

function UIFormationDispatchTaskView:RefreshReward(rewardList)
  self:ClearContent()
  for i, data in ipairs(rewardList) do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.WorldPointRewardItemBig, function(req)
      if req.isError then
        return
      end
      local item = req.gameObject
      item.name = "reward_item" .. i
      item:SetActive(true)
      item.transform:SetParent(self.reward_content.transform)
      item.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local cell = self.reward_content:AddComponent(RewardItem, item.name)
      local buildAddNum, itemId = DataCenter.ActDispatchTaskDataManager:GetBuildAddRewardInfo()
      local cellData = DeepCopy(data)
      if 0 < buildAddNum and cellData.itemId == itemId then
        cellData.count = cellData.count + buildAddNum
        cellData.isShowArrow = true
      end
      cell:ReInit(cellData)
      self.itemList[i] = cell
    end)
  end
end

local function hasSelectUuid(uuids, uuid)
  if uuids and uuid then
    for i, v in pairs(uuids) do
      if v == uuid then
        return true
      end
    end
  end
  return false
end

function UIFormationDispatchTaskView:OnCellMoveIn(itemObj, index)
  local uuid = self.heroList[index].uuid
  itemObj.name = uuid
  local cellItem = self.scroll_view:AddComponent(UIHeroCellSmall, itemObj)
  cellItem:SetData(uuid, self.clickHeroCellCallBack)
  cellItem.img_job:SetActive(false)
  cellItem:SetActive(true)
  cellItem:SetSelected(hasSelectUuid(self.selectedUUID, uuid))
end

function UIFormationDispatchTaskView:OnCellMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIHeroCellSmall)
end

function UIFormationDispatchTaskView:OnClickHeroCell(transform, heroUuid)
  local emptyTable = {
    1,
    2,
    3
  }
  for i, v in pairs(self.selectedUUID) do
    emptyTable[i] = nil
    if v == heroUuid then
      self.selectedUUID[i] = nil
      local heroCell = self.scroll_view:GetComponent(tostring(heroUuid), UIHeroCellSmall)
      if heroCell then
        heroCell:SetSelected(false)
      end
      self:RefreshSelectHero()
      return
    end
  end
  emptyTable = table.values(emptyTable)
  if 0 < #emptyTable then
    local heroCell = self.scroll_view:GetComponent(tostring(heroUuid), UIHeroCellSmall)
    if heroCell then
      heroCell:SetSelected(true)
    end
    self.selectedUUID[emptyTable[1]] = heroUuid
    self:RefreshSelectHero()
  end
end

function UIFormationDispatchTaskView:ShowTroopLine(startPos, endPos, startServer, endServer)
  startPos = toInt(startPos)
  endPos = toInt(endPos)
  if startPos <= 0 or endPos <= 0 then
    Logger.LogInfo(string.format("ERR -> forceType : %s , %s", startPos, endPos))
  end
  if self.troopLine == nil and self.dragInstance == nil then
    self.dragInstance = ResourceManager:InstantiateAsync(CS.GameDefines.EntityAssets.TroopLineDrag)
    self.dragInstance:completed("+", function()
      if self.dragInstance.isError then
        return
      end
      self.dragInstance.gameObject:SetActive(true)
      self.dragInstance.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      self.simpleAnim = self.dragInstance.gameObject:GetComponent(typeof(CS.SimpleAnimation))
      if self.simpleAnim then
        self.simpleAnim:Play("Default")
      end
      self.troopLine = self.dragInstance.gameObject:GetComponent(typeof(CS.WorldTroopLine))
      if self.troopLine ~= nil then
        self.troopLine:SetDragPath(SceneUtils.TileIndexToWorld(startPos, ForceChangeScene.World, startServer), SceneUtils.TileIndexToWorld(endPos, ForceChangeScene.World, endServer))
      end
    end)
  elseif self.troopLine ~= nil then
    self.troopLine:SetDragPath(SceneUtils.TileIndexToWorld(startPos, ForceChangeScene.World, startServer), SceneUtils.TileIndexToWorld(endPos, ForceChangeScene.World, endServer))
  end
end

function UIFormationDispatchTaskView:HideTroopLine()
  if self.simpleAnim then
    self.simpleAnim:Play("Hide")
    TimerManager:GetInstance():GetTimer(0.5, function()
      if self.dragInstance ~= nil then
        self.dragInstance:Destroy()
        self.dragInstance = nil
      end
    end, self, true, false, false)
  elseif self.dragInstance ~= nil then
    self.dragInstance:Destroy()
    self.dragInstance = nil
  end
  self.troopLine = nil
end

function UIFormationDispatchTaskView:CalculateMarchTime(endIndex)
  local startPt = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
  local endPt = SceneUtils.IndexToTilePos(endIndex, ForceChangeScene.World)
  local dis = Vector2.Distance(startPt, endPt)
  local speed = LuaEntry.DataConfig:TryGetNum("armyspeed", "k2")
  local time = math.ceil(dis * 1000 / speed)
  return time
end

function UIFormationDispatchTaskView:OnStartClick()
  if SeasonUtil.IsInLandlordActAndOnCenterServer() then
    UIUtil.ShowTipsId("zonewar_landlord_tips_1012")
    return
  end
  if self.meetAllCondition == true then
    local mgr = DataCenter.ActDispatchTaskDataManager
    local dispatchTask = mgr:GetSingleTaskByUuid(self.uuid)
    if dispatchTask and dispatchTask.completionTime == 0 then
      local maxMarch = DataCenter.ActDispatchTaskDataManager:GetMaxMarch()
      if maxMarch <= DataCenter.ActDispatchTaskDataManager:GetSingleTaskIngCount() then
        DataCenter.ActDispatchTaskDataManager:ShowMarchLimitTip()
      else
        SFSNetwork.SendMessage(MsgDefines.DispatchStart, self.uuid, table.values(self.selectedUUID), self:CalculateMarchTime(dispatchTask.pointId))
      end
    else
      UIUtil.ShowTipsId(456228)
    end
    self.ctrl:CloseSelf()
  else
    UIUtil.ShowTipsId(456252)
  end
end

function UIFormationDispatchTaskView:OnFastJoinClick()
  local isOpen = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_DISPATCH_TASK_FASTJOIN_FUNCTION_OPEN)
  if isOpen < 1 then
    UIUtil.ShowTipsId(456233)
    return
  end
  local taskInfo = DataCenter.ActDispatchTaskDataManager:GetSingleTaskByUuid(self.uuid)
  if taskInfo == nil then
    UIUtil.ShowTips(Localization:GetString("dispatch_des041"))
    self.ctrl:CloseSelf()
    return
  end
  local heroList, meetCondition = self.ctrl:GetRecommendHeroList(taskInfo)
  if heroList and meetCondition then
    for i, v in ipairs(self.selectedUUID) do
      local heroCell = self.scroll_view:GetComponent(tostring(v), UIHeroCellSmall)
      if heroCell then
        heroCell:SetSelected(false)
      end
    end
    self.selectedUUID = heroList
    for i, v in ipairs(self.selectedUUID) do
      local heroCell = self.scroll_view:GetComponent(tostring(v), UIHeroCellSmall)
      if heroCell then
        heroCell:SetSelected(true)
      end
    end
    self:RefreshSelectHero()
  else
    UIUtil.ShowTipsId(456224)
  end
end

return UIFormationDispatchTaskView
