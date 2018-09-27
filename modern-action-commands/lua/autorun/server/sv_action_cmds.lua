include("autorun/action_cmds_config.lua")

util.AddNetworkString("modern_action_cmd")
util.AddNetworkString("modern_timeout")

local timeout_players = {}

local function get_table_name(ply)
  return game.SinglePlayer() and ply:EntIndex() or ply:SteamID64()
end

local function player_on_timeout(player, command_n)
  if !timeout_players[command_n] then timeout_players[command_n] = {} end
  local m_p = get_table_name(player)

  for k,v in pairs(timeout_players[command_n]) do
    if (m_p == v) then return true end
  end

  return false
end

local function saved_val_on_timeout(saved_id, command_n)
  if !timeout_players[command_n] then timeout_players[command_n] = {} end

  for k,v in pairs(timeout_players[command_n]) do
    if (saved_id == v) then return true end
  end

  return false
end

local function handle_timeout(command_n, timeout_amt, player)
  if !timeout_players[command_n] then timeout_players[command_n] = {} end
  if (timeout_amt == 0) then return end
  local saved_sid = get_table_name(player)

  table.insert(timeout_players[command_n], saved_sid)

  timer.Simple(timeout_amt, function()
    if (player && IsValid(player) && player_on_timeout(player, command_n)) then
      table.RemoveByValue(timeout_players[command_n], get_table_name(player))
    elseif saved_val_on_timeout(saved_sid, timeout_players[command_n]) then
      table.RemoveByValue(timeout_players[command_n], saved_sid)
    end
  end)
end

local function command_exists_in_config(message_cmd)
  for k,v in pairs(modern_action_commands_config.commands_output) do
    if (message_cmd == "/"..v.command) then return true end
  end
end

local function find_action_tbl(message_cmd)
  for k, v in pairs(modern_action_commands_config.commands_output) do
    if (message_cmd == "/"..v.command) then return v end
  end
end

local function check_command(ply, text, public)
  if (command_exists_in_config(text)) then
    local action_tbl = find_action_tbl(text)
    action_tbl["player_name"] = ply:GetName()

    if (action_tbl["timeout_amount"] != 0 && player_on_timeout(ply, action_tbl["command"])) then
      net.Start("modern_timeout")
      net.WriteTable(action_tbl)
      net.Send(ply)
      if (modern_action_commands_config.hide_message) then return "" end
      return
    end

    handle_timeout(action_tbl["command"], action_tbl["timeout_amount"], ply)

    net.Start("modern_action_cmd")
    net.WriteTable(action_tbl)
    net.Broadcast()

    if (modern_action_commands_config.hide_message) then return "" end
  end
end
hook.Add("PlayerSay","modern_action_cmds",check_command)
