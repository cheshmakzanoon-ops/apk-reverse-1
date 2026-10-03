local UIWinterStormBattleResultS0View = BaseClass("UIWinterStormBattleResultS0View", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIWS_BattleResultACCell = require("UI.UIActivityCenterTable.Component.ActWinterStorm.Result.Component.UIWS_BattleResultACCell")
local ActMgr = DataCenter.ActWinterStormManager
local MVP_COMP_CLS = "UI.UIActivityCenterTable.Component.ActWinterStorm.Result.Component.UIWS_BattleResultMvpComp"
local MVP_COMP_PREFAB = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/UIWS_BattleResultMvpComp.prefab"
local ACHIEVEMENT_COMP_CLS = "UI.UIActivityCenterTable.Component.ActWinterStorm.Result.Component.UIWS_BattleResultAchievement"
local ACHIEVEMENT_COMP_PREFAB = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/S0/UIWS_BattleResultAchievement.prefab"

function UIWinterStormBattleResultS0View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWinterStormBattleResultS0View:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWinterStormBattleResultS0View:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compResult = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compVictoryGo = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compLoseGo = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compBoxList = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compVTip = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compCell1 = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compCell2 = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.compCell3 = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.compCell4 = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.textDesc2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textDesc3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textDesc1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textDesc4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textScore2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.textScore4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textScore3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.textScore1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.btnArrow = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnArrow:SetOnClick(function()
    self:OnBtnArrowClick()
  end)
  self.compArrow = self.viewSkin:AddComponent(self, UIBaseComponent, 21)
  self.compContent3 = self.viewSkin:AddComponent(self, UIBaseContainer, 22)
  self.compCell = self.viewSkin:AddComponent(self, UIBaseComponent, 23)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 24)
  self.textVTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 25)
  self.imgMvpIcon = self.viewSkin:AddComponent(self, UIImage, 26)
  self.compBg1 = self.viewSkin:AddComponent(self, UIBaseComponent, 27)
  self.compBg2 = self.viewSkin:AddComponent(self, UIBaseComponent, 28)
  self.compBg3 = self.viewSkin:AddComponent(self, UIBaseComponent, 29)
  self.compBg4 = self.viewSkin:AddComponent(self, UIBaseComponent, 30)
  self.btnScrollRect = self.viewSkin:AddComponent(self, UIButton, 31)
  self.btnScrollRect:SetOnClick(function()
    self:OnBtnScrollRectClick()
  end)
end

function UIWinterStormBattleResultS0View:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.compResult = nil
  self.compVictoryGo = nil
  self.compLoseGo = nil
  self.compBoxList = nil
  self.textScore = nil
  self.compVTip = nil
  self.compCell1 = nil
  self.compCell2 = nil
  self.compCell3 = nil
  self.compCell4 = nil
  self.textDesc2 = nil
  self.textDesc3 = nil
  self.textDesc1 = nil
  self.textDesc4 = nil
  self.textScore2 = nil
  self.textScore4 = nil
  self.textScore3 = nil
  self.textScore1 = nil
  self.btnArrow = nil
  self.compArrow = nil
  self.compContent3 = nil
  self.compCell = nil
  self.compContent = nil
  self.textVTip = nil
  self.imgMvpIcon = nil
  self.compBg1 = nil
  self.compBg2 = nil
  self.compBg3 = nil
  self.compBg4 = nil
  self.btnScrollRect = nil
end

function UIWinterStormBattleResultS0View:DataDefine()
  self.showContent3 = false
  self.compArrow:SetLocalScaleXYZ(1, -1, 1)
  self.fighting_top = ActMgr:CreateBattleInfoAsync(self, self.compResult, 0, function()
    self.fighting_top:SetAnchorMinXY(0, 0.5)
    self.fighting_top:SetAnchorMaxXY(1, 0.5)
    self.fighting_top:SetAnchoredPositionXY(0, 325)
    self.fighting_top:SetAsFirstSibling()
    self:UpdateFightingTop()
  end)
  self.boxList = ActMgr:CreateTaskBoxListAsync(self, self.compBoxList, function()
    if self.boxList ~= nil then
      self.boxList:SetAnchoredPositionXY(0, 0)
    end
  end)
  self.compCell.gameObject:GameObjectCreatePool()
  self.compCell:SetActive(false)
  self.cellList = {
    [BF_RewardPointType.SCORE] = {
      self.compCell1,
      self.textDesc1,
      self.textScore1,
      self.compBg1
    },
    [BF_RewardPointType.MVP] = {
      self.compCell2,
      self.textDesc2,
      self.textScore2,
      self.compBg2
    },
    [BF_RewardPointType.ACHIEVEMENT] = {
      self.compCell3,
      self.textDesc3,
      self.textScore3,
      self.compBg3
    },
    [BF_RewardPointType.RANK] = {
      self.compCell4,
      self.textDesc4,
      self.textScore4,
      self.compBg4
    }
  }
  self:RefreshResult()
  self.ctrl:SignClose()
end

function UIWinterStormBattleResultS0View:DataDestroy()
  if self.scoreTween ~= nil then
    self.scoreTween:Kill()
    self.scoreTween = nil
  end
  if self.bgDelays ~= nil then
    for _, v in pairs(self.bgDelays) do
      v:Stop()
    end
  end
  self.bgDelays = nil
  self.configList = nil
  self.compContent3:RemoveComponents(UIWS_BattleResultACCell)
  self.compCell.gameObject:GameObjectRecycleAll()
  self.boxList = nil
  ActMgr:CleanResult()
end

function UIWinterStormBattleResultS0View:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WinterStormResultAchievementShow, self.RefreshAchievement)
end

function UIWinterStormBattleResultS0View:OnRemoveListener()
  self:RemoveUIListener(EventId.WinterStormResultAchievementShow, self.RefreshAchievement)
  base.OnRemoveListener(self)
end

function UIWinterStormBattleResultS0View:OnBtnPanelClick()
  if self.compResult:GetActive() then
    self.compResult:SetActive(false)
    self:RefreshMvp()
  end
end

function UIWinterStormBattleResultS0View:OnBtnArrowClick()
  self.showContent3 = not self.showContent3
  self.compArrow:SetLocalScaleXYZ(1, self.showContent3 and 1 or -1, 1)
  self:RefreshContentAchievement()
end

function UIWinterStormBattleResultS0View:OnBtnScrollRectClick()
  self:OnBtnPanelClick()
end

function UIWinterStormBattleResultS0View:UpdateFightingTop()
  if not self.compResult:GetActive() or not self.fighting_top:AsyncLoadDone() then
    return
  end
  local resultInfo = ActMgr:GetResult()
  local battleScore = resultInfo ~= nil and resultInfo.battleScore or {}
  local numCL, numCR = 0, 0
  local mySide = ActMgr:GetMySide()
  local otherSide = 0
  if mySide ~= 0 then
    otherSide = mySide == 2 and 1 or 2
  end
  if battleScore ~= nil then
    for side, score in pairs(battleScore) do
      if side == mySide then
        numCL = numCL + score
      elseif side == otherSide then
        numCR = numCR + score
      end
    end
  end
  self.fighting_top:UpdateNum(numCL, numCR, mySide)
end

function UIWinterStormBattleResultS0View:RefreshResult()
  self.compResult:SetActive(true)
  local resultInfo = ActMgr:GetResult()
  local bWin = resultInfo ~= nil and resultInfo.isWin
  self.compVictoryGo:SetActive(bWin)
  self.compVTip:SetActive(bWin)
  self.compLoseGo:SetActive(not bWin)
  local pNum = 1
  if bWin then
    pNum = LuaEntry.DataConfig:TryGetNum("winter_bf_S0", "k2", 1.5)
    self.textVTip:SetLocalText("winter_s0_tips_2", pNum)
  end
  self:UpdateFightingTop()
  local preAdd = self:RefreshContent()
  local boxData = {
    curScore = resultInfo ~= nil and resultInfo.beforeScore or 0,
    preAdd = preAdd
  }
  if self.scoreTween ~= nil then
    self.scoreTween:Kill()
  end
  local sequence = DOTween.Sequence()
  sequence:Append(DOTween.To(function(x)
    self.textScore:SetText(string.GetFormattedSeparatorNum(math.floor(x)))
  end, 0, preAdd, 1.1))
  if bWin then
    local finalAdd = preAdd * pNum
    local delay = 0.8
    sequence:AppendInterval(delay)
    sequence:Append(DOTween.To(function(x)
      self.textScore:SetText(string.GetFormattedSeparatorNum(math.floor(x)))
    end, preAdd, finalAdd, 1.1))
    boxData.finalAdd = finalAdd
    boxData.delay = delay
  end
  self.scoreTween = sequence
  self.boxList:SetData(boxData)
end

function UIWinterStormBattleResultS0View:InitListInfo()
  if self.configList then
    return
  end
  local curGroup = tonumber(BattleFieldUtil.GetBattleFieldCfgValue(BattleFieldType.WinterStorm, BattleFieldTableKey.REWARD_POINT))
  local list = {}
  LocalController:instance():visitTable(TableName.LW_BattleField_RewardPointShow, function(id, lineData)
    local group = lineData:getIntValue("group")
    if group ~= curGroup then
      return
    end
    local info = {
      id = id,
      type = lineData:getIntValue("reward_point_type"),
      desc = lineData:getValue("desc"),
      sort = lineData:getIntValue("final_sort"),
      typeIds = lineData:getValue("type_id_list") or {},
      scoreList = lineData:getValue("score") or {}
    }
    table.insert(list, info)
  end)
  table.sort(list, function(a, b)
    return a.sort < b.sort
  end)
  local l = #list
  for i = 1, l do
    local info = list[i]
    local cl = self.cellList[info.type]
    if cl then
      cl[1]:SetSiblingIndex(i - 1)
    end
  end
  self.configList = list
end

function UIWinterStormBattleResultS0View:RefreshContent()
  self:InitListInfo()
  local resultInfo = ActMgr:GetResult()
  local scoreInfo = resultInfo ~= nil and resultInfo.scoreInfo or {}
  local totalPre = 0
  local delayIdx = 0
  local delayStart = 0.4
  local delayDuration = 0.2
  local delayPart = 0.03
  local delayStartX = 820
  if self.bgDelays ~= nil then
    for _, v in pairs(self.bgDelays) do
      v:Stop()
    end
  end
  self.bgDelays = {}
  for i, config in ipairs(self.configList) do
    local type = config.type
    local list = self.cellList[type]
    if list ~= nil then
      local info = scoreInfo[type]
      local cell = list[1]
      if info == nil then
        cell:SetActive(false)
      else
        local param = type == BF_RewardPointType.ACHIEVEMENT and info.param2 or info.param1
        local _, _, value, preAdd = ActMgr:GetScoreInfo(type, config, param)
        local descKey = config.desc
        local valueStr
        local getFlag = 0 < preAdd
        cell:SetActive(getFlag)
        if getFlag then
          local bg = list[4]
          bg:SetActive(false)
          local textDesc = list[2]
          self.bgDelays[i] = TimerManager:GetInstance():DelayInvoke(function()
            bg:SetActive(true)
            local x, y, z = bg:GetLocalPositionXYZ()
            bg:SetLocalPositionXYZ(x - delayStartX, y, z)
            bg.transform:DOLocalMoveX(x, delayDuration):SetEase(CS.DG.Tweening.Ease.OutQuad)
          end, delayStart + delayIdx * delayPart)
          delayIdx = delayIdx + 1
          if type == BF_RewardPointType.MVP then
            local tbName = DataCenter.ActWinterStormManager:GetCfgValue(BattleFieldTableKey.STAR)
            local line = LocalController:instance():getLine(tbName, param)
            if line ~= nil then
              local icon = line:getValue("icon")
              self.imgMvpIcon:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldMvpPath, icon))
              descKey = line:getValue("name")
            end
            textDesc:SetLocalText(descKey)
          elseif type == BF_RewardPointType.ACHIEVEMENT then
            local cnt = param ~= nil and #param or 0
            valueStr = getFlag and cnt or ""
            self.btnArrow:SetActive(0 < cnt)
            textDesc:SetLocalText(descKey, valueStr)
          elseif type == BF_RewardPointType.RANK then
            valueStr = getFlag and param or ""
            textDesc:SetLocalText(descKey, valueStr, value[2])
          else
            textDesc:SetLocalText(descKey)
          end
          local textScore = list[3]
          textScore:SetText("+" .. preAdd)
          totalPre = totalPre + preAdd
        end
      end
    end
  end
  self:RefreshContentAchievement()
  return totalPre
end

function UIWinterStormBattleResultS0View:RefreshContentAchievement()
  local flag = self.showContent3 and self.btnArrow:GetActive()
  self.compContent3:SetActive(flag)
  if not flag or self.acCells ~= nil then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
    return
  end
  local resultInfo = ActMgr:GetResult()
  local scoreInfo = resultInfo ~= nil and resultInfo.scoreInfo or {}
  local data = scoreInfo[BF_RewardPointType.ACHIEVEMENT] or {}
  local config
  for _, cfg in ipairs(self.configList) do
    if cfg.type == BF_RewardPointType.ACHIEVEMENT then
      config = cfg
      break
    end
  end
  local idList = data.param2 or {}
  ActMgr:SortAchievement(idList)
  local typeIds = config ~= nil and config.typeIds or {}
  local scoreList = config ~= nil and config.scoreList or {}
  local acList = {}
  for _, acId in ipairs(idList) do
    for i, id in ipairs(typeIds) do
      if id == acId then
        local scoreCfg = LocalController:instance():getLine(TableName.Score, scoreList[i])
        if scoreCfg then
          local score = scoreCfg:getIntValue("points")
          local acInfo = {id = id, number = score}
          local theName = "cell" .. i
          local goItem = self.compCell.gameObject:GameObjectSpawn(self.compContent3.transform)
          goItem.name = theName
          goItem:SetActive(true)
          local cell = self.compContent3:AddComponent(UIWS_BattleResultACCell, theName)
          cell:ReInit(acInfo)
          table.insert(acList, acInfo)
        end
      end
    end
  end
  self.acCells = acList
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent3.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
end

function UIWinterStormBattleResultS0View:RefreshMvp()
  if self.mvp ~= nil then
    self.mvp:CanvasShow(true)
    return
  end
  self.mvp = self:LoadComponentAsync(MVP_COMP_CLS, MVP_COMP_PREFAB, self, function()
    self.mvp.gameObject.name = "Mvp"
    self.mvp:SetOffsetMaxXY(0, 0)
    self.mvp:SetOffsetMinXY(0, 0)
  end)
end

function UIWinterStormBattleResultS0View:RefreshAchievement(playerUid)
  local resultInfo = ActMgr:GetResult()
  local mvps = resultInfo ~= nil and resultInfo.mvp or {}
  local mvpInfo
  for _, v in ipairs(mvps) do
    if v.uid == playerUid then
      mvpInfo = v
      break
    end
  end
  if mvpInfo == nil then
    self.mvpInfo = nil
    self:RefreshMvp()
    if self.achievement then
      self.achievement:SetActive(false)
    end
    return
  end
  self.mvpInfo = mvpInfo
  if self.mvp ~= nil then
    self.mvp:CanvasShow(false)
  end
  if self.achievement then
    self.achievement:SetActive(true)
    self.achievement:SetData(self.mvpInfo)
    return
  end
  self.achievement = self:LoadComponentAsync(ACHIEVEMENT_COMP_CLS, ACHIEVEMENT_COMP_PREFAB, self, function()
    self.achievement.gameObject.name = "Achievement"
    self.achievement:SetOffsetMaxXY(0, 0)
    self.achievement:SetOffsetMinXY(0, 0)
    if self.mvpInfo == nil then
      self.achievement:SetActive(false)
      return
    end
    self.achievement:SetActive(true)
    self.achievement:SetData(self.mvpInfo)
  end)
end

return UIWinterStormBattleResultS0View
