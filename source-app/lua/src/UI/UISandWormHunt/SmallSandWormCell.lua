local SmallSandWormCell = BaseClass("SmallSandWormCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_player_head_path = "UIPlayerHead"
local name_path = "name"
local desc_path = "desc"
local time_path = "time"
local btn_go_path = "BtnGo"

function SmallSandWormCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SmallSandWormCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function SmallSandWormCell:ComponentDefine()
  self.playerHead = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.desc:SetLocalText("season_activity_1000069_desc04")
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_go:SetOnClick(function()
    self:OnClickGoBtn()
  end)
end

function SmallSandWormCell:ComponentDestroy()
  self.playerHead = nil
  self.name = nil
  self.desc = nil
  self.time = nil
  self.btn_go = nil
end

function SmallSandWormCell:DataDefine()
end

function SmallSandWormCell:DataDestroy()
  self.serverId = nil
  self.pointId = nil
end

function SmallSandWormCell:SetData(data)
  if not data then
    return
  end
  self.serverId = data.serverId
  self.pointId = data.pointId
  local victim = data.avatar
  self.playerHead:SetHeadAndFrame(victim.uid, victim.headPic, victim.headPicVer, nil, victim.headSkinId, victim.headSkinET)
  self.name:SetText(UIUtil.FormatAllianceAndName(victim.abbr, victim.name, victim.uid))
  self.time:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(data.createTime))
end

function SmallSandWormCell:OnClickGoBtn()
  if not self.serverId then
    return
  end
  local serverId = self.serverId
  local pos = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World)
  GoToUtil.GotoWorldPos(pos, nil, 0, nil, serverId)
  GoToUtil.CloseAllWindows()
end

return SmallSandWormCell
