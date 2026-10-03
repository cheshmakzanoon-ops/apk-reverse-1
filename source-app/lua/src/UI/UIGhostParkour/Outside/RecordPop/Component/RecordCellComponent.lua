local base = UIBaseContainer
local RecordCellComponent = BaseClass("RecordCellComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local PlayerItem = require("UI.UIGhostParkour.Outside.RecordPop.Component.PlayerItemComponent")

function RecordCellComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RecordCellComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RecordCellComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTimetitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnShare = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.compRightPlayer = self.viewSkin:AddComponent(self, PlayerItem, 4)
  self.compLeftPlayer = self.viewSkin:AddComponent(self, PlayerItem, 5)
end

function RecordCellComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.textTimetitle = nil
  self.btnShare = nil
  self.compRightPlayer = nil
  self.compLeftPlayer = nil
end

function RecordCellComponent:DataDefine()
end

function RecordCellComponent:DataDestroy()
  self.data = nil
  self.stageId = nil
  self.isWinner = nil
  self.vsName = nil
  self.round = nil
end

function RecordCellComponent:OnAddListener()
  base.OnAddListener(self)
end

function RecordCellComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RecordCellComponent:OnBtnShareClick()
  local share_param = {}
  share_param.data = self.data
  share_param.stageId = self.stageId
  share_param.isWinner = self.isWinner
  share_param.name = self.vsName
  share_param.postType = PostType.GhostParkourRecordType
  share_param.score = self.score
  share_param.round = self.round
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function RecordCellComponent:SetData(data, index)
  self.round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  self.data = data
  if data then
    local record = DataCenter.LWGhostParkourDataManager:GetGhostParkourRecord()
    self.stageId = ""
    if record then
      self.stageId = record.stageId
    end
    local time = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.time)
    self.textTimetitle:SetLocalText("ghost_parkour_run_time", time)
    local isAttack = false
    self.isWinner = false
    if data.attackInfo.uid == LuaEntry.Player.uid then
      isAttack = true
      self.isWinner = data.attackInfo.flag == 1
      local name = data.defendInfo.name
      if not string.IsNullOrEmpty(data.defendInfo.abbr) then
        name = UIUtil.FormatAllianceAndName(data.defendInfo.abbr, name)
      end
      self.vsName = name
      self.score = data.attackInfo.score
    elseif data.defendInfo.uid == LuaEntry.Player.uid then
      self.isWinner = data.defendInfo.flag == 1
      local name = data.attackInfo.name
      if not string.IsNullOrEmpty(data.attackInfo.abbr) then
        name = UIUtil.FormatAllianceAndName(data.attackInfo.abbr, name)
      end
      self.vsName = name
      self.score = data.defendInfo.score
    end
    if isAttack then
      self.imgBg:LoadSpriteAsync("Assets/Main/Sprites/UI/UIGhostParkour/UIGhostParkourMainUI/lrb_YZPK_jilu_bg01.png")
      self.compLeftPlayer:SetData(data.attackInfo, true, self.stageId, data.defendInfo, self.round)
      self.compRightPlayer:SetData(data.defendInfo, false, self.stageId, data.attackInfo, self.round)
    else
      self.imgBg:LoadSpriteAsync("Assets/Main/Sprites/UI/UIGhostParkour/UIGhostParkourMainUI/lrb_YZPK_jilu_bg02.png")
      self.compLeftPlayer:SetData(data.defendInfo, false, self.stageId, data.attackInfo, self.round)
      self.compRightPlayer:SetData(data.attackInfo, true, self.stageId, data.defendInfo, self.round)
    end
  end
end

return RecordCellComponent
