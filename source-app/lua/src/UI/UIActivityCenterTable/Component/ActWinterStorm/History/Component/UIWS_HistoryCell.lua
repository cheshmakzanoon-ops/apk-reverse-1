local UIWS_HistoryCell = BaseClass("UIWS_HistoryCell", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local UIWS_HistoryPlayer = require("UI.UIActivityCenterTable.Component.ActWinterStorm.History.Component.UIWS_HistoryPlayer")
local MyRand = math.random
local WIN_IMG_PATH = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
local LOSE_IMG_PATH = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_defeat.png"
local BASE_PJ_IMG_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_dongjifengbao_%s.png"
local TIPS_KEY = {
  "winter_battlefield_tips1054",
  "winter_battlefield_tips1055",
  "winter_battlefield_tips1056"
}

function UIWS_HistoryCell:OnCreate()
  base.OnCreate(self)
  self.bg_win = self:AddComponent(UIBaseComponent, "BgWin")
  self.bg_lose = self:AddComponent(UIBaseComponent, "BgLose")
  self.img_state = self:AddComponent(UIImage, "StateImg")
  self.text_time = self:AddComponent(UIText, "TimeText")
  self.img_mvp = self:AddComponent(UIImage, "MyInfo/MvpBtn/MvpImg")
  self.btn_mvp = self:AddComponent(UIButton, "MyInfo/MvpBtn")
  self.btn_mvp:SetOnClick(BindCallback(self, self.OnClickMvpBtn))
  self.icon = self:AddComponent(UIPlayerHead, "MyInfo/Head/UIPlayerHead/HeadIcon")
  local btn = self:AddComponent(UIButton, "MyInfo/Head/UIPlayerHead")
  btn:SetInteractable(false)
  self.text_name = self:AddComponent(UIText, "MyInfo/NameText")
  self.text_lv = self:AddComponent(UIText, "MyInfo/LvText")
  self.img_pj = self:AddComponent(UIImage, "MyInfo/PJImg")
  self.team = self:AddComponent(UIBaseComponent, "Team")
  self.items = {}
  for i = 1, 4 do
    table.insert(self.items, self:AddComponent(UIWS_HistoryPlayer, "Team/Player" .. i))
  end
  self.tips = self:AddComponent(UIBaseComponent, "Team/Tips")
  self.bubble = self:AddComponent(UIBaseComponent, "Team/Tips/bubble")
  self.text_tips = self:AddComponent(UIText, "Team/Tips/bubble/txtContent")
end

function UIWS_HistoryCell:OnDestroy()
  if self.timer ~= nil then
    self.timer:Stop()
  end
  self.timer = nil
  self.bg_win = nil
  self.bg_lose = nil
  self.img_state = nil
  self.text_time = nil
  self.img_mvp = nil
  self.btn_mvp = nil
  self.icon = nil
  self.text_name = nil
  self.text_lv = nil
  self.img_pj = nil
  self.team = nil
  self.items = {}
  self.tips = nil
  self.bubble = nil
  self.text_tips = nil
  base.OnDestroy(self)
end

function UIWS_HistoryCell:OnClickMvpBtn()
  if not string.IsNullOrEmpty(self.mvpDesc) then
    UIUtil.ShowBubbleTips(self.mvpDesc, self.btn_mvp.transform.position, 0, -30, 0)
  end
end

function UIWS_HistoryCell:ReInit(logData)
  self.logData = logData
  self:RefreshView()
end

function UIWS_HistoryCell:UpdateData()
  if self.logData == nil then
    return
  end
  local logData = self.logData
  local bWin = logData.isWin
  self.bg_win:SetActive(bWin)
  self.bg_lose:SetActive(not bWin)
  self.img_state:LoadSpriteAsyncWithCallback(bWin and WIN_IMG_PATH or LOSE_IMG_PATH, function()
    if self.img_state then
      self.img_state:SetNativeSize()
    end
  end)
  self.text_time:SetText(Localization:GetString("800811") .. UITimeManager:GetInstance():TimeStampToTimeForServerMinute(logData.time * 1000))
  local mvpId = logData.mvpId or 0
  local tbName = DataCenter.ActWinterStormManager:GetCfgValue(BattleFieldTableKey.STAR)
  local line = 0 < mvpId and LocalController:instance():getLine(tbName, mvpId) or nil
  if line then
    local icon = line:getValue("icon")
    self.img_mvp:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldMvpPath, icon), function()
      if self.img_mvp then
        self.img_mvp:SetNativeSize()
      end
    end)
    self.img_mvp:SetActive(true)
    self.mvpDesc = Localization:GetString(line:getValue("desc"), line:getValue("score"))
  else
    self.img_mvp:SetActive(false)
    self.mvpDesc = nil
  end
  local team = logData.team or {}
  local teamArr
  local myUid = LuaEntry.Player:GetUid()
  local cnt = 1
  for i = 1, 5 do
    local item = self.items[cnt]
    local v = team[i]
    if v then
      if v.uid == myUid then
        teamArr = v
      else
        if item then
          item:SetActive(true)
          item:ReInit(v)
        end
        cnt = cnt + 1
      end
    else
      if item then
        item:SetActive(false)
      end
      cnt = cnt + 1
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.team.transform)
  local score = 0
  if teamArr then
    self.icon:SetData(teamArr.uid, teamArr.head, teamArr.frame)
    local name = UIUtil.FormatAllianceAndName(teamArr.allianceName, teamArr.name)
    self.text_name:SetText(name)
    self.text_lv:SetLocalText(140002, teamArr.lv)
    score = teamArr.score or 0
  else
    self.icon:UseSystemHead()
    self.text_name:SetText("")
    self.text_lv:SetText("")
  end
  local path = self:GetPJPath(score)
  self.img_pj:LoadSpriteAsyncWithCallback(path, function()
    if self.img_pj then
      self.img_pj:SetNativeSize()
    end
  end)
  self:RandomShowTips()
end

function UIWS_HistoryCell:GetPJPath(score)
  local group = DataCenter.WinterStormTemplateManager:GetK30()
  local idx = 5
  for i, v in ipairs(group) do
    if v < score then
      idx = i
      break
    end
  end
  local key = ""
  if idx == 1 then
    key = "sss"
  elseif idx == 2 then
    key = "ss"
  elseif idx == 3 then
    key = "s"
  elseif idx == 4 then
    key = "a"
  elseif idx == 5 then
    key = "b"
  else
    key = "c"
  end
  return string.format(BASE_PJ_IMG_PATH, key)
end

function UIWS_HistoryCell:RandomShowTips()
  if self.timer ~= nil then
    return
  end
  local rand = MyRand(1, #self.items)
  local item = self.items[rand]
  if not item or not item:GetActive() then
    return
  end
  local x, y, z = item:GetLocalPositionXYZ()
  self.tips:SetLocalPositionXYZ(x, y + 60, z)
  x, y, z = self.bubble:GetLocalPositionXYZ()
  self.bubble:SetLocalPositionXYZ(rand < 3 and 90 or 0, y, z)
  rand = MyRand(1, #TIPS_KEY)
  self.text_tips:SetLocalText(TIPS_KEY[rand])
  self.tips:SetActive(true)
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.timer ~= nil then
      self.timer:Stop()
    end
    self.timer = nil
    self.tips:SetActive(false)
  end, 5)
end

return UIWS_HistoryCell
