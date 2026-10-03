local base = UIBaseContainer
local UIGhostreconMemberCell = BaseClass("UIGhostreconMemberCell", base)
local UIGhostreconMemberTeamItem = require("UI.UIDispatchTask.Ghostrecon.MemberTip.Component.UIGhostreconMemberTeamItem")
local Localization = CS.GameEntry.Localization
local UIGhostreconPlayerItem = require("UI.UIDispatchTask.Ghostrecon.Component.UIGhostreconPlayerItem")
local playerItem_path = "PlayerItem"
local playerName_path = "PlayerName"
local removeBtn_path = "RemoveBtn"
local lineImg_path = "LineImg"
local teamItem1_path = "HeroListContent/TeamItem1"
local teamItem2_path = "HeroListContent/TeamItem2"
local teamItem3_path = "HeroListContent/TeamItem3"

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
  self.playerItem = self:AddComponent(UIGhostreconPlayerItem, playerItem_path)
  self.playerName = self:AddComponent(UIText, playerName_path)
  self.removeBtn = self:AddComponent(UIButton, removeBtn_path)
  self.lineImg = self:AddComponent(UIBaseContainer, lineImg_path)
  self.teamItem1 = self:AddComponent(UIGhostreconMemberTeamItem, teamItem1_path)
  self.teamItem2 = self:AddComponent(UIGhostreconMemberTeamItem, teamItem2_path)
  self.teamItem3 = self:AddComponent(UIGhostreconMemberTeamItem, teamItem3_path)
  self.removeBtn:SetOnClick(Bind(self, self.OnClickRemoveBtn))
end

local function ComponentDestroy(self)
  self.playerItem = nil
  self.playerName = nil
  self.removeBtn = nil
  self.lineImg = nil
  self.teamItem1 = nil
  self.teamItem2 = nil
  self.teamItem3 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.playerData = nil
  self.uuid = nil
end

local function SetData(self, uuid, index, formTeamUp)
  self.uuid = uuid
  local data = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(uuid)
  local playerData = data.memberList[index]
  if playerData then
    self.playerData = playerData
    local cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(data.cfgId)
    self.playerItem:SetData(playerData.memberInfo)
    for i = 1, 3 do
      local heroData = playerData.heroList[i]
      if heroData then
        local isMeet = cfg:CheckHeroMeetSuperCondions(heroData)
        self["teamItem" .. i]:SetData(playerData.heroList[i], isMeet)
      else
        self["teamItem" .. i]:SetEmpty()
      end
    end
    self.playerName:SetText(playerData.memberInfo.name)
    if data:OwnIsLeader() then
      if playerData.memberInfo.uid ~= LuaEntry.Player.uid and formTeamUp then
        self.removeBtn:SetActive(true)
      else
        self.removeBtn:SetActive(false)
      end
    else
      self.removeBtn:SetActive(false)
    end
    if playerData.uid == LuaEntry.Player.uid then
      self.playerName:SetColor(WorldGreenColor)
    else
      self.playerName:SetColor(WorldBlueColor)
    end
  else
    self.playerItem:SetEmpty()
    self.removeBtn:SetActive(false)
    for i = 1, 3 do
      self["teamItem" .. i]:SetEmpty()
    end
  end
end

local function OnClickRemoveBtn(self)
  if self.playerData then
    local param = {}
    param.tipText = Localization:GetString("ghostrecon_066", self.playerData.name)
    param.btnNum = 2
    param.showToggle = false
    
    function param.sureAction()
      SFSNetwork.SendMessage(MsgDefines.GhostReconKickMember, self.uuid, self.playerData.uid)
    end
    
    UIUtil.ShowSecondMessageByParam(param)
  end
end

local function HideLineImg(self)
  self.lineImg:SetActive(false)
end

UIGhostreconMemberCell.OnCreate = OnCreate
UIGhostreconMemberCell.OnDestroy = OnDestroy
UIGhostreconMemberCell.OnEnable = OnEnable
UIGhostreconMemberCell.OnDisable = OnDisable
UIGhostreconMemberCell.ComponentDefine = ComponentDefine
UIGhostreconMemberCell.ComponentDestroy = ComponentDestroy
UIGhostreconMemberCell.DataDefine = DataDefine
UIGhostreconMemberCell.DataDestroy = DataDestroy
UIGhostreconMemberCell.SetData = SetData
UIGhostreconMemberCell.OnClickRemoveBtn = OnClickRemoveBtn
UIGhostreconMemberCell.HideLineImg = HideLineImg
return UIGhostreconMemberCell
