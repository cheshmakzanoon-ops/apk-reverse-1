local UIChampionpropagandaView = BaseClass("UIChampionpropagandaView", UIBaseView)
local M = UIChampionpropagandaView
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function M:OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:ComponentDefine(self)
  self:RegisterUIEvent()
  self.maskBgBtn.enabled = false
  self.delayPosterInvoke = TimerManager:GetInstance():DelayInvoke(function()
    self.maskBgBtn.enabled = true
  end, 1.5)
  self:RefreshData()
end

function M:DataDefine(self)
end

function M:OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function M:ComponentDestroy(self)
  self:UnregisterUIEvent()
  if self.delayPosterInvoke ~= nil then
    self.delayPosterInvoke:Stop()
    self.delayPosterInvoke = nil
  end
end

function M:DataDestroy(self)
end

function M:RegisterUIEvent()
  self.maskBgBtn.onClick:AddListener(BindCallback(self, self.onClick_closeBtn))
end

function M:UnregisterUIEvent()
  self.maskBgBtn.onClick:RemoveAllListeners()
  Event:removeobserver(self)
end

function M:onClick_closeBtn()
  self.ctrl:CloseSelf()
end

function M:RefreshData()
  local championBattleInfo = DataCenter.ActChampionBattleManager:GetChampionBattleInfo()
  if championBattleInfo == nil then
    return
  end
  self.leftServerName.text = "#" .. championBattleInfo.serverId1
  self.rightServerName.text = "#" .. championBattleInfo.serverId2
  local params = self:getParams()
  local type = params.type
  local playerList = {}
  if params.data ~= nil then
    playerList = params.data
  end
  if type == ChampionBattlePosterType.Strongest_Eight then
    self.vs4:SetActiveEx(true)
    self.vs2:SetActiveEx(false)
    self.titleTxt.text = _lang("312003")
  elseif type == ChampionBattlePosterType.Strongest_Four then
    self.vs4:SetActiveEx(true)
    self.vs2:SetActiveEx(false)
    self.titleTxt.text = _lang("312004")
  elseif type == ChampionBattlePosterType.Strongest_Two then
    self.vs2:SetActiveEx(true)
    self.vs4:SetActiveEx(false)
    self.titleTxt.text = _lang("312005")
  end
  for i = 1, 4 do
    if i <= #playerList then
      local playerData = playerList[i]
      if playerData ~= nil then
        local player1 = championBattleInfo:GetPlayerMsgByUid(playerList[i].uid2)
        if player1 ~= nil then
          self["leftPlayer" .. i]:SetActiveEx(true)
          local abbr = " "
          if player1.abbr ~= nil then
            abbr = " [" .. player1.abbr .. "] "
          end
          self["leftplayerName" .. i].text = "#" .. player1.serverId .. abbr .. player1.name
        else
          self["leftPlayer" .. i]:SetActiveEx(false)
        end
        local player2 = championBattleInfo:GetPlayerMsgByUid(playerList[i].uid1)
        if player2 ~= nil then
          self["rightPlayer" .. i]:SetActiveEx(true)
          local abbr = " "
          if player2.abbr ~= nil then
            abbr = " [" .. player2.abbr .. "] "
          end
          self["rightplayerName" .. i].text = "#" .. player2.serverId .. abbr .. player2.name
        else
          self["rightPlayer" .. i]:SetActiveEx(false)
        end
      else
        self["leftPlayer" .. i]:SetActiveEx(false)
        self["rightPlayer" .. i]:SetActiveEx(false)
      end
    else
      self["leftPlayer" .. i]:SetActiveEx(false)
      self["rightPlayer" .. i]:SetActiveEx(false)
    end
  end
end

return M
