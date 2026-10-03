local base = UIBaseContainer
local UIIdleGameTaskEventItem = BaseClass("UIIdleGameTaskEventItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function UIIdleGameTaskEventItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIIdleGameTaskEventItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIIdleGameTaskEventItem:ComponentDefine()
  self.compWorkerIcon = self:AddComponent(UIBaseContainer, "WorkerIcon")
  self.compHeroIcon = self:AddComponent(UIBaseContainer, "HeroIcon")
  self.imgWorkerQuality = self:AddComponent(UIImage, "WorkerIcon/imgWorkerQuality")
  self.imgWorkerIcon = self:AddComponent(UIImage, "WorkerIcon/Mask/ImgWorkerIcon")
  self.imgHeroQuality = self:AddComponent(UIImage, "HeroIcon/imgHeroQuality")
  self.imgHeroIcon = self:AddComponent(UIImage, "HeroIcon/imgHeroIcon")
  self.textSpecialDesc = self:AddComponent(UITextMeshProUGUIEx, "TextPart/SpecialDesc")
  self.textSpecialTtile = self:AddComponent(UITextMeshProUGUIEx, "TextPart/SpecialTtile")
  self.textSpecialProcess = self:AddComponent(UITextMeshProUGUIEx, "TextPart/SpecialProcess")
  self.textNormalDesc = self:AddComponent(UITextMeshProUGUIEx, "TextPart/NormalDesc")
  self.btnClick = self:AddComponent(UIButton, "BtnClick")
  self.btnClick:SetOnClick(function()
    self:OnBtnClickClick()
  end)
  self.compTaskRedPoint = self:AddComponent(UIBaseContainer, "TaskRedPoint")
end

function UIIdleGameTaskEventItem:ComponentDestroy()
  self.imgWorkerQuality = nil
  self.imgWorkerIcon = nil
  self.compWorkerIcon = nil
  self.compHeroIcon = nil
  self.textSpecialDesc = nil
  self.textSpecialTtile = nil
  self.textSpecialProcess = nil
  self.imgHeroQuality = nil
  self.imgHeroIcon = nil
  self.compTaskRedPoint = nil
  self.textNormalDesc = nil
end

function UIIdleGameTaskEventItem:DataDefine()
  self.gameEventData = nil
  self.eventCfgData = nil
  self.questCfgData = nil
end

function UIIdleGameTaskEventItem:DataDestroy()
  self.gameEventData = nil
  self.eventCfgData = nil
  self.questCfgData = nil
end

function UIIdleGameTaskEventItem:OnAddListener()
  base.OnAddListener(self)
end

function UIIdleGameTaskEventItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIIdleGameTaskEventItem:RefreshView(gameEventData)
  if gameEventData == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventItem:RefreshView call with nil gameEventData")
    return
  end
  DataCenter.T11IdleGameManager:PrintEditorCustomLog("UIIdleGameTaskEventItem:RefreshView " .. gameEventData.uuid)
  self.gameEventData = gameEventData
  self.questCfgData = DataCenter.QuestTemplateManager:GetQuestTemplate(gameEventData.questId)
  if self.questCfgData == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventItem:RefreshView call with nil questCfgData")
    return
  end
  self.eventCfgData = DataCenter.T11IdleGameTemplateManager:GetGameEventTemplateById(gameEventData.eventId)
  if self.eventCfgData == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventItem:RefreshView call with nil eventCfgData")
    return
  end
  self.compWorkerIcon:SetActive(self.eventCfgData.event_type == Const.T11GameEventType.NormalEvent)
  self.compHeroIcon:SetActive(self.eventCfgData.event_type ~= Const.T11GameEventType.NormalEvent)
  self.textSpecialTtile:SetActive(self.eventCfgData.event_type ~= Const.T11GameEventType.NormalEvent)
  self.textNormalDesc:SetActive(self.eventCfgData.event_type == Const.T11GameEventType.NormalEvent)
  self.textSpecialDesc:SetActive(self.eventCfgData.event_type ~= Const.T11GameEventType.NormalEvent)
  if self.eventCfgData.event_type == Const.T11GameEventType.NormalEvent then
    local workerCfgData = DataCenter.WorkerTemplateManager:GetShowTemplateById(tonumber(gameEventData.figure))
    if workerCfgData == nil then
      return
    end
    self.imgWorkerQuality:LoadSprite(WorkerUtil.GetWorkerQualityBg(workerCfgData.quality))
    self.imgWorkerIcon:LoadSpriteAuto(HeroUtils.GetHeroIconPath(workerCfgData.appearance, HeroIconType.half_portrait))
    self.textNormalDesc:SetText(Localization:GetString(self.eventCfgData.normal_short_desc, Localization:GetString(workerCfgData.last_name)))
  else
    self.textSpecialTtile:SetLocalText("t11_idle_game_desc_39")
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(tonumber(gameEventData.figure))
    if heroTemplate == nil then
      return
    end
    local icon = HeroUtils.GetQualityIconPath(heroTemplate.quality, false)
    self.imgHeroQuality:LoadSprite(icon)
    local iconPath = HeroUtils.GetHeroIconPath(heroTemplate.appearance)
    self.imgHeroIcon:LoadSpriteAuto(iconPath)
    local strList = string.split(self.eventCfgData.special_quest_name, ";")
    if #strList == 1 then
      self.textSpecialDesc:SetText(Localization:GetString(strList[1]))
    elseif #strList == 2 then
      self.textSpecialDesc:SetText(Localization:GetString(strList[1], strList[2]))
    else
      DataCenter.T11IdleGameManager:PrintRealErrorLog("UIIdleGameTaskEventItem:RefreshView special_quest_name format error, strList count > 2")
    end
  end
  self.textSpecialProcess:SetActive(false)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.textSpecialDesc.transform.parent)
end

function UIIdleGameTaskEventItem:OnBtnClickClick()
  self.view.ctrl:SetCurSelectItemData(self.gameEventData, self.eventCfgData)
  if not string.IsNullOrEmpty(self.eventCfgData.start_plot) then
    if self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_PLOT then
      if self.gameEventData.status == Const.TaskState.NoComplete then
        DataCenter.T11IdleGameDataManager:PlayPlotWithoutRecord(self.eventCfgData.start_plot)
      else
        self.view:OpenUIIdleGameTaskEventDetailView(self.gameEventData)
      end
    else
      local isPlaySuccess = DataCenter.T11IdleGameDataManager:TryPlayPlot(self.gameEventData.uuid, self.eventCfgData.start_plot)
      if not isPlaySuccess then
        self.view:OpenUIIdleGameTaskEventDetailView(self.gameEventData)
      end
    end
  else
    self.view:OpenUIIdleGameTaskEventDetailView(self.gameEventData)
    if self.questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_PLOT then
      Logger.LogError("\229\175\185\232\175\157\228\187\187\229\138\161\230\178\161\230\156\137\233\133\141\231\189\174\229\175\185\232\175\157\239\188\129\232\175\183\230\163\128\230\159\165\239\188\154" .. self.eventCfgData.id)
    end
  end
end

function UIIdleGameTaskEventItem:SetBtnInteractable(state)
  self.btnClick:SetInteractable(state)
end

function UIIdleGameTaskEventItem:SetIsShowRedPoint(state)
  self.compTaskRedPoint:SetActive(self.gameEventData.status == Const.TaskState.CanReceive and state)
end

return UIIdleGameTaskEventItem
