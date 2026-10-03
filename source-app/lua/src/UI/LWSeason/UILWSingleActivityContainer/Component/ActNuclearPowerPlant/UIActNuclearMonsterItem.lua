local base = UIBaseContainer
local UIActNuclearMonsterItem = BaseClass("UIActNuclearMonsterItem", base)
local Localization = CS.GameEntry.Localization
local UICommonTipsView = require("UI.UICommonTips.View.UICommonTipsView")
local monsterName_path = "monsterInfo/monsterName"
local progressFront_path = "monsterInfo/progressArea/progress/progressFront"
local progressDes_path = "monsterInfo/progressArea/progress/progressDes"
local localtion_path = "monsterInfo/location"
local monsterState_path = "monsterInfo/monsterState"
local checkBtn_path = "monsterInfo/checkBtn"
local monsterTip_path = "monsterInfo/monsterState/tip"
local arriveDes_path = "monsterInfo/arriveDes"
local monsterInfo_path = "monsterInfo"
local killerInfo_path = "killerInfo"
local killerHead_path = "killerInfo/player"
local killerName_path = "killerInfo/killerName"
local killTime_path = "killerInfo/killTime"
local gotoBtn_path = "monsterInfo/monsterName/gotBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.monsterName = self:AddComponent(UIText, monsterName_path)
  self.progressFront = self:AddComponent(UIBaseContainer, progressFront_path)
  self.progressDes = self:AddComponent(UIText, progressDes_path)
  self.localtion = self:AddComponent(UIText, localtion_path)
  self.monsterState = self:AddComponent(UIText, monsterState_path)
  self.checkBtn = self:AddComponent(UIButton, checkBtn_path)
  self.monsterTip = self:AddComponent(UIButton, monsterTip_path)
  self.arriveDes = self:AddComponent(UIText, arriveDes_path)
  self.monsterInfo = self:AddComponent(UIBaseContainer, monsterInfo_path)
  self.killerInfo = self:AddComponent(UIBaseContainer, killerInfo_path)
  self.killerHead = self:AddComponent(UIBaseContainer, killerHead_path)
  self.killerName = self:AddComponent(UIText, killerName_path)
  self.killTime = self:AddComponent(UIText, killTime_path)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.playerHeadCom = self:AddComponent(UICommonHead, killerHead_path)
  self.checkBtn:SetSafeClickMode(true)
  self.checkBtn:SetOnClick(function()
    self:OnCheckBtnClick()
  end)
  self.gotoBtn:SetSafeClickMode(true)
  self.gotoBtn:SetOnClick(function()
    self:OnCheckBtnClick()
  end)
  self.monsterTip:SetSafeClickMode(true)
  self.monsterTip:SetOnClick(function()
    self:MonsterTipBtn()
  end)
end

local function ComponentDestroy(self)
  self.monsterName = nil
  self.progressFront = nil
  self.progressDes = nil
  self.localtion = nil
  self.monsterState = nil
  self.checkBtn = nil
  self.monsterTip = nil
  self.arriveDes = nil
  self.monsterInfo = nil
  self.killerInfo = nil
  self.killerHead = nil
  self.killerName = nil
  self.killTime = nil
  self.gotoBtn = nil
  self.playerHeadCom = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIActNuclearMonsterItem:SetData(data)
  self.arriveTime = nil
  self.data = data
  if self.data.killUserInfo and self.data.armyUnit == 0 then
    self.killerInfo:SetActive(true)
    self.monsterInfo:SetActive(false)
    self.playerHeadCom:SetEnableClickShowInfo(true)
    self.playerHeadCom:ParseHeadInfo(self.data.killUserInfo)
    self.killerName:SetText(UIUtil.FormatServerAllianceName(self.data.killUserInfo.srcServer, self.data.killUserInfo.abbr, self.data.killUserInfo.name))
    if self.data.killTime and 0 < self.data.killTime then
      self.killTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(self.data.killTime))
    else
      self.killTime:SetText("")
    end
  elseif self.data.armyUnit > 0 then
    self.monsterInfo:SetActive(true)
    self.killerInfo:SetActive(false)
    local config = LocalController:instance():getLine(TableName.Season_Congress_Boss, self.data.id)
    local name
    if config then
      local bossName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), config.boss_monster, "name")
      name = Localization:GetString(bossName)
    end
    if self.data.serverId then
      self.monsterName:SetText("[#" .. self.data.serverId .. "] " .. name)
    else
      self.monsterName:SetText(name)
    end
    local r = self.data.bossHp
    if 1 < r then
      r = 1
    elseif r < 0 then
      r = 0
    end
    self.progressFront.gameObject.transform:Set_localScale(r, 1, 1)
    r = r * 100
    r = math.floor(r * 100) / 100
    local hpText = Localization:GetString("season_s2_activity_1000047_description_14", tostring(r) .. "%")
    self.progressDes:SetText(hpText)
    local pos = SceneUtils.TileIndexToWorld(self.data.endPointId, ForceChangeScene.World)
    self.localtion:SetText(string.format("X: %s, Y: %s", tostring(pos.x), tostring(pos.y)))
    self.monsterState:SetActive(self.data.marchState ~= MarchStatus.BEHEMOTH_ATTACK_CITY and self.data.marchState ~= MarchStatus.BEHEMOTH_ARRIVING)
    self.checkBtn:SetActive(self.data.marchState == MarchStatus.BEHEMOTH_ATTACK_CITY or self.data.marchState == MarchStatus.BEHEMOTH_ARRIVING)
    if self.data.marchState == MarchStatus.MOVING then
      self.arriveTime = self.data.march.endTime
      local now = UITimeManager:GetInstance():GetServerTime()
      local time = self.arriveTime - now
      if 0 < time then
        local strExpireTime = UITimeManager:GetInstance():SecondToFmtString(time / 1000)
        self.arriveDes:SetText(Localization:GetString("season_s2_activity_1000047_description_27", strExpireTime))
        self.arriveDes:SetActive(true)
      else
        self.arriveDes:SetActive(false)
        self.arriveTime = nil
      end
    else
      self.arriveDes:SetActive(false)
    end
  else
    self.monsterInfo:SetActive(false)
    self.killerInfo:SetActive(false)
  end
end

function UIActNuclearMonsterItem:Update1000MS()
  if self.arriveTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local time = self.arriveTime - now
    if 0 < time then
      local strExpireTime = UITimeManager:GetInstance():SecondToFmtString(time / 1000)
      self.arriveDes:SetText(Localization:GetString("season_s2_activity_1000047_description_27", strExpireTime))
    else
      self.arriveDes:SetActive(false)
      self.arriveTime = nil
    end
  end
end

function UIActNuclearMonsterItem:OnCheckBtnClick()
  if self.data then
    if self.data.marchState == MarchStatus.BEHEMOTH_ATTACK_CITY or self.data.marchState == MarchStatus.BEHEMOTH_ARRIVING then
      GoToUtil.CloseAllWindows()
      local pos = SceneUtils.TileIndexToWorld(self.data.startPointId, ForceChangeScene.World)
      local monsterUuid = self.data.uuid
      local serverId = self.data.serverId
      GoToUtil.GotoWorldPos(pos, nil, nil, function()
        if monsterUuid then
          local marchInfo = CS.SceneManager.World:GetMarch(monsterUuid)
          if marchInfo ~= nil then
            UIUtil.OnClickWorldTroop(monsterUuid)
          else
            DataCenter.WorldPointWaitOpenManager:SetWaitOpenPointData(nil, nil, monsterUuid)
          end
        end
      end, serverId, nil)
    elseif self.data.marchState == MarchStatus.MOVING then
      local startPos = SceneUtils.TileIndexToWorld(self.data.startPointId, ForceChangeScene.World)
      local endPos = SceneUtils.TileIndexToWorld(self.data.endPointId, ForceChangeScene.World)
      local now = UITimeManager:GetInstance():GetServerTime()
      local r = (now - self.data.startTime) / (self.data.endTime - self.data.startTime)
      if r < 0 then
        r = 0
      elseif 1 < r then
        r = 1
      end
      local curPos = Vector3.Lerp(startPos, endPos, r)
      local curIndex = SceneUtils.WorldToTileIndex(curPos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      local pos = SceneUtils.TileIndexToWorld(curIndex, ForceChangeScene.World)
      local monsterUuid = self.data.uuid
      local serverId = self.data.serverId
      GoToUtil.GotoWorldPos(pos, nil, nil, function()
        if monsterUuid then
          local marchInfo = CS.SceneManager.World:GetMarch(monsterUuid)
          if marchInfo ~= nil then
            UIUtil.OnClickWorldTroop(monsterUuid)
          else
            DataCenter.WorldPointWaitOpenManager:SetWaitOpenPointData(nil, nil, monsterUuid)
          end
        end
      end, serverId, nil)
    end
  end
end

function UIActNuclearMonsterItem:MonsterTipBtn()
  local param = UICommonTipsView.ParamDataClass.New()
  param.content = Localization:GetString("season_s2_activity_1000047_description_05")
  param.position = self.monsterTip:GetPosition()
  param.deltaY = -20
  param.contentX = -20
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonTips, {anim = false}, param)
end

UIActNuclearMonsterItem.OnCreate = OnCreate
UIActNuclearMonsterItem.OnDestroy = OnDestroy
UIActNuclearMonsterItem.OnEnable = OnEnable
UIActNuclearMonsterItem.OnDisable = OnDisable
UIActNuclearMonsterItem.ComponentDefine = ComponentDefine
UIActNuclearMonsterItem.ComponentDestroy = ComponentDestroy
UIActNuclearMonsterItem.DataDefine = DataDefine
UIActNuclearMonsterItem.DataDestroy = DataDestroy
return UIActNuclearMonsterItem
