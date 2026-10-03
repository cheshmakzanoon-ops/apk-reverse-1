local UIIdleGameTaskEventDetailView = BaseClass("UIIdleGameTaskEventDetailView", UIBaseView)
local UIIdleGameTaskEventItem = require("UI.T11IdleGame.T11IdleGameTaskEventList.Component.UIIdleGameTaskEventItem")
local UIIdleGameTaskEventDetailInvite = require("UI.T11IdleGame.T11IdleGameTaskEventDetail.Component.UIIdleGameTaskEventDetailInvite")
local UIIdleGameTaskEventDetailRequireItemComponent = require("UI.T11IdleGame.T11IdleGameTaskEventDetail.Component.UIIdleGameTaskEventDetailRequireItemComponent")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local UIGray = CS.UIGray
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local sendMsgTime = 0
local clickInternal = 500
local blueBtnPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/common_btn_blue.png"
local greenBtnPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png"

function UIIdleGameTaskEventDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIIdleGameTaskEventDetailView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIIdleGameTaskEventDetailView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.taskEventItemScript = self.viewSkin:AddComponent(self, UIIdleGameTaskEventItem, 1)
  self.textTaskDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textEventRequirementTitleName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compEventRequirementContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.textEventRequirementDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.compItemContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compItemScrollContent = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.compInviteContent = self.viewSkin:AddComponent(self, UIIdleGameTaskEventDetailInvite, 6)
  self.textRewardTitleName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.rewardScrollContent = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.btnUse = self.viewSkin:AddComponent(self, UIButton, 9)
  self.textBtnUse = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.imgBtnUse = self.viewSkin:AddComponent(self, UIImage, 15)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnPanel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnDelete = self:AddComponent(UIButton, "BtnDelete")
  self.btnDelete:SetOnClick(function()
    self:OnBtnDeleteClick()
  end)
  self.btnDelete:SetSafeClickMode(true)
  self.btnDelete:SetSafeClickModeTime(3)
  self.requireItemReq = nil
  self.requireItem = nil
end

function UIIdleGameTaskEventDetailView:ComponentDestroy()
  if self.requireItemReq ~= nil then
    self.requireItemReq:Destroy()
    self.requireItemReq = nil
  end
  self.requireItem = nil
  self.viewSkin = nil
  self.taskEventItemScript = nil
  self.textTaskDesc = nil
  self.textEventRequirementTitleName = nil
  self.compEventRequirementContent = nil
  self.compItemContent = nil
  self.compInviteContent = nil
  self.textRewardTitleName = nil
  self.rewardScrollContent = nil
  self.btnUse = nil
  self.textBtnUse = nil
  self.textEventRequirementDesc = nil
  self.compItemScrollContent = nil
  self.textTitle = nil
  self.btnClose = nil
  self.imgBtnUse = nil
  self.btnPanel = nil
  self.btnDelete = nil
end

function UIIdleGameTaskEventDetailView:DataDefine()
  local userData = self:GetUserData()
  self.gameEventData = userData.gameEventData
  self.eventCfgData = DataCenter.T11IdleGameTemplateManager:GetGameEventTemplateById(self.gameEventData.eventId)
  if self.eventCfgData == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventDetailView:DataDefine call with nil eventCfgData")
    return
  end
  self.questCfgData = DataCenter.QuestTemplateManager:GetQuestTemplate(self.gameEventData.questId)
  if self.questCfgData == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventDetailView:DataDefine call with nil self.questCfgData")
    return
  end
  if self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_ALLIANCE_HELP then
    DataCenter.T11IdleGameDataManager:SendIdleGameEventGetMessage(LuaEntry.Player.uid, self.gameEventData.uuid, Const.IdleGameEventGetType.OnlyGetPlayerList)
  end
  self.itemReqs = {}
  self.itemList = {}
end

function UIIdleGameTaskEventDetailView:DataDestroy()
  self.gameEventData = nil
  self.eventCfgData = nil
  self.questCfgData = nil
  self:ClearContent()
end

function UIIdleGameTaskEventDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshView)
  self:AddUIListener(EventId.T11IdleGameTaskEventDetailRefresh, self.RefreshView)
  self:AddUIListener(EventId.T11IdleGameTaskEventInvitePlayers, self.RefreshInvitePlayers)
  self:AddUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
end

function UIIdleGameTaskEventDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshView)
  self:RemoveUIListener(EventId.T11IdleGameTaskEventDetailRefresh, self.RefreshView)
  self:RemoveUIListener(EventId.T11IdleGameTaskEventInvitePlayers, self.RefreshInvitePlayers)
  self:RemoveUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  base.OnRemoveListener(self)
end

function UIIdleGameTaskEventDetailView:RefreshInvitePlayers(param)
  local eventUuid = param.eventUuid
  if eventUuid ~= self.gameEventData.uuid then
    return
  end
  local requirementStr = self:GetRequirementDesc()
  self.compInviteContent:RefreshShow(eventUuid, requirementStr)
end

function UIIdleGameTaskEventDetailView:RefreshView()
  self:ClearContent()
  self:RefreshTop()
  self:RefreshRequirement()
  self:RefreshRewardShow()
  self:RefreshBtnUse()
end

function UIIdleGameTaskEventDetailView:RefreshTop()
  self.taskEventItemScript:SetActive(true)
  self.taskEventItemScript:RefreshView(self.gameEventData)
  self.taskEventItemScript:SetBtnInteractable(false)
  self.taskEventItemScript:SetIsShowRedPoint(false)
  self.textTitle:SetLocalText("t11_idle_game_title_40")
  self.textTaskDesc:SetLocalText(self.eventCfgData.long_desc)
  if self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_COST_GOODS then
    self.textEventRequirementTitleName:SetLocalText("t11_idle_game_normal_event_quest_desc_8")
  else
    self.textEventRequirementTitleName:SetLocalText("t11_idle_game_desc_41")
  end
  self.textRewardTitleName:SetLocalText("t11_idle_game_desc_42")
end

function UIIdleGameTaskEventDetailView:RefreshRequirement()
  local isT11GamePlay = self:IsT11GamePlay(self.questCfgData.type2)
  local isAccomplishGamePlay = self:IsAccomplishGamePlay(self.questCfgData.type2)
  local isDailyGamePlay = self:IsDailyGamePlay(self.questCfgData.type2)
  self.compEventRequirementContent:SetActive(self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_PLOT or isT11GamePlay or self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_5V5_BATTLE or isDailyGamePlay or isAccomplishGamePlay)
  self.compItemContent:SetActive(self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_COST_GOODS)
  self.compInviteContent:SetActive(self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_ALLIANCE_HELP)
  if self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_PLOT or self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_5V5_BATTLE or isT11GamePlay or isDailyGamePlay or isAccomplishGamePlay then
    local requirementStr = self:GetRequirementDesc()
    self.textEventRequirementDesc:SetText(requirementStr)
  elseif self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_COST_GOODS then
    if not string.IsNullOrEmpty(self.questCfgData.para3) then
      local strList = string.split(self.questCfgData.para3, ";")
      local itemId = strList[1]
      local curNum = 0
      local itemData = DataCenter.ItemData:GetItemById(itemId)
      if itemData ~= nil then
        curNum = itemData.count
      end
      local targetNum = tonumber(strList[2])
      local targetNumStr = string.GetFormattedSeperatorNum(targetNum)
      local curNumStr = tostring(curNum)
      if curNum < targetNum then
        curNumStr = "<color=#F53C3D>" .. string.GetFormattedStr(curNum) .. "</color>"
      else
        curNumStr = "<color=#FFFFFF>" .. string.GetFormattedStr(curNum) .. "</color>"
      end
      local showStr = curNumStr .. "/" .. targetNumStr
      local item = {
        rewardType = RewardType.GOODS,
        itemId = itemId
      }
      if self.requireItemReq == nil then
        self.requireItemReq = self:GameObjectInstantiateAsync(UIAssets.UIIdleGameTaskEventDetailRequireItem, function(req)
          if req.isError then
            return
          end
          local itemObj = req.gameObject
          itemObj.name = "UIIdleGameTaskEventDetailRequireItem"
          itemObj:SetActive(true)
          itemObj.transform:SetParent(self.compItemScrollContent.transform, false)
          itemObj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          self.requireItem = self.compItemScrollContent:AddComponent(UIIdleGameTaskEventDetailRequireItemComponent, itemObj.name)
          self.requireItem:ReInit(item, showStr)
        end)
      elseif self.requireItem ~= nil then
        self.requireItem:ReInit(item, showStr)
      end
    end
  elseif self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_ALLIANCE_HELP then
    self:RefreshInvitePlayers({
      eventUuid = self.gameEventData.uuid
    })
  else
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventDetailView:RefreshMiddle Quest\232\161\168\229\161\171\229\134\153\231\154\132type2\230\156\137\233\151\174\233\162\152: " .. self.gameEventData.questId)
  end
end

function UIIdleGameTaskEventDetailView:RefreshRewardShow()
  local rewardId = self.gameEventData.rewardId
  if string.IsNullOrEmpty(rewardId) then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventDetailView: RefreshRewardShow \230\156\170\228\184\139\229\143\145\229\165\150\229\138\177")
    return
  end
  local line = LocalController:instance():getLine(TableName.RewardConfig, rewardId)
  if line == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventDetailView: RefreshRewardShow \228\184\139\229\143\145\231\154\132\229\165\150\229\138\177\228\184\141\229\156\168 Reward \232\161\168\228\184\173\239\188\154" .. rewardId)
    return
  end
  local showRewardList = {}
  local itemValues = line:getValue("item") or ""
  local numValues = line:getValue("num") or ""
  if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
    local ids = string.split(itemValues, "|")
    local nums = string.split(numValues, "|")
    if ids ~= nil and 0 < #ids then
      for i, id in pairs(ids) do
        local oneData = {}
        oneData.itemId = id
        oneData.count = nums[i] or 0
        oneData.rewardType = RewardType.GOODS
        table.insert(showRewardList, oneData)
      end
    end
  end
  local itemValuesRes = line:getValue("resource_item_random_type") or ""
  local numValuesRes = line:getValue("resource_item_rate") or ""
  if not string.IsNullOrEmpty(itemValuesRes) and not string.IsNullOrEmpty(numValuesRes) then
    local code = self:GetCode(itemValuesRes)
    local idsRes = string.split(itemValuesRes, code)
    local numsRes = string.split(numValuesRes, code)
    if idsRes ~= nil and 0 < #idsRes then
      for i, id in pairs(idsRes) do
        local oneData = {}
        oneData.itemId = id
        local numss = string.split(numsRes[i], ";")
        oneData.count = tonumber(numss[1]) or 0
        oneData.rewardType = RewardType.RESOURCE_ITEM
        table.insert(showRewardList, oneData)
      end
    end
  end
  self:RefreshRewardList(showRewardList, self.rewardScrollContent)
end

function UIIdleGameTaskEventDetailView:GetCode(str)
  if string.IsNullOrEmpty(str) then
    return "|"
  end
  if string.find(str, "|") then
    return "|"
  end
  if string.find(str, ";") then
    return ";"
  end
  if string.find(str, ",") then
    return ","
  end
  return "|"
end

function UIIdleGameTaskEventDetailView:RefreshBtnUse()
  local isBtnGray = true
  local isT11GamePlay = self:IsT11GamePlay(self.questCfgData.type2)
  local isAccomplishGamePlay = self:IsAccomplishGamePlay(self.questCfgData.type2)
  local isDailyGamePlay = self:IsDailyGamePlay(self.questCfgData.type2)
  if self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_COST_GOODS then
    local strList = string.split(self.questCfgData.para3, ";")
    local itemId = tonumber(strList[1])
    local targetNum = tonumber(strList[2])
    local curNum = 0
    local itemData = DataCenter.ItemData:GetItemById(itemId)
    if itemData ~= nil then
      curNum = itemData.count
    end
    isBtnGray = self.gameEventData.status == Const.TaskState.Received
    if self.gameEventData.status == Const.TaskState.NoComplete then
      self.textBtnUse:SetLocalText("t11_idle_game_button_45")
    else
      self.textBtnUse:SetLocalText("t11_idle_game_button_44")
    end
    self.btnUse:SetOnClick(function()
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < sendMsgTime + clickInternal then
        return
      end
      sendMsgTime = curTime
      if self.gameEventData.status == Const.TaskState.NoComplete then
        if curNum >= targetNum then
          local itemName = DataCenter.ItemTemplateManager:GetName(itemId)
          local descStr = Localization:GetString("t11_idle_game_desc_46", targetNum, itemName)
          UIUtil.ShowMessage(descStr, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            DataCenter.T11IdleGameDataManager:SendIdleGameEventGoods(self.gameEventData.uuid)
          end)
        else
          LWResourceLackUtil:GotoGoodsItemLack(itemId, targetNum)
        end
      elseif self.gameEventData.status == Const.TaskState.CanReceive then
        self:CheckPlayPlot()
      end
    end)
  elseif self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_PLOT or isT11GamePlay or isAccomplishGamePlay or isDailyGamePlay or self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_ALLIANCE_HELP then
    local hasTaskJump = self.questCfgData.gotype2 ~= 0 or self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_ALLIANCE_HELP
    isBtnGray = self.gameEventData.status == Const.TaskState.NoComplete and not hasTaskJump or self.gameEventData.status == Const.TaskState.Received
    if self.gameEventData.status == Const.TaskState.NoComplete then
      if hasTaskJump then
        self.textBtnUse:SetLocalText("t11_idle_game_button_63")
      else
        self.textBtnUse:SetLocalText("t11_idle_game_button_43")
      end
    else
      self.textBtnUse:SetLocalText("t11_idle_game_button_44")
    end
    self.btnUse:SetOnClick(function()
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < sendMsgTime + clickInternal then
        return
      end
      sendMsgTime = curTime
      if self.gameEventData.status == Const.TaskState.NoComplete then
        if self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_ALLIANCE_HELP then
          DataCenter.T11IdleGameDataManager:SendIdleGameEventGetMessage(LuaEntry.Player.uid, self.gameEventData.uuid, Const.IdleGameEventGetType.GetDataAndOpenHelpView)
        else
          local questCfgData = self.questCfgData
          if questCfgData and questCfgData.gotype2 then
            GoToUtil.CloseAllWindows()
            GoToUtil.GoToByQuestId(questCfgData)
          end
        end
      elseif self.gameEventData.status == Const.TaskState.CanReceive then
        self:CheckPlayPlot()
      end
    end)
  elseif self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_5V5_BATTLE then
    isBtnGray = self.gameEventData.status == Const.TaskState.Received
    if self.gameEventData.status == Const.TaskState.NoComplete then
      self.textBtnUse:SetLocalText("150122")
    else
      self.textBtnUse:SetLocalText("t11_idle_game_button_44")
    end
    self.btnUse:SetOnClick(function()
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < sendMsgTime + clickInternal then
        return
      end
      sendMsgTime = curTime
      if self.gameEventData.status == Const.TaskState.NoComplete then
        DataCenter.T11IdleGameDataManager:EnterBattle(self.eventCfgData.battle_army, self.gameEventData.uuid)
      elseif self.gameEventData.status == Const.TaskState.CanReceive then
        self:CheckPlayPlot()
      end
    end)
  else
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventDetailView:RefreshBtnUse Quest\232\161\168\229\161\171\229\134\153\231\154\132type2\230\156\137\233\151\174\233\162\152: " .. self.gameEventData.questId)
  end
  if self.gameEventData.status == Const.TaskState.NoComplete then
    self.imgBtnUse:LoadSprite(blueBtnPath)
    self.btnDelete:SetActive(true)
  else
    self.imgBtnUse:LoadSprite(greenBtnPath)
    self.btnDelete:SetActive(false)
  end
  UIGray.SetGray(self.btnUse.transform, isBtnGray, not isBtnGray)
end

function UIIdleGameTaskEventDetailView:GetRequirementDesc()
  local requirementStr = ""
  if not string.IsNullOrEmpty(self.eventCfgData.quest_para) then
    local strList = string.split(self.eventCfgData.quest_para, ";")
    requirementStr = Localization:GetString(self.questCfgData.desc, table.unpack(strList))
  else
    requirementStr = Localization:GetString(self.questCfgData.desc, "0", self.questCfgData.para2)
  end
  if self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_LEVEL then
    return requirementStr
  end
  local curNum = self.gameEventData.num
  local targetNum = self.questCfgData.para2
  if 0 <= curNum - targetNum then
    curNum = targetNum
  end
  requirementStr = requirementStr .. " (" .. string.GetFormattedStr(curNum) .. "/" .. string.GetFormattedStr(targetNum) .. ")"
  return requirementStr
end

function UIIdleGameTaskEventDetailView:ClearContent()
  if table.count(self.itemList) > 0 then
    self.rewardScrollContent:RemoveComponents(UICommonResItem)
    self.itemList = {}
  end
  if table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      req:Destroy()
    end
    self.itemReqs = {}
  end
end

function UIIdleGameTaskEventDetailView:RefreshRewardList(rewardList, contentScript)
  if not table.IsNullOrEmpty(rewardList) then
    for i, data in pairs(rewardList) do
      local req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "reward_item" .. i
        item:SetActive(true)
        item.transform:SetParent(contentScript.transform)
        item.transform:Set_localScale(1, 1, 1)
        item.transform:Set_sizeDelta(118, 118)
        item.transform:Set_pivot(0.5, 0.5)
        local cell = contentScript:AddComponent(UICommonResItem, item.name)
        cell:ReInit(data)
        table.insert(self.itemList, cell)
      end)
      table.insert(self.itemReqs, req)
    end
  end
end

function UIIdleGameTaskEventDetailView:CheckPlayPlot()
  if not string.IsNullOrEmpty(self.eventCfgData.end_plot) then
    local isPlaySuccess = DataCenter.T11IdleGameDataManager:TryPlayPlot(self.gameEventData.uuid, self.eventCfgData.end_plot)
    if not isPlaySuccess then
      DataCenter.T11IdleGameDataManager:SendIdleGameEventReceiveMessage(self.gameEventData.uuid)
    end
  else
    DataCenter.T11IdleGameDataManager:SendIdleGameEventReceiveMessage(self.gameEventData.uuid)
  end
end

function UIIdleGameTaskEventDetailView:OnPlotGroupDone(plotGroupId)
  if not string.IsNullOrEmpty(self.eventCfgData.end_plot) and self.eventCfgData.end_plot == plotGroupId then
    DataCenter.T11IdleGameDataManager:SendIdleGameEventReceiveMessage(self.gameEventData.uuid)
  end
end

function UIIdleGameTaskEventDetailView:IsT11GamePlay(type2)
  return type2 == Const.T11GameEventCompleteType.IDLE_GAME_NODE_BATTLE_TIMES or type2 == Const.T11GameEventCompleteType.IDLE_GAME_NODE_BOX_TIMES or type2 == Const.T11GameEventCompleteType.IDLE_GAME_EVENT_RECEIVE or type2 == Const.T11GameEventCompleteType.IDLE_GAME_IDLE_TIME or type2 == Const.T11GameEventCompleteType.IDLE_GAME_LEVEL
end

function UIIdleGameTaskEventDetailView:IsAccomplishGamePlay(type2)
  return type2 == Const.T11GameEventCompleteType.GATHER_COUNT or type2 == Const.T11GameEventCompleteType.WILD_MONSTER_COUNT or type2 == Const.T11GameEventCompleteType.WILD_MONSTER_COUNT_ANY or type2 == Const.T11GameEventCompleteType.DOOMSDAY_ELITE_COUNT or type2 == Const.T11GameEventCompleteType.SPEEDUP_USED_COUNT or type2 == Const.T11GameEventCompleteType.ALLIANCE_HELP_COUNT or type2 == Const.T11GameEventCompleteType.ADVANCED_DRAW_COUNT or type2 == Const.T11GameEventCompleteType.RADAR_MISSION_COUNT or type2 == Const.T11GameEventCompleteType.ALLIANCE_GIFT_COUNT or type2 == Const.T11GameEventCompleteType.ALLIANCE_DONATION_COUNT
end

function UIIdleGameTaskEventDetailView:IsDailyGamePlay(type2)
  return type2 == Const.T11GameEventCompleteType.UP_HERO_LEVEL or type2 == Const.T11GameEventCompleteType.LW_HERO_UP_STAR or type2 == Const.T11GameEventCompleteType.WEAPON_LV_ARRIVE or type2 == Const.T11GameEventCompleteType.BUILDING_LV or type2 == Const.T11GameEventCompleteType.SOLDIER_MAX_LEVEL or type2 == Const.T11GameEventCompleteType.LW_HERO_UP_STAR_ANY
end

function UIIdleGameTaskEventDetailView:OnBtnCloseClick()
  self.view.ctrl:CloseSelf()
end

function UIIdleGameTaskEventDetailView:OnBtnDeleteClick()
  UIUtil.ShowMessage(Localization:GetString("t11_idle_game_desc_93"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    if self.gameEventData and self.gameEventData.uuid then
      DataCenter.T11IdleGameDataManager:SendIdleGameEventDeleteMessage(self.gameEventData.uuid)
    end
  end, nil, nil, "t11_idle_game_title_93", nil, nil, nil, nil, nil, nil, CS.UnityEngine.TextAnchor.MiddleLeft, nil, nil, nil, false)
end

return UIIdleGameTaskEventDetailView
