local SetFriendsCircleSettingMessage = BaseClass("SetArenaDefenseArmyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, array)
  base.OnCreate(self)
  local number
  if array then
    local list = SFSArray.New()
    for i = 1, #array do
      list:AddInt(array[i])
    end
    self.sfsObj:PutSFSArray("friendsCircleSet", list)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.PlayerInfoDataManager:RefreshSelfPlayerData(t)
  end
end

SetFriendsCircleSettingMessage.OnCreate = OnCreate
SetFriendsCircleSettingMessage.HandleMessage = HandleMessage
return SetFriendsCircleSettingMessage
