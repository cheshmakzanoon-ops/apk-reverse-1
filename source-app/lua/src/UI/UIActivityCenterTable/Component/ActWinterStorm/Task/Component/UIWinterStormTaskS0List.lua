local base = UIAsyncContainer
local UIWinterStormTaskS0List = BaseClass("UIWinterStormTaskS0List", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.ActWinterStormManager
local G_COLOR = "#099b4a"
local R_COLOR = "#E24D46"

function UIWinterStormTaskS0List:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWinterStormTaskS0List:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWinterStormTaskS0List:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textScore2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnInfo1 = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnInfo1:SetOnClick(function()
    self:OnBtnInfo1Click()
  end)
  self.compIcon2 = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.btnInfo2 = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnInfo2:SetOnClick(function()
    self:OnBtnInfo2Click()
  end)
  self.textDesc2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textDesc1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textDesc3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textDesc4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compIcon1 = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.textScore1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnDesc4 = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnDesc4:SetOnClick(function()
    self:OnBtnDesc4Click()
  end)
  self.btnDesc2 = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnDesc2:SetOnClick(function()
    self:OnBtnDesc2Click()
  end)
  self.btnDesc3 = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnDesc3:SetOnClick(function()
    self:OnBtnDesc3Click()
  end)
  self.compCell1 = self.viewSkin:AddComponent(self, UIBaseComponent, 14)
  self.compCell2 = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.compCell3 = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.compCell4 = self.viewSkin:AddComponent(self, UIBaseComponent, 17)
  self.textScore3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.textScore4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.compIcon4 = self.viewSkin:AddComponent(self, UIBaseComponent, 20)
  self.btnInfo4 = self.viewSkin:AddComponent(self, UIButton, 21)
  self.btnInfo4:SetOnClick(function()
    self:OnBtnInfo4Click()
  end)
end

function UIWinterStormTaskS0List:ComponentDestroy()
  self.viewSkin = nil
  self.textScore2 = nil
  self.btnInfo1 = nil
  self.compIcon2 = nil
  self.btnInfo2 = nil
  self.textDesc2 = nil
  self.textDesc1 = nil
  self.textDesc3 = nil
  self.textDesc4 = nil
  self.compIcon1 = nil
  self.textScore1 = nil
  self.btnDesc4 = nil
  self.btnDesc2 = nil
  self.btnDesc3 = nil
  self.compCell1 = nil
  self.compCell2 = nil
  self.compCell3 = nil
  self.compCell4 = nil
  self.textScore3 = nil
  self.textScore4 = nil
  self.compIcon4 = nil
  self.btnInfo4 = nil
end

function UIWinterStormTaskS0List:DataDefine()
  self.values = {}
  self.cellList = {
    [BF_RewardPointType.SCORE] = {
      self.compCell1,
      self.textDesc1,
      self.textScore1
    },
    [BF_RewardPointType.MVP] = {
      self.compCell2,
      self.textDesc2,
      self.textScore2
    },
    [BF_RewardPointType.ACHIEVEMENT] = {
      self.compCell3,
      self.textDesc3,
      self.textScore3
    },
    [BF_RewardPointType.RANK] = {
      self.compCell4,
      self.textDesc4,
      self.textScore4
    }
  }
  self:ShortCellList()
end

function UIWinterStormTaskS0List:DataDestroy()
  self.values = nil
  self.configList = nil
end

function UIWinterStormTaskS0List:OnAddListener()
  base.OnAddListener(self)
end

function UIWinterStormTaskS0List:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWinterStormTaskS0List:OnBtnInfo1Click()
  local min = self.values[BF_RewardPointType.SCORE] or 0
  local strTip = Localization:GetString("winter_s0_reward_engage_requirement_info", min)
  UIUtil.ShowBubbleTips(strTip, self.compIcon1.transform.position, 0, 30, 30, nil, nil, {reversal = true})
end

function UIWinterStormTaskS0List:OnBtnInfo2Click()
  local strTip = Localization:GetString("winter_s0_tips_7")
  UIUtil.ShowBubbleTips(strTip, self.compIcon2.transform.position, 0, 30, 30, nil, nil, {reversal = true})
end

function UIWinterStormTaskS0List:OnBtnInfo4Click()
  local values = self.values[BF_RewardPointType.RANK]
  local min = values ~= nil and values[2] or 0
  local strTip = Localization:GetString("winter_s0_final_ranking_requirement_info", min)
  UIUtil.ShowBubbleTips(strTip, self.compIcon4.transform.position, 0, 30, 30, nil, nil, {reversal = true})
end

function UIWinterStormTaskS0List:OnBtnDesc2Click()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:OpenScoreRules(BF_RewardPointType.MVP)
end

function UIWinterStormTaskS0List:OnBtnDesc3Click()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:OpenScoreRules(BF_RewardPointType.ACHIEVEMENT)
end

function UIWinterStormTaskS0List:OnBtnDesc4Click()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:OpenScoreRules(BF_RewardPointType.RANK)
end

function UIWinterStormTaskS0List:OpenScoreRules(idx)
  EventManager:GetInstance():Broadcast(EventId.WinterStormTaskDetailShow, idx)
end

function UIWinterStormTaskS0List:InitListInfo()
  if self.configList == nil then
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
        desc = lineData:getValue("reward_desc"),
        sort = lineData:getValue("reward_sort"),
        typeIds = lineData:getValue("type_id_list") or {},
        scoreList = lineData:getValue("score") or {}
      }
      table.insert(list, info)
    end)
    table.sort(list, function(a, b)
      return a.sort < b.sort
    end)
    self.configList = list
  end
  return self.configList
end

function UIWinterStormTaskS0List:ShortCellList()
  local list = self:InitListInfo()
  local l = #list
  for i = 1, l do
    local info = list[i]
    local cl = self.cellList[info.type]
    if cl then
      cl[1]:SetSiblingIndex(i - 1)
    end
  end
end

function UIWinterStormTaskS0List:GetScoreStr(cFlag, bAdd, min, max, ignoreSame)
  local scoreStr
  local color = cFlag and G_COLOR or R_COLOR
  local concatStr = bAdd and "-" or "/"
  local plusStr = bAdd and "+" or ""
  local minStr = string.GetFormattedStr(min)
  if max == nil or not ignoreSame and min == max then
    scoreStr = string.format("<color=%s>%s%s</color>", color, plusStr, minStr)
  else
    local maxStr = string.GetFormattedStr(max)
    scoreStr = string.format("<color=%s>%s%s%s%s</color>", color, plusStr, minStr, concatStr, maxStr)
  end
  return scoreStr
end

function UIWinterStormTaskS0List:ShowBase()
  if not self:AsyncLoadDone() then
    return
  end
  self.compIcon2:SetActive(false)
  self.btnInfo2:SetActive(false)
  local cfgList = self:InitListInfo()
  for _, config in ipairs(cfgList) do
    local type = config.type
    local list = self.cellList[type]
    if list then
      local min, max, value = ActMgr:GetScoreInfo(type, config)
      self.values[type] = value
      local textDesc = list[2]
      local valueStr = ""
      if type == BF_RewardPointType.SCORE then
        valueStr = self:GetScoreStr(true, false, value)
        self.value1 = value
        textDesc:SetLocalText(config.desc, valueStr)
      elseif type == BF_RewardPointType.RANK then
        textDesc:SetLocalText(config.desc, value[2])
      elseif string.IsNullOrEmpty(valueStr) then
        textDesc:SetLocalText(config.desc)
      else
        textDesc:SetLocalText(config.desc, valueStr)
      end
      local scoreStr = self:GetScoreStr(true, true, min, max)
      local textScore = list[3]
      textScore:SetText(scoreStr)
    end
  end
end

function UIWinterStormTaskS0List:ShowBattle(data)
  if self.compIcon2 ~= nil then
    self.compIcon2:SetActive(true)
  end
  if self.btnInfo2 ~= nil then
    self.btnInfo2:SetActive(true)
  end
  local scoreInfo = {}
  if not table.IsNullOrEmpty(data) then
    for _, v in ipairs(data) do
      scoreInfo[v.type] = v
    end
  end
  local totalPre = 0
  local cfgList = self:InitListInfo()
  local cellList = self.cellList or {}
  for _, config in ipairs(cfgList) do
    local type = config.type
    local list = cellList[type]
    local info = scoreInfo[type] or {}
    local param = type == BF_RewardPointType.ACHIEVEMENT and info.param2 or info.param1
    local min, max, value, preAdd = ActMgr:GetScoreInfo(type, config, param)
    if self.values then
      self.values[type] = value
    end
    local valueStr
    local getFlag = 0 < preAdd
    local textDesc = list ~= nil and list[2] or nil
    if type == BF_RewardPointType.SCORE then
      if textDesc ~= nil then
        local score = math.min(param or 0, value)
        valueStr = self:GetScoreStr(getFlag, false, score, value, true)
        textDesc:SetLocalText(config.desc, valueStr)
      end
    elseif type == BF_RewardPointType.ACHIEVEMENT then
      if textDesc ~= nil then
        valueStr = getFlag and Localization:GetString("winter_s0_tips_5", #param) or ""
        textDesc:SetText(Localization:GetString(config.desc) .. valueStr)
      end
    elseif type == BF_RewardPointType.RANK then
      local limit = value[2] or 0
      if getFlag then
        local sTypeInfo = scoreInfo[BF_RewardPointType.SCORE] or {}
        local curSNum = sTypeInfo.param1 or 0
        getFlag = limit <= curSNum
        if not getFlag then
          preAdd = 0
        end
      end
      if textDesc ~= nil then
        valueStr = getFlag and Localization:GetString("winter_s0_tips_6", param) or ""
        textDesc:SetText(Localization:GetString(config.desc, limit) .. valueStr)
      end
    elseif textDesc ~= nil then
      textDesc:SetLocalText(config.desc)
    end
    local textScore = list ~= nil and list[3] or nil
    if textScore ~= nil then
      local scoreStr
      if getFlag then
        scoreStr = self:GetScoreStr(true, true, preAdd)
      else
        scoreStr = self:GetScoreStr(false, true, min, max)
      end
      textScore:SetText(scoreStr)
    end
    totalPre = totalPre + preAdd
  end
  return totalPre
end

return UIWinterStormTaskS0List
