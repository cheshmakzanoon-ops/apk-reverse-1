local base = UIBaseContainer
local SelfDataComponent = BaseClass("SelfDataComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

function SelfDataComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SelfDataComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SelfDataComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.uIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 4)
  self.textNormalNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnPlay = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnPlay:SetOnClick(function()
    self:OnBtnPlayClick()
  end)
end

function SelfDataComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textServer = nil
  self.textName = nil
  self.textTime = nil
  self.uIPlayerHead = nil
  self.textNormalNum = nil
  self.btnPlay = nil
end

function SelfDataComponent:DataDefine()
end

function SelfDataComponent:DataDestroy()
end

function SelfDataComponent:OnAddListener()
  base.OnAddListener(self)
end

function SelfDataComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SelfDataComponent:OnBtnPlayClick()
  if self.showInfo and self.stageId then
    local param = {}
    param.type = PVEType.GhostParkour
    param.enterType = PVEEnterType.GhostPlayback
    param.levelId = self.stageId
    local uid = self.showInfo.uid
    if uid == nil or uid == 0 or uid == "" then
      Logger.LogError("GhostParkour -- SelfDataComponent showInfo.uid error")
    end
    local uuid = self.showInfo.uuid
    if uuid == nil or uuid == 0 then
      Logger.LogError("GhostParkour -- SelfDataComponent showInfo.uuid error")
    end
    local firstInfo = {}
    table.copy(self.showInfo, firstInfo)
    param.message = {firstInfo = firstInfo}
    DataCenter.LWBattleManager:Enter(param)
  end
end

function SelfDataComponent:SetItemShow(rankType, data, stageId)
  self.showInfo = data
  self.stageId = stageId
  local allName = LuaEntry.Player.name
  local serverName = LuaEntry.Player.serverId
  if LuaEntry.Player:IsInAlliance() then
    local allInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allInfo and allInfo.abbr then
      serverName = UIUtil.FormatServerAllianceName(serverName, allInfo.abbr)
    else
      serverName = string.format("#%s", serverName)
    end
  else
    serverName = string.format("#%s", serverName)
  end
  self.textServer:SetText(serverName)
  self.textName:SetText(allName)
  self.uIPlayerHead:SetAsMyself()
  self.textNormalNum.gameObject:SetActive(true)
  if data then
    data.uid = LuaEntry.Player:GetUid()
    if data.rank < 1 then
      self.textNormalNum:SetLocalText("challenge_zombie_no_rank")
    else
      self.textNormalNum:SetText(data.rank)
    end
    if data.score and data.score > 0 then
      local time = UITimeManager:GetInstance():GetCompetitionTimeFormat(data.score)
      self.textTime:SetLocalText("ghost_parkour_rank_best_record", time)
      self.btnPlay.gameObject:SetActive(true)
    else
      self.textTime:SetLocalText("ghost_parkour_rank_no_data")
      self.btnPlay.gameObject:SetActive(false)
    end
  end
end

return SelfDataComponent
