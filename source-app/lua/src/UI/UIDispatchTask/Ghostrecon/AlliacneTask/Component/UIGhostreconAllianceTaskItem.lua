local base = UIBaseContainer
local UIGhostreconAllianceTaskItem = BaseClass("UIGhostreconAllianceTaskItem", base)
local Localization = CS.GameEntry.Localization
local UIHeroCellTiny = require("UI.UIHero2.Common.UIHeroCellTiny")
local HeroCellType = {
  CanUse = "ghostrecon_080",
  UnHave = "ghostrecon_081",
  InTask = "ghostrecon_082",
  UnderStar = "ghostrecon_083",
  UnderLevel = "ghostrecon_084"
}
local UIGhostreconPlayerItem = require("UI.UIDispatchTask.Ghostrecon.Component.UIGhostreconPlayerItem")
local rewardBtn_path = "Holder/RewardBtn"
local taskText_path = "Holder/TaskTxt"
local leaderHead_path = "Holder/LeaderHeadHolder/LeaderHead"
local leaderNameText_path = "Holder/LeaderHeadHolder/LeaderNameTxt"
local timeText_path = "Holder/LeaderHeadHolder/TimeTxt"
local playerHead1_path = "Holder/PlayerHeadHolder/PlayerHead/Player1"
local playerHead2_path = "Holder/PlayerHeadHolder/PlayerHead/Player2"
local playerHead3_path = "Holder/PlayerHeadHolder/PlayerHead/Player3"
local playerHead4_path = "Holder/PlayerHeadHolder/PlayerHead/Player4"
local buildBg_path = "Holder/Build/BuildBg"
local buildImg_path = "Holder/Build/BuildBg/BuildImg"
local posText_path = "Holder/Build/PosTxt"
local needTimeText_path = "Holder/Build/Time/NeedTimeText"
local qualityImg_path = "Holder/Build/QualityImg"
local bg_path = "Holder/Bg"
local lvText_path = "Holder/Build/LvTxt"
local heroCell1_path = "Holder/Build/HeroList/HeroCell1"
local heroCell2_path = "Holder/Build/HeroList/HeroCell2"

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
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.taskText = self:AddComponent(UIText, taskText_path)
  self.leaderHead = self:AddComponent(UIGhostreconPlayerItem, leaderHead_path)
  self.leaderNameText = self:AddComponent(UIText, leaderNameText_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
  self.playerHead1 = self:AddComponent(UIGhostreconPlayerItem, playerHead1_path)
  self.playerHead2 = self:AddComponent(UIGhostreconPlayerItem, playerHead2_path)
  self.playerHead3 = self:AddComponent(UIGhostreconPlayerItem, playerHead3_path)
  self.playerHead4 = self:AddComponent(UIGhostreconPlayerItem, playerHead4_path)
  self.buildBg = self:AddComponent(UIRawImage, buildBg_path)
  self.buildImg = self:AddComponent(UIRawImage, buildImg_path)
  self.posText = self:AddComponent(UIText, posText_path)
  self.needTimeText = self:AddComponent(UIText, needTimeText_path)
  self.qualityImg = self:AddComponent(UIImage, qualityImg_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.lvText = self:AddComponent(UIText, lvText_path)
  self.rewardBtn:SetOnClick(Bind(self, self.OnClickRewardBtn))
  self.posBtn = self:AddComponent(UIButton, posText_path)
  self.posBtn:SetOnClick(Bind(self, self.OnJoinClick))
  self.heroCell1 = self:AddComponent(UIHeroCellTiny, heroCell1_path)
  self.heroCellBtn1 = self:AddComponent(UIButton, heroCell1_path)
  self.heroCell2 = self:AddComponent(UIHeroCellTiny, heroCell2_path)
  self.heroCellBtn2 = self:AddComponent(UIButton, heroCell2_path)
end

local function ComponentDestroy(self)
  self.rewardBtn = nil
  self.taskText = nil
  self.leaderHead = nil
  self.leaderNameText = nil
  self.timeText = nil
  self.playerHead1 = nil
  self.playerHead2 = nil
  self.playerHead3 = nil
  self.playerHead4 = nil
  self.buildBg = nil
  self.buildImg = nil
  self.posText = nil
  self.needTimeText = nil
  self.qualityImg = nil
  self.bg = nil
  self.lvText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.uuid = nil
  self.data = nil
  self.cfg = nil
  self.heroCellType = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function SetData(self, uuid)
  self.uuid = uuid
  self.data = DataCenter.ActGhostreconAllianceManager:GetAllianceTaskInfoByUUid(uuid)
  self.cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(self.data.cfgId)
  self.taskText:SetLocalText(self.cfg.nameId)
  self.needTimeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.cfg.time))
  self.startTime = UITimeManager:GetInstance():GetServerTime() - self.data.teamStartTime
  self.leaderHead:SetData(self.data.leaderMemberInfo.memberInfo)
  self.leaderNameText:SetText(DataCenter.ActGhostreconManager:GetTeamName(self.data.leaderMemberInfo.memberInfo.name))
  local joined = self.data:OwnIsJoined()
  for i = 1, 4 do
    if self.data.noLeaderMemberList and self.data.noLeaderMemberList[i] then
      self["playerHead" .. i]:SetData(self.data.noLeaderMemberList[i].memberInfo)
    elseif joined then
      self["playerHead" .. i]:SetEmpty()
    else
      self["playerHead" .. i]:SetEmpty()
      self["playerHead" .. i]:SetJoinActive(true)
      self["playerHead" .. i]:SetJoinFunc(Bind(self, self.OnJoinClick))
    end
  end
  if joined then
    self.bg:SetColorRGBA255(163, 227, 133, 255)
  else
    self.bg:SetColorRGBA255(255, 255, 255, 255)
  end
  self.buildBg:LoadSprite(UIAssets.GhostreconTexturePath .. self.cfg.imgSet.BuildBg)
  self.qualityImg:LoadSprite(self.cfg.imgSet.QualityImg)
  self.qualityImg:SetNativeSize()
  self.buildImg:LoadSprite(UIAssets.GhostreconTexturePath .. self.cfg.imgSet.BuildImg)
  local pos = SceneUtils.IndexToTilePos(self.data.pointId, ForceChangeScene.World)
  self.posText:SetText(string.format("#%s X:%s Y:%s", self.data.targetServer, pos.x, pos.y))
  self.lvText:SetLocalText(140205, self.cfg.level, "")
  self:RefreshHeroList()
  self:Update1000MS()
end

local function OnGhostreconAllianceTaskRefreshOne(self, uuid)
  if uuid and uuid == self.uuid then
    self:SetData(uuid)
  end
end

local function OnClickRewardBtn(self)
  local param = {}
  param.cfg = self.cfg
  param.width = 480
  param.alignObject = self.rewardBtn
  param.yPosFix = -20
  param.showArrow = true
  param.meetNums = param.cfg:GetSuperCondionNumsByMemberList(self.data.memberList)
  if not IsNull(self.rewardBtn) and not IsNull(self.rewardBtn.transform) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconGiftTip, {anim = true}, param)
  end
end

local function OnJoinClick(self)
  if self.uuid and DataCenter.ActGhostreconAllianceManager:GetAllianceTaskInfoByUUid(self.uuid) then
    if self.data then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconFormation, {anim = true}, self.uuid, true)
    end
  else
    UIUtil.ShowTipsId("ghostrecon_070")
    EventManager:GetInstance():Broadcast(EventId.GhostreconAllianceTaskRefresh)
  end
end

local function Update1000MS(self)
  if self.startTime and self.startTime > 0 then
    self.timeText:SetText(Localization:GetString("ghostrecon_008") .. UITimeManager:GetInstance():MilliSecondToFmtString(self.startTime))
    self.startTime = self.startTime + 1000
  end
end

local function RefreshHeroList(self)
  if self.cfg.superCondions and #self.cfg.superCondions > 0 then
    self.heroCellType = {}
    local heroDataList = DataCenter.HeroDataManager:GetAllHeroList()
    local usedHeroList = DataCenter.ActGhostreconManager:GetAllUsedHeroList()
    for i = 1, 2 do
      local heroCell = self["heroCell" .. i]
      local condition = self.cfg.superCondions[i]
      if condition then
        heroCell:SetData(condition.heroId)
        heroCell:SetActive(true)
        local heroData
        for key, value in pairs(heroDataList) do
          if value.heroId == condition.heroId then
            heroData = value
            break
          end
        end
        if heroData then
          if table.indexof(usedHeroList, heroData.heroId) then
            self.heroCellType[i] = HeroCellType.InTask
          elseif heroData.level < condition.level then
            self.heroCellType[i] = HeroCellType.UnderLevel
          elseif heroData.rank < condition.star then
            self.heroCellType[i] = HeroCellType.UnderStar
          else
            self.heroCellType[i] = HeroCellType.CanUse
          end
        else
          self.heroCellType[i] = HeroCellType.UnHave
        end
        CS.UIGray.SetGray(heroCell.transform, self.heroCellType[i] ~= HeroCellType.CanUse, true)
        self["heroCellBtn" .. i]:SetOnClick(Bind(self, self.OnClickHeroCell, i))
      else
        heroCell:SetActive(false)
      end
    end
  else
    for i = 1, 2 do
      self["heroCell" .. i]:SetActive(false)
    end
  end
end

local function OnClickHeroCell(self, index)
  if self.heroCellType and self.heroCellType[index] then
    UIUtil.ShowBubbleTips(Localization:GetString(self.heroCellType[index]), self["heroCell" .. index].transform.position, 20, -40, 0)
  end
end

UIGhostreconAllianceTaskItem.OnCreate = OnCreate
UIGhostreconAllianceTaskItem.OnDestroy = OnDestroy
UIGhostreconAllianceTaskItem.OnEnable = OnEnable
UIGhostreconAllianceTaskItem.OnDisable = OnDisable
UIGhostreconAllianceTaskItem.ComponentDefine = ComponentDefine
UIGhostreconAllianceTaskItem.ComponentDestroy = ComponentDestroy
UIGhostreconAllianceTaskItem.DataDefine = DataDefine
UIGhostreconAllianceTaskItem.DataDestroy = DataDestroy
UIGhostreconAllianceTaskItem.SetData = SetData
UIGhostreconAllianceTaskItem.OnClickRewardBtn = OnClickRewardBtn
UIGhostreconAllianceTaskItem.OnJoinClick = OnJoinClick
UIGhostreconAllianceTaskItem.Update1000MS = Update1000MS
UIGhostreconAllianceTaskItem.RefreshHeroList = RefreshHeroList
UIGhostreconAllianceTaskItem.OnClickHeroCell = OnClickHeroCell
UIGhostreconAllianceTaskItem.OnAddListener = OnAddListener
UIGhostreconAllianceTaskItem.OnRemoveListener = OnRemoveListener
UIGhostreconAllianceTaskItem.OnGhostreconAllianceTaskRefreshOne = OnGhostreconAllianceTaskRefreshOne
return UIGhostreconAllianceTaskItem
