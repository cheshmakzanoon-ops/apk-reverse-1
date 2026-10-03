local base = UIAsyncContainer
local UIEBR_Detail = BaseClass("UIEBR_Detail", base)
local Localization = CS.GameEntry.Localization
local UIEBR_VsInfo = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleResult.Component.UIEBR_VsInfo")
local UIEBR_DetailItem = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleResult.Component.UIEBR_DetailItem")
local victoryGo_path = "VictoryGo"
local loseGo_path = "LoseGo"
local vsInfo_path = "VsInfo"
local content_path = "Content"
local Prefab = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleResultDetailItem.prefab"

function UIEBR_Detail:OnCreate()
  base.OnCreate(self)
  self.victory = self:AddComponent(UIBaseContainer, victoryGo_path)
  self.lose = self:AddComponent(UIBaseContainer, loseGo_path)
  self.vsInfo = self:AddComponent(UIEBR_VsInfo, vsInfo_path)
  self.listContent = self:AddComponent(UIBaseContainer, content_path)
end

function UIEBR_Detail:OnDestroy()
  self.listContent:RemoveComponents(UIEBR_DetailItem)
  if self.dataList ~= nil then
    for _, v in pairs(self.dataList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.dataList = nil
  end
  self.victory = nil
  self.lose = nil
  self.vsInfo = nil
  self.listContent = nil
  base.OnDestroy(self)
end

function UIEBR_Detail:UpdateData()
  local msg = self.view.msg
  local bWin, myInfo, otherInfo = self.vsInfo:SetData(msg)
  local soundId = 0
  if bWin then
    soundId = toInt(BattleFieldUtil.GetBattleFieldCfgValue(BattleFieldType.EpidemicZone, BattleFieldTableKey.SOUND_VICTORY))
  else
    soundId = toInt(BattleFieldUtil.GetBattleFieldCfgValue(BattleFieldType.EpidemicZone, BattleFieldTableKey.SOUND_DEFEAT))
  end
  if soundId ~= 0 then
    DataCenter.LWSoundManager:PlaySound(soundId, false)
  end
  self.victory:SetActive(bWin)
  self.lose:SetActive(not bWin)
  if myInfo == nil or otherInfo == nil then
    return
  end
  local valueKeys = {
    "occupiedScore",
    "resourceScore",
    "plunderScore",
    "electricOccupiedTime",
    "centerOccupiedTime"
  }
  local datas = {
    {
      string.GetFormattedSeperatorNum(myInfo[valueKeys[1]]),
      Localization:GetString("YiBianJinQu_battle_result_tips_1"),
      string.GetFormattedSeperatorNum(otherInfo[valueKeys[1]])
    },
    {
      string.GetFormattedSeperatorNum(myInfo[valueKeys[2]]),
      Localization:GetString("YiBianJinQu_battle_result_tips_2"),
      string.GetFormattedSeperatorNum(otherInfo[valueKeys[2]])
    },
    {
      string.GetFormattedSeperatorNum(myInfo[valueKeys[3]]),
      Localization:GetString("YiBianJinQu_battle_result_tips_3"),
      string.GetFormattedSeperatorNum(otherInfo[valueKeys[3]])
    },
    {
      UITimeManager:GetInstance():SecondToFmtString(myInfo[valueKeys[4]] or 0),
      Localization:GetString("YiBianJinQu_battle_result_tips_4"),
      UITimeManager:GetInstance():SecondToFmtString(otherInfo[valueKeys[4]] or 0)
    },
    {
      UITimeManager:GetInstance():SecondToFmtString(myInfo[valueKeys[5]] or 0),
      Localization:GetString("YiBianJinQu_battle_result_tips_5"),
      UITimeManager:GetInstance():SecondToFmtString(otherInfo[valueKeys[5]] or 0)
    }
  }
  self.dataList = {}
  for i, v in ipairs(datas) do
    self.dataList[i] = self:GameObjectInstantiateAsync(Prefab, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.listContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(i)
      go.name = nameStr
      local cell = self.listContent:AddComponent(UIEBR_DetailItem, go.name)
      cell:SetData(v)
    end)
  end
end

return UIEBR_Detail
