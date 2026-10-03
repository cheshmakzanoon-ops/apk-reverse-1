local ShareDecode = require("Chat.Other.ShareDecode")
local ChatMessageHelper = require("Chat.Other.ChatMessageHelper")
local UIPositionShareConfirmCtrl = BaseClass("UIPositionShareConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPositionShareConfirm)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function getPreviewText(self, chat_data)
  if chat_data.param.post == PostType.Activity_BargainShop then
    return ""
  end
  return ShareDecode.Decode(chat_data, chat_data.param, true)
end

local function Confirm(self, chat_data, channel_data)
  if chat_data.post == PostType.Text_Formation_Share then
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    Setting:SetPrivateInt("FormationShareTime", serverTime)
  end
  if chat_data.post == PostType.MONSTER_INVASION_BOSS_SELF_PROTECTED then
    if channel_data and channel_data.group ~= ChatGroupType.GROUP_ALLIANCE and channel_data.group ~= ChatGroupType.GROUP_ALLIANCE_MANAGER and channel_data.group ~= ChatGroupType.GROUP_CUSTOM then
      SFSNetwork.SendMessage(MsgDefines.MonsterInvasionBossCanAttack, chat_data.param.uuid, chat_data.param.srcServer)
    elseif channel_data and channel_data.group == ChatGroupType.GROUP_CUSTOM then
      local find = false
      local all = DataCenter.AllianceMemberDataManager:GetAllMember()
      for key, value in pairs(channel_data.memberList) do
        if all[value] == nil then
          find = true
        end
      end
      if find then
        SFSNetwork.SendMessage(MsgDefines.MonsterInvasionBossCanAttack, chat_data.param.uuid, chat_data.param.srcServer)
      end
    end
  end
  if chat_data.post == PostType.MONSTER_INVASION_BOSS_SELF_PROTECTED then
    chat_data.post = PostType.INVASION_BOSS_SHARE
  end
  if chat_data.post == PostType.Activity_BargainShop then
  else
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chat_data)
  end
  self:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPositionShare)
end

UIPositionShareConfirmCtrl.CloseSelf = CloseSelf
UIPositionShareConfirmCtrl.Close = Close
UIPositionShareConfirmCtrl.getPreviewText = getPreviewText
UIPositionShareConfirmCtrl.Confirm = Confirm
return UIPositionShareConfirmCtrl
