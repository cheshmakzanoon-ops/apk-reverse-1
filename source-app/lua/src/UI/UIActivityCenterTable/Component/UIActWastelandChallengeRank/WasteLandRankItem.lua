local WasteLandRankItem = BaseClass("WasteLandRankItem", UIBaseContainer)
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local valid_path = "valid"
local empty_path = "empty"
local score_path = "valid/score"
local alliance_path = "valid/nameArea/alliance"
local player_path = "valid/player"
local detail_btn_path = "valid/detailBtn"
local btn_time_path = "valid/btn_time"
local btn_box_path = "valid/btn_box"
local img_box_path = "valid/btn_box/img_box"
local alliance_item_path = "allianceItem"
local alliance_flag_path = "allianceItem/allianceFlag"
local medal_path = "medal"
local num_txt_path = "medal/numTxt"
local no_aliance_path = "noAliance"
local btn_alliance_path = "noAliance/btn_alliance"
local BOXICONSTRS = {
  [1] = "Assets/Main/Sprites/UI/LWOffSeason1/Recapture/lrb_zhouliuhuodong_baoxiangkai_05.png",
  [2] = "Assets/Main/Sprites/UI/LWOffSeason1/Recapture/lrb_zhouliuhuodong_baoxiangkai_04.png",
  [3] = "Assets/Main/Sprites/UI/LWOffSeason1/Recapture/lrb_zhouliuhuodong_baoxiangkai_03.png",
  [4] = "Assets/Main/Sprites/UI/LWOffSeason1/Recapture/lrb_zhouliuhuodong_baoxiangkai_02.png"
}

function WasteLandRankItem:OnCreate()
  base.OnCreate(self)
  self.valid = self:AddComponent(UIBaseContainer, valid_path)
  self.empty = self:AddComponent(UIBaseContainer, empty_path)
  self.score = self:AddComponent(UIText, score_path)
  self.alliance = self:AddComponent(UIText, alliance_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.detail_btn = self:AddComponent(UIButton, detail_btn_path)
  self.btn_time = self:AddComponent(UIButton, btn_time_path)
  self.btn_box = self:AddComponent(UIButton, btn_box_path)
  self.img_box = self:AddComponent(UIImage, img_box_path)
  self.medal = self:AddComponent(UIImage, medal_path)
  self.num_txt = self:AddComponent(UITextMeshProUGUIEx, num_txt_path)
  self.alliance_item = self:AddComponent(UIBaseContainer, alliance_item_path)
  self.alliance_flag = self:AddComponent(UIImage, alliance_flag_path)
  self.no_aliance = self:TryAddComponent(UIBaseContainer, no_aliance_path)
  self.btn_alliance = self:TryAddComponent(UIButton, btn_alliance_path)
  if self.btn_alliance then
    self.btn_alliance:SetOnClick(BindCallback(self, self.ClickAlliance))
  end
  self.detail_btn:SetOnClick(function()
    self:OnClick()
  end)
  self.btn_time:SetOnClick(BindCallback(self, self.ClickTime))
  self.btn_box:SetOnClick(BindCallback(self, self.ClickBox))
end

function WasteLandRankItem:OnDestroy()
  self.score = nil
  self.alliance = nil
  self.valid = nil
  self.empty = nil
  self.player = nil
  self.detail_btn = nil
  self.btn_time = nil
  self.btn_box = nil
  self.img_box = nil
  self.medal = nil
  self.num_txt = nil
  self.alliance_item = nil
  self.alliance_flag = nil
  self.no_aliance = nil
  self.btn_alliance = nil
  self.selfMode = nil
  base.OnDestroy(self)
end

function WasteLandRankItem:SetSelfMode()
  self.selfMode = true
end

function WasteLandRankItem:GetReward(rewardList, rank)
  local rankReward
  local rankIndex = -1
  if rank == 0 then
    return rankReward, rankIndex
  end
  for k, v in ipairs(rewardList) do
    if rank >= v.minRanking and rank <= v.maxRanking then
      rankReward = v.rewards
      rankIndex = k
      break
    end
  end
  return rankReward, rankIndex
end

function WasteLandRankItem:RefreshData(data, rankDes, type, serverValue, rewardList)
  self.showType = type
  if data == nil or data.rank == 0 then
    self.empty:SetActive(true)
    self.valid:SetActive(false)
    self.alliance_item:SetActive(false)
    self.data = nil
    if self.selfMode then
      self.medal:SetEnable(false)
      self.num_txt:SetText("-")
    end
    self:RefreshNoAlliance(type)
    return
  end
  self.data = data
  self.empty:SetActive(false)
  local rankIndex
  self.rankReward, rankIndex = self:GetReward(rewardList, data.rank)
  self.btn_box:SetActive(self.rankReward ~= nil)
  if self.selfMode then
    self.medal:SetEnable(false)
  end
  if self.rankReward ~= nil and self.selfMode then
    if 3 < rankIndex then
      rankIndex = 4
    end
    self.img_box:LoadSprite(BOXICONSTRS[rankIndex])
  end
  self.detail_btn:SetActive(true)
  if type == CommonActivityRankType.PERSONAL then
    self.valid:SetActive(true)
    self.alliance_item:SetActive(false)
    if self.no_aliance then
      self.no_aliance:SetActive(false)
    end
    local infoText = ""
    local abbr = ""
    if self.data.allianceAbbr and not string.IsNullOrEmpty(self.data.allianceAbbr) then
      abbr = "[" .. self.data.allianceAbbr .. "]"
    end
    abbr = "#" .. self.data.srcServer .. " " .. abbr
    infoText = abbr .. " " .. data.name
    self.alliance:SetText(infoText)
    self.score:SetText(rankDes .. data.score)
    if not data.isAlly then
      self.player:SetActive(true)
      if data.isSelf then
        local userPic = LuaEntry.Player:GetPic() or ""
        local userPicVer = LuaEntry.Player.picVer or 0
        self.player:SetData(LuaEntry.Player:GetUid(), userPic, userPicVer, nil, LuaEntry.Player:GetHeadBgImg())
      else
        local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET)
        self.player:SetData(data.uid, data.pic, data.picVer, nil, headFrame)
      end
    else
      self.player:SetActive(false)
    end
    self.num_txt:SetText(tostring(data.rank))
  else
    self.alliance_item:SetActive(true)
    self.valid:SetActive(true)
    self.player:SetActive(false)
    local abbr = UIUtil.FormatAllianceAndName(self.data.abbr, self.data.allianceName)
    abbr = "#" .. self.data.srcServer .. " " .. abbr
    self.alliance:SetText(abbr)
    self.score:SetText(rankDes .. self.data.score)
    self.num_txt:SetText(tostring(data.rank))
  end
  self:RefreshNoAlliance(type)
end

function WasteLandRankItem:RefreshNoAlliance(type)
  self.medal:SetActive(true)
  if self.selfMode and type == CommonActivityRankType.ALLINCE then
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    if self.no_aliance then
      self.no_aliance:SetActive(not hasAlliance)
    end
    self.medal:SetActive(hasAlliance)
    self.alliance_item:SetActive(hasAlliance and self.data ~= nil and self.data.rank ~= 0)
    self.valid:SetActive(hasAlliance and self.data ~= nil and self.data.rank ~= 0)
    self.empty:SetActive(hasAlliance and (self.data == nil or self.data.rank == 0))
  elseif self.selfMode and type == CommonActivityRankType.PERSONAL and self.no_aliance then
    self.no_aliance:SetActive(false)
  end
end

function WasteLandRankItem:OnPlayerDetailClick(serverId, playerUid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {serverId = serverId, uid = playerUid})
end

function WasteLandRankItem:ClickTime()
  if self.data then
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.TreasureBoxTimeTip)
    param.contentText = Localization:GetString("season_monster_activity_record_time")
    local time = UITimeManager:GetInstance():TimeStampToTimeForServerMinute(self.data.wasteland_time)
    param.contentText = param.contentText .. "\n" .. time
    param.alignObject = self.btn_time
    param.yPosFix = 30
    param.addPosX = 0 * CommonUtil.ArabicAutoMirrorFactor()
    param.showArrow = true
    param.preferTop = false
    param.unEnableTouchThrough = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActShowTextTipView, {anim = true}, param)
  end
end

function WasteLandRankItem:ClickBox()
  if self.rankReward ~= nil then
    local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
    param.position = self.img_box:GetPosition()
    param.deltaX = -60
    param.deltaY = 150
    if CommonUtil.IsArabicAutoMirrorOpen() then
      param.dir = UIPersonalArmsRewardTipView.Direction.LEFT
    else
      param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
    end
    param.rewardList = self.rankReward
    param.hideCount = true
    local theItemList = {}
    local sortOrder = -1
    for k, v in pairs(self.rankReward) do
      if v.itemId ~= nil and v.rewardType == RewardType.GOODS then
        local meta = DataCenter.ItemTemplateManager:TryGetItemTemplate(v.itemId)
        if meta ~= nil and meta.color then
          v.sortOrder = toInt(meta.color)
        else
          v.sortOrder = sortOrder
        end
      elseif v.itemId ~= nil and v.rewardType == RewardType.RESOURCE_ITEM then
        local meta = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(v.itemId)
        if meta ~= nil and meta.quality then
          v.sortOrder = toInt(meta.quality)
        else
          v.sortOrder = sortOrder
        end
      else
        v.sortOrder = sortOrder
      end
      table.insert(theItemList, v)
      sortOrder = sortOrder - 1
    end
    table.sort(theItemList, function(a, b)
      if a.sortOrder == b.sortOrder then
        return a.rewardType > b.rewardType
      end
      return a.sortOrder > b.sortOrder
    end)
    param.rewardList = theItemList
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
  end
end

function WasteLandRankItem:ClickAlliance()
  if LuaEntry.Player:IsFirstJoinAlliance() == true then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
  end
end

function WasteLandRankItem:OnClick()
  if self.showType == CommonActivityRankType.PERSONAL then
    if self.data then
      self:OnPlayerDetailClick(self.data.serverId, self.data.uid)
    end
  elseif self.data then
    UIUtil.TryShowAllianceInfo(self.data.srcServer, self.data.uid, self.data.allianceName)
  end
end

return WasteLandRankItem
