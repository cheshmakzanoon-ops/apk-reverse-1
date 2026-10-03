local UIDesertBattleResultDetailDataView = BaseClass("UIDesertBattleResultDetailDataView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local SingleAllyItem = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleResult.Component.SingleAllyItem")
local BattleResultDataItem = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleResultDetailData.Component.BattleResultDataItem")
local panel_path = "panel"
local selfAlly_path = "AllianceInfo/UserSelf"
local enemyAlly_path = "AllianceInfo/UserOther"
local victoryGo_path = "VictoryGo"
local victoryText_path = "VictoryGo/VictoryText"
local loseGo_path = "LoseGo"
local loseText_path = "LoseGo/DefeatGo/DefeatText"
local content_path = "Content"
local battleStatisticType = {
  "occupyScore",
  "collectScore",
  "brokeScore",
  "killScore",
  "centerControlTime"
}
local manager = DataCenter.ActDragonManager

function UIDesertBattleResultDetailDataView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshPanel()
end

function UIDesertBattleResultDetailDataView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDesertBattleResultDetailDataView:OnAddListener()
  base.OnAddListener(self)
end

function UIDesertBattleResultDetailDataView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDesertBattleResultDetailDataView:ComponentDefine()
  self.selfAlly = self:AddComponent(SingleAllyItem, selfAlly_path)
  self.enemyAlly = self:AddComponent(SingleAllyItem, enemyAlly_path)
  self.victory = self:AddComponent(UIBaseContainer, victoryGo_path)
  self.lose = self:AddComponent(UIBaseContainer, loseGo_path)
  self.listContent = self:AddComponent(UIBaseContainer, content_path)
  self.victoryText = self:AddComponent(UIText, victoryText_path)
  self.victoryText:SetText(Localization:GetString("390186"))
  self.loseText = self:AddComponent(UIText, loseText_path)
  self.loseText:SetText(Localization:GetString("390187"))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function UIDesertBattleResultDetailDataView:ComponentDestroy()
  self.listContent:RemoveComponents(BattleResultDataItem)
  if self.dataList ~= nil then
    for k, v in pairs(self.dataList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.close_btn1 = nil
  self.selfAlly = nil
  self.enemyAlly = nil
  self.victory = nil
  self.lose = nil
  self.victoryText = nil
  self.loseText = nil
  self.listContent = nil
end

function UIDesertBattleResultDetailDataView:RefreshPanel()
  local data = DataCenter.ActDragonManager:GetDragonRecord()
  local myAllianceId = LuaEntry.Player.allianceId
  local dragonInfo = DataCenter.ActDragonManager:GetCurGroup()
  local vsInfoArr = dragonInfo ~= nil and dragonInfo.vsInfoArr or nil
  local selfAllyRecordData = data[myAllianceId]
  if selfAllyRecordData then
    self.victory:SetActive(selfAllyRecordData.win ~= 0)
    self.lose:SetActive(selfAllyRecordData.win == 0)
  end
  local enemyAllyRecordData
  for k, v in pairs(data) do
    if k ~= myAllianceId then
      enemyAllyRecordData = v
    end
  end
  if vsInfoArr then
    for _, v in pairs(vsInfoArr) do
      if v.allianceId == myAllianceId then
        local selfAllyData = {
          icon = v.icon,
          name = v:GetFullName(),
          serverId = v.serverId,
          allyPersonNum = selfAllyRecordData.currPlayerNum,
          allyPersonMaxNum = selfAllyRecordData.maxPlayerNum,
          allyPoint = selfAllyRecordData.score
        }
        self.selfAlly:SetData(selfAllyData)
      else
        local enemyAllyData = {
          icon = v.icon,
          name = v:GetFullName(),
          serverId = v.serverId,
          allyPersonNum = enemyAllyRecordData.currPlayerNum,
          allyPersonMaxNum = enemyAllyRecordData.maxPlayerNum,
          allyPoint = enemyAllyRecordData.score
        }
        self.enemyAlly:SetData(enemyAllyData)
      end
    end
  end
  self:RefreshBattleStatistic()
end

function UIDesertBattleResultDetailDataView:RefreshBattleStatistic()
  local battleStatisticData = {
    {
      selfData = string.GetFormattedSeperatorNum(manager:GetRecordScore(true, battleStatisticType[1])),
      dataName = Localization:GetString("458052"),
      otherData = string.GetFormattedSeperatorNum(manager:GetRecordScore(false, battleStatisticType[1]))
    },
    {
      selfData = string.GetFormattedSeperatorNum(manager:GetRecordScore(true, battleStatisticType[2])),
      dataName = Localization:GetString("458053"),
      otherData = string.GetFormattedSeperatorNum(manager:GetRecordScore(false, battleStatisticType[2]))
    },
    {
      selfData = string.GetFormattedSeperatorNum(manager:GetRecordScore(true, battleStatisticType[3])),
      dataName = Localization:GetString("458054"),
      otherData = string.GetFormattedSeperatorNum(manager:GetRecordScore(false, battleStatisticType[3]))
    },
    {
      selfData = string.GetFormattedSeperatorNum(manager:GetRecordScore(true, battleStatisticType[4])),
      dataName = Localization:GetString("458055"),
      otherData = string.GetFormattedSeperatorNum(manager:GetRecordScore(false, battleStatisticType[4]))
    },
    {
      selfData = UITimeManager:GetInstance():MilliSecondToFmtString(manager:GetRecordScore(true, battleStatisticType[5])),
      dataName = Localization:GetString("458056"),
      otherData = UITimeManager:GetInstance():MilliSecondToFmtString(manager:GetRecordScore(false, battleStatisticType[5]))
    }
  }
  self.dataList = {}
  for i = 1, #battleStatisticType do
    self.dataList[i] = self:GameObjectInstantiateAsync(UIAssets.UIDesertBattleResultDataItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.listContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(i)
      go.name = nameStr
      local cell = self.listContent:AddComponent(BattleResultDataItem, go.name)
      cell:SetData(battleStatisticData[i])
    end)
  end
end

return UIDesertBattleResultDetailDataView
